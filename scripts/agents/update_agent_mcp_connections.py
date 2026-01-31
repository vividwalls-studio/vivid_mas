#!/usr/bin/env python3
"""
Update MCP connections in agent workflows
VividWalls Multi-Agent System
"""

import json
import os
from pathlib import Path
from typing import Dict, List, Any

# Base path for agent workflows
WORKFLOWS_PATH = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/workflows")

# MCP Server mappings for each agent
AGENT_MCP_MAPPINGS = {
    "business_manager_agent": {
        "executive_communication": [
            {
                "id": "telegram-mcp",
                "name": "Telegram MCP",
                "credential_id": "TelegramMCP",
                "credential_name": "Telegram MCP account",
                "tool_name": "send_message",
                "position": [3000, -100]
            },
            {
                "id": "email-mcp",
                "name": "Email MCP", 
                "credential_id": "SendGridMCP",
                "credential_name": "SendGrid MCP account",
                "tool_name": "send_email",
                "position": [3400, -100]
            },
            {
                "id": "html-report-mcp",
                "name": "HTML Report Generator MCP",
                "credential_id": "HTMLReportGeneratorMCP",
                "credential_name": "HTML Report Generator MCP account",
                "tool_name": "generate_report",
                "position": [3800, -100]
            }
        ],
        "agent_specific": [
            {
                "id": "bm-prompts-mcp",
                "name": "Business Manager Prompts MCP",
                "credential_id": "BusinessManagerPromptsMCP",
                "credential_name": "Business Manager Prompts MCP account",
                "tool_name": "get_prompt",
                "existing": True
            },
            {
                "id": "bm-resources-mcp",
                "name": "Business Manager Resources MCP",
                "credential_id": "BusinessManagerResourceMCP", 
                "credential_name": "Business Manager Resource MCP account",
                "tool_name": "get_resource",
                "existing": True
            }
        ],
        "analytics": [
            {
                "id": "kpi-dashboard-mcp",
                "name": "KPI Dashboard MCP",
                "credential_id": "KPIDashboardMCP",
                "credential_name": "KPI Dashboard MCP account",
                "tool_name": "get_business_kpis",
                "position": [4600, -100]
            }
        ],
        "core_services": [
            {
                "id": "linear-mcp",
                "name": "Linear MCP",
                "credential_id": "LinearMCP",
                "credential_name": "Linear MCP account",
                "tool_name": "create_issue",
                "position": [4200, -100]
            }
        ]
    },
    "marketing_director_agent": {
        "agent_specific": [
            {
                "id": "marketing-prompts-mcp",
                "name": "Marketing Director Prompts MCP",
                "credential_id": "MarketingDirectorPromptsMCP",
                "credential_name": "Marketing Director Prompts MCP account"
            },
            {
                "id": "marketing-resources-mcp",
                "name": "Marketing Director Resources MCP",
                "credential_id": "MarketingDirectorResourceMCP",
                "credential_name": "Marketing Director Resource MCP account"
            }
        ],
        "marketing_tools": [
            {
                "id": "shopify-mcp",
                "name": "Shopify MCP",
                "credential_id": "ShopifyMCP",
                "credential_name": "Shopify MCP account"
            },
            {
                "id": "wordpress-mcp",
                "name": "WordPress MCP",
                "credential_id": "WordPressMCP",
                "credential_name": "WordPress MCP account"
            },
            {
                "id": "sendgrid-mcp",
                "name": "SendGrid MCP",
                "credential_id": "SendGridMCP",
                "credential_name": "SendGrid MCP account"
            }
        ]
    },
    "sales_director_agent": {
        "agent_specific": [
            {
                "id": "sales-prompts-mcp",
                "name": "Sales Director Prompts MCP",
                "credential_id": "SalesDirectorPromptsMCP",
                "credential_name": "Sales Director Prompts MCP account"
            },
            {
                "id": "sales-resources-mcp",
                "name": "Sales Director Resources MCP",
                "credential_id": "SalesDirectorResourceMCP",
                "credential_name": "Sales Director Resource MCP account"
            }
        ],
        "sales_tools": [
            {
                "id": "shopify-mcp",
                "name": "Shopify MCP",
                "credential_id": "ShopifyMCP",
                "credential_name": "Shopify MCP account"
            },
            {
                "id": "stripe-mcp",
                "name": "Stripe MCP",
                "credential_id": "StripeMCP",
                "credential_name": "Stripe MCP account"
            },
            {
                "id": "twenty-mcp",
                "name": "Twenty CRM MCP",
                "credential_id": "TwentyMCP",
                "credential_name": "Twenty MCP account"
            }
        ]
    }
}

