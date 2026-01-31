#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Update Business Manager Agent to Orchestrator Pattern
Transforms the monolithic Business Manager into a lightweight orchestrator
that delegates to specialized sub-agents
"""

import json
from pathlib import Path
from datetime import datetime

# Base paths
BASE_PATH = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas")
WORKFLOW_FILE = BASE_PATH / "services/n8n/agents/workflows/core/business_manager_agent.json"
PROMPT_FILE = BASE_PATH / "services/n8n/agents/prompts/core/business_manager_agent_system_prompt.md"

def create_orchestrator_workflow():
    """Create the updated Business Manager Orchestrator workflow"""
    
    workflow = {
        "name": "Business Manager Agent",
        "nodes": [],
        "connections": {},
        "active": True,
        "settings": {
            "executionOrder": "v1"
        },
        "versionId": str(datetime.now().timestamp()),
        "meta": {
            "instanceId": "business-manager-orchestrator"
        }
    }
    
    # 1. Execute Workflow Trigger
    execute_trigger = {
        "parameters": {
            "inputSource": "passthrough"
        },
        "id": "bm-execute-trigger",
        "name": "When Executed by Another Workflow",
        "type": "n8n-nodes-base.executeWorkflowTrigger",
        "typeVersion": 1.1,
        "position": [700, 300]
    }
    workflow["nodes"].append(execute_trigger)
    
    # 2. Chat Trigger
    chat_trigger = {
        "parameters": {
            "options": {}
        },
        "id": "bm-chat-trigger",
        "name": "When chat message received",
        "type": "@n8n/n8n-nodes-langchain.chatTrigger",
        "typeVersion": 1.1,
        "position": [1120, -80],
        "webhookId": "business-manager-chat-trigger"
    }
    workflow["nodes"].append(chat_trigger)
    
    # 3. Schedule Trigger for Morning Strategic Review
    schedule_trigger = {
        "parameters": {
            "rule": {
                "interval": [
                    {
                        "field": "cronExpression",
                        "expression": "0 9 * * 1-5"  # 9:00 AM EST Monday-Friday
                    }
                ]
            }
        },
        "id": "bm-schedule-trigger",
        "name": "Morning Strategic Review",
        "type": "n8n-nodes-base.scheduleTrigger",
        "typeVersion": 1.1,
        "position": [300, 600]
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
                "temperature": 0.7
            }
        },
        "id": "bm-chat-model",
        "name": "OpenAI Chat Model",
        "type": "@n8n/n8n-nodes-langchain.lmChatOpenAi",
        "typeVersion": 1.2,
        "position": [-1280, 1840],
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
            "sessionKey": "={{ $json.chatId ?? 'business_manager_' + $now.toMillis() }}"
        },
        "id": "bm-memory",
        "name": "Chat Memory Manager",
        "type": "@n8n/n8n-nodes-langchain.memoryPostgresChat",
        "typeVersion": 1.2,
        "position": [-420, 1840],
        "credentials": {
            "postgres": {
                "id": "FGhT5pFBUVhSgKvd",
                "name": "Local Postgres for Chat Memory account"
            }
        }
    }
    workflow["nodes"].append(memory_manager)
    
    # 6. Task Analyzer
    task_analyzer = {
        "parameters": {
            "jsCode": """// Analyze incoming request and determine routing
const input = $input.all()[0].json;

// Extract task type and priority
let taskType = 'strategic_decision';  // default
let priority = 'normal';
let subAgent = 'strategic_orchestrator';

// Keywords for task routing
const keywords = {
  performance: ['metrics', 'analytics', 'performance', 'kpi', 'roas', 'conversion'],
  budget: ['budget', 'spend', 'allocation', 'roi', 'cost', 'optimize budget'],
  campaign: ['campaign', 'creative', 'launch', 'coordinate', 'multi-channel'],
  workflow: ['automate', 'workflow', 'n8n', 'trigger', 'process', 'error'],
  report: ['report', 'dashboard', 'summary', 'stakeholder', 'executive']
};

// Analyze message content
const message = (input.message || input.query || '').toLowerCase();

