#!/usr/bin/env python3
"""
Environment Manager for Multi-Environment Package Structure
Automatically switches package names based on Git branch patterns
"""

import os
import re
import subprocess
import yaml
from typing import Dict, Optional

class EnvironmentManager:
    def __init__(self):
        self.base_package_name = self.get_base_package_name()
        self.current_branch = self.get_current_branch()
        self.environment = self.determine_environment()
        self.target_package_name = self.get_target_package_name()
        
    def get_base_package_name(self) -> str:
        """Extract base package name from pubspec.yaml"""
        try:
            with open('pubspec.yaml', 'r') as f:
                pubspec = yaml.safe_load(f)
                name = pubspec.get('name', 'flutter_projects')
                # Remove any existing environment suffixes
                base_name = re.sub(r'\.(dev|stg)$', '', name)
                return base_name
        except Exception as e:
            print(f"⚠️ Error reading pubspec.yaml: {e}")
            return 'flutter_projects'
    
    def get_current_branch(self) -> str:
        """Get current Git branch name"""
        try:
            branch = subprocess.check_output(['git', 'rev-parse', '--abbrev-ref', 'HEAD']).decode().strip()
            return branch
        except:
            return os.getenv('GITHUB_REF_NAME', 'main')
    
    def determine_environment(self) -> str:
        """Determine environment based on branch name"""
        branch = self.current_branch.lower()
        
        # Release branches (production)
        if branch.startswith('release/') or branch == 'main':
            return 'production'
        
        # Development/QA branches (staging)
        elif branch in ['development', 'develop', 'dev'] or branch.startswith('qa/'):
            return 'staging'
        
        # Feature branches (development)
        elif (branch.startswith('feature/') or 
              branch.startswith('feat/') or 
              branch.startswith('fix/') or 
              branch.startswith('hotfix/') or
              branch.startswith('bugfix/')):
            return 'development'
        
        # Default to development for unknown branches
        else:
            return 'development'
    
    def get_target_package_name(self) -> str:
        """Get target package name based on environment"""
        if self.environment == 'production':
            return self.base_package_name
        elif self.environment == 'staging':
            return f"{self.base_package_name}.stg"
        else:  # development
            return f"{self.base_package_name}.dev"
    
    def get_android_package_name(self) -> str:
        """Convert Flutter package name to Android package format"""
        # Convert snake_case to dot notation for Android
        android_name = self.target_package_name.replace('_', '.')
        # Ensure it starts with com. if not already
        if not android_name.startswith('com.'):
            android_name = f"com.example.{android_name}"
        return android_name
    
    def get_ios_bundle_id(self) -> str:
        """Convert Flutter package name to iOS bundle ID format"""
        # Convert snake_case to dot notation for iOS
        bundle_id = self.target_package_name.replace('_', '.')
        # Ensure it starts with com. if not already
        if not bundle_id.startswith('com.'):
            bundle_id = f"com.example.{bundle_id}"
        return bundle_id
    
    def update_pubspec_yaml(self):
        """Update pubspec.yaml with environment-specific package name"""
        try:
            with open('pubspec.yaml', 'r') as f:
                content = f.read()
            
            # Update name field
            content = re.sub(
                r'^name:\s*.*$',
                f'name: {self.target_package_name}',
                content,
                flags=re.MULTILINE
            )
            
            with open('pubspec.yaml', 'w') as f:
                f.write(content)
            
            print(f"✅ Updated pubspec.yaml: name = {self.target_package_name}")
            
        except Exception as e:
            print(f"❌ Error updating pubspec.yaml: {e}")
    
    def update_android_config(self):
        """Update Android configuration files"""
        android_package = self.get_android_package_name()
        
        # Update build.gradle.kts
        self.update_android_build_gradle(android_package)
        
        # Update AndroidManifest.xml files
        self.update_android_manifests(android_package)
        
        print(f"✅ Updated Android config: package = {android_package}")
    
    def update_android_build_gradle(self, package_name: str):
        """Update Android build.gradle.kts with new package name"""
        build_gradle_path = 'android/app/build.gradle.kts'
        
        try:
            with open(build_gradle_path, 'r') as f:
                content = f.read()
            
            # Update applicationId
            content = re.sub(
                r'applicationId\s*=\s*"[^"]*"',
                f'applicationId = "{package_name}"',
                content
            )
            
            with open(build_gradle_path, 'w') as f:
                f.write(content)
                
        except Exception as e:
            print(f"⚠️ Error updating build.gradle.kts: {e}")
    
    def update_android_manifests(self, package_name: str):
        """Update AndroidManifest.xml files with new package name"""
        manifest_paths = [
            'android/app/src/main/AndroidManifest.xml',
            'android/app/src/debug/AndroidManifest.xml',
            'android/app/src/profile/AndroidManifest.xml'
        ]
        
        for manifest_path in manifest_paths:
            try:
                if os.path.exists(manifest_path):
                    with open(manifest_path, 'r') as f:
                        content = f.read()
                    
                    # Update package attribute
                    content = re.sub(
                        r'package="[^"]*"',
                        f'package="{package_name}"',
                        content
                    )
                    
                    with open(manifest_path, 'w') as f:
                        f.write(content)
                        
            except Exception as e:
                print(f"⚠️ Error updating {manifest_path}: {e}")
    
    def update_ios_config(self):
        """Update iOS configuration files"""
        bundle_id = self.get_ios_bundle_id()
        
        # Update Info.plist
        self.update_ios_info_plist(bundle_id)
        
        # Update project.pbxproj if needed
        self.update_ios_project_config(bundle_id)
        
        print(f"✅ Updated iOS config: bundle ID = {bundle_id}")
    
    def update_ios_info_plist(self, bundle_id: str):
        """Update iOS Info.plist with new bundle identifier"""
        info_plist_path = 'ios/Runner/Info.plist'
        
        try:
            if os.path.exists(info_plist_path):
                with open(info_plist_path, 'r') as f:
                    content = f.read()
                
                # Update CFBundleIdentifier
                content = re.sub(
                    r'<key>CFBundleIdentifier</key>\s*<string>[^<]*</string>',
                    f'<key>CFBundleIdentifier</key>\n\t<string>{bundle_id}</string>',
                    content
                )
                
                with open(info_plist_path, 'w') as f:
                    f.write(content)
                    
        except Exception as e:
            print(f"⚠️ Error updating Info.plist: {e}")
    
    def update_ios_project_config(self, bundle_id: str):
        """Update iOS project configuration"""
        # This would typically involve updating the Xcode project file
        # For now, we'll create a simple configuration note
        config_note = f"""
# iOS Bundle ID Configuration
# Environment: {self.environment}
# Bundle ID: {bundle_id}
# Branch: {self.current_branch}
"""
        
        try:
            os.makedirs('ios/configuration', exist_ok=True)
            with open('ios/configuration/environment.txt', 'w') as f:
                f.write(config_note)
        except Exception as e:
            print(f"⚠️ Error creating iOS config note: {e}")
    
    def create_environment_info(self):
        """Create environment information file"""
        env_info = {
            'environment': self.environment,
            'branch': self.current_branch,
            'flutter_package_name': self.target_package_name,
            'android_package_name': self.get_android_package_name(),
            'ios_bundle_id': self.get_ios_bundle_id(),
            'base_package_name': self.base_package_name
        }
        
        try:
            os.makedirs('build_config', exist_ok=True)
            with open('build_config/environment.json', 'w') as f:
                import json
                json.dump(env_info, f, indent=2)
            
            print(f"✅ Created environment info: build_config/environment.json")
            
        except Exception as e:
            print(f"⚠️ Error creating environment info: {e}")
    
    def apply_environment_config(self):
        """Apply all environment-specific configurations"""
        print(f"🔧 Configuring environment for branch: {self.current_branch}")
        print(f"📱 Environment: {self.environment}")
        print(f"📦 Target package: {self.target_package_name}")
        
        # Update all configuration files
        self.update_pubspec_yaml()
        self.update_android_config()
        self.update_ios_config()
        self.create_environment_info()
        
        print(f"✅ Environment configuration completed!")
        
        # Display summary
        self.display_summary()
    
    def display_summary(self):
        """Display configuration summary"""
        print("\n" + "="*60)
        print("📱 ENVIRONMENT CONFIGURATION SUMMARY")
        print("="*60)
        print(f"🌿 Branch: {self.current_branch}")
        print(f"🏷️  Environment: {self.environment.upper()}")
        print(f"📦 Flutter Package: {self.target_package_name}")
        print(f"🤖 Android Package: {self.get_android_package_name()}")
        print(f"🍎 iOS Bundle ID: {self.get_ios_bundle_id()}")
        print("="*60)
        
        # Environment-specific notes
        if self.environment == 'development':
            print("🔧 DEVELOPMENT Environment (.dev)")
            print("   - For feature branches and development work")
            print("   - Separate app instance for testing")
        elif self.environment == 'staging':
            print("🧪 STAGING Environment (.stg)")
            print("   - For QA and pre-production testing")
            print("   - Mirrors production configuration")
        else:
            print("🚀 PRODUCTION Environment")
            print("   - For release branches and production builds")
            print("   - Original package name")
        
        print("="*60 + "\n")

if __name__ == "__main__":
    manager = EnvironmentManager()
    manager.apply_environment_config()
