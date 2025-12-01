---
name: MCP로그
description: MCP 서버 로그 확인 및 분석
---

# 📝 MCP 로그 (MCP Logs)

MCP 서버의 로그를 확인하고 분석합니다!

## 🔍 로그 빠른 확인

### 오늘의 로그

```bash
echo "📋 오늘의 MCP 로그"
echo ""

# 모니터링 로그
LOG_DATE=$(date +%Y-%m-%d)

if [ -f ".claude/logs/mcp-monitor_${LOG_DATE}.log" ]; then
    echo "🔍 모니터링 로그:"
    tail -20 ".claude/logs/mcp-monitor_${LOG_DATE}.log"
else
    echo "  오늘의 모니터링 로그가 없습니다"
fi

echo ""

# 헬스체크 로그
if [ -f ".claude/logs/mcp-health_${LOG_DATE}.log" ]; then
    echo "🏥 헬스체크 로그:"
    tail -20 ".claude/logs/mcp-health_${LOG_DATE}.log"
else
    echo "  오늘의 헬스체크 로그가 없습니다"
fi

echo ""

# 에러 로그
if [ -f ".claude/logs/mcp-errors.log" ]; then
    echo "❌ 에러 로그:"
    tail -20 ".claude/logs/mcp-errors.log"
else
    echo "  ✅ 에러가 없습니다!"
fi
```

### 실시간 로그 (tail -f)

```bash
echo "📡 실시간 로그 모니터링 시작..."
echo "   Ctrl+C로 종료"
echo ""

# 여러 로그를 동시에 모니터링
tail -f .claude/logs/mcp-monitor_$(date +%Y-%m-%d).log \
       .claude/logs/mcp-errors.log 2>/dev/null
```

## 📊 로그 분석

### 에러 통계

```bash
echo "📊 MCP 에러 통계 (최근 7일)"
echo ""

for i in {0..6}; do
    LOG_DATE=$(date -d "$i days ago" +%Y-%m-%d 2>/dev/null || date -v-${i}d +%Y-%m-%d)
    LOG_FILE=".claude/logs/mcp-monitor_${LOG_DATE}.log"

    if [ -f "$LOG_FILE" ]; then
        ERROR_COUNT=$(grep -c "FAIL\|ERROR\|WARN" "$LOG_FILE" 2>/dev/null || echo 0)
        echo "  $LOG_DATE: $ERROR_COUNT 건"
    fi
done
```

### 성능 분석

```bash
echo "📈 MCP 서버 성능 분석"
echo ""

# 평균 응답 시간
if [ -f ".claude/logs/mcp-monitor_$(date +%Y-%m-%d).log" ]; then
    echo "⏱️  응답 시간 통계:"
    grep "응답 시간" .claude/logs/mcp-monitor_$(date +%Y-%m-%d).log | \
    awk '{print $NF}' | \
    sed 's/초//' | \
    awk '{sum+=$1; count++} END {
        if (count > 0) {
            printf "  평균: %.2f초\n", sum/count;
            printf "  총 요청: %d건\n", count
        }
    }'
fi

echo ""

# CPU/메모리 사용량
echo "💻 리소스 사용량:"
grep "CPU:\|메모리:" .claude/logs/mcp-monitor_$(date +%Y-%m-%d).log 2>/dev/null | tail -5
```

## 🔧 로그 레벨별 확인

### INFO 레벨

```bash
echo "ℹ️  INFO 레벨 로그"
grep "INFO" .claude/logs/mcp-monitor_$(date +%Y-%m-%d).log 2>/dev/null | tail -10
```

### WARNING 레벨

```bash
echo "⚠️  WARNING 레벨 로그"
grep "WARN" .claude/logs/mcp-monitor_$(date +%Y-%m-%d).log 2>/dev/null | tail -10
```

### ERROR 레벨

```bash
echo "❌ ERROR 레벨 로그"
grep "ERROR\|FAIL" .claude/logs/mcp-monitor_$(date +%Y-%m-%d).log 2>/dev/null | tail -10
```

## 📅 날짜별 로그

### 특정 날짜 로그 보기

```bash
# 날짜 입력 (예: 2025-11-16)
read -p "날짜 입력 (YYYY-MM-DD): " TARGET_DATE

echo "📋 $TARGET_DATE 로그"
echo ""

# 모니터링 로그
if [ -f ".claude/logs/mcp-monitor_${TARGET_DATE}.log" ]; then
    cat ".claude/logs/mcp-monitor_${TARGET_DATE}.log"
else
    echo "  해당 날짜의 로그가 없습니다"
fi
```

### 최근 7일 로그 요약

```bash
echo "📅 최근 7일 로그 요약"
echo ""

for i in {0..6}; do
    LOG_DATE=$(date -d "$i days ago" +%Y-%m-%d 2>/dev/null || date -v-${i}d +%Y-%m-%d)
    LOG_FILE=".claude/logs/mcp-monitor_${LOG_DATE}.log"

    if [ -f "$LOG_FILE" ]; then
        TOTAL_LINES=$(wc -l < "$LOG_FILE")
        ERROR_COUNT=$(grep -c "FAIL\|ERROR" "$LOG_FILE" 2>/dev/null || echo 0)

        echo "📆 $LOG_DATE"
        echo "  총 로그: $TOTAL_LINES 줄"
        echo "  에러: $ERROR_COUNT 건"
        echo ""
    fi
done
```

## 🔍 로그 검색

### 키워드 검색