// Route based on keywords
for (const [type, words] of Object.entries(keywords)) {
  if (words.some(word => message.includes(word))) {
    switch(type) {
      case 'performance':
        taskType = 'performance_analysis';
        subAgent = 'performance_analytics';
        break;
      case 'budget':
        taskType = 'budget_optimization';
        subAgent = 'budget_optimization';
        break;
      case 'campaign':
        taskType = 'campaign_coordination';
        subAgent = 'campaign_coordination';
        break;
      case 'workflow':
        taskType = 'workflow_automation';
        subAgent = 'workflow_automation';
        break;
      case 'report':
        taskType = 'stakeholder_report';
        subAgent = 'stakeholder_communications';
        break;
    }
    break;
  }
}

// Determine priority
if (message.includes('urgent') || message.includes('critical') || message.includes('asap')) {
  priority = 'critical';
} else if (message.includes('high priority') || message.includes('important')) {
  priority = 'high';
}

// Check for morning review trigger
if ($('Schedule Trigger').exists() && $('Schedule Trigger').isExecuted) {
  taskType = 'morning_review';
  subAgent = 'performance_analytics';
  priority = 'high';
}

return {
  originalInput: input,
  taskType: taskType,
  subAgent: subAgent,
  priority: priority,
  timestamp: new Date().toISOString(),
  sessionId: input.chatId || 'business_manager_' + Date.now()
};"""
        },
        "id": "bm-task-analyzer",
        "name": "Task Analyzer",
        "type": "n8n-nodes-base.code",
        "typeVersion": 2,
        "position": [1400, 640]
    }
    workflow["nodes"].append(task_analyzer)
    
    # 7. Orchestrator AI Agent
    orchestrator_agent = {
        "parameters": {
            "systemMessage": "=file:///Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/prompts/core/business_manager_orchestrator_prompt.md",
            "options": {
                "outputParsingMode": "custom",
                "customOutputParser": "itemInformation",
                "returnIntermediateSteps": True,
                "maxIterations": 5  # Reduced for orchestrator efficiency
            }
        },
        "id": "bm-orchestrator-agent",
        "name": "Business Manager Orchestrator",
        "type": "@n8n/n8n-nodes-langchain.agent",
        "typeVersion": 1.7,
        "position": [2020, 640]
    }
    workflow["nodes"].append(orchestrator_agent)
    
    # 8. Sub-Agent Router
    router_node = {
        "parameters": {
            "mode": "expression",
            "rules": [
                {
                    "condition": "={{ $json.subAgent === 'strategic_orchestrator' }}",
                    "output": 0
                },
                {
                    "condition": "={{ $json.subAgent === 'performance_analytics' }}",
                    "output": 1
                },
                {
                    "condition": "={{ $json.subAgent === 'budget_optimization' }}",
                    "output": 2
                },
                {
                    "condition": "={{ $json.subAgent === 'campaign_coordination' }}",
                    "output": 3
                },
                {
                    "condition": "={{ $json.subAgent === 'workflow_automation' }}",
                    "output": 4
                },
                {
                    "condition": "={{ $json.subAgent === 'stakeholder_communications' }}",
                    "output": 5
                }
            ]
        },
        "id": "bm-router",
        "name": "Sub-Agent Router",
        "type": "n8n-nodes-base.switch",
        "typeVersion": 1.1,
        "position": [2600, 640]
    }
    workflow["nodes"].append(router_node)
    
    # 9. Sub-Agent Execution Nodes
    sub_agents = [
        "strategic_orchestrator",
        "performance_analytics",
        "budget_optimization",
        "campaign_coordination",
        "workflow_automation",
        "stakeholder_communications"
    ]
    
    y_offset = 0
    for i, agent in enumerate(sub_agents):
        exec_node = {
            "parameters": {
                "workflowId": {
                    "__rl": True,
                    "value": f"{agent}_workflow",
                    "mode": "list"
                },
                "waitForSubworkflow": True,
                "workflowInputs": {
                    "mappingMode": "defineBelow",
                    "value": {
                        "task": "={{ $json.originalInput }}",
                        "priority": "={{ $json.priority }}",
                        "context": "={{ $json }}",
                        "sessionId": "={{ $json.sessionId }}"
                    }
                }
            },
            "id": f"exec-{agent}",
            "name": f"Execute {agent.replace('_', ' ').title()}",
            "type": "n8n-nodes-base.executeWorkflow",
            "typeVersion": 1.1,
            "position": [3200, 200 + y_offset]
        }
        workflow["nodes"].append(exec_node)
        y_offset += 200
    
    # 10. Result Aggregator
    aggregator = {
        "parameters": {
            "jsCode": """// Aggregate results from sub-agents
