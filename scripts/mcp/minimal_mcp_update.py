#!/usr/bin/env python3
"""
Create minimal update to add MCP nodes to Business Manager Agent
"""

import json

# Read the new system prompt
with open('business_manager_system_prompt.txt', 'r') as f:
    new_system_prompt = f.read()

# Simple update data - just update the Business Manager Agent's system prompt
# and add the two MCP nodes
update_data = {
    "workflowId": "RXS9ROWlTQTBLBtG",
    "nodes": [
        # Update only the Business Manager Agent node with new system prompt
        {
            "id": "3e4955a3-4b0a-4ef5-a853-425d3bae3629",
            "name": "Business Manager Agent",
            "type": "@n8n/n8n-nodes-langchain.agent",
            "typeVersion": 2,
            "position": [1100, 400],
            "parameters": {
                "promptType": "define",
                "text": "={{$input }}",
                "options": {
                    "systemMessage": new_system_prompt
                }
            }
        },
        # Add the two new MCP nodes
        {
            "id": "bm-prompts-mcp",
            "name": "Business Manager Prompts MCP",
            "type": "n8n-nodes-mcp.mcpClientTool",
            "typeVersion": 1,
            "position": [1200, 500],
            "parameters": {
                "operation": "executeTool",
                "toolName": "get_prompt",
                "toolParameters": "={{ {\n  \"prompt_name\": $fromAI(\"prompt_name\", \"business-manager-system, strategic-planning, director-coordination, performance-monitoring, resource-allocation, executive-reporting, crisis-management, dynamic-rules-engine\")\n} }}"
            },
            "credentials": {
                "mcpClientApi": {
                    "id": "1sL2egXbdslY8cew",
                    "name": "WordPress MCP Client (STDIO) account"
                }
            }
        },
        {
            "id": "bm-resources-mcp",
            "name": "Business Manager Resources MCP",
            "type": "n8n-nodes-mcp.mcpClientTool",
            "typeVersion": 1,
            "position": [1300, 500],
            "parameters": {
                "operation": "executeTool",
                "toolName": "get_resource",
                "toolParameters": "={{ {\n  \"resource_uri\": $fromAI(\"resource_uri\", \"business-manager://strategy/okr-framework, business-manager://kpis/executive-dashboard, business-manager://frameworks/delegation-matrix, business-manager://crisis/incident-response, business-manager://planning/strategic-planning-framework, business-manager://performance/balanced-scorecard\")\n} }}"
            },
            "credentials": {
                "mcpClientApi": {
                    "id": "1sL2egXbdslY8cew",
                    "name": "WordPress MCP Client (STDIO) account"
                }
            }
        }
    ]
}

# Write minimal update
with open('minimal_update.json', 'w') as f:
    json.dump(update_data, f, indent=2)

print("✅ Created minimal update")
print("📁 Output: minimal_update.json")