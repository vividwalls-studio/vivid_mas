#!/usr/bin/env python3
"""
Precise workflow update for Business Manager Agent
This script creates exact node updates without extra parameters
"""

import json
import copy

# Read the current workflow
with open('/Volumes/SeagatePortableDrive/Projects/vivid_mas/business_manager_current.json', 'r') as f:
    current_workflow = json.load(f)

# Read the updated system prompt
with open('/Volumes/SeagatePortableDrive/Projects/vivid_mas/business_manager_system_prompt.txt', 'r') as f:
    new_system_prompt = f.read()

# Create a clean copy of nodes
updated_nodes = copy.deepcopy(current_workflow['nodes'])

# Update the Business Manager Agent system prompt
for node in updated_nodes:
    if node.get('name') == 'Business Manager Agent' and node.get('type') == '@n8n/n8n-nodes-langchain.agent':
        node['parameters']['options']['systemMessage'] = new_system_prompt
        print("✅ Updated Business Manager Agent system prompt")

# Add the two new MCP tool nodes
new_mcp_nodes = [
    {
        "parameters": {
            "operation": "executeTool",
            "toolName": "get_prompt",
            "toolParameters": "={{ {\n  \"prompt_name\": $fromAI(\"prompt_name\", \"business-manager-system, strategic-planning, director-coordination, performance-monitoring, resource-allocation, executive-reporting, crisis-management, dynamic-rules-engine\")\n} }}"
        },
        "type": "n8n-nodes-mcp.mcpClientTool",
        "typeVersion": 1,
        "position": [2200, -100],
        "id": "bm-prompts-mcp",
        "name": "Business Manager Prompts MCP",
        "credentials": {
            "mcpClientApi": {
                "id": "1sL2egXbdslY8cew",
                "name": "WordPress MCP Client (STDIO) account"
            }
        }
    },
    {
        "parameters": {
            "operation": "executeTool",
            "toolName": "get_resource",
            "toolParameters": "={{ {\n  \"resource_uri\": $fromAI(\"resource_uri\", \"business-manager://strategy/okr-framework, business-manager://kpis/executive-dashboard, business-manager://frameworks/delegation-matrix, business-manager://crisis/incident-response, business-manager://planning/strategic-planning-framework, business-manager://performance/balanced-scorecard\")\n} }}"
        },
        "type": "n8n-nodes-mcp.mcpClientTool",
        "typeVersion": 1,
        "position": [2600, -100],
        "id": "bm-resources-mcp",
        "name": "Business Manager Resources MCP",
        "credentials": {
            "mcpClientApi": {
                "id": "1sL2egXbdslY8cew",
                "name": "WordPress MCP Client (STDIO) account"
            }
        }
    }
]

# Check if nodes already exist
existing_node_ids = [node['id'] for node in updated_nodes]
for new_node in new_mcp_nodes:
    if new_node['id'] not in existing_node_ids:
        updated_nodes.append(new_node)
        print(f"✅ Added {new_node['name']}")

# Fix director workflow IDs
director_mappings = {
    "Marketing Director Tool1": "FmyORnR3mSnCoXMq",
    "Analytics Director Tool": "nIOJwbu7mRzNElCT",
    "Social Media Director Tool": "M1wo3A6fxYsnUCHq",
    "Sales Director Agent": "6DbMolJ2fTLRQdft",
    "Operations Director Tool1": "R8x8qOARDh0Ax6RK",
    "Customer Experience Director Tool": "aHxcDdy6xwdCPPgy",
    "Product Director Tool": "quGb12qEsIrB9WLT",
    "Technology Director Tool1": "RhuS0opWbJ31EmN2",
    "Finance Director Tool1": "yuygwTz8dIm9FSFu",
    "Creative Director Tool": "htRNfLaOSGtfnPAU"
}

for node in updated_nodes:
    if node.get('name') in director_mappings:
        if 'workflowId' in node.get('parameters', {}):
            node['parameters']['workflowId']['value'] = director_mappings[node['name']]
            print(f"✅ Updated workflow ID for {node['name']}")

# Create updated connections
updated_connections = copy.deepcopy(current_workflow['connections'])

# Add connections for new MCP tools
if 'Business Manager Prompts MCP' not in updated_connections:
    updated_connections['Business Manager Prompts MCP'] = {
        "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
    }
    print("✅ Added connection for Business Manager Prompts MCP")

if 'Business Manager Resources MCP' not in updated_connections:
    updated_connections['Business Manager Resources MCP'] = {
        "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
    }
    print("✅ Added connection for Business Manager Resources MCP")

# Extract tag names only (not the full objects)
tag_names = [tag['name'] for tag in current_workflow.get('tags', [])]

# Create the update data with ONLY the fields that update_workflow accepts
update_data = {
    "workflowId": current_workflow['id'],
    "name": current_workflow['name'],
    "nodes": updated_nodes,
    "connections": updated_connections,
    "active": current_workflow['active'],
    "tags": tag_names  # Just the tag names, not the full objects
}

# Save the update data
with open('precise_update_data.json', 'w') as f:
    json.dump(update_data, f, indent=2)

print("\n✅ Created precise update data")
print(f"Total nodes: {len(updated_nodes)}")
print(f"Total connections: {len(updated_connections)}")
print(f"Tags: {tag_names}")

# Also save just the nodes and connections separately for easier manipulation
nodes_only = {
    "nodes": updated_nodes
}
with open('nodes_only.json', 'w') as f:
    json.dump(nodes_only, f, indent=2)

connections_only = {
    "connections": updated_connections
}
with open('connections_only.json', 'w') as f:
    json.dump(connections_only, f, indent=2)

print("\n📁 Files created:")
print("- precise_update_data.json (complete update)")
print("- nodes_only.json (just nodes)")
print("- connections_only.json (just connections)")