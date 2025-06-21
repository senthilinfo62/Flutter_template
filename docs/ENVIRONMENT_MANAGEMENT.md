# 🌿 Multi-Environment Package Management

This guide explains the automatic environment-based package name switching system that supports your development workflow.

## 📱 Environment Structure

### Package Name Mapping
```
🔧 Development (.dev)    - feature/*, fix/*, hotfix/*, bugfix/*
🧪 Staging (.stg)        - development, develop, dev, qa/*
🚀 Production (original) - main, release/*
```

### Package Name Examples
```
Base package: flutter_projects

🔧 Development:  flutter_projects.dev
🧪 Staging:      flutter_projects.stg  
🚀 Production:   flutter_projects
```

### Platform-Specific Identifiers
```
Android Package Names:
🔧 Development:  com.example.flutter.projects.dev
🧪 Staging:      com.example.flutter.projects.stg
🚀 Production:   com.example.flutter.projects

iOS Bundle IDs:
🔧 Development:  com.example.flutter.projects.dev
🧪 Staging:      com.example.flutter.projects.stg
🚀 Production:   com.example.flutter.projects
```

## 🔄 Automatic Configuration

### Branch-Based Environment Detection
The system automatically detects your environment based on Git branch patterns:

#### 🔧 Development Environment (.dev)
**Triggers:** Feature and fix branches
- `feature/user-authentication`
- `feat/payment-integration`
- `fix/login-bug`
- `hotfix/critical-crash`
- `bugfix/ui-alignment`

**Purpose:** Separate app instance for development and testing

#### 🧪 Staging Environment (.stg)
**Triggers:** QA and development branches
- `development`
- `develop`
- `dev`
- `qa/sprint-1`
- `qa/regression-testing`

**Purpose:** Pre-production testing and QA validation

#### 🚀 Production Environment (original)
**Triggers:** Release and main branches
- `main`
- `release/v1.0.0`
- `release/v2.1.0`

**Purpose:** Production builds for app store distribution

## 🛠️ How It Works

### Automatic Configuration Process
1. **Branch Detection** - System reads current Git branch
2. **Environment Mapping** - Maps branch to environment type
3. **Package Name Generation** - Creates environment-specific package name
4. **Configuration Update** - Updates all platform configuration files
5. **Build Preparation** - Prepares environment for building

### Files Updated Automatically
```
📱 Flutter Configuration:
- pubspec.yaml (name field)

🤖 Android Configuration:
- android/app/build.gradle.kts (applicationId)
- android/app/src/main/AndroidManifest.xml (package)
- android/app/src/debug/AndroidManifest.xml (package)
- android/app/src/profile/AndroidManifest.xml (package)

🍎 iOS Configuration:
- ios/Runner/Info.plist (CFBundleIdentifier)
- ios/configuration/environment.txt (notes)

📊 Build Configuration:
- build_config/environment.json (metadata)
```

## 🚀 Usage

### Manual Environment Configuration
```bash
# Configure environment for current branch
python3 scripts/environment_manager.py
```

### Automatic CI/CD Integration
The environment is automatically configured in CI/CD workflows:
```yaml
- name: Configure environment based on branch
  run: |
    python3 scripts/environment_manager.py
    echo "📱 Environment configured for branch: ${{ github.ref_name }}"
```

### Fastlane Integration
Environment configuration is automatically triggered in Fastlane lanes:
```ruby
# Android
lane :deploy_internal do
  configure_environment  # Automatic environment setup
  build_ci
  # ... rest of deployment
end

# iOS
lane :deploy_testflight do
  configure_environment  # Automatic environment setup
  build_firebase
  # ... rest of deployment
end
```

## 📊 Environment Information

### Build Configuration Output
After configuration, check `build_config/environment.json`:
```json
{
  "environment": "development",
  "branch": "feature/user-auth",
  "flutter_package_name": "flutter_projects.dev",
  "android_package_name": "com.example.flutter.projects.dev",
  "ios_bundle_id": "com.example.flutter.projects.dev",
  "base_package_name": "flutter_projects"
}
```

### Environment Summary Display
```
============================================================
📱 ENVIRONMENT CONFIGURATION SUMMARY
============================================================
🌿 Branch: feature/user-authentication
🏷️  Environment: DEVELOPMENT
📦 Flutter Package: flutter_projects.dev
🤖 Android Package: com.example.flutter.projects.dev
🍎 iOS Bundle ID: com.example.flutter.projects.dev
============================================================
🔧 DEVELOPMENT Environment (.dev)
   - For feature branches and development work
   - Separate app instance for testing
============================================================
```

## 🎯 Benefits

### Development Workflow
- **Parallel Development** - Multiple environments can coexist
- **Isolated Testing** - Each environment is completely separate
- **Automatic Configuration** - No manual package name changes
- **Branch-Based Logic** - Follows Git workflow naturally

### Team Collaboration
- **Consistent Environments** - Same configuration across team
- **Reduced Conflicts** - Separate app instances prevent conflicts
- **Professional Workflow** - Industry-standard environment management
- **Automated Process** - Zero manual configuration required

### App Store Management
- **Multiple Builds** - Different environments in app stores
- **Testing Isolation** - QA can test without affecting production
- **Release Management** - Clear separation of release stages
- **Professional Distribution** - Proper environment-based deployment

## 🔧 Customization

### Modifying Environment Rules
Edit `scripts/environment_manager.py` to customize branch patterns:
```python
def determine_environment(self) -> str:
    branch = self.current_branch.lower()
    
    # Add your custom branch patterns here
    if branch.startswith('release/') or branch == 'main':
        return 'production'
    elif branch in ['development', 'develop', 'dev'] or branch.startswith('qa/'):
        return 'staging'
    else:
        return 'development'
```

### Custom Package Name Format
Modify package name generation in `get_target_package_name()`:
```python
def get_target_package_name(self) -> str:
    if self.environment == 'production':
        return self.base_package_name
    elif self.environment == 'staging':
        return f"{self.base_package_name}.stg"  # Customize suffix
    else:
        return f"{self.base_package_name}.dev"  # Customize suffix
```

## 🚨 Important Notes

### App Store Considerations
- Each environment creates a **separate app** in app stores
- Configure separate **certificates** and **provisioning profiles** for iOS
- Set up separate **service accounts** for Android Play Store
- Use different **app icons** or **app names** to distinguish environments

### Development Best Practices
- **Test environment switching** before important releases
- **Verify package names** in build outputs
- **Use consistent branch naming** for predictable environment mapping
- **Document custom environment rules** for your team

### CI/CD Integration
- Environment configuration runs **automatically** in CI/CD
- **No manual intervention** required for environment switching
- **Consistent configuration** across all build environments
- **Professional deployment** with proper environment separation

This system provides enterprise-level environment management that scales with your team and follows industry best practices for multi-environment Flutter development.
