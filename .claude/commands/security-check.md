---
name: security-check
description: 보안 취약점 검사 (비밀키, SQL injection, XSS 등)
---

# 보안 검사

## 1. 비밀키 및 민감정보 노출 확인

```bash
# Detect-secrets로 스캔
detect-secrets scan --baseline .secrets.baseline 2>/dev/null || echo "detect-secrets not installed"

# 직접 검색
grep -r "api_key\|password\|secret\|token" src/ --include="*.py" | grep -v "# SAFE" || echo "No suspicious patterns found"
```

## 2. 환경변수 파일 확인

```bash
# .env 파일이 git에 포함되어 있는지 확인
git ls-files | grep -E "\.env$|credentials|secret" && echo "⚠️ WARNING: Sensitive files in git!" || echo "✓ No sensitive files in git"
```

## 3. 의존성 취약점 검사

```bash
# pip-audit 사용 (있는 경우)
python -m pip list --format=json | python -c "import sys, json; print('\n'.join([f\"{p['name']}=={p['version']}\" for p in json.load(sys.stdin)]))" > /tmp/requirements_check.txt
pip-audit -r /tmp/requirements_check.txt 2>/dev/null || echo "pip-audit not available"
```

## 4. 코드 보안 패턴 검사

다음 항목을 `src/` 디렉토리에서 수동으로 확인하세요:

### SQL Injection
```python
# 나쁜 예:
cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")  # ❌

# 좋은 예:
cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))  # ✅
```

### XSS (Cross-Site Scripting)
```python
# 나쁜 예:
html = f"<div>{user_input}</div>"  # ❌

# 좋은 예:
from html import escape
html = f"<div>{escape(user_input)}</div>"  # ✅
```

### 하드코딩된 비밀번호
```python
# 나쁜 예:
API_KEY = "sk-1234567890abcdef"  # ❌

# 좋은 예:
import os
API_KEY = os.getenv("API_KEY")  # ✅
```

### 안전하지 않은 난수 생성
```python
# 나쁜 예:
import random
token = random.randint(1000, 9999)  # ❌

# 좋은 예:
import secrets
token = secrets.token_urlsafe(32)  # ✅
```

## 5. 파일 권한 확인

```bash
find data/ -type f -exec ls -la {} \; 2>/dev/null | grep -E "rw-rw-rw-|rwxrwxrwx" && echo "⚠️ WARNING: Overly permissive file permissions" || echo "✓ File permissions OK"
```

## 6. 보안 검사 결과 보고

다음 형식으로 정리하세요:

### 🔴 Critical (즉시 수정 필요)
- 발견된 심각한 보안 문제

### 🟡 High (빠른 시일 내 수정)
- 중요한 보안 문제

### 🟢 Medium/Low (개선 권장)
- 덜 심각하지만 개선이 필요한 사항

### ✅ 통과한 검사
- 문제가 없는 항목들

### 📋 권장 사항
- 보안 강화를 위한 추가 조치
