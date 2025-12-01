# Claude Code Development Environment

A security-first Python development environment with comprehensive Claude Code integration for AI-assisted development workflows.

## Overview

This repository provides a complete Claude Code setup with specialized agents, automated hooks, and workflow commands designed for efficient, secure Python development.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/younga1234/2.git
cd 2

# Set up environment variables
cp .env.example .env  # Edit with your credentials

# Start Claude Code session
claude
```

## Features

### 🤖 Specialized Agents

**23개의 전문화된 에이전트:**

#### Python 개발 전문가 (13개)
- **backend-architect**: FastAPI/Django/Flask 백엔드 아키텍처
- **data-scientist**: pandas/numpy 데이터 분석 및 시각화
- **ml-engineer**: scikit-learn/TensorFlow/PyTorch 머신러닝
- **web-scraper**: BeautifulSoup/Selenium/Scrapy 웹 스크래핑
- **database-expert**: PostgreSQL/MySQL/MongoDB/Redis 데이터베이스
- **api-developer**: REST/GraphQL API 개발 및 문서화
- **async-specialist**: asyncio/aiohttp/Celery 비동기 프로그래밍
- **test-engineer**: pytest/unittest 테스트 자동화
- **devops-engineer**: Docker/CI/CD/배포 자동화
- **performance-optimizer**: 코드 성능 분석 및 최적화
- **security-auditor**: OWASP Top 10 보안 검증
- **code-reviewer**: 코드 품질 및 베스트 프랙티스 검토
- **documentation-writer**: 기술 문서 및 API 문서 작성

#### 초보자 친화 에이전트 (6개)
- **senior-mentor**: 20년차 시니어 개발자 멘토
- **auto-architect**: 자동 아키텍트 - 모든 기술적 결정 자동화
- **beginner-helper**: 초보자 도우미 - 에러 자동 해결
- **code-explainer**: 코드 설명가 - 일반인이 이해할 수 있게 설명
- **project-wizard**: 프로젝트 마법사 - 클릭으로 프로젝트 생성
- **deployment-butler**: 배포 집사 - 클릭으로 배포

#### MCP 서버 관리 (4개)
- **mcp-server-manager**: MCP 서버 설치, 설정, 모니터링
- **mcp-tool-builder**: MCP 도구(tool) 개발 및 최적화
- **mcp-resource-expert**: MCP 리소스(resource) 설계 및 최적화
- **mcp-integration-specialist**: Claude Code와 MCP 서버 통합

**사용법:**
```bash
# Python 개발
/agent backend-architect "FastAPI 프로젝트 구조 설계"
/agent data-scientist "CSV 데이터 분석 및 시각화"
/agent ml-engineer "고객 이탈 예측 모델 개발"

# 초보자 모드
/초보자모드  # 완전 자동화 개발 모드 활성화
/무엇을할까  # 다음 단계 자동 제안
/자동설정    # 베스트 프랙티스 자동 설정

