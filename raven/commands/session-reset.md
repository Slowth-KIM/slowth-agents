---
description: "Reset session state and start fresh"
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/scripts/session-reset.sh:*)"]
---

# Raven Session Reset

Reset the current session state and start fresh:

```!
"${CLAUDE_PLUGIN_ROOT}/scripts/session-reset.sh"
```

This clears the working memory without losing belief state or decision history.
