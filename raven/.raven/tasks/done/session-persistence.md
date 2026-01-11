---
id: session-persistence
title: Session Persistence - BMAD 스타일 에이전트 메모리 시스템
created: 2026-01-07T02:30:00+0900
status: focus
priority: high
tags: [feature, memory]
prd: docs/prd/session-persistence.md
---

BMAD 스타일의 에이전트 메모리 시스템 구현

## Description

BMAD(Belief-Memory-Action-Dialogue) 패턴을 적용한 에이전트 메모리 시스템:
- belief.json: 프로젝트에 대한 에이전트의 이해
- working.json: 현재 세션 작업 상태
- decisions/: 태스크별 의사결정 기록
- dialogue/: 태스크별 대화 히스토리

## Acceptance Criteria

- [x] `.raven/state/memory/` 구조 생성
- [x] 에이전트 시작 시 이전 세션 재개 옵션
- [x] 작업 중단 시 진행 상태 자동 저장
- [x] 의사결정 기록 기능
- [x] 에이전트 간 핸드오프 시 컨텍스트 유지
