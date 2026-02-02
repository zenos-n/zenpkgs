#!/usr/bin/env bash
# Quick wrapper to run the sanity check
# Usage: ./tests/check.sh or cd tests && ./check.sh

# Get the directory where this script resides (tests/)
TEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Resolve the Project Root (one level up from tests/)
PROJECT_ROOT="$(dirname "$TEST_DIR")"

# Ensure we operate from the Project Root
cd "$PROJECT_ROOT"

if [ ! -f "flake.nix" ]; then
    echo "## [ ! ] Error: flake.nix not found in $PROJECT_ROOT"
    exit 1
fi

echo "## [ START ] Initializing ZenPkgs Sanity Check..."
echo "## [ INFO ]  Context: $PROJECT_ROOT"

# Run nix-build pointing to the sanity file in the tests directory
nix-build "$TEST_DIR/sanity.nix" --no-out-link

if [ $? -eq 0 ]; then
    echo ""
    echo "## [ SUCCESS ] Sanity Check Complete. Structure is valid."
else
    echo ""
    echo "## [ ! ] FAIL: Sanity Check encountered errors."
    echo "Check the trace above for 'throw' messages or evaluation errors."
fi