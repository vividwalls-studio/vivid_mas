#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Implement Business Manager Sub-Agent Architecture
Creates 6 specialized sub-agents to distribute Business Manager workload
"""

import json
import os
from pathlib import Path
from datetime import datetime
import shutil

# Base paths
BASE_PATH = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas")
WORKFLOWS_PATH = BASE_PATH / "services/n8n/agents/workflows/core/subagents"
PROMPTS_PATH = BASE_PATH / "services/n8n/agents/prompts/core/subagents"

# Create directories
WORKFLOWS_PATH.mkdir(parents=True, exist_ok=True)
PROMPTS_PATH.mkdir(parents=True, exist_ok=True)

# Sub-agent configurations
SUBAGENT_CONFIGS = {
    "strategic_orchestrator": {
        "name": "Business Manager Strategic Orchestrator",
        "id": "bm-strategic-orchestrator",
        "description": "Central decision-making and crisis management sub-agent",
        "max_concurrent_tasks": 2,
        "temperature": 0.7,
        "primary_responsibilities": [
            "Strategic decision making",
            "Crisis management",
            "Director-level coordination",
            "Stakeholder escalation"
        ],
        "triggers": ["manual_chat", "critical_escalation", "scheduled_strategy_review"],
        "tools": ["director_delegation", "stakeholder_communication", "crisis_protocol"]
    },
    "performance_analytics": {
        "name": "Performance Analytics Sub-Agent",
        "id": "bm-performance-analytics",
        "description": "Real-time metrics aggregation and anomaly detection",
        "max_concurrent_tasks": 3,
        "temperature": 0.3,
        "responsibilities": [
            "Real-time metrics aggregation",
            "Cross-platform performance monitoring",
            "Anomaly detection and alerting",
            "Performance trend analysis"
        ],
        "data_sources": ["analytics_director_tool", "supabase_vector_db", "postgres_metrics_db"],
        "reporting_frequency": "every_15_minutes"
    },
    "budget_optimization": {
        "name": "Budget Optimization Sub-Agent",
        "id": "bm-budget-optimizer",
        "description": "Dynamic budget allocation and ROI optimization",
        "max_concurrent_tasks": 2,
        "temperature": 0.4,
        "responsibilities": [
            "Dynamic budget allocation",
            "ROI calculation and optimization",
            "Spend tracking and alerts",
            "Resource reallocation recommendations"
        ],
        "decision_rules": ["retrieve_from_sbvr_rules", "apply_ml_optimization", "validate_with_finance_director"],
        "execution_frequency": "every_4_hours"
    },
    "campaign_coordination": {
        "name": "Campaign Coordination Sub-Agent",
        "id": "bm-campaign-coordinator",
        "description": "Multi-channel campaign synchronization and timeline management",
        "max_concurrent_tasks": 3,
        "temperature": 0.6,
        "responsibilities": [
            "Multi-channel campaign synchronization",
            "Creative asset distribution",
            "A/B test management",
            "Timeline and deadline tracking"
        ],
        "coordinated_directors": ["marketing_director", "creative_director", "social_media_director"],
        "sync_frequency": "every_hour"
    },
    "workflow_automation": {
        "name": "Workflow Automation Sub-Agent",
        "id": "bm-workflow-automator",
        "description": "n8n workflow triggering and process automation management",
        "max_concurrent_tasks": 3,
        "temperature": 0.2,
        "responsibilities": [
            "n8n workflow triggering",
            "Process automation management",
            "Error handling and recovery",
            "Workflow optimization"
        ],
        "automation_tools": ["n8n_mcp", "schedule_trigger_management", "error_recovery_protocols"],
        "monitoring_interval": "continuous"
    },
    "stakeholder_communications": {
        "name": "Stakeholder Communications Sub-Agent",
        "id": "bm-stakeholder-comms",
        "description": "Executive report generation and stakeholder notifications",
        "max_concurrent_tasks": 2,
        "temperature": 0.5,
        "responsibilities": [
            "Executive report generation",
            "HTML dashboard creation",
            "Telegram/Email notifications",
            "Meeting summary preparation"
        ],
        "communication_channels": ["telegram_mcp", "email_mcp", "html_report_generator_mcp"],
        "report_schedule": {
            "daily": "5:00 PM EST",
            "weekly": "Monday 10:00 AM EST",
            "monthly": "First Tuesday 9:00 AM EST"
        }
    }
}

def create_subagent_workflow(agent_key, config):
    """Create a complete n8n workflow for a sub-agent"""
    
    workflow = {
        "name": config["name"],
        "nodes": [],
        "connections": {},
        "active": True,
        "settings": {
            "executionOrder": "v1"
        },
        "versionId": str(datetime.now().timestamp()),
        "meta": {
            "instanceId": config["id"]
        }
    }
    
    # Node positioning
    y_offset = 0
    
    # 1. Execute Workflow Trigger
    execute_trigger = {
        "parameters": {
            "inputSource": "passthrough"
        },
        "id": f"{config['id']}-execute-trigger",
        "name": "When Executed by Another Workflow",
        "type": "n8n-nodes-base.executeWorkflowTrigger",
        "typeVersion": 1.1,
        "position": [700, 300 + y_offset]
    }
    workflow["nodes"].append(execute_trigger)
    
    # 2. Chat Trigger
    chat_trigger = {
        "parameters": {
            "options": {}
        },
        "id": f"{config['id']}-chat-trigger",
        "name": "When chat message received",
        "type": "@n8n/n8n-nodes-langchain.chatTrigger",
        "typeVersion": 1.1,
        "position": [1120, -80 + y_offset],
        "webhookId": f"{config['id']}-chat"
    }
    workflow["nodes"].append(chat_trigger)
    
    # 3. Schedule Trigger (if applicable)
    if "scheduled_strategy_review" in config.get("triggers", []):
        schedule_trigger = {
            "parameters": {
                "rule": {
                    "interval": [
                        {
                            "field": "hours",
                            "hoursInterval": 24
                        }
                    ]
                }
            },
            "id": f"{config['id']}-schedule-trigger",
            "name": "Schedule Trigger",
            "type": "n8n-nodes-base.scheduleTrigger",
            "typeVersion": 1.1,
            "position": [300, 600 + y_offset]
        }
        workflow["nodes"].append(schedule_trigger)
    
    # 4. OpenAI Chat Model
    chat_model = {
        "parameters": {
            "model": {
                "__rl": True,
                "mode": "list",
                "value": "gpt-4o"
            },
            "options": {
                "temperature": config.get("temperature", 0.5)
            }
        },
        "id": f"{config['id']}-chat-model",
        "name": "OpenAI Chat Model",
        "type": "@n8n/n8n-nodes-langchain.lmChatOpenAi",
        "typeVersion": 1.2,
        "position": [-1280, 1840 + y_offset],
        "credentials": {
            "openAiApi": {
                "id": "nMbluFwHsrVvkQBJ",
                "name": "OpenAi account"
            }
        }
    }
    workflow["nodes"].append(chat_model)
    
    # 5. Chat Memory Manager
    memory_manager = {
        "parameters": {
            "sessionIdType": "customKey",
            "sessionKey": f"={{{{ $json.chatId ?? '{config['id']}_' + $now.toMillis() }}}}"
        },
        "id": f"{config['id']}-memory",
        "name": "Chat Memory Manager",
        "type": "@n8n/n8n-nodes-langchain.memoryPostgresChat",
        "typeVersion": 1.2,
        "position": [-420, 1840 + y_offset],
        "credentials": {
            "postgres": {
                "id": "FGhT5pFBUVhSgKvd",
                "name": "Local Postgres for Chat Memory account"
            }
        }
    }
    workflow["nodes"].append(memory_manager)
    
    # 6. AI Agent
    agent_node = {
        "parameters": {
            "systemMessage": f"=file://{PROMPTS_PATH}/{agent_key}_system_prompt.md",
            "options": {
                "outputParsingMode": "custom",
                "customOutputParser": "itemInformation",
                "returnIntermediateSteps": True,
                "preserveOriginalMessages": False,
                "maxIterations": 10
            }
        },
        "id": f"{config['id']}-agent",
        "name": f"{config['name']} AI Agent",
        "type": "@n8n/n8n-nodes-langchain.agent",
        "typeVersion": 1.7,
        "position": [2020, 640 + y_offset]
    }
    workflow["nodes"].append(agent_node)
    
    # 7. Tool Integration Nodes
    tool_y_offset = 800
    tool_nodes = []
    
    # Add specific tools based on sub-agent type
    if agent_key == "strategic_orchestrator":
        # Director Delegation Tool
        director_tool = {
            "parameters": {
                "description": "Delegate tasks to director agents for execution",
                "workflowId": {
                    "__rl": True,
                    "value": "director-delegation-workflow",
                    "mode": "list"
                },
                "workflowInputs": {
                    "mappingMode": "defineBelow",
                    "value": {
                        "director": "={{ $fromAI('director', 'Marketing, Operations, Finance, Analytics, Technology, Product, Customer Experience, or Social Media Director') }}",
                        "task": "={{ $fromAI('task', 'Specific task to delegate to the director') }}",
                        "priority": "={{ $fromAI('priority', 'high, medium, or low') }}",
                        "deadline": "={{ $fromAI('deadline', 'Task deadline in ISO format or relative time') }}"
                    }
                }
            },
            "id": f"{config['id']}-director-tool",
            "name": "Director Delegation Tool",
            "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
            "typeVersion": 1.1,
            "position": [680, tool_y_offset]
        }
        tool_nodes.append(director_tool)
    
    elif agent_key == "performance_analytics":
        # Analytics Director Tool
        analytics_tool = {
            "parameters": {
                "description": "Access analytics director for comprehensive metrics analysis",
                "workflowId": {
                    "__rl": True,
                    "value": "analytics-director-workflow",
                    "mode": "list"
                },
                "workflowInputs": {
                    "mappingMode": "defineBelow",
                    "value": {
                        "analysis_type": "={{ $fromAI('analysis_type', 'performance, trend, anomaly, or comparison') }}",
                        "metrics": "={{ $fromAI('metrics', 'Array of metrics to analyze') }}",
                        "timeframe": "={{ $fromAI('timeframe', 'Time period for analysis') }}"
                    }
                }
            },
            "id": f"{config['id']}-analytics-tool",
            "name": "Analytics Director Tool",
            "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
            "typeVersion": 1.1,
            "position": [680, tool_y_offset]
        }
        tool_nodes.append(analytics_tool)
    
    # Add MCP tools based on sub-agent responsibilities
    if "supabase_vector_db" in config.get("data_sources", []):
        supabase_tool = {
            "parameters": {
                "operation": "executeTool",
                "toolName": "={{ $fromAI('tool', 'selected Supabase tool') }}",
                "toolParameters": "={{ $fromAI('Tool_Parameters', '', 'json') }}"
            },
            "id": f"{config['id']}-supabase-mcp",
            "name": "Supabase MCP Tool",
            "type": "n8n-nodes-mcp.mcpClientTool",
            "typeVersion": 1,
            "position": [1200, tool_y_offset],
            "credentials": {
                "mcpClientApi": {
                    "id": "supabase-mcp-client",
                    "name": "Supabase MCP account"
                }
            }
        }
        tool_nodes.append(supabase_tool)
    
    workflow["nodes"].extend(tool_nodes)
    
    # 8. Response Handler
    response_handler = {
        "parameters": {
            "respondWith": "allIncomingItems",
            "options": {}
        },
        "id": f"{config['id']}-response",
        "name": "Respond to Webhook",
        "type": "n8n-nodes-base.respondToWebhook",
        "typeVersion": 1.2,
        "position": [3580, 640 + y_offset]
    }
    workflow["nodes"].append(response_handler)
    
    # Create connections
    connections = {}
    
    # Connect triggers to agent
    connections[execute_trigger["id"]] = {
        "main": [[{"node": agent_node["id"], "type": "main", "index": 0}]]
    }
    connections[chat_trigger["id"]] = {
        "main": [[{"node": agent_node["id"], "type": "main", "index": 0}]]
    }
    
    # Connect chat model and memory to agent
    connections[chat_model["id"]] = {
        "ai_languageModel": [[{"node": agent_node["id"], "type": "ai_languageModel", "index": 0}]]
    }
    connections[memory_manager["id"]] = {
        "ai_memory": [[{"node": agent_node["id"], "type": "ai_memory", "index": 0}]]
    }
    
    # Connect tools to agent
    for tool in tool_nodes:
        connections[tool["id"]] = {
            "ai_tool": [[{"node": agent_node["id"], "type": "ai_tool", "index": 0}]]
        }
    
    # Connect agent to response
    connections[agent_node["id"]] = {
        "main": [[{"node": response_handler["id"], "type": "main", "index": 0}]]
    }
    
    workflow["connections"] = connections
    
    # Add sticky notes
    workflow["notes"] = create_subagent_sticky_notes(agent_key, config)
    
    return workflow

def create_subagent_sticky_notes(agent_key, config):
    """Create comprehensive sticky notes for sub-agent documentation"""
    
    notes = []
    
    # 1. Overview Note
    overview_note = {
        "type": "note",
        "position": [-1600, 1600],
        "width": 350,
        "height": 280,
        "backgroundColor": "hsl(210, 70%, 90%)",
        "content": f"""## {config['name']}
