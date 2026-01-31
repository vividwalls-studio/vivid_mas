#!/usr/bin/env python3
"""
Update Business Manager Agent to follow proper hierarchical structure.
Removes platform-specific MCPs and keeps only executive functions.
"""

import json
import sys
from datetime import datetime

def update_business_manager_agent(workflow_path):
    """Remove platform-specific MCPs from Business Manager Agent"""
    
    # Read the workflow
    with open(workflow_path, 'r') as f:
        workflow = json.load(f)
    
    # Track changes
    removed_nodes = []
    updated_connections = {}
    
    # Nodes to remove (platform-specific MCPs that belong to directors)
    nodes_to_remove = [
        "Shopify MCP - Execute Tool",  # Should be in Operations/Finance Director
        "Facebook Ads MCP - Execute Tool",  # Should be in Marketing Director
        "n8n MCP - Execute Tool"  # Should be in Technology Director
    ]
    
    # Keep these executive MCPs
    executive_mcps = [
        "Telegram MCP - Send Message",  # For stakeholder communication
        "Email MCP - Send Email",  # For stakeholder reports
        "HTML Report Generator MCP"  # For executive reporting
    ]
    
    # Filter nodes
    updated_nodes = []
    for node in workflow['nodes']:
        if node.get('name') in nodes_to_remove:
            removed_nodes.append(node['name'])
            # Update related sticky notes
            if node['name'] == "Shopify MCP - Execute Tool":
                # Update the MCP Integration Tools sticky note
                for n in workflow['nodes']:
                    if n.get('type') == 'n8n-nodes-base.stickyNote' and 'Shopify MCP' in n.get('parameters', {}).get('content', ''):
                        n['parameters']['content'] = n['parameters']['content'].replace(
                            "### E-commerce & Analytics\n- **Shopify MCP**: Order, customer, product management\n- **Facebook Ads MCP**: Campaign performance & optimization\n- **n8n MCP**: Workflow automation & execution",
                            "### Executive Communication\n- **Telegram MCP**: Real-time stakeholder notifications\n- **Email MCP**: Formal reports to kingler@vividwalls.co\n- **HTML Report Generator**: Beautiful interactive dashboards"
                        )
        else:
            updated_nodes.append(node)
    
    workflow['nodes'] = updated_nodes
    
    # Update connections to remove references to removed nodes
    updated_connections = {}
    for source, targets in workflow.get('connections', {}).items():
        if source not in nodes_to_remove:
            updated_connections[source] = {}
            for conn_type, conn_list in targets.items():
                updated_connections[source][conn_type] = []
                for conns in conn_list:
                    filtered_conns = [c for c in conns if c.get('node') not in nodes_to_remove]
                    if filtered_conns:
                        updated_connections[source][conn_type].append(filtered_conns)
    
    workflow['connections'] = updated_connections
    
    # Add a new sticky note explaining the delegation pattern
    delegation_note = {
        "parameters": {
            "content": "## Delegation Pattern\n\n### Business Manager Role\nThe Business Manager Agent serves as the central orchestrator, delegating to Directors rather than directly accessing platform MCPs.\n\n### MCP Access Pattern\n- **Business Manager**: Executive MCPs only (Telegram, Email, Reports)\n- **Directors**: Domain-specific MCPs\n- **Platform Agents**: Platform-specific MCPs\n\n### Example Flow\n1. Business Manager receives request\n2. Delegates to appropriate Director\n3. Director uses their MCPs or delegates to agents\n4. Results flow back up the hierarchy\n\nThis maintains clean separation of concerns and proper organizational boundaries.",
            "height": 450,
            "width": 400
        },
        "type": "n8n-nodes-base.stickyNote",
        "typeVersion": 1,
        "position": [3400, 2800],
        "id": "note-delegation-pattern"
    }
    
    workflow['nodes'].append(delegation_note)
    
    # Update the main documentation sticky note
    for node in workflow['nodes']:
        if node.get('id') == 'note-001':
            node['parameters']['content'] = """## Business Manager Agent - Core Workflow

### Purpose
The Business Manager Agent serves as the central orchestrator of all marketing operations for VividWalls. This agent oversees performance across all channels, coordinates between specialized directors, and ensures strategic alignment with business objectives.

### Key Responsibilities
1. **Strategic Oversight**: Monitor overall business performance
2. **Director Coordination**: Delegate to 8 Directors (not direct platform access)
3. **Executive Communication**: Report to stakeholder Kingler
4. **Performance Analysis**: Consolidate metrics from Directors
5. **Decision Making**: High-level strategic decisions

### Available Tools
- All 8 Director Agents (primary delegation)
- Executive Communication MCPs:
  - Telegram (stakeholder alerts)
  - Email (formal reports)
  - HTML Report Generator
- Memory Systems (Postgres, Supabase)

### Delegation Pattern
Business Manager → Directors → Platform Agents → MCPs"""
    
    return workflow, removed_nodes

