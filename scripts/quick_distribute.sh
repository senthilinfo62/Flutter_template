#!/bin/bash

# Quick Firebase Distribution Script
echo "🚀 Quick Firebase Distribution"

# Check if environment is provided
if [ -z "$1" ]; then
  echo "Usage: $0 [dev|stg] [android|ios|both]"
  echo "Examples:"
  echo "  $0 dev both      # Build and distribute both platforms for dev"
  echo "  $0 stg android   # Build and distribute Android only for staging"
  exit 1
fi

ENVIRONMENT=$1
PLATFORM=${2:-both}

# Validate environment
if [[ "$ENVIRONMENT" != "dev" && "$ENVIRONMENT" != "stg" ]]; then
  echo "❌ Invalid environment: $ENVIRONMENT"
  echo "Valid options: dev, stg"
  exit 1
fi

# Validate platform
if [[ "$PLATFORM" != "android" && "$PLATFORM" != "ios" && "$PLATFORM" != "both" ]]; then
  echo "❌ Invalid platform: $PLATFORM"
  echo "Valid options: android, ios, both"
  exit 1
fi

echo "🔧 Environment: $ENVIRONMENT"
echo "📱 Platform: $PLATFORM"

# Setup Firebase environment
echo "🔥 Setting up Firebase environment..."
./scripts/setup_firebase_env.sh $ENVIRONMENT

# Source environment variables
if [ -f .env.firebase ]; then
  source .env.firebase
fi

# Build and distribute based on environment and platform
case $ENVIRONMENT in
  dev)
    if [[ "$PLATFORM" == "android" || "$PLATFORM" == "both" ]]; then
      ./scripts/build_dev.sh --firebase --android-only
    fi
    if [[ "$PLATFORM" == "ios" || "$PLATFORM" == "both" ]]; then
      ./scripts/build_dev.sh --firebase --ios-only
    fi
    ;;
  stg)
    if [[ "$PLATFORM" == "android" || "$PLATFORM" == "both" ]]; then
      ./scripts/build_stg.sh --firebase --android-only
    fi
    if [[ "$PLATFORM" == "ios" || "$PLATFORM" == "both" ]]; then
      ./scripts/build_stg.sh --firebase --ios-only
    fi
    ;;
esac

echo ""
echo "✅ Distribution completed!"
echo "📧 Check your email for download links"
echo "🔗 Or visit Firebase Console: https://console.firebase.google.com/project/$FIREBASE_PROJECT/appdistribution"
