#!/bin/bash
# Pre-build privacy manifest fix
echo "🔧 Running pre-build privacy manifest fix..."

# Remove privacy bundles
find . -name "*privacy.bundle" -type d -exec rm -rf {} + 2>/dev/null || true
find . -name "*_privacy" -type d -exec rm -rf {} + 2>/dev/null || true

# Remove privacy manifest references from build files
find . -name "*.xcconfig" -exec sed -i '' '/privacy/d' {} + 2>/dev/null || true

echo "✅ Pre-build fix completed"
