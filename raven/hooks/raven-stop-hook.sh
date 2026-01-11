#!/bin/bash

# Raven Stop Hook
# Implements autonomous loop functionality (Ralph-Wiggum style)
# Prevents session exit when a raven-loop is active

set -euo pipefail

# Read hook input from stdin (advanced stop hook API)
HOOK_INPUT=$(cat)

# State file location
RAVEN_LOOP_FILE=".claude/raven-loop.local.md"

# Check if raven-loop is active
if [[ ! -f "$RAVEN_LOOP_FILE" ]]; then
  # No active loop - allow exit
  exit 0
fi

# Parse markdown frontmatter (YAML between ---) and extract values
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$RAVEN_LOOP_FILE")
ITERATION=$(echo "$FRONTMATTER" | grep '^iteration:' | sed 's/iteration: *//' || echo "1")
MAX_ITERATIONS=$(echo "$FRONTMATTER" | grep '^max_iterations:' | sed 's/max_iterations: *//' || echo "0")
COMPLETION_PROMISE=$(echo "$FRONTMATTER" | grep '^completion_promise:' | sed 's/completion_promise: *//' | sed 's/^"\(.*\)"$/\1/' || echo "")
AGENT=$(echo "$FRONTMATTER" | grep '^agent:' | sed 's/agent: *//' || echo "raven-coding")
TASK_ID=$(echo "$FRONTMATTER" | grep '^task_id:' | sed 's/task_id: *//' || echo "unknown")

# Validate numeric fields
if [[ ! "$ITERATION" =~ ^[0-9]+$ ]]; then
  echo "Raven loop: Invalid iteration value, resetting" >&2
  ITERATION=1
fi

if [[ ! "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
  MAX_ITERATIONS=0
fi

# Check if max iterations reached
if [[ $MAX_ITERATIONS -gt 0 ]] && [[ $ITERATION -ge $MAX_ITERATIONS ]]; then
  echo "Raven loop: Max iterations ($MAX_ITERATIONS) reached for task '$TASK_ID'"
  rm "$RAVEN_LOOP_FILE"
  exit 0
fi

# Get transcript path from hook input
TRANSCRIPT_PATH=$(echo "$HOOK_INPUT" | jq -r '.transcript_path' 2>/dev/null || echo "")

if [[ -z "$TRANSCRIPT_PATH" ]] || [[ ! -f "$TRANSCRIPT_PATH" ]]; then
  echo "Raven loop: Transcript not found, stopping loop" >&2
  rm "$RAVEN_LOOP_FILE"
  exit 0
fi

# Read last assistant message from transcript (JSONL format)
if ! grep -q '"role":"assistant"' "$TRANSCRIPT_PATH" 2>/dev/null; then
  echo "Raven loop: No assistant messages in transcript" >&2
  rm "$RAVEN_LOOP_FILE"
  exit 0
fi

# Extract last assistant message
LAST_LINE=$(grep '"role":"assistant"' "$TRANSCRIPT_PATH" | tail -1)
if [[ -z "$LAST_LINE" ]]; then
  echo "Raven loop: Failed to extract assistant message" >&2
  rm "$RAVEN_LOOP_FILE"
  exit 0
fi

# Parse JSON to get text content
LAST_OUTPUT=$(echo "$LAST_LINE" | jq -r '
  .message.content |
  map(select(.type == "text")) |
  map(.text) |
  join("\n")
' 2>/dev/null || echo "")

if [[ -z "$LAST_OUTPUT" ]]; then
  echo "Raven loop: Empty assistant output" >&2
  rm "$RAVEN_LOOP_FILE"
  exit 0
fi

# Check for completion promise
if [[ -n "$COMPLETION_PROMISE" ]] && [[ "$COMPLETION_PROMISE" != "null" ]]; then
  # Extract text from <promise> tags
  PROMISE_TEXT=$(echo "$LAST_OUTPUT" | perl -0777 -pe 's/.*?<promise>(.*?)<\/promise>.*/$1/s; s/^\s+|\s+$//g; s/\s+/ /g' 2>/dev/null || echo "")

  if [[ -n "$PROMISE_TEXT" ]] && [[ "$PROMISE_TEXT" = "$COMPLETION_PROMISE" ]]; then
    echo "Raven loop: Task '$TASK_ID' completed - <promise>$COMPLETION_PROMISE</promise>"
    rm "$RAVEN_LOOP_FILE"
    exit 0
  fi
fi

# Not complete - continue loop with SAME PROMPT
NEXT_ITERATION=$((ITERATION + 1))

# Extract prompt (everything after the closing ---)
PROMPT_TEXT=$(awk '/^---$/{i++; next} i>=2' "$RAVEN_LOOP_FILE")

if [[ -z "$PROMPT_TEXT" ]]; then
  echo "Raven loop: No prompt found in state file" >&2
  rm "$RAVEN_LOOP_FILE"
  exit 0
fi

# Update iteration in frontmatter
TEMP_FILE="${RAVEN_LOOP_FILE}.tmp.$$"
sed "s/^iteration: .*/iteration: $NEXT_ITERATION/" "$RAVEN_LOOP_FILE" > "$TEMP_FILE"
mv "$TEMP_FILE" "$RAVEN_LOOP_FILE"

# Build system message
if [[ -n "$COMPLETION_PROMISE" ]] && [[ "$COMPLETION_PROMISE" != "null" ]]; then
  SYSTEM_MSG="Raven Loop iteration $NEXT_ITERATION/$MAX_ITERATIONS | Task: $TASK_ID | Complete: output <promise>$COMPLETION_PROMISE</promise>"
else
  SYSTEM_MSG="Raven Loop iteration $NEXT_ITERATION | Task: $TASK_ID | No completion promise - runs until max iterations"
fi

# Output JSON to block the stop and feed prompt back
jq -n \
  --arg prompt "$PROMPT_TEXT" \
  --arg msg "$SYSTEM_MSG" \
  '{
    "decision": "block",
    "reason": $prompt,
    "systemMessage": $msg
  }'

exit 0