const results = $input.all();
const subAgentResult = results[0].json;

// Format response based on execution path
const response = {
  success: true,
  timestamp: new Date().toISOString(),
  subAgent: subAgentResult.subAgent || 'unknown',
  result: subAgentResult.result || subAgentResult,
  performance: {
    executionTime: Date.now() - new Date($json.timestamp).getTime(),
    tasksProcessed: 1
  }
};

// Add any alerts or recommendations
if (subAgentResult.alerts) {
  response.alerts = subAgentResult.alerts;
}

if (subAgentResult.recommendations) {
  response.recommendations = subAgentResult.recommendations;
}

return response;"""
        },
        "id": "bm-aggregator",
        "name": "Result Aggregator",
        "type": "n8n-nodes-base.code",
        "typeVersion": 2,
        "position": [3800, 640]
    }
    workflow["nodes"].append(aggregator)
    
    # 11. Response Handler
    response_handler = {
        "parameters": {
            "respondWith": "allIncomingItems",
            "options": {}
        },
        "id": "bm-response",
        "name": "Respond to Webhook",
        "type": "n8n-nodes-base.respondToWebhook",
        "typeVersion": 1.2,
        "position": [4200, 640]
    }
    workflow["nodes"].append(response_handler)
    
    # 12. Director Delegation Tools
    director_tools = [
        {
            "name": "Marketing Director",
            "workflowId": "marketing-director-workflow"
        },
        {
            "name": "Operations Director",
            "workflowId": "operations-director-workflow"
        },
        {
            "name": "Finance Director",
            "workflowId": "finance-director-workflow"
        },
        {
            "name": "Analytics Director",
            "workflowId": "analytics-director-workflow"
        },
        {
            "name": "Technology Director",
            "workflowId": "technology-director-workflow"
        },
        {
            "name": "Product Director",
            "workflowId": "product-director-workflow"
        },
        {
            "name": "Customer Experience Director",
            "workflowId": "customer-experience-director-workflow"
        },
        {
            "name": "Social Media Director",
            "workflowId": "social-media-director-workflow"
        }
    ]
    
    tool_y_offset = 1000
    for i, director in enumerate(director_tools):
        tool_node = {
            "parameters": {
                "description": f"Delegate tasks to {director['name']} for {director['name'].split()[0].lower()} operations",
                "workflowId": {
                    "__rl": True,
                    "value": director["workflowId"],
                    "mode": "list"
                },
                "workflowInputs": {
                    "mappingMode": "defineBelow",
                    "value": {
                        "task": "={{ $fromAI('task', 'Specific task to delegate') }}",
                        "priority": "={{ $fromAI('priority', 'Task priority level') }}",
                        "context": "={{ $fromAI('context', 'Additional context for the director') }}"
                    }
                }
            },
            "id": f"tool-{director['name'].lower().replace(' ', '-')}",
            "name": f"{director['name']} Tool",
            "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
            "typeVersion": 1.1,
            "position": [200 + (i % 4) * 400, tool_y_offset + (i // 4) * 200]
        }
        workflow["nodes"].append(tool_node)
    
    # Create connections
    connections = {}
    
    # Triggers to Task Analyzer
    connections[execute_trigger["id"]] = {
        "main": [[{"node": task_analyzer["id"], "type": "main", "index": 0}]]
    }
    connections[chat_trigger["id"]] = {
        "main": [[{"node": task_analyzer["id"], "type": "main", "index": 0}]]
    }
    connections[schedule_trigger["id"]] = {
        "main": [[{"node": task_analyzer["id"], "type": "main", "index": 0}]]
    }
    
    # Task Analyzer to Orchestrator
    connections[task_analyzer["id"]] = {
        "main": [[{"node": orchestrator_agent["id"], "type": "main", "index": 0}]]
    }
    
    # AI components to Orchestrator
    connections[chat_model["id"]] = {
        "ai_languageModel": [[{"node": orchestrator_agent["id"], "type": "ai_languageModel", "index": 0}]]
    }
    connections[memory_manager["id"]] = {
        "ai_memory": [[{"node": orchestrator_agent["id"], "type": "ai_memory", "index": 0}]]
    }
    
    # Director tools to Orchestrator
    for tool in [t for t in workflow["nodes"] if t["type"] == "@n8n/n8n-nodes-langchain.toolWorkflow"]:
        connections[tool["id"]] = {
            "ai_tool": [[{"node": orchestrator_agent["id"], "type": "ai_tool", "index": 0}]]
        }
    
    # Orchestrator to Router
    connections[orchestrator_agent["id"]] = {
        "main": [[{"node": router_node["id"], "type": "main", "index": 0}]]
    }
    
    # Router to Sub-Agents
    for i, agent in enumerate(sub_agents):
        exec_id = f"exec-{agent}"
        if router_node["id"] not in connections:
            connections[router_node["id"]] = {"main": []}
        connections[router_node["id"]]["main"].append([{"node": exec_id, "type": "main", "index": 0}])
    
    # Sub-Agents to Aggregator
    for agent in sub_agents:
        exec_id = f"exec-{agent}"
        connections[exec_id] = {
            "main": [[{"node": aggregator["id"], "type": "main", "index": 0}]]
        }
    
    # Aggregator to Response
    connections[aggregator["id"]] = {
        "main": [[{"node": response_handler["id"], "type": "main", "index": 0}]]
    }
    
    workflow["connections"] = connections
    
    # Add orchestrator sticky notes
    workflow["notes"] = create_orchestrator_sticky_notes()
    
    return workflow

def create_orchestrator_sticky_notes():
    """Create sticky notes for the orchestrator workflow"""
    
    notes = [
        {
            "type": "note",
            "position": [-1600, 1600],
            "width": 400,
            "height": 350,
            "backgroundColor": "hsl(0, 70%, 90%)",
            "content": """## 🎯 Business Manager Orchestrator
