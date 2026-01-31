# VividWalls Multi-Agent System Documentation

## Table of Contents
- [Agent Hierarchy](#agent-hierarchy)
- [Agent Types](#agent-types)
- [Core Director Agents](#core-director-agents)
- [Department Agents](#department-agents)
- [Agent Communication](#agent-communication)
- [Workflow Standards](#workflow-standards)
- [Agent Population Summary](#agent-population-summary)

## Agent Hierarchy

### Core Director Agents
1. **Business Manager Agent** - Central orchestrator
2. **Marketing Director Agent** - Chief Marketing Officer
3. **Operations Director Agent** - Chief Operations Officer
4. **Customer Experience Director Agent** - Chief Customer Officer
5. **Product Director Agent** - Chief Product Officer
6. **Finance Director Agent** - Chief Financial Officer
7. **Analytics Director Agent** - Chief Data Officer
8. **Technology Director Agent** - Chief Technology Officer

## Agent Types

### 1. Director / Orchestrator Agents
- Set strategy and allocate resources
- Own complete n8n workflows
- May call other agents

### 2. Action / Task-oriented Agents
- Perform scoped work
- Operate within parent workflows
- Accessed via Call n8n Workflow Tool or MCP Client

## Department Agents

### Marketing Department
- **Social Media Agents**: Facebook, Instagram, Pinterest
- **Content Creation**: Copy Writer, Copy Editor
- **Analytics**: Campaign Analytics, Audience Intelligence

### Operations Department
- **Fulfillment**: Order Processing, Inventory Management
- **Logistics**: Shipping, Returns

### Customer Experience
- **Support**: Customer Service, Returns
- **Engagement**: Loyalty, Feedback Analysis

## Agent Communication

### Communication Patterns
- Director-to-Director: Strategic alignment
- Director-to-Task: Work delegation
- Task-to-Task: Data sharing and coordination

### Integration Points
- MCP Servers for tool access
- n8n workflows for automation
- Centralized data storage

## Workflow Standards

### n8n Integration
- Standardized workflow templates
- Error handling and logging
- Performance monitoring

### MCP Client Usage
- **List Tools** for discovery
- **Call Tools** for execution
- Standardized error responses

## Agent Population Summary

### Core Department (8 Director Agents)
1. Business Manager Agent
2. Analytics Director Agent
3. Customer Experience Director Agent
4. Finance Director Agent
5. Marketing Director Agent
6. Operations Director Agent
7. Product Director Agent
8. Technology Director Agent

### Department Agents (20+ Task Agents)
- Marketing: Audience Intelligence, Campaign Analytics, etc.
- Operations: Fulfillment, Logistics, etc.
- Customer Experience: Support, Engagement, etc.

## Related Documentation
- [n8n Workflow Standards](N8N_AGENT_WORKFLOW_STANDARDS.md)
- [Multi-Agent System Schema](MULTI_AGENT_SYSTEM_SCHEMA.md)
- [Agent Strategy Reconciliation](AGENT_STRATEGY_RECONCILIATION.md)
