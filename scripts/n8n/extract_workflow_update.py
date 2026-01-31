#!/usr/bin/env python3
"""
Extract just the nodes and connections for the n8n MCP update_workflow function
"""

import json

# Read the complete updated workflow
with open('/Volumes/SeagatePortableDrive/Projects/vivid_mas/business_manager_updated_complete.json', 'r') as f:
    workflow = json.load(f)

# Extract just the fields that update_workflow accepts
update_data = {
    "workflowId": workflow["id"],
    "name": workflow["name"],
    "nodes": workflow["nodes"],
    "connections": workflow["connections"],
    "active": workflow["active"]
}

# Save the update data
with open('/Volumes/SeagatePortableDrive/Projects/vivid_mas/workflow_update_data.json', 'w') as f:
    json.dump(update_data, f, indent=2)

print("✅ Extracted update data for n8n MCP update_workflow function")
print(f"- Workflow ID: {update_data['workflowId']}")
print(f"- Total nodes: {len(update_data['nodes'])}")
print(f"- Active: {update_data['active']}")

# Check if new MCP nodes are included
mcp_nodes = [node for node in update_data['nodes'] if 'Business Manager' in node.get('name', '') and 'MCP' in node.get('name', '')]
print(f"\n✅ Business Manager MCP nodes found: {len(mcp_nodes)}")
for node in mcp_nodes:
    print(f"  - {node['name']}")

# Check if system prompt was updated
bm_agent_node = next((node for node in update_data['nodes'] if node.get('name') == 'Business Manager Agent'), None)
if bm_agent_node:
    system_message = bm_agent_node.get('parameters', {}).get('options', {}).get('systemMessage', '')
    if 'CORE MARKETING OBJECTIVES' in system_message:
        print("\n✅ Marketing objectives found in system prompt")
    else:
        print("\n❌ Marketing objectives NOT found in system prompt")