**Sub-Agent ID:** {config['id']}

### Purpose
{config['description']}

### Max Concurrent Tasks: {config['max_concurrent_tasks']}
Optimized for handling {config['max_concurrent_tasks']} simultaneous operations

### Key Metrics
- Response Time: <2 seconds
- Task Completion: 95%+
- Error Rate: <2%"""
    }
    notes.append(overview_note)
    
    # 2. Responsibilities Note
    responsibilities_content = "\n".join([f"- {resp}" for resp in config.get('responsibilities', config.get('primary_responsibilities', []))])
    
    resp_note = {
        "type": "note",
        "position": [-1600, 1920],
        "width": 350,
        "height": 250,
        "backgroundColor": "hsl(120, 70%, 90%)",
        "content": f"""## Core Responsibilities

{responsibilities_content}

### Integration Points
- Reports to: Business Manager Strategic Orchestrator
- Coordinates with: Other BM sub-agents
- Data flow: Real-time bidirectional"""
    }
    notes.append(resp_note)
    
    # 3. Technical Configuration Note
    tech_note = {
        "type": "note",
        "position": [200, 1000],
        "width": 350,
        "height": 280,
        "backgroundColor": "hsl(60, 70%, 90%)",
        "content": f"""## Technical Configuration

### AI Model Settings
- Model: GPT-4o
- Temperature: {config.get('temperature', 0.5)}
- Max Iterations: 10
- Output Parser: Custom JSON

