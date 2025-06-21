# 🚀 App Store Deployment Setup

This guide explains how to configure automatic uploads to TestFlight (iOS) and Play Store Internal Release (Android) after successful CI/CD builds.

## 📱 iOS TestFlight Setup

### 1. Apple Developer Account Requirements
- Active Apple Developer Program membership ($99/year)
- App registered in App Store Connect
- Certificates and provisioning profiles configured

### 2. Required GitHub Secrets
Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):

```
FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD
FASTLANE_SESSION
MATCH_PASSWORD (if using fastlane match)
```

### 3. Certificate Management Options

#### Option A: Manual Certificate Management
1. Create App Store distribution certificate
2. Create App Store provisioning profile
3. Add certificates to GitHub repository secrets

#### Option B: Fastlane Match (Recommended)
```bash
# Setup fastlane match for automatic certificate management
cd ios
bundle exec fastlane match init
bundle exec fastlane match appstore
```

### 4. Enable TestFlight Deployment
Uncomment this line in `.github/workflows/ci.yml`:
```yaml
# bundle exec fastlane deploy_testflight
```

## 🤖 Android Play Store Setup

### 1. Google Play Console Requirements
- Google Play Console account ($25 one-time fee)
- App registered in Play Console
- Service account with Play Console access

### 2. Service Account Setup
1. Go to Google Cloud Console
2. Create a new service account
3. Download the JSON key file
4. Grant Play Console access to the service account

### 3. Required GitHub Secrets
Add this secret to your GitHub repository:

```
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON
```
(Paste the entire contents of your service account JSON file)

### 4. Configure App Details
Update `android/fastlane/Appfile`:
```ruby
json_key_file("path/to/your/service-account-key.json")
package_name("com.yourcompany.yourapp")
```

### 5. Enable Play Store Deployment
Uncomment this line in `.github/workflows/ci.yml`:
```yaml
# bundle exec fastlane deploy_internal
```

## 🎯 Deployment Workflow

### Automatic Deployment Triggers
- **Trigger:** Push to `main` branch
- **iOS:** Uploads to TestFlight for internal testing
- **Android:** Uploads to Play Store Internal Release track

### Manual Deployment Commands
```bash
# iOS TestFlight
cd ios && bundle exec fastlane deploy_testflight

# Android Play Store Internal
cd android && bundle exec fastlane deploy_internal

# Android Play Store Alpha
cd android && bundle exec fastlane deploy_alpha
```

## 🔒 Security Best Practices

### GitHub Secrets Management
- Never commit certificates or keys to repository
- Use GitHub repository secrets for sensitive data
- Rotate secrets regularly
- Use environment-specific secrets for different stages

### Certificate Security
- Store certificates securely (use fastlane match)
- Use App Store Connect API keys when possible
- Enable two-factor authentication on all accounts

## 📋 Deployment Checklist

### Before First Deployment
- [ ] Apple Developer account active
- [ ] Google Play Console account setup
- [ ] Apps registered in both stores
- [ ] GitHub secrets configured
- [ ] Certificates and provisioning profiles ready
- [ ] Service account JSON configured

### For Each Release
- [ ] Version number updated in pubspec.yaml
- [ ] Release notes prepared
- [ ] Testing completed
- [ ] Push to main branch triggers deployment

## 🚀 Expected Results

After successful setup:
- **iOS builds** automatically upload to TestFlight
- **Android builds** automatically upload to Play Store Internal Release
- **Team members** can test via TestFlight and Play Console
- **Deployment time** added: ~2-3 minutes per platform

## 📈 Benefits

- **Automated distribution** - No manual uploads needed
- **Faster feedback cycles** - Testers get builds immediately
- **Professional workflow** - Industry-standard deployment
- **Reduced errors** - Automated process eliminates manual mistakes
- **Team efficiency** - Developers focus on coding, not deployment

## 🤖 Post-Deployment Automation

After successful app store uploads, the system automatically:

### 📢 Notifications
- **Slack notifications** with release details and changelog
- **Email notifications** (if configured)
- **Team mentions** for QA assignments

### 📝 Documentation
- **Auto-generated release notes** in `docs/releases/`
- **Changelog from Git commits** since last release
- **QA checklists** with download instructions

### 🧪 QA Process Automation
- **Notion pages** for QA tracking (if configured)
- **Trello cards** for task management (if configured)
- **Jira tickets** for issue tracking (if configured)

### 📊 Metadata Logging
- **JSON logs** in `logs/release_history.json`
- **CSV logs** in `logs/release_history.csv`
- **Historical tracking** of all releases

### 🏷️ Git Tagging
- **Automatic tagging** as `release-ios-vX.Y.Z` or `release-android-vX.Y.Z`
- **Push to remote** for version tracking

## 🔧 Post-Deployment Configuration

### Required GitHub Secrets
```
# Slack Integration
SLACK_WEBHOOK_URL

# Notion Integration (optional)
NOTION_TOKEN
NOTION_QA_DATABASE_ID

# Trello Integration (optional)
TRELLO_API_KEY
TRELLO_TOKEN
TRELLO_QA_LIST_ID

# Jira Integration (optional)
JIRA_URL
JIRA_EMAIL
JIRA_API_TOKEN
JIRA_PROJECT_KEY

# QA Assignment
QA_ASSIGNEE
```

### Slack Webhook Setup
1. Go to your Slack workspace
2. Create a new app or use existing
3. Add Incoming Webhooks
4. Copy webhook URL to GitHub secrets

### Notion Integration Setup
1. Create Notion integration at https://www.notion.so/my-integrations
2. Create a database for QA tracking
3. Add integration token and database ID to secrets

## 🔧 Troubleshooting

### Common Issues
1. **Certificate errors** - Check provisioning profiles and certificates
2. **Service account permissions** - Verify Play Console access
3. **Version conflicts** - Ensure version numbers are incremented
4. **Build signing** - Verify code signing configuration
5. **Python dependencies** - Ensure scripts/requirements.txt is installed
6. **Webhook failures** - Check Slack/Notion/Trello credentials

### Support Resources
- [Fastlane iOS Documentation](https://docs.fastlane.tools/getting-started/ios/)
- [Fastlane Android Documentation](https://docs.fastlane.tools/getting-started/android/)
- [App Store Connect API](https://developer.apple.com/app-store-connect/api/)
- [Google Play Console API](https://developers.google.com/android-publisher)
- [Slack Webhooks](https://api.slack.com/messaging/webhooks)
- [Notion API](https://developers.notion.com/)
