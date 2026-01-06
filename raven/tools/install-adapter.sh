#!/bin/bash
# Raven Adapter Installation Script
# Installs the appropriate adapter for your AI coding tool

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

RAVEN_REPO="https://raw.githubusercontent.com/Slowth-KIM/raven/main"

echo -e "${BLUE}🪶 Raven Adapter Installer${NC}"
echo ""

# Check if .raven exists
if [ ! -d ".raven" ]; then
    echo -e "${YELLOW}⚠️  .raven/ 폴더가 없습니다. 먼저 초기화하세요:${NC}"
    echo "   curl -sL ${RAVEN_REPO}/tools/init-raven.sh | bash"
    echo ""
fi

# Menu
echo "어떤 AI 코딩 도구를 사용하시나요?"
echo ""
echo "[1] Claude Code (.claude/)"
echo "[2] OpenAI Codex CLI (AGENTS.md)"
echo "[3] Cursor (.cursorrules)"
echo "[4] All (모두 설치)"
echo "[x] 취소"
echo ""
read -p "선택: " choice

case $choice in
    1)
        echo ""
        echo -e "${YELLOW}📦 Claude Code 어댑터 설치 중...${NC}"
        mkdir -p .claude/agents .claude/skills
        curl -sL "${RAVEN_REPO}/.claude/agents/raven-gtd.md" -o .claude/agents/raven-gtd.md
        curl -sL "${RAVEN_REPO}/.claude/agents/raven-init.md" -o .claude/agents/raven-init.md
        curl -sL "${RAVEN_REPO}/.claude/agents/raven-coding.md" -o .claude/agents/raven-coding.md
        curl -sL "${RAVEN_REPO}/.claude/agents/raven-tester.md" -o .claude/agents/raven-tester.md
        curl -sL "${RAVEN_REPO}/.claude/skills/raven-gtd.md" -o .claude/skills/raven-gtd.md
        curl -sL "${RAVEN_REPO}/.claude/skills/raven-init.md" -o .claude/skills/raven-init.md
        curl -sL "${RAVEN_REPO}/.claude/skills/raven-code.md" -o .claude/skills/raven-code.md
        curl -sL "${RAVEN_REPO}/.claude/skills/raven-test.md" -o .claude/skills/raven-test.md
        echo -e "${GREEN}✅ Claude Code 어댑터 설치 완료${NC}"
        echo "   사용법: /raven-gtd, /raven-init, /raven-code, /raven-test"
        ;;
    2)
        echo ""
        echo -e "${YELLOW}📦 Codex 어댑터 설치 중...${NC}"
        curl -sL "${RAVEN_REPO}/adapters/codex/AGENTS.md" -o AGENTS.md
        echo -e "${GREEN}✅ Codex 어댑터 설치 완료${NC}"
        echo "   AGENTS.md가 프로젝트 루트에 생성되었습니다."
        ;;
    3)
        echo ""
        echo -e "${YELLOW}📦 Cursor 어댑터 설치 중...${NC}"
        curl -sL "${RAVEN_REPO}/adapters/cursor/.cursorrules" -o .cursorrules
        echo -e "${GREEN}✅ Cursor 어댑터 설치 완료${NC}"
        echo "   .cursorrules가 프로젝트 루트에 생성되었습니다."
        echo "   Cursor를 재시작하세요."
        ;;
    4)
        echo ""
        echo -e "${YELLOW}📦 모든 어댑터 설치 중...${NC}"

        # Claude Code
        mkdir -p .claude/agents .claude/skills
        curl -sL "${RAVEN_REPO}/.claude/agents/raven-gtd.md" -o .claude/agents/raven-gtd.md
        curl -sL "${RAVEN_REPO}/.claude/agents/raven-init.md" -o .claude/agents/raven-init.md
        curl -sL "${RAVEN_REPO}/.claude/agents/raven-coding.md" -o .claude/agents/raven-coding.md
        curl -sL "${RAVEN_REPO}/.claude/agents/raven-tester.md" -o .claude/agents/raven-tester.md
        curl -sL "${RAVEN_REPO}/.claude/skills/raven-gtd.md" -o .claude/skills/raven-gtd.md
        curl -sL "${RAVEN_REPO}/.claude/skills/raven-init.md" -o .claude/skills/raven-init.md
        curl -sL "${RAVEN_REPO}/.claude/skills/raven-code.md" -o .claude/skills/raven-code.md
        curl -sL "${RAVEN_REPO}/.claude/skills/raven-test.md" -o .claude/skills/raven-test.md
        echo "  ✓ Claude Code"

        # Codex
        curl -sL "${RAVEN_REPO}/adapters/codex/AGENTS.md" -o AGENTS.md
        echo "  ✓ Codex (AGENTS.md)"

        # Cursor
        curl -sL "${RAVEN_REPO}/adapters/cursor/.cursorrules" -o .cursorrules
        echo "  ✓ Cursor (.cursorrules)"

        echo ""
        echo -e "${GREEN}✅ 모든 어댑터 설치 완료${NC}"
        ;;
    x|X)
        echo "취소됨"
        exit 0
        ;;
    *)
        echo "잘못된 선택입니다."
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}🪶 Nevermore shall you code alone${NC}"
