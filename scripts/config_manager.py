#!/usr/bin/env python3
"""
Configuration Manager for Multi-Environment Setup
Automatically copies the correct configuration files based on environment
"""

import os
import shutil
import json
from pathlib import Path

class ConfigManager:
    def __init__(self, environment: str = None):
        self.environment = environment or self.determine_environment()
        self.project_root = Path.cwd()
        self.config_templates = self.project_root / "config" / "templates"
        
    def determine_environment(self) -> str:
        """Determine environment based on branch name"""
        try:
            import subprocess
            branch = subprocess.check_output(['git', 'rev-parse', '--abbrev-ref', 'HEAD']).decode().strip()
            
            if branch.startswith('release/') or branch == 'main':
                return 'prod'
            elif branch in ['development', 'develop', 'dev'] or branch.startswith('qa/'):
                return 'stg'
            else:
                return 'dev'
        except:
            return 'dev'
    
    def copy_android_config(self):
        """Copy Android Firebase configuration"""
        source_file = self.config_templates / "android" / f"google-services-{self.environment}.json"
        target_file = self.project_root / "android" / "app" / "google-services.json"
        
        if source_file.exists():
            # Ensure target directory exists
            target_file.parent.mkdir(parents=True, exist_ok=True)
            
            # Copy the file
            shutil.copy2(source_file, target_file)
            print(f"✅ Copied Android config: {source_file.name} → google-services.json")
        else:
            print(f"⚠️ Android config template not found: {source_file}")
            print(f"   Please create: {source_file}")
    
    def copy_ios_config(self):
        """Copy iOS Firebase configuration"""
        source_file = self.config_templates / "ios" / f"GoogleService-Info-{self.environment}.plist"
        target_file = self.project_root / "ios" / "Runner" / "GoogleService-Info.plist"
        
        if source_file.exists():
            # Ensure target directory exists
            target_file.parent.mkdir(parents=True, exist_ok=True)
            
            # Copy the file
            shutil.copy2(source_file, target_file)
            print(f"✅ Copied iOS config: {source_file.name} → GoogleService-Info.plist")
        else:
            print(f"⚠️ iOS config template not found: {source_file}")
            print(f"   Please create: {source_file}")
    
    def create_environment_info(self):
        """Create environment information file"""
        env_info = {
            'environment': self.environment,
            'android_config': f"google-services-{self.environment}.json",
            'ios_config': f"GoogleService-Info-{self.environment}.plist",
            'description': self.get_environment_description()
        }
        
        # Ensure build_config directory exists
        build_config_dir = self.project_root / "build_config"
        build_config_dir.mkdir(exist_ok=True)
        
        # Write environment info
        with open(build_config_dir / "config_environment.json", 'w') as f:
            json.dump(env_info, f, indent=2)
        
        print(f"✅ Created config environment info: build_config/config_environment.json")
    
    def get_environment_description(self) -> str:
        """Get description for current environment"""
        descriptions = {
            'dev': 'Development environment for feature branches',
            'stg': 'Staging environment for QA and testing',
            'prod': 'Production environment for releases'
        }
        return descriptions.get(self.environment, 'Unknown environment')
    
    def apply_all_configs(self):
        """Apply all environment-specific configurations"""
        print(f"🔧 Applying {self.environment.upper()} environment configurations...")
        
        # Copy configuration files
        self.copy_android_config()
        self.copy_ios_config()
        self.create_environment_info()
        
        # Display summary
        self.display_summary()
    
    def display_summary(self):
        """Display configuration summary"""
        print("\n" + "="*60)
        print("🔧 CONFIGURATION SUMMARY")
        print("="*60)
        print(f"🌿 Environment: {self.environment.upper()}")
        print(f"📱 Description: {self.get_environment_description()}")
        print(f"🤖 Android Config: google-services-{self.environment}.json")
        print(f"🍎 iOS Config: GoogleService-Info-{self.environment}.plist")
        print("="*60)
        
        # Environment-specific notes
        if self.environment == 'dev':
            print("🔧 DEVELOPMENT Configuration")
            print("   - Firebase project: your-project-id-dev")
            print("   - Package: com.example.flutter.projects.dev")
        elif self.environment == 'stg':
            print("🧪 STAGING Configuration")
            print("   - Firebase project: your-project-id-stg")
            print("   - Package: com.example.flutter.projects.stg")
        else:
            print("🚀 PRODUCTION Configuration")
            print("   - Firebase project: your-project-id-prod")
            print("   - Package: com.example.flutter.projects")
        
        print("="*60 + "\n")

if __name__ == "__main__":
    import sys
    
    environment = sys.argv[1] if len(sys.argv) > 1 else None
    manager = ConfigManager(environment)
    manager.apply_all_configs()
