# MCP Connection Updates Required

## Business Manager Agent Workflow Updates

### Current Issues:
1. MCP tools are using incorrect credentials ("WordPress MCP Client")
2. Missing executive communication MCPs (telegram-mcp, email-mcp, html-report-generator-mcp)
3. Missing analytics MCPs (kpi-dashboard, business-scorecard)
4. Missing core service MCPs (linear-mcp-server, n8n-mcp-server)

### Required MCP Tool Nodes:

#### 1. Telegram MCP (Executive Communication)
```json
{
  "parameters": {
    "operation": "executeTool",
    "toolName": "send_message",
    "toolParameters": "={{ {\n  \"chat_id\": $fromAI(\"chat_id\", \"Kingler's Telegram chat ID\"),\n  \"text\": $fromAI(\"message\", \"Message content for stakeholder\"),\n  \"parse_mode\": \"Markdown\"\n} }}"
  },
  "type": "n8n-nodes-mcp.mcpClientTool",
  "typeVersion": 1,
  "position": [3000, -100],
  "id": "telegram-mcp",
  "name": "Telegram MCP",
  "credentials": {
    "mcpClientApi": {
      "id": "TelegramMCP",
      "name": "Telegram MCP account"
    }
  }
}
```

#### 2. Email MCP (Executive Reports)
```json
{
  "parameters": {
    "operation": "executeTool",
    "toolName": "send_email",
    "toolParameters": "={{ {\n  \"to\": $fromAI(\"recipient\", \"kingler@vividwalls.co\"),\n  \"subject\": $fromAI(\"subject\", \"Email subject\"),\n  \"body\": $fromAI(\"body\", \"Email body content\"),\n  \"cc\": $fromAI(\"cc\", \"CC recipients\", \"optional\")\n} }}"
  },
  "type": "n8n-nodes-mcp.mcpClientTool",
  "typeVersion": 1,
  "position": [3400, -100],
  "id": "email-mcp",
  "name": "Email MCP",
  "credentials": {
    "mcpClientApi": {
      "id": "SendGridMCP",
      "name": "SendGrid MCP account"
    }
  }
}
```

#### 3. HTML Report Generator MCP
```json
{
  "parameters": {
    "operation": "executeTool",
    "toolName": "generate_report",
    "toolParameters": "={{ {\n  \"report_type\": $fromAI(\"report_type\", \"executive_dashboard, performance_report, strategic_review\"),\n  \"data\": $fromAI(\"report_data\", \"Report data object\", \"json\"),\n  \"template\": $fromAI(\"template\", \"vividwalls_executive\", \"optional\")\n} }}"
  },
  "type": "n8n-nodes-mcp.mcpClientTool",
  "typeVersion": 1,
  "position": [3800, -100],
  "id": "html-report-mcp",
  "name": "HTML Report Generator MCP",
  "credentials": {
    "mcpClientApi": {
      "id": "HTMLReportGeneratorMCP",
      "name": "HTML Report Generator MCP account"
    }
  }
}
```

#### 4. Linear MCP (Task Management)
```json
{
  "parameters": {
    "operation": "executeTool",
    "toolName": "={{ $fromAI('linear_tool', 'create_issue, update_issue, get_issue, search_issues, create_project_update') }}",
    "toolParameters": "={{ $fromAI('tool_parameters', 'Parameters for Linear tool', 'json') }}"
  },
  "type": "n8n-nodes-mcp.mcpClientTool",
  "typeVersion": 1,
  "position": [4200, -100],
  "id": "linear-mcp",
  "name": "Linear MCP",
  "credentials": {
    "mcpClientApi": {
      "id": "LinearMCP",
      "name": "Linear MCP account"
    }
  }
}
```