def create_hierarchy_documentation():
    """Create documentation for the proper organizational hierarchy"""
    
    hierarchy_doc = """# VividWalls Multi-Agent System - Organizational Hierarchy

## Proper Hierarchical Structure

### Executive Level
```
Business Manager Agent (Central Orchestrator)
    │
    ├── Purpose: Strategic oversight and coordination
    ├── Direct Reports: All 8 Directors
    └── Tools: Director Agent Tools + Executive MCPs only
```

### Director Level
```
Directors (Department Heads)
    │
    ├── Marketing Director
    │   ├── Social Media Director
    │   ├── Creative Director
    │   ├── Content Strategy Agent
    │   └── Campaign Management Agent
    │
    ├── Analytics Director
    │   ├── Performance Analytics Agent
    │   └── Data Insights Agent
    │
    ├── Finance Director
    │   ├── Budget Management Agent
    │   └── ROI Analysis Agent
    │
    ├── Operations Director
    │   ├── Inventory Management Agent
    │   ├── Fulfillment Agent
    │   └── Shopify Integration (MCP)
    │
    ├── Customer Experience Director
    │   ├── Support Agent
    │   └── Satisfaction Monitoring Agent
    │
    ├── Product Director
    │   ├── Product Strategy Agent
    │   └── Market Research Agent
    │
    └── Technology Director
        ├── System Monitoring Agent
        ├── Integration Management Agent
        └── n8n Automation (MCP)
```

### Platform Agent Level
```
Platform-Specific Agents (Execution Layer)
    │
    ├── Social Media Agents (report to Social Media Director)
    │   ├── Instagram Agent → Instagram MCP
    │   ├── Facebook Agent → Facebook MCP
    │   └── Pinterest Agent → Pinterest MCP
    │
    ├── Email Marketing Agent → Email Platform MCP
    ├── SMS Marketing Agent → SMS Platform MCP
    └── Shopify Agent → Shopify MCP
```

## Communication Patterns

### Downward Delegation
1. **Business Manager** → Directors: Strategic directives
2. **Directors** → Agents: Task assignments
3. **Agents** → MCPs: Platform operations

### Upward Reporting
1. **MCPs** → Agents: Operation results
2. **Agents** → Directors: Performance data
3. **Directors** → Business Manager: Consolidated insights
4. **Business Manager** → Stakeholder: Executive reports

## MCP Distribution by Role

### Business Manager MCPs
- **Telegram MCP**: Stakeholder notifications
- **Email MCP**: Executive reports
- **HTML Report Generator**: Interactive dashboards

### Director-Level MCPs
- **Marketing Director**: Facebook Ads MCP, Google Ads MCP
- **Operations Director**: Shopify MCP, Inventory MCP
- **Finance Director**: Accounting MCP, Payment Processing MCP
- **Technology Director**: n8n MCP, Monitoring MCPs
- **Analytics Director**: Analytics Platform MCPs

### Agent-Level MCPs
- Platform-specific MCPs aligned with agent responsibilities
- Each agent has access only to their required MCPs

## Key Principles

1. **Separation of Concerns**: Each level has distinct responsibilities
2. **Clean Boundaries**: MCPs belong to the appropriate organizational level
3. **Delegation Over Direct Access**: Higher levels delegate rather than directly access platforms
4. **Bi-directional Communication**: Clear paths for both delegation and reporting
5. **Single Responsibility**: Each agent/director owns their domain

## Implementation Notes

- Business Manager should NOT have direct platform MCPs
- Directors coordinate their department's agents
- Platform agents handle direct platform interactions
- MCPs are assigned based on functional responsibility
- All communication follows the hierarchical structure

Last Updated: {timestamp}
"""
    
    return hierarchy_doc.format(timestamp=datetime.now().isoformat())

