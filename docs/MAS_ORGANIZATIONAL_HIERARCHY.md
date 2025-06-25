# VividWalls Multi-Agent System - Organizational Hierarchy

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

Last Updated: 2025-06-25T12:12:10.859495
