---
name: MCP서버관리
description: MCP 서버 설치, 설정, 시작/중지, 상태 확인 (완전 자동)
---

# 🔧 MCP 서버 관리 (MCP Server Manager)

MCP(Model Context Protocol) 서버를 클릭 한 번으로 관리합니다!

## 🚀 빠른 시작

### 1단계: MCP 서버 자동 설정

```bash
echo "🎯 MCP 서버 자동 설정을 시작합니다..."
echo ""

# MCP 서버 관리 에이전트 호출
/agent mcp-server-manager "MCP 서버 자동 설치 및 설정"
```

자동으로 처리되는 것:
- Python/Node.js MCP 서버 설치
- 환경변수 설정 (.env)
- 설정 파일 생성 (.claude/mcp-servers.json)
- 첫 실행 및 테스트

## 📋 MCP 서버 상태 확인

### 실시간 상태 체크

```bash
echo "📊 MCP 서버 상태 확인"
echo ""

# 프로세스 확인
if pgrep -f "python.*mcp" > /dev/null 2>&1; then
    PID=$(pgrep -f "python.*mcp")
    echo "✅ Python MCP 서버 실행 중 (PID: $PID)"
    ps -p $PID -o pid,ppid,%cpu,%mem,etime,cmd
else
    echo "❌ Python MCP 서버 미실행"
fi

if pgrep -f "node.*mcp" > /dev/null 2>&1; then
    PID=$(pgrep -f "node.*mcp")
    echo "✅ Node.js MCP 서버 실행 중 (PID: $PID)"
    ps -p $PID -o pid,ppid,%cpu,%mem,etime,cmd
else
    echo "❌ Node.js MCP 서버 미실행"
fi

# 포트 확인
echo ""
echo "🔌 포트 사용 현황:"
lsof -Pi :3000-3010 -sTCP:LISTEN 2>/dev/null || echo "  포트 3000-3010 사용 안 함"

# 설정 파일 확인
echo ""
echo "📁 설정 파일:"
[ -f ".claude/mcp-servers.json" ] && echo "  ✅ .claude/mcp-servers.json" || echo "  ❌ .claude/mcp-servers.json 없음"
[ -f ".env" ] && echo "  ✅ .env" || echo "  ❌ .env 없음"
```

### 헬스체크 (자동)

```bash
bash hooks/mcp-health-check.sh
```

## ⚙️ MCP 서버 제어

### 서버 시작

```bash
echo "🚀 MCP 서버 시작 중..."

# Python MCP 서버 시작
if [ -f "scripts/start-mcp-server.py" ]; then
    python scripts/start-mcp-server.py &
    echo "✅ Python MCP 서버 시작됨"
fi

# Node.js MCP 서버 시작
if [ -f "scripts/start-mcp-server.js" ]; then
    node scripts/start-mcp-server.js &
    echo "✅ Node.js MCP 서버 시작됨"
fi

# 시작 확인 (3초 대기)
sleep 3
bash hooks/mcp-health-check.sh
```

### 서버 중지

```bash
echo "🛑 MCP 서버 중지 중..."

# Python MCP 서버 중지
if pgrep -f "python.*mcp" > /dev/null 2>&1; then
    pkill -f "python.*mcp"
    echo "✅ Python MCP 서버 중지됨"
fi

# Node.js MCP 서버 중지
if pgrep -f "node.*mcp" > /dev/null 2>&1; then
    pkill -f "node.*mcp"
    echo "✅ Node.js MCP 서버 중지됨"
fi

echo "✅ 모든 MCP 서버 중지 완료"
```

### 서버 재시작

```bash
echo "🔄 MCP 서버 재시작 중..."

# 중지
pkill -f "python.*mcp" 2>/dev/null
pkill -f "node.*mcp" 2>/dev/null
sleep 2

# 시작
if [ -f "scripts/start-mcp-server.py" ]; then
    python scripts/start-mcp-server.py &
fi

if [ -f "scripts/start-mcp-server.js" ]; then
    node scripts/start-mcp-server.js &
fi

sleep 3
echo "✅ MCP 서버 재시작 완료"
bash hooks/mcp-health-check.sh
```