```bash
read -p "검색할 키워드: " KEYWORD

echo "🔍 '$KEYWORD' 검색 결과"
echo ""

# 모든 로그 파일에서 검색
grep -r "$KEYWORD" .claude/logs/mcp-*.log 2>/dev/null | head -20
```

### 시간대별 검색

```bash
read -p "시작 시간 (HH:MM): " START_TIME
read -p "종료 시간 (HH:MM): " END_TIME

echo "🕐 $START_TIME ~ $END_TIME 로그"
echo ""

awk -v start="$START_TIME" -v end="$END_TIME" '
    $2 >= start && $2 <= end {print}
' .claude/logs/mcp-monitor_$(date +%Y-%m-%d).log
```

## 📊 로그 시각화

### 시간대별 이벤트 분포

```bash
echo "📊 시간대별 이벤트 분포 (최근 24시간)"
echo ""

for hour in {00..23}; do
    COUNT=$(grep "^\\[.*${hour}:" .claude/logs/mcp-monitor_$(date +%Y-%m-%d).log 2>/dev/null | wc -l)
    BAR=$(printf '▓%.0s' $(seq 1 $((COUNT / 10))))
    printf "%s:00 [%3d] %s\n" "$hour" "$COUNT" "$BAR"
done
```

### 에러 타입 분포

```bash
echo "📊 에러 타입 분포"
echo ""

echo "연결 에러:"
grep -c "연결 실패\|connection failed" .claude/logs/mcp-errors.log 2>/dev/null || echo "0"

echo "타임아웃:"
grep -c "타임아웃\|timeout" .claude/logs/mcp-errors.log 2>/dev/null || echo "0"

echo "인증 에러:"
grep -c "인증 실패\|authentication failed" .claude/logs/mcp-errors.log 2>/dev/null || echo "0"

echo "기타 에러:"
grep -c "ERROR" .claude/logs/mcp-errors.log 2>/dev/null || echo "0"
```

## 🧹 로그 관리

### 로그 파일 크기 확인

```bash
echo "📁 로그 파일 크기"
echo ""

du -h .claude/logs/mcp-*.log 2>/dev/null | sort -hr
echo ""

TOTAL_SIZE=$(du -sh .claude/logs/ 2>/dev/null | awk '{print $1}')
echo "전체 로그 크기: $TOTAL_SIZE"
```

### 오래된 로그 정리

```bash
echo "🧹 30일 이상 된 로그 정리 중..."

# 30일 이상 된 로그 파일 삭제
find .claude/logs/ -name "mcp-*.log" -mtime +30 -delete

echo "✅ 정리 완료!"
```

### 로그 압축

```bash
echo "📦 로그 압축 중..."

# 7일 이상 된 로그를 압축
find .claude/logs/ -name "mcp-*.log" -mtime +7 -exec gzip {} \;

echo "✅ 압축 완료!"
ls -lh .claude/logs/*.gz 2>/dev/null
```

## 📤 로그 내보내기

### 로그를 파일로 저장

```bash
read -p "내보낼 파일명: " OUTPUT_FILE

echo "📤 로그 내보내기 중..."

# 최근 7일 로그를 하나의 파일로
cat .claude/logs/mcp-monitor_*.log > "$OUTPUT_FILE"

echo "✅ 로그를 $OUTPUT_FILE 에 저장했습니다"
ls -lh "$OUTPUT_FILE"
```

### 에러만 추출

```bash
echo "📤 에러 로그만 추출 중..."

grep "ERROR\|FAIL" .claude/logs/mcp-*.log > mcp-errors-summary.txt

echo "✅ 에러 로그를 mcp-errors-summary.txt 에 저장했습니다"
wc -l mcp-errors-summary.txt
```

## 🎯 고급 분석

### 자동 로그 분석

```bash
/agent mcp-server-manager "
MCP 로그 자동 분석:
- 최근 7일 로그 분석
- 에러 패턴 식별
- 성능 병목 지점 발견
- 개선 방안 제시
"
```

### 이상 탐지

```bash
echo "🔍 이상 패턴 탐지 중..."

# 비정상적으로 높은 CPU 사용량
echo "⚠️  높은 CPU 사용량 (80% 이상):"
grep "CPU:" .claude/logs/mcp-monitor_$(date +%Y-%m-%d).log | \
awk -F'CPU: |%' '$2 > 80 {print}'

# 느린 응답 시간
echo ""
echo "⚠️  느린 응답 (2초 이상):"
grep "응답 시간" .claude/logs/mcp-monitor_$(date +%Y-%m-%d).log | \
awk -F': |초' '$2 > 2.0 {print}'

# 연속된 에러
echo ""
echo "⚠️  연속 에러 (3회 이상):"
grep "ERROR" .claude/logs/mcp-errors.log | \
awk '{print $1, $2}' | uniq -c | awk '$1 >= 3 {print}'
```

## 📧 알림 설정

### 에러 발생 시 알림

```bash
# hooks/mcp-error-alert.sh 생성
cat > hooks/mcp-error-alert.sh << 'EOF'
#!/bin/bash
# MCP 에러 발생 시 알림

ERROR_COUNT=$(grep -c "ERROR" .claude/logs/mcp-errors.log 2>/dev/null || echo 0)

if [ "$ERROR_COUNT" -gt 10 ]; then
    echo "🚨 경고: MCP 서버 에러가 $ERROR_COUNT 건 발생했습니다!"
    echo "💡 /MCP로그 명령어로 확인하세요"
fi
EOF

chmod +x hooks/mcp-error-alert.sh
```

---

**💡 팁**: 로그는 자동으로 날짜별로 분류되며, 오래된 로그는 자동으로 압축됩니다!
