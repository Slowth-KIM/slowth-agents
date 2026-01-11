---
name: raven-code
description: Developer 에이전트의 구현 프로세스. Feature 구현, 세션 관리, 커밋 워크플로우의 세부 단계를 정의합니다.
---

# Raven Code - Implementation Process

💻 Coding Agent의 세부 구현 프로세스입니다.

## Main Menu

```
💻 Coding Agent - Developer

활성 세션: {있음/없음}
Focus 태스크: {n}개

[1] impl   - Feature 구현 시작
[2] resume - 중단된 구현 재개
[3] fix    - Quick fix (PRD 없이)
[4] status - 현재 상태 확인
[x] 종료
```

---

## impl - Feature 구현

### Step 1: 세션 확인

이전 세션이 있으면:
```
이전 세션: {task_name}
진행: {completed}/{total} 완료
[r] 이어서 / [n] 새로 시작
```

### Step 2: 태스크 선택

`.raven/tasks/focus/`에서 PRD가 있는 태스크 목록 표시.

없으면:
```
Focus에 task가 없습니다.
[n] next/에서 선택
[d] 직접 설명
```

### Step 3: 구현 계획 생성

PRD 분석 후 태스크 분해:
- 필요한 변경 사항
- 파일 수정/생성
- 의존성과 순서

```
구현 계획:
1. {subtask_1}
2. {subtask_2}
3. {subtask_3}

맞나요? [y] 예 / [e] 수정
```

`working-init`으로 세션 초기화, 계획 저장.

### Step 4: 구현 실행

각 서브태스크마다:
```
▶ Task {n}/{total}: {subtask_name}
```

- 서브태스크 구현
- diff 또는 요약 표시
- `working-update`로 상태 업데이트

```
[c] 계속 / [p] 일시정지 / [t] 테스트 실행
```

- `p`: 상태 저장 후 종료
- `t`: 테스트 실행

### Step 5: 통합 확인

```
구현 확인:
[c] 완료 → 커밋
[f] 수정 필요
[t] Tester에게 전달
```

### Step 6: 커밋

```
커밋 메시지: "{message}"
[y] 커밋 / [e] 수정 / [n] 취소
```

### Step 7: 핸드오프

```
다음 단계:
[t] Tester Agent 호출
[g] GTD로 돌아가기
[x] 종료
```

`handoff-write` 실행 후 안내.

---

## resume - 세션 재개

1. `working-load`로 상태 로드
2. 진행 상황 표시:
   ```
   Task: {task_name}
   진행: {completed}/{total}

   ✅ 완료: {completed_subtasks}
   ▶ 다음: {next_subtask}
   ```
3. git status 확인
4. impl Step 4로 점프

---

## fix - Quick Fix

1. 수정 내용 파악
2. 변경 수행, diff 표시
3. 커밋:
   ```
   fix: {message}

   🪶 Raven Coding Agent
   ```

---

## status - 현재 상태

```bash
git status --short
git log --oneline -5
```

활성 세션 있으면 진행 상황 표시.

---

## Implementation Guidelines

1. **프로젝트 컨벤션 준수** - CLAUDE.md 확인
2. **점진적 구현** - 한 번에 한 파일/함수
3. **에러 처리** - edge case 고려
4. **테스트 가능성** - 의존성 주입 고려

---

## Commit Format

```
{type}: {description}

{body}

🪶 Raven Coding Agent
```

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`

---

## BMAD Integration

- **시작**: `working-load`, `belief-load`
- **진행 중**: `working-update`, `decision-log`
- **종료**: `dialogue-save`, `handoff-write`