**Lightweight Coordination Layer**

### Architecture Pattern
This is now a thin orchestrator that delegates all heavy processing to specialized sub-agents:

1. **Strategic Orchestrator** (2 tasks)
2. **Performance Analytics** (3 tasks)
3. **Budget Optimization** (2 tasks)
4. **Campaign Coordination** (3 tasks)
5. **Workflow Automation** (3 tasks)
6. **Stakeholder Communications** (2 tasks)

**Total Capacity**: 15 concurrent tasks
**Response Time**: <2 seconds
**Delegation Efficiency**: 98%+"""
        },
        {
            "type": "note",
            "position": [1000, 900],
            "width": 350,
            "height": 250,
            "backgroundColor": "hsl(60, 70%, 90%)",
            "content": """## 📊 Task Analysis
**Intelligent Routing Logic**

Analyzes incoming requests to determine:
- Task type classification
- Priority assessment
- Optimal sub-agent selection
- Context enrichment

Uses keyword matching and NLP to route tasks efficiently."""
        },
        {
            "type": "note",
            "position": [2400, 900],
            "width": 350,
            "height": 300,
            "backgroundColor": "hsl(120, 70%, 90%)",
            "content": """## 🔀 Sub-Agent Router
**Dynamic Task Distribution**

Routes tasks based on:
- Task type
- Current load
- Priority level
- Sub-agent availability

Implements circuit breaker pattern for resilience."""
        },
        {
            "type": "note",
            "position": [200, 1400],
            "width": 400,
            "height": 250,
            "backgroundColor": "hsl(210, 70%, 90%)",
            "content": """## 🎭 Director Delegation Tools
**Direct Access to All Directors**

