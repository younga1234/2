# Security Policy

## Sensitive Information Management

### Environment Variables

This project uses environment variables to store sensitive information. **NEVER commit `.env` files to version control.**

### Required Environment Variables

Create a `.env` file in the project root with the following structure:

```
GITHUB_TOKEN=your_github_personal_access_token
GITHUB_REPO=https://github.com/username/repo.git
GITHUB_EMAIL=your_email@example.com
```

### GitHub Secrets Configuration

For GitHub Actions, configure the following secrets in your repository:

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add the following secrets:

| Secret Name | Description |
|------------|-------------|
| `GITHUB_TOKEN` | Your GitHub Personal Access Token (automatically provided by GitHub Actions) |
| `NOTEBOOKLM_AUTH` | NotebookLM authentication credentials (if applicable) |

### Setting Up GitHub Personal Access Token

1. Go to GitHub → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. Click **Generate new token (classic)**
3. Select scopes:
   - `repo` (Full control of private repositories)
   - `workflow` (Update GitHub Action workflows)
4. Generate and copy the token
5. Store it securely in your `.env` file locally
6. Add it to GitHub Secrets for CI/CD

### Security Best Practices

- ✅ Always use `.gitignore` to exclude sensitive files
- ✅ Use GitHub Secrets for CI/CD pipelines
- ✅ Rotate tokens regularly
- ✅ Use environment-specific configurations
- ❌ Never hardcode credentials in source code
- ❌ Never commit `.env` files
- ❌ Never share tokens publicly

### Protected Data Directories

The following directories contain sensitive data and are excluded via `.gitignore`:

- `data/` - Contains authentication and session data
- `data/browser_state/` - Browser session storage
- `data/auth_info.json` - Authentication credentials

## Reporting Security Issues

If you discover a security vulnerability, please email: **kimya99@naver.com**

Do not create public GitHub issues for security vulnerabilities.
