# VividWalls MAS Agent Consolidation Guide

## Overview

This guide provides specific instructions for consolidating the current 58 agents into an optimized ~20 agent structure based on Anthropic patterns.

## Consolidation Map

### 1. Marketing Domain: From 14 to 4 Agents

#### A. Marketing Operations Agent (Orchestrator-Workers Pattern)
**Combines:**
- Marketing Director Agent
- Marketing Research Agent
- Campaign Coordination workflow

**New Structure:**
```javascript
{
  name: "Marketing Operations Agent",
  pattern: "orchestrator-workers",
  capabilities: [
    "strategic planning",
    "campaign orchestration", 
    "resource allocation",
    "performance monitoring"
  ],
  mcpTools: [
    "marketing-director-prompts",
    "marketing-director-resource",
    "marketing-analytics-aggregator",
    "linear-mcp-server"
  ],
  delegates_to: ["Content Operations", "Campaign Execution", "Social Media Hub"]
}
```

#### B. Content Operations Agent (Evaluator-Optimizer Pattern)
**Combines:**
- Content Strategy Agent
- Copy Writer Agent
- Copy Editor Agent
- SEO Specialist (from Keyword Agent)

**New Structure:**
```javascript
{
  name: "Content Operations Agent",
  pattern: "evaluator-optimizer",
  workflow: {
    generate: "Create initial content",
    evaluate: "Assess quality, SEO, brand alignment",
    optimize: "Iterate until quality threshold met",
    publish: "Deploy across channels"
  },
  mcpTools: [
    "content-strategy-prompts",
    "copy-writer-prompts",
    "copy-editor-prompts",
    "wordpress-mcp-server",
    "seo-research-mcp"
  ]
}
```

#### C. Campaign Execution Agent (Parallelization Pattern)
**Combines:**
- Marketing Campaign Agent
- Email Marketing Agent
- Newsletter Agent

**New Structure:**
```javascript
{
  name: "Campaign Execution Agent",
  pattern: "parallelization",
  parallel_tasks: [
    "email_creation",
    "landing_page_setup",
    "ad_copy_generation",
    "audience_segmentation"
  ],
  mcpTools: [
    "sendgrid-mcp-server",
    "listmonk-mcp-server",
    "marketing-campaign-prompts",
    "shopify-mcp-server"
  ]
}
```

#### D. Social Media Hub (Routing Pattern)
**Combines:**
- Social Media Director Agent
- Facebook Agent
- Instagram Agent
- Pinterest Agent

**New Structure:**
```javascript
{
  name: "Social Media Hub",
  pattern: "routing",
  route_by_platform: {
    facebook: "facebook-specific-logic",
    instagram: "instagram-specific-logic",
    pinterest: "pinterest-specific-logic",
    cross_platform: "unified-scheduling"
  },
  mcpTools: [
    "social-media-director-prompts",
    "facebook-analytics-mcp",
    "pinterest-mcp-server",
    "postiz-mcp-server"
  ]
}
```

### 2. Sales Domain: From 13 to 2 Agents

#### A. Sales Operations Agent (Routing Pattern)
**Combines:**
- Sales Director Agent
- Lead Generation workflow
- Sales Agent base functionality

**New Structure:**
```javascript
{
  name: "Sales Operations Agent",
  pattern: "routing + orchestrator",
  routing_logic: "segment-based",
  capabilities: [
    "lead qualification",
    "opportunity management",
    "pipeline orchestration",
    "sales analytics"
  ],
  mcpTools: [
    "sales-director-prompts",
    "twenty-mcp-server",
    "shopify-mcp-server",
    "stripe-mcp-server"
  ]
}
```

#### B. Sales Specialist Agent (Dynamic Routing)
**Combines ALL segment agents:**
- B2B Sales Agent
- Corporate Sales Agent
- Healthcare Sales Agent
- Hospitality Sales Agent
- Retail Sales Agent
- Residential Sales (derived from others)

**New Structure:**
```javascript
{
  name: "Sales Specialist Agent",
  pattern: "dynamic-routing",
  approach: "Load persona based on customer segment",
  personas: {
    b2b: { style: "consultative", focus: "ROI" },
    corporate: { style: "executive", focus: "brand" },
    healthcare: { style: "compliant", focus: "healing" },
    hospitality: { style: "experiential", focus: "ambiance" },
    retail: { style: "volume", focus: "margins" }
  },
  dynamic_loading: true,
  mcpTools: ["sales-persona-resource", "twenty-mcp-server"]
}
```

### 3. Operations Domain: From 6 to 3 Agents

#### A. Operations Hub
**Combines:**
- Operations Director Agent
- Workflow Automation components

**New Structure:**
```javascript
{
  name: "Operations Hub",
  pattern: "orchestrator-workers",
  domains: ["inventory", "fulfillment", "logistics", "automation"],
  mcpTools: [
    "operations-director-prompts",
    "shopify-mcp-server",
    "medusa-mcp-server",
    "n8n-mcp-server"
  ]
}
```

#### B. Fulfillment Agent
**Combines:**
- Orders Fulfillment Agent
- E-commerce order workflow
- Inventory management

