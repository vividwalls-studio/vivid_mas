# VividWalls MAS Data Flow Quick Reference

## 🎯 Core Data Flow Pattern

```
Stakeholder Request (JSON)
    ↓
Business Manager Agent (Transform & Route)
    ↓
Director Agent (Plan & Delegate)
    ↓
Specialized Agents (Execute)
    ↓
Consolidated Response (JSON)
```

## 📊 Standard JSON Structures

### Input from Stakeholder
```json
{
  "directive_type": "marketing_campaign|cx_optimization|order_management|supply_chain|shop_update",
  "request_id": "req_YYYYMMDD_XXX",
  "timestamp": "ISO 8601",
  "stakeholder": {
    "id": "kingler_bercy",
    "role": "owner"
  },
  "[activity]_details": {
    // Activity-specific data
  }
}
```

### Business Manager to Director
```json
{
  "directive_type": "[activity]_execution",
  "directive_id": "dir_YYYYMMDD_XXX",
  "source": "business_manager",
  "target": "[director]_director",
  "priority": "critical|high|medium|low",
  "deadline": "ISO 8601",
  "[activity]_specification": {
    // Detailed requirements
  },
  "coordination_requirements": {
    "collaborate_with": ["other_directors"],
    "reporting_frequency": "immediate|daily|weekly"
  }
}
```

### Director Response
```json
{
  "response_type": "[activity]_plan",
  "response_id": "resp_YYYYMMDD_XXX",
  "directive_id": "dir_YYYYMMDD_XXX",
  "status": "success|in_progress|error",
  "execution_plan": {
    // Detailed plan
  },
  "sub_agent_assignments": {
    "[agent_name]": {
      "tasks": ["task_list"],
      "budget": 0
    }
  }
}
```

## 🔄 Activity-Specific Flows

### 1️⃣ Marketing Campaign
```
Stakeholder → Business Manager
  Fields: name, budget, timeline, targets, channels
    ↓
Business Manager → Marketing Director  
  Fields: budget_allocation, performance_targets, creative_requirements
    ↓
Marketing Director → Sub-agents
  - Email Marketing Agent (templates, segments)
  - Social Media Director (content, schedule)
  - Creative Director (assets, brand)
```

### 2️⃣ Customer Experience
```
Stakeholder → Business Manager
  Fields: primary_metric, target_improvement, focus_areas
    ↓
Business Manager → CX Director
  Fields: current_metrics, target_metrics, improvement_areas
    ↓
CX Director → Sub-agents
  - Customer Service Agent (chatbot, FAQs)
  - Customer Lifecycle Agent (segmentation, automation)
  - Satisfaction Monitor Agent (tracking, insights)
```

### 3️⃣ Order Management
```
Stakeholder → Business Manager
  Fields: issue_type, affected_orders, priority
    ↓
Business Manager → Operations Director
  Fields: crisis_details, required_actions, coordination_needs
    ↓
Operations Director → Sub-agents
  - Fulfillment Agent (expedite shipping)
  - Inventory Management Agent (stock levels)
  - Shopify Agent (order updates)
```

### 4️⃣ Supply Chain
```
Stakeholder → Business Manager
  Fields: focus, target_savings, constraints
    ↓
Business Manager → Operations Director
  Fields: optimization_parameters, analysis_requirements
    ↓
Operations Director → Sub-agents
  - Supply Chain Agent (vendor analysis)
  - Logistics Agent (route optimization)
  - Quality Control Agent (standards)
```

### 5️⃣ E-commerce Shop
```
Stakeholder → Business Manager
  Fields: type, requirements, launch_date, budget
    ↓
Business Manager → Multiple Directors
  - Product Director (catalog, merchandising)
  - Technology Director (implementation, testing)
  - Marketing Director (content, SEO)
    ↓
Coordinated Execution
```

## 🛠️ MCP Tool Usage by Activity

| Activity | Primary MCPs | Data Retrieved/Modified |
|----------|--------------|------------------------|
| Marketing Campaign | Shopify, SendGrid, WordPress | Products, Customers, Content |
| Customer Experience | Twenty CRM, KPI Dashboard | Customer data, Metrics |
| Order Management | Shopify, Pictorem, SendGrid | Orders, Inventory, Notifications |
| Supply Chain | Medusa, Vendor Management | Suppliers, Costs, Lead times |
| Shop Update | Shopify, WordPress, Pictorem | Products, Content, Images |

## 🚨 Critical Fields Never to Miss

### All Directives
- `directive_type` - Determines routing
- `directive_id` - Enables tracking
- `priority` - Sets execution order
- `deadline` - Ensures timely completion

### Financial Operations
- `budget` - Total allocation
- `budget_allocation` - Breakdown by category
- `roi_target` - Expected return

### Performance Metrics
- `current_[metric]` - Baseline measurement
- `target_[metric]` - Goal to achieve
- `timeline` - Achievement deadline

## 📝 Quick Validation Checklist

Before sending any directive:
- [ ] All required fields present?
- [ ] IDs follow format: `type_YYYYMMDD_XXX`?
- [ ] Timestamps in ISO 8601?
- [ ] Money values in USD (number type)?
- [ ] Percentages as decimals (0.15 = 15%)?
- [ ] Arrays properly formatted?
- [ ] Nested objects complete?

## 🔍 Debugging Tips

1. **Missing Required Field**: Check field names match exactly (case-sensitive)
2. **Invalid Format**: Verify date/time strings are ISO 8601
3. **Type Mismatch**: Ensure numbers aren't quoted as strings
4. **Routing Failure**: Confirm target agent name matches exactly
5. **MCP Error**: Check tool name and parameters match MCP documentation

## 📡 Webhook Endpoints

```
Production Base: https://n8n.vividwalls.blog/webhook/

Marketing Campaign: business-manager-marketing-campaign
CX Optimization: business-manager-cx-optimization  
Order Management: business-manager-order-crisis
Supply Chain: business-manager-supply-chain
Shop Update: business-manager-shop-update
```

## 🎬 Quick Test Commands

```bash
# Test Marketing Campaign
curl -X POST https://n8n.vividwalls.blog/webhook/business-manager-marketing-campaign \
  -H "Content-Type: application/json" \
  -d @marketing_campaign_test.json

# Test CX Optimization  
curl -X POST https://n8n.vividwalls.blog/webhook/business-manager-cx-optimization \
  -H "Content-Type: application/json" \
  -d @cx_optimization_test.json
```

---
*Keep this reference handy for quick troubleshooting and validation!*