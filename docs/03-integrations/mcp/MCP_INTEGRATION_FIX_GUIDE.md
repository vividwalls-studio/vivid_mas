# MCP Integration Fix Guide for VividWalls MAS

## Overview

This guide provides specific instructions for fixing the MCP (Model Context Protocol) integration issues identified in the VividWalls Multi-Agent System.

## Current Issues

### 1. Placeholder Pattern Mismatch

**Problem**: Agent prompts use `${mcp_server_tool_name}` syntax that isn't connected to actual implementations.

**Example**:
```markdown
# In prompts:
${mcp_facebook-ads_create_campaign}
${mcp_pinterest_create_promoted_pin}

# In workflows:
No corresponding implementation
```

### 2. Missing MCP Server Integrations

**Critical Missing Servers**:
- Facebook Ads MCP (40% of traffic)
- Pinterest MCP (25% of traffic)
- Email Marketing MCP (highest ROI)
- Instagram MCP (growing channel)
- Google Analytics MCP (universal tracking)

### 3. Inconsistent Integration Patterns

**Current Patterns Found**:
1. Placeholder syntax in prompts: `${mcp_server_tool}`
2. n8n MCP nodes in some workflows: `n8n-nodes-mcp.mcpClientTool`
3. Sub-workflow calls instead of MCP: `@n8n/n8n-nodes-langchain.toolWorkflow`

## Fix Implementation Guide

### Step 1: Standardize MCP Tool References

**Convert all prompt placeholders to actual tool names**:

```markdown
# OLD (in prompts):
${mcp_facebook-ads_create_campaign}

# NEW (in prompts):
Available MCP Tools:
- **Facebook Ads MCP** (`create_campaign`) - Creates advertising campaigns
```

### Step 2: Implement MCP Client Nodes

**For each MCP server integration, add proper nodes**:

```json
{
  "parameters": {
    "operation": "listTools"
  },
  "type": "n8n-nodes-mcp.mcpClientTool",
  "name": "Facebook Ads MCP - List Tools",
  "credentials": {
    "mcpClientApi": {
      "id": "FacebookAdsMCPClient",
      "name": "Facebook Ads MCP account"
    }
  }
}
```

```json
{
  "parameters": {
    "operation": "executeTool",
    "toolName": "={{ $fromAI('selected_tool', 'create_campaign, update_campaign, get_insights') }}",
    "toolParameters": "={{ $fromAI('tool_parameters', 'Parameters for the selected tool', 'json') }}"
  },
  "type": "n8n-nodes-mcp.mcpClientTool",
  "name": "Facebook Ads MCP - Execute Tool"
}
```

### Step 3: Create MCP Server Configurations

**For each missing MCP server, create configuration**:

```javascript
// /services/mcp-servers/configs/facebook-ads-config.json
{
  "name": "facebook-ads-mcp",
  "command": "node",
  "args": ["./build/index.js"],
  "env": {
    "FACEBOOK_APP_ID": "${FACEBOOK_APP_ID}",
    "FACEBOOK_APP_SECRET": "${FACEBOOK_APP_SECRET}",
    "FACEBOOK_ACCESS_TOKEN": "${FACEBOOK_ACCESS_TOKEN}"
  }
}
```

### Step 4: Update Agent Prompts

**Remove placeholder syntax and use clear tool listings**:

```markdown
## Available MCP Tools

### Facebook Ads Management
- **Facebook Ads MCP**
  - `list_ad_accounts` - List all ad accounts
  - `create_campaign` - Create new campaign
  - `update_campaign` - Update existing campaign
  - `get_campaign_insights` - Get performance data
  - `create_ad_set` - Create ad set
  - `create_ad` - Create individual ad

### Pinterest Marketing  
- **Pinterest MCP**
  - `get_boards` - List all boards
  - `create_pin` - Create new pin
  - `create_promoted_pin` - Create promoted pin
  - `get_analytics` - Get performance metrics
```

### Step 5: Implement Fallback Logic

**Add error handling for missing MCP servers**:

```javascript
// In agent workflow
try {
  // Attempt MCP tool execution
  const result = await mcpClient.executeTool({
    server: 'facebook-ads',
    tool: 'create_campaign',
    parameters: campaignData
  });
} catch (error) {
  if (error.code === 'MCP_SERVER_NOT_FOUND') {
    // Fallback to manual process or queue for later
    await notifyAdmin('Facebook Ads MCP not available', {
      task: 'create_campaign',
      data: campaignData
    });
    // Use alternative method if available
    return alternativeCreateCampaign(campaignData);
  }
  throw error;
}
```

