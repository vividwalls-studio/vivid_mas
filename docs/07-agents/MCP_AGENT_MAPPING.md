# MCP Agent Mapping Guide

This document maps each agent in the VividWalls Multi-Agent System to their appropriate MCP server connections in n8n workflows.

## Business Manager Agent

### Executive Communication MCPs (Direct Access)
- **telegram-mcp**: Real-time stakeholder notifications
- **email-mcp**: Formal executive reports  
- **html-report-generator-mcp**: Interactive dashboards

### Agent-Specific MCPs
- **business-manager-prompts**: Strategic prompt templates
- **business-manager-resource**: Strategic frameworks and knowledge

### Analytics MCPs
- **kpi-dashboard-mcp-server**: Business KPI monitoring
- **business-scorecard-mcp-server**: Executive scorecard

### Core Service MCPs
- **linear-mcp-server**: Project management and task delegation
- **n8n-mcp-server**: Workflow orchestration control

## Marketing Director Agent

### Agent-Specific MCPs
- **marketing-director-prompts**: Marketing strategy prompts
- **marketing-director-resource**: Marketing knowledge base

### Marketing Tool MCPs
- **shopify-mcp-server**: Product and customer data
- **wordpress-mcp-server**: Content management
- **sendgrid-mcp-server**: Email campaigns

### Analytics MCPs
- **marketing-analytics-aggregator**: Campaign performance

## Sales Director Agent

### Agent-Specific MCPs
- **sales-director-prompts**: Sales strategy prompts
- **sales-director-resource**: Sales knowledge base

### Sales Tool MCPs
- **shopify-mcp-server**: Order and customer management
- **stripe-mcp-server**: Payment processing
- **twenty-mcp-server**: CRM operations

## Social Media Director Agent

### Agent-Specific MCPs
- **social-media-director-prompts**: Social media strategy prompts
- **social-media-director-resource**: Social platform knowledge

### Platform MCPs
- **facebook-analytics-mcp**: Facebook/Meta insights
- **pinterest-mcp-server**: Pinterest management
- **postiz-mcp-server**: Social media scheduling

## Analytics Director Agent

### Agent-Specific MCPs
- **analytics-director-prompts**: Analytics strategy prompts
- **analytics-director-resource**: Analytics frameworks

### Analytics Tool MCPs
- **kpi-dashboard-mcp-server**: Performance metrics
- **shopify-mcp-server**: E-commerce analytics
- **supabase-mcp-server**: Database queries

## Finance Director Agent

### Agent-Specific MCPs
- **finance-director-prompts**: Financial strategy prompts
- **finance-director-resource**: Financial frameworks

### Financial Tool MCPs
- **stripe-mcp-server**: Payment analytics
- **shopify-mcp-server**: Revenue data

## Operations Director Agent

### Agent-Specific MCPs
- **operations-director-prompts**: Operations strategy prompts
- **operations-director-resource**: Operations knowledge

### Operations Tool MCPs
- **shopify-mcp-server**: Inventory and fulfillment
- **medusa-mcp-server**: E-commerce operations

## Customer Experience Director Agent

### Agent-Specific MCPs
- **customer-experience-director-prompts**: CX strategy prompts
- **customer-experience-director-resource**: CX frameworks

### Customer Tool MCPs
- **twenty-mcp-server**: Customer relationship management
- **sendgrid-mcp-server**: Customer communications
- **listmonk-mcp-server**: Newsletter management

## Product Director Agent

### Agent-Specific MCPs
- **product-director-prompts**: Product strategy prompts
- **product-director-resource**: Product knowledge

### Product Tool MCPs
- **shopify-mcp-server**: Product catalog management
- **pictorem-mcp-server**: Print-on-demand integration

## Technology Director Agent

### Agent-Specific MCPs
- **technology-director-prompts**: Tech strategy prompts
- **technology-director-resource**: Technical frameworks

### Technical Tool MCPs
- **n8n-mcp-server**: Workflow automation
- **neo4j-mcp-server**: Knowledge graph management
- **supabase-mcp-server**: Database operations

## Creative Director Agent

### Agent-Specific MCPs
- **creative-director-prompts**: Creative strategy prompts
- **creative-director-resource**: Design frameworks

### Creative Tool MCPs
- **pictorem-mcp-server**: Artwork management
- **wordpress-mcp-server**: Content creation

## Common MCPs for All Directors

### Communication & Collaboration
- **linear-mcp-server**: Task management (all directors can create/update tasks)

### Knowledge & Memory
- **knowledge-reasoning-mcp-server**: Domain-specific reasoning
- **neo4j-mcp-server**: Knowledge graph queries (filtered by domain)

## MCP Server Connection Format in n8n

### For Tool-based MCPs (e.g., shopify-mcp-server):
```json
{
  "parameters": {
    "operation": "executeTool",
    "toolName": "={{ $fromAI('tool_name', 'get-products, get-customers, get-orders') }}",
    "toolParameters": "={{ $fromAI('tool_parameters', 'Parameters for tool', 'json') }}"
  },
  "type": "n8n-nodes-mcp.mcpClientTool",
  "credentials": {
    "mcpClientApi": {
      "id": "ShopifyMCP",
      "name": "Shopify MCP account"
    }
  }
}
```

### For Prompt-based MCPs:
```json
{
  "parameters": {
    "operation": "get_prompt",
    "promptName": "={{ $fromAI('prompt_name', 'available-prompts-list') }}"
  },
  "type": "n8n-nodes-mcp.mcpClientPrompt",
  "credentials": {
    "mcpClientApi": {
      "id": "MarketingDirectorPromptsMCP",
      "name": "Marketing Director Prompts MCP"
    }
  }
}
```

### For Resource-based MCPs:
```json
{
  "parameters": {
    "operation": "read-resource",
    "resourceUri": "marketing-director://knowledge/campaign-frameworks"
  },
  "type": "n8n-nodes-mcp.mcpClientResource",
  "credentials": {
    "mcpClientApi": {
      "id": "MarketingDirectorResourceMCP",
      "name": "Marketing Director Resource MCP"
    }
  }
}
```

## Connection Rules

1. **Executive Tools**: Only Business Manager has direct access to telegram-mcp, email-mcp, and html-report-generator-mcp
2. **Director Tools**: Each director can only delegate to their own sub-agents, not to other directors
3. **Platform MCPs**: Social Media Director manages all social platform MCPs
4. **Analytics Access**: Analytics Director has read access to all data MCPs but write access only to analytics-specific tools
5. **Security**: Each agent's MCP credentials should be scoped to their specific permissions

## Implementation Notes

- All MCP connections must use the `ai_tool` connection type to the agent node
- Each MCP tool node must have proper credentials configured
- Tool parameters should use `$fromAI()` for dynamic extraction from agent responses
- Memory and knowledge access should be filtered by agent domain