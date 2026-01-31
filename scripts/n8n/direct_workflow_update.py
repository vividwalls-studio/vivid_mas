#!/usr/bin/env python3
"""
Direct workflow update using n8n MCP
"""

import json

# Read the new system prompt
with open('business_manager_system_prompt.txt', 'r') as f:
    new_system_prompt = f.read()

# Read current workflow from get_workflow output
with open('business_manager_current.json', 'r') as f:
    workflow = json.load(f)

# Update the Business Manager Agent's system prompt
for node in workflow['nodes']:
    if node['id'] == '3e4955a3-4b0a-4ef5-a853-425d3bae3629' and node['name'] == 'Business Manager Agent':
        node['parameters']['options']['systemMessage'] = new_system_prompt
        print("✅ Updated Business Manager Agent system prompt")
        break

# Add the two new MCP nodes if they don't exist
mcp_nodes = [
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

# Check if nodes already exist
existing_ids = {node['id'] for node in workflow['nodes']}
for mcp_node in mcp_nodes:
    if mcp_node['id'] not in existing_ids:
        workflow['nodes'].append(mcp_node)
        print(f"✅ Added {mcp_node['name']}")

# Add connections for the new MCP nodes
if 'connections' not in workflow:
    workflow['connections'] = {}

# Add connections for MCP nodes to Business Manager Agent
new_connections = {
    "Business Manager Prompts MCP": {
        "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
    },
    "Business Manager Resources MCP": {
        "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
    }
}

workflow['connections'].update(new_connections)
print("✅ Added MCP connections")

# Fix extreme node positions
print("\nFixing extreme node positions...")
for node in workflow['nodes']:
    if 'position' in node and len(node['position']) == 2:
        x, y = node['position']
        if abs(x) > 10000 or abs(y) > 10000:
            # Normalize extreme positions
            if abs(x) > 10000:
                new_x = 1000 + (x / abs(x)) * 2000
            else:
                new_x = x
            
            if abs(y) > 10000:
                new_y = 500 + (y / abs(y)) * 1000
            else:
                new_y = y
                
            node['position'] = [int(new_x), int(new_y)]
            print(f"  Fixed {node['name']}: [{x}, {y}] -> {node['position']}")

# Create update payload with only essential fields
update_payload = {
    "workflowId": "RXS9ROWlTQTBLBtG",
    "name": workflow['name'],
    "nodes": workflow['nodes'],
    "connections": workflow['connections'],
    "active": workflow.get('active', True),
    "tags": [tag['name'] for tag in workflow.get('tags', [])]
}

# Write the update payload
with open('workflow_update_payload.json', 'w') as f:
    json.dump(update_payload, f, indent=2)

print("\n✅ Created workflow update payload")
print("📁 Output: workflow_update_payload.json")
print(f"📊 Total nodes: {len(workflow['nodes'])}")
print(f"📊 Total connections: {len(workflow['connections'])}")