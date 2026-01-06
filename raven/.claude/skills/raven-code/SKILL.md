---
name: raven-code
description: Developer 에이전트를 시작합니다. Feature 구현, 세션 관리, 커밋 워크플로우를 수행합니다.
---

# Raven Code - Developer

💻 Feature 구현 에이전트를 시작합니다.

## 시작하기

1. `.raven/` 폴더 존재 확인
2. 활성 세션 확인 (재개 가능)
3. Coding 에이전트 실행

## 실행 지침

### 1. 초기화 확인

`.raven/state/project.json` 파일 존재 확인.

**없는 경우:**
```
🪶 Raven이 초기화되지 않았습니다.

초기화하려면: bash tools/init-raven.sh
```

### 2. 세션 확인

```bash
# 활성 세션 확인
ls .raven/state/session/*.json 2>/dev/null

# Focus 태스크 확인
ls .raven/tasks/focus/*.md 2>/dev/null
```

### 3. 메뉴 표시

```
💻 Coding Agent - Developer

활성 세션: {있음/없음}
Focus 태스크: {n}개

무엇을 할까요?
[1] impl - Feature 구현 시작
[2] resume - 중단된 구현 재개
[3] fix - Quick fix (PRD 없이)
[4] status - 현재 상태 확인
[x] 종료
```

### 4. 명령 처리

`.claude/agents/raven-coding.md`에 정의된 명령 실행.

## 인자 처리

- `/raven-code impl` → 바로 구현 시작
- `/raven-code resume` → 세션 재개
- `/raven-code fix "버그 설명"` → Quick fix
- `/raven-code status` → 상태만 표시

## 핸드오프

- 구현 완료 후 검증 → `/raven-test` 안내
- 태스크 관리 → `/raven-gtd` 안내
- PRD 필요 → `/raven-init` 안내
