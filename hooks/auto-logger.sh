#!/bin/bash
# Auto-logger hook
# 모든 요청과 답변을 자동으로 로그에 기록

LOG_DIR=".claude/logs"
mkdir -p "$LOG_DIR"

# 날짜별 로그 파일
DATE=$(date +"%Y-%m-%d")
LOG_FILE="$LOG_DIR/session_${DATE}.log"

# 타임스탬프
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# 로그 항목 추가
log_entry() {
    local EVENT_TYPE="$1"
    local MESSAGE="$2"

    echo "[$TIMESTAMP] [$EVENT_TYPE] $MESSAGE" >> "$LOG_FILE"
}

# 이벤트 타입에 따라 로그 기록
case "${EVENT_TYPE:-}" in
    "session_start")
        log_entry "SESSION_START" "새 세션 시작"
        log_entry "INFO" "작업 디렉토리: $(pwd)"
        log_entry "INFO" "Git 브랜치: $(git branch --show-current 2>/dev/null || echo 'N/A')"
        ;;

    "session_end")
        log_entry "SESSION_END" "세션 종료"
        CHANGES=$(git status --short 2>/dev/null | wc -l)
        log_entry "INFO" "커밋되지 않은 변경사항: $CHANGES 개"
        ;;

    "compact")
        log_entry "COMPACT" "컨텍스트 압축 실행"
        log_entry "INFO" "압축 전 세션 상태 저장됨"
        ;;

    "command")
        COMMAND_NAME="${1:-unknown}"
        log_entry "COMMAND" "슬래시 커맨드 실행: /$COMMAND_NAME"
        ;;

    "agent")
        AGENT_NAME="${1:-unknown}"
        log_entry "AGENT" "에이전트 실행: $AGENT_NAME"
        ;;

    "git_commit")
        COMMIT_MSG="${1:-no message}"
        log_entry "GIT_COMMIT" "커밋 실행: $COMMIT_MSG"
        ;;

    *)
        log_entry "INFO" "${1:-Event logged}"
        ;;
esac

# 로그 파일 크기 관리 (10MB 초과 시 아카이브)
LOG_SIZE=$(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)
if [ "$LOG_SIZE" -gt 10485760 ]; then
    ARCHIVE_FILE="$LOG_DIR/archive/session_${DATE}_$(date +%H%M%S).log"
    mkdir -p "$LOG_DIR/archive"
    mv "$LOG_FILE" "$ARCHIVE_FILE"
    log_entry "ARCHIVE" "로그 파일 아카이브됨: $ARCHIVE_FILE"
fi

exit 0
