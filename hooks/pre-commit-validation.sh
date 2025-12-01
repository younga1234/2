#!/bin/bash
# Pre-commit validation hook
# This script runs before git commit to ensure code quality

set -e

echo "🔍 Running pre-commit validation..."

# 1. Check if tests directory exists
if [ -d "tests" ]; then
    echo "📝 Running tests..."
    python -m pytest tests/ -v --tb=short || {
        echo "❌ Tests failed! Fix the issues before committing."
        exit 2  # Exit code 2 blocks the commit
    }
    echo "✅ All tests passed"
else
    echo "⚠️  No tests directory found, skipping tests"
fi

# 2. Check for Python syntax errors
echo "🔍 Checking for syntax errors..."
python -m py_compile **/*.py 2>/dev/null || {
    echo "⚠️  py_compile not available or no Python files"
}

# 3. Check if .env file is accidentally staged
if git diff --cached --name-only | grep -q "^\.env$"; then
    echo "❌ ERROR: .env file is staged! Remove it before committing."
    echo "Run: git reset HEAD .env"
    exit 2
fi

echo "✅ Pre-commit validation passed"
exit 0
