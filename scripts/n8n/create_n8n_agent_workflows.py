#!/usr/bin/env python3
"""
Create n8n Workflows for All New Agents
This script generates n8n workflow JSON files for each new agent
"""

import json
import uuid
from pathlib import Path
from datetime import datetime

# Base paths
BASE_PATH = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas")
MCP_DATA_PATH = BASE_PATH / "services/mcp-servers/mcp_data"
N8N_WORKFLOWS_PATH = BASE_PATH / "services/n8n/agents/workflows"

def load_json(file_path):
    """Load JSON file"""
    with open(file_path, 'r') as f:
        return json.load(f)

def save_json(data, file_path):
    """Save JSON file with proper formatting"""
    with open(file_path, 'w') as f:
        json.dump(data, f, indent=2)

def create_agent_workflow(agent_name, agent_id, agent_role, department=""):
    """Create n8n workflow for an agent"""
    
    # Generate workflow ID
    workflow_id = str(uuid.uuid4())
    
    # Create workflow structure
    workflow = {
        "name": f"VividWalls-{agent_name.replace('Agent', '')}-MCP-Agent",
        "nodes": [
            {
                "parameters": {
                    "method": "POST",
                    "url": "={{ $json.webhook_url }}",
                    "authentication": "genericCredentialType",
                    "genericAuthType": "httpBasicAuth",
                    "sendHeaders": True,
                    "headerParameters": {
                        "parameters": [
                            {
                                "name": "Content-Type",
                                "value": "application/json"
                            }
                        ]
                    },
                    "sendBody": True,
                    "bodyParameters": {
                        "parameters": [
                            {
                                "name": "task",
                                "value": "={{ $json.task }}"
                            },
                            {
                                "name": "context",
                                "value": "={{ $json.context }}"
                            },
                            {
                                "name": "agent_id",
                                "value": agent_id
                            }
                        ]
                    }
                },
                "id": str(uuid.uuid4()),
                "name": "Webhook",
                "type": "n8n-nodes-base.webhook",
                "typeVersion": 1.1,
                "position": [250, 300]
            },
            {
                "parameters": {
                    "model": "gpt-4",
                    "messages": {
                        "values": [
                            {
                                "role": "system",
                                "content": f"You are the {agent_name}, specializing in {agent_role}. Process the given task and provide actionable insights or execute the required actions."
                            },
                            {
                                "role": "user", 
                                "content": "={{ $json.body.task }}\\n\\nContext: {{ $json.body.context }}"
                            }
                        ]
                    }
                },
                "id": str(uuid.uuid4()),
                "name": "OpenAI",
                "type": "n8n-nodes-base.openAi",
                "typeVersion": 1,
                "position": [450, 300]
            },
            {
                "parameters": {
                    "collection": "agent_tasks",
                    "operation": "insert",
                    "fields": {
                        "agent_id": agent_id,
                        "agent_name": agent_name,
                        "task": "={{ $json.body.task }}",
                        "response": "={{ $json.message.content }}",
                        "timestamp": "={{ $now }}"
                    }
                },
                "id": str(uuid.uuid4()),
                "name": "Supabase",
                "type": "n8n-nodes-base.supabase",
                "typeVersion": 1,
                "position": [650, 300]
            },
            {
                "parameters": {
                    "respondWith": "json",
                    "responseBody": {
                        "success": True,
                        "agent": agent_name,
                        "response": "={{ $json.message.content }}",
                        "timestamp": "={{ $now }}"
                    }
                },
                "id": str(uuid.uuid4()),
                "name": "Respond to Webhook",
                "type": "n8n-nodes-base.respondToWebhook",
                "typeVersion": 1,
                "position": [850, 300]
            }
        ],
        "connections": {
            "Webhook": {
                "main": [
                    [
                        {
                            "node": "OpenAI",
                            "type": "main",
                            "index": 0
                        }
                    ]
                ]
            },
            "OpenAI": {
                "main": [
                    [
                        {
                            "node": "Supabase",
                            "type": "main",
                            "index": 0
                        }
                    ]
                ]
            },
            "Supabase": {
                "main": [
                    [
                        {
                            "node": "Respond to Webhook",
                            "type": "main",
                            "index": 0
                        }
                    ]
                ]
            }
        },
        "active": False,
        "settings": {
            "executionOrder": "v1"
        },
        "tags": [
            {
                "name": "agent",
                "color": "#4B5563"
            },
            {
                "name": department.lower() if department else "operational",
                "color": "#10B981"
            },
            {
                "name": "mcp",
                "color": "#6366F1"
            }
        ],
        "updatedAt": datetime.now().isoformat(),
        "createdAt": datetime.now().isoformat(),
        "id": workflow_id
    }
    
    return workflow