### Step 6: Create Tool Registry

**Implement dynamic tool discovery**:

```sql
-- In Supabase
INSERT INTO mcp_tools (name, mcp_server_name, tool_schema, is_active) VALUES
('create_campaign', 'facebook-ads-mcp', '{"parameters": {...}}', true),
('get_boards', 'pinterest-mcp', '{"parameters": {...}}', true);

-- Link tools to agents
INSERT INTO agent_tools (agent_id, tool_id, access_level) VALUES
((SELECT id FROM agents WHERE name = 'FacebookAgent'), 
 (SELECT id FROM mcp_tools WHERE name = 'create_campaign'), 
 'execute');
```

### Step 7: Implement Service Discovery

**Create MCP service registry**:

```javascript
// /services/mcp-servers/registry/index.js
class MCPServiceRegistry {
  constructor() {
    this.servers = new Map();
  }
  
  register(serverName, config) {
    this.servers.set(serverName, {
      ...config,
      status: 'pending',
      lastHealthCheck: null
    });
  }
  
  async healthCheck(serverName) {
    const server = this.servers.get(serverName);
    try {
      const response = await server.client.listTools();
      server.status = 'active';
      server.lastHealthCheck = new Date();
      server.availableTools = response.tools;
    } catch (error) {
      server.status = 'error';
      server.error = error.message;
    }
  }
  
  getAvailableTools(serverName) {
    const server = this.servers.get(serverName);
    return server?.status === 'active' ? server.availableTools : [];
  }
}
```

## Implementation Priority

### Week 1: Critical Revenue Protection
1. **Facebook Ads MCP**
   - Create server implementation
   - Update Business Manager workflow
   - Update Marketing Director workflow
   - Test campaign creation

2. **Email Marketing MCP (SendGrid)**
   - Implement server wrapper
   - Update Email Marketing Agent
   - Test email campaigns

### Week 2: Traffic Generation
1. **Pinterest MCP**
   - Implement Pinterest API wrapper
   - Update Pinterest Agent workflow
   - Test pin creation and analytics

2. **Instagram MCP**
   - Create Instagram Graph API integration
   - Update Instagram Agent workflow
   - Test content posting

### Week 3: Analytics & Monitoring
1. **Google Analytics MCP**
   - Implement GA4 integration
   - Update Analytics Director workflow
   - Create unified dashboard

2. **MCP Health Monitor**
   - Deploy service registry
   - Implement health checks
   - Create alerting system

## Validation Checklist

For each MCP integration:

- [ ] MCP server implementation exists in `/services/mcp-servers/`
- [ ] Server is documented in `MCP_SERVERS_DOCUMENTATION.md`
- [ ] Agent prompts reference actual tool names (not placeholders)
- [ ] Workflows include proper MCP client nodes
- [ ] Error handling implemented for server unavailability
- [ ] Tools registered in Supabase `mcp_tools` table
- [ ] Agent permissions set in `agent_tools` table
- [ ] Health monitoring configured
- [ ] Integration tests written and passing
- [ ] Sticky note documentation added to workflow

## Testing Protocol

1. **Unit Tests**: Test each MCP tool individually
2. **Integration Tests**: Test agent-to-MCP communication
3. **End-to-End Tests**: Test full workflow from trigger to response
4. **Failure Tests**: Test behavior when MCP servers are down
5. **Performance Tests**: Ensure < 5 second response times

## Monitoring Setup

```javascript
// Example monitoring configuration
{
  "mcp_servers": {
    "facebook-ads": {
      "health_check_interval": 60, // seconds
      "timeout": 30, // seconds
      "alerts": {
        "email": "admin@vividwalls.com",
        "slack": "#mcp-alerts"
      }
    }
  }
}
```

## Rollback Plan

If issues arise:

1. **Immediate**: Disable MCP integration, fall back to manual
2. **Short-term**: Route to human operators via Linear tasks
3. **Recovery**: Fix issues while system continues with fallbacks
4. **Validation**: Test thoroughly before re-enabling

---

*Created: [Current Date]*
*Priority: CRITICAL - Revenue Protection*
*Owner: Technology Director Agent*