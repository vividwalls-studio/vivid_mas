# MCP Validation Checklist for Agent Workflows

Use this checklist to verify that each agent workflow in n8n has the correct MCP server connections configured.

## ✅ Business Manager Agent

**Location**: `/core/orchestration/business_manager_agent.json`

- [ ] **Telegram MCP** connected (for stakeholder notifications)
- [ ] **SendGrid MCP** connected (for executive emails)
- [ ] **HTML Report Generator MCP** connected (for dashboards)
- [ ] **Linear MCP** connected (for project management)
- [ ] **n8n MCP** connected (for workflow oversight)
- [ ] **Business Manager Prompts MCP** connected
- [ ] **Business Manager Resources MCP** connected
- [ ] **KPI Dashboard MCP** connected
- [ ] **Business Scorecard MCP** connected

## ✅ Marketing Director

**Location**: `/domains/marketing/marketing_director_agent.json`

- [ ] **Marketing Director Prompts MCP** connected
- [ ] **Marketing Director Resources MCP** connected
- [ ] **Shopify MCP** connected (product/customer data)
- [ ] **WordPress MCP** connected (content management)
- [ ] **SendGrid MCP** connected (email campaigns)
- [ ] **Marketing Analytics Aggregator MCP** connected
- [ ] **Linear MCP** connected
- [ ] **Neo4j MCP** connected (marketing domain filter)

## ✅ Sales Director

**Location**: `/domains/sales/sales_director_agent.json`

- [ ] **Sales Director Prompts MCP** connected
- [ ] **Sales Director Resources MCP** connected
- [ ] **Shopify MCP** connected (orders/customers)
- [ ] **Stripe MCP** connected (payments)
- [ ] **Twenty CRM MCP** connected
- [ ] **Sales Analytics MCP** connected
- [ ] **Linear MCP** connected
- [ ] **Neo4j MCP** connected (sales domain filter)

## ✅ Operations Director

**Location**: `/domains/operations/operations_director_agent.json`

- [ ] **Operations Director Prompts MCP** connected
- [ ] **Operations Director Resources MCP** connected
- [ ] **Shopify MCP** connected (inventory/fulfillment)
- [ ] **Medusa MCP** connected
- [ ] **Pictorem MCP** connected
- [ ] **Linear MCP** connected
- [ ] **Neo4j MCP** connected (operations domain filter)

## ✅ Customer Experience Director

**Location**: `/domains/customer_experience/customer_experience_director_agent.json`

- [ ] **CX Director Prompts MCP** connected
- [ ] **CX Director Resources MCP** connected
- [ ] **Twenty CRM MCP** connected
- [ ] **SendGrid MCP** connected (customer comms)
- [ ] **Listmonk MCP** connected (newsletters)
- [ ] **Shopify MCP** connected (order history)
- [ ] **Linear MCP** connected
- [ ] **Neo4j MCP** connected (customer domain filter)

## ✅ Product Director

**Location**: `/domains/product/product_director_agent.json`

- [ ] **Product Director Prompts MCP** connected
- [ ] **Product Director Resources MCP** connected
- [ ] **Shopify MCP** connected (product catalog)
- [ ] **Pictorem MCP** connected (artwork specs)
- [ ] **WordPress MCP** connected (product content)
- [ ] **Linear MCP** connected
- [ ] **Neo4j MCP** connected (product domain filter)

## ✅ Finance Director

**Location**: `/domains/finance/finance_director_agent.json`

- [ ] **Finance Director Prompts MCP** connected
- [ ] **Finance Director Resources MCP** connected
- [ ] **Stripe MCP** connected (payment analytics)
- [ ] **Shopify MCP** connected (sales data)
- [ ] **Financial Analytics MCP** connected
- [ ] **Linear MCP** connected
- [ ] **Neo4j MCP** connected (finance domain filter)

## ✅ Analytics Director

**Location**: `/domains/analytics/analytics_director_agent.json`

- [ ] **Analytics Director Prompts MCP** connected
- [ ] **Analytics Director Resources MCP** connected
- [ ] **Supabase MCP** connected (database queries)
- [ ] **KPI Dashboard MCP** connected
- [ ] **Shopify MCP** connected (analytics)
- [ ] **Marketing Analytics Aggregator MCP** connected
- [ ] **Linear MCP** connected
- [ ] **Neo4j MCP** connected (full access)

## ✅ Technology Director

**Location**: `/domains/technology/technology_director_agent.json`

- [ ] **Technology Director Prompts MCP** connected
- [ ] **Technology Director Resources MCP** connected
- [ ] **n8n MCP** connected (workflow automation)
- [ ] **Supabase MCP** connected (database admin)
- [ ] **Neo4j MCP** connected (graph admin)
- [ ] **Linear MCP** connected

## ✅ Social Media Director

**Location**: `/domains/social_media/social_media_director_agent.json`

- [ ] **Social Media Director Prompts MCP** connected
- [ ] **Social Media Director Resources MCP** connected
- [ ] **Facebook Analytics MCP** connected
- [ ] **Pinterest MCP** connected
- [ ] **Postiz MCP** connected
- [ ] **Linear MCP** connected
- [ ] **Neo4j MCP** connected (social domain filter)

## ✅ Creative Director

**Location**: `/domains/marketing/creative_director_agent.json`

- [ ] **Creative Director Prompts MCP** connected
- [ ] **Creative Director Resources MCP** connected
- [ ] **Pictorem MCP** connected (artwork)
- [ ] **WordPress MCP** connected (content)
- [ ] **Figma MCP** connected (design)
- [ ] **Linear MCP** connected
- [ ] **Neo4j MCP** connected (creative domain filter)

## Validation Steps

### 1. Credential Configuration
For each MCP connection:
1. Open n8n UI > Credentials
2. Create MCP Client credential with correct name
3. Configure with server details from `MCP_CLIENT_CONFIGURATION_GUIDE.md`

### 2. Node Connection
For each workflow:
1. Open workflow in n8n editor
2. Verify MCP tool nodes exist
3. Check credentials are assigned
4. Ensure ai_tool connections to agent node

### 3. Test Execution
For each MCP tool:
1. Create test input for the agent
2. Execute workflow with test data
3. Verify MCP tool is called correctly
4. Check response handling

### 4. Error Handling
Verify each workflow has:
- [ ] Error catch nodes for MCP failures
- [ ] Retry logic for transient errors
- [ ] Fallback behavior for tool unavailability
- [ ] Logging for debugging

## Common Issues and Fixes

### Issue: "MCP server not found"
**Fix**: Check credential configuration and server name matches exactly

### Issue: "Tool not available"
**Fix**: Verify tool name in workflow matches MCP server's available tools

### Issue: "Authentication failed"
**Fix**: Update MCP credentials with correct API keys/tokens

### Issue: "Connection timeout"
**Fix**: Ensure MCP server is running and accessible on configured port

## Sign-off

- [ ] All Business Manager MCPs validated
- [ ] All Director MCPs validated  
- [ ] All cross-functional connections tested
- [ ] Error handling implemented
- [ ] Documentation updated

**Validated by**: _________________
**Date**: _________________
**n8n Version**: _________________