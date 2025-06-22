#!/bin/bash

# Build script for Staging environment
echo "🚀 Building Flutter Projects - Staging Environment"

# Set environment variables
export FLUTTER_ENV=stg

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build for iOS (Staging)
echo "📱 Building iOS Staging..."
flutter build ios --target lib/main_stg.dart --flavor stg --dart-define=FLUTTER_ENV=stg

# Build for Android (Staging)
echo "🤖 Building Android Staging..."
flutter build apk --target lib/main_stg.dart --flavor stg --dart-define=FLUTTER_ENV=stg

echo "✅ Staging build completed!"
echo "📱 iOS: build/ios/iphoneos/Runner.app"
echo "🤖 Android: build/app/outputs/flutter-apk/app-stg-release.apk"
