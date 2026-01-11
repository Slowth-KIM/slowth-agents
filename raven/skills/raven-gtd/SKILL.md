---
name: raven-gtd
description: GTD Agent의 세부 프로세스. 태스크 캡처, inbox 정리, focus 관리, weekly review의 단계를 정의합니다.
---

# Raven GTD - Task Manager Process

📥 GTD Agent의 세부 프로세스입니다.

## Main Menu

```
📥 Inbox: {n}개  🎯 Focus: {n}/3  📋 Next: {n}개  💭 Someday: {n}개  ✅ Done: {n}개

[1] inbox  - Inbox 정리 (Clarify)
[2] focus  - Focus 관리 (현재 작업)
[3] add    - 빠른 추가 (Capture)
[4] review - Weekly Review
[5] status - 전체 현황 보기
[x] 종료
```

---

## inbox - Inbox 정리

1. `.raven/tasks/inbox/` 의 모든 .md 파일 읽기
2. 비어있으면: "Inbox가 비어있습니다! 🎉"
3. 각 항목에 대해:
   ```
   [a] 실행 가능 (Actionable) → next/
   [s] 나중에 (Someday) → someday/
   [d] 삭제
   [skip] 다음 항목으로
   ```
4. 'a' 선택 시: "PRD가 필요한가요? [y/n]"
   - y: `needs_prd: true` 설정 후 next/로 이동
   - n: 바로 next/로 이동
5. 처리 요약 표시

---

## focus - Focus 관리

1. `.raven/tasks/focus/` 읽기
2. "현재 Focus ({count}/3):" 표시
3. 선택지:
   ```
   [a] Focus에 추가 (next/에서 선택)
   [c] 완료 처리 → done/
   [r] Focus에서 제거 → next/
   [x] 메뉴로
   ```
4. Focus 3개 이상이면: "Focus가 가득 찼습니다."
5. 완료 시:
   - `completed_at` 타임스탬프 추가
   - done/으로 이동
   - "🎉 완료! 잘했어요!"

---

## add - 빠른 추가

1. "무엇을 추가할까요?" 질문
2. 제목으로 ID 생성 (slugify)
3. `.raven/tasks/inbox/{id}.md` 파일 생성:
   ```yaml
   ---
   id: {slug}
   title: {title}
   created: {timestamp}
   status: inbox
   priority: medium
   tags: []
   ---
   ```
4. "더 자세한 설명을 추가할까요? [y/n]"
5. "✅ '{title}' 추가됨 (inbox)"
6. "바로 정리할까요? [y/n]"

---

## review - Weekly Review

### 1. Inbox Zero
- inbox 항목 수 확인
- 있으면: "먼저 inbox를 정리할까요? [y/n]"

### 2. Review Someday
- someday/ 태스크 목록 표시
- "활성화할 항목이 있나요?" → next/로 이동

### 3. Review Next
- next/ 태스크 목록 표시 (created 날짜 포함)
- 2주 이상 된 항목 표시
- "stale한 항목을 정리할까요?"

### 4. Celebrate Done
- 이번 주 완료 항목 카운트
- "이번 주 완료: {count}개 🎉"

### 5. Plan Next Week
- "다음 주 focus에 넣을 항목을 선택하세요 (최대 3개)"
- "Weekly review 완료!"

---

## status - 전체 현황

```
📥 Inbox: {n}개
🎯 Focus: {n}/3
📋 Next: {n}개
💭 Someday: {n}개
✅ Done: {n}개
```

Focus 태스크 목록 표시.

권장사항:
- inbox > 5: "💡 Inbox가 쌓여있어요."
- focus == 0: "💡 Focus가 비어있어요."

---

## Helper Functions

### Slugify
```bash
echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-'
```

### Timestamp
```bash
date '+%Y-%m-%dT%H:%M:%S%z'
```

---

## BMAD Integration

- **시작**: `belief-load`
- **핸드오프**: `handoff-write`
