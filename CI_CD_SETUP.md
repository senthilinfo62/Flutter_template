# 🚀 CI/CD & Firebase Distribution Setup

This document explains how to set up automatic Firebase distribution with Android/iOS build uploads.

## 📋 Overview

Based on your preferences:
- ✅ **Dev builds** → Firebase App Distribution (for developers)
- ✅ **Staging builds** → Firebase App Distribution (for QA team)
- ❌ **Production builds** → Direct to App Store/Play Store (no Firebase distribution)

## 🔧 GitHub Secrets Setup

Add these secrets to your GitHub repository (`Settings > Secrets and variables > Actions`):

### Firebase Secrets
```
FIREBASE_SERVICE_ACCOUNT_KEY          # Firebase service account JSON
FIREBASE_ANDROID_APP_ID_DEV           # Dev Android app ID
FIREBASE_IOS_APP_ID_DEV               # Dev iOS app ID  
FIREBASE_ANDROID_APP_ID_STG           # Staging Android app ID
FIREBASE_IOS_APP_ID_STG               # Staging iOS app ID
```

### Android Signing Secrets
```
ANDROID_KEYSTORE_BASE64               # Base64 encoded keystore file
ANDROID_KEYSTORE_PASSWORD             # Keystore password
ANDROID_KEY_PASSWORD                  # Key password
ANDROID_KEY_ALIAS                     # Key alias
```

### iOS Signing Secrets
```
IOS_CERTIFICATE_BASE64                # Base64 encoded .p12 certificate
IOS_CERTIFICATE_PASSWORD              # Certificate password
IOS_PROVISIONING_PROFILE_BASE64       # Base64 encoded provisioning profile
IOS_KEYCHAIN_PASSWORD                 # Keychain password for CI
```

## 🔥 Firebase Setup

### 1. Create Firebase Service Account

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project → Project Settings → Service Accounts
3. Click "Generate new private key"
4. Save the JSON file and encode it to base64:
   ```bash
   base64 -i firebase-service-account.json | pbcopy
   ```
5. Add to GitHub secrets as `FIREBASE_SERVICE_ACCOUNT_KEY`

### 2. Get Firebase App IDs

Find your app IDs in Firebase Console → Project Settings → General:

**Development Project (`fluttertemplate-74068-dev`):**
- Android: `1:5186223346:android:6f6c4b0468a2259e6f646b`
- iOS: `1:5186223346:ios:6f6c4b0468a2259e6f646c`

**Staging Project (`fluttertemplate-74068-stg`):**
- Android: `1:5186223346:android:6f6c4b0468a2259e6f646c`
- iOS: `1:5186223346:ios:6f6c4b0468a2259e6f646d`

### 3. Setup Distribution Groups

In Firebase Console → App Distribution → Testers & Groups:

**Development:**
- Group: `developers`
- Members: Development team emails

**Staging:**
- Group: `qa-team`  
- Members: QA team and stakeholder emails

## 🤖 Android Signing Setup

### 1. Generate Keystore
```bash
keytool -genkey -v -keystore android/app/keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. Encode Keystore
```bash
base64 -i android/app/keystore.jks | pbcopy
```

### 3. Add to GitHub Secrets
- `ANDROID_KEYSTORE_BASE64`: The base64 encoded keystore
- `ANDROID_KEYSTORE_PASSWORD`: Password you set for keystore
- `ANDROID_KEY_PASSWORD`: Password you set for key
- `ANDROID_KEY_ALIAS`: Alias you used (e.g., "upload")

## 🍎 iOS Signing Setup

### 1. Export Certificate
1. Open Keychain Access
2. Find your distribution certificate
3. Right-click → Export → .p12 format
4. Set a password

### 2. Export Provisioning Profile
1. Go to [Apple Developer Portal](https://developer.apple.com/)
2. Certificates, Identifiers & Profiles → Profiles
3. Download your distribution profile

### 3. Encode Files
```bash
base64 -i certificate.p12 | pbcopy
base64 -i profile.mobileprovision | pbcopy
```

## 🚀 Automated Workflows

### Branch-Based Distribution

| Branch | Environment | Distribution |
|--------|-------------|--------------|
| `feature/*` | Development | ✅ Firebase |
| `develop` | Development | ✅ Firebase |
| `staging` | Staging | ✅ Firebase |
| `main` | Production | ❌ Manual only |

### Manual Distribution

```bash
# Development with Firebase distribution
./scripts/build_dev.sh --firebase

# Staging with Firebase distribution  
./scripts/build_stg.sh --firebase

# Android only
./scripts/build_dev.sh --firebase --android-only

# iOS only
./scripts/build_stg.sh --firebase --ios-only
```

## 📱 Distribution Process

### Automatic (CI/CD)
1. Push to `develop` or `staging` branch
2. GitHub Actions triggers build
3. Builds Android APK and iOS IPA
4. Distributes to Firebase App Distribution
5. Sends email notifications to testers

### Manual Local
1. Set up Firebase environment:
   ```bash
   ./scripts/setup_firebase_env.sh dev
   ```
2. Build and distribute:
   ```bash
   ./scripts/build_dev.sh --firebase
   ```

## 📧 Notifications

After successful distribution, testers receive:
- 📧 Email with download link
- 📱 Push notification (if Firebase app installed)
- 🔗 Direct download link

## 🔍 Monitoring

Track distributions in:
- Firebase Console → App Distribution
- GitHub Actions → Workflow runs
- Email notifications to team

## 🛠️ Troubleshooting

### Common Issues

1. **Build fails with signing error**
   - Check certificate/keystore passwords
   - Verify base64 encoding is correct

2. **Firebase distribution fails**
   - Verify service account has App Distribution Admin role
   - Check app IDs match Firebase console

3. **iOS build fails**
   - Ensure provisioning profile matches bundle ID
   - Check certificate is valid and not expired

### Debug Commands

```bash
# Check Firebase login
firebase login

# List Firebase projects
firebase projects:list

# Test distribution manually
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-dev-release.apk \
  --app "1:5186223346:android:6f6c4b0468a2259e6f646b" \
  --groups "developers"
```
