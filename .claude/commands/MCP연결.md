---
name: MCP연결
description: Claude Code와 MCP 서버 연결 및 도구 사용
---

# 🔌 MCP 연결 (MCP Connection)

Claude Code와 MCP 서버를 연결하고 도구를 사용합니다!

## 🚀 빠른 연결

### 1단계: MCP 서버 설정 확인

```bash
echo "🔍 MCP 서버 설정 확인 중..."

# 설정 파일 존재 확인
if [ -f ".claude/mcp-servers.json" ]; then
    echo "✅ MCP 서버 설정 파일 존재"
    cat .claude/mcp-servers.json
else
    echo "❌ MCP 서버 설정 파일 없음"
    echo "💡 /MCP서버관리 명령어로 먼저 설정하세요"
    exit 1
fi
```

### 2단계: 자동 연결

```bash
# MCP 통합 전문가 에이전트 호출
/agent mcp-integration-specialist "Claude Code와 MCP 서버 자동 연결"
```

자동으로 처리되는 것:
- MCP 서버 시작
- Claude Code 설정 업데이트
- 연결 테스트
- 도구 목록 확인

## 📋 연결 상태 확인

### 연결 테스트

```bash
echo "🧪 MCP 서버 연결 테스트"
echo ""

# 1. 서버 실행 확인
if pgrep -f "mcp" > /dev/null 2>&1; then
    echo "✅ MCP 서버 실행 중"
else
    echo "❌ MCP 서버 미실행 - 먼저 시작하세요"
    exit 1
fi

# 2. HTTP 연결 테스트
MCP_URL=${MCP_SERVER_URL:-"http://localhost:3000"}

if curl -s -f "$MCP_URL/health" > /dev/null 2>&1; then
    echo "✅ HTTP 연결 성공 ($MCP_URL)"
else
    echo "❌ HTTP 연결 실패"
    exit 1
fi

# 3. 도구 목록 가져오기 테스트
TOOLS=$(curl -s "$MCP_URL/tools" 2>/dev/null || echo "{}")

if [ -n "$TOOLS" ] && [ "$TOOLS" != "{}" ]; then
    echo "✅ 도구 목록 조회 성공"
    echo "$TOOLS" | python -m json.tool 2>/dev/null || echo "$TOOLS"
else
    echo "⚠️  도구 목록이 비어있습니다"
fi

echo ""
echo "✅ 모든 연결 테스트 통과!"
```

## 🛠️ MCP 도구 사용

### 사용 가능한 도구 목록 확인

```bash
# /MCP도구목록 명령어 사용
/MCP도구목록

# 또는 직접 확인
curl -s http://localhost:3000/tools | python -m json.tool
```

### 도구 호출 예제

```bash
# 에이전트를 통한 자동 호출
/agent mcp-integration-specialist "file_search 도구로 .py 파일 검색"

# 결과:
# - MCP 도구 자동 발견
# - 최적 도구 선택
# - 파라미터 구성
# - 도구 실행
# - 결과 반환
```

## 🔧 연결 설정

### Claude Code 설정 (.claude/settings.json)

```json
{
  "mcpServers": {
    "my-server": {
      "command": "python",
      "args": ["scripts/mcp-server.py"],
      "env": {
        "MCP_SERVER_PORT": "3000"
      }
    }
  },
  "hooks": {
    "SessionStart": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "bash hooks/mcp-server-monitor.sh"
          }
        ]
      }
    ]
  }
}
```

### 환경변수 설정 (.env)

```bash
# MCP 서버 연결 정보
MCP_SERVER_URL=http://localhost:3000
MCP_SERVER_PORT=3000

# 전송 방식 (stdio 또는 sse)
MCP_TRANSPORT=stdio

# 인증 (필요시)
MCP_API_KEY=your-api-key-here
MCP_AUTH_TOKEN=your-auth-token-here

# 타임아웃 설정
MCP_REQUEST_TIMEOUT=30
MCP_CONNECT_TIMEOUT=10
```

## 📊 도구 사용 예제

### 예제 1: 파일 검색 도구

```bash
# MCP 도구를 통한 파일 검색
/agent mcp-integration-specialist "
MCP file_search 도구 사용:
- 패턴: '*.py'
- 디렉토리: 'src/'
- 재귀 검색: true
"

# 결과:
# {
#   "tool": "file_search",
#   "results": [
#     "src/main.py",
#     "src/config.py",
#     "src/utils.py"
#   ],
#   "count": 3
# }
```

### 예제 2: 데이터베이스 쿼리 도구