def update_social_media_director_hierarchy(workflow_path):
    """Update Social Media Director to report to Marketing Director"""
    
    # Read the enhanced workflow
    with open(workflow_path, 'r') as f:
        workflow = json.load(f)
    
    # Add Marketing Director reporting tool
    marketing_director_report = {
        "parameters": {
            "method": "POST",
            "url": "={{ $env.MARKETING_DIRECTOR_WEBHOOK_URL }}/report",
            "sendBody": True,
            "bodyParameters": {
                "parameters": [
                    {
                        "name": "agent",
                        "value": "Social Media Director"
                    },
                    {
                        "name": "report_type",
                        "value": "={{ $fromAI('report_type', 'performance, campaign_status, platform_metrics') }}"
                    },
                    {
                        "name": "data",
                        "value": "={{ $json.consolidated_data }}"
                    },
                    {
                        "name": "recommendations",
                        "value": "={{ $json.strategic_recommendations }}"
                    },
                    {
                        "name": "next_actions",
                        "value": "={{ $json.planned_actions }}"
                    }
                ]
            }
        },
        "type": "n8n-nodes-base.httpRequest",
        "typeVersion": 4.1,
        "position": [3800, 900],
        "id": "marketing-director-report",
        "name": "Report to Marketing Director"
    }
    
    # Update the existing "Report to Marketing Director" node if it exists
    node_updated = False
    for node in workflow['nodes']:
        if node.get('name') == 'Report to Marketing Director':
            node.update(marketing_director_report)
            node_updated = True
            break
    
    if not node_updated:
        workflow['nodes'].append(marketing_director_report)
    
    # Add sticky note about reporting structure
    reporting_note = {
        "parameters": {
            "content": "## Reporting Structure\n\n### Social Media Director Reports To:\n**Marketing Director** (Primary reporting line)\n\n### Reporting Frequency:\n- **Daily**: Performance metrics\n- **Weekly**: Campaign summaries\n- **Monthly**: Strategic analysis\n- **Real-time**: Critical issues\n\n### Report Contents:\n1. Platform performance metrics\n2. Campaign effectiveness\n3. Budget utilization\n4. Strategic recommendations\n5. Planned actions\n\n### Delegation From Marketing Director:\n- Campaign strategies\n- Budget allocations\n- Content priorities\n- Performance targets",
            "height": 400,
            "width": 350
        },
        "type": "n8n-nodes-base.stickyNote",
        "typeVersion": 1,
        "position": [3800, 1300],
        "id": "note-reporting-structure"
    }
    
    workflow['nodes'].append(reporting_note)
    
    return workflow

def main():
    """Main execution function"""
    
    print("Updating Business Manager Agent hierarchy...")
    
    # Update Business Manager Agent
    bm_workflow_path = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/workflows/core/business_manager_agent.json'
    updated_workflow, removed_nodes = update_business_manager_agent(bm_workflow_path)
    
    # Save updated Business Manager workflow
    output_path = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/workflows/core/business_manager_agent_updated.json'
    with open(output_path, 'w') as f:
        json.dump(updated_workflow, f, indent=2)
    
    print(f"✓ Business Manager Agent updated")
    print(f"  - Removed nodes: {', '.join(removed_nodes)}")
    print(f"  - Saved to: {output_path}")
    
    # Update Social Media Director
    print("\nUpdating Social Media Director reporting structure...")
    smd_workflow_path = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/workflows/social-media/social_media_director_agent_enhanced.json'
    
    if os.path.exists(smd_workflow_path):
        smd_workflow = update_social_media_director_hierarchy(smd_workflow_path)
        smd_output_path = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/workflows/social-media/social_media_director_agent_hierarchy_fixed.json'
        
        with open(smd_output_path, 'w') as f:
            json.dump(smd_workflow, f, indent=2)
        
        print(f"✓ Social Media Director updated with Marketing Director reporting")
        print(f"  - Saved to: {smd_output_path}")
    
    # Create hierarchy documentation
    print("\nCreating hierarchy documentation...")
    hierarchy_doc = create_hierarchy_documentation()
    doc_path = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/docs/MAS_ORGANIZATIONAL_HIERARCHY.md'
    
    with open(doc_path, 'w') as f:
        f.write(hierarchy_doc)
    
    print(f"✓ Hierarchy documentation created")
    print(f"  - Saved to: {doc_path}")
    
    print("\n✅ All updates completed successfully!")
    print("\nNext steps:")
    print("1. Review the updated Business Manager Agent workflow")
    print("2. Test the delegation patterns")
    print("3. Update other Directors with appropriate MCPs")
    print("4. Verify reporting chains work correctly")

if __name__ == "__main__":
    import os
    main()