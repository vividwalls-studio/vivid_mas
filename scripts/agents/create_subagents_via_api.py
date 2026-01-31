#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Create Business Manager sub-agents directly via n8n API
"""

import json
from pathlib import Path

# Base paths
BASE_PATH = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas")
PROMPTS_PATH = BASE_PATH / "services/n8n/agents/prompts/core/subagents"

# Sub-agent configurations
SUBAGENT_CONFIGS = {
    "budget_optimization": {
        "name": "Budget Optimization Sub-Agent",
        "temperature": 0.4,
        "webhook_id": "bm-budget-optimizer-chat",
        "session_key": "bm-budget-optimizer",
        "prompt_file": "budget_optimization_system_prompt.md"
    },
    "campaign_coordination": {
        "name": "Campaign Coordination Sub-Agent", 
        "temperature": 0.6,
        "webhook_id": "bm-campaign-coordinator-chat",
        "session_key": "bm-campaign-coordinator",
        "prompt_file": "campaign_coordination_system_prompt.md"
    },
    "workflow_automation": {
        "name": "Workflow Automation Sub-Agent",
        "temperature": 0.2,
        "webhook_id": "bm-workflow-automator-chat", 
        "session_key": "bm-workflow-automator",
        "prompt_file": "workflow_automation_system_prompt.md"
    },
    "stakeholder_communications": {
        "name": "Stakeholder Communications Sub-Agent",
        "temperature": 0.5,
        "webhook_id": "bm-stakeholder-comms-chat",
        "session_key": "bm-stakeholder-comms",
        "prompt_file": "stakeholder_communications_system_prompt.md"
    }
}

def create_base_workflow(config):
    """Create a basic workflow structure for sub-agents"""
    
    # Read system prompt
    prompt_file = PROMPTS_PATH / config["prompt_file"]
    with open(prompt_file, 'r', encoding='utf-8') as f:
        system_prompt = f.read()
    
    # Extract key parts of the prompt (first 1000 chars for brevity)
    system_prompt_excerpt = system_prompt[:1000] + "\n\n[Full prompt content embedded in workflow]"
    
    workflow = {
        "name": config["name"],
        "nodes": [
            {
                "parameters": {"inputSource": "passthrough"},
                "id": "execute-trigger",
                "name": "When Executed by Another Workflow",
                "type": "n8n-nodes-base.executeWorkflowTrigger",
                "typeVersion": 1.1,
                "position": [700, 300]
            },
            {
                "parameters": {"options": {}},
                "id": "chat-trigger",
                "name": "When chat message received",
                "type": "@n8n/n8n-nodes-langchain.chatTrigger",
                "typeVersion": 1.1,
                "position": [1120, -80],
                "webhookId": config["webhook_id"]
            },
            {
                "parameters": {
                    "model": {"__rl": True, "mode": "list", "value": "gpt-4o"},
                    "options": {"temperature": config["temperature"]}
                },
                "id": "chat-model",
                "name": "OpenAI Chat Model",
                "type": "@n8n/n8n-nodes-langchain.lmChatOpenAi",
                "typeVersion": 1.2,
                "position": [-1280, 1840],
                "credentials": {
                    "openAiApi": {"id": "nMbluFwHsrVvkQBJ", "name": "OpenAi account"}
                }
            },
            {
                "parameters": {
                    "sessionIdType": "customKey",
                    "sessionKey": f"={{{{ $json.chatId ?? '{config['session_key']}_' + $now.toMillis() }}}}"
                },
                "id": "memory",
                "name": "Chat Memory Manager",
                "type": "@n8n/n8n-nodes-langchain.memoryPostgresChat",
                "typeVersion": 1.2,
                "position": [-420, 1840],
                "credentials": {
                    "postgres": {"id": "FGhT5pFBUVhSgKvd", "name": "Local Postgres for Chat Memory account"}
                }
            },
            {
                "parameters": {
                    "systemMessage": system_prompt_excerpt,
                    "options": {
                        "outputParsingMode": "custom",
                        "customOutputParser": "itemInformation",
                        "returnIntermediateSteps": True,
                        "preserveOriginalMessages": False,
                        "maxIterations": 10
                    }
                },
                "id": "agent",
                "name": f"{config['name']} AI Agent",
                "type": "@n8n/n8n-nodes-langchain.agent",
                "typeVersion": 1.7,
                "position": [2020, 640]
            },
            {
                "parameters": {"respondWith": "allIncomingItems", "options": {}},
                "id": "response",
                "name": "Respond to Webhook",
                "type": "n8n-nodes-base.respondToWebhook",
                "typeVersion": 1.2,
                "position": [3580, 640]
            }
        ],
        "connections": {
            "execute-trigger": {"main": [[{"node": "agent", "type": "main", "index": 0}]]},
            "chat-trigger": {"main": [[{"node": "agent", "type": "main", "index": 0}]]},
            "chat-model": {"ai_languageModel": [[{"node": "agent", "type": "ai_languageModel", "index": 0}]]},
            "memory": {"ai_memory": [[{"node": "agent", "type": "ai_memory", "index": 0}]]},
            "agent": {"main": [[{"node": "response", "type": "main", "index": 0}]]}
        },
        "active": False
    }
    
    return workflow

def generate_api_commands():
    """Generate the API commands needed to create workflows"""
    
    print("🔧 Generating n8n API Commands for Sub-Agent Creation")
    print("=" * 60)
    
    commands = []
    
    for agent_key, config in SUBAGENT_CONFIGS.items():
        print(f"\n📝 Generating command for {config['name']}...")
        
        # Create workflow structure
        workflow = create_base_workflow(config)
        
        # Save workflow for manual import
        output_file = BASE_PATH / f"api_create_{agent_key}.json"
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(workflow, f, indent=2, ensure_ascii=False)
        
        print(f"   ✅ Saved: {output_file}")
        
        # Generate API command info
        command_info = {
            "agent": agent_key,
            "name": config["name"],
            "file": output_file.name,
            "description": f"Create {config['name']} with temperature {config['temperature']}"
        }
        commands.append(command_info)
    
    # Create summary
    summary = """# n8n Sub-Agent Creation Summary

