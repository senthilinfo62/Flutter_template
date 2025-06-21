#!/bin/bash
# Remove privacy bundle references before build
find . -name "*privacy.bundle" -type d -exec rm -rf {} + 2>/dev/null || true
find . -name "*_privacy" -type d -exec rm -rf {} + 2>/dev/null || true
