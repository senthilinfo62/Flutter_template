#!/usr/bin/env python3
"""
Flutter Template Setup Script
Automatically configures a new Flutter project from the template
"""

import os
import re
import subprocess
import sys
from pathlib import Path

class FlutterProjectSetup:
    def __init__(self):
        self.project_root = Path.cwd()
        self.old_package_name = "flutter_projects"
        self.new_package_name = ""
        self.new_project_name = ""
        self.organization = ""
        
    def welcome_message(self):
        """Display welcome message"""
        print("🚀 Flutter Template Setup")
        print("=" * 50)
        print("This script will help you set up a new Flutter project")
        print("from the template with your custom package name.")
        print("=" * 50)
        print()
    
    def get_user_input(self):
        """Get project details from user"""
        print("📝 Project Configuration:")
        print()
        
        # Get project name
        while True:
            self.new_project_name = input("Enter your project name (e.g., 'My Awesome App'): ").strip()
            if self.new_project_name:
                break
            print("❌ Project name cannot be empty!")
        
        # Generate package name suggestion
        suggested_package = re.sub(r'[^a-zA-Z0-9]', '_', self.new_project_name.lower())
        suggested_package = re.sub(r'_+', '_', suggested_package).strip('_')
        
        # Get package name
        while True:
            default_package = input(f"Enter package name [{suggested_package}]: ").strip()
            self.new_package_name = default_package if default_package else suggested_package
            
            # Validate package name
            if re.match(r'^[a-z][a-z0-9_]*$', self.new_package_name):
                break
            print("❌ Package name must start with lowercase letter and contain only lowercase letters, numbers, and underscores!")
        
        # Get organization
        while True:
            self.organization = input("Enter your organization (e.g., 'com.yourcompany'): ").strip()
            if re.match(r'^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)*$', self.organization):
                break
            print("❌ Organization must be in format 'com.yourcompany' (lowercase, dots allowed)!")
        
        print()
        print("📋 Configuration Summary:")
        print(f"   Project Name: {self.new_project_name}")
        print(f"   Package Name: {self.new_package_name}")
        print(f"   Organization: {self.organization}")
        print(f"   Android Package: {self.organization}.{self.new_package_name}")
        print(f"   iOS Bundle ID: {self.organization}.{self.new_package_name}")
        print()
        
        confirm = input("Continue with this configuration? (y/N): ").strip().lower()
        if confirm != 'y':
            print("❌ Setup cancelled.")
            sys.exit(0)
    
    def update_pubspec_yaml(self):
        """Update pubspec.yaml with new package name"""
        pubspec_path = self.project_root / "pubspec.yaml"
        
        if not pubspec_path.exists():
            print("❌ pubspec.yaml not found!")
            return False
        
        with open(pubspec_path, 'r') as f:
            content = f.read()
        
        # Update name and description
        content = re.sub(
            r'^name:\s*.*$',
            f'name: {self.new_package_name}',
            content,
            flags=re.MULTILINE
        )
        
        content = re.sub(
            r'^description:\s*.*$',
            f'description: {self.new_project_name}',
            content,
            flags=re.MULTILINE
        )
        
        with open(pubspec_path, 'w') as f:
            f.write(content)
        
        print("✅ Updated pubspec.yaml")
        return True
    
    def update_android_config(self):
        """Update Android configuration files"""
        android_package = f"{self.organization}.{self.new_package_name}"
        
        # Update build.gradle.kts
        build_gradle_path = self.project_root / "android" / "app" / "build.gradle.kts"
        if build_gradle_path.exists():
            with open(build_gradle_path, 'r') as f:
                content = f.read()
            
            content = re.sub(
                r'applicationId\s*=\s*"[^"]*"',
                f'applicationId = "{android_package}"',
                content
            )
            
            with open(build_gradle_path, 'w') as f:
                f.write(content)
        
        # Update AndroidManifest.xml files
        manifest_paths = [
            "android/app/src/main/AndroidManifest.xml",
            "android/app/src/debug/AndroidManifest.xml",
            "android/app/src/profile/AndroidManifest.xml"
        ]
        
        for manifest_path in manifest_paths:
            full_path = self.project_root / manifest_path
            if full_path.exists():
                with open(full_path, 'r') as f:
                    content = f.read()
                
                content = re.sub(
                    r'package="[^"]*"',
                    f'package="{android_package}"',
                    content
                )
                
                with open(full_path, 'w') as f:
                    f.write(content)
        
        print("✅ Updated Android configuration")
    
    def update_ios_config(self):
        """Update iOS configuration files"""
        bundle_id = f"{self.organization}.{self.new_package_name}"
        
        # Update Info.plist
        info_plist_path = self.project_root / "ios" / "Runner" / "Info.plist"
        if info_plist_path.exists():
            with open(info_plist_path, 'r') as f:
                content = f.read()
            
            content = re.sub(
                r'<key>CFBundleIdentifier</key>\s*<string>[^<]*</string>',
                f'<key>CFBundleIdentifier</key>\n\t<string>{bundle_id}</string>',
                content
            )
            
            with open(info_plist_path, 'w') as f:
                f.write(content)
        
        print("✅ Updated iOS configuration")
    
    def update_firebase_templates(self):
        """Update Firebase configuration templates"""
        android_package = f"{self.organization}.{self.new_package_name}"
        bundle_id = f"{self.organization}.{self.new_package_name}"
        
        # Update Android Firebase templates
        android_templates = [
            "config/templates/android/google-services-dev.json",
            "config/templates/android/google-services-stg.json",
            "config/templates/android/google-services-prod.json"
        ]
        
        for template_path in android_templates:
            full_path = self.project_root / template_path
            if full_path.exists():
                with open(full_path, 'r') as f:
                    content = f.read()
                
                # Update package names
                if 'dev.json' in template_path:
                    content = content.replace('com.example.flutter.projects.dev', f'{android_package}.dev')
                elif 'stg.json' in template_path:
                    content = content.replace('com.example.flutter.projects.stg', f'{android_package}.stg')
                else:
                    content = content.replace('com.example.flutter.projects', android_package)
                
                with open(full_path, 'w') as f:
                    f.write(content)
        
        # Update iOS Firebase templates
        ios_templates = [
            "config/templates/ios/GoogleService-Info-dev.plist",
            "config/templates/ios/GoogleService-Info-stg.plist",
            "config/templates/ios/GoogleService-Info-prod.plist"
        ]
        
        for template_path in ios_templates:
            full_path = self.project_root / template_path
            if full_path.exists():
                with open(full_path, 'r') as f:
                    content = f.read()
                
                # Update bundle IDs
                if 'dev.plist' in template_path:
                    content = content.replace('com.example.flutter.projects.dev', f'{bundle_id}.dev')
                elif 'stg.plist' in template_path:
                    content = content.replace('com.example.flutter.projects.stg', f'{bundle_id}.stg')
                else:
                    content = content.replace('com.example.flutter.projects', bundle_id)
                
                with open(full_path, 'w') as f:
                    f.write(content)
        
        print("✅ Updated Firebase configuration templates")
    
    def update_documentation(self):
        """Update documentation with new package names"""
        readme_path = self.project_root / "README.md"
        if readme_path.exists():
            with open(readme_path, 'r') as f:
                content = f.read()
            
            # Update title and description
            content = re.sub(
                r'^# .*$',
                f'# {self.new_project_name}',
                content,
                flags=re.MULTILINE
            )
            
            # Update package references
            content = content.replace('flutter_projects', self.new_package_name)
            content = content.replace('com.example.flutter.projects', f'{self.organization}.{self.new_package_name}')
            
            with open(readme_path, 'w') as f:
                f.write(content)
        
        print("✅ Updated documentation")
    
    def run_flutter_commands(self):
        """Run Flutter commands to finalize setup"""
        print("\n🔧 Running Flutter commands...")
        
        try:
            # Clean and get dependencies
            subprocess.run(['flutter', 'clean'], check=True, capture_output=True)
            subprocess.run(['flutter', 'pub', 'get'], check=True, capture_output=True)
            
            # Generate code
            subprocess.run(['dart', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'], 
                         check=True, capture_output=True)
            
            print("✅ Flutter setup completed")
            
        except subprocess.CalledProcessError as e:
            print(f"⚠️ Flutter command failed: {e}")
            print("You may need to run these commands manually:")
            print("  flutter clean")
            print("  flutter pub get")
            print("  dart run build_runner build --delete-conflicting-outputs")
    
    def create_setup_summary(self):
        """Create a setup summary file"""
        summary = f"""# {self.new_project_name} - Setup Summary

## 📱 Project Configuration
- **Project Name:** {self.new_project_name}
- **Package Name:** {self.new_package_name}
- **Organization:** {self.organization}

## 📦 Package Identifiers
- **Android Package:** {self.organization}.{self.new_package_name}
- **iOS Bundle ID:** {self.organization}.{self.new_package_name}

## 🌿 Environment Packages
- **Development:** {self.organization}.{self.new_package_name}.dev
- **Staging:** {self.organization}.{self.new_package_name}.stg
- **Production:** {self.organization}.{self.new_package_name}

## 🔥 Next Steps
1. Set up Firebase projects with the package names above
2. Update Firebase configuration templates in `config/templates/`
3. Configure GitHub secrets for CI/CD
4. Start developing your app!

## 📖 Documentation
- See `docs/` folder for complete setup guides
- Run `./scripts/setup_firebase.sh` for Firebase configuration help
- Check `config/README.md` for Firebase setup instructions

Generated on: {subprocess.check_output(['date']).decode().strip()}
"""
        
        with open(self.project_root / "PROJECT_SETUP.md", 'w') as f:
            f.write(summary)
        
        print("✅ Created PROJECT_SETUP.md with configuration details")
    
    def run_setup(self):
        """Run the complete setup process"""
        self.welcome_message()
        self.get_user_input()
        
        print("\n🔧 Configuring project...")
        
        self.update_pubspec_yaml()
        self.update_android_config()
        self.update_ios_config()
        self.update_firebase_templates()
        self.update_documentation()
        self.run_flutter_commands()
        self.create_setup_summary()
        
        print("\n🎉 Setup Complete!")
        print("=" * 50)
        print(f"✅ Project '{self.new_project_name}' is ready!")
        print(f"📦 Package: {self.new_package_name}")
        print(f"🏢 Organization: {self.organization}")
        print()
        print("📋 Next Steps:")
        print("1. Set up Firebase projects (see PROJECT_SETUP.md)")
        print("2. Configure GitHub secrets for CI/CD")
        print("3. Start building your app!")
        print()
        print("📖 Documentation:")
        print("- PROJECT_SETUP.md - Your project configuration")
        print("- docs/ - Complete setup guides")
        print("- config/README.md - Firebase setup instructions")
        print()
        print("🚀 Happy coding!")

if __name__ == "__main__":
    setup = FlutterProjectSetup()
    setup.run_setup()
