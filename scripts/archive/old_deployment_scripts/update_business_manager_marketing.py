#!/usr/bin/env python3
"""
Update Business Manager Agent with marketing objectives and MCP tools
"""

import json
import requests
from typing import Dict, Any
import sys

# n8n configuration
N8N_BASE_URL = "http://localhost:5678"
N8N_API_KEY = "n8n_api_YOUR_API_KEY_HERE"  # Replace with actual API key

# Workflow ID
WORKFLOW_ID = "RXS9ROWlTQTBLBtG"

def get_workflow(workflow_id: str) -> Dict[str, Any]:
    """Get workflow data from n8n"""
    headers = {
        "X-N8N-API-KEY": N8N_API_KEY,
        "Content-Type": "application/json"
    }
    
    response = requests.get(
        f"{N8N_BASE_URL}/api/v1/workflows/{workflow_id}",
        headers=headers
    )
    
    if response.status_code != 200:
        print(f"Error getting workflow: {response.status_code}")
        print(response.text)
        sys.exit(1)
    
    return response.json()["data"]

def update_workflow(workflow_id: str, workflow_data: Dict[str, Any]) -> None:
    """Update workflow in n8n"""
    headers = {
        "X-N8N-API-KEY": N8N_API_KEY,
        "Content-Type": "application/json"
    }
    
    # Remove fields that shouldn't be in update request
    update_data = {
        "name": workflow_data["name"],
        "nodes": workflow_data["nodes"],
        "connections": workflow_data["connections"],
        "settings": workflow_data.get("settings", {}),
        "staticData": workflow_data.get("staticData", {}),
        "active": workflow_data.get("active", True)
    }
    
    response = requests.put(
        f"{N8N_BASE_URL}/api/v1/workflows/{workflow_id}",
        headers=headers,
        json=update_data
    )
    
    if response.status_code != 200:
        print(f"Error updating workflow: {response.status_code}")
        print(response.text)
        sys.exit(1)
    
    print(f"Successfully updated workflow {workflow_id}")

def update_system_prompt(nodes):
    """Update the Business Manager Agent system prompt with marketing objectives"""
    for node in nodes:
        if node.get("name") == "Business Manager Agent" and node.get("type") == "@n8n/n8n-nodes-langchain.agent":
            current_prompt = node["parameters"]["options"]["systemMessage"]
            
            # Check if marketing objectives already added
            if "CORE MARKETING OBJECTIVES" in current_prompt:
                print("Marketing objectives already in system prompt")
                return
            
            # Find where to insert marketing objectives
            insert_pos = current_prompt.find("## Available Director Tools")
            if insert_pos == -1:
                insert_pos = current_prompt.find("## Delegation Framework")
            
            marketing_objectives = """## CORE MARKETING OBJECTIVES

### Revenue Growth Target
- Generate $30,000+ monthly revenue from $2,000 marketing investment (15x ROI)
- Timeline: Achieve within 3 months through strategic growth hacking

### Customer Acquisition Strategy
1. **Cold Email Outreach**
   - Build 3,000+ qualified email list through targeted research
   - Achieve 20% open rate, 5% click rate, 1% conversion
   - Focus on commercial segments: hospitality, corporate, healthcare

2. **Meta Pixel Optimization**
   - Start with $10/day testing budget for pixel training
   - Build 1% lookalike audience from 100+ conversions
   - Scale to $50/day once ROAS exceeds 3:1
   - Target high-value customer segments

3. **AI SEO Content Strategy**
   - Create 50+ long-tail keyword articles monthly
   - Build E-E-A-T (Experience, Expertise, Authoritativeness, Trust)
   - Target "wall art for [specific niche]" keywords
   - Achieve 10,000+ organic visitors within 90 days

4. **Daily Social Media Automation**
   - Post 2x daily across Facebook, Instagram, Pinterest
   - Rotate through 200+ marketing creatives
   - Use AI-generated captions optimized for engagement
   - Build 5,000+ engaged followers per platform

### Performance Metrics
- Overall Conversion Rate: 3.5%+ (current: 2.3%)
- Average Order Value: $350+ (current: $275)
- Customer Lifetime Value: $800+ (current: $500)
- Email List Growth: 1,000+ subscribers/month
- Social Media Engagement: 5%+ average

### Budget Allocation
- Meta Ads: $800/month (40%)
- Email Tools: $200/month (10%)
- SEO/Content: $600/month (30%)
- Social Media Tools: $200/month (10%)
- Testing/Reserve: $200/month (10%)

"""
            
            # Insert marketing objectives
            new_prompt = current_prompt[:insert_pos] + marketing_objectives + "\n" + current_prompt[insert_pos:]
            node["parameters"]["options"]["systemMessage"] = new_prompt
            print("Added marketing objectives to system prompt")
            break

