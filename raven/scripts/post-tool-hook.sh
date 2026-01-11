#!/bin/bash

# Raven PostToolUse Hook
# Automatically tracks file modifications in working memory

set -euo pipefail

# Read hook input from stdin
HOOK_INPUT=$(cat)

# State file path
WORKING_FILE=".raven/state/memory/working.json"

# Only process if working file exists and has active session
if [[ ! -f "$WORKING_FILE" ]]; then
  exit 0
fi

SESSION_ID=$(jq -r '.session_id // empty' "$WORKING_FILE" 2>/dev/null || echo "")
if [[ -z "$SESSION_ID" || "$SESSION_ID" == "null" ]]; then
  exit 0
fi

# Extract tool info from hook input
TOOL_NAME=$(echo "$HOOK_INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
TOOL_INPUT=$(echo "$HOOK_INPUT" | jq -r '.tool_input // empty' 2>/dev/null || echo "")

# Track file modifications
track_file() {
  local file_path="$1"
  local array_name="$2"

  if [[ -z "$file_path" ]]; then
    return
  fi

  # Check if file is already in the array
  local exists=$(jq -r --arg path "$file_path" \
    ".context.${array_name} | index(\$path) // empty" "$WORKING_FILE" 2>/dev/null || echo "")

  if [[ -z "$exists" ]]; then
    # Add file to array and update timestamp
    TEMP_FILE="${WORKING_FILE}.tmp.$$"
    jq --arg path "$file_path" \
       --arg time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
       ".context.${array_name} += [\$path] | .last_activity = \$time" \
       "$WORKING_FILE" > "$TEMP_FILE" 2>/dev/null && \
    mv "$TEMP_FILE" "$WORKING_FILE"
  fi
}

case "$TOOL_NAME" in
  "Edit"|"Write"|"NotebookEdit")
    # Track modified files
    FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty' 2>/dev/null || echo "")
    if [[ -z "$FILE_PATH" ]]; then
      FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.notebook_path // empty' 2>/dev/null || echo "")
    fi
    track_file "$FILE_PATH" "files_modified"
    ;;

  "Read"|"NotebookRead")
    # Track read files
    FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty' 2>/dev/null || echo "")
    if [[ -z "$FILE_PATH" ]]; then
      FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.notebook_path // empty' 2>/dev/null || echo "")
    fi
    track_file "$FILE_PATH" "files_read"
    ;;
esac

exit 0
