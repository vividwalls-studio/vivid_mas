# VividWalls Multi-Agent System - Organizational Hierarchy

## Proper Hierarchical Structure

### Executive Level
```
Business Manager Agent (Central Orchestrator)
    │
    ├── Purpose: Strategic oversight and coordination
    ├── Direct Reports: All 9 Directors
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
    │   ├── Data Analytics Agent (Primary - Single Source of Truth)
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
    ├── Technology Director
    │   ├── System Monitoring Agent
    │   ├── Integration Management Agent
    │   └── n8n Automation (MCP)
    │
    └── Sales Director
        ├── Commercial Buyers Team
        │   ├── Hospitality Sales Agent
        │   ├── Corporate Sales Agent
        │   ├── Healthcare Sales Agent
        │   ├── Retail Sales Agent
        │   └── Real Estate Sales Agent
        ├── Residential Buyers Team
        │   ├── Homeowner Sales Agent
        │   ├── Renter Sales Agent
        │   ├── Interior Designer Sales Agent
        │   ├── Art Collector Sales Agent
        │   └── Gift Buyer Sales Agent
        └── Online Shoppers Team
            ├── Millennial/Gen Z Sales Agent
            └── Global Customer Sales Agent
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
- **Sales Director**: Sales CRM MCP, Shopify MCP, Linear MCP
- **Operations Director**: Shopify MCP, Inventory MCP
- **Finance Director**: Accounting MCP, Payment Processing MCP
- **Technology Director**: n8n MCP, Monitoring MCPs
- **Analytics Director**: Marketing Analytics Aggregator MCP, Analytics Director Prompts MCP, Analytics Director Resource MCP, Data Analytics Prompts MCP, Data Analytics Resource MCP, Analytics Dashboard MCP, Performance Metrics MCP

### Agent-Level MCPs
- Platform-specific MCPs aligned with agent responsibilities
- Each agent has access only to their required MCPs

## Special Roles

### Data Analytics Agent - Single Source of Truth
The Data Analytics Agent serves a unique cross-functional role:
- **Primary Data Hub**: All agents request performance data through this agent
- **Prevents Duplication**: Ensures consistent metrics across all departments
- **Real-time Access**: Provides up-to-the-minute business metrics
- **Quality Assurance**: Validates data integrity before distribution
- **MCP Access**: 
  - marketing-analytics-aggregator (aggregates from multiple sources)
  - data-analytics-prompts (specialized analysis prompts)
  - data-analytics-resource (pre-computed KPIs)
  - Direct access to Shopify, Supabase, and Stripe MCPs

## Key Principles

1. **Separation of Concerns**: Each level has distinct responsibilities
2. **Clean Boundaries**: MCPs belong to the appropriate organizational level
3. **Delegation Over Direct Access**: Higher levels delegate rather than directly access platforms
4. **Bi-directional Communication**: Clear paths for both delegation and reporting
5. **Single Responsibility**: Each agent/director owns their domain
6. **Centralized Data Access**: All performance data flows through the Data Analytics Agent

## Implementation Notes

- Business Manager should NOT have direct platform MCPs
- Directors coordinate their department's agents
- Platform agents handle direct platform interactions
- MCPs are assigned based on functional responsibility
- All communication follows the hierarchical structure

## Resilience & Reliability

The VividWalls MAS implements comprehensive resilience patterns based on multi-agent system failure research:

- **Message Acknowledgments**: All inter-agent communications use ACK/NACK protocols
- **Circuit Breakers**: Prevent cascading failures across agent dependencies
- **Context Management**: Sliding window summarization prevents information loss
- **Clarification Protocols**: Agents request clarification when ambiguity detected
- **Multi-Level Verification**: Syntax, logic, and semantic validation layers

For detailed implementation plan, see [PLAN.md](./PLAN.md)

Last Updated: 2025-07-03
