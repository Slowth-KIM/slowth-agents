# Raven for Cursor

Setup instructions for using Raven with Cursor IDE.

## Installation

### 1. Initialize Raven

```bash
# In your project directory
curl -sL https://raw.githubusercontent.com/Slowth-KIM/raven/main/tools/init-raven.sh | bash
```

### 2. Copy .cursorrules

```bash
# Download Cursor adapter
curl -sL https://raw.githubusercontent.com/Slowth-KIM/raven/main/adapters/cursor/.cursorrules -o .cursorrules
```

Or manually copy from `adapters/cursor/.cursorrules` to your project root.

### 3. Restart Cursor

Cursor reads `.cursorrules` on startup. Restart to load Raven rules.

### 4. Start using

In Cursor's AI chat:
```
> raven gtd      # Task management
> raven init     # Create PRD
> raven code     # Implement
> raven test     # Verify
```

## How it works

Cursor reads `.cursorrules` for project-specific AI behavior. The Raven rules file defines 4 specialized agents that activate based on keywords.

## Agents

| Trigger | Agent | Function |
|---------|-------|----------|
| `raven gtd` | 📥 GTD | Task management |
| `raven init` | 🚀 Init | PRD creation |
| `raven code` | 💻 Coding | Implementation |
| `raven test` | 🧪 Tester | Verification |

## Directory Structure

After installation:
```
your-project/
├── .cursorrules        # Cursor rules (this adapter)
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

## Tips

- Use Cursor's Composer (Cmd+I) for multi-file operations
- The AI will automatically detect Raven context
- Korean language is supported by default
