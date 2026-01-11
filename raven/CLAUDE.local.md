# Raven - 해야할 일

## Done (완료)

### Session Persistence Auto-Save (v0.2.1)
- **상태**: 구현 완료

**구현된 Hook 자동화**:
- [x] SessionStart Hook - 세션 시작 시 이전 상태 로드
- [x] Stop Hook 확장 - 세션 종료 시 자동 저장
- [x] PostToolUse Hook - 파일 Read/Edit/Write 자동 추적
- [x] `/raven:session-reset` 명령 추가

**새 스크립트**:
- `scripts/session-start-hook.sh`
- `scripts/session-init.sh`
- `scripts/session-update.sh`
- `scripts/session-reset.sh`
- `scripts/post-tool-hook.sh`

### Plugin Structure Refactoring (v0.2.0)
- **상태**: 완료

### ralph-wiggum-integration (구현 완료)
- **PRD**: `docs/prd/ralph-wiggum-integration.md`
- **상태**: 구현 완료

### security-enhancement (구현 완료)
- **PRD**: `docs/prd/security-enhancement.md`
- **상태**: 구현 완료

---

## Next (준비 완료)

### tester-coding-integration
- **설명**: 별도 Tester 에이전트 대신 Coding 워크플로우에 테스트 단계 통합
- **우선순위**: Medium

---

## 기술 부채

### 검증 필요
- [ ] SessionStart Hook 실제 동작 테스트
- [ ] PostToolUse Hook 파일 추적 테스트
- [ ] 세션 재개 시나리오 E2E 테스트

### 문서화
- [x] README.md 업데이트 (Session Persistence 섹션)
- [ ] 각 에이전트 사용법 문서화
- [ ] 신규 사용자용 Quick Start 가이드

---

## Hook 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                    Session Lifecycle                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SessionStart ──────────────────────────────────────────►   │
│       │                                                     │
│       ▼                                                     │
│  ┌─────────────────┐                                        │
│  │ Load working.json│                                       │
│  │ Show resume prompt│                                      │
│  └─────────────────┘                                        │
│       │                                                     │
│       ▼                                                     │
│  ┌─────────────────┐    PostToolUse                         │
│  │   Work Session   │◄──────────────┐                       │
│  │                  │               │                       │
│  │  Read/Edit/Write │───────────────┘                       │
│  │  (auto-tracked)  │      │                                │
│  └─────────────────┘      ▼                                 │
│       │              ┌─────────────────┐                    │
│       │              │ Update context  │                    │
│       │              │ files_read/     │                    │
│       │              │ files_modified  │                    │
│       │              └─────────────────┘                    │
│       ▼                                                     │
│  ┌─────────────────┐                                        │
│  │    Stop Hook    │                                        │
│  │ Auto-save state │                                        │
│  │ Check loop      │                                        │
│  └─────────────────┘                                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

*Last updated: 2026-01-11*
