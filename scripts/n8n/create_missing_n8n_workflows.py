#!/usr/bin/env python3
"""
Create missing n8n workflows based on data flow definitions
Using reference workflow templates
"""

import json
import uuid
from datetime import datetime
from pathlib import Path

# Base template structure from the reference workflows
def create_agent_workflow_template(agent_name, agent_key, webhook_path, system_prompt):
    """Create a standard agent workflow based on the reference template"""
    
    workflow_id = str(uuid.uuid4())
    
    workflow = {
        "name": f"VividWalls {agent_name} Agent",
        "nodes": [
            # Webhook trigger
            {
                "parameters": {
                    "httpMethod": "POST",
                    "path": webhook_path,
                    "responseMode": "responseNode",
                    "options": {}
                },
                "id": f"{workflow_id}-webhook",
                "name": "Webhook Trigger",
                "type": "n8n-nodes-base.webhook",
                "typeVersion": 2,
                "position": [250, 300],
                "webhookId": f"{agent_key}-webhook"
            },
            # Execute workflow trigger
            {
                "parameters": {
                    "workflowInputs": {
                        "values": [
                            {"name": "task_context"},
                            {"name": "priority"},
                            {"name": "deadline"}
                        ]
                    }
                },
                "id": f"{workflow_id}-execute",
                "name": "Execute from Director",
                "type": "n8n-nodes-base.executeWorkflowTrigger",
                "typeVersion": 1.1,
                "position": [250, 500]
            },
            # Chat trigger
            {
                "parameters": {
                    "options": {}
                },
                "type": "@n8n/n8n-nodes-langchain.chatTrigger",
                "typeVersion": 1.1,
                "position": [250, 100],
                "id": f"{workflow_id}-chat",
                "name": "When chat message received",
                "webhookId": f"{agent_key}-chat"
            },
            # OpenAI model
            {
                "parameters": {
                    "model": {
                        "__rl": True,
                        "mode": "list",
                        "value": "gpt-4o"
                    },
                    "options": {
                        "temperature": 0.7
                    }
                },
                "type": "@n8n/n8n-nodes-langchain.lmChatOpenAi",
                "typeVersion": 1.2,
                "position": [650, 300],
                "id": f"{workflow_id}-openai",
                "name": "OpenAI Chat Model",
                "credentials": {
                    "openAiApi": {
                        "id": "nMbluFwHsrVvkQBJ",
                        "name": "OpenAi account"
                    }
                }
            },
            # Memory
            {
                "parameters": {
                    "sessionKey": f"={{{{ $json.chatId || $json.session_id || '{agent_key}_' + $now.toMillis() }}}}"
                },
                "type": "@n8n/n8n-nodes-langchain.memoryPostgresChat",
                "typeVersion": 1.3,
                "position": [850, 300],
                "id": f"{workflow_id}-memory",
                "name": "Postgres Chat Memory",
                "credentials": {
                    "postgres": {
                        "id": "A84NDuNHTbqn50Xe",
                        "name": "Postgres account"
                    }
                }
            },
            # Main Agent
            {
                "parameters": {
                    "promptType": "define",
                    "text": "Follow your instructions",
                    "options": {
                        "systemMessage": system_prompt
                    }
                },
                "type": "@n8n/n8n-nodes-langchain.agent",
                "typeVersion": 1.9,
                "position": [1050, 300],
                "id": f"{workflow_id}-agent",
                "name": agent_name
            },
            # Response
            {
                "parameters": {
                    "options": {}
                },
                "type": "n8n-nodes-base.respondToWebhook",
                "typeVersion": 1.2,
                "position": [1450, 300],
                "id": f"{workflow_id}-respond",
                "name": "Respond to Webhook"
            }
        ],
        "connections": {
            "Webhook Trigger": {
                "main": [[{"node": agent_name, "type": "main", "index": 0}]]
            },
            "Execute from Director": {
                "main": [[{"node": agent_name, "type": "main", "index": 0}]]
            },
            "When chat message received": {
                "main": [[{"node": agent_name, "type": "main", "index": 0}]]
            },
            "OpenAI Chat Model": {
                "ai_languageModel": [[{"node": agent_name, "type": "ai_languageModel", "index": 0}]]
            },
            "Postgres Chat Memory": {
                "ai_memory": [[{"node": agent_name, "type": "ai_memory", "index": 0}]]
            },
            agent_name: {
                "main": [[{"node": "Respond to Webhook", "type": "main", "index": 0}]]
            }
        },
        "active": False,
        "settings": {
            "executionOrder": "v1"
        },
        "versionId": workflow_id,
        "meta": {
            "templateCredsSetupCompleted": True,
            "instanceId": workflow_id
        },
        "tags": []
    }
    
    return workflow

