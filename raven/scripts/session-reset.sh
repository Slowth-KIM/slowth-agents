#!/bin/bash

# Raven Session Reset Script
# Clears working memory while preserving belief and decisions

set -euo pipefail

WORKING_FILE=".raven/state/memory/working.json"

# Check if there's an active session
if [[ -f "$WORKING_FILE" ]]; then
  SESSION_ID=$(jq -r '.session_id // empty' "$WORKING_FILE" 2>/dev/null || echo "")
  TASK_ID=$(jq -r '.task_id // empty' "$WORKING_FILE" 2>/dev/null || echo "")

  if [[ -n "$SESSION_ID" && "$SESSION_ID" != "null" ]]; then
    echo "Clearing session: $SESSION_ID (Task: $TASK_ID)"
  fi
fi

# Reset working.json to empty state
cat > "$WORKING_FILE" <<'EOF'
{
  "session_id": null,
  "agent": null,
  "task_id": null,
  "started_at": null,
  "last_activity": null,
  "plan": {
    "steps": [],
    "current_step": 0
  },
  "context": {
    "files_read": [],
    "files_modified": [],
    "key_findings": []
  },
  "notes": [],
  "handoff": null
}
EOF

echo ""
echo "Session reset complete."
echo "Belief state and decision history preserved."
echo ""
echo "To start a new session, use /raven:code or /raven:init"
