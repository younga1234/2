#!/bin/bash
# Session end hook
# This script runs when a Claude Code session ends

echo "🏁 Claude Code 세션 종료 중..."

# 1. 세션 진행 상황 자동 저장 (선택 사항)
if [ -d ".claude/session-data" ]; then
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

    # 현재 세션 정보 저장
    if [ -f ".claude/session-data/current-session.txt" ]; then
        mv ".claude/session-data/current-session.txt" ".claude/session-data/session_${TIMESTAMP}.txt"
        echo "📝 세션 기록 저장됨: session_${TIMESTAMP}.txt"
    fi
fi

# 2. 임시 파일 정리
echo "🧹 임시 파일 정리 중..."
rm -f /tmp/claude-*.tmp 2>/dev/null || true
rm -f /tmp/test-result.txt 2>/dev/null || true
rm -f /tmp/requirements_check.txt 2>/dev/null || true

# 3. Git 상태 확인 (커밋되지 않은 변경사항 경고)
if [ -d ".git" ]; then
    UNCOMMITTED=$(git status --short | wc -l)
    if [ "$UNCOMMITTED" -gt 0 ]; then
        echo "⚠️  경고: $UNCOMMITTED 개의 커밋되지 않은 변경사항이 있습니다"
        echo "   다음 세션에서 확인하세요: git status"
    fi
fi

# 4. 컨텍스트 사용 통계 (참고용)
if [ -d ".claude" ]; then
    FILE_COUNT=$(find .claude/commands -name "*.md" 2>/dev/null | wc -l)
    echo "📊 프로젝트 통계:"
    echo "   - 슬래시 커맨드: $FILE_COUNT 개"
    echo "   - 훅 스크립트: $(ls hooks/*.sh 2>/dev/null | wc -l) 개"
fi

# 5. 자동 로깅
export EVENT_TYPE="session_end"
bash hooks/auto-logger.sh

# 6. 다음 세션을 위한 힌트
echo ""
echo "💡 다음 세션 시작 시:"
echo "   /현황파악 - 현재 상태 확인"
echo "   /컨텍스트관리 - 토큰 사용량 확인"
echo ""
echo "✅ 세션 종료 완료"
echo "📝 세션 로그: .claude/logs/session_$(date +%Y-%m-%d).log"

exit 0