# Critical missing workflows to create
MISSING_WORKFLOWS = [
    {
        "name": "Campaign Manager",
        "key": "campaign-manager",
        "webhook": "campaign-manager",
        "prompt": """You are the Campaign Manager Agent for VividWalls Multi-Agent System.
Your role is to plan, execute, and optimize marketing campaigns across all channels.
You coordinate with Marketing Director, Content Strategy, and Social Media agents."""
    },
    {
        "name": "Copy Writer",
        "key": "copy-writer",
        "webhook": "copy-writer",
        "prompt": """You are the Copy Writer Agent for VividWalls Multi-Agent System.
Your role is to create compelling copy for marketing materials, product descriptions, and campaigns.
You work with Marketing Director and Content Strategy agents."""
    },
    {
        "name": "Copy Editor",
        "key": "copy-editor",
        "webhook": "copy-editor",
        "prompt": """You are the Copy Editor Agent for VividWalls Multi-Agent System.
Your role is to review, edit, and ensure quality of all written content.
You collaborate with Copy Writer and Content Strategy agents."""
    },
    {
        "name": "Email Marketing",
        "key": "email-marketing",
        "webhook": "email-marketing",
        "prompt": """You are the Email Marketing Agent for VividWalls Multi-Agent System.
Your role is to manage email campaigns, newsletters, and customer communications.
You work with Marketing Director and Campaign Manager agents."""
    },
    {
        "name": "Product Director",
        "key": "product-director",
        "webhook": "product-director",
        "prompt": """You are the Product Director Agent for VividWalls Multi-Agent System.
Your role is to oversee product strategy, development, and catalog management.
You coordinate with Business Manager and department directors."""
    },
    {
        "name": "Hospitality Sales",
        "key": "hospitality-sales",
        "webhook": "hospitality-sales",
        "prompt": """You are the Hospitality Sales Agent for VividWalls Multi-Agent System.
Your role is to manage B2B sales for hotels, restaurants, and hospitality venues.
You report to Sales Director and collaborate with Account Management."""
    },
    {
        "name": "Corporate Sales",
        "key": "corporate-sales",
        "webhook": "corporate-sales",
        "prompt": """You are the Corporate Sales Agent for VividWalls Multi-Agent System.
Your role is to manage B2B sales for corporate offices and commercial spaces.
You report to Sales Director and work with Partnership Development."""
    },
    {
        "name": "Healthcare Sales",
        "key": "healthcare-sales",
        "webhook": "healthcare-sales",
        "prompt": """You are the Healthcare Sales Agent for VividWalls Multi-Agent System.
Your role is to manage sales for healthcare facilities and medical offices.
You report to Sales Director and coordinate with specialized sales teams."""
    },
    {
        "name": "Pinterest",
        "key": "pinterest",
        "webhook": "pinterest",
        "prompt": """You are the Pinterest Agent for VividWalls Multi-Agent System.
Your role is to manage Pinterest presence, pins, boards, and engagement.
You report to Social Media Director and coordinate with Visual Content teams."""
    },
    {
        "name": "Twitter",
        "key": "twitter",
        "webhook": "twitter",
        "prompt": """You are the Twitter Agent for VividWalls Multi-Agent System.
Your role is to manage Twitter/X presence, tweets, and engagement.
You report to Social Media Director and coordinate with Content teams."""
    },
    {
        "name": "LinkedIn",
        "key": "linkedin",
        "webhook": "linkedin",
        "prompt": """You are the LinkedIn Agent for VividWalls Multi-Agent System.
Your role is to manage LinkedIn presence for B2B engagement and thought leadership.
You report to Social Media Director and work with Corporate Sales."""
    },
    {
        "name": "TikTok",
        "key": "tiktok",
        "webhook": "tiktok",
        "prompt": """You are the TikTok Agent for VividWalls Multi-Agent System.
Your role is to manage TikTok presence and create engaging video content.
You report to Social Media Director and coordinate with Creative teams."""
    },
    {
        "name": "YouTube",
        "key": "youtube",
        "webhook": "youtube",
        "prompt": """You are the YouTube Agent for VividWalls Multi-Agent System.
Your role is to manage YouTube channel, videos, and community engagement.
You report to Social Media Director and work with Video Content teams."""
    }
]

def main():
    """Generate workflow JSON files"""
    
    output_dir = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/n8n_workflows_to_import")
    output_dir.mkdir(exist_ok=True)
    
    print("🚀 Creating missing n8n workflows...")
    print("=" * 60)
    
    created_count = 0
    
    for workflow_config in MISSING_WORKFLOWS:
        workflow = create_agent_workflow_template(
            workflow_config["name"],
            workflow_config["key"],
            workflow_config["webhook"],
            workflow_config["prompt"]
        )
        
        # Save workflow JSON
        filename = f"{workflow_config['key']}-agent-workflow.json"
        filepath = output_dir / filename
        
        with open(filepath, 'w') as f:
            json.dump(workflow, f, indent=2)
        
        print(f"✅ Created: {filename}")
        created_count += 1
    
    print(f"\n✅ Created {created_count} workflow files")
    print(f"📁 Saved to: {output_dir}")
    
    # Create import instructions
    instructions = f"""
# N8N Workflow Import Instructions

## Files Created: {created_count}
Location: {output_dir}

## Import Methods:

### Method 1: Via n8n UI
1. Access n8n at https://n8n.vividwalls.blog
2. Go to Workflows > Import
3. Upload each JSON file

### Method 2: Via n8n CLI (on droplet)
```bash
cd /root/vivid_mas
for file in n8n_workflows_to_import/*.json; do
  docker exec n8n n8n import:workflow --input="$file"
done
```

### Method 3: Via n8n API
```bash
for file in n8n_workflows_to_import/*.json; do
  curl -X POST https://n8n.vividwalls.blog/api/v1/workflows \\
    -H "X-N8N-API-KEY: YOUR_API_KEY" \\
    -H "Content-Type: application/json" \\
    -d @"$file"
done
```

## Workflows Created:
"""
    
    for workflow_config in MISSING_WORKFLOWS:
        instructions += f"- {workflow_config['name']} Agent ({workflow_config['key']})\n"
    
    instructions_file = output_dir / "IMPORT_INSTRUCTIONS.md"
    with open(instructions_file, 'w') as f:
        f.write(instructions)
    
    print(f"\n📋 Import instructions saved to: {instructions_file}")

if __name__ == "__main__":
    main()