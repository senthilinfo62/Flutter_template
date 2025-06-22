#!/bin/bash

# Run script for Development environment
echo "🚀 Running Flutter Projects - Development Environment"

# Set environment variables
export FLUTTER_ENV=dev

# Run the development app (iOS doesn't support flavors without custom schemes)
flutter run --target lib/main_dev.dart --dart-define=FLUTTER_ENV=dev