## 🔧 설정 관리

### MCP 서버 설정 파일 (.claude/mcp-servers.json)

```json
{
  "mcpServers": {
    "my-python-server": {
      "command": "python",
      "args": ["scripts/mcp-server.py"],
      "env": {
        "MCP_SERVER_PORT": "3000",
        "MCP_LOG_LEVEL": "info"
      }
    },
    "my-node-server": {
      "command": "node",
      "args": ["scripts/mcp-server.js"],
      "env": {
        "MCP_SERVER_PORT": "3001"
      }
    }
  }
}
```

### 환경변수 (.env)

```bash
# MCP 서버 설정
MCP_SERVER_URL=http://localhost:3000
MCP_SERVER_PORT=3000
MCP_LOG_LEVEL=info
MCP_AUTO_RECOVERY=true

# API 키 (필요시)
MCP_API_KEY=your-api-key-here
```

## 📊 모니터링

### 자동 모니터링 활성화

```bash
# hooks/mcp-server-monitor.sh 실행
bash hooks/mcp-server-monitor.sh

# 결과:
# - 서버 프로세스 상태
# - CPU/메모리 사용량
# - 응답 시간
# - 에러 로그 확인
# - 자동 복구 (옵션)
```

### 로그 확인

```bash
# 오늘의 모니터링 로그
cat .claude/logs/mcp-monitor_$(date +%Y-%m-%d).log

# 오늘의 헬스체크 로그
cat .claude/logs/mcp-health_$(date +%Y-%m-%d).log

# 실시간 로그 (tail)
tail -f .claude/logs/mcp-monitor_$(date +%Y-%m-%d).log
```

## 🛠️ 문제 해결

### 서버가 시작되지 않을 때

```bash
# 1. 포트 충돌 확인
lsof -Pi :3000 -sTCP:LISTEN

# 2. 로그 확인
cat .claude/logs/mcp-errors.log

# 3. 자동 수정 시도
/agent mcp-server-manager "MCP 서버 시작 문제 해결"
```

### 연결이 안 될 때

```bash
# 1. 헬스체크 실행
bash hooks/mcp-health-check.sh

# 2. 설정 파일 확인
cat .claude/mcp-servers.json

# 3. 재시작
pkill -f "mcp" && sleep 2 && python scripts/start-mcp-server.py &
```

### 성능 문제

```bash
# CPU/메모리 사용량 확인
ps aux | grep mcp

# 느린 응답 시간 확인
time curl http://localhost:3000/health

# 자동 최적화
/agent mcp-server-manager "MCP 서버 성능 최적화"
```

## 🎯 고급 기능

### 멀티플 MCP 서버 관리

```bash
# 서버 추가
/agent mcp-server-manager "새 MCP 서버 추가 및 설정"

# 모든 서버 상태 확인
for port in {3000..3005}; do
    curl -s http://localhost:$port/health && echo "  ✅ 포트 $port 정상"
done
```

### Docker로 실행

```bash
# Dockerfile 자동 생성
/agent mcp-server-manager "MCP 서버 Docker 컨테이너화"

# Docker Compose로 실행
docker-compose up -d mcp-server

# 상태 확인
docker-compose ps
docker-compose logs -f mcp-server
```

### 자동 재시작 설정 (systemd)

```bash
# systemd 서비스 파일 생성
/agent devops-engineer "MCP 서버 systemd 서비스 생성"

# 서비스 활성화
sudo systemctl enable mcp-server
sudo systemctl start mcp-server
sudo systemctl status mcp-server
```

## 📈 성능 메트릭

```markdown
# 📊 MCP 서버 성능 대시보드

## 실시간 통계
- 요청 수: 1,234 개/시간
- 평균 응답 시간: 45ms
- 에러율: 0.2%
- CPU 사용량: 12%
- 메모리 사용량: 230MB

## 도구별 사용량
- file_search: 567 회
- database_query: 234 회
- api_call: 433 회

## 알림
- ✅ 모든 시스템 정상
- 💡 응답 시간이 빨라졌어요 (+15%)
```

---

**💡 팁**: MCP 서버는 자동으로 모니터링되며, 문제 발생 시 자동 복구됩니다!