# MCP 서버 관리
/MCP서버관리  # MCP 서버 설치 및 관리
/MCP연결      # Claude Code와 MCP 연결
/MCP도구목록  # 사용 가능한 도구 확인
```

### ⚡ Slash Commands (슬래시 커맨드)

**15개의 한국어 워크플로우 커맨드:**

#### 개발 워크플로우 (5개)
| 명령어 | 설명 |
|--------|------|
| `/현황파악` | 변경사항 분석 및 현재 진행상황 파악 |
| `/테스트디버깅` | 실패한 테스트 분석 및 디버깅 |
| `/PR준비` | Pull Request 제출 전 준비 체크리스트 |
| `/보안검사` | 보안 취약점 검사 (비밀키, SQL injection, XSS 등) |
| `/리팩토링계획` | 리팩토링 계획 수립 및 영향 분석 |

#### 컨텍스트 관리 (3개)
| 명령어 | 설명 |
|--------|------|
| `/컨텍스트관리` | 세션 컨텍스트 관리 (시작/종료 시 자동 기록) |
| `/로그확인` | 모든 요청과 답변 로그 확인 |
| `/자동개발` | 전문 에이전트 그룹별 병렬 실행 |

#### 초보자 모드 (4개)
| 명령어 | 설명 |
|--------|------|
| `/초보자모드` | 비개발자를 위한 완전 자동 개발 모드 |
| `/무엇을할까` | 20년차 시니어처럼 다음 단계 자동 제안 |
| `/자동설정` | 모든 것을 베스트 프랙티스로 자동 설정 |
| `/배포하기` | 클릭 한 번으로 인터넷에 배포 |

#### MCP 서버 관리 (4개)
| 명령어 | 설명 |
|--------|------|
| `/MCP서버관리` | MCP 서버 설치, 설정, 시작/중지, 상태 확인 |
| `/MCP연결` | Claude Code와 MCP 서버 연결 및 도구 사용 |
| `/MCP도구목록` | 사용 가능한 MCP 도구 목록 및 사용법 |
| `/MCP로그` | MCP 서버 로그 확인 및 분석 |

### 🔒 Automated Hooks

**8개의 자동화 훅:**

#### PreToolUse 훅 (1개)
1. **pre-commit-validation.sh** (`git commit` 전)
   - 모든 테스트 실행 후 통과 시에만 커밋 허용
   - 실패한 테스트가 있으면 커밋 차단
   - `.env` 파일 우발적 커밋 방지

#### PostToolUse 훅 (2개)
2. **post-write-format.sh** (`*.py` 파일 작성 후)
   - Black 자동 포매팅
   - Flake8 문법 검사

3. **mcp-health-check.sh** (`.claude/mcp-servers.json` 변경 후)
   - MCP 서버 설정 변경 시 자동 헬스체크
   - 연결 상태 확인

#### SessionStart 훅 (3개)
4. **session-start.sh** (세션 시작 시)
   - 환경 설정 로드
   - Python 버전 및 git 상태 표시
   - 컨텍스트 관리 팁 제공

5. **auto-logger.sh** (세션 시작 시)
   - 날짜별 로그 파일 자동 생성
   - 요청/답변 이벤트 기록 시작

6. **mcp-server-monitor.sh** (세션 시작 시)
   - MCP 서버 상태 자동 확인
   - 프로세스, CPU, 메모리 모니터링
   - 자동 복구 (옵션)

#### SessionEnd 훅 (2개)
7. **session-end.sh** (세션 종료 시)
   - 진행 상황 저장
   - 중요 변경사항 요약
   - 다음 세션을 위한 컨텍스트 저장

8. **beginner-auto-fix.sh** (초보자 모드 - 자동 에러 수정)
   - Python 문법 에러 자동 검사 및 수정
   - 의존성 자동 확인 및 설치
   - 환경변수 파일 자동 생성
   - 데이터베이스 파일 자동 생성
   - Git 설정 확인
   - 포트 충돌 자동 해결
   - 디렉토리 권한 확인

## Project Structure

```
.
├── .claude/                         # Claude Code configuration
│   ├── agents.json                 # Python 전문가 에이전트 (13개)
│   ├── agents-beginner.json        # 초보자 친화 에이전트 (6개)
│   ├── agents-mcp.json             # MCP 서버 관리 에이전트 (4개)
│   ├── settings.json               # 훅 설정 (8개 훅)
│   ├── mcp-servers.json.example    # MCP 서버 설정 템플릿
│   ├── commands/                   # 슬래시 커맨드 (15개)
│   │   ├── 현황파악.md
│   │   ├── 테스트디버깅.md
│   │   ├── PR준비.md
│   │   ├── 보안검사.md
│   │   ├── 리팩토링계획.md
│   │   ├── 컨텍스트관리.md
│   │   ├── 로그확인.md
│   │   ├── 자동개발.md
│   │   ├── 초보자모드.md
│   │   ├── 무엇을할까.md
│   │   ├── 자동설정.md
│   │   ├── 배포하기.md
│   │   ├── MCP서버관리.md
│   │   ├── MCP연결.md
│   │   ├── MCP도구목록.md
│   │   └── MCP로그.md
│   └── logs/                       # 자동 로깅
│       ├── session_YYYY-MM-DD.log
│       ├── mcp-monitor_YYYY-MM-DD.log
│       └── mcp-health_YYYY-MM-DD.log
├── hooks/                           # 훅 스크립트 (8개)
│   ├── pre-commit-validation.sh
│   ├── post-write-format.sh
│   ├── session-start.sh
│   ├── session-end.sh
│   ├── auto-logger.sh
│   ├── beginner-auto-fix.sh
│   ├── mcp-server-monitor.sh
│   └── mcp-health-check.sh
├── scripts/                         # MCP 서버 스크립트
│   └── mcp-server-example.py       # Python MCP 서버 예제
├── .github/workflows/               # CI/CD pipelines
│   └── python-app.yml              # Multi-version Python testing
├── CLAUDE.md                        # Claude Code project guide
├── SECURITY.md                      # Security policies
└── .env                             # Environment variables (gitignored)
```

## Configuration

### Environment Variables

Create a `.env` file in the project root:

```bash
GITHUB_TOKEN=your_personal_access_token
GITHUB_REPO=https://github.com/younga1234/2.git
GITHUB_EMAIL=your_email@example.com
```

**⚠️ Critical**: Never commit `.env` files. Pre-commit hooks will block this automatically.

### GitHub Actions

The repository includes automated CI/CD:

**Test Job** (Python 3.8, 3.9, 3.10, 3.11):
- Dependency installation with caching
- Patchright browser installation
- Flake8 linting
- Project structure validation

**Security Job**:
- `.env` commit detection (blocks merge)
- Secret scanning with `detect-secrets`
- `.gitignore` validation

## Workflow Examples

### Starting a New Feature

```bash
# 1. Check current status (현황 파악)
/현황파악

