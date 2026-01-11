#!/bin/bash

# Raven Security Hook
# PreToolUse hook for detecting and blocking dangerous patterns
# Checks Bash commands and file modifications

set -euo pipefail

# Read hook input from stdin
HOOK_INPUT=$(cat)

# Extract tool name and input
TOOL_NAME=$(echo "$HOOK_INPUT" | jq -r '.tool_name' 2>/dev/null || echo "")
TOOL_INPUT=$(echo "$HOOK_INPUT" | jq -r '.tool_input' 2>/dev/null || echo "{}")

# Security rules file (optional override)
SECURITY_RULES_FILE=".claude/raven-security.local.md"

# Default blocked patterns (Critical - always block)
BLOCKED_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \$HOME"
  ":(){ :|:& };:"
  "chmod -R 777 /"
  "git push --force origin main"
  "git push -f origin main"
  "git push --force origin master"
  "git push -f origin master"
  "> /dev/sda"
  "mkfs."
  "dd if=/dev/zero"
)

# Default confirm patterns (Warning - log and allow)
CONFIRM_PATTERNS=(
  "rm -rf"
  "git push --force"
  "git push -f"
  "git reset --hard"
  "npm publish"
  "docker system prune"
  "DROP TABLE"
  "DROP DATABASE"
  "TRUNCATE"
)

# Protected file patterns
PROTECTED_FILES=(
  ".env"
  ".env.local"
  ".env.production"
  "*.pem"
  "*.key"
  "*credentials*"
  "*secret*"
  "id_rsa"
  "id_ed25519"
)

# Function to check if command matches blocked patterns
check_blocked() {
  local cmd="$1"
  for pattern in "${BLOCKED_PATTERNS[@]}"; do
    if [[ "$cmd" == *"$pattern"* ]]; then
      echo "$pattern"
      return 0
    fi
  done
  return 1
}

# Function to check if command matches confirm patterns
check_confirm() {
  local cmd="$1"
  for pattern in "${CONFIRM_PATTERNS[@]}"; do
    if [[ "$cmd" == *"$pattern"* ]]; then
      echo "$pattern"
      return 0
    fi
  done
  return 1
}

# Function to check if file path matches protected patterns
check_protected_file() {
  local filepath="$1"
  local filename=$(basename "$filepath")

  for pattern in "${PROTECTED_FILES[@]}"; do
    # Check exact match or glob pattern
    if [[ "$filename" == $pattern ]] || [[ "$filepath" == *"$pattern"* ]]; then
      echo "$pattern"
      return 0
    fi
  done
  return 1
}

# Function to log security events
log_security_event() {
  local event_type="$1"
  local tool="$2"
  local detail="$3"
  local log_file=".claude/security-log.local.md"

  # Create log file if not exists
  if [[ ! -f "$log_file" ]]; then
    echo "# Raven Security Log" > "$log_file"
    echo "" >> "$log_file"
  fi

  # Append log entry
  echo "## $(date -Iseconds) | $event_type" >> "$log_file"
  echo "- Tool: $tool" >> "$log_file"
  echo "- Detail: $detail" >> "$log_file"
  echo "" >> "$log_file"
}

# Handle Bash tool
if [[ "$TOOL_NAME" == "Bash" ]]; then
  COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command' 2>/dev/null || echo "")

  if [[ -z "$COMMAND" ]]; then
    # No command, allow
    echo '{"decision": "allow"}'
    exit 0
  fi

  # Check blocked patterns
  if blocked_match=$(check_blocked "$COMMAND"); then
    log_security_event "BLOCKED" "Bash" "Pattern: $blocked_match | Command: $COMMAND"
    jq -n \
      --arg reason "BLOCKED: Command matches dangerous pattern '$blocked_match'. This command is not allowed for safety reasons." \
      '{"decision": "block", "reason": $reason}'
    exit 0
  fi

  # Check confirm patterns (log warning but allow)
  if confirm_match=$(check_confirm "$COMMAND"); then
    log_security_event "WARNING" "Bash" "Pattern: $confirm_match | Command: $COMMAND"
    # Allow but log - user can check security-log.local.md
    echo '{"decision": "allow"}'
    exit 0
  fi

  # Allow
  echo '{"decision": "allow"}'
  exit 0
fi

# Handle Edit/Write tools
if [[ "$TOOL_NAME" == "Edit" ]] || [[ "$TOOL_NAME" == "Write" ]]; then
  FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path' 2>/dev/null || echo "")

  if [[ -z "$FILE_PATH" ]]; then
    echo '{"decision": "allow"}'
    exit 0
  fi

  # Check protected files
  if protected_match=$(check_protected_file "$FILE_PATH"); then
    log_security_event "BLOCKED" "$TOOL_NAME" "Protected file pattern: $protected_match | Path: $FILE_PATH"
    jq -n \
      --arg reason "BLOCKED: Cannot modify protected file matching '$protected_match'. This file contains sensitive information." \
      '{"decision": "block", "reason": $reason}'
    exit 0
  fi

  # Allow
  echo '{"decision": "allow"}'
  exit 0
fi

# Unknown tool - allow
echo '{"decision": "allow"}'
exit 0
