#!/bin/bash
# MCP 서버 헬스체크 훅
# 주기적으로 MCP 서버 건강 상태를 확인하고 문제 발견 시 알림

HEALTH_LOG=".claude/logs/mcp-health_$(date +%Y-%m-%d).log"
mkdir -p .claude/logs

log_health() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> "$HEALTH_LOG"
}

echo "🏥 MCP 서버 헬스체크 시작..."

# 체크 항목 초기화
ALL_CHECKS_PASSED=true

# 1. 프로세스 존재 확인
check_process() {
    local process_name=$1
    local display_name=$2

    if pgrep -f "$process_name" > /dev/null 2>&1; then
        echo "  ✅ $display_name 프로세스 정상"
        log_health "OK: $display_name 프로세스 실행 중"
        return 0
    else
        echo "  ❌ $display_name 프로세스 미실행"
        log_health "FAIL: $display_name 프로세스 없음"
        ALL_CHECKS_PASSED=false
        return 1
    fi
}

# 2. 포트 리스닝 확인
check_port() {
    local port=$1
    local service=$2

    if command -v lsof &> /dev/null; then
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            echo "  ✅ $service 포트 $port 리스닝 중"
            log_health "OK: $service 포트 $port 활성"
            return 0
        else
            echo "  ⚠️  $service 포트 $port 리스닝 안 함"
            log_health "WARN: $service 포트 $port 비활성"
            ALL_CHECKS_PASSED=false
            return 1
        fi
    else
        echo "  ℹ️  lsof 미설치 - 포트 확인 건너뜀"
        return 0
    fi
}

# 3. HTTP 엔드포인트 응답 확인
check_http_endpoint() {
    local url=$1
    local service=$2
    local max_time=${3:-5}

    if command -v curl &> /dev/null; then
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$url" --max-time $max_time 2>/dev/null || echo "000")

        if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "204" ]; then
            echo "  ✅ $service HTTP 응답 정상 (${HTTP_CODE})"
            log_health "OK: $service HTTP 상태 ${HTTP_CODE}"
            return 0
        else
            echo "  ❌ $service HTTP 응답 실패 (${HTTP_CODE})"
            log_health "FAIL: $service HTTP 상태 ${HTTP_CODE}"
            ALL_CHECKS_PASSED=false
            return 1
        fi
    else
        echo "  ℹ️  curl 미설치 - HTTP 확인 건너뜀"
        return 0
    fi
}

# 4. 파일 존재 확인
check_file() {
    local file=$1
    local description=$2

    if [ -f "$file" ]; then
        echo "  ✅ $description 존재"
        log_health "OK: $description ($file)"
        return 0
    else
        echo "  ⚠️  $description 없음"
        log_health "WARN: $description 없음 ($file)"
        return 1
    fi
}

# 5. 디스크 공간 확인
check_disk_space() {
    local min_space_mb=${1:-100}

    AVAILABLE_SPACE=$(df -m . | awk 'NR==2 {print $4}')

    if [ "$AVAILABLE_SPACE" -gt "$min_space_mb" ]; then
        echo "  ✅ 디스크 공간 충분 (${AVAILABLE_SPACE}MB 사용 가능)"
        log_health "OK: 디스크 공간 ${AVAILABLE_SPACE}MB"
        return 0
    else
        echo "  ⚠️  디스크 공간 부족 (${AVAILABLE_SPACE}MB 사용 가능)"
        log_health "WARN: 디스크 공간 부족 ${AVAILABLE_SPACE}MB"
        ALL_CHECKS_PASSED=false
        return 1
    fi
}

# 헬스체크 실행
echo ""
echo "📋 체크 항목:"

# 프로세스 체크
check_process "python.*mcp" "Python MCP 서버"
check_process "node.*mcp" "Node.js MCP 서버"

# 포트 체크 (환경변수에서 가져오기)
MCP_PORT=${MCP_PORT:-3000}
check_port $MCP_PORT "MCP 서버"

# HTTP 엔드포인트 체크
MCP_SERVER_URL=${MCP_SERVER_URL:-"http://localhost:3000"}
check_http_endpoint "$MCP_SERVER_URL/health" "MCP 서버"

# 설정 파일 체크
check_file ".claude/mcp-servers.json" "MCP 설정 파일"
check_file ".env" "환경변수 파일"

# 디스크 공간 체크
check_disk_space 100

echo ""

# 결과 요약
if [ "$ALL_CHECKS_PASSED" = true ]; then
    echo "✅ 모든 헬스체크 통과!"
    log_health "SUCCESS: 모든 헬스체크 통과"
    exit 0
else
    echo "⚠️  일부 헬스체크 실패 - 확인이 필요합니다"
    log_health "FAILURE: 일부 헬스체크 실패"
    echo "💡 /MCP로그 명령어로 자세한 정보를 확인하세요"
    exit 1
fi
