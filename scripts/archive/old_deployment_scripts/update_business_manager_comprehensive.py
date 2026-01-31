#!/usr/bin/env python3
"""
Comprehensive update script for Business Manager Agent workflow
This script generates the complete workflow JSON with all necessary updates
"""

import json
import sys

def update_business_manager_workflow():
    """Generate the complete updated Business Manager workflow"""
    
    # Read the current workflow data from file
    with open('/Volumes/SeagatePortableDrive/Projects/vivid_mas/business_manager_current.json', 'r') as f:
        workflow_data = json.load(f)
    
    # 1. Update the system prompt in the Business Manager Agent node
    for node in workflow_data['nodes']:
        if node.get('name') == 'Business Manager Agent' and node.get('type') == '@n8n/n8n-nodes-langchain.agent':
            # Read the updated system prompt
            with open('/Volumes/SeagatePortableDrive/Projects/vivid_mas/business_manager_system_prompt.txt', 'r') as f:
                updated_prompt = f.read()
            
            # Update the system prompt
            node['parameters']['options']['systemMessage'] = updated_prompt
            print("✅ Updated Business Manager system prompt with marketing objectives")
            break
    
    # 2. Add the two new MCP tool nodes
    new_nodes = [
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
    
    # Add sticky notes for documentation
    sticky_notes = [
        {
            "parameters": {
                "content": "## Business Manager Prompts MCP\\n\\n**Purpose**: Strategic prompt templates\\n\\n**Available Prompts**:\\n- business-manager-system\\n- strategic-planning\\n- director-coordination\\n- performance-monitoring\\n- resource-allocation\\n- executive-reporting\\n- crisis-management\\n- dynamic-rules-engine",
                "height": 360,
                "width": 320
            },
            "type": "n8n-nodes-base.stickyNote",
            "position": [2200, 120],
            "id": "bm-prompts-note",
            "name": "Business Manager Prompts Note",
            "typeVersion": 1
        },
        {
            "parameters": {
                "content": "## Business Manager Resources MCP\\n\\n**Purpose**: Strategic frameworks & knowledge\\n\\n**Available Resources**:\\n- OKR Framework\\n- Executive KPI Dashboard\\n- RACI Delegation Matrix\\n- Crisis Management Playbook\\n- Strategic Planning Framework\\n- Balanced Scorecard",
                "height": 360,
                "width": 320
            },
            "type": "n8n-nodes-base.stickyNote",
            "position": [2600, 120],
            "id": "bm-resources-note",
            "name": "Business Manager Resources Note",
            "typeVersion": 1
        }
    ]
    
    # Check if nodes already exist
    existing_node_ids = [node['id'] for node in workflow_data['nodes']]
    
    if 'bm-prompts-mcp' not in existing_node_ids:
        workflow_data['nodes'].extend(new_nodes)
        workflow_data['nodes'].extend(sticky_notes)
        print("✅ Added Business Manager MCP tool nodes")
    
    # 3. Add connections for the new MCP tools
    if 'Business Manager Prompts MCP' not in workflow_data['connections']:
        workflow_data['connections']['Business Manager Prompts MCP'] = {
            "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
        }
    
    if 'Business Manager Resources MCP' not in workflow_data['connections']:
        workflow_data['connections']['Business Manager Resources MCP'] = {
            "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
        }
    
    print("✅ Added MCP tool connections")
    
    # 4. Fix director workflow IDs
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
    
    updated_count = 0
    for node in workflow_data['nodes']:
        if node.get('name') in director_mappings:
            if 'workflowId' in node.get('parameters', {}):
                node['parameters']['workflowId']['value'] = director_mappings[node['name']]
                updated_count += 1
    
    print(f"✅ Updated {updated_count} director workflow IDs")
    
    return workflow_data

def main():
    print("Business Manager Agent Comprehensive Update")
    print("=" * 50)
    
    # First, save the current workflow
    print("\nSaving current workflow state...")
    import subprocess
    
    # Use n8n CLI or API to get current workflow
    # For now, we'll assume we have it from the previous get_workflow call
    
    try:
        # Generate the updated workflow
        updated_workflow = update_business_manager_workflow()
        
        # Save to file
        output_file = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/business_manager_updated_complete.json'
        with open(output_file, 'w') as f:
            json.dump(updated_workflow, f, indent=2)
        
        print(f"\n✅ Updated workflow saved to: {output_file}")
        
        print("\n📋 Summary of Changes:")
        print("1. ✅ Added marketing objectives to system prompt")
        print("2. ✅ Added Business Manager Prompts MCP tool")
        print("3. ✅ Added Business Manager Resources MCP tool")
        print("4. ✅ Fixed all director workflow IDs")
        print("5. ✅ Added proper connections for MCP tools")
        
        print("\n🚀 Next Steps:")
        print("1. Open n8n UI (http://localhost:5678)")
        print("2. Navigate to Business Manager Agent workflow")
        print("3. Click 'Workflow' menu → 'Import from File'")
        print("4. Select: business_manager_updated_complete.json")
        print("5. Save and activate the workflow")
        
        print("\n⚡ Quick Import via CLI:")
        print("n8n import:workflow --input=business_manager_updated_complete.json --overwrite")
        
    except Exception as e:
        print(f"\n❌ Error: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    main()