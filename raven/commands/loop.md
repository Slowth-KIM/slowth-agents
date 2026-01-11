---
description: "Start autonomous loop - Ralph-Wiggum style"
argument-hint: "PROMPT [--max N] [--promise TEXT] [--task ID]"
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/scripts/setup-raven-loop.sh:*)"]
---

# Raven Loop Command

Execute the setup script to initialize the autonomous loop:

```!
"${CLAUDE_PLUGIN_ROOT}/scripts/setup-raven-loop.sh" $ARGUMENTS
```

Please work on the task. When you try to exit, the Raven loop will feed the SAME PROMPT back to you for the next iteration. You'll see your previous work in files and git history, allowing you to iterate and improve.

CRITICAL RULE: If a completion promise is set, you may ONLY output it when the statement is completely and unequivocally TRUE. Do not output false promises to escape the loop, even if you think you're stuck or should exit for other reasons. The loop is designed to continue until genuine completion.
