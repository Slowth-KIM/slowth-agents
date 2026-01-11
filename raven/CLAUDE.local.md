# Raven - 해야할 일

## Done (완료)

### Plugin Structure Refactoring (v0.2.0)
- **상태**: 완료

**변경 내용**:
- [x] `.claude-plugin/plugin.json` 표준 위치로 이동
- [x] agents, commands, skills, hooks를 플러그인 루트로 이동
- [x] `scripts/` 폴더 생성 및 loop 스크립트 구현
- [x] loop 명령 표준 형식으로 변경 (Bash 스크립트 실행)
- [x] 기존 `.claude/` 폴더 정리 (런타임 상태만 유지)

### ralph-wiggum-integration (구현 완료)
- **PRD**: `docs/prd/ralph-wiggum-integration.md`
- **상태**: 구현 완료

**구현된 내용**:
- [x] Ralph-Wiggum 플러그인 분석
- [x] 자율 루프 기능 설계
- [x] PRD 작성
- [x] Stop Hook 구현 (`hooks/raven-stop-hook.sh`)
- [x] `/raven:loop` 명령 추가 (Bash 스크립트 방식)
- [x] `/raven:cancel-loop` 명령 추가

### security-enhancement (구현 완료)
- **PRD**: `docs/prd/security-enhancement.md`
- **상태**: 구현 완료

**구현된 내용**:
- [x] 위험 패턴 목록 정의
- [x] Hook 구조 설계
- [x] PRD 작성
- [x] PreToolUse hook 구현 (`hooks/raven-security-hook.sh`)
- [x] 보안 로그 기능

---

## Focus (현재 작업 중)

### 1. session-persistence (구현 완료, 검증 필요)
- **PRD**: `docs/prd/session-persistence.md`
- **상태**: 구현 완료, 테스트 필요

**남은 작업**:
- [ ] `/raven:code resume` 명령 실제 테스트
- [ ] 세션 재개 시나리오 검증
- [ ] PRD Open Questions 해결

---

## Next (준비 완료)

### 2. tester-coding-integration
- **설명**: 별도 Tester 에이전트 대신 Coding 워크플로우에 테스트 단계 통합
- **우선순위**: Medium

---

## 기술 부채

### Agent/Skill 개선
- [ ] Agent 실행 시 실제 memory-helpers skill 로드 테스트
- [ ] 에이전트 간 핸드오프 실제 동작 검증
- [ ] working.json 자동 저장 구현

### 문서화
- [x] README.md 업데이트 (새 구조 문서화)
- [ ] 각 에이전트 사용법 문서화
- [ ] BMAD 메모리 시스템 사용 가이드
- [ ] 신규 사용자용 Quick Start 가이드

---

## 리팩토링된 구조

```
raven/
├── .claude-plugin/plugin.json   # 표준 위치
├── agents/                      # 플러그인 루트
├── commands/
├── skills/
├── hooks/
├── scripts/                     # NEW
│   ├── setup-raven-loop.sh
│   └── cancel-raven-loop.sh
├── .claude/                     # 런타임 상태만
└── src/agents/                  # YAML 소스
```

---

*Last updated: 2026-01-11*