def create_mcp_tool_node(mcp_config: Dict[str, Any]) -> Dict[str, Any]:
    """Create an MCP tool node configuration"""
    node = {
        "parameters": {
            "operation": "executeTool",
            "toolName": f"={{{{ $fromAI('{mcp_config.get('tool_name', 'tool_name')}', 'Available tools') }}}}",
            "toolParameters": "={{ $fromAI('tool_parameters', 'Parameters for tool', 'json') }}"
        },
        "type": "n8n-nodes-mcp.mcpClientTool",
        "typeVersion": 1,
        "position": mcp_config.get("position", [2000, 0]),
        "id": mcp_config["id"],
        "name": mcp_config["name"],
        "credentials": {
            "mcpClientApi": {
                "id": mcp_config["credential_id"],
                "name": mcp_config["credential_name"]
            }
        }
    }
    return node

def update_workflow_mcp_connections(workflow_path: Path, agent_type: str):
    """Update MCP connections in a workflow file"""
    
    if not workflow_path.exists():
        print(f"Workflow file not found: {workflow_path}")
        return
    
    # Load workflow
    with open(workflow_path, 'r') as f:
        workflow = json.load(f)
    
    # Get MCP mappings for this agent
    mcp_mappings = AGENT_MCP_MAPPINGS.get(agent_type, {})
    if not mcp_mappings:
        print(f"No MCP mappings found for agent type: {agent_type}")
        return
    
    # Track nodes to add and update
    nodes_to_add = []
    nodes_to_update = {}
    
    # Process each MCP category
    for category, mcps in mcp_mappings.items():
        for mcp in mcps:
            existing_node = None
            
            # Check if node already exists
            for i, node in enumerate(workflow.get("nodes", [])):
                if node.get("id") == mcp["id"]:
                    existing_node = node
                    nodes_to_update[i] = mcp
                    break
            
            # If node doesn't exist and not marked as existing, create it
            if not existing_node and not mcp.get("existing", False):
                nodes_to_add.append(create_mcp_tool_node(mcp))
    
    # Update existing nodes
    for index, mcp_config in nodes_to_update.items():
        node = workflow["nodes"][index]
        
        # Update credentials if needed
        if "credential_id" in mcp_config:
            node["credentials"]["mcpClientApi"]["id"] = mcp_config["credential_id"]
            node["credentials"]["mcpClientApi"]["name"] = mcp_config["credential_name"]
        
        print(f"Updated node: {node['name']}")
    
    # Add new nodes
    workflow["nodes"].extend(nodes_to_add)
    for node in nodes_to_add:
        print(f"Added node: {node['name']}")
    
    # Update connections - ensure all MCP tools connect to the agent
    agent_node_name = None
    for node in workflow["nodes"]:
        if "agent" in node.get("type", "").lower() and "langchain.agent" in node.get("type", ""):
            agent_node_name = node["name"]
            break
    
    if agent_node_name and "connections" in workflow:
        # Add connections for new MCP nodes
        for node in nodes_to_add:
            node_id = node["id"]
            if node_id not in workflow["connections"]:
                workflow["connections"][node_id] = {
                    "ai_tool": [[{
                        "node": agent_node_name,
                        "type": "ai_tool",
                        "index": 0
                    }]]
                }
                print(f"Added connection: {node_id} -> {agent_node_name}")
    
    # Save updated workflow
    output_path = workflow_path.with_suffix('.updated.json')
    with open(output_path, 'w') as f:
        json.dump(workflow, f, indent=2)
    
    print(f"Updated workflow saved to: {output_path}")
    return output_path

def main():
    """Main function to update all agent workflows"""
    
    # Define workflow paths
    workflow_updates = [
        {
            "path": WORKFLOWS_PATH / "core/orchestration/business_manager_agent.json",
            "agent_type": "business_manager_agent"
        },
        {
            "path": WORKFLOWS_PATH / "domains/marketing/marketing_director_agent.json",
            "agent_type": "marketing_director_agent"
        },
        {
            "path": WORKFLOWS_PATH / "domains/sales/sales_director_agent.json",
            "agent_type": "sales_director_agent"
        }
    ]
    
    print("Starting MCP connection updates for agent workflows...")
    print("-" * 60)
    
    for update in workflow_updates:
        print(f"\nProcessing: {update['path'].name}")
        print(f"Agent type: {update['agent_type']}")
        
        try:
            updated_path = update_workflow_mcp_connections(
                update['path'],
                update['agent_type']
            )
            if updated_path:
                print(f"✓ Successfully updated: {updated_path.name}")
        except Exception as e:
            print(f"✗ Error updating workflow: {e}")
    
    print("\n" + "-" * 60)
    print("MCP connection update complete!")
    print("\nNext steps:")
    print("1. Review the .updated.json files")
    print("2. Import updated workflows into n8n")
    print("3. Configure MCP credentials in n8n UI")
    print("4. Test MCP connections")

if __name__ == "__main__":
    main()