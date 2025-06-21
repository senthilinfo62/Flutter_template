#!/bin/bash

# Pre-commit hook for Flutter Clean Architecture Template
# This script runs before each commit to ensure code quality

set -e

echo "🚀 Running pre-commit checks..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[PRE-COMMIT]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get list of changed Dart files
DART_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.dart$' | grep -v '\.g\.dart$' | grep -v '\.freezed\.dart$' | grep -v '\.gr\.dart$' || true)

if [ -z "$DART_FILES" ]; then
    print_status "No Dart files to check"
    exit 0
fi

print_status "Checking ${#DART_FILES[@]} Dart files..."

# 1. Format check
print_status "Checking code formatting..."
if ! dart format --set-exit-if-changed $DART_FILES; then
    print_error "Code formatting issues found. Please run 'dart format .' to fix."
    exit 1
fi

# 2. Import sorting
print_status "Sorting imports..."
dart run import_sorter:main

# 3. Analysis
print_status "Running analysis..."
if ! flutter analyze $DART_FILES; then
    print_error "Analysis issues found. Please fix them before committing."
    exit 1
fi

# 4. Advanced analysis for changed files
print_status "Running advanced analysis..."
if ! flutter analyze --fatal-infos $DART_FILES; then
    print_error "Advanced analysis issues found"
    exit 1
fi

print_success "All pre-commit checks passed!"
exit 0
