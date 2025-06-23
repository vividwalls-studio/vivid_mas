# Business Manager KPI Dashboard Integration Guide

## Overview

The Business Manager KPI Dashboard provides comprehensive oversight tools for the Business Manager Agent to monitor, coordinate, and optimize all business operations within the VividWalls Multi-Agent System.

## Key Features

### 1. Executive Dashboard
- Real-time business metrics and KPIs
- Multi-channel performance overview
- Agent coordination status
- Crisis trigger monitoring
- Strategic recommendations

### 2. Agent Performance Tracking
- Task completion metrics
- Response time analysis
- Quality score tracking
- Coordination efficiency
- Inter-agent communication patterns

### 3. Budget Management
- Channel allocation tracking
- ROI analysis by channel
- Budget optimization recommendations
- Historical performance comparison

### 4. Crisis Management
- Real-time trigger monitoring
- Automated alert generation
- Resolution tracking
- Impact analysis

## Available MCP Tools

### Core Business Manager Tools

#### `get_business_manager_dashboard`
Retrieves comprehensive dashboard with all critical KPIs.

**Parameters:**
- `timeframe`: 'daily' | 'weekly' | 'monthly' (default: 'daily')

**Example Usage:**
```javascript
const dashboard = await mcp.callTool('get_business_manager_dashboard', {
  timeframe: 'weekly'
});
```

**Response Structure:**
```json
{
  "success": true,
  "data": {
    "timestamp": "2024-01-15T10:00:00Z",
    "timeframe": "weekly",
    "executive_summary": {
      "total_revenue": 125000,
      "revenue_growth": 15.5,
      "total_orders": 450,
      "conversion_rate": 3.2,
      "average_order_value": 277.78,
      "customer_acquisition_cost": 42.50,
      "customer_lifetime_value": 850.00,
      "overall_roas": 3.8
    },
    "channel_performance": {...},
    "agent_coordination": {...},
    "operational_health": {...},
    "crisis_alerts": [],
    "recommendations": [...]
  }
}
```

#### `track_agent_task`
Records agent task completion for performance tracking.

**Parameters:**
- `agent_id`: string - ID of the agent
- `task_data`: object
  - `task_type`: string
  - `completion_time_ms`: number
  - `success`: boolean
  - `quality_score`: number (optional, 0-1)
  - `impact_metrics`: object (optional)

#### `track_agent_communication`
Monitors inter-agent communication patterns.

**Parameters:**
- `from_agent`: string
- `to_agent`: string
- `communication_type`: 'task_delegation' | 'data_request' | 'status_update' | 'collaboration'
- `response_time_ms`: number (optional)
- `success`: boolean

#### `track_budget_allocation`
Records budget allocation decisions.

**Parameters:**
- `channel`: string
- `previous_budget`: number
- `new_budget`: number
- `reason`: string
- `expected_roi`: number
- `decision_metrics`: object

#### `get_agent_scorecard`
Generates performance scorecard for agents.

**Parameters:**
- `agent_id`: string (optional - all agents if omitted)
- `days`: number (default: 7)

#### `monitor_crisis_triggers`
Real-time crisis trigger monitoring.

**Parameters:** None

**Crisis Triggers Monitored:**
- Revenue decline > 10%
- Customer satisfaction < 4.0
- CAC > $50
- Inventory stockouts
- System downtime

#### `generate_stakeholder_report`
Creates formatted reports for stakeholder communication.

**Parameters:**
- `report_type`: 'daily' | 'weekly' | 'monthly'

**Returns:** Interactive HTML dashboard with charts and visualizations

### Strategic Decision Support Tools

#### `analyze_strategic_alignment`
Analyzes alignment between agent activities and business objectives.

#### `coordinate_multi_agent_campaign`
Coordinates complex campaigns across multiple agents.

#### `evaluate_resource_allocation_efficiency`
Evaluates current resource allocation efficiency.

## Integration with n8n Workflows

### 1. Business Manager Workflow Integration

The Business Manager Agent workflow should include these key nodes:

```json
{
  "nodes": [
    {
      "type": "mcp-client",
      "name": "Get Dashboard",
      "parameters": {
        "server": "kpi-dashboard",
        "tool": "get_business_manager_dashboard",
        "timeframe": "daily"
      }
    },
    {
      "type": "mcp-client",
      "name": "Check Crisis Triggers",
      "parameters": {
        "server": "kpi-dashboard",
        "tool": "monitor_crisis_triggers"
      }
    }
  ]
}
```

