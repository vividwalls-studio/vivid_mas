# Webhook Naming Convention Audit Report

## Summary
Analysis of agent webhook naming conventions across the VividWalls MAS system shows **INCONSISTENT** naming patterns that need standardization.

## Expected Pattern (From Frontend Code)
The frontend expects semantic role-based webhook names following this pattern:
- **Format**: `/webhook/{agent-name}-agent` or `/{agent-name}-agent`
- **Examples**: 
  - `/webhook/marketing-director-agent`
  - `/webhook/sales-director-agent`
  - `/webhook/business-manager-agent`

## Current State Analysis

### ✅ Correctly Named Agents (Following Semantic Pattern)
These agents follow the expected `{role}-agent` pattern:

**Director Level:**
- `/marketing-director-agent` ✅
- `/customer-experience-director-agent` ✅
- `/creative-director-agent` ✅
- `/product-director-agent` ✅
- `/data-analytics-agent` ✅

**Marketing Agents:**
- `/campaign-agent` ✅
- `/content-strategy-agent` ✅
- `/copy-editor-agent` ✅
- `/marketing-research-agent` ✅

**Social Media:**
- `/instagram-subagent` ✅

### ❌ Incorrectly Named Agents (Need Fixing)
These agents use the `-approval` suffix instead of `-agent`:

**Director Level:**
- `analyticsdirector_workflow`: `/webhook/analyticsdirector-approval` ❌
  - **Should be**: `/webhook/analytics-director-agent`
- `salesdirector_workflow`: `/webhook/salesdirector-approval` ❌
  - **Should be**: `/webhook/sales-director-agent`

**Finance Department:**
- `accounting_workflow`: `/webhook/accounting-approval` ❌
  - **Should be**: `/webhook/accounting-agent`
- `budgeting_workflow`: `/webhook/budgeting-approval` ❌
  - **Should be**: `/webhook/budgeting-agent`
- `financialplanning_workflow`: `/webhook/financialplanning-approval` ❌
  - **Should be**: `/webhook/financial-planning-agent`

**Sales Department:**
- `accountmanagement_workflow`: `/webhook/accountmanagement-approval` ❌
  - **Should be**: `/webhook/account-management-agent`
- `corporatesales_workflow`: `/webhook/corporatesales-approval` ❌
  - **Should be**: `/webhook/corporate-sales-agent`
- `educationalsales_workflow`: `/webhook/educationalsales-approval` ❌
  - **Should be**: `/webhook/educational-sales-agent`
- `governmentsales_workflow`: `/webhook/governmentsales-approval` ❌
  - **Should be**: `/webhook/government-sales-agent`
- `healthcaresales_workflow`: `/webhook/healthcaresales-approval` ❌
  - **Should be**: `/webhook/healthcare-sales-agent`
- `hospitalitysales_workflow`: `/webhook/hospitalitysales-approval` ❌
  - **Should be**: `/webhook/hospitality-sales-agent`
- `leadgeneration_workflow`: `/webhook/leadgeneration-approval` ❌
  - **Should be**: `/webhook/lead-generation-agent`
- `partnershipdevelopment_workflow`: `/webhook/partnershipdevelopment-approval` ❌
  - **Should be**: `/webhook/partnership-development-agent`
- `realestatesales_workflow`: `/webhook/realestatesales-approval` ❌
  - **Should be**: `/webhook/real-estate-sales-agent`
- `residentialsales_workflow`: `/webhook/residentialsales-approval` ❌
  - **Should be**: `/webhook/residential-sales-agent`
- `retailsales_workflow`: `/webhook/retailsales-approval` ❌
  - **Should be**: `/webhook/retail-sales-agent`
- `salesanalytics_workflow`: `/webhook/salesanalytics-approval` ❌
  - **Should be**: `/webhook/sales-analytics-agent`

**Customer Experience:**
- `customerfeedback_workflow`: `/webhook/customerfeedback-approval` ❌
  - **Should be**: `/webhook/customer-feedback-agent`
- `customerservice_workflow`: `/webhook/customerservice-approval` ❌
  - **Should be**: `/webhook/customer-service-agent`
- `customersuccess_workflow`: `/webhook/customersuccess-approval` ❌
  - **Should be**: `/webhook/customer-success-agent`
- `livechat_workflow`: `/webhook/livechat-approval` ❌
  - **Should be**: `/webhook/live-chat-agent`
- `supportticket_workflow`: `/webhook/supportticket-approval` ❌
  - **Should be**: `/webhook/support-ticket-agent`

**Operations:**
- `inventorymanagement_workflow`: `/webhook/inventorymanagement-approval` ❌
  - **Should be**: `/webhook/inventory-management-agent`
- `logistics_workflow`: `/webhook/logistics-approval` ❌
  - **Should be**: `/webhook/logistics-agent`
- `qualitycontrol_workflow`: `/webhook/qualitycontrol-approval` ❌
  - **Should be**: `/webhook/quality-control-agent`
- `supplychain_workflow`: `/webhook/supplychain-approval` ❌
  - **Should be**: `/webhook/supply-chain-agent`
