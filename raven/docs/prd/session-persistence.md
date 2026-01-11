# PRD: Session Persistence - BMAD Style Agent Memory System

## Overview

| Field | Value |
|-------|-------|
| **Task ID** | session-persistence |
| **Title** | BMAD 스타일 에이전트 메모리 시스템 |
| **Priority** | High |
| **Created** | 2026-01-07 |
| **Status** | Draft |

## Problem Statement

현재 Raven 에이전트들은 세션 간에 컨텍스트를 유지하지 못합니다. 대화가 중단되면 이전 작업 상태, 의사결정 기록, 학습된 컨텍스트가 모두 손실됩니다. 이로 인해:

1. **세션 재개 불가**: 작업 중단 시 처음부터 다시 시작해야 함
2. **컨텍스트 손실**: 이전에 분석한 코드베이스 정보가 사라짐
3. **의사결정 추적 불가**: 왜 특정 결정을 했는지 기록이 없음
4. **에이전트 간 핸드오프 어려움**: 정보 전달이 명시적이지 않음

## Goals

BMAD(Belief-Memory-Action-Dialogue) 패턴을 적용한 에이전트 메모리 시스템 구현:

1. **세션 재개**: 중단된 작업을 정확히 그 지점부터 재개
2. **컨텍스트 보존**: 코드베이스 분석 결과, 프로젝트 이해 유지
3. **의사결정 기록**: 모든 중요 결정과 그 근거 저장
4. **에이전트 핸드오프**: 에이전트 간 메모리 공유

## Non-Goals

- 외부 벡터 데이터베이스 사용 (파일 기반으로 구현)
- 자연어 검색 기능 (키워드/구조 기반 검색만)
- 메모리 자동 압축/요약 (수동 관리)

## Architecture

### State Structure

```
.raven/state/
├── project.json              # 기존: 프로젝트 메타데이터
├── session/
│   └── {task_id}.json        # 기존: 구현 진행률
├── memory/                   # 신규: BMAD 메모리
│   ├── belief.json           # 에이전트 신념 상태
│   ├── working.json          # 현재 작업 컨텍스트
│   └── decisions/
│       └── {task_id}.json    # 태스크별 의사결정 기록
└── dialogue/                 # 신규: 대화 기록
    └── {task_id}.json        # 태스크별 대화 히스토리
```

### Core Components

#### 1. Belief State (`belief.json`)

에이전트의 현재 "믿음" 상태 - 프로젝트에 대한 이해:

```json
{
  "updated_at": "ISO timestamp",
  "project": {
    "name": "raven",
    "type": "ai-agent-framework",
    "tech_stack": ["TypeScript", "Bun", "Claude Code"],
    "structure_summary": "..."
  },
  "codebase": {
    "key_files": [...],
    "patterns": [...],
    "conventions": [...]
  },
  "current_focus": {
    "task_id": "session-persistence",
    "understanding": "...",
    "blockers": []
  }
}
```

#### 2. Working Memory (`working.json`)

현재 세션의 작업 상태:

```json
{
  "session_id": "uuid",
  "agent": "raven-coding",
  "task_id": "session-persistence",
  "started_at": "ISO timestamp",
  "last_activity": "ISO timestamp",

  "plan": {
    "steps": [
      {"id": 1, "name": "Create memory directory structure", "status": "completed"},
      {"id": 2, "name": "Implement belief state management", "status": "in_progress"},
      {"id": 3, "name": "Add working memory persistence", "status": "pending"}
    ],
    "current_step": 2
  },

  "context": {
    "files_read": [...],
    "files_modified": [...],
    "key_findings": [...]
  },

  "notes": [...]
}
```

#### 3. Decision Log (`decisions/{task_id}.json`)

태스크별 의사결정 기록:

