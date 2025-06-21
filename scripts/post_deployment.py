#!/usr/bin/env python3
"""
Post-Deployment Automation Script
Handles all post-release tasks after successful app store uploads
"""

import os
import json
import csv
import subprocess
import requests
from datetime import datetime
from typing import Dict, List, Optional
import yaml

class PostDeploymentAutomation:
    def __init__(self, platform: str, version: str, build_number: str):
        self.platform = platform.lower()
        self.version = version
        self.build_number = build_number
        self.timestamp = datetime.now().isoformat()
        self.commit_hash = self.get_commit_hash()
        self.branch_name = self.get_branch_name()
        self.triggered_by = self.get_triggered_by()
        
    def get_commit_hash(self) -> str:
        """Get current commit hash"""
        try:
            return subprocess.check_output(['git', 'rev-parse', 'HEAD']).decode().strip()
        except:
            return "unknown"
    
    def get_branch_name(self) -> str:
        """Get current branch name"""
        try:
            return subprocess.check_output(['git', 'rev-parse', '--abbrev-ref', 'HEAD']).decode().strip()
        except:
            return os.getenv('GITHUB_REF_NAME', 'unknown')
    
    def get_triggered_by(self) -> str:
        """Get who triggered the build"""
        return os.getenv('GITHUB_ACTOR', 'automated')
    
    def generate_changelog(self) -> str:
        """Generate changelog from git commits since last release"""
        try:
            # Get last release tag
            last_tag = subprocess.check_output(['git', 'describe', '--tags', '--abbrev=0']).decode().strip()
            # Get commits since last tag
            commits = subprocess.check_output([
                'git', 'log', f'{last_tag}..HEAD', '--pretty=format:- %s (%h)'
            ]).decode().strip()
            return commits if commits else "- Initial release"
        except:
            # If no previous tags, get recent commits
            try:
                commits = subprocess.check_output([
                    'git', 'log', '--oneline', '-10', '--pretty=format:- %s (%h)'
                ]).decode().strip()
                return commits
            except:
                return "- No changelog available"
    
    def send_slack_notification(self):
        """Send release notification to Slack"""
        webhook_url = os.getenv('SLACK_WEBHOOK_URL')
        if not webhook_url:
            print("⚠️ SLACK_WEBHOOK_URL not configured")
            return
        
        changelog = self.generate_changelog()
        platform_emoji = "🍎" if self.platform == "ios" else "🤖"
        store_name = "TestFlight" if self.platform == "ios" else "Play Store Internal"
        
        message = {
            "text": f"{platform_emoji} New {self.platform.upper()} Release Available!",
            "blocks": [
                {
                    "type": "header",
                    "text": {
                        "type": "plain_text",
                        "text": f"{platform_emoji} {self.platform.upper()} Release - v{self.version}"
                    }
                },
                {
                    "type": "section",
                    "fields": [
                        {"type": "mrkdwn", "text": f"*Version:* {self.version}"},
                        {"type": "mrkdwn", "text": f"*Build:* {self.build_number}"},
                        {"type": "mrkdwn", "text": f"*Platform:* {store_name}"},
                        {"type": "mrkdwn", "text": f"*Branch:* {self.branch_name}"},
                        {"type": "mrkdwn", "text": f"*Commit:* {self.commit_hash[:8]}"},
                        {"type": "mrkdwn", "text": f"*Triggered by:* {self.triggered_by}"},
                        {"type": "mrkdwn", "text": f"*Upload time:* {self.timestamp}"}
                    ]
                },
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": f"*📝 What's New:*\n```{changelog}```"
                    }
                },
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": f"*📱 Download Instructions:*\n{self.get_download_instructions()}"
                    }
                }
            ]
        }
        
        try:
            response = requests.post(webhook_url, json=message)
            if response.status_code == 200:
                print("✅ Slack notification sent successfully")
            else:
                print(f"❌ Failed to send Slack notification: {response.status_code}")
        except Exception as e:
            print(f"❌ Error sending Slack notification: {e}")
    
    def get_download_instructions(self) -> str:
        """Get platform-specific download instructions"""
        if self.platform == "ios":
            return "• Open TestFlight app on your iOS device\n• Check for new builds\n• Install and test the latest version"
        else:
            return "• Open Play Console Internal Testing link\n• Download and install the latest AAB\n• Test on your Android device"
    
    def create_release_notes(self):
        """Create/update release notes document"""
        changelog = self.generate_changelog()
        release_notes = f"""# Release Notes - v{self.version}

## 📱 {self.platform.upper()} Release
- **Version:** {self.version}
- **Build Number:** {self.build_number}
- **Release Date:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
- **Platform:** {self.platform.upper()}
- **Branch:** {self.branch_name}
- **Commit:** {self.commit_hash}
- **Triggered by:** {self.triggered_by}

## 📝 Changelog
{changelog}

## 📱 Download
{self.get_download_instructions()}

## 🧪 QA Checklist
- [ ] App launches successfully
- [ ] Core functionality works
- [ ] UI/UX is consistent
- [ ] Performance is acceptable
- [ ] No crashes or critical bugs
- [ ] Firebase analytics working
- [ ] Push notifications working (if applicable)

---
*Generated automatically by CI/CD pipeline*
"""
        
        # Save to docs directory
        os.makedirs('docs/releases', exist_ok=True)
        filename = f"docs/releases/v{self.version}-{self.platform}.md"
        with open(filename, 'w') as f:
            f.write(release_notes)
        print(f"✅ Release notes created: {filename}")
        
        return release_notes
    
    def log_metadata(self):
        """Log release metadata for historical tracking"""
        metadata = {
            'timestamp': self.timestamp,
            'platform': self.platform,
            'version': self.version,
            'build_number': self.build_number,
            'commit_hash': self.commit_hash,
            'branch_name': self.branch_name,
            'triggered_by': self.triggered_by,
            'status': 'success'
        }
        
        # JSON log
        os.makedirs('logs', exist_ok=True)
        json_file = 'logs/release_history.json'
        
        # Load existing data
        history = []
        if os.path.exists(json_file):
            with open(json_file, 'r') as f:
                history = json.load(f)
        
        history.append(metadata)
        
        with open(json_file, 'w') as f:
            json.dump(history, f, indent=2)
        
        # CSV log
        csv_file = 'logs/release_history.csv'
        file_exists = os.path.exists(csv_file)
        
        with open(csv_file, 'a', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=metadata.keys())
            if not file_exists:
                writer.writeheader()
            writer.writerow(metadata)
        
        print(f"✅ Metadata logged to {json_file} and {csv_file}")
    
    def create_git_tag(self):
        """Create and push git tag for release"""
        tag_name = f"release-{self.platform}-v{self.version}"
        
        try:
            # Create tag
            subprocess.run(['git', 'tag', '-a', tag_name, '-m', f'{self.platform.upper()} release v{self.version}'], check=True)
            # Push tag
            subprocess.run(['git', 'push', 'origin', tag_name], check=True)
            print(f"✅ Git tag created and pushed: {tag_name}")
        except subprocess.CalledProcessError as e:
            print(f"❌ Failed to create git tag: {e}")
    
    def trigger_qa_process(self):
        """Trigger QA checklist process"""
        # This would integrate with Notion, Trello, or Jira
        # For now, we'll create a local QA checklist
        
        qa_checklist = {
            'title': f'QA Testing - {self.platform.upper()} v{self.version}',
            'platform': self.platform,
            'version': self.version,
            'build_number': self.build_number,
            'download_instructions': self.get_download_instructions(),
            'changelog': self.generate_changelog(),
            'checklist': [
                'App launches successfully',
                'Core functionality works',
                'UI/UX is consistent',
                'Performance is acceptable',
                'No crashes or critical bugs',
                'Firebase analytics working',
                'Push notifications working (if applicable)',
                'Regression testing completed'
            ],
            'assigned_qa': os.getenv('QA_ASSIGNEE', 'QA Team'),
            'created_at': self.timestamp
        }
        
        # Save QA checklist
        os.makedirs('qa', exist_ok=True)
        qa_file = f"qa/qa-checklist-v{self.version}-{self.platform}.json"
        with open(qa_file, 'w') as f:
            json.dump(qa_checklist, f, indent=2)
        
        print(f"✅ QA checklist created: {qa_file}")
        
        # TODO: Integrate with actual QA tools
        # - Notion API for creating pages
        # - Trello API for creating cards
        # - Jira API for creating tickets
    
    def run_all_tasks(self):
        """Execute all post-deployment tasks"""
        print(f"🚀 Starting post-deployment automation for {self.platform.upper()} v{self.version}")
        
        # 1. Send notifications
        self.send_slack_notification()
        
        # 2. Create release notes
        self.create_release_notes()
        
        # 3. Log metadata
        self.log_metadata()
        
        # 4. Create git tag
        self.create_git_tag()
        
        # 5. Trigger QA process
        self.trigger_qa_process()
        
        print(f"✅ Post-deployment automation completed for {self.platform.upper()} v{self.version}")

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) != 4:
        print("Usage: python post_deployment.py <platform> <version> <build_number>")
        sys.exit(1)
    
    platform = sys.argv[1]
    version = sys.argv[2]
    build_number = sys.argv[3]
    
    automation = PostDeploymentAutomation(platform, version, build_number)
    automation.run_all_tasks()
