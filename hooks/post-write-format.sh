#!/bin/bash
# Post-write formatting hook
# This script runs after writing Python files to auto-format them

FILE="$1"

# Only process Python files
if [[ "$FILE" == *.py ]]; then
    echo "📝 Formatting Python file: $FILE"

    # Auto-format with Black (if available)
    if command -v black &> /dev/null; then
        python -m black "$FILE" --quiet 2>/dev/null || echo "⚠️  Black formatting skipped"
    fi

    # Check basic style with flake8 (if available)
    if command -v flake8 &> /dev/null; then
        python -m flake8 "$FILE" --select=E9,F63,F7,F82 2>/dev/null || echo "⚠️  Flake8 check skipped"
    fi
fi

exit 0