#### 5. KPI Dashboard MCP
```json
{
  "parameters": {
    "operation": "executeTool",
    "toolName": "={{ $fromAI('kpi_tool', 'get_business_kpis, get_department_performance, get_financial_metrics') }}",
    "toolParameters": "={{ $fromAI('tool_parameters', 'Parameters for KPI tool', 'json') }}"
  },
  "type": "n8n-nodes-mcp.mcpClientTool",
  "typeVersion": 1,
  "position": [4600, -100],
  "id": "kpi-dashboard-mcp",
  "name": "KPI Dashboard MCP",
  "credentials": {
    "mcpClientApi": {
      "id": "KPIDashboardMCP",
      "name": "KPI Dashboard MCP account"
    }
  }
}
```

### Required Credential Updates:

1. Update Business Manager Prompts MCP credentials:
   - From: "WordPress MCP Client (STDIO) account"
   - To: "BusinessManagerPromptsMCP"

2. Update Business Manager Resources MCP credentials:
   - From: "WordPress MCP Client (STDIO) account"
   - To: "BusinessManagerResourceMCP"

### Connection Updates:

All new MCP tool nodes must be connected to the Business Manager Agent node:
```json
"connections": {
  "telegram-mcp": {
    "ai_tool": [
      [
        {
          "node": "Business Manager Agent",
          "type": "ai_tool",
          "index": 0
        }
      ]
    ]
  },
  "email-mcp": {
    "ai_tool": [
      [
        {
          "node": "Business Manager Agent",
          "type": "ai_tool",
          "index": 0
        }
      ]
    ]
  },
  // ... continue for all MCP tools
}
```

## Director Agent Workflow Updates

### Marketing Director
- Ensure marketing-director-prompts uses correct credentials
- Ensure marketing-director-resource uses correct credentials
- Add shopify-mcp-server connection
- Add wordpress-mcp-server connection
- Add sendgrid-mcp-server connection

### Sales Director
- Add sales-director-prompts MCP
- Add sales-director-resource MCP
- Add shopify-mcp-server connection
- Add stripe-mcp-server connection
- Add twenty-mcp-server connection

### Analytics Director
- Add analytics-director-prompts MCP
- Add analytics-director-resource MCP
- Add kpi-dashboard-mcp-server connection
- Add supabase-mcp-server connection

### Finance Director
- Add finance-director-prompts MCP
- Add finance-director-resource MCP
- Add stripe-mcp-server connection
- Add shopify-mcp-server connection (for revenue data)

### Operations Director
- Add operations-director-prompts MCP
- Add operations-director-resource MCP
- Add shopify-mcp-server connection
- Add medusa-mcp-server connection

### Customer Experience Director
- Add customer-experience-director-prompts MCP
- Add customer-experience-director-resource MCP
- Add twenty-mcp-server connection
- Add sendgrid-mcp-server connection
- Add listmonk-mcp-server connection

### Product Director
- Add product-director-prompts MCP
- Add product-director-resource MCP
- Add shopify-mcp-server connection
- Add pictorem-mcp-server connection

### Technology Director
- Add technology-director-prompts MCP
- Add technology-director-resource MCP
- Add n8n-mcp-server connection
- Add neo4j-mcp-server connection
- Add supabase-mcp-server connection

### Creative Director
- Add creative-director-prompts MCP
- Add creative-director-resource MCP
- Add pictorem-mcp-server connection
- Add wordpress-mcp-server connection

### Social Media Director
- Add social-media-director-prompts MCP
- Add social-media-director-resource MCP
- Add facebook-analytics-mcp connection
- Add pinterest-mcp-server connection
- Add postiz-mcp-server connection

## Implementation Steps

1. **Create MCP Credentials in n8n**:
   - Go to n8n UI > Credentials
   - Create MCP Client credentials for each MCP server
   - Use the server names from MCP_CLIENT_CONFIGURATION_GUIDE.md

2. **Update Workflows**:
   - Open each agent workflow in n8n
   - Add missing MCP tool nodes
   - Update incorrect credentials
   - Connect all MCP tools to the agent node

3. **Test Connections**:
   - Execute test runs for each MCP tool
   - Verify tool parameters are correctly extracted
   - Check error handling and responses

4. **Validate Agent Communication**:
   - Test Business Manager delegating to directors
   - Test directors accessing their specific MCPs
   - Verify security boundaries (no cross-director access)