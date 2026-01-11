# Raven - AI Agent Framework

> 🪶 *"Nevermore shall you code alone"*

## Installed Skills & Plugins

프로젝트에 설치된 skills와 plugins를 먼저 확인하세요:

```bash
# 설치된 skills 조회
ls -la .claude/skills/

# 설치된 agents 조회
ls -la .claude/agents/

# 설치된 commands 조회
ls -la .claude/commands/

# plugin.json 확인
cat .claude/plugin.json
```

### Available Skills

| Skill | 설명 |
|-------|------|
| `memory-helpers` | BMAD 스타일 에이전트 메모리 관리 |
| `raven-code` | Coding Agent 구현 프로세스 |
| `raven-gtd` | GTD Agent 태스크 관리 프로세스 |
| `raven-init` | Init Agent PRD 생성 프로세스 |
| `raven-test` | Tester Agent 검증 프로세스 |
| `prompt-engineering-patterns` | 프롬프트 엔지니어링 패턴 및 기법 |

### Available Agents

| Agent | 호출 | 설명 |
|-------|------|------|
| `raven-gtd` | `/raven:gtd` | GTD 태스크 매니저 |
| `raven-init` | `/raven:init` | Context Engineer + PRD 생성 |
| `raven-coding` | `/raven:code` | Senior Developer |
| `raven-tester` | `/raven:test` | QA Engineer |

---

## Overview

**Raven** is an open-source AI agent framework that enables autonomous coding through interactive conversations. Built on top of Claude Code, it provides structured agents that can manage tasks, understand requirements, implement features, and verify code — all while keeping users in the loop.

### Philosophy

- **Interactive Autonomy**: Agents work autonomously but keep users in control
- **GTD-Driven Workflow**: Capture → Clarify → Organize → Execute
- **PRD-Based Development**: Clear requirements lead to quality code
- **Session Resilience**: Pause anytime, resume seamlessly
- **Zero API Cost**: Uses Claude Code directly, no separate API key needed

## Tech Stack

| Category | Technology |
|----------|------------|
| Runtime | Bun |
| Language | TypeScript |
| Agent Format | YAML → Markdown (compiled) |
| State | JSON + Markdown files |
| CLI | Commander.js + Inquirer.js |

## Architecture

### Agent System

```
src/agents/*.yaml  →  compile  →  .raven/agents/*.md
   (definitions)      (bun run build)    (runtime agents)
```

### Core Agents

| Agent | Icon | Role | Responsibility |
|-------|------|------|----------------|
| **GTD** | 📥 | Task Manager | Task capture, clarification, prioritization |
| **Init** | 🚀 | Context Engineer | PRD creation, requirement analysis |
| **Coding** | 💻 | Developer | Feature implementation, commits |
| **Tester** | 🧪 | QA Engineer | Test execution, verification |

### Agent Workflow

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│   📥 GTD          🚀 Init         💻 Coding       🧪 Tester    │
│   ─────────       ──────────      ───────────     ──────────   │
│   Capture         Analyze         Implement       Verify       │
│   Clarify         Create PRD      Code            Test         │
│   Prioritize      Define scope    Commit          Report       │
│                                                                │
│        │              │               │               │        │
│        ▼              ▼               ▼               ▼        │
│   ┌────────┐    ┌──────────┐    ┌──────────┐    ┌────────┐    │
│   │ inbox  │ → │   next   │ → │  doing   │ → │  done  │     │
│   │ someday│    │ (ready)  │    │ (active) │    │(archive)│    │
│   └────────┘    └──────────┘    └──────────┘    └────────┘    │
│                                                                │
│   ←──────────── Agents can hand off freely ────────────────→   │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### GTD Task Management

Inspired by **Getting Things Done** and **Things app**:

```
.raven/tasks/
├── inbox/           # 📥 Raw ideas, bugs, features
│   └── *.md
├── focus/           # 🎯 Current session (1-3 tasks max)
│   └── *.md
├── next/            # 📋 Ready to work (PRD complete)
│   └── *.md
├── someday/         # 💭 Future ideas (icebox)
│   └── *.md
└── done/            # ✅ Completed (archive)
    └── *.md
```

#### Task File Format

```markdown
---
id: implement-auth
title: Implement User Authentication
created: 2024-01-15
status: focus
priority: high
prd: docs/prd/version/1.0.0.md
tags: [auth, security]
---

## Description
OAuth2-based user authentication system

## Acceptance Criteria
- [ ] Google login
- [ ] GitHub login
- [ ] Session management

## Notes
- Consider using NextAuth.js
```

#### Task Lifecycle

```
inbox → [GTD clarifies] → next or someday
next  → [Init creates PRD] → focus
focus → [Coding implements] → (testing)
       → [Tester verifies] → done or back to focus
```

### State Management

```
.raven/
├── tasks/                # GTD task files (see above)
├── state/
│   ├── project.json      # Project-level state
│   └── session/
│       └── *.json        # Session snapshots
├── config.yaml           # User configuration
└── agents/               # Compiled agents (runtime)
```