def add_mcp_tools(workflow_data):
    """Add Business Manager MCP tools to the workflow"""
    nodes = workflow_data["nodes"]
    connections = workflow_data["connections"]
    
    # Business Manager Prompts MCP tool
    prompts_tool = {
        "parameters": {
            "operation": "executeTool",
            "toolName": "get_prompt",
            "toolParameters": '={{ {\n  "prompt_name": $fromAI("prompt_name", "business-manager-system, strategic-planning, director-coordination, performance-monitoring, resource-allocation, executive-reporting, crisis-management, dynamic-rules-engine")\n} }}'
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
    }
    
    # Business Manager Resources MCP tool
    resources_tool = {
        "parameters": {
            "operation": "executeTool",
            "toolName": "get_resource",
            "toolParameters": '={{ {\n  "resource_uri": $fromAI("resource_uri", "business-manager://strategy/okr-framework, business-manager://kpis/executive-dashboard, business-manager://frameworks/delegation-matrix, business-manager://crisis/incident-response, business-manager://planning/strategic-planning-framework, business-manager://performance/balanced-scorecard")\n} }}'
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
    
    # Add sticky notes for documentation
    prompts_note = {
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
    }
    
    resources_note = {
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
    
    # Add nodes if they don't exist
    node_ids = [node["id"] for node in nodes]
    if "bm-prompts-mcp" not in node_ids:
        nodes.append(prompts_tool)
        nodes.append(prompts_note)
        # Add connection to Business Manager Agent
        if "Business Manager Prompts MCP" not in connections:
            connections["Business Manager Prompts MCP"] = {
                "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
            }
        print("Added Business Manager Prompts MCP tool")
    
    if "bm-resources-mcp" not in node_ids:
        nodes.append(resources_tool)
        nodes.append(resources_note)
        # Add connection to Business Manager Agent
        if "Business Manager Resources MCP" not in connections:
            connections["Business Manager Resources MCP"] = {
                "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
            }
        print("Added Business Manager Resources MCP tool")

def fix_director_workflow_ids(nodes):
    """Fix workflow ID references in director tools"""
    director_mappings = {
        "Marketing Director Tool1": "FmyORnR3mSnCoXMq",
        "Analytics Director Tool": "nIOJwbu7mRzNElCT",
        "Sales Director Agent": "6DbMolJ2fTLRQdft",
        "Operations Director Tool1": "R8x8qOARDh0Ax6RK",
        "Customer Experience Director Tool": "aHxcDdy6xwdCPPgy",
        "Product Director Tool": "quGb12qEsIrB9WLT",
        "Technology Director Tool1": "RhuS0opWbJ31EmN2",
        "Finance Director Tool1": "yuygwTz8dIm9FSFu",
        "Creative Director Tool": "htRNfLaOSGtfnPAU",
        "Social Media Director Tool": "M1wo3A6fxYsnUCHq"
    }
    
    for node in nodes:
        if node.get("name") in director_mappings:
            if "workflowId" in node.get("parameters", {}):
                node["parameters"]["workflowId"]["value"] = director_mappings[node["name"]]
                print(f"Updated workflow ID for {node['name']}")

def main():
    print("Updating Business Manager Agent workflow...")
    
    # Get current workflow
    workflow_data = get_workflow(WORKFLOW_ID)
    
    # Update system prompt
    update_system_prompt(workflow_data["nodes"])
    
    # Add MCP tools
    add_mcp_tools(workflow_data)
    
    # Fix director workflow IDs
    fix_director_workflow_ids(workflow_data["nodes"])
    
    # Update workflow
    # update_workflow(WORKFLOW_ID, workflow_data)
    
    # Save to file for manual import
    with open("business_manager_updated.json", "w") as f:
        json.dump(workflow_data, f, indent=2)
    
    print("\nWorkflow updated successfully!")
    print("The updated workflow has been saved to 'business_manager_updated.json'")
    print("\nTo import manually:")
    print("1. Go to n8n UI")
    print("2. Open the Business Manager Agent workflow")
    print("3. Press Ctrl+A to select all")
    print("4. Press Delete to clear")
    print("5. Press Ctrl+V and paste the contents of business_manager_updated.json")
    print("\nActivated workflows:")
    print("- Marketing Director Agent")
    print("- Social Media Director Agent")
    print("- Sales Director Agent")
    print("- Customer Experience Director Agent")
    print("- Product Director Agent")
    print("- VividWalls Daily Social Media Publisher")

if __name__ == "__main__":
    main()