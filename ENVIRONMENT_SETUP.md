# 🌍 Environment Configuration Guide

This Flutter project supports multiple environments: **Development (dev)**, **Staging (stg)**, and **Production (prod)**.

## 📱 Environment Overview

| Environment | Bundle ID | Firebase Project | App Name |
|-------------|-----------|------------------|----------|
| **Development** | `com.example.flutterProjects.dev` | `fluttertemplate-74068-dev` | Flutter Projects Dev |
| **Staging** | `com.example.flutterProjects.stg` | `fluttertemplate-74068-stg` | Flutter Projects Staging |
| **Production** | `com.example.flutterProjects` | `fluttertemplate-74068` | Flutter Projects |

## 🚀 Quick Start

### Running Different Environments

```bash
# Development
./scripts/run_dev.sh

# Staging  
./scripts/run_stg.sh

# Production (default)
flutter run
```

### Building for Different Environments

```bash
# Development
./scripts/build_dev.sh

# Staging
./scripts/build_stg.sh

# Production
./scripts/build_prod.sh
```

## 📁 File Structure

```
lib/
├── main.dart              # Production entry point
├── main_dev.dart          # Development entry point
├── main_stg.dart          # Staging entry point
├── firebase_options.dart  # Production Firebase config
├── firebase_options_dev.dart  # Development Firebase config
├── firebase_options_stg.dart  # Staging Firebase config
└── core/
    └── config/
        └── environment_config.dart  # Environment management

ios/Runner/
├── GoogleService-Info.plist      # Production
├── GoogleService-Info-Dev.plist  # Development
└── GoogleService-Info-Stg.plist  # Staging

android/app/src/
├── main/google-services.json     # Production
├── dev/google-services.json      # Development
└── stg/google-services.json      # Staging
```

## 🔧 Manual Commands

### iOS
```bash
# Development
flutter run -t lib/main_dev.dart --dart-define=FLUTTER_ENV=dev

# Staging
flutter run -t lib/main_stg.dart --dart-define=FLUTTER_ENV=stg

# Production
flutter run -t lib/main.dart --dart-define=FLUTTER_ENV=prod
```

### Android
```bash
# Development
flutter run -t lib/main_dev.dart --flavor dev --dart-define=FLUTTER_ENV=dev

# Staging
flutter run -t lib/main_stg.dart --flavor stg --dart-define=FLUTTER_ENV=stg

# Production
flutter run -t lib/main.dart --flavor prod --dart-define=FLUTTER_ENV=prod
```

## 🔥 Firebase Configuration

Each environment has its own Firebase project:

- **Dev**: `fluttertemplate-74068-dev`
- **Staging**: `fluttertemplate-74068-stg`  
- **Production**: `fluttertemplate-74068`

### Setting Up New Firebase Projects

1. Create Firebase projects for dev/stg environments
2. Download configuration files:
   - iOS: `GoogleService-Info.plist` → rename and place in `ios/Runner/`
   - Android: `google-services.json` → place in `android/app/src/{env}/`
3. Update `firebase_options_*.dart` files with new project details

## 🎯 Environment Features

### Development
- Debug banner enabled
- Enhanced logging
- Development API endpoints
- Firebase Analytics enabled for testing

### Staging
- Debug banner enabled
- Production-like behavior
- Staging API endpoints
- Full Firebase services enabled

### Production
- Debug banner disabled
- Optimized performance
- Production API endpoints
- Full Firebase services enabled

## 📋 Checklist for New Environments

- [ ] Create Firebase project
- [ ] Download and configure Firebase files
- [ ] Update bundle identifiers
- [ ] Test build and run scripts
- [ ] Verify Firebase services work
- [ ] Test push notifications
- [ ] Validate API endpoints