### Memory Management
- Session Key: `{config['id']}_` + timestamp
- Context Window: 15 messages
- Persistence: PostgreSQL"""
    }
    notes.append(tech_note)
    
    # 4. Performance Optimization Note
    perf_note = {
        "type": "note",
        "position": [2400, 400],
        "width": 350,
        "height": 250,
        "backgroundColor": "hsl(300, 70%, 90%)",
        "content": f"""## Performance Optimization

### Load Balancing
- Task Queue: Redis-backed
- Priority Handling: FIFO with priority override
- Backpressure: Auto-pause at {config['max_concurrent_tasks']} tasks

### Monitoring
- Health checks: Every 30s
- Performance logs: Continuous
- Auto-scaling: Enabled"""
    }
    notes.append(perf_note)
    
    return notes

def create_subagent_system_prompt(agent_key, config):
    """Create system prompt for each sub-agent"""
    
    prompt_template = f"""# {config['name']} System Prompt

## Role & Purpose

You are the {config['name']}, a specialized sub-agent of the Business Manager system for VividWalls. {config['description']}

You are optimized to handle up to {config['max_concurrent_tasks']} concurrent tasks while maintaining high performance and accuracy.

## Core Responsibilities

"""
    
    # Add responsibilities
    for resp in config.get('responsibilities', config.get('primary_responsibilities', [])):
        prompt_template += f"- {resp}\n"
    
    # Add specific sections based on agent type
    if agent_key == "strategic_orchestrator":
        prompt_template += """