### 2. Automated Monitoring Schedule

Recommended monitoring schedule:
- **Morning (9 AM)**: Daily dashboard review
- **Midday (1 PM)**: Crisis trigger check
- **Evening (5 PM)**: Agent scorecard review
- **Weekly**: Strategic alignment analysis
- **Monthly**: Comprehensive stakeholder report

### 3. Agent Communication Protocol

When delegating tasks to other agents:

```javascript
// Track the delegation
await mcp.callTool('track_agent_communication', {
  from_agent: 'business_manager',
  to_agent: 'marketing_director',
  communication_type: 'task_delegation',
  success: true
});

// Track task completion
await mcp.callTool('track_agent_task', {
  agent_id: 'marketing_director',
  task_data: {
    task_type: 'campaign_optimization',
    completion_time_ms: 3600000,
    success: true,
    quality_score: 0.95,
    impact_metrics: {
      roas_improvement: 0.15,
      budget_saved: 2500
    }
  }
});
```

## Database Schema

The Business Manager KPI tracking uses dedicated tables:

1. **agent_tasks** - Task execution tracking
2. **agent_communications** - Inter-agent communication log
3. **budget_allocations** - Budget decision history
4. **agent_performance_metrics** - Daily performance aggregates
5. **crisis_triggers** - Alert and resolution tracking
6. **strategic_decisions** - Major decision log
7. **coordination_sessions** - Multi-agent campaign tracking
8. **stakeholder_reports** - Report generation history
9. **business_kpi_snapshots** - Hourly KPI snapshots

## Best Practices

### 1. Regular Monitoring
- Check crisis triggers at least 3 times daily
- Review agent scorecards weekly
- Generate stakeholder reports on schedule

### 2. Proactive Management
- Set up automated alerts for crisis triggers
- Track all major budget reallocations
- Document strategic decisions with rationale

### 3. Agent Coordination
- Track all inter-agent communications
- Monitor task completion rates
- Identify bottlenecks in coordination

### 4. Performance Optimization
- Use historical data for trend analysis
- Compare actual vs expected ROI
- Adjust strategies based on KPI insights

## Example Use Cases

### 1. Daily Morning Review
```javascript
// Get overnight performance
const dashboard = await mcp.callTool('get_business_manager_dashboard', {
  timeframe: 'daily'
});

// Check for any crisis alerts
const triggers = await mcp.callTool('monitor_crisis_triggers', {});

// If issues found, coordinate response
if (triggers.data.active_alerts.length > 0) {
  // Delegate to appropriate agents
  // Track the delegation
  // Set follow-up reminders
}
```

### 2. Budget Reallocation Decision
```javascript
// Track the decision
await mcp.callTool('track_budget_allocation', {
  channel: 'facebook_ads',
  previous_budget: 10000,
  new_budget: 12500,
  reason: 'High ROAS performance last week',
  expected_roi: 4.2,
  decision_metrics: {
    last_week_roas: 4.5,
    conversion_rate: 3.8,
    cac: 35
  }
});
```

### 3. Multi-Agent Campaign Coordination
```javascript
// Coordinate product launch campaign
const campaign = await mcp.callTool('coordinate_multi_agent_campaign', {
  campaign_type: 'product_launch',
  agents_involved: [
    'marketing_director',
    'social_media_director',
    'email_marketing_agent',
    'shopify_agent'
  ],
  budget: 25000,
  duration_days: 30
});

// Track progress through agent communications
// Monitor performance through dashboard
// Adjust as needed based on KPIs
```

## Troubleshooting

### Common Issues

1. **Missing Data in Dashboard**
   - Ensure all agents are properly tracking tasks
   - Check database connectivity
   - Verify data collection intervals

2. **Crisis Triggers Not Firing**
   - Review threshold settings
   - Check metric calculation logic
   - Verify real-time data flow

3. **Agent Communication Gaps**
   - Ensure all agents use tracking tools
   - Review communication protocols
   - Check for timeout issues

## Future Enhancements

1. **Predictive Analytics**
   - ML-based crisis prediction
   - Trend forecasting
   - Anomaly detection

2. **Advanced Visualizations**
   - Real-time dashboards
   - Interactive reports
   - Mobile app integration

3. **Automated Responses**
   - Crisis auto-remediation
   - Dynamic budget reallocation
   - Intelligent task routing