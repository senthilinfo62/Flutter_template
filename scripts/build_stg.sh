#!/bin/bash

# Build script for Staging environment with Firebase Distribution
echo "🚀 Building Flutter Projects - Staging Environment"

# Set environment variables
export FLUTTER_ENV=stg

# Parse command line arguments
DISTRIBUTE_FIREBASE=false
DISTRIBUTE_ANDROID=true
DISTRIBUTE_IOS=true

while [[ $# -gt 0 ]]; do
  case $1 in
    --firebase)
      DISTRIBUTE_FIREBASE=true
      shift
      ;;
    --android-only)
      DISTRIBUTE_IOS=false
      shift
      ;;
    --ios-only)
      DISTRIBUTE_ANDROID=false
      shift
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build for Android (Staging)
if [ "$DISTRIBUTE_ANDROID" = true ]; then
  echo "🤖 Building Android Staging..."
  flutter build apk --target lib/main_stg.dart --flavor stg --dart-define=FLUTTER_ENV=stg --release

  if [ "$DISTRIBUTE_FIREBASE" = true ]; then
    echo "🚀 Distributing Android to Firebase..."
    firebase appdistribution:distribute build/app/outputs/flutter-apk/app-stg-release.apk \
      --app "$FIREBASE_ANDROID_APP_ID_STG" \
      --groups "qa-team" \
      --release-notes "Staging build from $(git rev-parse --short HEAD) - $(date)"
  fi
fi

# Build for iOS (Staging)
if [ "$DISTRIBUTE_IOS" = true ]; then
  echo "📱 Building iOS Staging..."
  flutter build ios --target lib/main_stg.dart --dart-define=FLUTTER_ENV=stg --release --no-codesign

  # Create IPA for distribution
  echo "📦 Creating IPA..."
  cd build/ios/iphoneos
  mkdir -p Payload
  cp -r Runner.app Payload/
  zip -r app-stg.ipa Payload/
  cd ../../..

  if [ "$DISTRIBUTE_FIREBASE" = true ]; then
    echo "🚀 Distributing iOS to Firebase..."
    firebase appdistribution:distribute build/ios/iphoneos/app-stg.ipa \
      --app "$FIREBASE_IOS_APP_ID_STG" \
      --groups "qa-team" \
      --release-notes "Staging build from $(git rev-parse --short HEAD) - $(date)"
  fi
fi

echo "✅ Staging build completed!"
if [ "$DISTRIBUTE_ANDROID" = true ]; then
  echo "🤖 Android: build/app/outputs/flutter-apk/app-stg-release.apk"
fi
if [ "$DISTRIBUTE_IOS" = true ]; then
  echo "📱 iOS: build/ios/iphoneos/app-stg.ipa"
fi

if [ "$DISTRIBUTE_FIREBASE" = true ]; then
  echo "🚀 Builds distributed to Firebase App Distribution!"
  echo "📧 Check your email or Firebase console for download links"
fi
