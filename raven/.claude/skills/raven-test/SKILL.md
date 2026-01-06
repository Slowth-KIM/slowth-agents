---
name: raven-test
description: QA Engineer를 시작합니다. 구현 검증, 테스트 실행, 커버리지 확인, 리포트 생성을 수행합니다.
---

# Raven Test - QA Engineer

🧪 QA 및 검증 에이전트를 시작합니다.

## 시작하기

1. `.raven/` 폴더 존재 확인
2. 검증 대기 태스크 확인
3. 테스트 프레임워크 감지
4. Tester 에이전트 실행

## 실행 지침

### 1. 초기화 확인

`.raven/state/project.json` 파일 존재 확인.

**없는 경우:**
```
🪶 Raven이 초기화되지 않았습니다.

초기화하려면: bash tools/init-raven.sh
```

### 2. 테스트 환경 확인

```bash
# 테스트 프레임워크 감지
if [ -f package.json ]; then
  echo "Node.js project"
  grep -E "(jest|mocha|vitest)" package.json
elif [ -f pytest.ini ] || [ -f setup.py ]; then
  echo "Python project - pytest"
elif [ -f go.mod ]; then
  echo "Go project - go test"
elif [ -f Cargo.toml ]; then
  echo "Rust project - cargo test"
fi
```

### 3. 메뉴 표시

```
🧪 Tester Agent - QA Engineer

검증 대기: {n}개 태스크
테스트 프레임워크: {detected}

무엇을 할까요?
[1] verify - 구현 검증 (PRD 기준)
[2] test - 테스트 실행
[3] coverage - 커버리지 확인
[4] report - 테스트 리포트 생성
[x] 종료
```

### 4. 명령 처리

`.claude/agents/raven-tester.md`에 정의된 명령 실행.

## 인자 처리

- `/raven-test verify` → 바로 검증 시작
- `/raven-test test` → 테스트만 실행
- `/raven-test coverage` → 커버리지 확인
- `/raven-test report` → 리포트 생성

## 핸드오프

- 검증 실패 → `/raven-code` 안내 (수정 필요)
- 검증 통과 → done/으로 이동, `/raven-gtd` 안내
