#!/bin/bash
# Raven Initialization Script
# Creates .raven/ directory structure and initializes project state

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🪶 Raven 초기화 중...${NC}"
echo ""

# Get project name from current directory
PROJECT_NAME=$(basename "$(pwd)")
TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S%z')

# Create directory structure
echo -e "${YELLOW}📁 디렉토리 구조 생성 중...${NC}"

mkdir -p .raven/state/session
mkdir -p .raven/tasks/inbox
mkdir -p .raven/tasks/focus
mkdir -p .raven/tasks/next
mkdir -p .raven/tasks/someday
mkdir -p .raven/tasks/done
mkdir -p .raven/agents

echo "  ✓ .raven/state/"
echo "  ✓ .raven/tasks/{inbox,focus,next,someday,done}/"
echo "  ✓ .raven/agents/"

# Create project.json
echo ""
echo -e "${YELLOW}📄 프로젝트 상태 파일 생성 중...${NC}"

cat > .raven/state/project.json << EOF
{
  "name": "${PROJECT_NAME}",
  "project_context_initialized": false,
  "current_task": null,
  "last_activity": "${TIMESTAMP}",
  "last_agent": null,
  "stats": {
    "inbox": 1,
    "focus": 0,
    "next": 0,
    "someday": 0,
    "done": 0
  }
}
EOF

echo "  ✓ .raven/state/project.json"

# Create config.yaml
cat > .raven/config.yaml << EOF
# Raven Configuration
user_name: ""
communication_language: "ko"
focus_limit: 3
auto_archive_days: 30
EOF

echo "  ✓ .raven/config.yaml"

# Create sample inbox task
echo ""
echo -e "${YELLOW}📝 샘플 태스크 생성 중...${NC}"

SAMPLE_ID="welcome-to-raven"
cat > .raven/tasks/inbox/${SAMPLE_ID}.md << EOF
---
id: ${SAMPLE_ID}
title: Raven에 오신 것을 환영합니다
created: ${TIMESTAMP}
status: inbox
priority: medium
needs_prd: false
tags: [welcome, tutorial]
---

## Description

Raven GTD 시스템에 오신 것을 환영합니다!

이 태스크는 시스템이 어떻게 작동하는지 보여주기 위한 샘플입니다.

## Notes

- inbox에서 이 태스크를 처리해보세요
- [a]를 눌러 next/로 이동하거나
- [d]를 눌러 삭제할 수 있습니다
EOF

echo "  ✓ 샘플 태스크: ${SAMPLE_ID}"

# Add to .gitignore if exists
if [ -f .gitignore ]; then
  if ! grep -q ".raven/state/session" .gitignore 2>/dev/null; then
    echo ""
    echo -e "${YELLOW}📋 .gitignore 업데이트 중...${NC}"
    echo "" >> .gitignore
    echo "# Raven session data" >> .gitignore
    echo ".raven/state/session/" >> .gitignore
    echo "  ✓ .gitignore에 세션 데이터 제외 추가"
  fi
fi

echo ""
echo -e "${GREEN}✅ Raven 초기화 완료!${NC}"
echo ""
echo "다음 명령어로 시작하세요:"
echo "  /raven gtd    - GTD 태스크 매니저 시작"
echo "  /raven status - 현재 상태 확인"
echo ""