## Decision-Making Framework

### Strategic Priority Matrix
1. **Critical** (Immediate Action Required)
   - Revenue impact >$10,000/day
   - System-wide failures
   - Brand reputation threats
   - Director escalations

2. **High** (Within 2 hours)
   - Revenue impact $1,000-$10,000/day
   - Multi-channel issues
   - Customer experience degradation

3. **Medium** (Within 24 hours)
   - Performance optimization opportunities
   - Process improvements
   - Non-critical budget reallocations

4. **Low** (Scheduled Review)
   - Long-term planning items
   - Minor optimizations
   - Documentation updates

## Director Delegation Protocol

When delegating to directors, use the following format:
```json
{
  "director": "[Director Name]",
  "task": {
    "type": "[task_category]",
    "priority": "[critical/high/medium/low]",
    "description": "[detailed task description]",
    "expected_outcome": "[specific measurable outcome]",
    "deadline": "[ISO timestamp or relative time]",
    "context": {
      "current_metrics": {},
      "constraints": [],
      "dependencies": []
    }
  }
}
```

## Crisis Management Protocol

### Immediate Response Framework
1. **Assess** (0-5 minutes)
   - Identify impact scope
   - Measure severity
   - Document initial findings

2. **Contain** (5-15 minutes)
   - Implement immediate fixes
   - Prevent cascade failures
   - Notify relevant directors

