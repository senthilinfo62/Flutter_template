# 🔐 GitHub Secrets Setup Guide

This guide will help you set up all the required GitHub secrets for CI/CD to work properly.

## 📋 Required Secrets Overview

### 🔥 Firebase Secrets (Required for Distribution)
```
FIREBASE_SERVICE_ACCOUNT_KEY          # Firebase service account JSON
FIREBASE_ANDROID_APP_ID_DEV           # Dev Android app ID
FIREBASE_IOS_APP_ID_DEV               # Dev iOS app ID  
FIREBASE_ANDROID_APP_ID_STG           # Staging Android app ID
FIREBASE_IOS_APP_ID_STG               # Staging iOS app ID
```

### 🤖 Android Signing Secrets (Required for Release Builds)
```
ANDROID_KEYSTORE_BASE64               # Base64 encoded keystore file
ANDROID_KEYSTORE_PASSWORD             # Keystore password
ANDROID_KEY_PASSWORD                  # Key password
ANDROID_KEY_ALIAS                     # Key alias
```

### 🍎 iOS Signing Secrets (Required for Release Builds)
```
IOS_CERTIFICATE_BASE64                # Base64 encoded .p12 certificate
IOS_CERTIFICATE_PASSWORD              # Certificate password
IOS_PROVISIONING_PROFILE_BASE64       # Base64 encoded provisioning profile
IOS_KEYCHAIN_PASSWORD                 # Keychain password for CI
```

## 🚀 Quick Start (Test Builds Only)

**For now, you can test the CI/CD without any secrets!**

The test workflow (`.github/workflows/test_build.yml`) will:
- ✅ Build all environments (dev, stg, prod)
- ✅ Run tests and analysis
- ✅ Create debug APKs and iOS apps
- ❌ No distribution (requires secrets)

## 🔥 Step 1: Firebase Setup

### 1.1 Create Firebase Service Account

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project → **Project Settings** → **Service Accounts**
3. Click **"Generate new private key"**
4. Download the JSON file
5. Convert to base64:
   ```bash
   # On macOS/Linux
   base64 -i firebase-service-account.json | pbcopy
   
   # On Windows
   certutil -encode firebase-service-account.json firebase-base64.txt
   ```
6. Add to GitHub secrets as `FIREBASE_SERVICE_ACCOUNT_KEY`

### 1.2 Get Firebase App IDs

1. Go to Firebase Console → **Project Settings** → **General**
2. Find your app IDs for each environment:

**Development Project:**
- Android: `1:PROJECT_NUMBER:android:ANDROID_APP_ID`
- iOS: `1:PROJECT_NUMBER:ios:IOS_APP_ID`

**Staging Project:**
- Android: `1:PROJECT_NUMBER:android:ANDROID_APP_ID`
- iOS: `1:PROJECT_NUMBER:ios:IOS_APP_ID`

### 1.3 Setup Distribution Groups

1. Go to Firebase Console → **App Distribution** → **Testers & Groups**
2. Create groups:
   - **developers** (for dev builds)
   - **qa-team** (for staging builds)
3. Add team member emails to appropriate groups

## 🤖 Step 2: Android Signing

### 2.1 Generate Keystore (if you don't have one)

```bash
keytool -genkey -v -keystore android/app/keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload \
  -dname "CN=Your Name, OU=Your Company, O=Your Company, L=Your City, ST=Your State, C=US"
```

### 2.2 Configure Android Signing

1. Encode keystore to base64:
   ```bash
   base64 -i android/app/keystore.jks | pbcopy
   ```

2. Add these secrets to GitHub:
   - `ANDROID_KEYSTORE_BASE64`: The base64 encoded keystore
   - `ANDROID_KEYSTORE_PASSWORD`: Password you set for keystore
   - `ANDROID_KEY_PASSWORD`: Password you set for key
   - `ANDROID_KEY_ALIAS`: Alias you used (e.g., "upload")

## 🍎 Step 3: iOS Signing

### 3.1 Export Certificate

1. Open **Keychain Access** on macOS
2. Find your **iOS Distribution** certificate
3. Right-click → **Export** → Save as `.p12`
4. Set a password when prompted

### 3.2 Export Provisioning Profile

1. Go to [Apple Developer Portal](https://developer.apple.com/)
2. **Certificates, Identifiers & Profiles** → **Profiles**
3. Download your **App Store** or **Ad Hoc** distribution profile

### 3.3 Encode and Add to GitHub

```bash
# Encode certificate
base64 -i certificate.p12 | pbcopy

# Encode provisioning profile
base64 -i profile.mobileprovision | pbcopy
```

Add these secrets:
- `IOS_CERTIFICATE_BASE64`: Base64 encoded certificate
- `IOS_CERTIFICATE_PASSWORD`: Certificate password
- `IOS_PROVISIONING_PROFILE_BASE64`: Base64 encoded profile
- `IOS_KEYCHAIN_PASSWORD`: Any secure password for CI keychain

## 📱 Step 4: Add Secrets to GitHub

1. Go to your GitHub repository
2. **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"**
4. Add each secret one by one

## 🧪 Step 5: Test the Setup

### Test Without Secrets (Basic Build)
```bash
# Push to any branch to trigger test build
git push origin feature/test-ci-cd
```

### Test With Secrets (Full Distribution)
```bash
# Push to develop branch for dev distribution
git push origin develop

# Push to staging branch for staging distribution
git push origin staging
```

## 🔍 Troubleshooting

### Common Issues

1. **"Secret not found"**
   - Check secret names match exactly (case-sensitive)
   - Verify secrets are added to the correct repository

2. **"Invalid base64"**
   - Re-encode files ensuring no extra characters
   - Use `pbcopy` on macOS or copy directly from terminal

3. **"Firebase distribution failed"**
   - Verify service account has **Firebase App Distribution Admin** role
   - Check app IDs match your Firebase console

4. **"Android signing failed"**
   - Verify keystore password is correct
   - Check that keystore file is properly encoded

5. **"iOS signing failed"**
   - Ensure certificate is valid and not expired
   - Verify provisioning profile matches bundle ID

## 📞 Need Help?

If you encounter issues:
1. Check the **Actions** tab in GitHub for detailed error logs
2. Verify all secrets are properly set
3. Test builds locally first using the build scripts
4. Check Firebase console for distribution status

## 🎯 Next Steps

Once secrets are configured:
1. Test builds will automatically distribute to Firebase
2. Team members will receive email notifications
3. Apps can be downloaded directly from Firebase App Distribution
4. Monitor builds in GitHub Actions and Firebase Console