# 2. Create feature branch
git checkout -b feature/user-auth

# 3. Implement feature
"Implement JWT authentication with refresh tokens"

# 4. Run security check (보안 검사)
/보안검사

# 5. Prepare PR (PR 준비)
/PR준비
```

### Debugging Test Failures

```bash
# Automatic test analysis and fix suggestions (테스트 디버깅)
/테스트디버깅

# Agent-assisted debugging
/agent test-engineer "Debug authentication tests"
```

### Code Review Workflow

```bash
# Review before commit
/agent code-reviewer "Review all changes"

# Apply suggestions
"Apply code review suggestions"

# Commit (hooks validate automatically)
git commit -m "feat: Add JWT authentication"
```

## Development Guidelines

### Code Quality Standards

All code must:
- Pass Flake8 checks (E9, F63, F7, F82 categories)
- Maintain Python 3.8+ compatibility
- Include unit tests with >80% coverage
- Have no security vulnerabilities

### Security Requirements

- **Never** commit `.env` files (enforced by hooks)
- Use environment variables for all credentials
- Follow OWASP Top 10 security guidelines
- Rotate tokens regularly

### Testing Requirements

- Unit tests for all functions
- Integration tests for workflows
- Edge case coverage (null, empty, boundary values)
- Pytest with `pytest-cov` for coverage reporting

## Context Management

### Token Budget (200K total)

```
CLAUDE.md:        5K   (2.5%)  - Project fundamentals
Slash commands:   5K   (2.5%)  - Workflows
Working files:   40K  (20%)    - Current work
Session history: 50K  (25%)    - Conversation
Free buffer:     95K  (50%)    - Additional context
```

### Best Practices

- Use `/context` to monitor token usage
- Use `/clear` to clean up completed sessions
- Delegate complex tasks to specialized agents
- Keep CLAUDE.md concise and focused

## CI/CD Integration

GitHub Actions automatically run on:
- Push to `master` or `main`
- Pull requests to `master` or `main`

**Required Checks**:
- ✅ All tests pass
- ✅ No Flake8 syntax errors
- ✅ No `.env` files in repository
- ✅ No detected secrets

## Troubleshooting

### Hook Failures

```bash
# If pre-commit hook blocks your commit
# Fix the failing tests first
pytest tests/ -v

# Then retry commit
git commit -m "Your message"
```

### Agent Not Found

```bash
# Verify agents.json exists
cat .claude/agents.json

# Restart Claude Code session
claude --restart
```

### Environment Issues

```bash
# Verify .env file
cat .env

# Check environment variables are loaded
echo $GITHUB_TOKEN
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes following development guidelines
4. Run `/pr-prep` for pre-submission checks
5. Submit pull request

## Security

See [SECURITY.md](SECURITY.md) for:
- Vulnerability reporting procedures
- Token management guidelines
- Protected data directories
- Security best practices

## License

This project follows Anthropic Claude Code best practices and configurations.

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/claude/claude-code)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [GitHub Repository](https://github.com/younga1234/2)

---

**Note**: This environment is configured for maximum security and development efficiency. All hooks and agents are production-ready and follow Anthropic's official guidelines.
