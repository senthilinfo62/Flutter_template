#!/usr/bin/env python3
"""
Slack notification templates for different release scenarios
"""

def get_success_template(platform: str, version: str, build_number: str, changelog: str, metadata: dict) -> dict:
    """Template for successful release notification"""
    platform_emoji = "🍎" if platform == "ios" else "🤖"
    store_name = "TestFlight" if platform == "ios" else "Play Store Internal"
    
    return {
        "text": f"{platform_emoji} New {platform.upper()} Release Available!",
        "blocks": [
            {
                "type": "header",
                "text": {
                    "type": "plain_text",
                    "text": f"{platform_emoji} {platform.upper()} Release - v{version}",
                    "emoji": True
                }
            },
            {
                "type": "section",
                "fields": [
                    {"type": "mrkdwn", "text": f"*Version:* {version}"},
                    {"type": "mrkdwn", "text": f"*Build:* {build_number}"},
                    {"type": "mrkdwn", "text": f"*Platform:* {store_name}"},
                    {"type": "mrkdwn", "text": f"*Branch:* {metadata.get('branch_name', 'unknown')}"},
                    {"type": "mrkdwn", "text": f"*Commit:* `{metadata.get('commit_hash', 'unknown')[:8]}`"},
                    {"type": "mrkdwn", "text": f"*Triggered by:* @{metadata.get('triggered_by', 'automated')}"}
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
                    "text": f"*📱 Download Instructions:*\n{get_download_instructions(platform)}"
                }
            },
            {
                "type": "actions",
                "elements": [
                    {
                        "type": "button",
                        "text": {
                            "type": "plain_text",
                            "text": "📋 View QA Checklist",
                            "emoji": True
                        },
                        "style": "primary",
                        "url": f"https://github.com/{metadata.get('repo', 'your-repo')}/blob/main/qa/qa-checklist-v{version}-{platform}.json"
                    },
                    {
                        "type": "button",
                        "text": {
                            "type": "plain_text",
                            "text": "📖 Release Notes",
                            "emoji": True
                        },
                        "url": f"https://github.com/{metadata.get('repo', 'your-repo')}/blob/main/docs/releases/v{version}-{platform}.md"
                    }
                ]
            }
        ]
    }

def get_failure_template(platform: str, version: str, error_message: str, metadata: dict) -> dict:
    """Template for failed release notification"""
    platform_emoji = "🍎" if platform == "ios" else "🤖"
    
    return {
        "text": f"❌ {platform.upper()} Release Failed!",
        "blocks": [
            {
                "type": "header",
                "text": {
                    "type": "plain_text",
                    "text": f"❌ {platform_emoji} {platform.upper()} Release Failed - v{version}",
                    "emoji": True
                }
            },
            {
                "type": "section",
                "fields": [
                    {"type": "mrkdwn", "text": f"*Version:* {version}"},
                    {"type": "mrkdwn", "text": f"*Platform:* {platform.upper()}"},
                    {"type": "mrkdwn", "text": f"*Branch:* {metadata.get('branch_name', 'unknown')}"},
                    {"type": "mrkdwn", "text": f"*Triggered by:* @{metadata.get('triggered_by', 'automated')}"}
                ]
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"*🚨 Error Details:*\n```{error_message}```"
                }
            },
            {
                "type": "actions",
                "elements": [
                    {
                        "type": "button",
                        "text": {
                            "type": "plain_text",
                            "text": "🔍 View Logs",
                            "emoji": True
                        },
                        "style": "danger",
                        "url": f"https://github.com/{metadata.get('repo', 'your-repo')}/actions"
                    }
                ]
            }
        ]
    }

def get_download_instructions(platform: str) -> str:
    """Get platform-specific download instructions"""
    if platform == "ios":
        return """• Open TestFlight app on your iOS device
• Check for new builds under "Flutter Projects"
• Install and test the latest version
• Report any issues in #qa-feedback"""
    else:
        return """• Open Play Console Internal Testing link
• Download and install the latest AAB
• Test on your Android device
• Report any issues in #qa-feedback"""

def get_qa_reminder_template(platform: str, version: str, qa_assignee: str) -> dict:
    """Template for QA testing reminder"""
    platform_emoji = "🍎" if platform == "ios" else "🤖"
    
    return {
        "text": f"🧪 QA Testing Required - {platform.upper()} v{version}",
        "blocks": [
            {
                "type": "header",
                "text": {
                    "type": "plain_text",
                    "text": f"🧪 QA Testing Required - {platform_emoji} v{version}",
                    "emoji": True
                }
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"Hey @{qa_assignee}! 👋\n\nA new {platform.upper()} build is ready for testing. Please complete the QA checklist and report any issues."
                }
            },
            {
                "type": "section",
                "fields": [
                    {"type": "mrkdwn", "text": f"*Platform:* {platform.upper()}"},
                    {"type": "mrkdwn", "text": f"*Version:* {version}"},
                    {"type": "mrkdwn", "text": f"*Assigned to:* @{qa_assignee}"},
                    {"type": "mrkdwn", "text": f"*Priority:* High"}
                ]
            }
        ]
    }
