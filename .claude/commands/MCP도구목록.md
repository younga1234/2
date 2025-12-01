---
name: MCP도구목록
description: 사용 가능한 MCP 도구 목록 및 사용법
---

# 🛠️ MCP 도구 목록 (MCP Tools List)

사용 가능한 모든 MCP 도구와 사용법을 확인합니다!

## 🔍 도구 목록 자동 조회

```bash
echo "📋 MCP 도구 목록 조회 중..."
echo ""

# MCP 서버에서 도구 목록 가져오기
MCP_URL=${MCP_SERVER_URL:-"http://localhost:3000"}

if curl -s -f "$MCP_URL/tools" > /dev/null 2>&1; then
    echo "✅ 연결 성공 - 도구 목록:"
    echo ""
    curl -s "$MCP_URL/tools" | python -m json.tool
else
    echo "❌ MCP 서버에 연결할 수 없습니다"
    echo "💡 /MCP서버관리로 서버를 먼저 시작하세요"
fi
```

## 📚 주요 도구 카테고리

### 1. 파일 시스템 도구

#### file_search
**설명**: 파일 패턴으로 검색

**사용법**:
```bash
/agent mcp-integration-specialist "
file_search 도구 사용:
- pattern: '*.py'
- directory: 'src/'
- recursive: true
"
```

**파라미터**:
- `pattern` (필수): 파일 패턴 (예: `*.py`, `test_*.js`)
- `directory` (선택): 검색 디렉토리 (기본: 현재 디렉토리)
- `recursive` (선택): 하위 디렉토리 포함 (기본: true)

**응답 예제**:
```json
{
  "tool": "file_search",
  "results": [
    "src/main.py",
    "src/config.py",
    "src/utils.py"
  ],
  "count": 3
}
```

#### file_read
**설명**: 파일 내용 읽기

**사용법**:
```bash
/agent mcp-integration-specialist "
file_read 도구 사용:
- path: 'src/main.py'
- encoding: 'utf-8'
"
```

#### file_write
**설명**: 파일에 내용 쓰기

**사용법**:
```bash
/agent mcp-integration-specialist "
file_write 도구 사용:
- path: 'output.txt'
- content: 'Hello, World!'
- mode: 'w'
"
```

### 2. 데이터베이스 도구

#### database_query
**설명**: SQL 쿼리 실행

**사용법**:
```bash
/agent mcp-integration-specialist "
database_query 도구 사용:
- query: 'SELECT * FROM users LIMIT 10'
- database: 'app.db'
"
```

**파라미터**:
- `query` (필수): SQL 쿼리문
- `database` (선택): 데이터베이스 경로 (기본: DATABASE_URL)
- `params` (선택): 바인딩 파라미터

**응답 예제**:
```json
{
  "tool": "database_query",
  "columns": ["id", "name", "email"],
  "rows": [
    [1, "Alice", "alice@example.com"],
    [2, "Bob", "bob@example.com"]
  ],
  "count": 2
}
```

#### database_schema
**설명**: 데이터베이스 스키마 조회

**사용법**:
```bash
/agent mcp-integration-specialist "
database_schema 도구 사용:
- database: 'app.db'
- table: 'users'
"
```

### 3. API 도구

#### api_call
**설명**: HTTP API 호출

**사용법**:
```bash
/agent mcp-integration-specialist "
api_call 도구 사용:
- url: 'https://api.github.com/users/anthropics'
- method: 'GET'
- headers: {'Accept': 'application/json'}
"
```

**파라미터**:
- `url` (필수): API 엔드포인트
- `method` (선택): HTTP 메소드 (GET, POST, PUT, DELETE 등)
- `headers` (선택): 요청 헤더
- `body` (선택): 요청 본문
- `timeout` (선택): 타임아웃 (기본: 30초)

**응답 예제**:
```json
{
  "tool": "api_call",
  "status": 200,
  "headers": {...},
  "data": {...}
}
```

### 4. 웹 스크래핑 도구

#### web_scrape
**설명**: 웹페이지 스크래핑

**사용법**:
```bash
/agent mcp-integration-specialist "
web_scrape 도구 사용:
- url: 'https://example.com'
- selector: 'h1, p'
- extract: ['text', 'href']
"
```

**파라미터**:
- `url` (필수): 웹페이지 URL
- `selector` (필수): CSS 선택자
- `extract` (선택): 추출할 속성 (text, href, src 등)
- `wait` (선택): JavaScript 로딩 대기 시간

### 5. 데이터 처리 도구

#### json_parse
**설명**: JSON 파싱 및 변환

**사용법**:
```bash
/agent mcp-integration-specialist "
json_parse 도구 사용:
- input: '{\"name\": \"Alice\", \"age\": 30}'
- operation: 'extract'
- path: '$.name'
"
```

