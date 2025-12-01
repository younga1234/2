#!/usr/bin/env python3
"""
MCP 서버 예제 (Python)
Model Context Protocol 서버 구현 예제
"""

import os
import sys
import json
import logging
from datetime import datetime
from typing import Dict, List, Any

# FastMCP 설치 필요: pip install fastmcp
try:
    from fastmcp import FastMCP
except ImportError:
    print("❌ FastMCP가 설치되지 않았습니다")
    print("💡 설치: pip install fastmcp")
    sys.exit(1)

# 로깅 설정
logging.basicConfig(
    level=logging.INFO,
    format='[%(asctime)s] %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('.claude/logs/mcp-server.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# MCP 서버 초기화
mcp = FastMCP("Example MCP Server")


# 도구 1: 파일 검색
@mcp.tool()
def file_search(pattern: str, directory: str = ".", recursive: bool = True) -> Dict[str, Any]:
    """
    파일 패턴으로 파일 검색

    Args:
        pattern: 파일 패턴 (예: *.py, test_*.js)
        directory: 검색 디렉토리 (기본: 현재 디렉토리)
        recursive: 하위 디렉토리 포함 여부 (기본: True)

    Returns:
        검색 결과 (파일 목록 및 개수)
    """
    import glob

    logger.info(f"file_search: pattern={pattern}, directory={directory}, recursive={recursive}")

    try:
        # 재귀 검색
        if recursive:
            search_pattern = f"{directory}/**/{pattern}"
            files = glob.glob(search_pattern, recursive=True)
        else:
            search_pattern = f"{directory}/{pattern}"
            files = glob.glob(search_pattern)

        return {
            "tool": "file_search",
            "pattern": pattern,
            "directory": directory,
            "results": files,
            "count": len(files)
        }
    except Exception as e:
        logger.error(f"file_search 에러: {e}")
        return {
            "tool": "file_search",
            "error": str(e),
            "results": [],
            "count": 0
        }


# 도구 2: 파일 읽기
@mcp.tool()
def file_read(path: str, encoding: str = "utf-8") -> Dict[str, Any]:
    """
    파일 내용 읽기

    Args:
        path: 파일 경로
        encoding: 인코딩 (기본: utf-8)

    Returns:
        파일 내용
    """
    logger.info(f"file_read: path={path}, encoding={encoding}")

    try:
        with open(path, 'r', encoding=encoding) as f:
            content = f.read()

        return {
            "tool": "file_read",
            "path": path,
            "content": content,
            "size": len(content),
            "lines": content.count('\n') + 1
        }
    except Exception as e:
        logger.error(f"file_read 에러: {e}")
        return {
            "tool": "file_read",
            "error": str(e)
        }


# 도구 3: JSON 파싱
@mcp.tool()
def json_parse(input: str, operation: str = "parse") -> Dict[str, Any]:
    """
    JSON 파싱 및 변환

    Args:
        input: JSON 문자열 또는 파일 경로
        operation: 작업 (parse, validate, prettify)

    Returns:
        파싱 결과
    """
    logger.info(f"json_parse: operation={operation}")

    try:
        # 파일인지 확인
        if os.path.isfile(input):
            with open(input, 'r') as f:
                data = json.load(f)
        else:
            data = json.loads(input)

        if operation == "parse":
            return {
                "tool": "json_parse",
                "operation": operation,
                "data": data,
                "valid": True
            }
        elif operation == "validate":
            return {
                "tool": "json_parse",
                "operation": operation,
                "valid": True,
                "message": "유효한 JSON입니다"
            }
        elif operation == "prettify":
            pretty = json.dumps(data, indent=2, ensure_ascii=False)
            return {
                "tool": "json_parse",
                "operation": operation,
                "result": pretty
            }
    except Exception as e:
        logger.error(f"json_parse 에러: {e}")
        return {
            "tool": "json_parse",
            "error": str(e),
            "valid": False
        }


# 리소스: 프로젝트 파일
@mcp.resource("file://{path}")
def get_file_resource(path: str) -> str:
    """
    파일 리소스 제공

    Args:
        path: 파일 경로

    Returns:
        파일 내용
    """
    logger.info(f"리소스 요청: file://{path}")

    try:
        with open(path, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        logger.error(f"리소스 에러: {e}")
        return f"Error: {e}"


# 프롬프트: 코드 리뷰 템플릿
@mcp.prompt()
def code_review_template(file_path: str) -> str:
    """
    코드 리뷰 프롬프트 템플릿

    Args:
        file_path: 리뷰할 파일 경로

    Returns:
        프롬프트 문자열
    """
    return f"""
다음 코드를 리뷰해주세요:

파일: {file_path}

체크 항목:
1. 코드 품질 (가독성, 유지보수성)
2. 베스트 프랙티스 준수
3. 잠재적 버그
4. 성능 개선 기회
5. 보안 취약점

리뷰 결과를 제공해주세요.
"""


# Health check 엔드포인트
@mcp.tool()
def health_check() -> Dict[str, Any]:
    """
    서버 건강 상태 확인

    Returns:
        서버 상태 정보
    """
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "version": "1.0.0",
        "tools": ["file_search", "file_read", "json_parse", "health_check"]
    }


# 서버 시작
if __name__ == "__main__":
    # 환경변수에서 포트 가져오기
    port = int(os.getenv("MCP_SERVER_PORT", "3000"))

    logger.info("=" * 60)
    logger.info("🚀 MCP 서버 시작")
    logger.info(f"📡 포트: {port}")
    logger.info(f"🛠️  도구: file_search, file_read, json_parse, health_check")
    logger.info("=" * 60)

    # 서버 실행
    mcp.run(transport="stdio")
