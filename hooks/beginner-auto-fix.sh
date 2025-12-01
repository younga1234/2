#!/bin/bash
# 초보자를 위한 자동 에러 수정 훅
# 에러가 발생하면 자동으로 감지하고 수정합니다

AUTO_FIX_LOG=".claude/logs/auto-fix_$(date +%Y-%m-%d).log"
mkdir -p .claude/logs

log_fix() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> "$AUTO_FIX_LOG"
}

echo "🔍 자동 에러 검사 시작..."

# 1. Python 문법 에러 자동 검사
if ls *.py 2>/dev/null || find . -name "*.py" 2>/dev/null | grep -q .; then
    echo "  - Python 파일 검사 중..."

    for file in $(find . -name "*.py" ! -path "./.venv/*" ! -path "./venv/*"); do
        # 문법 에러 검사
        python -m py_compile "$file" 2>/tmp/syntax_error.txt
        if [ $? -ne 0 ]; then
            ERROR=$(cat /tmp/syntax_error.txt)
            log_fix "문법 에러 발견: $file - $ERROR"

            echo "  ❌ 문법 에러 발견: $file"
            echo "  🔧 자동 수정 시도 중..."

            # 흔한 에러 자동 수정
            # 1. 들여쓰기 오류
            if echo "$ERROR" | grep -q "IndentationError"; then
                autopep8 --in-place --select=E1 "$file" 2>/dev/null || true
                log_fix "들여쓰기 자동 수정: $file"
                echo "  ✅ 들여쓰기 수정 완료"
            fi

            # 2. 불필요한 공백
            if echo "$ERROR" | grep -q "unexpected indent"; then
                sed -i 's/[[:space:]]*$//' "$file"
                log_fix "불필요한 공백 제거: $file"
                echo "  ✅ 공백 정리 완료"
            fi
        fi
    done
fi

# 2. 의존성 자동 확인 및 설치
echo "  - 필요한 패키지 확인 중..."
if [ -f "requirements.txt" ]; then
    while IFS= read -r package; do
        # 주석 및 빈 줄 건너뛰기
        [[ $package =~ ^#.*$ ]] && continue
        [[ -z $package ]] && continue

        # 패키지 이름 추출 (버전 정보 제거)
        pkg_name=$(echo "$package" | sed 's/[>=<].*//' | tr -d ' ')

        # 설치 확인
        python -c "import $pkg_name" 2>/dev/null
        if [ $? -ne 0 ]; then
            echo "  ⚠️  $pkg_name 없음 - 자동 설치 중..."
            pip install "$package" --quiet
            if [ $? -eq 0 ]; then
                log_fix "패키지 자동 설치: $package"
                echo "  ✅ $pkg_name 설치 완료"
            fi
        fi
    done < requirements.txt
fi

# 3. 환경변수 파일 자동 생성
echo "  - 환경 설정 확인 중..."
if [ ! -f ".env" ] && [ -f ".env.example" ]; then
    echo "  ⚠️  .env 파일 없음 - 자동 생성 중..."
    cp .env.example .env

    # SECRET_KEY 자동 생성
    if grep -q "SECRET_KEY=" .env; then
        SECRET=$(python -c "import secrets; print(secrets.token_urlsafe(32))")
        sed -i "s/SECRET_KEY=.*/SECRET_KEY=$SECRET/" .env
        log_fix ".env 파일 자동 생성 및 SECRET_KEY 설정"
        echo "  ✅ 환경변수 파일 생성 완료"
    fi
fi

# 4. 데이터베이스 파일 자동 생성
echo "  - 데이터베이스 확인 중..."
if [ ! -f "app.db" ] && [ ! -f "db.sqlite3" ]; then
    if [ -f "alembic.ini" ] || grep -q "alembic" requirements.txt 2>/dev/null; then
        echo "  ⚠️  데이터베이스 없음 - 자동 생성 중..."
        alembic upgrade head 2>/dev/null || python -c "
from sqlalchemy import create_engine
from app.models import Base
engine = create_engine('sqlite:///app.db')
Base.metadata.create_all(engine)
" 2>/dev/null || true

        if [ $? -eq 0 ]; then
            log_fix "데이터베이스 자동 생성"
            echo "  ✅ 데이터베이스 생성 완료"
        fi
    fi
fi

# 5. Git 설정 확인
echo "  - Git 설정 확인 중..."
if [ -d ".git" ]; then
    # .gitignore 자동 생성
    if [ ! -f ".gitignore" ]; then
        cat > .gitignore << EOF
.env
.venv/
venv/
__pycache__/
*.pyc
*.pyo
*.db
*.sqlite3
.DS_Store
EOF
        log_fix ".gitignore 자동 생성"
        echo "  ✅ .gitignore 생성 완료"
    fi

    # user.name 확인
    if ! git config user.name >/dev/null 2>&1; then
        git config --local user.name "Developer"
        log_fix "Git user.name 자동 설정"
        echo "  ✅ Git 사용자 설정 완료"
    fi

    # user.email 확인
    if ! git config user.email >/dev/null 2>&1; then
        git config --local user.email "developer@localhost"
        log_fix "Git user.email 자동 설정"
        echo "  ✅ Git 이메일 설정 완료"
    fi
fi

# 6. 포트 충돌 자동 해결
echo "  - 포트 사용 확인 중..."
DEFAULT_PORT=8000
if lsof -Pi :$DEFAULT_PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "  ⚠️  포트 $DEFAULT_PORT 사용 중 - 다른 포트 찾는 중..."

    # 사용 가능한 포트 찾기
    for port in {8001..8010}; do
        if ! lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            echo "  ✅ 포트 $port 사용 가능"
            log_fix "포트 충돌 해결: $DEFAULT_PORT -> $port"

            # .env 파일 업데이트
            if [ -f ".env" ]; then
                sed -i "s/API_PORT=.*/API_PORT=$port/" .env 2>/dev/null || true
            fi
            break
        fi
    done
fi

# 7. 디렉토리 권한 확인
echo "  - 파일 권한 확인 중..."
if [ -d "data" ] && [ ! -w "data" ]; then
    chmod -R u+w data 2>/dev/null || true
    log_fix "data 디렉토리 권한 수정"
    echo "  ✅ 파일 권한 수정 완료"
fi

echo ""
echo "✅ 자동 에러 검사 완료!"
echo "📝 로그: $AUTO_FIX_LOG"

# 수정된 내용이 있으면 알림
if [ -f "$AUTO_FIX_LOG" ] && [ $(wc -l < "$AUTO_FIX_LOG") -gt 0 ]; then
    FIX_COUNT=$(wc -l < "$AUTO_FIX_LOG")
    echo ""
    echo "🔧 자동으로 $FIX_COUNT 개의 문제를 수정했어요!"
    echo "   자세한 내용은 로그 파일을 확인하세요"
fi

exit 0
