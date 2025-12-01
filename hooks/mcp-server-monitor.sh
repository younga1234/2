#!/bin/bash
# MCP 서버 자동 모니터링 훅
# MCP 서버 상태를 확인하고 문제 발생 시 자동 복구

MCP_LOG=".claude/logs/mcp-monitor_$(date +%Y-%m-%d).log"
MCP_CONFIG=".claude/mcp-servers.json"
mkdir -p .claude/logs

log_mcp() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> "$MCP_LOG"
}

echo "🔍 MCP 서버 상태 확인 중..."

# MCP 서버 설정 파일 확인
if [ ! -f "$MCP_CONFIG" ]; then
    echo "⚠️  MCP 서버 설정 파일이 없습니다"
    echo "💡 /MCP서버관리 명령어로 설정하세요"
    log_mcp "MCP 설정 파일 없음"
    exit 0
fi

# 설정된 MCP 서버 목록 읽기
if command -v jq &> /dev/null; then
    # jq가 설치되어 있으면 사용
    SERVER_COUNT=$(jq '.mcpServers | length' "$MCP_CONFIG" 2>/dev/null || echo "0")
else
    # jq가 없으면 간단하게 카운트
    SERVER_COUNT=$(grep -c '"command"' "$MCP_CONFIG" 2>/dev/null || echo "0")
fi

if [ "$SERVER_COUNT" -eq 0 ]; then
    echo "ℹ️  등록된 MCP 서버가 없습니다"
    log_mcp "등록된 MCP 서버 없음"
    exit 0
fi

echo "📊 등록된 MCP 서버: $SERVER_COUNT 개"

# 1. Python MCP 서버 확인
echo "  - Python MCP 서버 확인 중..."
if pgrep -f "python.*mcp" > /dev/null 2>&1; then
    PID=$(pgrep -f "python.*mcp" | head -1)
    CPU=$(ps -p $PID -o %cpu= 2>/dev/null | tr -d ' ')
    MEM=$(ps -p $PID -o %mem= 2>/dev/null | tr -d ' ')

    echo "    ✅ Python MCP 서버 실행 중 (PID: $PID)"
    echo "    📈 CPU: ${CPU}% | 메모리: ${MEM}%"
    log_mcp "Python MCP 서버 정상 (PID: $PID, CPU: ${CPU}%, MEM: ${MEM}%)"

    # 리소스 사용량 경고
    if (( $(echo "$CPU > 80" | bc -l 2>/dev/null || echo 0) )); then
        echo "    ⚠️  높은 CPU 사용량 감지"
        log_mcp "경고: Python MCP 서버 높은 CPU 사용량 (${CPU}%)"
    fi
else
    echo "    ℹ️  Python MCP 서버 미실행"
    log_mcp "Python MCP 서버 미실행"
fi

# 2. Node.js MCP 서버 확인
echo "  - Node.js MCP 서버 확인 중..."
if pgrep -f "node.*mcp" > /dev/null 2>&1; then
    PID=$(pgrep -f "node.*mcp" | head -1)
    CPU=$(ps -p $PID -o %cpu= 2>/dev/null | tr -d ' ')
    MEM=$(ps -p $PID -o %mem= 2>/dev/null | tr -d ' ')

    echo "    ✅ Node.js MCP 서버 실행 중 (PID: $PID)"
    echo "    📈 CPU: ${CPU}% | 메모리: ${MEM}%"
    log_mcp "Node.js MCP 서버 정상 (PID: $PID, CPU: ${CPU}%, MEM: ${MEM}%)"
else
    echo "    ℹ️  Node.js MCP 서버 미실행"
    log_mcp "Node.js MCP 서버 미실행"
fi

# 3. MCP 서버 로그 에러 확인
echo "  - MCP 로그 에러 확인 중..."
MCP_ERROR_LOG=".claude/logs/mcp-errors.log"

if [ -f "$MCP_ERROR_LOG" ]; then
    # 최근 10분 이내 에러 확인
    RECENT_ERRORS=$(find "$MCP_ERROR_LOG" -mmin -10 -exec cat {} \; 2>/dev/null | wc -l)

    if [ "$RECENT_ERRORS" -gt 0 ]; then
        echo "    ⚠️  최근 10분간 에러 $RECENT_ERRORS 건 발견"
        echo "    💡 /MCP로그 명령어로 자세히 확인하세요"
        log_mcp "경고: 최근 10분간 MCP 에러 $RECENT_ERRORS 건"
    else
        echo "    ✅ 최근 에러 없음"
    fi
fi

# 4. MCP 도구 응답 시간 확인 (간단한 헬스체크)
echo "  - MCP 도구 응답성 확인 중..."

# 환경변수에서 MCP 서버 URL 가져오기
MCP_SERVER_URL=${MCP_SERVER_URL:-"http://localhost:3000"}

if command -v curl &> /dev/null; then
    # Health check endpoint가 있다면 확인
    RESPONSE_TIME=$(curl -s -o /dev/null -w "%{time_total}" "$MCP_SERVER_URL/health" --max-time 5 2>/dev/null || echo "timeout")

    if [ "$RESPONSE_TIME" != "timeout" ]; then
        echo "    ✅ 서버 응답 시간: ${RESPONSE_TIME}초"
        log_mcp "MCP 서버 응답 시간: ${RESPONSE_TIME}초"

        # 응답 시간 경고 (2초 이상)
        if (( $(echo "$RESPONSE_TIME > 2.0" | bc -l 2>/dev/null || echo 0) )); then
            echo "    ⚠️  느린 응답 시간 감지"
            log_mcp "경고: MCP 서버 느린 응답 (${RESPONSE_TIME}초)"
        fi
    else
        echo "    ⚠️  서버 응답 없음 (타임아웃)"
        log_mcp "경고: MCP 서버 응답 없음"
    fi
fi

# 5. 자동 복구 시도 (옵션)
AUTO_RECOVERY=${MCP_AUTO_RECOVERY:-false}

if [ "$AUTO_RECOVERY" = "true" ]; then
    echo ""
    echo "🔧 자동 복구 모드 활성화"

    # MCP 서버가 죽었을 때 자동 재시작
    if ! pgrep -f "python.*mcp" > /dev/null 2>&1 && \
       ! pgrep -f "node.*mcp" > /dev/null 2>&1; then

        echo "⚠️  MCP 서버가 실행 중이지 않습니다"
        echo "🔄 자동 재시작 시도 중..."
        log_mcp "자동 복구: MCP 서버 재시작 시도"

        # 재시작 스크립트가 있다면 실행
        if [ -f "scripts/start-mcp-server.sh" ]; then
            bash scripts/start-mcp-server.sh &
            echo "✅ MCP 서버 재시작 완료"
            log_mcp "자동 복구: MCP 서버 재시작 성공"
        else
            echo "❌ 재시작 스크립트를 찾을 수 없습니다"
            log_mcp "자동 복구 실패: 재시작 스크립트 없음"
        fi
    fi
fi

echo ""
echo "✅ MCP 서버 모니터링 완료!"
echo "📝 로그: $MCP_LOG"

exit 0
