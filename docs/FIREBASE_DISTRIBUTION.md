# 🔥 Firebase App Distribution Configuration

This guide explains how Firebase App Distribution is configured for **dev** and **stg** environments only, while **production** builds go to official app stores.

## 📱 Distribution Strategy

### Environment-Based Distribution:
```
🔧 Development (.dev)  → Firebase App Distribution
🧪 Staging (.stg)      → Firebase App Distribution  
🚀 Production (prod)   → TestFlight + Play Store
```

### Why This Approach:
- **Dev/Stg**: Fast distribution for testing and QA
- **Production**: Official app store channels for releases
- **Security**: Separate distribution channels by environment
- **Professional**: Industry-standard release management

## 🔧 Firebase App Distribution Setup

### Step 1: Enable App Distribution in Firebase Console

For each Firebase project (dev and stg):

1. Go to Firebase Console → Your Project
2. Navigate to **App Distribution** in the left sidebar
3. Click **Get Started**
4. Add your Android and iOS apps if not already added

### Step 2: Get Firebase App IDs

#### 🤖 Android App IDs:
```
Development: 1:123456789012:android:abcd1234efgh5678
Staging:     1:234567890123:android:efgh5678ijkl9012
```

#### 🍎 iOS App IDs:
```
Development: 1:123456789012:ios:wxyz5678abcd9012
Staging:     1:234567890123:ios:ijkl9012mnop3456
```

### Step 3: Configure GitHub Secrets

Add these secrets to your GitHub repository:

```
# Firebase App IDs
FIREBASE_APP_ID_DEV=1:123456789012:android:abcd1234efgh5678
FIREBASE_APP_ID_STG=1:234567890123:android:efgh5678ijkl9012
FIREBASE_APP_ID_IOS_DEV=1:123456789012:ios:wxyz5678abcd9012
FIREBASE_APP_ID_IOS_STG=1:234567890123:ios:ijkl9012mnop3456

# Firebase Service Account (for authentication)
FIREBASE_SERVICE_ACCOUNT_KEY=<your-service-account-json>
```

### Step 4: Create Firebase Service Account

1. Go to Firebase Console → Project Settings → Service Accounts
2. Click **Generate New Private Key**
3. Download the JSON file
4. Copy the entire JSON content to `FIREBASE_SERVICE_ACCOUNT_KEY` secret

## 👥 Distribution Groups

### Predefined Groups:

#### 🔧 Development Environment:
- **developers** - Development team
- **qa-team** - QA engineers

#### 🧪 Staging Environment:
- **qa-team** - QA engineers
- **stakeholders** - Product managers, designers
- **beta-testers** - External beta testers

### Creating Groups in Firebase Console:

1. Go to App Distribution → Testers & Groups
2. Click **Add Group**
3. Enter group name and add email addresses
4. Save the group

## 🚀 How It Works

### Automatic Distribution Logic:

```ruby
# Fastlane automatically determines distribution method:

if environment == 'development' || environment == 'staging'
  # Use Firebase App Distribution
  firebase_app_distribution(
    app: get_firebase_app_id(environment),
    groups: get_firebase_groups(environment),
    release_notes: generate_release_notes(version, environment)
  )
else
  # Use official app stores (TestFlight/Play Store)
  upload_to_testflight() # iOS
  upload_to_play_store() # Android
end
```

### Branch-Based Distribution:

```
feature/user-auth     → Firebase App Distribution (dev)
qa/testing           → Firebase App Distribution (stg)
main                 → TestFlight + Play Store (prod)
release/v1.0.0       → TestFlight + Play Store (prod)
```

## 📝 Release Notes Generation

### Automatic Release Notes:
```
🤖 Android DEV Build v1.0.0

📝 Recent Changes:
- Add user authentication
- Fix login bug
- Update UI components
- Improve performance
- Add unit tests

🔧 Environment: DEVELOPMENT
📱 Package: com.example.flutter.projects.dev

🧪 This is a development build for testing purposes.
```

### Customization:
Release notes are automatically generated from recent Git commits. You can customize the format in the Fastfile helper functions.

## 🔒 Security Configuration

### Environment Variables:
```yaml
# GitHub Actions environment variables
FIREBASE_SERVICE_ACCOUNT_KEY: ${{ secrets.FIREBASE_SERVICE_ACCOUNT_KEY }}
FIREBASE_APP_ID_DEV: ${{ secrets.FIREBASE_APP_ID_DEV }}
FIREBASE_APP_ID_STG: ${{ secrets.FIREBASE_APP_ID_STG }}
```

### Access Control:
- **Firebase projects** - Separate for each environment
- **Distribution groups** - Environment-specific access
- **Service accounts** - Minimal required permissions
- **GitHub secrets** - Secure credential storage

## 📱 Testing the Distribution

### Manual Testing:
```bash
# Test development distribution
cd android && bundle exec fastlane deploy_internal

# Test staging distribution (from staging branch)
git checkout qa/testing
cd android && bundle exec fastlane deploy_internal
```

### Verification:
1. Check Firebase Console → App Distribution → Releases
2. Verify testers receive email notifications
3. Test app installation from Firebase App Distribution
4. Confirm release notes are displayed correctly

## 🎯 Benefits

### Development Efficiency:
- **Fast distribution** - No app store review process
- **Immediate feedback** - Testers get builds instantly
- **Easy access** - Firebase App Distribution app
- **Automatic notifications** - Email alerts to testers

### Professional Workflow:
- **Environment separation** - Clear testing boundaries
- **Controlled access** - Group-based distribution
- **Release tracking** - Complete distribution history
- **Integration** - Seamless CI/CD integration

### Quality Assurance:
- **Dedicated QA builds** - Separate from production
- **Stakeholder access** - Easy sharing with non-technical users
- **Beta testing** - External tester management
- **Feedback collection** - Built-in feedback mechanisms

## 🚨 Important Notes

### Production Builds:
- **Never distributed via Firebase** - Only official app stores
- **TestFlight for iOS** - Apple's official beta testing
- **Play Store Internal** - Google's internal testing track
- **Professional release management** - Proper app store workflow

### Environment Isolation:
- **Separate Firebase projects** - Complete isolation
- **Different package names** - No conflicts
- **Independent distribution** - Separate tester groups
- **Secure configuration** - Environment-specific secrets

This configuration ensures that your development and staging builds are quickly distributed to the right people for testing, while maintaining professional release management for production builds through official app store channels.
