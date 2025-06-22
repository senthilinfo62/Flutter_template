#!/bin/bash

# Build script for Development environment
echo "🚀 Building Flutter Projects - Development Environment"

# Set environment variables
export FLUTTER_ENV=dev

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build for iOS (Development)
echo "📱 Building iOS Development..."
flutter build ios --target lib/main_dev.dart --flavor dev --dart-define=FLUTTER_ENV=dev

# Build for Android (Development)
echo "🤖 Building Android Development..."
flutter build apk --target lib/main_dev.dart --flavor dev --dart-define=FLUTTER_ENV=dev

echo "✅ Development build completed!"
echo "📱 iOS: build/ios/iphoneos/Runner.app"
echo "🤖 Android: build/app/outputs/flutter-apk/app-dev-release.apk"
