#!/bin/bash
# Session start hook
# This script runs when a Claude Code session starts

echo "🚀 Claude Code 세션 시작..."
echo ""

# 1. 컨텍스트 관리 - 이전 세션 정보 확인
if [ -d ".claude/session-data" ]; then
    LAST_SESSION=$(ls -t .claude/session-data/session_*.txt 2>/dev/null | head -1)
    if [ -n "$LAST_SESSION" ]; then
        echo "📂 이전 세션 발견: $(basename $LAST_SESSION)"
        echo "   이전 작업을 계속하려면 해당 파일을 확인하세요"
    fi
else
    mkdir -p .claude/session-data
fi

# 2. 환경 변수 파일 확인
if [ -f ".env" ]; then
    echo "📋 환경 변수 파일 감지됨 (.env)"
    # 보안상 export 하지 않음, 알림만
fi

# 3. Python 버전 확인
if command -v python &> /dev/null; then
    PYTHON_VERSION=$(python --version 2>&1)
    echo "🐍 $PYTHON_VERSION"
fi

# 4. 가상환경 확인
if [ -d ".venv" ]; then
    echo "✅ 가상환경 발견 (.venv/)"
elif [ -d "venv" ]; then
    echo "✅ 가상환경 발견 (venv/)"
else
    echo "⚠️  가상환경이 없습니다. 생성을 권장합니다:"
    echo "   python -m venv .venv"
fi

# 5. Git 저장소 확인
if [ -d ".git" ]; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
    echo "📦 Git 저장소: 브랜치 '$BRANCH'"

    # 6. 커밋되지 않은 변경사항 확인
    CHANGES=$(git status --short | wc -l)
    if [ "$CHANGES" -gt 0 ]; then
        echo "📝 커밋되지 않은 변경사항: $CHANGES 개 파일"
        echo "   /현황파악 명령어로 상세 확인 가능"
    fi
fi

# 7. 컨텍스트 사용 권장사항
echo ""
echo "💡 컨텍스트 관리 팁:"
echo "   - 작업 시작: /현황파악으로 현재 상태 확인"
echo "   - 토큰 확인: /컨텍스트관리로 사용량 체크"
echo "   - 정기 정리: 2-3시간마다 /compact 실행 권장"
echo ""

# 8. 현재 세션 시작 시간 기록
echo "$(date +"%Y-%m-%d %H:%M:%S") - 세션 시작" > .claude/session-data/current-session.txt

echo "✅ 세션 초기화 완료"
exit 0
