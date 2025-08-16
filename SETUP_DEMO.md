# 🚀 Flutter Template Setup Demo

## Super Easy Project Setup in 3 Steps!

### Step 1: Clone the Template
```bash
git clone https://github.com/senthilinfo62/Flutter_template.git
cd Flutter_template
```

### Step 2: Run Setup Script
```bash
./setup.sh
```

### Step 3: Follow Interactive Prompts

```
🚀 Flutter Template Setup
==================================================
This script will help you set up a new Flutter project
from the template with your custom package name.
==================================================

📝 Project Configuration:

Enter your project name (e.g., 'My Awesome App'): TaskMaster Pro
Enter package name [taskmaster_pro]: 
Enter your organization (e.g., 'com.yourcompany'): com.acmetech

📋 Configuration Summary:
   Project Name: TaskMaster Pro
   Package Name: taskmaster_pro
   Organization: com.acmetech
   Android Package: com.acmetech.taskmaster_pro
   iOS Bundle ID: com.acmetech.taskmaster_pro

Continue with this configuration? (y/N): y

🔧 Configuring project...
✅ Updated pubspec.yaml
✅ Updated Android configuration
✅ Updated iOS configuration
✅ Updated Firebase configuration templates
✅ Updated documentation
✅ Flutter setup completed
✅ Created PROJECT_SETUP.md with configuration details

🎉 Setup Complete!
==================================================
✅ Project 'TaskMaster Pro' is ready!
📦 Package: taskmaster_pro
🏢 Organization: com.acmetech

📋 Next Steps:
1. Set up Firebase projects (see PROJECT_SETUP.md)
2. Configure GitHub secrets for CI/CD
3. Start building your app!

📖 Documentation:
- PROJECT_SETUP.md - Your project configuration
- docs/ - Complete setup guides
- config/README.md - Firebase setup instructions

🚀 Happy coding!
```

## What Gets Automatically Updated

### ✅ Flutter Configuration
- **pubspec.yaml** - Project name and package name
- **lib/** - All import statements and references

### ✅ Android Configuration
- **android/app/build.gradle.kts** - applicationId
- **AndroidManifest.xml** - package attribute (all variants)
- **Fastlane configuration** - package references

### ✅ iOS Configuration
- **ios/Runner/Info.plist** - CFBundleIdentifier
- **Fastlane configuration** - bundle ID references

### ✅ Firebase Templates
- **config/templates/android/** - All package names updated
- **config/templates/ios/** - All bundle IDs updated
- **Environment-specific configurations** - dev, stg, prod variants

### ✅ Documentation
- **README.md** - Project title and package references
- **PROJECT_SETUP.md** - Generated with your configuration
- **All docs/** - Package name references updated

### ✅ CI/CD Configuration
- **GitHub Actions** - Environment variables
- **Fastlane** - Package and bundle ID references
- **Scripts** - All automation scripts updated

## Generated PROJECT_SETUP.md

After setup, you'll get a personalized configuration file:

```markdown
# TaskMaster Pro - Setup Summary

## 📱 Project Configuration
- **Project Name:** TaskMaster Pro
- **Package Name:** taskmaster_pro
- **Organization:** com.acmetech

## 📦 Package Identifiers
- **Android Package:** com.acmetech.taskmaster_pro
- **iOS Bundle ID:** com.acmetech.taskmaster_pro

## 🌿 Environment Packages
- **Development:** com.acmetech.taskmaster_pro.dev
- **Staging:** com.acmetech.taskmaster_pro.stg
- **Production:** com.acmetech.taskmaster_pro

## 🔥 Next Steps
1. Set up Firebase projects with the package names above
2. Update Firebase configuration templates in `config/templates/`
3. Configure GitHub secrets for CI/CD
4. Start developing your app!
```

## Benefits of Using the Setup Script

### 🚀 Speed
- **30 seconds** vs **30+ minutes** of manual configuration
- **Zero errors** - automated updates across all files
- **Consistent** - all references updated correctly

### 🎯 Accuracy
- **No missed files** - updates everything automatically
- **No typos** - consistent package names everywhere
- **No conflicts** - proper environment configuration

### 👥 Team Friendly
- **Same process** for all team members
- **Documented configuration** in PROJECT_SETUP.md
- **Ready for collaboration** immediately

### 🔒 Professional
- **Industry standards** - proper package naming
- **Environment separation** - dev, stg, prod ready
- **Complete setup** - Firebase, CI/CD, documentation

## Ready to Start Building!

After running the setup script, you can immediately:

```bash
# Start developing
flutter run

# Build for different environments
flutter build apk --dart-define=ENVIRONMENT=dev
flutter build ios --dart-define=ENVIRONMENT=stg

# Deploy to Firebase App Distribution
cd android && bundle exec fastlane deploy_internal

# Run tests
flutter test

# Generate code
dart run build_runner build
```

**Your Flutter app is now ready for professional development with enterprise-grade infrastructure!** 🎉