def main():
    """Main execution function"""
    print("🚀 Creating n8n Workflows for All Agents")
    print("=" * 60)
    
    # Load agents configuration
    agents_file = MCP_DATA_PATH / "agents.json"
    agents = load_json(agents_file)
    
    # Create workflows directory structure
    workflows_dirs = {
        "core": N8N_WORKFLOWS_PATH / "core",
        "sales": N8N_WORKFLOWS_PATH / "sales",
        "marketing": N8N_WORKFLOWS_PATH / "marketing",
        "operations": N8N_WORKFLOWS_PATH / "operations",
        "finance": N8N_WORKFLOWS_PATH / "finance",
        "product": N8N_WORKFLOWS_PATH / "product",
        "customer": N8N_WORKFLOWS_PATH / "customer_experience",
        "analytics": N8N_WORKFLOWS_PATH / "analytics",
        "social": N8N_WORKFLOWS_PATH / "social_media"
    }
    
    # Create directories
    for dir_path in workflows_dirs.values():
        dir_path.mkdir(parents=True, exist_ok=True)
    
    # Agent to department mapping
    department_mapping = {
        # Directors
        "SalesDirectorAgent": ("sales", "core"),
        "MarketingDirectorAgent": ("marketing", "core"),
        "FinanceDirectorAgent": ("finance", "core"),
        "OperationsDirectorAgent": ("operations", "core"),
        "ProductDirectorAgent": ("product", "core"),
        "CustomerExperienceDirectorAgent": ("customer", "core"),
        "TechnologyDirectorAgent": ("technology", "core"),
        "AnalyticsDirectorAgent": ("analytics", "core"),
        
        # Sales agents
        "HospitalitySalesAgent": ("sales", "sales"),
        "CorporateSalesAgent": ("sales", "sales"),
        "HealthcareSalesAgent": ("sales", "sales"),
        "ResidentialSalesAgent": ("sales", "sales"),
        "EducationalSalesAgent": ("sales", "sales"),
        "GovernmentSalesAgent": ("sales", "sales"),
        "RetailSalesAgent": ("sales", "sales"),
        "RealEstateSalesAgent": ("sales", "sales"),
        "LeadGenerationAgent": ("sales", "sales"),
        "PartnershipDevelopmentAgent": ("sales", "sales"),
        "AccountManagementAgent": ("sales", "sales"),
        "SalesAnalyticsAgent": ("sales", "sales"),
        
        # Marketing agents
        "EmailMarketingAgent": ("marketing", "marketing"),
        "NewsletterAgent": ("marketing", "marketing"),
        "CopyWriterAgent": ("marketing", "marketing"),
        "CopyEditorAgent": ("marketing", "marketing"),
        "KeywordAgent": ("marketing", "marketing"),
        
        # Social Media agents
        "PinterestAgent": ("social_media", "social"),
        "TwitterAgent": ("social_media", "social"),
        "LinkedInAgent": ("social_media", "social"),
        "TikTokAgent": ("social_media", "social"),
        "YouTubeAgent": ("social_media", "social"),
        
        # Finance agents
        "AccountingAgent": ("finance", "finance"),
        "BudgetingAgent": ("finance", "finance"),
        "FinancialPlanningAgent": ("finance", "finance"),
        
        # Customer Experience agents
        "CustomerServiceAgent": ("customer_experience", "customer"),
        "CustomerFeedbackAgent": ("customer_experience", "customer"),
        "CustomerSuccessAgent": ("customer_experience", "customer"),
        "SupportTicketAgent": ("customer_experience", "customer"),
        "LiveChatAgent": ("customer_experience", "customer"),
        
        # Operations agents
        "InventoryManagementAgent": ("operations", "operations"),
        "SupplyChainAgent": ("operations", "operations"),
        "QualityControlAgent": ("operations", "operations"),
        "LogisticsAgent": ("operations", "operations"),
        "VendorManagementAgent": ("operations", "operations"),
        
        # Product agents
        "ProductResearchAgent": ("product", "product"),
        "ProductDevelopmentAgent": ("product", "product"),
        "ProductAnalyticsAgent": ("product", "product"),
        "CatalogManagementAgent": ("product", "product")
    }
    
    # Track created workflows
    created_workflows = []
    
    # Process only new agents (those created today)
    new_agents = [
        "SalesDirectorAgent", "HospitalitySalesAgent", "CorporateSalesAgent",
        "HealthcareSalesAgent", "ResidentialSalesAgent", "EducationalSalesAgent",
        "GovernmentSalesAgent", "RetailSalesAgent", "RealEstateSalesAgent",
        "LeadGenerationAgent", "PartnershipDevelopmentAgent", "AccountManagementAgent",
        "SalesAnalyticsAgent", "PinterestAgent", "TwitterAgent", "LinkedInAgent",
        "TikTokAgent", "YouTubeAgent", "EmailMarketingAgent", "NewsletterAgent",
        "CopyWriterAgent", "CopyEditorAgent", "KeywordAgent", "AnalyticsDirectorAgent",
        "AccountingAgent", "BudgetingAgent", "FinancialPlanningAgent",
        "CustomerServiceAgent", "CustomerFeedbackAgent", "CustomerSuccessAgent",
        "SupportTicketAgent", "LiveChatAgent", "InventoryManagementAgent",
        "SupplyChainAgent", "QualityControlAgent", "LogisticsAgent",
        "VendorManagementAgent", "ProductResearchAgent", "ProductDevelopmentAgent",
        "ProductAnalyticsAgent", "CatalogManagementAgent"
    ]
    
    print("\n📝 Creating workflows for new agents...")
    
    for agent in agents:
        if agent['name'] in new_agents:
            department, folder = department_mapping.get(agent['name'], ("operational", "operations"))
            
            # Create workflow
            workflow = create_agent_workflow(
                agent['name'],
                agent['id'],
                agent['role'],
                department
            )
            
            # Determine file path
            workflow_path = workflows_dirs[folder] / f"{agent['name'].replace('Agent', '').lower()}_workflow.json"
            
            # Save workflow
            save_json(workflow, workflow_path)
            created_workflows.append((agent['name'], workflow_path))
            print(f"  ✅ Created workflow for {agent['name']}")
    
    # Create master workflow index
    print("\n📚 Creating workflow index...")
    workflow_index = {
        "created_at": datetime.now().isoformat(),
        "total_workflows": len(created_workflows),
        "workflows": [
            {
                "agent": name,
                "file": str(path.relative_to(BASE_PATH))
            }
            for name, path in created_workflows
        ]
    }
    
    index_path = N8N_WORKFLOWS_PATH / "workflow_index.json"
    save_json(workflow_index, index_path)
    
    # Summary
    print("\n" + "=" * 60)
    print("✅ N8N WORKFLOW CREATION COMPLETE")
    print("=" * 60)
    print(f"\n📊 Summary:")
    print(f"  • Workflows created: {len(created_workflows)}")
    print(f"  • Departments covered: {len(set(department_mapping.values()))}")
    
    print("\n📁 Workflow locations:")
    for folder_name, folder_path in workflows_dirs.items():
        count = len(list(folder_path.glob("*.json")))
        if count > 0:
            print(f"  • {folder_name}: {count} workflows")
    
    print("\n🎯 Next Steps:")
    print("  1. Import workflows into n8n")
    print("  2. Configure webhook URLs")
    print("  3. Set up credentials")
    print("  4. Activate workflows")
    print("  5. Test agent communications")

if __name__ == "__main__":
    main()