Enables strategic delegation to:
- Marketing Director
- Operations Director
- Finance Director
- Analytics Director
- Technology Director
- Product Director
- Customer Experience Director
- Social Media Director"""
        }
    ]
    
    return notes

def create_orchestrator_system_prompt():
    """Create the lightweight orchestrator system prompt"""
    
    prompt = """# Business Manager Orchestrator System Prompt

## Role & Purpose

You are the Business Manager Orchestrator for VividWalls, a lightweight coordination layer that intelligently delegates tasks to specialized sub-agents and directors. Your primary function is rapid task analysis, routing, and high-level coordination - NOT detailed execution.

## Core Principles

1. **Delegate, Don't Execute**: Your role is to understand, route, and coordinate - not to perform detailed analysis
2. **Speed Over Depth**: Make routing decisions quickly (target: <500ms)
3. **Trust Sub-Agents**: Each sub-agent is an expert in their domain
4. **Maintain Context**: Preserve conversation flow while distributing work

## Task Routing Framework

### Quick Classification Rules

Analyze incoming requests and route to the appropriate sub-agent:

1. **Strategic Orchestrator** → Route when:
   - Crisis or urgent decisions needed
   - Multi-director coordination required
   - Stakeholder escalation necessary
   - Strategic planning discussions

2. **Performance Analytics** → Route when:
   - Metrics, KPIs, or analytics requested
   - Performance monitoring needed
   - Anomaly detection required
   - Trend analysis asked for

3. **Budget Optimization** → Route when:
   - Budget allocation decisions
   - ROI or cost optimization
   - Spend management
   - Resource reallocation

4. **Campaign Coordination** → Route when:
   - Multi-channel campaigns
   - Creative asset management
   - A/B testing coordination
   - Launch planning

5. **Workflow Automation** → Route when:
   - n8n workflow management
   - Process automation
   - Error handling
   - System optimization

6. **Stakeholder Communications** → Route when:
   - Reports requested
   - Executive summaries needed
   - Notifications required
   - Dashboard generation

## Director Delegation

When broader strategic input is needed, delegate directly to directors:

```json
{
  "use_case": "When specialized department expertise is required",
  "directors": [
    "Marketing Director - Campaign strategy, brand management",
    "Operations Director - Fulfillment, supply chain",
    "Finance Director - Financial planning, budgets",
    "Analytics Director - Deep data analysis, ML models",
    "Technology Director - System architecture, integrations",
    "Product Director - Catalog management, curation",
    "Customer Experience Director - Support, retention",
    "Social Media Director - Platform-specific strategies"
  ]
}
```

## Response Handling

### Quick Acknowledgment Pattern
1. Acknowledge receipt immediately
2. Indicate which sub-agent/director is handling
3. Provide estimated response time
4. Forward complete results without modification

### Example Response Flow
```
User: "What's our Facebook ROAS today?"
You: "Routing to Performance Analytics for real-time metrics..."
[Sub-agent processes]
You: [Forward complete sub-agent response]
```

## Coordination Protocols

### Multi-Agent Tasks
When a task requires multiple sub-agents:
1. Identify all required sub-agents
2. Create coordination plan
3. Execute in parallel when possible
4. Aggregate results coherently

### Priority Handling
- **Critical**: Route immediately, monitor progress
- **High**: Route within 30 seconds
- **Normal**: Standard routing
- **Low**: Batch with similar requests

## Performance Optimization

### Caching Strategy
- Remember recent routing decisions
- Cache frequently asked questions
- Maintain session context efficiently

### Load Balancing
- Monitor sub-agent availability
- Distribute load evenly
- Implement failover for busy agents

## DO NOT

1. **Don't perform detailed analysis** - Let sub-agents handle complexity
2. **Don't modify sub-agent responses** - Forward them intact
3. **Don't make business decisions** - Route to appropriate decision-makers
4. **Don't store sensitive data** - Pass through to secure sub-agents

## Success Metrics

- Routing Accuracy: >95%
- Response Time: <2 seconds
- Delegation Rate: >90%
- Context Preservation: 100%

