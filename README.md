# slowth-agents

> A collection of AI agents for Claude Code

## Available Plugins

| Plugin | Description | Status |
|--------|-------------|--------|
| [raven](./raven) | GTD-based autonomous coding framework | Active |

## Installation

In Claude Code, run:

```bash
# 1. Add marketplace
/plugin marketplace add Slowth-KIM/slowth-agents

# 2. Install plugin
/plugin install raven@slowth-agents
```

### Updating

```bash
/plugin marketplace update slowth-agents
/plugin update raven@slowth-agents
```

## Plugins

### Raven

GTD-based autonomous coding with specialized AI agents.

**Features:**
- GTD Task Manager (capture, clarify, organize)
- Context Engineer (PRD creation)
- Developer (feature implementation)
- QA Engineer (verification)

[Learn more](./raven/README.md)

---

## Adding New Plugins

Create a new folder with `.claude/plugin.json`:

```
slowth-agents/
├── .claude-plugin/
│   └── marketplace.json
├── raven/
│   └── .claude/plugin.json
├── new-plugin/
│   └── .claude/plugin.json
└── README.md
```

## Marketplace Setup

To register a repository as a marketplace, create `.claude-plugin/marketplace.json`:

```json
{
  "$schema": "https://claude.ai/schemas/marketplace.json",
  "name": "slowth-agents",
  "owner": {
    "name": "Slowth-KIM",
    "url": "https://github.com/Slowth-KIM"
  },
  "displayName": "Slowth Agents",
  "description": "A collection of AI agents for Claude Code",
  "repository": "https://github.com/Slowth-KIM/slowth-agents",
  "plugins": [
    {
      "name": "raven",
      "source": "./raven/.claude",
      "description": "GTD-based autonomous coding with specialized AI agents"
    }
  ]
}
```

## License

MIT