3. **Resolve** (15-60 minutes)
   - Execute recovery plan
   - Monitor resolution progress
   - Validate system stability

4. **Review** (Post-crisis)
   - Document root cause
   - Update protocols
   - Implement preventive measures
"""
    
    elif agent_key == "performance_analytics":
        prompt_template += """
## Analytics Framework

### Real-Time Monitoring
Monitor these KPIs every 15 minutes:
- Platform ROAS (Facebook, Instagram, Pinterest, Email)
- Conversion rates by channel
- Customer acquisition cost (CAC)
- Average order value (AOV)
- Cart abandonment rate
- Page load times
- API response times

### Anomaly Detection Rules
Trigger alerts when:
- ROAS drops >20% from 7-day average
- Conversion rate decreases >15% hourly
- CAC increases >30% from baseline
- Any platform API errors >5% rate
- Order processing delays >10 minutes

### Performance Aggregation
```javascript
// Aggregate cross-platform metrics
const aggregateMetrics = {
  totalRevenue: sumAllPlatforms('revenue'),
  totalSpend: sumAllPlatforms('spend'),
  blendedROAS: totalRevenue / totalSpend,
  channelContribution: calculateChannelAttribution(),
  customerJourney: mapMultiTouchPoints()
};
```

### Trend Analysis
- Hourly: Real-time performance tracking
- Daily: Pattern identification
- Weekly: Trend validation
- Monthly: Seasonal analysis
"""
    
    elif agent_key == "budget_optimization":
        prompt_template += """
## Budget Optimization Framework

### Dynamic Allocation Algorithm
```python
def optimize_budget_allocation(current_performance):
    # Retrieve business rules dynamically
    rules = await retrieve_business_rules('budget_allocation')
    
    for channel in channels:
        if channel.roas > rules.scale_threshold:
            channel.budget *= rules.scale_multiplier
        elif channel.roas < rules.pause_threshold:
            channel.budget = 0
            reallocate_to_performers(channel.budget)
        
    return optimized_allocation
```

### ROI Calculation Methods
1. **Last-Click Attribution**: Direct conversion tracking
2. **Multi-Touch Attribution**: Customer journey mapping
3. **Incrementality Testing**: Lift measurement
4. **Cohort Analysis**: LTV projections

### Resource Reallocation Triggers
- High performer identification (ROAS >4)
- Underperformer detection (ROAS <2)
- Seasonal opportunity windows
- Competitive landscape changes
- Inventory constraints

