# 🔧 Firebase Configuration Setup Guide

This guide shows you how to set up Firebase configurations for all environments using the provided templates.

## 📁 Configuration Structure

```
config/
├── templates/
│   ├── android/
│   │   ├── google-services-dev.json    # Development
│   │   ├── google-services-stg.json    # Staging
│   │   └── google-services-prod.json   # Production
│   └── ios/
│       ├── GoogleService-Info-dev.plist    # Development
│       ├── GoogleService-Info-stg.plist    # Staging
│       └── GoogleService-Info-prod.plist   # Production
└── README.md (this file)
```

## 🚀 Quick Setup (Copy & Paste)

### Step 1: Create Firebase Projects
Create 3 Firebase projects in [Firebase Console](https://console.firebase.google.com/):

1. **Development:** `your-project-id-dev`
2. **Staging:** `your-project-id-stg`  
3. **Production:** `your-project-id-prod`

### Step 2: Add Apps to Each Project

For each Firebase project, add both Android and iOS apps:

#### 🤖 Android Apps:
- **Development:** `com.example.flutter.projects.dev`
- **Staging:** `com.example.flutter.projects.stg`
- **Production:** `com.example.flutter.projects`

#### 🍎 iOS Apps:
- **Development:** `com.example.flutter.projects.dev`
- **Staging:** `com.example.flutter.projects.stg`
- **Production:** `com.example.flutter.projects`

### Step 3: Download Configuration Files

#### 🤖 For Android:
1. Go to Project Settings → General → Your apps
2. Click on Android app → Download `google-services.json`
3. **Copy the content** and paste into the appropriate template:
   - Development → `config/templates/android/google-services-dev.json`
   - Staging → `config/templates/android/google-services-stg.json`
   - Production → `config/templates/android/google-services-prod.json`

#### 🍎 For iOS:
1. Go to Project Settings → General → Your apps
2. Click on iOS app → Download `GoogleService-Info.plist`
3. **Copy the content** and paste into the appropriate template:
   - Development → `config/templates/ios/GoogleService-Info-dev.plist`
   - Staging → `config/templates/ios/GoogleService-Info-stg.plist`
   - Production → `config/templates/ios/GoogleService-Info-prod.plist`

## 📋 Template Placeholders

Replace these placeholders in your templates with actual values from Firebase:

### 🤖 Android Templates:
```json
{
  "project_info": {
    "project_number": "YOUR_PROJECT_NUMBER_DEV",     // Replace with actual
    "project_id": "your-project-id-dev",            // Replace with actual
    "storage_bucket": "your-project-id-dev.appspot.com"
  },
  "client": [{
    "client_info": {
      "mobilesdk_app_id": "1:YOUR_PROJECT_NUMBER_DEV:android:YOUR_APP_ID_DEV",
      "android_client_info": {
        "package_name": "com.example.flutter.projects.dev"  // Already correct
      }
    },
    "api_key": [{
      "current_key": "YOUR_API_KEY_DEV"              // Replace with actual
    }]
  }]
}
```

### 🍎 iOS Templates:
```xml
<key>API_KEY</key>
<string>YOUR_IOS_API_KEY_DEV</string>              <!-- Replace with actual -->

<key>GCM_SENDER_ID</key>
<string>YOUR_PROJECT_NUMBER_DEV</string>           <!-- Replace with actual -->

<key>PROJECT_ID</key>
<string>your-project-id-dev</string>               <!-- Replace with actual -->

<key>GOOGLE_APP_ID</key>
<string>1:YOUR_PROJECT_NUMBER_DEV:ios:YOUR_IOS_APP_ID_DEV</string>  <!-- Replace -->
```

## 🔄 Automatic Configuration

Once you've set up the templates, the system automatically copies the correct configuration files based on your Git branch:

```bash
# Manual configuration
python3 scripts/config_manager.py

# Or specify environment
python3 scripts/config_manager.py dev
python3 scripts/config_manager.py stg
python3 scripts/config_manager.py prod
```

### Automatic Branch Detection:
- **feature/*** → Development (dev)
- **qa/*** → Staging (stg)
- **main/release*** → Production (prod)

## ✅ Verification

After setup, verify your configuration:

1. **Check copied files:**
   ```bash
   ls -la android/app/google-services.json
   ls -la ios/Runner/GoogleService-Info.plist
   ```

2. **Check environment info:**
   ```bash
   cat build_config/config_environment.json
   ```

3. **Test Firebase connection:**
   ```bash
   flutter run
   # Check logs for Firebase initialization
   ```

## 🎯 Example: Complete Development Setup

Here's a complete example for the development environment:

### 1. Firebase Project: `flutter-projects-dev`

### 2. Android App: `com.example.flutter.projects.dev`
**google-services-dev.json:**
```json
{
  "project_info": {
    "project_number": "123456789012",
    "project_id": "flutter-projects-dev",
    "storage_bucket": "flutter-projects-dev.appspot.com"
  },
  "client": [{
    "client_info": {
      "mobilesdk_app_id": "1:123456789012:android:abcd1234efgh5678",
      "android_client_info": {
        "package_name": "com.example.flutter.projects.dev"
      }
    },
    "api_key": [{
      "current_key": "AIzaSyABC123DEF456GHI789JKL012MNO345PQR"
    }]
  }]
}
```

### 3. iOS App: `com.example.flutter.projects.dev`
**GoogleService-Info-dev.plist:**
```xml
<key>API_KEY</key>
<string>AIzaSyABC123DEF456GHI789JKL012MNO345PQR</string>

<key>PROJECT_ID</key>
<string>flutter-projects-dev</string>

<key>BUNDLE_ID</key>
<string>com.example.flutter.projects.dev</string>
```

## 🔒 Security Notes

- **Never commit actual configuration files** to version control
- **Templates are safe** to commit (they contain placeholders)
- **Use environment variables** for sensitive data in CI/CD
- **Restrict Firebase project access** to team members only

## 🚨 Important Files to .gitignore

Make sure these files are in your `.gitignore`:
```
# Firebase configuration files (actual files, not templates)
android/app/google-services.json
ios/Runner/GoogleService-Info.plist

# Build configuration
build_config/config_environment.json
```

## 🎉 Benefits

✅ **Easy Setup** - Copy and paste from Firebase Console  
✅ **Environment Separation** - Different Firebase projects per environment  
✅ **Automatic Switching** - Based on Git branch  
✅ **Team Friendly** - Templates can be shared safely  
✅ **Professional** - Industry-standard multi-environment setup  

Now you can easily set up Firebase for all environments by simply copying and pasting the configuration files from Firebase Console into the provided templates! 🚀