- `vendormanagement_workflow`: `/webhook/vendormanagement-approval` ❌
  - **Should be**: `/webhook/vendor-management-agent`

**Product:**
- `catalogmanagement_workflow`: `/webhook/catalogmanagement-approval` ❌
  - **Should be**: `/webhook/catalog-management-agent`
- `productanalytics_workflow`: `/webhook/productanalytics-approval` ❌
  - **Should be**: `/webhook/product-analytics-agent`
- `productdevelopment_workflow`: `/webhook/productdevelopment-approval` ❌
  - **Should be**: `/webhook/product-development-agent`
- `productresearch_workflow`: `/webhook/productresearch-approval` ❌
  - **Should be**: `/webhook/product-research-agent`

**Marketing:**
- `copywriter_workflow`: `/webhook/copywriter-approval` ❌
  - **Should be**: `/webhook/copywriter-agent`
- `emailmarketing_workflow`: `/webhook/emailmarketing-approval` ❌
  - **Should be**: `/webhook/email-marketing-agent`
- `keyword_workflow`: `/webhook/keyword-approval` ❌
  - **Should be**: `/webhook/keyword-agent`
- `newsletter_workflow`: `/webhook/newsletter-approval` ❌
  - **Should be**: `/webhook/newsletter-agent`

**Social Media:**
- `linkedin_workflow`: `/webhook/linkedin-approval` ❌
  - **Should be**: `/webhook/linkedin-agent`
- `pinterest_workflow`: `/webhook/pinterest-approval` ❌
  - **Should be**: `/webhook/pinterest-agent`
- `tiktok_workflow`: `/webhook/tiktok-approval` ❌
  - **Should be**: `/webhook/tiktok-agent`
- `twitter_workflow`: `/webhook/twitter-approval` ❌
  - **Should be**: `/webhook/twitter-agent`
- `youtube_workflow`: `/webhook/youtube-approval` ❌
  - **Should be**: `/webhook/youtube-agent`

### 🔧 Special Cases (Need Review)
- `Campaign Manager Agent Strategic`: `/webhook/campaign-manager-agent---strategic-webhook`
  - **Should be**: `/webhook/campaign-manager-agent`
- `campaign_finance_budget_agent`: `campaign-finance-webhook` (missing /webhook prefix)
  - **Should be**: `/webhook/campaign-finance-agent`
- `keyword-agent-workflow`: `/webhook/keyword-webhook`
  - **Should be**: `/webhook/keyword-agent`
- `product-director-workflow`: `/webhook/product-director-webhook`
  - **Should be**: `/webhook/product-director-agent`
- `facebook_marketing_knowledge_gatherer_agent`: `/webhook/facebook-marketing-knowledge-gatherer-agent-webhook`
  - **Should be**: `/webhook/facebook-marketing-agent`

### 📋 Integration Webhooks (OK as-is)
These are not agent webhooks and can keep their current naming:
- `supabase-lead-created`
- `/webhook/twenty-to-supabase-lead-sync-webhook`
- `twenty-lead-sync`

## Statistics
- **Total Agent Workflows**: 58
- **Correctly Named**: 10 (17%)
- **Need Fixing**: 48 (83%)

## Frontend-Backend Alignment Issues

The frontend code expects webhooks in this format:
```typescript
// From webhook.service.ts
const webhookId = `${agentName.toLowerCase().replace(/\s+/g, '-')}-agent`
// Example: "Marketing Director" → "marketing-director-agent"
```

Current misalignments will cause:
1. **404 errors** when frontend tries to call agents with `-approval` suffix
2. **Failed agent executions** from the dashboard
3. **Broken real-time updates** via SSE

## Recommendations

### Immediate Actions Required
1. **Standardize all webhook paths** to use `-agent` suffix instead of `-approval`
2. **Add hyphenation** for multi-word agent names (e.g., `salesanalytics` → `sales-analytics`)
3. **Ensure all paths start with `/webhook/`** prefix
4. **Update n8n workflows** to match the new naming convention

### Naming Convention Standard
```
/webhook/{department}-{role}-agent

Examples:
/webhook/sales-director-agent
/webhook/marketing-research-agent
/webhook/finance-accounting-agent
/webhook/customer-service-agent
```

### Migration Script Needed
A script should be created to:
1. Update all workflow JSON files with correct webhook paths
2. Validate naming consistency
3. Generate updated webhook documentation
4. Test frontend-backend connectivity

## Impact on Frontend
The frontend components that will be affected by fixing these names:
- `frontend-integration/lib/services/webhook.service.ts`
- `frontend-integration/lib/hooks/useAgentWebhooks.ts`
- `frontend-integration/components/dashboard/AgentDashboardWithWebhooks.tsx`
- All API route handlers in `frontend-integration/app/api/agents/`

## Conclusion
**83% of agent webhooks do not follow the semantic role-based naming convention** expected by the frontend. This misalignment will cause the frontend dashboard to fail when attempting to execute most agents. Immediate standardization is required for proper system functionality.