#!/usr/bin/env bash

# Find the git root directory to ensure reliable path resolution
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$GIT_ROOT" ]; then
    echo "Error: Not inside a git repository."
    exit 1
fi

# Define the hook path
HOOK_DIR="$GIT_ROOT/.git/hooks"
HOOK_FILE="$HOOK_DIR/pre-push"

# Ensure the hooks directory exists
if [ ! -d "$HOOK_DIR" ]; then
    echo "Error: .git/hooks directory not found. Is git initialized?"
    exit 1
fi

# Create the pre-push hook
echo "Creating pre-push hook at $HOOK_FILE..."

cat > "$HOOK_FILE" << 'EOF'
#!/bin/sh

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "Running Nix Integrity Check before push..."

# Run the evaluation
OUTPUT=$(nix run .#check 2>&1)
EXIT_CODE=$?

# Check strictly for the "SUCCESS" status in the output struct
if echo "$OUTPUT" | grep -Fq 'status = "SUCCESS";'; then
    echo -e "${GREEN}✅ Integrity Check SUCCESS.${NC}"
    exit 0
else
    echo -e "${RED}❌ Integrity Check FAILED. Push aborted.${NC}"
    echo -e "${RED}The last commit is broken. Fix it and amend before pushing.${NC}"
    echo "---------------------------------------------------"
    echo "$OUTPUT"
    echo "---------------------------------------------------"
    exit 1
fi
EOF

# Make the hook executable
chmod +x "$HOOK_FILE"

echo "✅ Hook installed successfully at $HOOK_FILE"
echo "Any 'git push' will now automatically run 'nix eval ...'"