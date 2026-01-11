---
name: raven-test
description: Tester Agent의 세부 프로세스. 구현 검증, 테스트 실행, 커버리지 확인, 리포트 생성의 단계를 정의합니다.
---

# Raven Test - QA Engineer Process

🧪 Tester Agent의 세부 프로세스입니다.

## Main Menu

```
🧪 Tester Agent - QA Engineer

검증 대기: {n}개 태스크
테스트 프레임워크: {detected}

[1] verify   - 구현 검증 (PRD 기준)
[2] test     - 테스트 실행
[3] coverage - 커버리지 확인
[4] report   - 테스트 리포트 생성
[x] 종료
```

---

## verify - 구현 검증

### 1. 컨텍스트 로드
- `working.json` 확인 → Coding 핸드오프 노트 읽기
- 검증 준비된 태스크 목록
- 태스크와 PRD 로드

### 2. 기준 추출
PRD에서 수락 기준 파싱:
```
검증 항목 ({count}개):
□ 기준 1
□ 기준 2
□ 기준 3
```

### 3. 자동화 테스트 실행
테스트 있으면:
- 테스트 스위트 실행
- 결과 요약 표시
- 자동 pass/fail 마킹

테스트 없으면:
```
자동화된 테스트가 없습니다.
테스트 작성을 권장할까요? [y/n]
```

### 4. 수동 검증
각 수락 기준에 대해:
```
"{criteria}"
[p] Pass ✅
[f] Fail ❌
[s] Skip
```

### 5. Edge Case
```
추가 edge case 검증:
[y] 검증 진행
[n] 스킵
```

### 6. 결과 요약
```
검증 결과:
✅ Passed: {pass_count}
❌ Failed: {fail_count}
⏭️ Skipped: {skip_count}

Overall: {pass_rate}%
```

**모두 통과:**
```
🎉 모든 검증 통과!
Task를 완료 처리할까요? [y/n]
```
→ done/으로 이동, `working.json` 초기화

**실패 있음:**
```
❌ 일부 검증 실패
[c] Coding Agent에게 반환
[r] 재검증
[i] 무시하고 완료
```
→ `handoff-write` (실패 기준 포함)

---

## test - 테스트 실행

### 1. 테스트 감지
```bash
# Node.js
grep -E "(jest|mocha|vitest)" package.json

# Python
ls pytest.ini setup.py

# Go
ls go.mod

# Rust
ls Cargo.toml
```

### 2. 테스트 실행
```
테스트 범위:
[a] 전체 (all)
[f] 특정 파일/폴더
[w] Watch 모드
```

### 3. 결과
```
테스트 결과:
- Total: {total}
- Passed: {passed}
- Failed: {failed}
- Duration: {time}
```

실패 있으면:
```
실패한 테스트:
- {test_name}: {error_message}

분석할까요? [y/n]
```

---

## coverage - 커버리지 확인

### 1. 커버리지 실행
프레임워크별 커버리지 도구 감지 및 실행

### 2. 리포트
```
커버리지 결과:
- Lines: {line_coverage}%
- Branches: {branch_coverage}%
- Functions: {function_coverage}%
```

커버리지 낮은 파일 목록

### 3. 권장사항
- 더 많은 테스트가 필요한 영역 제안
- 커버리지 없는 중요 경로 식별

---

## report - 테스트 리포트

### 1. 범위
```
리포트 범위:
[t] 특정 task
[p] 전체 프로젝트
```

### 2. 리포트 생성
```markdown
# Verification Report

## Task: {task_id}
## Date: {timestamp}

### Acceptance Criteria
| # | Criteria | Status | Notes |
|---|----------|--------|-------|

### Automated Tests
- Framework: {framework}
- Total/Passed/Failed

### Edge Cases Checked

### Overall Result
{PASS/FAIL}

### Recommendations
```

### 3. 출력
```
[s] 화면에 표시
[f] 파일로 저장 (.raven/reports/)
```

---

## Test Framework Commands

| Framework | Command |
|-----------|---------|
| Jest | `npm test` |
| Pytest | `pytest` |
| Go | `go test ./...` |
| Cargo | `cargo test` |
| Vitest | `npx vitest run` |

---

## BMAD Integration

- **시작**: `belief-load`, `working.json` 핸드오프 확인
- **검증 후**: `dialogue-save` (검증 결과 요약)
- **실패 시**: `handoff-write` (실패 기준 포함)
- **완료 시**: `working.json` 초기화, done/으로 이동
