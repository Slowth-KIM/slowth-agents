# PRD: Tester-Coding Integration

## Overview

별도의 Tester 에이전트 대신 Coding 워크플로우에 테스트 단계를 통합합니다.

## Problem Statement

현재 워크플로우:
```
Coding → 핸드오프 → Tester → (실패시) 핸드오프 → Coding → ...
```

**문제점:**
1. 에이전트 간 핸드오프 오버헤드
2. 컨텍스트 스위치 비용
3. 테스트가 "사후" 단계로 분리됨
4. 현대적인 TDD/BDD 원칙과 불일치

## Solution

"Shift-Left Testing" 패턴 적용 - 테스트를 개발 초기 단계로 통합.

### New Workflow

```
Coding Agent (통합):
  impl → 계획 → [구현 → 테스트 → 수정]×N → 전체 검증 → 커밋 → 완료
```

### Key Changes

1. **구현 단계 테스트**: 각 서브태스크 구현 후 관련 테스트 자동 실행
2. **PRD 검증 통합**: 구현 완료 후 수락 기준 자체 검증
3. **Tester 역할 축소**: 독립 QA 리뷰 용도로만 유지 (선택적)

## Implementation Plan

### Phase 1: Coding Agent 업데이트

**agents/raven-coding.md:**
- skills에 `raven-test` 추가
- 테스트 실행 능력 추가
- 자체 검증 원칙 추가

### Phase 2: raven-code Skill 업데이트

**skills/raven-code/SKILL.md:**

#### Step 4 수정 (구현 실행):
```
각 서브태스크:
1. 구현
2. 관련 테스트 실행 (있으면)
3. 실패시 즉시 수정
4. 다음 서브태스크로
```

#### Step 5 확장 (통합 확인 → 통합 검증):
```
통합 검증:
1. 전체 테스트 스위트 실행
2. PRD 수락 기준 체크
3. 결과 요약
   - ✅ Pass → 커밋으로
   - ❌ Fail → 수정 필요
```

새 섹션 추가:
```
## self-verify - 자체 검증

1. PRD에서 수락 기준 추출
2. 각 기준 검증 (자동/수동)
3. 테스트 결과 통합
4. 검증 요약 생성
```

### Phase 3: Tester Agent 역할 재정의

**agents/raven-tester.md:**
- "독립 QA 리뷰어"로 재정의
- Coding이 자체 검증 후에도 필요시 호출
- 커버리지 분석, 심층 테스트 등 전문 기능 유지

### Phase 4: Commands 업데이트

**commands/test.md:**
- 독립 실행 가능하도록 유지
- "심층 QA" 용도로 설명 변경

## Acceptance Criteria

- [x] Coding Agent가 구현 중 테스트 실행 가능
- [x] 각 서브태스크 후 관련 테스트 자동 실행
- [x] 구현 완료 후 PRD 수락 기준 자체 검증
- [x] Tester 에이전트 없이도 태스크 완료 가능
- [x] 기존 Tester 기능 (심층 QA) 여전히 사용 가능

## Out of Scope

- TDD 워크플로우 강제 (선택적)
- 테스트 자동 생성
- CI/CD 통합

## Technical Notes

- 테스트 프레임워크 감지 로직은 raven-test에서 재사용
- PRD 검증 로직은 raven-test verify 프로세스에서 차용
- 핸드오프 대신 단일 세션 내 반복

---

*Created: 2026-01-11*
