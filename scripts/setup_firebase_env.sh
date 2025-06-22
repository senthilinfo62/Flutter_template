#!/bin/bash

# Firebase Environment Setup Script
echo "🔥 Setting up Firebase Environment Variables"

# Check if environment is provided
if [ -z "$1" ]; then
  echo "Usage: $0 [dev|stg|prod]"
  echo "Example: $0 dev"
  exit 1
fi

ENVIRONMENT=$1

# Set Firebase project based on environment
case $ENVIRONMENT in
  dev)
    export FIREBASE_PROJECT="fluttertemplate-74068-dev"
    export FIREBASE_ANDROID_APP_ID_DEV="1:5186223346:android:6f6c4b0468a2259e6f646b"
    export FIREBASE_IOS_APP_ID_DEV="1:5186223346:ios:6f6c4b0468a2259e6f646c"
    echo "🔧 Environment set to: Development"
    ;;
  stg)
    export FIREBASE_PROJECT="fluttertemplate-74068-stg"
    export FIREBASE_ANDROID_APP_ID_STG="1:5186223346:android:6f6c4b0468a2259e6f646c"
    export FIREBASE_IOS_APP_ID_STG="1:5186223346:ios:6f6c4b0468a2259e6f646d"
    echo "🔧 Environment set to: Staging"
    ;;
  prod)
    export FIREBASE_PROJECT="fluttertemplate-74068"
    echo "🔧 Environment set to: Production"
    echo "⚠️  Note: Production builds are not distributed via Firebase"
    ;;
  *)
    echo "❌ Invalid environment: $ENVIRONMENT"
    echo "Valid options: dev, stg, prod"
    exit 1
    ;;
esac

# Set Firebase project
echo "🔥 Setting Firebase project to: $FIREBASE_PROJECT"
firebase use $FIREBASE_PROJECT

# Export environment variables to a file for CI/CD
cat > .env.firebase << EOF
FIREBASE_PROJECT=$FIREBASE_PROJECT
FIREBASE_ANDROID_APP_ID_DEV=$FIREBASE_ANDROID_APP_ID_DEV
FIREBASE_IOS_APP_ID_DEV=$FIREBASE_IOS_APP_ID_DEV
FIREBASE_ANDROID_APP_ID_STG=$FIREBASE_ANDROID_APP_ID_STG
FIREBASE_IOS_APP_ID_STG=$FIREBASE_IOS_APP_ID_STG
EOF

echo "✅ Firebase environment setup complete!"
echo "📁 Environment variables saved to .env.firebase"

# Display current configuration
echo ""
echo "📋 Current Configuration:"
echo "   Environment: $ENVIRONMENT"
echo "   Firebase Project: $FIREBASE_PROJECT"
if [ "$ENVIRONMENT" != "prod" ]; then
  echo "   Android App ID: $(eval echo \$FIREBASE_ANDROID_APP_ID_${ENVIRONMENT^^})"
  echo "   iOS App ID: $(eval echo \$FIREBASE_IOS_APP_ID_${ENVIRONMENT^^})"
fi
