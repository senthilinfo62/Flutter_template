#!/bin/bash

# Firebase Configuration Setup Script
# This script helps you set up Firebase configurations for all environments

echo "🔥 Firebase Configuration Setup"
echo "================================"
echo ""

# Check if config templates exist
if [ ! -d "config/templates" ]; then
    echo "❌ Config templates directory not found!"
    echo "   Please run this script from the project root directory."
    exit 1
fi

echo "📋 Setup Instructions:"
echo ""
echo "1. Create 3 Firebase projects:"
echo "   🔧 Development: your-project-id-dev"
echo "   🧪 Staging:     your-project-id-stg"
echo "   🚀 Production:  your-project-id-prod"
echo ""

echo "2. Add apps to each project:"
echo "   🤖 Android:"
echo "      - Development: com.example.flutter.projects.dev"
echo "      - Staging:     com.example.flutter.projects.stg"
echo "      - Production:  com.example.flutter.projects"
echo ""
echo "   🍎 iOS:"
echo "      - Development: com.example.flutter.projects.dev"
echo "      - Staging:     com.example.flutter.projects.stg"
echo "      - Production:  com.example.flutter.projects"
echo ""

echo "3. Download and copy configuration files:"
echo ""

# Function to check if template has been configured
check_template() {
    local file=$1
    local placeholder=$2
    
    if [ -f "$file" ]; then
        if grep -q "$placeholder" "$file"; then
            echo "   ⚠️  $(basename $file) - NEEDS CONFIGURATION"
            return 1
        else
            echo "   ✅ $(basename $file) - CONFIGURED"
            return 0
        fi
    else
        echo "   ❌ $(basename $file) - MISSING"
        return 1
    fi
}

echo "🤖 Android Templates Status:"
check_template "config/templates/android/google-services-dev.json" "YOUR_PROJECT_NUMBER_DEV"
check_template "config/templates/android/google-services-stg.json" "YOUR_PROJECT_NUMBER_STG"
check_template "config/templates/android/google-services-prod.json" "YOUR_PROJECT_NUMBER_PROD"

echo ""
echo "🍎 iOS Templates Status:"
check_template "config/templates/ios/GoogleService-Info-dev.plist" "YOUR_IOS_API_KEY_DEV"
check_template "config/templates/ios/GoogleService-Info-stg.plist" "YOUR_IOS_API_KEY_STG"
check_template "config/templates/ios/GoogleService-Info-prod.plist" "YOUR_IOS_API_KEY_PROD"

echo ""
echo "📖 Next Steps:"
echo ""
echo "1. Open Firebase Console: https://console.firebase.google.com/"
echo "2. Create your Firebase projects"
echo "3. Add Android and iOS apps with the package names above"
echo "4. Download google-services.json and GoogleService-Info.plist"
echo "5. Copy the content into the template files in config/templates/"
echo "6. Replace all placeholder values with actual Firebase values"
echo ""

echo "🔧 After configuration, test with:"
echo "   python3 scripts/config_manager.py dev"
echo "   python3 scripts/config_manager.py stg"
echo "   python3 scripts/config_manager.py prod"
echo ""

echo "📚 For detailed instructions, see: config/README.md"
echo ""
echo "🎉 Happy coding!"
