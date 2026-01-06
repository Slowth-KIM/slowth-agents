# Raven for OpenAI Codex CLI

Setup instructions for using Raven with OpenAI Codex CLI.

## Installation

### 1. Initialize Raven

```bash
# In your project directory
curl -sL https://raw.githubusercontent.com/Slowth-KIM/raven/main/tools/init-raven.sh | bash
```

### 2. Copy AGENTS.md

```bash
# Download Codex adapter
curl -sL https://raw.githubusercontent.com/Slowth-KIM/raven/main/adapters/codex/AGENTS.md -o AGENTS.md
```

Or manually copy from `adapters/codex/AGENTS.md` to your project root.

### 3. Start using

```bash
# Open Codex CLI
codex

# Use Raven agents
> raven gtd      # Task management
> raven init     # Create PRD
> raven code     # Implement
> raven test     # Verify
```

## How it works

Codex CLI reads `AGENTS.md` for custom instructions. The Raven AGENTS.md defines 4 specialized agents that activate based on keywords in your prompts.

## Agents

| Trigger | Agent | Function |
|---------|-------|----------|
| `raven gtd` | 📥 GTD | Task management |
| `raven init` | 🚀 Init | PRD creation |
| `raven code` | 💻 Coding | Implementation |
| `raven test` | 🧪 Tester | Verification |

## Directory Structure

After initialization:
```
your-project/
├── AGENTS.md           # Codex instructions (this adapter)
├── .raven/
│   ├── tasks/          # GTD task folders
│   ├── state/          # Project state
│   └── config.yaml     # Configuration
└── docs/prd/           # PRD documents (created by Init)
```

## Configuration

Edit `.raven/config.yaml`:
```yaml
user_name: "Your Name"
communication_language: "ko"  # or "en"
focus_limit: 3
```
