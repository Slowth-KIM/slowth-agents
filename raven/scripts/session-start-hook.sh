#!/bin/bash

# Raven Session Start Hook
# Automatically loads previous session state and prompts for resume

set -euo pipefail

# State file paths
WORKING_FILE=".raven/state/memory/working.json"
BELIEF_FILE=".raven/state/memory/belief.json"

# Ensure directories exist
mkdir -p .raven/state/memory/decisions
mkdir -p .raven/state/dialogue

# Initialize working.json if not exists
if [[ ! -f "$WORKING_FILE" ]]; then
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
fi

# Initialize belief.json if not exists
if [[ ! -f "$BELIEF_FILE" ]]; then
  cat > "$BELIEF_FILE" <<EOF
{
  "updated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "project": {
    "name": "unknown",
    "type": "unknown",
    "tech_stack": [],
    "structure_summary": ""
  },
  "codebase": {
    "key_files": [],
    "patterns": [],
    "conventions": []
  },
  "current_focus": {
    "task_id": null,
    "understanding": null,
    "blockers": []
  }
}
EOF
fi

# Check for active session
SESSION_ID=$(jq -r '.session_id // empty' "$WORKING_FILE" 2>/dev/null || echo "")

if [[ -n "$SESSION_ID" && "$SESSION_ID" != "null" ]]; then
  # Previous session exists
  TASK_ID=$(jq -r '.task_id // "unknown"' "$WORKING_FILE")
  AGENT=$(jq -r '.agent // "unknown"' "$WORKING_FILE")
  LAST_ACTIVITY=$(jq -r '.last_activity // "unknown"' "$WORKING_FILE")
  CURRENT_STEP=$(jq -r '.plan.current_step // 0' "$WORKING_FILE")
  TOTAL_STEPS=$(jq -r '.plan.steps | length' "$WORKING_FILE")

  # Get step summaries
  STEPS_SUMMARY=$(jq -r '.plan.steps | to_entries | map(
    if .value.status == "completed" then "  [x] \(.value.name)"
    elif .value.status == "in_progress" then "  [>] \(.value.name) (current)"
    else "  [ ] \(.value.name)"
    end
  ) | join("\n")' "$WORKING_FILE" 2>/dev/null || echo "  No steps recorded")

  cat <<EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂 Previous Session Found
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Task: $TASK_ID
Agent: $AGENT
Last Activity: $LAST_ACTIVITY
Progress: Step $CURRENT_STEP of $TOTAL_STEPS

Plan:
$STEPS_SUMMARY

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
To resume: Continue working on this task
To start fresh: Run /raven:session-reset
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
else
  # No active session - just confirm state files are ready
  echo "Raven session initialized. State files ready."
fi