#### csv_parse
**설명**: CSV 파일 파싱

**사용법**:
```bash
/agent mcp-integration-specialist "
csv_parse 도구 사용:
- file: 'data.csv'
- delimiter: ','
- has_header: true
"
```

### 6. 코드 분석 도구

#### code_analysis
**설명**: 코드 정적 분석

**사용법**:
```bash
/agent mcp-integration-specialist "
code_analysis 도구 사용:
- file: 'src/main.py'
- checks: ['complexity', 'security', 'style']
"
```

**파라미터**:
- `file` (필수): 분석할 파일
- `checks` (선택): 분석 항목 (complexity, security, style, dependencies)

**응답 예제**:
```json
{
  "tool": "code_analysis",
  "file": "src/main.py",
  "results": {
    "complexity": {"score": 8, "issues": []},
    "security": {"score": 9, "vulnerabilities": []},
    "style": {"score": 10, "violations": []}
  }
}
```

### 7. 유틸리티 도구

#### regex_match
**설명**: 정규표현식 매칭

**사용법**:
```bash
/agent mcp-integration-specialist "
regex_match 도구 사용:
- pattern: '\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\b'
- text: 'Contact us at support@example.com'
- flags: 'i'
"
```

#### hash_generate
**설명**: 해시 생성

**사용법**:
```bash
/agent mcp-integration-specialist "
hash_generate 도구 사용:
- algorithm: 'sha256'
- input: 'Hello, World!'
"
```

## 🎯 도구 사용 패턴

### 패턴 1: 단일 도구 실행

```bash
/agent mcp-integration-specialist "
[도구명] 도구 사용:
- [파라미터1]: [값1]
- [파라미터2]: [값2]
"
```

### 패턴 2: 도구 체이닝 (순차 실행)

```bash
/agent mcp-integration-specialist "
다음 작업을 순서대로 실행:

1. file_search로 모든 .json 파일 찾기
   - pattern: '*.json'

2. 각 파일을 file_read로 읽기

3. json_parse로 유효성 검증

4. 결과를 report_generate로 리포트 생성
"
```

### 패턴 3: 병렬 실행

```bash
/agent mcp-integration-specialist "
다음 작업을 병렬로 실행:

- file_search: src/ 디렉토리에서 .py 파일 검색
- database_query: users 테이블 조회
- api_call: GitHub API로 저장소 정보 가져오기

모든 결과를 종합하여 리포트 생성
"
```

## 📊 도구별 성능 및 사용 통계

```bash
# 도구 사용 통계 확인
curl -s http://localhost:3000/tools/stats | python -m json.tool
```

**응답 예제**:
```json
{
  "stats": {
    "file_search": {
      "total_calls": 234,
      "avg_response_time": "23ms",
      "success_rate": "99.1%"
    },
    "database_query": {
      "total_calls": 89,
      "avg_response_time": "156ms",
      "success_rate": "97.8%"
    },
    "api_call": {
      "total_calls": 156,
      "avg_response_time": "892ms",
      "success_rate": "95.5%"
    }
  }
}
```

## 🛠️ 커스텀 도구 개발

### 새 도구 만들기

```bash
/agent mcp-tool-builder "
새로운 MCP 도구 개발:

이름: image_compress
설명: 이미지 압축 도구
입력:
  - input_path: 입력 이미지 경로
  - output_path: 출력 이미지 경로
  - quality: 압축 품질 (1-100)
출력:
  - original_size: 원본 크기
  - compressed_size: 압축된 크기
  - compression_ratio: 압축률
"
```

## 📋 도구 목록 전체 보기

```bash
# 상세 도구 목록 (설명 포함)
curl -s http://localhost:3000/tools?verbose=true | python -m json.tool

# 도구 이름만 간단히
curl -s http://localhost:3000/tools | python -c "
import sys, json
data = json.load(sys.stdin)
for tool in data.get('tools', []):
    print(f'- {tool[\"name\"]}: {tool.get(\"description\", \"\")}')
"
```

## 🔧 도구 테스트

### 개별 도구 테스트

```bash
# file_search 테스트
curl -X POST http://localhost:3000/tools/file_search \
  -H "Content-Type: application/json" \
  -d '{"pattern": "*.py", "directory": "src/"}'

# database_query 테스트
curl -X POST http://localhost:3000/tools/database_query \
  -H "Content-Type: application/json" \
  -d '{"query": "SELECT COUNT(*) FROM users"}'
```

### 전체 도구 헬스체크

```bash
/agent mcp-server-manager "모든 MCP 도구 헬스체크 실행"
```

---

**💡 팁**: 도구 이름을 잘 모르겠다면 `/MCP연결` 명령어로 자동 발견 기능을 사용하세요!
