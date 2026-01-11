#!/bin/bash

# Raven Session Update Script
# Updates working memory with plan steps, notes, or findings

set -euo pipefail

WORKING_FILE=".raven/state/memory/working.json"

if [[ ! -f "$WORKING_FILE" ]]; then
  echo "Error: No active session. Run session-init first." >&2
  exit 1
fi

# Parse arguments
ACTION=""
VALUE=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --add-step)
      ACTION="add_step"
      VALUE="$2"
      shift 2
      ;;
    --complete-step)
      ACTION="complete_step"
      VALUE="$2"
      shift 2
      ;;
    --add-note)
      ACTION="add_note"
      VALUE="$2"
      shift 2
      ;;
    --add-finding)
      ACTION="add_finding"
      VALUE="$2"
      shift 2
      ;;
    --set-current-step)
      ACTION="set_current"
      VALUE="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)
TEMP_FILE="${WORKING_FILE}.tmp.$$"

case "$ACTION" in
  "add_step")
    # Add a new step to the plan
    STEP_COUNT=$(jq '.plan.steps | length' "$WORKING_FILE")
    jq --arg name "$VALUE" \
       --arg time "$NOW" \
       --argjson id "$((STEP_COUNT + 1))" \
       '.plan.steps += [{"id": $id, "name": $name, "status": "pending"}] | .last_activity = $time' \
       "$WORKING_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$WORKING_FILE"
    echo "Added step: $VALUE"
    ;;

  "complete_step")
    # Mark a step as completed (by id or current)
    if [[ "$VALUE" == "current" ]]; then
      STEP_ID=$(jq '.plan.current_step' "$WORKING_FILE")
    else
      STEP_ID="$VALUE"
    fi
    jq --argjson id "$STEP_ID" \
       --arg time "$NOW" \
       '(.plan.steps[] | select(.id == $id)).status = "completed" | .last_activity = $time' \
       "$WORKING_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$WORKING_FILE"
    echo "Completed step $STEP_ID"
    ;;

  "add_note")
    jq --arg note "$VALUE" \
       --arg time "$NOW" \
       '.notes += [$note] | .last_activity = $time' \
       "$WORKING_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$WORKING_FILE"
    echo "Added note"
    ;;

  "add_finding")
    jq --arg finding "$VALUE" \
       --arg time "$NOW" \
       '.context.key_findings += [$finding] | .last_activity = $time' \
       "$WORKING_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$WORKING_FILE"
    echo "Added finding"
    ;;

  "set_current")
    jq --argjson step "$VALUE" \
       --arg time "$NOW" \
       '.plan.current_step = $step | (.plan.steps[] | select(.id == $step)).status = "in_progress" | .last_activity = $time' \
       "$WORKING_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$WORKING_FILE"
    echo "Set current step to $VALUE"
    ;;

  *)
    echo "Usage: session-update.sh [--add-step NAME] [--complete-step ID|current] [--add-note TEXT] [--add-finding TEXT] [--set-current-step ID]"
    exit 1
    ;;
esac
