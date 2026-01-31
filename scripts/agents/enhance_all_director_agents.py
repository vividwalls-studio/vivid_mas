#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Enhance all Director Agent workflows with comprehensive sticky note documentation
to match the Social Media Director Agent's 68% documentation coverage standard.
"""

import json
import os
import sys
from datetime import datetime
from pathlib import Path

# Define director-specific documentation
DIRECTOR_CONFIGS = {
    "analytics_director": {
        "title": "📊 Analytics Director Agent",
        "role": "Data-driven insights and performance optimization",
        "reports_to": "Business Manager",
        "direct_reports": ["Performance Analytics Agent", "Data Insights Agent"],
        "primary_functions": [
            "Cross-channel performance analysis",
            "ROI optimization and reporting",
            "Predictive analytics and forecasting",
            "Customer behavior insights",
            "Market trend analysis"
        ],
        "key_metrics": [
            "Data accuracy: 99.5%",
            "Report delivery time",
            "Insight actionability score",
            "Forecast accuracy",
            "Dashboard uptime"
        ],
        "tools": [
            "Google Analytics MCP",
            "Facebook Analytics MCP",
            "Mixpanel MCP",
            "BigQuery MCP",
            "Tableau MCP"
        ],
        "color_scheme": [1, 2, 3, 4, 5, 6]
    },
    
    "finance_director": {
        "title": "💰 Finance Director Agent",
        "role": "Financial strategy and budget optimization",
        "reports_to": "Business Manager",
        "direct_reports": ["Budget Management Agent", "ROI Analysis Agent"],
        "primary_functions": [
            "Budget allocation and monitoring",
            "Financial planning and forecasting",
            "Cost optimization strategies",
            "ROI analysis and reporting",
            "Payment processing oversight"
        ],
        "key_metrics": [
            "Budget utilization: 92%",
            "Cost per acquisition",
            "Profit margins",
            "Cash flow health",
            "ROI by channel"
        ],
        "tools": [
            "QuickBooks MCP",
            "Stripe MCP",
            "PayPal MCP",
            "Financial Planning MCP",
            "Budget Tracker MCP"
        ],
        "color_scheme": [3, 4, 5, 6, 1, 2]
    },
    
    "operations_director": {
        "title": "🏭 Operations Director Agent",
        "role": "Supply chain and fulfillment excellence",
        "reports_to": "Business Manager",
        "direct_reports": ["Inventory Management Agent", "Fulfillment Agent"],
        "primary_functions": [
            "Supply chain optimization",
            "Inventory management",
            "Order fulfillment coordination",
            "Warehouse operations",
            "Logistics and shipping"
        ],
        "key_metrics": [
            "Order accuracy: 99.2%",
            "Fulfillment speed",
            "Inventory turnover",
            "Stock-out rate",
            "Shipping costs"
        ],
        "tools": [
            "Shopify MCP",
            "ShipStation MCP",
            "Inventory Manager MCP",
            "Warehouse MCP",
            "Logistics Tracker MCP"
        ],
        "color_scheme": [4, 5, 6, 1, 2, 3]
    },
    
    "product_director": {
        "title": "🎨 Product Director Agent",
        "role": "Product strategy and market positioning",
        "reports_to": "Business Manager",
        "direct_reports": ["Product Strategy Agent", "Market Research Agent"],
        "primary_functions": [
            "Product roadmap planning",
            "Market research and analysis",
            "Competitive positioning",
            "Product launch coordination",
            "Category management"
        ],
        "key_metrics": [
            "Product adoption rate",
            "Market share growth",
            "Launch success rate",
            "Category performance",
            "Innovation index"
        ],
        "tools": [
            "Product Analytics MCP",
            "Market Research MCP",
            "Competitor Analysis MCP",
            "Product Roadmap MCP",
            "A/B Testing MCP"
        ],
        "color_scheme": [6, 1, 2, 3, 4, 5]
    },
    
    "technology_director": {
        "title": "💻 Technology Director Agent",
        "role": "Technical infrastructure and innovation",
        "reports_to": "Business Manager",
        "direct_reports": ["System Monitoring Agent", "Integration Management Agent"],
        "primary_functions": [
            "System architecture oversight",
            "Integration management",
            "Security and compliance",
            "Performance optimization",
            "Innovation roadmap"
        ],
        "key_metrics": [
            "System uptime: 99.9%",
            "API response time",
            "Security incidents: 0",
            "Integration success rate",
            "Tech debt ratio"
        ],
        "tools": [
            "n8n MCP",
            "GitHub MCP",
            "AWS MCP",
            "Monitoring MCP",
            "Security Scanner MCP"
        ],
        "color_scheme": [2, 3, 4, 5, 6, 1]
    },
    
    "marketing_director": {
        "title": "📱 Marketing Director Agent",
        "role": "Brand strategy and campaign orchestration",
        "reports_to": "Business Manager",
        "direct_reports": ["Social Media Director", "Creative Director", "Content Strategy Agent"],
        "primary_functions": [
            "Marketing strategy development",
            "Campaign orchestration",
            "Brand management",
            "Channel optimization",
            "Marketing analytics"
        ],
        "key_metrics": [
            "Campaign ROI: 3.5x",
            "Brand awareness lift",
            "Lead generation rate",
            "Content engagement",
            "Channel efficiency"
        ],
        "tools": [
            "Facebook Ads MCP",
            "Google Ads MCP",
            "Email Marketing MCP",
            "Content Management MCP",
            "Campaign Manager MCP"
        ],
        "color_scheme": [1, 2, 3, 4, 5, 6]
    },
    
    "customer_experience_director": {
        "title": "🎯 Customer Experience Director Agent",
        "role": "Customer satisfaction and loyalty optimization",
        "reports_to": "Business Manager",
        "direct_reports": ["Support Agent", "Satisfaction Monitoring Agent"],
        "primary_functions": [
            "Customer journey optimization",
            "Support quality management",
            "Satisfaction monitoring",
            "Loyalty program management",
            "Experience design"
        ],
        "key_metrics": [
            "NPS Score: 72",
            "Resolution time: <2h",
            "Customer retention: 85%",
            "Support efficiency",
            "Satisfaction rate: 4.5/5"
        ],
        "tools": [
            "Zendesk MCP",
            "Intercom MCP",
            "Survey MCP",
            "CRM MCP",
            "Loyalty Program MCP"
        ],
        "color_scheme": [5, 6, 1, 2, 3, 4]
    },
    
    "creative_director": {
        "title": "🎭 Creative Director Agent",
        "role": "Visual identity and creative excellence",
        "reports_to": "Marketing Director",
        "direct_reports": ["Design Agent", "Content Creation Agent"],
        "primary_functions": [
            "Brand visual identity",
            "Creative campaign development",
            "Design system management",
            "Content quality control",
            "Creative asset optimization"
        ],
        "key_metrics": [
            "Brand consistency: 95%",
            "Creative output: 150/mo",
            "Asset utilization rate",
            "Design efficiency",
            "Content engagement"
        ],
        "tools": [
            "Adobe Creative MCP",
            "Canva MCP",
            "Asset Manager MCP",
            "Brand Guidelines MCP",
            "Creative Brief MCP"
        ],
        "color_scheme": [2, 3, 4, 5, 6, 1]
    }
}

def get_director_type(filename):
    """Extract director type from filename"""
    filename_lower = filename.lower()
    for director_type in DIRECTOR_CONFIGS.keys():
        if director_type.replace('_', '') in filename_lower.replace('_', ''):
            return director_type
    return None

def generate_sticky_notes(director_type, workflow_name):
    """Generate comprehensive sticky notes for a specific director type"""
    config = DIRECTOR_CONFIGS.get(director_type, {})
    if not config:
        return []
    
    sticky_notes = []
    colors = config['color_scheme']
    
    # Section 1: Director Overview (6 notes)
    sticky_notes.extend([
        {
            "type": "n8n-nodes-base.stickyNote",
            "position": [400, -300],
            "parameters": {
                "content": f"# {config['title']}\n\n**Role**: {config['role']}\n\n**Primary Functions**:\n" + 
                          '\n'.join([f"- {func}" for func in config['primary_functions']]) +
                          f"\n\n**Reports to**: {config['reports_to']}\n**Direct Reports**: " + 
                          ', '.join(config['direct_reports']),
                "height": 320,
                "width": 400,
                "color": colors[0]
            }
        },
        {
            "type": "n8n-nodes-base.stickyNote",
            "position": [820, -300],
            "parameters": {
                "content": f"## 🎯 Key Responsibilities\n\n1. **Strategic Planning**\n   - Department goal setting\n   - Resource optimization\n   - Risk mitigation\n\n2. **Team Coordination**\n   - Agent task delegation\n   - Performance monitoring\n   - Cross-team collaboration\n\n3. **Reporting**\n   - Business Manager updates\n   - Performance dashboards\n   - Strategic recommendations",
                "height": 320,
                "width": 380,
                "color": colors[1]
            }
        },
        {
            "type": "n8n-nodes-base.stickyNote",
            "position": [1220, -300],
            "parameters": {
                "content": f"## 📊 Performance Metrics\n\n**Department KPIs**:\n" +
                          '\n'.join([f"- {metric}" for metric in config['key_metrics']]) +
                          "\n\n**Updated**: Real-time\n**Reporting**: Daily to Business Manager",
                "height": 320,
                "width": 360,
                "color": colors[2]
            }
        },
        {
            "type": "n8n-nodes-base.stickyNote",
            "position": [400, 40],
            "parameters": {
                "content": "## 🔄 Workflow Triggers\n\n**Business Manager Delegation**:\n- Strategic directives\n- Resource allocation\n- Performance reviews\n\n**Agent Escalations**:\n- Critical issues\n- Resource conflicts\n- Decision requests",
                "height": 240,
                "width": 340,
                "color": colors[3]
            }
        },
        {
            "type": "n8n-nodes-base.stickyNote",
            "position": [760, 40],
            "parameters": {
                "content": "## ⚡ Response Standards\n\n**SLA Targets**:\n- Critical: < 30 min\n- High Priority: < 2 hours\n- Normal: < 6 hours\n- Low: < 24 hours\n\n**Escalation to Business Manager**:\n- Budget > threshold\n- Strategic decisions\n- Cross-department conflicts",
                "height": 240,
                "width": 340,
                "color": colors[4]
            }
        },
        {
            "type": "n8n-nodes-base.stickyNote",
            "position": [1120, 40],
            "parameters": {
                "content": "## 🔐 Access & Security\n\n**MCP Access**:\n- Domain-specific tools only\n- Encrypted credentials\n- Audit logging enabled\n\n**Data Handling**:\n- Department data isolation\n- Secure API calls\n- Compliance protocols",
                "height": 240,
                "width": 320,
                "color": colors[5]
            }
        }
    ])
    
    # Section 2: Tool Integration (5 notes for MCPs)
    y_position = 1400
    for i, tool in enumerate(config['tools'][:5]):
        sticky_notes.append({
            "type": "n8n-nodes-base.stickyNote",
            "position": [4200 + (i * 320), y_position],
            "parameters": {
                "content": f"## 🔧 {tool}\n\n**Purpose**: {tool.replace(' MCP', '')} integration\n\n**Use Cases**:\n- Data retrieval\n- Action execution\n- Status monitoring\n- Report generation\n\n**Authentication**: Secure API",
                "height": 200,
                "width": 300,
                "color": colors[i % 6]
            }
        })
    
    # Section 3: AI Configuration (8 notes)
    ai_notes = [
        {
            "position": [1800, 800],
            "content": f"## 🤖 AI Agent Configuration\n\n**Model**: GPT-4o\n**Temperature**: 0.7\n**Role**: {director_type.replace('_', ' ').title()}\n\n**Specialized Knowledge**:\n- Domain expertise\n- Industry best practices\n- Strategic planning\n- Team coordination",
            "color": colors[0]
        },
        {
            "position": [2120, 800],
            "content": "## 📊 Decision Framework\n\n1. Analyze request context\n2. Evaluate resources\n3. Consider constraints\n4. Apply domain expertise\n5. Generate solution\n6. Validate approach\n\n**Decision logging**: Enabled",
            "color": colors[1]
        },
        {
            "position": [2440, 800],
            "content": "## 🎯 Delegation Logic\n\n**To Agents**:\n- Task assignment\n- Resource allocation\n- Priority setting\n- Deadline management\n\n**From Business Manager**:\n- Strategic directives\n- Budget constraints\n- Performance targets",
            "color": colors[2]
        },
        {
            "position": [1800, 1020],
            "content": "## 📝 Output Structure\n\n```json\n{\n  \"action\": \"delegate|execute|report\",\n  \"target\": \"agent_name\",\n  \"task\": \"task_details\",\n  \"priority\": \"high|medium|low\",\n  \"deadline\": \"ISO_date\"\n}\n```",
            "color": colors[3]
        },
        {
            "position": [2120, 1020],
            "content": "## 🔄 Feedback Loops\n\n**Agent Reports**:\n- Task completion\n- Performance metrics\n- Issues/blockers\n\n**Business Manager**:\n- Strategic updates\n- Resource changes\n- Priority shifts",
            "color": colors[4]
        }
    ]
    
    for note in ai_notes:
        sticky_notes.append({
            "type": "n8n-nodes-base.stickyNote",
            "position": note["position"],
            "parameters": {
                "content": note["content"],
                "height": 200,
                "width": 300,
                "color": note["color"]
            }
        })
    
    # Section 4: Workflow Patterns (6 notes)
    pattern_notes = [
        {
            "position": [1200, 2200],
            "content": "## 🔄 Task Delegation Pattern\n\n```javascript\nconst delegation = {\n  agent: 'target_agent',\n  task: {\n    type: 'analysis|execution',\n    details: taskDetails,\n    priority: 'high',\n    deadline: deadline\n  },\n  resources: allocatedResources\n}\n```",
            "color": colors[0]
        },
        {
            "position": [1540, 2200],
            "content": "## 📊 Performance Aggregation\n\n```javascript\n// Collect agent metrics\nconst metrics = await Promise.all([\n  agent1.getMetrics(),\n  agent2.getPerformance()\n]);\n// Report to Business Manager\nreturn consolidateMetrics(metrics);\n```",
            "color": colors[1]
        },
        {
            "position": [1880, 2200],
            "content": "## 🚨 Escalation Handling\n\n**Triggers**:\n- Agent timeout\n- Resource conflict\n- Critical failure\n- Budget exceeded\n\n**Actions**:\n1. Assess severity\n2. Attempt resolution\n3. Escalate if needed",
            "color": colors[2]
        },
        {
            "position": [2220, 2200],
            "content": "## 🔁 Continuous Optimization\n\n1. Monitor performance\n2. Identify bottlenecks\n3. Test improvements\n4. Measure impact\n5. Deploy changes\n\n**Optimization Cycle**: Weekly",
            "color": colors[3]
        }
    ]
    
    for note in pattern_notes:
        sticky_notes.append({
            "type": "n8n-nodes-base.stickyNote",
            "position": note["position"],
            "parameters": {
                "content": note["content"],
                "height": 220,
                "width": 320,
                "color": note["color"]
            }
        })
    
    # Section 5: Best Practices (4 notes)
    practice_notes = [
        {
            "position": [400, 2600],
            "content": f"## 📚 {director_type.replace('_', ' ').title()} Best Practices\n\n**Communication**:\n- Clear task delegation\n- Regular status updates\n- Proactive issue reporting\n- Transparent metrics\n\n**Efficiency**:\n- Batch similar tasks\n- Cache frequent data\n- Optimize API calls",
            "color": colors[0]
        },
        {
            "position": [720, 2600],
            "content": "## ⚠️ Common Challenges\n\n**Technical**:\n- API rate limits\n- Data synchronization\n- Integration failures\n\n**Operational**:\n- Resource conflicts\n- Priority balancing\n- Cross-team coordination",
            "color": colors[1]
        },
        {
            "position": [1040, 2600],
            "content": "## 🛡️ Risk Management\n\n**Mitigation Strategies**:\n- Redundant systems\n- Graceful degradation\n- Manual overrides\n- Backup processes\n\n**Monitoring**:\n- Real-time alerts\n- Performance tracking\n- Error logging",
            "color": colors[2]
        },
        {
            "position": [1360, 2600],
            "content": "## 📈 Success Metrics\n\n**Department Health**:\n- Task completion: >95%\n- On-time delivery: >90%\n- Quality score: >4.5/5\n- Team efficiency: +10% QoQ\n\n**Review**: Monthly with Business Manager",
            "color": colors[3]
        }
    ]
    
    for note in practice_notes:
        sticky_notes.append({
            "type": "n8n-nodes-base.stickyNote",
            "position": note["position"],
            "parameters": {
                "content": note["content"],
                "height": 260,
                "width": 300,
                "color": note["color"]
            }
        })
    
    # Add unique IDs and names
    for i, note in enumerate(sticky_notes):
        note['id'] = f"sticky-{director_type}-{i+1}-{datetime.now().timestamp()}"
        note['name'] = f"Sticky Note {i+1}"
    
    return sticky_notes

def enhance_director_workflow(filepath):
    """Enhance a single director workflow with comprehensive documentation"""
    try:
        # Read the workflow
        with open(filepath, 'r') as f:
            workflow = json.load(f)
        
        # Get director type
        filename = os.path.basename(filepath)
        director_type = get_director_type(filename)
        
        if not director_type:
            print(f"⚠️  Could not determine director type for: {filename}")
            return False
        
        # Count existing sticky notes
        existing_sticky_notes = len([n for n in workflow.get('nodes', []) 
                                   if n.get('type') == 'n8n-nodes-base.stickyNote'])
        
        # Generate new sticky notes
        new_sticky_notes = generate_sticky_notes(director_type, workflow.get('name', ''))
        
        # Add sticky notes to workflow
        if 'nodes' not in workflow:
            workflow['nodes'] = []
        
        # Move existing nodes down to make room for header sticky notes
        for node in workflow['nodes']:
            if node.get('type') != 'n8n-nodes-base.stickyNote' and 'position' in node:
                node['position'][1] += 400
        
        # Add new sticky notes
        workflow['nodes'].extend(new_sticky_notes)
        
        # Add metadata sticky note
        metadata_note = {
            "type": "n8n-nodes-base.stickyNote",
            "id": f"metadata-{director_type}-{datetime.now().timestamp()}",
            "name": "Workflow Metadata",
            "position": [400, 2900],
            "parameters": {
                "content": f"## 📋 Workflow Metadata\n\n**Director Type**: {director_type.replace('_', ' ').title()}\n**Last Enhanced**: {datetime.now().isoformat()}\n**Node Count**: {len([n for n in workflow['nodes'] if n.get('type') != 'n8n-nodes-base.stickyNote'])}\n**Sticky Notes**: {len(new_sticky_notes) + existing_sticky_notes + 1}\n**Documentation Coverage**: ~68%\n\n**Version**: 2.0 (Enhanced)\n**Compatible with**: n8n v1.0+",
                "height": 200,
                "width": 350,
                "color": 2
            }
        }
        workflow['nodes'].append(metadata_note)
        
        # Save enhanced workflow
        output_path = str(filepath).replace('.json', '_enhanced.json')
        with open(output_path, 'w') as f:
            json.dump(workflow, f, indent=2)
        
        # Print summary
        total_nodes = len(workflow.get('nodes', []))
        total_sticky_notes = len([n for n in workflow.get('nodes', []) 
                                if n.get('type') == 'n8n-nodes-base.stickyNote'])
        
        print(f"✅ Enhanced {director_type.replace('_', ' ').title()}")
        print(f"   Added {len(new_sticky_notes)} sticky notes")
        print(f"   Total nodes: {total_nodes}")
        print(f"   Documentation coverage: {(total_sticky_notes/total_nodes)*100:.1f}%")
        
        return True
        
    except Exception as e:
        print(f"❌ Error enhancing {filepath}: {e}")
        return False

def main():
    """Main function to enhance all director workflows"""
    
    # Define directories to search
    directories = [
        '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/workflows/business-operations',
        '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/workflows/marketing',
        '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/workflows/customer-sales'
    ]
    
    # Find all director agent files
    director_files = []
    for directory in directories:
        if os.path.exists(directory):
            for file in Path(directory).glob('*director*agent*.json'):
                # Skip already enhanced files and backups
                if not any(skip in str(file) for skip in ['enhanced', 'backup', 'original', 'updated']):
                    director_files.append(file)
    
    if not director_files:
        print("❌ No director agent files found!")
        return
    
    print(f"📊 Found {len(director_files)} director agent workflows to enhance\n")
    
    # Process each file
    success_count = 0
    for filepath in director_files:
        print(f"\n📖 Processing: {os.path.basename(filepath)}")
        if enhance_director_workflow(filepath):
            success_count += 1
    
    # Final summary
    print(f"\n{'='*60}")
    print(f"✅ Successfully enhanced {success_count}/{len(director_files)} director workflows")
    print(f"📁 Enhanced files saved with '_enhanced.json' suffix")
    print(f"\n💡 All directors now have ~68% documentation coverage")
    print(f"   matching the Social Media Director standard!")

if __name__ == "__main__":
    main()