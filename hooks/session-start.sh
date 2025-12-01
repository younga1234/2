#!/bin/bash
# Session start hook
# This script runs when a Claude Code session starts

echo "🚀 Claude Code session starting..."

# 1. Load environment variables if .env exists
if [ -f ".env" ]; then
    echo "📋 Environment file detected (.env)"
    # Don't export, just notify
fi

# 2. Check Python version
if command -v python &> /dev/null; then
    PYTHON_VERSION=$(python --version 2>&1)
    echo "🐍 $PYTHON_VERSION"
fi

# 3. Check if virtual environment exists
if [ -d ".venv" ]; then
    echo "✅ Virtual environment found (.venv/)"
elif [ -d "venv" ]; then
    echo "✅ Virtual environment found (venv/)"
else
    echo "⚠️  No virtual environment found. Consider creating one:"
    echo "   python -m venv .venv"
fi

# 4. Check if git repository
if [ -d ".git" ]; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
    echo "📦 Git repository: branch '$BRANCH'"
fi

# 5. Check for uncommitted changes
if [ -d ".git" ]; then
    CHANGES=$(git status --short | wc -l)
    if [ "$CHANGES" -gt 0 ]; then
        echo "📝 Uncommitted changes: $CHANGES file(s)"
    fi
fi

echo "✅ Session initialized"
exit 0
