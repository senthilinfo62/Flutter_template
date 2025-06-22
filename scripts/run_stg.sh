#!/bin/bash

# Run script for Staging environment
echo "🚀 Running Flutter Projects - Staging Environment"

# Set environment variables
export FLUTTER_ENV=stg

# Run the staging app (iOS doesn't support flavors without custom schemes)
flutter run --target lib/main_stg.dart --dart-define=FLUTTER_ENV=stg
