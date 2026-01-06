# Raven MVP - Ralph Loop Prompt

## Mission

Create Codex and Cursor adapters for Raven framework.

## Completed

- ✅ Phase 1: GTD Agent + init script
- ✅ Phase 2: Init, Coding, Tester agents
- ✅ README.md + plugin.json

## Current Focus: Phase 3 - Multi-Platform Adapters

Create adapters so Raven works with Codex and Cursor.

### 1. Codex Adapter → `adapters/codex/`

Create `adapters/codex/AGENTS.md`:
- OpenAI Codex CLI uses AGENTS.md for instructions
- Convert the 4 Raven agents to Codex format
- Include GTD workflow, task management commands
- Reference .raven/ directory structure
- Korean + English support

### 2. Cursor Adapter → `adapters/cursor/`

Create `adapters/cursor/.cursorrules`:
- Cursor uses .cursorrules for project-specific AI behavior
- Convert Raven agents to Cursor rules format
- Include all 4 agents (GTD, Init, Coding, Tester)
- Task management workflow
- Session persistence patterns

### 3. Shared Core

Create `adapters/shared/raven-core.md`:
- Common instructions that work across platforms
- GTD workflow definition
- Task file format specification
- Handoff protocol

### 4. Installation Script

Update `tools/init-raven.sh` to:
- Detect platform (Claude Code / Codex / Cursor)
- Copy appropriate adapter files
- Or create `tools/install-adapters.sh` for manual selection

## Output Requirements

Files to create:
```
adapters/
├── codex/
│   ├── AGENTS.md          # Main Codex instructions
│   └── README.md          # Codex-specific setup
├── cursor/
│   ├── .cursorrules       # Cursor rules file
│   └── README.md          # Cursor-specific setup
└── shared/
    └── raven-core.md      # Shared core instructions
```

## Completion Criteria

Output this promise when adapters are complete:

```
<promise>RAVEN PHASE 3 ADAPTERS COMPLETE</promise>
```

## Reference

- `.claude/agents/raven-*.md` - Source agent definitions
- `helpers.md` - Shared utilities
- Keep the same GTD philosophy across platforms
