# 📋 Sample Firebase Configuration Values

This file shows you exactly what values to replace in your Firebase configuration templates.

## 🔥 Firebase Console Values to Copy

When you create your Firebase projects and add apps, you'll get these values from Firebase Console:

### 📱 From Firebase Project Settings → General

#### 🔧 Development Project (your-project-id-dev)
```
Project Number: 123456789012
Project ID: flutter-projects-dev
Storage Bucket: flutter-projects-dev.appspot.com
```

#### 🧪 Staging Project (your-project-id-stg)
```
Project Number: 234567890123
Project ID: flutter-projects-stg
Storage Bucket: flutter-projects-stg.appspot.com
```

#### 🚀 Production Project (your-project-id-prod)
```
Project Number: 345678901234
Project ID: flutter-projects-prod
Storage Bucket: flutter-projects-prod.appspot.com
```

### 🤖 Android App Configuration

#### From google-services.json (download from Firebase Console):

**Development (com.example.flutter.projects.dev):**
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

### 🍎 iOS App Configuration

#### From GoogleService-Info.plist (download from Firebase Console):

**Development (com.example.flutter.projects.dev):**
```xml
<key>API_KEY</key>
<string>AIzaSyABC123DEF456GHI789JKL012MNO345PQR</string>

<key>GCM_SENDER_ID</key>
<string>123456789012</string>

<key>PROJECT_ID</key>
<string>flutter-projects-dev</string>

<key>GOOGLE_APP_ID</key>
<string>1:123456789012:ios:wxyz5678abcd9012</string>

<key>BUNDLE_ID</key>
<string>com.example.flutter.projects.dev</string>
```

## 🔄 Copy & Paste Instructions

### Step 1: Replace Android Template Values

Open `config/templates/android/google-services-dev.json` and replace:

```
YOUR_PROJECT_NUMBER_DEV     → 123456789012
your-project-id-dev         → flutter-projects-dev
YOUR_APP_ID_DEV            → abcd1234efgh5678
YOUR_API_KEY_DEV           → AIzaSyABC123DEF456GHI789JKL012MNO345PQR
YOUR_CLIENT_ID_DEV         → 123456789012-abcd1234efgh5678.apps.googleusercontent.com
```

### Step 2: Replace iOS Template Values

Open `config/templates/ios/GoogleService-Info-dev.plist` and replace:

```
YOUR_IOS_API_KEY_DEV       → AIzaSyABC123DEF456GHI789JKL012MNO345PQR
YOUR_PROJECT_NUMBER_DEV    → 123456789012
your-project-id-dev        → flutter-projects-dev
YOUR_IOS_APP_ID_DEV        → wxyz5678abcd9012
```

### Step 3: Repeat for All Environments

Do the same for staging (.stg) and production (prod) templates using their respective values.

## 🎯 Quick Verification

After replacing values, your templates should look like this:

### ✅ Correct Android Template:
```json
{
  "project_info": {
    "project_number": "123456789012",
    "project_id": "flutter-projects-dev"
  }
}
```

### ❌ Incorrect (still has placeholders):
```json
{
  "project_info": {
    "project_number": "YOUR_PROJECT_NUMBER_DEV",
    "project_id": "your-project-id-dev"
  }
}
```

## 🔧 Test Your Configuration

After setting up templates, test with:

```bash
# Test development environment
python3 scripts/config_manager.py dev

# Check if files were copied correctly
ls -la android/app/google-services.json
ls -la ios/Runner/GoogleService-Info.plist

# Verify content (should not contain "YOUR_" placeholders)
grep -i "your_" android/app/google-services.json || echo "✅ Android config looks good"
grep -i "your_" ios/Runner/GoogleService-Info.plist || echo "✅ iOS config looks good"
```

## 🎉 You're Done!

Once you've replaced all placeholder values with actual Firebase values:

1. ✅ Templates are configured with real Firebase data
2. ✅ Environment manager can copy correct configs automatically
3. ✅ CI/CD will use appropriate configs based on branch
4. ✅ Each environment has separate Firebase projects

Your multi-environment Firebase setup is now complete! 🚀
