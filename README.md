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

Four pre-configured agents for common development tasks:

- **code-reviewer**: Code quality, security, and performance auditing
- **test-engineer**: Test writing and debugging with 95%+ coverage goals
- **security-auditor**: OWASP Top 10 vulnerability scanning
- **documentation-writer**: Technical documentation and API docs

**Usage:**
```bash
/agent code-reviewer "Review authentication module"
/agent test-engineer "Write tests for user API"
/agent security-auditor "Scan for vulnerabilities"
```

### ⚡ Slash Commands (슬래시 커맨드)

Five workflow commands for common operations (한국어 명령어 지원):

| 명령어 | 설명 | Command |
|--------|------|---------|
| `/현황파악` | 변경사항 분석 및 현재 진행상황 파악 | Analyze recent changes and project status |
| `/테스트디버깅` | 실패한 테스트 분석 및 디버깅 | Debug failing tests with root cause analysis |
| `/PR준비` | Pull Request 제출 전 준비 체크리스트 | PR preparation checklist (lint, test, format) |
| `/보안검사` | 보안 취약점 검사 (비밀키, SQL injection, XSS 등) | Security audit (secrets, injection, XSS) |
| `/리팩토링계획` | 리팩토링 계획 수립 및 영향 분석 | Refactoring impact analysis and planning |

### 🔒 Automated Hooks

Three hooks enforce development standards:

1. **Pre-commit validation** (`PreToolUse: git commit`)
   - Runs all tests before allowing commits
   - Blocks commits with failing tests
   - Prevents accidental `.env` commits

2. **Auto-formatting** (`PostToolUse: write *.py`)
   - Auto-formats Python files with Black
   - Runs Flake8 syntax checks

3. **Session initialization** (`SessionStart`)
   - Loads environment configuration
   - Displays Python version and git status
   - Checks for uncommitted changes

## Project Structure

```
.
├── .claude/                    # Claude Code configuration
│   ├── agents.json            # Agent definitions
│   ├── settings.json          # Hook configuration
│   └── commands/              # Slash command implementations
├── hooks/                      # Hook scripts
│   ├── pre-commit-validation.sh
│   ├── post-write-format.sh
│   └── session-start.sh
├── .github/workflows/          # CI/CD pipelines
│   └── python-app.yml         # Multi-version Python testing
├── CLAUDE.md                   # Claude Code project guide
├── SECURITY.md                 # Security policies
└── .env                        # Environment variables (gitignored)
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