**New Structure:**
```javascript
{
  name: "Fulfillment Agent",
  pattern: "prompt-chaining",
  chain: [
    "verify_inventory",
    "process_payment",
    "generate_shipping",
    "notify_customer"
  ],
  mcpTools: ["shopify-mcp-server", "pictorem-mcp-server", "stripe-mcp-server"]
}
```

#### C. Integration Manager
**Keeps:**
- Integration Management Agent
- System Monitoring Agent functionality

### 4. Analytics Domain: From 4 to 1 Agent

#### Unified Analytics Agent (Parallelization Pattern)
**Combines:**
- Analytics Director Agent
- Data Analytics Agent
- Data Insights Agent
- Performance Analytics

**New Structure:**
```javascript
{
  name: "Unified Analytics Agent",
  pattern: "parallelization + aggregation",
  parallel_sources: [
    "shopify_analytics",
    "marketing_metrics",
    "sales_performance",
    "financial_data"
  ],
  aggregation_logic: "Consolidate into unified dashboards",
  mcpTools: [
    "analytics-director-prompts",
    "kpi-dashboard-mcp-server",
    "business-scorecard-mcp-server",
    "supabase-mcp-server"
  ]
}
```

### 5. Other Domains: Minimal Changes

#### Keep As-Is (Already Optimized):
1. **Business Manager Agent** - Central orchestrator
2. **Customer Experience Director** - Moderate complexity justified
3. **Product Director Agent** - Specialized knowledge required
4. **Technology Director Agent** - Technical oversight needed
5. **Creative Director Agent** - Creative decisions centralized

#### Minor Consolidations:
- **Finance Director + Budget Agents** → Finance Operations Agent
- **Customer Service + Relationship Agents** → Customer Operations Agent

## Implementation Examples

### Example 1: Converting Marketing Agents

**Before: Complex Chain**
```
Business Manager → Marketing Director → Campaign Manager → Email Agent
                                     ↘ Content Agent → Copy Writer
                                                    ↘ Copy Editor
```

**After: Direct Routing**
```
Business Manager → Marketing Operations → [Parallel]
                                          ├─ Content Operations (with quality loop)
                                          └─ Campaign Execution (parallel tasks)
```

### Example 2: Sales Routing Implementation

**Current n8n Workflow:**
```javascript
// Multiple separate workflows for each segment
if (customer.type === 'hospital') {
  $executeWorkflow('healthcare-sales-agent', request);
} else if (customer.type === 'hotel') {
  $executeWorkflow('hospitality-sales-agent', request);
} 
// ... repeated for each segment
```

**Optimized Pattern:**
```javascript
// Single agent with dynamic persona loading
const salesSpecialist = {
  async handleCustomer(customer) {
    // Load appropriate persona
    const segment = await this.classifyCustomer(customer);
    const persona = await this.loadPersona(segment);
    
    // Apply persona-specific approach
    return await this.executeWithPersona(persona, customer);
  },
  
  loadPersona(segment) {
    // Dynamically load behavior patterns
    return {
      greetingStyle: personaTemplates[segment].greeting,
      objectionHandling: personaTemplates[segment].objections,
      closingTechniques: personaTemplates[segment].closing,
      communicationTone: personaTemplates[segment].tone
    };
  }
};
```

### Example 3: Parallel Marketing Execution

**Current: Sequential**
```javascript
// Current workflow executes tasks one by one
const email = await createEmail();
const social = await createSocialPosts();
const landing = await createLandingPage();
```

**Optimized: Parallel**
```javascript
// New pattern executes simultaneously
const campaignAssets = await Promise.all([
  this.createEmail(campaign),
  this.createSocialPosts(campaign),
  this.createLandingPage(campaign),
  this.setupAnalytics(campaign)
]);

// Then coordinate deployment
return await this.coordinateDeployment(campaignAssets);
```

## Migration Strategy

### Phase 1: Non-Breaking Consolidation (Week 1)
1. Create new consolidated agents alongside existing ones
2. Route test traffic to new agents
3. Monitor performance differences
4. Keep fallback to original agents

### Phase 2: Gradual Cutover (Week 2-3)
1. Route increasing percentage to new agents
2. Deactivate redundant agents one by one
3. Update Business Manager routing
4. Maintain audit logs

### Phase 3: Cleanup (Week 4)
1. Archive old workflows
2. Update documentation
3. Remove deprecated MCP connections
4. Optimize remaining agents

## Validation Checklist

For each consolidation:
- [ ] All functionality preserved
- [ ] Response time improved
- [ ] Fewer total LLM calls
- [ ] Simplified maintenance
- [ ] Clear migration path
- [ ] Rollback plan ready

## Expected Outcomes

1. **Agent Reduction**: 58 → ~20 agents (65% reduction)
2. **Workflow Simplification**: 100+ workflows → ~30 workflows
3. **Response Time**: 40-60% faster for multi-step operations
4. **Maintenance**: Single point of update for related functions
5. **Cost**: 30-50% reduction in LLM token usage