```json
{
  "task_id": "session-persistence",
  "decisions": [
    {
      "id": 1,
      "timestamp": "ISO timestamp",
      "decision": "Use JSON files instead of SQLite",
      "rationale": "Simplicity, portability, no external dependencies",
      "alternatives": [
        {"option": "SQLite", "rejected_reason": "Adds complexity"},
        {"option": "YAML", "rejected_reason": "Less structured for nested data"}
      ],
      "impact": "medium"
    }
  ]
}
```

#### 4. Dialogue History (`dialogue/{task_id}.json`)

태스크별 중요 대화 기록:

```json
{
  "task_id": "session-persistence",
  "conversations": [
    {
      "session_id": "uuid",
      "started_at": "ISO timestamp",
      "summary": "PRD 작성 및 구조 설계",
      "key_exchanges": [
        {
          "user": "BMAD 스타일로 구현해줘",
          "agent": "belief, memory, action, dialogue 패턴을 적용하겠습니다",
          "outcome": "Architecture defined"
        }
      ]
    }
  ]
}
```

## Implementation Plan

### Phase 1: Directory Structure & Schema

1. `.raven/state/memory/` 디렉토리 생성
2. `.raven/state/dialogue/` 디렉토리 생성
3. 각 JSON 파일의 초기 스키마 정의

### Phase 2: Memory Helper Functions

`raven/.claude/skills/` 또는 에이전트 내 helper 섹션에 추가:

```markdown
### memory-load
.raven/state/memory/에서 현재 상태 로드

### memory-save
현재 상태를 .raven/state/memory/에 저장

### belief-update
belief.json의 특정 필드 업데이트

### working-init
새 세션의 working.json 초기화

### working-update
working.json 진행 상태 업데이트

### decision-log
새 의사결정 기록 추가

### dialogue-save
대화 요약 저장
```

### Phase 3: Agent Integration

각 에이전트의 시작/종료 시퀀스 수정:

**시작 시:**
1. `working.json` 확인 → 이전 세션 있으면 재개 여부 확인
2. `belief.json` 로드 → 프로젝트 컨텍스트 복원
3. `decisions/{task_id}.json` 로드 → 이전 결정 참조

**종료 시:**
1. `working.json` 업데이트 → 현재 진행 상태 저장
2. `belief.json` 업데이트 → 새로 학습한 내용 반영
3. `dialogue/{task_id}.json` 추가 → 세션 요약 저장

### Phase 4: Handoff Protocol Enhancement

에이전트 전환 시:
1. 현재 에이전트가 `working.json`에 핸드오프 노트 작성
2. 다음 에이전트가 핸드오프 노트 읽고 컨텍스트 파악
3. `belief.json`은 공유, `working.json`은 새로 초기화

## Acceptance Criteria

- [ ] `.raven/state/memory/` 구조가 생성됨
- [ ] 에이전트 시작 시 이전 세션 존재하면 재개 옵션 제공
- [ ] 작업 중단 시 `working.json`에 진행 상태 자동 저장
- [ ] 의사결정 시 `decisions/`에 기록
- [ ] 에이전트 간 핸드오프 시 컨텍스트 유지됨
- [ ] `/raven:code resume` 명령으로 이전 세션 정확히 재개

## Technical Constraints

1. **파일 기반**: 외부 DB 없이 JSON/YAML 파일만 사용
2. **동기화 안전**: 동시 접근 시 충돌 방지 (lock file 또는 순차 처리)
3. **크기 제한**: 각 파일 1MB 이하 유지 (오래된 항목 아카이브)
4. **호환성**: 기존 `.raven/` 구조와 호환 유지

## Success Metrics

1. 세션 재개 성공률 > 95%
2. 컨텍스트 복원 후 사용자 추가 설명 필요 없음
3. 의사결정 추적으로 "왜 이렇게 했지?" 질문에 답변 가능

## Open Questions

1. 메모리 정리 정책: 얼마나 오래 보관할 것인가?
2. 대화 기록 상세도: 전체 저장 vs 요약만 저장?
3. 멀티 에이전트 동시 실행 시 충돌 처리 방법?

---

*Generated by Raven Init Agent*