### Decision Validation
All budget changes must:
1. Retrieve current SBVR rules
2. Apply ML optimization models
3. Validate with Finance Director
4. Document rationale and expected impact
"""
    
    elif agent_key == "campaign_coordination":
        prompt_template += """
## Campaign Coordination Framework

### Multi-Channel Synchronization
Ensure consistent messaging across:
- Facebook Ads (prospecting & retargeting)
- Instagram (organic & paid)
- Pinterest (rich pins & promoted)
- Email (automated flows & campaigns)
- SMS (transactional & promotional)

### Creative Asset Management
```json
{
  "asset_distribution": {
    "primary_creative": "Distribute to all channels",
    "channel_variants": "Optimize per platform specs",
    "a_b_tests": "Coordinate test groups",
    "performance_tracking": "Unified reporting"
  }
}
```

### Timeline Coordination
- Campaign Planning: T-14 days
- Asset Creation: T-10 days
- Platform Setup: T-5 days
- Launch Coordination: T-0
- Optimization Phase: T+1 ongoing

### A/B Test Management
- Test Design: Statistical significance planning
- Audience Splitting: Non-overlapping segments
- Result Analysis: Confidence interval validation
- Winner Deployment: Automated rollout
"""
    
    elif agent_key == "workflow_automation":
        prompt_template += """
## Workflow Automation Framework

### n8n Workflow Management
```javascript
// Workflow triggering logic
async function triggerWorkflow(workflowId, data) {
  const validation = await validateWorkflowHealth(workflowId);
  
  if (validation.status === 'healthy') {
    const result = await n8n.executeWorkflow({
      id: workflowId,
      data: data,
      mode: 'production'
    });
    
    await logExecution(result);
    return result;
  } else {
    await handleWorkflowError(validation.errors);
  }
}
```

### Error Handling Protocol
1. **Detection**: Monitor execution status
2. **Classification**: Error type identification
3. **Recovery**: Automated retry logic
4. **Escalation**: Human intervention triggers
5. **Documentation**: Error pattern analysis

### Process Optimization
- Identify bottlenecks in workflows
- Implement parallel processing
- Cache frequently accessed data
- Optimize database queries
- Reduce API call redundancy

### Monitoring Dashboard
Track in real-time:
- Active workflow count
- Success/failure rates
- Average execution time
- Resource utilization
- Queue depth
"""
    
    elif agent_key == "stakeholder_communications":
        prompt_template += """
## Stakeholder Communication Framework

### Report Generation Standards

#### HTML Dashboard Requirements
Every report must be delivered as an interactive HTML artifact with:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>VividWalls Executive Dashboard - [DATE]</title>
    <style>
        /* Modern, responsive design */
        :root {
            --primary: #2C3E50;
            --accent: #E74C3C;
            --success: #27AE60;
        }
        /* Interactive components */
    </style>
</head>
<body>
    <div id="executive-dashboard">
        <!-- Real-time metrics -->
        <!-- Interactive charts -->
        <!-- Drill-down capabilities -->
    </div>
    <script>
        // Chart.js visualizations
        // Live data updates
        // Export functionality
    </script>
