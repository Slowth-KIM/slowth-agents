#!/bin/bash

# Raven Session Init Script
# Initializes a new session in working memory
# Called by agents when starting a new task

set -euo pipefail

WORKING_FILE=".raven/state/memory/working.json"

# Parse arguments
TASK_ID=""
AGENT="raven-coding"

while [[ $# -gt 0 ]]; do
  case $1 in
    --task)
      TASK_ID="$2"
      shift 2
      ;;
    --agent)
      AGENT="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# Generate session ID
SESSION_ID="session-$(date +%Y%m%d-%H%M%S)-$$"

# Generate task ID if not provided
if [[ -z "$TASK_ID" ]]; then
  TASK_ID="task-$(date +%Y%m%d-%H%M%S)"
fi

# Ensure directory exists
mkdir -p "$(dirname "$WORKING_FILE")"

# Create/update working.json
NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)

cat > "$WORKING_FILE" <<EOF
{
  "session_id": "$SESSION_ID",
  "agent": "$AGENT",
  "task_id": "$TASK_ID",
  "started_at": "$NOW",
  "last_activity": "$NOW",
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

cat <<EOF
Session initialized:
  ID: $SESSION_ID
  Task: $TASK_ID
  Agent: $AGENT
  Started: $NOW
EOF
