---
name: raven-init
description: Init Agent의 세부 프로세스. 프로젝트 컨텍스트 설정, PRD 생성, 코드베이스 분석의 단계를 정의합니다.
---

# Raven Init - Context Engineer Process

🚀 Init Agent의 세부 프로세스입니다.

## Main Menu

```
🚀 Init Agent - Context Engineer

프로젝트: {project_name}
컨텍스트 초기화됨: {yes/no}
PRD 수: {count}개

[1] setup   - Project Context (CLAUDE.md) 설정
[2] prd     - Task PRD 생성
[3] analyze - 코드베이스 분석
[4] status  - 프로젝트 상태 확인
[x] 종료
```

---

## setup - Project Context 설정

### 1. 기존 컨텍스트 확인
- CLAUDE.md 존재 여부 확인
- 있으면: "CLAUDE.md가 이미 있습니다. 수정할까요? [y/n]"

### 2. 설치된 Skills/Plugins 확인

**먼저 확인:**
```bash
ls -la .claude/skills/
ls -la .claude/agents/
cat .claude/plugin.json
```

### 3. 코드베이스 분석
```bash
git ls-tree -r --name-only HEAD 2>/dev/null || find . -type f -not -path '*/\.*'
```
- 주요 언어/프레임워크 식별
- 프로젝트 구조 파악
- 주요 명령어 (package.json, Makefile 등)

### 4. 분석 결과 확인
```
분석 결과:
- 언어: {languages}
- 프레임워크: {frameworks}
- 구조: {structure_summary}
- 설치된 Skills: {skills}

맞나요? [c] 계속 / [e] 수정
```

### 5. CLAUDE.md 생성
섹션:
- Installed Skills & Plugins (먼저!)
- Project Overview
- Tech Stack
- Architecture
- Key Commands
- Code Conventions

### 6. 저장
- CLAUDE.md 작성
- `belief-update` 실행
- project.json 업데이트: `project_context_initialized: true`

---

## prd - PRD 생성

### 1. 컨텍스트 확인
- CLAUDE.md 없으면: "먼저 설정할까요? [y/n]"

### 2. 태스크 선택
- `.raven/tasks/focus/` 또는 `next/`에서 태스크 목록
- 번호로 선택

### 3. 범위 파악
```
추가로 알아야 할 내용이 있나요?
[d] 직접 설명 추가
[c] 코드 분석으로 파악
[n] 현재 정보로 충분
```

### 4. PRD 생성
```markdown
---
task_id: {task_id}
title: {title}
created: {timestamp}
status: draft
---

# {title}

## Overview
## Goals
## Acceptance Criteria
## Technical Approach
## Out of Scope
## Dependencies
```

### 5. PRD 저장
- `docs/prd/` 디렉토리 생성
- `docs/prd/{task_id}.md` 저장
- 태스크 파일 업데이트: `prd: docs/prd/{task_id}.md`
- `decision-log`로 PRD 결정 기록

### 6. 핸드오프
```
다음 단계:
[c] Coding Agent 호출
[f] Focus에 추가
[x] 종료
```

---

## analyze - 코드베이스 분석

### 1. 구조 분석
```bash
find . -type d -not -path '*/\.*' | head -50
```

### 2. Tech Stack 파악
- package.json, go.mod, Cargo.toml, requirements.txt

### 3. 설치된 Skills 확인
```bash
ls .claude/skills/
```

### 4. 결과 표시
- 프로젝트 구조
- Tech Stack
- 설치된 Skills
- 패턴
- 권장 다음 단계

---

## status - 프로젝트 상태

1. `.raven/state/project.json` 읽기
2. 상태 표시:
   ```
   프로젝트: {name}
   컨텍스트 초기화됨: {yes/no}
   마지막 활동: {last_activity}
   설치된 Skills: {count}개
   ```
3. PRD 목록 표시

---

## BMAD Integration

- **시작**: `belief-load`
- **분석 후**: `belief-update` (코드베이스 정보)
- **PRD 생성**: `decision-log`
- **핸드오프**: `handoff-write`
