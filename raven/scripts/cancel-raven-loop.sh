#!/bin/bash

# Raven Loop Cancel Script
# Cancels the active autonomous loop

set -euo pipefail

LOOP_FILE=".claude/raven-loop.local.md"

if [[ ! -f "$LOOP_FILE" ]]; then
  echo "No active Raven loop found."
  echo ""
  echo "The loop state file does not exist:"
  echo "  $LOOP_FILE"
  exit 0
fi

# Read current state
echo "Cancelling Raven loop..."
echo ""

# Parse frontmatter
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$LOOP_FILE")
ITERATION=$(echo "$FRONTMATTER" | grep '^iteration:' | sed 's/iteration: *//' || echo "?")
TASK_ID=$(echo "$FRONTMATTER" | grep '^task_id:' | sed 's/task_id: *//' || echo "?")
STARTED_AT=$(echo "$FRONTMATTER" | grep '^started_at:' | sed 's/started_at: *//' | tr -d '"' || echo "?")

echo "Loop Statistics:"
echo "  Task ID: $TASK_ID"
echo "  Iterations completed: $ITERATION"
echo "  Started at: $STARTED_AT"
echo ""

# Remove state file
rm "$LOOP_FILE"

echo "Raven loop cancelled successfully."
echo ""
echo "The stop hook will no longer intercept session exit."
