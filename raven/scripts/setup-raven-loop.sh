#!/bin/bash

# Raven Loop Setup Script
# Creates state file for in-session autonomous loop (Ralph-Wiggum style)

set -euo pipefail

# Parse arguments
PROMPT_PARTS=()
MAX_ITERATIONS=30
COMPLETION_PROMISE="COMPLETE"
TASK_ID=""
AGENT="raven-coding"

# Parse options and positional arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      cat << 'HELP_EOF'
Raven Loop - Autonomous self-referential development loop

USAGE:
  /raven:loop [PROMPT...] [OPTIONS]

ARGUMENTS:
  PROMPT...    Task description to work on (can be multiple words)

OPTIONS:
  --max <n>              Maximum iterations before auto-stop (default: 30)
  --promise '<text>'     Completion promise phrase (default: COMPLETE)
  --task '<id>'          Task ID for tracking (default: auto-generated)
  --agent '<name>'       Agent to use (default: raven-coding)
  -h, --help             Show this help message

DESCRIPTION:
  Starts an autonomous loop in your CURRENT session. The stop hook prevents
  exit and feeds your output back as input until completion or iteration limit.

  To signal completion, output: <promise>YOUR_PHRASE</promise>

EXAMPLES:
  /raven:loop Build a REST API with tests --promise 'DONE'
  /raven:loop --max 20 Fix the auth bug
  /raven:loop Implement user authentication --task auth-feature

STOPPING:
  - Output <promise>COMPLETE</promise> (or your custom promise)
  - Reach --max iterations
  - Run /raven:cancel-loop

MONITORING:
  head -10 .claude/raven-loop.local.md
HELP_EOF
      exit 0
      ;;
    --max|--max-iterations)
      if [[ -z "${2:-}" ]] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "Error: --max requires a positive integer" >&2
        exit 1
      fi
      MAX_ITERATIONS="$2"
      shift 2
      ;;
    --promise|--completion-promise)
      if [[ -z "${2:-}" ]]; then
        echo "Error: --promise requires a text argument" >&2
        exit 1
      fi
      COMPLETION_PROMISE="$2"
      shift 2
      ;;
    --task)
      if [[ -z "${2:-}" ]]; then
        echo "Error: --task requires an ID" >&2
        exit 1
      fi
      TASK_ID="$2"
      shift 2
      ;;
    --agent)
      if [[ -z "${2:-}" ]]; then
        echo "Error: --agent requires a name" >&2
        exit 1
      fi
      AGENT="$2"
      shift 2
      ;;
    *)
      PROMPT_PARTS+=("$1")
      shift
      ;;
  esac
done

# Join prompt parts
PROMPT="${PROMPT_PARTS[*]:-}"

# Validate prompt
if [[ -z "$PROMPT" ]]; then
  echo "Error: No prompt provided" >&2
  echo "" >&2
  echo "Examples:" >&2
  echo "  /raven:loop Build a REST API with CRUD operations" >&2
  echo "  /raven:loop Fix the authentication bug --max 20" >&2
  echo "" >&2
  echo "For help: /raven:loop --help" >&2
  exit 1
fi

# Generate task ID if not provided
if [[ -z "$TASK_ID" ]]; then
  TASK_ID="loop-$(date +%Y%m%d-%H%M%S)"
fi

# Create state directory
mkdir -p .claude

# Quote completion promise for YAML
COMPLETION_PROMISE_YAML="\"$COMPLETION_PROMISE\""

# Create state file
cat > .claude/raven-loop.local.md <<EOF
---
active: true
iteration: 1
max_iterations: $MAX_ITERATIONS
completion_promise: $COMPLETION_PROMISE_YAML
agent: $AGENT
task_id: $TASK_ID
started_at: "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
---

$PROMPT

---

## Completion Criteria

When the task is FULLY complete, output:

<promise>$COMPLETION_PROMISE</promise>

CRITICAL: Only output the promise when the statement is TRUE.
Do NOT lie to exit the loop.
EOF

# Output setup message
cat <<EOF
Raven Loop activated!

Task ID: $TASK_ID
Agent: $AGENT
Iteration: 1 / $MAX_ITERATIONS
Completion: <promise>$COMPLETION_PROMISE</promise>

The stop hook is now active. When you try to exit, the SAME PROMPT
will be fed back to you for the next iteration.

---

$PROMPT

---

To complete: output <promise>$COMPLETION_PROMISE</promise> when done.
To cancel: /raven:cancel-loop
To monitor: head -10 .claude/raven-loop.local.md
EOF
