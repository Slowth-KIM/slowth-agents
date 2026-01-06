# Raven MVP Progress

## Iteration 1 - 2026-01-07

### Completed

1. **GTD Agent Conversion** ✅
   - Created `.claude/agents/raven-gtd.md`
   - Converted YAML persona, prompts, menu to Claude Code agent format
   - Includes: identity, communication style, principles, startup sequence
   - Commands: inbox, focus, add, review, status
   - Korean language support

2. **Initialization Script** ✅
   - Created `tools/init-raven.sh`
   - Creates `.raven/` directory structure
   - Initializes `project.json` with default values
   - Creates sample welcome task in inbox
   - Updates `.gitignore` for session data

3. **GTD Skill** ✅
   - Created `.claude/skills/raven-gtd.md`
   - Provides invocation instructions
   - Supports argument handling (inbox, add, status, review)
   - Documents handoff to other agents

4. **Testing** ✅
   - Ran init script successfully
   - Verified directory structure created
   - Verified project.json and config.yaml
   - Verified sample task in inbox

### Files Created

```
.claude/
├── agents/
│   └── raven-gtd.md          # GTD agent definition
└── skills/
    └── raven-gtd.md          # GTD skill invocation

.raven/
├── state/
│   └── project.json          # Project state
├── tasks/
│   ├── inbox/
│   │   └── welcome-to-raven.md
│   ├── focus/
│   ├── next/
│   ├── someday/
│   └── done/
└── config.yaml               # User config

tools/
└── init-raven.sh             # Initialization script
```

### Remaining for Phase 1

- [ ] Integration test with actual Claude Code invocation
- [ ] Verify AskUserQuestion works for interactive menus

### Phase 2 (Next)

- [x] Convert Init agent → `.claude/agents/raven-init.md`
- [x] Convert Coding agent → `.claude/agents/raven-coding.md`
- [x] Convert Tester agent → `.claude/agents/raven-tester.md`
- [x] Create corresponding skills

---

## Iteration 2 - Phase 2 Complete

### Completed

1. **Init Agent** ✅
   - `.claude/agents/raven-init.md` - Context Engineer
   - `.claude/skills/raven-init.md` - `/raven-init` skill
   - Commands: setup, prd, analyze, status
   - CLAUDE.md 생성, PRD 작성

2. **Coding Agent** ✅
   - `.claude/agents/raven-coding.md` - Developer
   - `.claude/skills/raven-code.md` - `/raven-code` skill
   - Commands: impl, resume, fix, status
   - 세션 기반 진행 관리, 커밋 워크플로우

3. **Tester Agent** ✅
   - `.claude/agents/raven-tester.md` - QA Engineer
   - `.claude/skills/raven-test.md` - `/raven-test` skill
   - Commands: verify, test, coverage, report
   - PRD 수락 기준 검증, 테스트 프레임워크 자동 감지

### Complete File Structure

```
.claude/
├── agents/
│   ├── raven-gtd.md           # GTD Task Manager
│   ├── raven-init.md          # Context Engineer
│   ├── raven-coding.md        # Developer
│   └── raven-tester.md        # QA Engineer
├── skills/
│   ├── raven-gtd.md           # /raven-gtd
│   ├── raven-init.md          # /raven-init
│   ├── raven-code.md          # /raven-code
│   └── raven-test.md          # /raven-test
│   └── prompt-engineering-patterns/  # Reference
└── raven-progress.md          # This file

.raven/
├── state/
│   ├── project.json
│   └── session/               # Coding session state
├── tasks/
│   ├── inbox/
│   ├── focus/
│   ├── next/
│   ├── someday/
│   └── done/
└── config.yaml

tools/
└── init-raven.sh
```

### Workflow

```
GTD (캡처/정리) → Init (PRD 생성) → Coding (구현) → Tester (검증)
     ↑                                                    ↓
     └──────────────── 태스크 완료 또는 실패 ─────────────┘
```

### Blockers

None.

### Decisions Made

1. Agent format: Using Claude Code `.md` agent format with frontmatter
2. Korean as default communication language
3. Focus limit: 3 tasks (configurable in config.yaml)
4. Task file format: YAML frontmatter + Markdown body
5. Session state: JSON in `.raven/state/session/`
6. PRD location: `docs/prd/{task_id}.md`

<promise>RAVEN MVP PHASE 2 COMPLETE</promise>
