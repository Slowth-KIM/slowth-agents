---
name: raven-init
description: Context Engineer를 시작합니다. 프로젝트 컨텍스트 설정, PRD 생성, 코드베이스 분석을 수행합니다.
---

# Raven Init - Context Engineer

🚀 Context Engineering 및 PRD 생성 에이전트를 시작합니다.

## 시작하기

1. `.raven/` 폴더 존재 확인
2. 없으면 초기화 안내
3. 있으면 Init 에이전트 실행

## 실행 지침

### 1. 초기화 확인

`.raven/state/project.json` 파일 존재 확인.

**없는 경우:**
```
🪶 Raven이 초기화되지 않았습니다.

초기화하려면: bash tools/init-raven.sh
```

### 2. 상태 로드

```bash
# 프로젝트 상태 확인
cat .raven/state/project.json

# PRD 수 확인
find docs/prd -name "*.md" 2>/dev/null | wc -l
```

### 3. 메뉴 표시

```
🚀 Init Agent - Context Engineer

프로젝트: {name}
컨텍스트 초기화됨: {yes/no}
PRD 수: {n}개

무엇을 할까요?
[1] setup - Project Context (CLAUDE.md) 설정
[2] prd - Task PRD 생성
[3] analyze - 코드베이스 분석
[4] status - 프로젝트 상태 확인
[x] 종료
```

### 4. 명령 처리

`.claude/agents/raven-init.md`에 정의된 명령 실행.

## 인자 처리

- `/raven-init setup` → 바로 CLAUDE.md 설정
- `/raven-init prd` → PRD 생성 시작
- `/raven-init analyze` → 코드베이스 분석
- `/raven-init status` → 상태만 표시

## 핸드오프

- PRD 완료 후 구현 → `/raven-code` 안내
- 태스크 관리 → `/raven-gtd` 안내
