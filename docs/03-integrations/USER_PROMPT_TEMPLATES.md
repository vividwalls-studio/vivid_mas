# VividWalls MAS User Prompt Templates

This document provides ready-to-use prompt templates for testing the VividWalls Multi-Agent System workflows. Each template includes the proper JSON payload structure for different business activities.

## Table of Contents
1. [Marketing Campaign Launch](#1-marketing-campaign-launch)
2. [Customer Experience Optimization](#2-customer-experience-optimization)
3. [Order Management Crisis](#3-order-management-crisis)
4. [Supply Chain Optimization](#4-supply-chain-optimization)
5. [E-commerce Shop Update](#5-e-commerce-shop-update)

---

## 1. Marketing Campaign Launch

### User Prompt Template:
```
Launch a marketing campaign for our Spring Collection 2025 featuring botanical art prints. 
Budget: $5,000
Timeline: March 1 - April 30, 2025
Targets: 200 new customers, $50,000 revenue
Focus on email, social media, content marketing, and paid ads.
```

### Structured Payload for Business Manager:
```json
{
  "directive_type": "marketing_campaign",
  "request_id": "req_20250117_001",
  "timestamp": "2025-01-17T10:00:00Z",
  "stakeholder": {
    "id": "kingler_bercy",
    "role": "owner"
  },
  "campaign_details": {
    "name": "Spring Collection 2025",
    "objective": "Launch new botanical art collection",
    "budget": 5000,
    "timeline": {
      "start_date": "2025-03-01",
      "end_date": "2025-04-30"
    },
    "targets": {
      "revenue": 50000,
      "new_customers": 200,
      "engagement_rate": 0.05
    },
    "channels": ["email", "social_media", "content_marketing", "paid_ads"]
  }
}
```

### Expected Business Manager Actions:
1. Transform request into marketing_campaign_execution directive
2. Route to Marketing Director with budget allocation
3. Set performance targets and creative requirements
4. Define coordination with Creative and Social Media Directors

---

## 2. Customer Experience Optimization

### User Prompt Template:
```
I want to improve our customer satisfaction scores by 15% over the next 60 days.
Focus on reducing response times, adding personalization, and improving post-purchase support.
Budget: $3,000 for technology and process improvements.
```

### Structured Payload for Business Manager:
```json
{
  "directive_type": "customer_experience_optimization",
  "request_id": "req_20250117_002",
  "timestamp": "2025-01-17T11:00:00Z",
  "stakeholder": {
    "id": "kingler_bercy",
    "role": "owner"
  },
  "optimization_goals": {
    "primary_metric": "customer_satisfaction_score",
    "target_improvement": 0.15,
    "focus_areas": ["response_time", "personalization", "post_purchase_support"],
    "budget": 3000,
    "timeline_days": 60
  }
}
```

### Expected Business Manager Actions:
1. Analyze current CX metrics vs targets
2. Create cx_optimization_initiative directive
3. Route to Customer Experience Director
4. Set improvement areas and resource allocation
5. Request coordination with Technology and Operations

---

## 3. Order Management Crisis

### User Prompt Template:
```
URGENT: We have 45 orders delayed due to supplier stock shortage.
Affected customers include 12 VIPs. Total order value: $15,750.
Need immediate action to expedite fulfillment and communicate with customers.
```

### Structured Payload for Business Manager:
```json
{
  "directive_type": "order_management",
  "request_id": "req_20250117_003",
  "timestamp": "2025-01-17T12:00:00Z",
  "stakeholder": {
    "id": "kingler_bercy",
    "role": "owner"
  },
  "order_concerns": {
    "issue_type": "fulfillment_delays",
    "affected_orders": 45,
    "priority": "urgent",
    "customer_impact": "high",
    "required_action": "expedite_and_communicate"
  }
}
```

### Expected Business Manager Actions:
1. Create order_fulfillment_crisis directive
2. Set priority to "critical"
3. Route to Operations Director
4. Include customer segment breakdown
5. Coordinate with CX Director for communications
6. Request Finance approval for expedited shipping

---

## 4. Supply Chain Optimization

### User Prompt Template:
```
Optimize our supply chain to reduce costs by 15% over the next 3 months.
Maintain quality standards and delivery times.
Consider volume discounts, new suppliers, and shipping optimization.
```

### Structured Payload for Business Manager:
```json
{
  "directive_type": "supply_chain_optimization",
  "request_id": "req_20250117_004",
  "timestamp": "2025-01-17T13:00:00Z",
  "stakeholder": {
    "id": "kingler_bercy",
    "role": "owner"
  },
  "optimization_request": {
    "focus": "cost_reduction",
    "target_savings": 0.15,
    "constraints": ["maintain_quality", "no_delivery_delays"],
    "timeline_months": 3
  }
}
```

### Expected Business Manager Actions:
1. Analyze current supply chain metrics
2. Create supply_chain_optimization directive
3. Route to Operations Director
4. Set optimization strategies and constraints
5. Request collaboration with Finance and Product Directors

---

## 5. E-commerce Shop Update

### User Prompt Template:
```
Update our online shop for spring season by March 1st.
Requirements: New homepage, add botanical/abstract/coastal collections, 
optimize checkout, improve mobile experience.
Budget: $8,000
```

### Structured Payload for Business Manager:
```json
{
  "directive_type": "ecommerce_shop_update",
  "request_id": "req_20250117_005",
  "timestamp": "2025-01-17T14:00:00Z",
  "stakeholder": {
    "id": "kingler_bercy",
    "role": "owner"
  },
  "shop_updates": {
    "type": "seasonal_refresh",
    "requirements": [
      "update_homepage",
      "add_new_collections",
      "optimize_checkout",
      "improve_mobile_experience"
    ],
    "launch_date": "2025-03-01",
    "budget": 8000
  }
}
```

### Expected Business Manager Actions:
1. Create ecommerce_shop_overhaul directive
2. Split between Product, Technology, and Marketing Directors
3. Allocate budget across directors
4. Set specific requirements for each area
5. Define coordination matrix for collaboration

---

## Testing Workflow Execution

### 1. Direct Webhook Test
```bash
# Test Marketing Campaign
curl -X POST https://n8n.vividwalls.blog/webhook/business-manager-marketing-campaign \
  -H "Content-Type: application/json" \
  -d @marketing_campaign_payload.json
```

### 2. Via n8n Execute Workflow
In n8n, use the "Execute Workflow" node with:
- Source: Current Workflow
- Workflow: Business Manager Agent
- Input Data: Use the structured payload

### 3. Chat Interface Test
When using the chat interface, paste the user prompt template. The Business Manager should:
1. Parse the natural language request
2. Generate the structured directive
3. Route to appropriate director(s)
4. Return execution plan

## Validation Checklist

Before sending any request:
- [ ] Verify all required fields are present
- [ ] Check date formats (ISO 8601)
- [ ] Confirm budget is a number (not string)
- [ ] Validate priority levels (critical/high/medium/low)
- [ ] Ensure IDs follow format conventions

## Common Patterns

### Multi-Director Coordination
Some requests require multiple directors:
- **Shop Update**: Product + Technology + Marketing
- **Crisis Management**: Operations + Customer Experience + Finance
- **Campaign Launch**: Marketing + Creative + Social Media

### Escalation Triggers
Automatic escalation to Business Manager when:
- Budget overrun > 10%
- Timeline delay > 20%
- Customer satisfaction drop > 10%
- Critical system failures

### Response Expectations
All directors should respond with:
- Acknowledgment of directive
- Execution plan with phases
- Resource allocation
- Sub-agent assignments
- Success metrics
- Timeline/milestones