# slowth-agents

> A collection of AI agents for Claude Code

## Available Plugins

| Plugin | Description | Status |
|--------|-------------|--------|
| [raven](./raven) | GTD-based autonomous coding framework | Active |

## Installation

```bash
# Add marketplace
/plugin marketplace add Slowth-KIM/slowth-agents

# Install plugins
/plugin install raven@slowth-agents
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
├── raven/
│   └── .claude/plugin.json
├── new-plugin/
│   └── .claude/plugin.json
└── README.md
```

## License

MIT
