#!/bin/bash

# Build script for Production environment
echo "🚀 Building Flutter Projects - Production Environment"

# Set environment variables
export FLUTTER_ENV=prod

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build for iOS (Production)
echo "📱 Building iOS Production..."
flutter build ios --target lib/main.dart --dart-define=FLUTTER_ENV=prod

# Build for Android (Production)
echo "🤖 Building Android Production..."
flutter build apk --target lib/main.dart --flavor prod --dart-define=FLUTTER_ENV=prod

echo "✅ Production build completed!"
echo "📱 iOS: build/ios/iphoneos/Runner.app"
echo "🤖 Android: build/app/outputs/flutter-apk/app-prod-release.apk"
