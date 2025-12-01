# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Status

This repository is currently in a **transition state**. All previous source code has been removed (as of commit 9f8c099), leaving only infrastructure and security configuration:

- `.github/workflows/python-app.yml` - CI/CD pipeline configuration
- `SECURITY.md` - Security policies and credential management
- `.gitignore` - Git ignore rules for Python projects
- `.env` (local only, not committed) - Environment variables

### Previous Project Context

Based on git history, this was previously a **Cultural Heritage Excavation Report Validation Tool** (문화재 발굴보고서 검증 도구) that went through several iterations:
- v1.0: Initial heritage report correction tool
- v2.0: Cultural Heritage Administration compliance validation
- v3.0: Simplified edition with user-centric redesign

All implementation code has been removed, but the infrastructure remains.

## GitHub Configuration

### Repository Details
- **Remote**: `https://github.com/younga1234/2.git`
- **Branch**: `master`
- **Contact**: kimya99@naver.com

### Environment Variables

The `.env` file (never committed) contains:
```
GITHUB_TOKEN=<personal_access_token>
GITHUB_REPO=https://github.com/younga1234/2.git
GITHUB_EMAIL=kimya99@naver.com
```

**Critical**: The `.env` file must always remain in `.gitignore`. The GitHub Actions workflow includes automated security checks to prevent accidental commits.

### GitHub Actions Workflow

Location: `.github/workflows/python-app.yml`

**Triggers**: Push/PR to `master` or `main` branches

**Jobs**:
1. **Test Job** (Multi-version Python testing)
   - Runs on: Python 3.8, 3.9, 3.10, 3.11
   - Installs dependencies from `requirements.txt` (if present)
   - Installs Patchright Chrome browser
   - Runs flake8 linting (non-blocking)
   - Validates project structure

2. **Security Job**
   - Verifies `.env` is not committed (fails if found)
   - Scans for secrets using `detect-secrets`
   - Validates `.gitignore` configuration

## Development Setup (Expected Pattern)

Based on the GitHub Actions configuration, the expected project structure is:

```
.
├── scripts/
│   └── setup_environment.py  # Virtual environment setup
├── requirements.txt           # Python dependencies
├── .venv/                     # Virtual environment (gitignored)
└── data/                      # Runtime data (gitignored)
    ├── browser_state/         # Browser session data
    └── auth_info.json         # Authentication state
```

### Expected Dependencies (from workflow)
- **patchright**: Browser automation library
- **flake8**: Code linting (dev dependency)
- **detect-secrets**: Secret scanning (security)

### Common Commands (Inferred)

```bash
# Setup virtual environment
python scripts/setup_environment.py

# Install dependencies
pip install -r requirements.txt

# Install Patchright browsers
python -m patchright install chrome

# Lint code
flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics

# Security scan
detect-secrets scan --baseline .secrets.baseline
```

## Architecture Notes

### Browser Automation Architecture (Inferred)

The presence of Patchright (Playwright fork with anti-detection) and `data/browser_state/` suggests this project uses:
- Stateful browser sessions with persistent authentication
- Chrome browser (not Chromium) for reliability
- Session data stored in `data/` directory

### Security-First Design

The repository enforces strict security practices:
- **Automated secret detection** in CI/CD
- **Multi-layer gitignore** for sensitive data
- **Explicit .env validation** preventing accidental commits
- **Token-based GitHub authentication** via environment variables

## Working with This Repository

### If Starting Fresh

Since the repository is currently empty of source code, when building a new project:

1. Create `requirements.txt` with necessary dependencies
2. Add `scripts/setup_environment.py` for environment management
3. Ensure any new code follows the Python 3.8+ compatibility requirement
4. Keep the existing security infrastructure intact

### If Restoring Previous Project

The git history contains complete implementations of the Cultural Heritage Report tool. Use:

```bash
# View previous commits
git log --oneline --all

# Restore specific version
git checkout <commit-hash>
```

Notable commits:
- `8ed2516`: v3.0 Simple Edition
- `18f1e56`: v2.0 with enhanced safety
- `ab0780b`: Initial implementation

### CI/CD Expectations

All code pushed to `master` or `main` must:
- Pass flake8 syntax checks (E9, F63, F7, F82 categories)
- Not contain `.env` files
- Be compatible with Python 3.8-3.11
- Include valid `requirements.txt` if using dependencies

## Context Management with Claude Code

### Agents (컨텍스트 격리)

Use agents to isolate complex tasks in separate contexts, improving token efficiency:

```bash
# Define specialized agents in .claude/agents.json
{
  "agents": [
    {
      "name": "code-reviewer",
      "description": "코드 품질 및 보안 검토",
      "tools": {"read": true, "grep": true, "edit": false}
    },
    {
      "name": "test-engineer",
      "description": "테스트 작성 및 분석",
      "tools": {"read": true, "edit": true, "bash": true}
    }
  ]
}

# Delegate tasks to agents
/agent code-reviewer "전체 코드 검토"
/agent test-engineer "단위 테스트 작성"
```

**Benefits**: Main session stays clean, each agent works independently with isolated context.

### Hooks (자동화된 규칙)

Configure hooks in `.claude/settings.json` to enforce rules automatically:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "bash:git commit",
      "hooks": [{"command": "pytest tests/ -v"}]
    }],
    "PostToolUse": [{
      "matcher": "write:src/**/*.py",
      "hooks": [{"command": "python -m black {file}"}]
    }]
  }
}
```

**Key Principle**: Use "Block-at-Submit" pattern - don't block during work, only validate at commit time.

### Slash Commands (재사용 가능한 워크플로우)

Create custom commands in `.claude/commands/`:

**`.claude/commands/catchup.md`**:
```markdown
---
name: catchup
description: 변경사항 분석 및 진행상황 파악
---

1. `git status --short` 실행
2. `git diff HEAD` 분석
3. 변경 파일 요약 및 다음 작업 제안
```

**Usage**:
```bash
/catchup      # 현재 상태 파악
/test-debug   # 테스트 디버깅
/pr-prep      # PR 준비 체크리스트
```

### Token Efficiency Strategy

```
Total Context: 200K tokens

CLAUDE.md:        5K   (2.5%)  - Project fundamentals
Slash commands:   5K   (2.5%)  - Workflows
Working files:   40K  (20%)    - Current work
Session history: 50K  (25%)    - Conversation
Free buffer:     95K  (50%)    - Additional context
```

**Best Practices**:
- Keep CLAUDE.md concise (2-5KB)
- Use `/context` to monitor token usage
- Use `/clear` or `/compact` to clean up sessions
- Delegate complex tasks to specialized agents

### Recommended Workflow

```bash
# 1. Start session (CLAUDE.md auto-loads)
claude

# 2. Catch up on changes
/catchup

# 3. Work on features
"Implement JWT authentication"

# 4. Debug if needed
/test-debug

# 5. Commit (hooks validate automatically)
git commit -m "Add authentication"

# 6. Prepare PR
/pr-prep

# 7. Code review (agent delegation)
/agent code-reviewer "Review all changes"
```

## Security Policy

See `SECURITY.md` for comprehensive security guidelines including:
- GitHub token management
- Environment variable configuration
- Protected data directories
- Vulnerability reporting procedures
