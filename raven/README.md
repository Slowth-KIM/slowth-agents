# Raven - AI Agent Framework

> 🪶 *"Nevermore shall you code alone"*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-blueviolet)](https://claude.ai)
[![Cursor](https://img.shields.io/badge/Cursor-00D1FF)](https://cursor.sh)
[![Codex](https://img.shields.io/badge/OpenAI%20Codex-412991)](https://openai.com)

**Raven** is a multi-platform AI agent framework that enables GTD-based autonomous coding. Works with **Claude Code**, **Cursor**, and **OpenAI Codex CLI**. Manage tasks, create PRDs, implement features, and verify code — all through conversational AI.

![Raven Demo](assets/demo.gif)

## Features

- 📥 **GTD Task Management** - Capture, clarify, organize, prioritize
- 🚀 **PRD Generation** - Transform ideas into actionable specs
- 💻 **Guided Implementation** - Step-by-step coding with session persistence
- 🧪 **Automated Verification** - Test against acceptance criteria
- 🔄 **Agent Handoffs** - Seamless workflow between agents

## Why Raven? (For Claude Code Users)

Claude Code만 쓰셨다면, 이런 경험 있으시죠?

```
"아, 이거 나중에 해야 하는데..."  → 까먹음
"지금 뭐부터 해야 하지?"        → 멍때림
"어제 뭐 하다 말았더라?"        → 컨텍스트 날아감
```

Claude Code는 **어떻게 코딩할지** 도와줍니다.
**Raven은 무엇을 코딩할지** 도와줍니다.

| Before (Claude Code만) | After (+ Raven) |
|------------------------|-----------------|
| 머리속에 TODO 저장 | 파일로 영속화 |
| "뭐하다 말았지?" | 세션 자동 복구 |
| 모든 것 동시에 | Focus 3개 제한 |
| 컨텍스트 날아감 | PRD로 명세화 |

### GTD 워크플로우

```
┌─────────────────────────────────────────────────────┐
│  📥 inbox/     "일단 던져놓으세요"                    │
│  🎯 focus/     "지금 이것만 집중" (최대 3개)          │
│  📋 next/      "다음에 할 것들"                      │
│  💭 someday/   "언젠가..."                          │
│  ✅ done/      "완료!"                              │
└─────────────────────────────────────────────────────┘
```

> 🪶 *머리를 비우세요. Raven이 기억합니다.*

## Quick Start

### 1. Initialize Raven

```bash
curl -sL https://raw.githubusercontent.com/Slowth-KIM/raven/main/tools/init-raven.sh | bash
```

### 2. Install adapter for your tool

```bash
curl -sL https://raw.githubusercontent.com/Slowth-KIM/raven/main/tools/install-adapter.sh | bash
```

Or install manually:

| Platform | Command |
|----------|---------|
| **Claude Code** | `cp -r raven/.claude your-project/.claude` |
| **Cursor** | `cp raven/adapters/cursor/.cursorrules .cursorrules` |
| **Codex CLI** | `cp raven/adapters/codex/AGENTS.md AGENTS.md` |

### 3. Use the agents

```bash
# Claude Code
/raven-gtd, /raven-init, /raven-code, /raven-test

# Cursor / Codex
raven gtd, raven init, raven code, raven test
```

## Workflow

```
📥 GTD ──→ 🚀 Init ──→ 💻 Coding ──→ 🧪 Tester ──→ ✅ Done
   │         (PRD)      (Implement)    (Verify)       │
   └─────────────────── On failure ──────────────────┘
```

| Agent | Command | Role |
|-------|---------|------|
| **GTD** | `/raven-gtd` | Task capture, clarification, prioritization |
| **Init** | `/raven-init` | PRD creation, codebase analysis |
| **Coding** | `/raven-code` | Feature implementation with commits |
| **Tester** | `/raven-test` | Verification against acceptance criteria |

## Task Management (GTD)

Tasks flow through these states:

```
.raven/tasks/
├── inbox/     # 📥 Raw ideas (capture everything)
├── focus/     # 🎯 Current work (max 3)
├── next/      # 📋 Ready to implement
├── someday/   # 💭 Future ideas
└── done/      # ✅ Completed
```

### Task File Format

```yaml
---
id: implement-auth
title: Implement User Authentication
created: 2025-01-07T10:00:00+0900
status: focus
priority: high
prd: docs/prd/implement-auth.md
tags: [auth, security]
---

## Description
OAuth2-based user authentication

## Acceptance Criteria
- [ ] Google login
- [ ] Session management
```

## Configuration

Edit `.raven/config.yaml`:

```yaml
user_name: "Your Name"
communication_language: "ko"  # ko, en, etc.
focus_limit: 3
auto_archive_days: 30
```

## Philosophy

- **Interactive Autonomy**: Agents work autonomously but keep you in control
- **GTD-Driven**: Capture → Clarify → Organize → Execute
- **PRD-Based**: Clear requirements lead to quality code
- **Session Resilience**: Pause anytime, resume seamlessly

## Project Structure

```
.claude/                    # Claude Code adapter
├── agents/
│   └── raven-*.md
└── skills/
    └── raven-*.md

adapters/                   # Other platforms
├── codex/AGENTS.md         # OpenAI Codex CLI
├── cursor/.cursorrules     # Cursor IDE
└── shared/raven-core.md    # Shared instructions

.raven/                     # Runtime state (created on init)
├── tasks/                  # GTD task files
├── state/                  # Project & session state
└── config.yaml             # User configuration
```

## Inspirations

- [Getting Things Done](https://gettingthingsdone.com/) by David Allen
- [Things app](https://culturedcode.com/things/)
- [Anthropic's Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)

## Contributing

Contributions welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

## License

MIT © 2025

---

*Built with 🪶 by developers who believe AI should amplify, not replace, human creativity.*