```bash
/agent mcp-integration-specialist "
MCP database_query 도구 사용:
- 쿼리: 'SELECT * FROM users LIMIT 10'
- 데이터베이스: 'app.db'
"

# 결과:
# {
#   "tool": "database_query",
#   "rows": [...],
#   "count": 10
# }
```

### 예제 3: API 호출 도구

```bash
/agent mcp-integration-specialist "
MCP api_call 도구 사용:
- URL: 'https://api.github.com/users/anthropics'
- 메소드: 'GET'
- 헤더: {'Accept': 'application/json'}
"

# 결과:
# {
#   "tool": "api_call",
#   "status": 200,
#   "data": {...}
# }
```

## 🔄 자동 재연결

### 연결 끊김 시 자동 복구

```bash
# .claude/settings.json에 추가
{
  "mcpServers": {
    "my-server": {
      "command": "python",
      "args": ["scripts/mcp-server.py"],
      "autoRestart": true,
      "maxRetries": 3,
      "retryDelay": 1000
    }
  }
}
```

### 수동 재연결

```bash
echo "🔄 MCP 서버 재연결 중..."

# 1. 서버 재시작
pkill -f "mcp" 2>/dev/null
sleep 2
python scripts/start-mcp-server.py &

# 2. 연결 대기 (최대 30초)
for i in {1..30}; do
    if curl -s -f http://localhost:3000/health > /dev/null 2>&1; then
        echo "✅ 재연결 성공! (${i}초 소요)"
        break
    fi
    sleep 1
done

# 3. 연결 확인
bash hooks/mcp-health-check.sh
```

## 🛠️ 문제 해결

### 연결이 안 될 때

```bash
# 1. 서버 실행 확인
pgrep -f "mcp" || echo "서버 미실행 - /MCP서버관리로 시작하세요"

# 2. 포트 확인
lsof -Pi :3000 -sTCP:LISTEN || echo "포트 3000이 열려있지 않습니다"

# 3. 방화벽 확인 (필요시)
# sudo ufw allow 3000/tcp

# 4. 로그 확인
cat .claude/logs/mcp-errors.log

# 5. 자동 수정
/agent mcp-integration-specialist "MCP 연결 문제 자동 해결"
```

### 도구가 응답하지 않을 때

```bash
# 1. 타임아웃 증가
export MCP_REQUEST_TIMEOUT=60

# 2. 서버 재시작
/MCP서버관리 # "서버 재시작" 섹션 참조

# 3. 도구별 테스트
curl -X POST http://localhost:3000/tools/file_search \
  -H "Content-Type: application/json" \
  -d '{"pattern": "*.py"}'
```

## 🎯 고급 기능

### 멀티플 MCP 서버 연결

```json
// .claude/settings.json
{
  "mcpServers": {
    "file-server": {
      "command": "python",
      "args": ["scripts/mcp-file-server.py"]
    },
    "db-server": {
      "command": "python",
      "args": ["scripts/mcp-db-server.py"]
    },
    "api-server": {
      "command": "node",
      "args": ["scripts/mcp-api-server.js"]
    }
  }
}
```

### 도구 체이닝 (순차 실행)

```bash
/agent mcp-integration-specialist "
다음 작업을 순서대로 실행:
1. file_search로 모든 .py 파일 찾기
2. 찾은 파일들을 code_analysis 도구로 분석
3. 분석 결과를 report_generator로 리포트 생성
"
```

### 커스텀 도구 개발

```bash
# MCP 도구 개발 에이전트 호출
/agent mcp-tool-builder "
새로운 MCP 도구 개발:
- 이름: custom_scraper
- 기능: 웹페이지 스크래핑
- 입력: URL, CSS selector
- 출력: 추출된 텍스트
"
```

## 📈 연결 모니터링

```markdown
# 🔌 MCP 연결 대시보드

## 연결 상태
- ✅ my-server: 연결됨 (응답 시간: 12ms)
- ✅ db-server: 연결됨 (응답 시간: 8ms)
- ⚠️  api-server: 재연결 중...

## 도구 사용 통계 (최근 1시간)
- file_search: 45 회 (평균 응답: 23ms)
- database_query: 12 회 (평균 응답: 156ms)
- api_call: 28 회 (평균 응답: 892ms)

## 에러 로그
- 14:32 - api_call 타임아웃 (URL: https://slow-api.com)
- 14:15 - database_query 연결 실패 (재시도 성공)

## 알림
- ✅ 모든 서버 정상 작동 중
- 💡 api-server 응답 시간이 개선되었어요 (+30%)
```

---

**💡 팁**: MCP 서버는 세션 시작 시 자동으로 연결되며, 문제 발생 시 자동 재연결됩니다!