**Project State Schema:**
```json
{
  "name": "project_name",
  "current_task": "implement-auth",
  "status": "gtd | init | code | test | done",
  "last_activity": "ISO timestamp",
  "stats": {
    "inbox": 3,
    "focus": 1,
    "next": 5,
    "someday": 12,
    "done": 24
  }
}
```

## Installation

```bash
# Install globally
bun add -g raven-agent

# Initialize in your project
cd your-project
raven install

# Start working
raven gtd       # Manage tasks
raven init      # Create PRD for a task
raven code      # Implement a task
raven test      # Verify implementation
```

## Commands

```bash
# Core commands
raven install          # Install Raven to project
raven status           # Show project & task status

# Agent commands
raven gtd              # 📥 Task Manager - capture, clarify, prioritize
raven init             # 🚀 Context Engineer - analyze, create PRD
raven code             # 💻 Developer - implement features
raven test             # 🧪 QA Engineer - verify implementation

# Task shortcuts
raven add "task title" # Quick add to inbox
raven focus            # Show current focus tasks
raven next             # Show ready tasks
raven done             # Show completed tasks
```

## Agent Definition Format

Agents are defined in YAML and compiled to Markdown:

```yaml
agent:
  metadata:
    id: "gtd"
    name: "GTD"
    title: "Task Manager"
    icon: "📥"

  persona:
    role: |
      GTD Expert + Task Orchestrator
    identity: |
      I help you capture, clarify, and organize tasks.
      I ensure nothing falls through the cracks.
    communication_style: |
      Calm and organized. I ask clarifying questions.
    principles:
      - Capture everything - don't rely on memory
      - Clarify next actions - make tasks actionable
      - Review regularly - keep the system trusted
      - One thing at a time - focus beats multitasking

  prompts:
    - id: inbox
      content: |
        <instructions>
        Process inbox items one by one.
        </instructions>
        <process>
        <step n="1">List all inbox items</step>
        <step n="2">For each: Is it actionable?</step>
        <step n="3">If yes: What's the next action? → next/</step>
        <step n="4">If no: Delete or → someday/</step>
        </process>

  menu:
    - trigger: inbox
      action: "#inbox"
      description: "Process inbox items"
    - trigger: review
      action: "#review"
      description: "Weekly review"
```

## Configuration

`.raven/config.yaml`:
```yaml
user_name: "Your Name"
communication_language: "English"
focus_limit: 3              # Max tasks in focus
auto_archive_days: 30       # Archive done tasks after N days
```

## Development

```bash
# Clone and setup
git clone https://github.com/anthropics/raven.git
cd raven
bun install

# Development commands
bun run build         # Compile agents
bun run test          # Run tests
bun run lint          # Lint code
bun run dev           # Watch mode
```

## Project Structure

```
raven/
├── src/
│   ├── agents/              # Agent YAML definitions
│   │   ├── gtd.agent.yaml
│   │   ├── init.agent.yaml
│   │   ├── coding.agent.yaml
│   │   └── tester.agent.yaml
│   ├── core/
│   │   ├── tasks/           # Shared task definitions
│   │   ├── templates/       # Output templates
│   │   └── utils/           # Helper utilities
│   └── workflows/           # Multi-agent workflows
├── tools/
│   └── cli/                 # CLI implementation
│       ├── commands/        # CLI commands
│       └── lib/             # Shared utilities
├── test/                    # Tests
├── package.json
├── tsconfig.json
└── CLAUDE.md               # This file
```

## Key Concepts

### PRD (Product Requirements Document)

Location: `docs/prd/{task-id}.md`

Init agent creates PRDs that define:
- Feature scope and goals
- Acceptance criteria
- Technical constraints
- Out of scope items

### Session Resilience

All progress is saved automatically. If interrupted:
1. Task state preserved in `.raven/tasks/`
2. Session snapshot in `.raven/state/session/`
3. Next session offers to resume

### Handoff Protocol

Agents communicate via task status changes:
```
GTD → Init:   Task clarified, moved to next/
Init → Coding: PRD created, moved to focus/
Coding → Tester: Implementation complete
Tester → Done: All tests pass → done/
Tester → Coding: Tests fail → back to focus/
```

### Weekly Review (GTD)

GTD agent can run a weekly review:
1. Process inbox to zero
2. Review someday/ for anything to activate
3. Review next/ for stale tasks
4. Review done/ and celebrate wins
5. Capture any new ideas

## Inspirations

- **David Allen's GTD** - Getting Things Done methodology
- **Things app** - Beautiful task management
- [Anthropic's Effective Harnesses](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- [Claude Quickstarts: Autonomous Coding](https://github.com/anthropics/claude-code/tree/main/quickstarts/autonomous-coding)

## License

MIT

---

*Built with 🪶 by developers who believe AI should amplify, not replace, human creativity.*