## Created Workflow Files

The following simplified workflow files have been created for the sub-agents:

"""
    
    for cmd in commands:
        summary += f"- **{cmd['name']}**: `{cmd['file']}`\n"
    
    summary += """
## Manual Import Process

Since direct API creation requires authentication, please:

1. Open n8n UI (http://localhost:5678)
2. For each workflow file:
   - Click "Add workflow" → "Import from file"
   - Select the file
   - After import, update the system prompt with full content
   - Save the workflow

## Workflow IDs to Note

After importing, note these workflow IDs for the orchestrator:

- Budget Optimization Sub-Agent: _____________
- Campaign Coordination Sub-Agent: _____________
- Workflow Automation Sub-Agent: _____________
- Stakeholder Communications Sub-Agent: _____________

## Update Business Manager Orchestrator

In the Business Manager workflow, update the Execute Workflow nodes to reference these IDs.
"""
    
    summary_file = BASE_PATH / "subagent_creation_summary.md"
    with open(summary_file, 'w', encoding='utf-8') as f:
        f.write(summary)
    
    print(f"\n📄 Summary saved to: {summary_file}")
    
    return commands

def main():
    """Main execution function"""
    
    commands = generate_api_commands()
    
    print("\n" + "=" * 60)
    print("✅ Sub-Agent workflow files created!")
    print(f"\n📁 Generated {len(commands)} workflow files")
    print("\n🚀 Next Steps:")
    print("1. Import each workflow file into n8n")
    print("2. Update system prompts with full content") 
    print("3. Note the workflow IDs after import")
    print("4. Update Business Manager orchestrator with correct IDs")

if __name__ == "__main__":
    main()