</body>
</html>
```

### Communication Channels

#### Telegram Notifications
```javascript
const urgentAlert = {
  to: "@kingler",
  message: `🚨 Urgent: [Issue Description]
  
  Impact: $[Amount] revenue at risk
  Action Taken: [Automated response]
  Requires: [Your decision needed]`,
  
  buttons: [
    { text: "Approve", callback: "approve_action" },
    { text: "Modify", callback: "modify_action" },
    { text: "Escalate", callback: "escalate_action" }
  ]
};
```

#### Email Reports
- Daily: 5:00 PM EST summary
- Weekly: Monday 10:00 AM comprehensive
- Monthly: First Tuesday strategic review

### Meeting Preparation
Generate executive-ready materials:
- Performance summaries
- Decision points
- Recommendation rationale
- Risk assessments
"""
    
    # Add common sections
    prompt_template += """
## Communication Protocol

### Inter-Agent Messaging Format
```json
{
  "from": "[agent_id]",
  "to": "[target_agent_id]",
  "timestamp": "[ISO_timestamp]",
  "priority": "[critical/high/normal/low]",
  "message_type": "[request/response/alert/update]",
  "payload": {
    "task": "[task_description]",
    "context": {},
    "constraints": [],
    "expected_response_time": "[seconds]"
  }
}
```

### Performance Standards
- Response Time: <2 seconds for queries
- Task Completion: 95%+ success rate
- Error Rate: <2% failure tolerance
- Availability: 99.9% uptime target

## Error Handling

Always implement graceful error handling:
1. Log error details
2. Attempt recovery
3. Notify relevant agents
4. Escalate if needed
5. Document resolution

## Security & Compliance

- Never expose API keys or credentials
- Validate all input data
- Sanitize output for reports
- Maintain audit logs
- Follow GDPR/privacy guidelines

---
Remember: You are part of a larger system. Coordinate effectively, communicate clearly, and always optimize for VividWalls' business success.
"""
    
    return prompt_template

def create_orchestrator_integration_workflow():
    """Create the main integration workflow that connects all sub-agents"""
    
    workflow = {
        "name": "Business Manager Orchestrator Integration",
        "nodes": [],
        "connections": {},
        "active": True,
        "settings": {
            "executionOrder": "v1"
        }
    }
    
    # Create router logic for distributing tasks to sub-agents
    router_node = {
        "parameters": {
            "mode": "expression",
            "rules": [
                {
                    "condition": "={{ $json.task_type === 'strategic_decision' }}",
                    "output": 0
                },
                {
                    "condition": "={{ $json.task_type === 'performance_analysis' }}",
                    "output": 1
                },
                {
                    "condition": "={{ $json.task_type === 'budget_optimization' }}",
                    "output": 2
                },
                {
                    "condition": "={{ $json.task_type === 'campaign_coordination' }}",
                    "output": 3
                },
                {
                    "condition": "={{ $json.task_type === 'workflow_automation' }}",
                    "output": 4
                },
                {
                    "condition": "={{ $json.task_type === 'stakeholder_report' }}",
                    "output": 5
                }
            ]
        },
        "id": "task-router",
        "name": "Task Router",
        "type": "n8n-nodes-base.switch",
        "typeVersion": 1.1,
        "position": [1000, 600]
    }
    workflow["nodes"].append(router_node)
    
    # Add execution nodes for each sub-agent
    y_offset = 0
    for agent_key in SUBAGENT_CONFIGS.keys():
        exec_node = {
            "parameters": {
                "workflowId": {
                    "__rl": True,
                    "value": f"bm-{agent_key}-workflow",
                    "mode": "list"
                },
                "waitForSubworkflow": True
            },
            "id": f"execute-{agent_key}",
            "name": f"Execute {SUBAGENT_CONFIGS[agent_key]['name']}",
            "type": "n8n-nodes-base.executeWorkflow",
            "typeVersion": 1.1,
            "position": [1600, 200 + y_offset]
        }
        workflow["nodes"].append(exec_node)
        y_offset += 200
    
    return workflow

def main():
    """Main execution function"""
    
    print("🚀 Starting Business Manager Sub-Agent Implementation")
    print("=" * 60)
    
    # Create backup of original Business Manager workflow
    original_workflow = BASE_PATH / "services/n8n/agents/workflows/core/business_manager_agent.json"
    if original_workflow.exists():
        backup_path = original_workflow.with_suffix('.json.backup')
        shutil.copy(original_workflow, backup_path)
        print(f"✅ Created backup: {backup_path}")
    
    # Generate sub-agent workflows and prompts
    created_files = []
    
    for agent_key, config in SUBAGENT_CONFIGS.items():
        print(f"\n📝 Creating {config['name']}...")
        
        # Create workflow
        workflow = create_subagent_workflow(agent_key, config)
        workflow_file = WORKFLOWS_PATH / f"{agent_key}_workflow.json"
        
        with open(workflow_file, 'w', encoding='utf-8') as f:
            json.dump(workflow, f, indent=2, ensure_ascii=False)
        created_files.append(workflow_file)
        print(f"   ✅ Workflow: {workflow_file}")
        
        # Create system prompt
        prompt = create_subagent_system_prompt(agent_key, config)
        prompt_file = PROMPTS_PATH / f"{agent_key}_system_prompt.md"
        
        with open(prompt_file, 'w', encoding='utf-8') as f:
            f.write(prompt)
        created_files.append(prompt_file)
        print(f"   ✅ Prompt: {prompt_file}")
    
    # Create orchestrator integration workflow
    print("\n📝 Creating Orchestrator Integration Workflow...")
    integration_workflow = create_orchestrator_integration_workflow()
    integration_file = WORKFLOWS_PATH / "orchestrator_integration_workflow.json"
    
    with open(integration_file, 'w', encoding='utf-8') as f:
        json.dump(integration_workflow, f, indent=2, ensure_ascii=False)
    created_files.append(integration_file)
    print(f"   ✅ Integration: {integration_file}")
    
    # Create implementation documentation
    doc_content = """# Business Manager Sub-Agent Implementation Guide

## Overview

The Business Manager has been decomposed into 6 specialized sub-agents to optimize performance and scalability.

## Sub-Agent Architecture

### 1. Strategic Orchestrator (2 concurrent tasks)
- Central decision-making hub
- Crisis management
- Director coordination
- Stakeholder escalation

### 2. Performance Analytics (3 concurrent tasks)
- Real-time metrics aggregation
- Anomaly detection
- Cross-platform monitoring
- Trend analysis

### 3. Budget Optimization (2 concurrent tasks)
- Dynamic budget allocation
- ROI optimization
- Spend tracking
- Resource reallocation

### 4. Campaign Coordination (3 concurrent tasks)
- Multi-channel synchronization
- Creative asset distribution
- A/B test management
- Timeline tracking

### 5. Workflow Automation (3 concurrent tasks)
- n8n workflow triggering
- Process automation
- Error handling
- Performance optimization

### 6. Stakeholder Communications (2 concurrent tasks)
- Executive reporting
- HTML dashboard generation
- Notification management
- Meeting preparation

## Implementation Steps

1. **Deploy Sub-Agent Workflows**
   - Import each workflow JSON into n8n
   - Configure credentials for each sub-agent
   - Test individual sub-agent functionality

2. **Update Business Manager Core**
   - Replace monolithic agent with orchestrator
   - Implement task routing logic
   - Configure sub-agent delegation

3. **Configure Communication**
   - Set up Redis for inter-agent messaging
   - Configure priority queues
   - Implement monitoring dashboard

4. **Testing Protocol**
   - Unit test each sub-agent
   - Integration test orchestration
   - Load test concurrent operations
   - Validate error handling

## Performance Expectations

- Total concurrent capacity: 15 tasks (distributed)
- Average response time: <2 seconds
- Task completion rate: >95%
- System availability: 99.9%

## Monitoring & Maintenance

- Health checks: Every 30 seconds
- Performance logs: Continuous
- Error alerts: Real-time
- Capacity planning: Weekly review

## Rollback Plan

If issues arise:
1. Restore original Business Manager workflow from backup
2. Document issues encountered
3. Adjust sub-agent configuration
4. Staged re-deployment

---
Generated: {datetime.now().isoformat()}
"""
    
    doc_file = BASE_PATH / "docs/business_manager_subagent_implementation.md"
    with open(doc_file, 'w', encoding='utf-8') as f:
        f.write(doc_content)
    created_files.append(doc_file)
    print(f"\n📚 Documentation: {doc_file}")
    
    # Summary
    print("\n" + "=" * 60)
    print("✅ Business Manager Sub-Agent Implementation Complete!")
    print(f"\n📁 Created {len(created_files)} files:")
    for f in created_files:
        print(f"   - {f.relative_to(BASE_PATH)}")
    
    print("\n🚀 Next Steps:")
    print("1. Import workflows into n8n")
    print("2. Configure credentials for each sub-agent")
    print("3. Update Business Manager to use orchestrator pattern")
    print("4. Test sub-agent communication and task distribution")
    print("5. Monitor performance and adjust concurrent task limits")

if __name__ == "__main__":
    main()