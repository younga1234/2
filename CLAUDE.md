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

## Security Policy

See `SECURITY.md` for comprehensive security guidelines including:
- GitHub token management
- Environment variable configuration
- Protected data directories
- Vulnerability reporting procedures