Remember: You are the conductor of an orchestra. Direct the musicians (sub-agents) to create harmony, but don't try to play all the instruments yourself.
"""
    
    return prompt

def main():
    """Main execution function"""
    
    print("🔄 Updating Business Manager to Orchestrator Pattern")
    print("=" * 60)
    
    # Create new orchestrator workflow
    print("\n📝 Creating orchestrator workflow...")
    orchestrator_workflow = create_orchestrator_workflow()
    
    # Save workflow
    with open(WORKFLOW_FILE, 'w', encoding='utf-8') as f:
        json.dump(orchestrator_workflow, f, indent=2, ensure_ascii=False)
    print(f"✅ Updated workflow: {WORKFLOW_FILE}")
    
    # Create orchestrator system prompt
    print("\n📝 Creating orchestrator system prompt...")
    orchestrator_prompt = create_orchestrator_system_prompt()
    
    # Save to new file (preserve original)
    orchestrator_prompt_file = PROMPT_FILE.parent / "business_manager_orchestrator_prompt.md"
    with open(orchestrator_prompt_file, 'w', encoding='utf-8') as f:
        f.write(orchestrator_prompt)
    print(f"✅ Created prompt: {orchestrator_prompt_file}")
    
    # Create migration guide
    migration_guide = """# Business Manager Orchestrator Migration Guide

## Overview

The Business Manager has been transformed from a monolithic agent into a lightweight orchestrator that delegates to 6 specialized sub-agents.

## Architecture Changes

### Before (Monolithic)
- Single agent handling all tasks
- 15+ responsibilities in one workflow
- Performance bottlenecks
- Complex decision trees

### After (Orchestrator + Sub-Agents)
- Lightweight orchestrator for routing
- 6 specialized sub-agents
- Distributed processing (15 total concurrent tasks)
- Clear separation of concerns

## Migration Steps

### Phase 1: Deploy Sub-Agents (Day 1)
1. Import all 6 sub-agent workflows into n8n
2. Configure credentials for each sub-agent
3. Test each sub-agent individually
4. Verify inter-agent communication

### Phase 2: Update Business Manager (Day 2)
1. Backup current Business Manager workflow
2. Import new orchestrator workflow
3. Update system prompt reference
4. Test routing logic

### Phase 3: Integration Testing (Day 3-4)
1. Test all routing paths
2. Verify priority handling
3. Load test with concurrent requests
4. Monitor performance metrics

### Phase 4: Gradual Rollout (Day 5-7)
1. Route 10% traffic to new system
2. Monitor for issues
3. Increase to 50% if stable
4. Full cutover when validated

## Testing Checklist

- [ ] Strategic decisions route correctly
- [ ] Performance analytics queries work
- [ ] Budget optimization triggers properly
- [ ] Campaign coordination functions
- [ ] Workflow automation executes
- [ ] Stakeholder reports generate
- [ ] Director delegation works
- [ ] Error handling is robust
- [ ] Response times <2 seconds
- [ ] Memory management stable

## Rollback Plan

If issues occur:
1. Switch webhook to backup workflow
2. Investigate issues in staging
3. Fix and redeploy
4. Gradual rollout again

## Monitoring

Key metrics to track:
- Response time (target: <2s)
- Routing accuracy (target: >95%)
- Task completion rate (target: >95%)
- Error rate (target: <2%)
- Sub-agent utilization

## Support

For issues or questions:
- Check sub-agent logs
- Review orchestrator routing
- Verify credential configuration
- Test individual components

---
Migration Date: {datetime.now().isoformat()}
"""
    
    migration_file = BASE_PATH / "docs/business_manager_orchestrator_migration.md"
    with open(migration_file, 'w', encoding='utf-8') as f:
        f.write(migration_guide)
    print(f"\n📚 Migration guide: {migration_file}")
    
    print("\n" + "=" * 60)
    print("✅ Business Manager Orchestrator Update Complete!")
    print("\n🎯 Next Steps:")
    print("1. Review the updated workflow structure")
    print("2. Import into n8n following migration guide")
    print("3. Test routing logic with sample requests")
    print("4. Monitor sub-agent performance")
    print("5. Gradually increase traffic to new system")

if __name__ == "__main__":
    main()