#!/usr/bin/env python3
"""
QA Automation Integration
Supports Notion, Trello, and Jira integrations
"""

import os
import json
import requests
from typing import Dict, List, Optional

class QAAutomation:
    def __init__(self, platform: str, version: str, build_number: str, changelog: str):
        self.platform = platform
        self.version = version
        self.build_number = build_number
        self.changelog = changelog
        
    def create_notion_page(self) -> bool:
        """Create QA checklist page in Notion"""
        notion_token = os.getenv('NOTION_TOKEN')
        notion_database_id = os.getenv('NOTION_QA_DATABASE_ID')
        
        if not notion_token or not notion_database_id:
            print("⚠️ Notion credentials not configured")
            return False
        
        headers = {
            'Authorization': f'Bearer {notion_token}',
            'Content-Type': 'application/json',
            'Notion-Version': '2022-06-28'
        }
        
        page_data = {
            "parent": {"database_id": notion_database_id},
            "properties": {
                "Title": {
                    "title": [
                        {
                            "text": {
                                "content": f"QA Testing - {self.platform.upper()} v{self.version}"
                            }
                        }
                    ]
                },
                "Platform": {
                    "select": {
                        "name": self.platform.upper()
                    }
                },
                "Version": {
                    "rich_text": [
                        {
                            "text": {
                                "content": self.version
                            }
                        }
                    ]
                },
                "Status": {
                    "select": {
                        "name": "Ready for Testing"
                    }
                },
                "Priority": {
                    "select": {
                        "name": "High"
                    }
                }
            },
            "children": [
                {
                    "object": "block",
                    "type": "heading_2",
                    "heading_2": {
                        "rich_text": [{"type": "text", "text": {"content": "📱 Release Information"}}]
                    }
                },
                {
                    "object": "block",
                    "type": "paragraph",
                    "paragraph": {
                        "rich_text": [
                            {"type": "text", "text": {"content": f"Platform: {self.platform.upper()}\n"}},
                            {"type": "text", "text": {"content": f"Version: {self.version}\n"}},
                            {"type": "text", "text": {"content": f"Build: {self.build_number}\n"}}
                        ]
                    }
                },
                {
                    "object": "block",
                    "type": "heading_2",
                    "heading_2": {
                        "rich_text": [{"type": "text", "text": {"content": "📝 What's New"}}]
                    }
                },
                {
                    "object": "block",
                    "type": "code",
                    "code": {
                        "rich_text": [{"type": "text", "text": {"content": self.changelog}}],
                        "language": "plain text"
                    }
                },
                {
                    "object": "block",
                    "type": "heading_2",
                    "heading_2": {
                        "rich_text": [{"type": "text", "text": {"content": "🧪 QA Checklist"}}]
                    }
                }
            ]
        }
        
        # Add checklist items
        checklist_items = [
            "App launches successfully",
            "Core functionality works",
            "UI/UX is consistent",
            "Performance is acceptable",
            "No crashes or critical bugs",
            "Firebase analytics working",
            "Push notifications working (if applicable)",
            "Regression testing completed"
        ]
        
        for item in checklist_items:
            page_data["children"].append({
                "object": "block",
                "type": "to_do",
                "to_do": {
                    "rich_text": [{"type": "text", "text": {"content": item}}],
                    "checked": False
                }
            })
        
        try:
            response = requests.post(
                'https://api.notion.com/v1/pages',
                headers=headers,
                json=page_data
            )
            
            if response.status_code == 200:
                page_url = response.json().get('url', '')
                print(f"✅ Notion QA page created: {page_url}")
                return True
            else:
                print(f"❌ Failed to create Notion page: {response.status_code}")
                return False
                
        except Exception as e:
            print(f"❌ Error creating Notion page: {e}")
            return False
    
    def create_trello_card(self) -> bool:
        """Create QA checklist card in Trello"""
        trello_key = os.getenv('TRELLO_API_KEY')
        trello_token = os.getenv('TRELLO_TOKEN')
        trello_list_id = os.getenv('TRELLO_QA_LIST_ID')
        
        if not all([trello_key, trello_token, trello_list_id]):
            print("⚠️ Trello credentials not configured")
            return False
        
        card_data = {
            'key': trello_key,
            'token': trello_token,
            'idList': trello_list_id,
            'name': f'QA Testing - {self.platform.upper()} v{self.version}',
            'desc': f"""## 📱 Release Information
Platform: {self.platform.upper()}
Version: {self.version}
Build: {self.build_number}

## 📝 What's New
```
{self.changelog}
```

## 🧪 QA Checklist
- [ ] App launches successfully
- [ ] Core functionality works
- [ ] UI/UX is consistent
- [ ] Performance is acceptable
- [ ] No crashes or critical bugs
- [ ] Firebase analytics working
- [ ] Push notifications working (if applicable)
- [ ] Regression testing completed

## 📱 Download Instructions
{self.get_download_instructions()}
""",
            'pos': 'top'
        }
        
        try:
            response = requests.post(
                'https://api.trello.com/1/cards',
                data=card_data
            )
            
            if response.status_code == 200:
                card_url = response.json().get('shortUrl', '')
                print(f"✅ Trello QA card created: {card_url}")
                return True
            else:
                print(f"❌ Failed to create Trello card: {response.status_code}")
                return False
                
        except Exception as e:
            print(f"❌ Error creating Trello card: {e}")
            return False
    
    def create_jira_ticket(self) -> bool:
        """Create QA testing ticket in Jira"""
        jira_url = os.getenv('JIRA_URL')
        jira_email = os.getenv('JIRA_EMAIL')
        jira_token = os.getenv('JIRA_API_TOKEN')
        jira_project_key = os.getenv('JIRA_PROJECT_KEY')
        
        if not all([jira_url, jira_email, jira_token, jira_project_key]):
            print("⚠️ Jira credentials not configured")
            return False
        
        headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        }
        
        ticket_data = {
            "fields": {
                "project": {
                    "key": jira_project_key
                },
                "summary": f"QA Testing - {self.platform.upper()} v{self.version}",
                "description": {
                    "type": "doc",
                    "version": 1,
                    "content": [
                        {
                            "type": "heading",
                            "attrs": {"level": 2},
                            "content": [{"type": "text", "text": "📱 Release Information"}]
                        },
                        {
                            "type": "paragraph",
                            "content": [
                                {"type": "text", "text": f"Platform: {self.platform.upper()}\n"},
                                {"type": "text", "text": f"Version: {self.version}\n"},
                                {"type": "text", "text": f"Build: {self.build_number}\n"}
                            ]
                        },
                        {
                            "type": "heading",
                            "attrs": {"level": 2},
                            "content": [{"type": "text", "text": "📝 What's New"}]
                        },
                        {
                            "type": "codeBlock",
                            "content": [{"type": "text", "text": self.changelog}]
                        }
                    ]
                },
                "issuetype": {
                    "name": "Task"
                },
                "priority": {
                    "name": "High"
                }
            }
        }
        
        try:
            response = requests.post(
                f'{jira_url}/rest/api/3/issue',
                headers=headers,
                json=ticket_data,
                auth=(jira_email, jira_token)
            )
            
            if response.status_code == 201:
                issue_key = response.json().get('key', '')
                issue_url = f"{jira_url}/browse/{issue_key}"
                print(f"✅ Jira QA ticket created: {issue_url}")
                return True
            else:
                print(f"❌ Failed to create Jira ticket: {response.status_code}")
                return False
                
        except Exception as e:
            print(f"❌ Error creating Jira ticket: {e}")
            return False
    
    def get_download_instructions(self) -> str:
        """Get platform-specific download instructions"""
        if self.platform == "ios":
            return "• Open TestFlight app on your iOS device\n• Check for new builds\n• Install and test the latest version"
        else:
            return "• Open Play Console Internal Testing link\n• Download and install the latest AAB\n• Test on your Android device"
    
    def trigger_all_qa_processes(self) -> Dict[str, bool]:
        """Trigger all configured QA processes"""
        results = {}
        
        print("🧪 Triggering QA automation processes...")
        
        # Try each integration
        results['notion'] = self.create_notion_page()
        results['trello'] = self.create_trello_card()
        results['jira'] = self.create_jira_ticket()
        
        successful = sum(results.values())
        total = len(results)
        
        print(f"✅ QA automation completed: {successful}/{total} integrations successful")
        
        return results
