# Structured Workflow Implementation Guide

This guide ensures all VividWalls MAS agents handle structured JSON data inputs and outputs for seamless workflow execution.

## Core Principles

### 1. Data Structure Standards

All agent workflows MUST adhere to these standards:

```json
{
  "directive_type": "string - defines the action type",
  "directive_id": "string - unique identifier (dir_YYYYMMDD_XXX)",
  "source": "string - originating agent",
  "target": "string - receiving agent",
  "priority": "enum - critical|high|medium|low",
  "deadline": "ISO 8601 timestamp",
  "specification": {
    // Type-specific structured data
  },
  "coordination": {
    // Cross-agent collaboration requirements
  }
}
```

### 2. Input Validation

Each agent workflow must validate inputs:

```javascript
// n8n Code node for input validation
const requiredFields = ['directive_type', 'directive_id', 'source', 'priority'];
const input = $input.first().json;

for (const field of requiredFields) {
  if (!input[field]) {
    throw new Error(`Missing required field: ${field}`);
  }
}

// Validate directive type
const validDirectives = ['marketing_campaign', 'cx_optimization', 'order_management'];
if (!validDirectives.includes(input.directive_type)) {
  throw new Error(`Invalid directive type: ${input.directive_type}`);
}

return input;
```

### 3. Output Standardization

All agent responses must follow this structure:

```json
{
  "response_type": "string - type of response",
  "response_id": "string - unique response identifier",
  "directive_id": "string - reference to original directive",
  "status": "enum - success|error|in_progress|pending",
  "result": {
    // Agent-specific results
  },
  "metadata": {
    "timestamp": "ISO 8601",
    "processing_time_ms": "number",
    "agent": "string - responding agent name"
  }
}
```

## Workflow Components

### 1. Webhook Triggers

Each director agent needs webhook endpoints:

```json
{
  "business_manager": "/webhook/business-manager",
  "marketing_director": "/webhook/marketing-director",
  "sales_director": "/webhook/sales-director",
  "operations_director": "/webhook/operations-director",
  "cx_director": "/webhook/cx-director",
  "product_director": "/webhook/product-director",
  "finance_director": "/webhook/finance-director",
  "analytics_director": "/webhook/analytics-director",
  "technology_director": "/webhook/technology-director",
  "creative_director": "/webhook/creative-director",
  "social_media_director": "/webhook/social-media-director"
}
```

### 2. MCP Tool Integration

Each workflow must connect appropriate MCP tools:

```javascript
// Example: Marketing Director using Shopify MCP
{
  "parameters": {
    "operation": "executeTool",
    "toolName": "get-products",
    "toolParameters": JSON.stringify({
      "limit": 50,
      "searchTitle": $('previous_node').json.product_search
    })
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

### 3. Error Handling Pattern

All workflows must implement error handling:

```javascript
// Error catch node configuration
{
  "parameters": {
    "errorMessage": "={{ $json.error.message }}",
    "errorType": "={{ $json.error.name }}",
    "additionalFields": {
      "directive_id": "={{ $('Create Directive').json.directive_id }}",
      "agent": "marketing_director",
      "timestamp": "={{ new Date().toISOString() }}"
    }
  },
  "type": "n8n-nodes-base.errorWorkflow",
  "position": [1000, 500]
}
```

## Business Activity Workflows

### 1. Marketing Campaign Launch

**Trigger Path**: Stakeholder → Business Manager → Marketing Director

**Data Flow**:
```
1. Stakeholder Input (via webhook/UI)
   ↓
2. Business Manager Transformation
   ↓
3. Marketing Director Execution
   ↓
4. Sub-agent Delegation (Email, Social, Creative)
   ↓
5. Consolidated Response
```

**Key Integration Points**:
- Shopify MCP for product data
- SendGrid MCP for email campaigns
- WordPress MCP for content
- Linear MCP for task tracking

### 2. Customer Experience Optimization

**Trigger Path**: Stakeholder → Business Manager → CX Director

**Data Flow**:
```
1. Optimization Request
   ↓
2. Current Metrics Retrieval (KPI Dashboard MCP)
   ↓
3. CX Director Planning
   ↓
4. Multi-agent Coordination (Service, Lifecycle, Satisfaction)
   ↓
5. Implementation Tracking
```

**Key Integration Points**:
- Twenty CRM MCP for customer data
- Shopify MCP for order history
- Listmonk MCP for communications
- Supabase MCP for analytics

### 3. Order Management Crisis

**Trigger Path**: Stakeholder → Business Manager → Operations Director

**Data Flow**:
```
1. Crisis Alert
   ↓
2. Order Analysis (Shopify MCP)
   ↓
3. Operations Director Triage
   ↓
4. Multi-director Coordination (CX, Finance)
   ↓
5. Resolution Execution
```

**Key Integration Points**:
- Shopify MCP for order management
- Pictorem MCP for fulfillment
- SendGrid MCP for customer notifications
- Stripe MCP for refunds

### 4. Supply Chain Optimization

**Trigger Path**: Stakeholder → Business Manager → Operations Director

**Data Flow**:
```
1. Optimization Request
   ↓
2. Current State Analysis
   ↓
3. Operations Planning
   ↓
4. Vendor Coordination
   ↓
5. Implementation Monitoring
```

**Key Integration Points**:
- Medusa MCP for inventory
- Vendor Management MCP
- Financial Analytics MCP
- Linear MCP for project tracking

### 5. E-commerce Shop Updates

**Trigger Path**: Stakeholder → Business Manager → Multi-Director

**Data Flow**:
```
1. Shop Update Request
   ↓
2. Business Manager Coordination Matrix
   ↓
3. Parallel Director Execution:
   - Product Director: Catalog
   - Technology Director: Implementation
   - Marketing Director: Content
   ↓
4. Integration Testing
   ↓
5. Launch Coordination
```

**Key Integration Points**:

- Shopify MCP for shop management
- WordPress MCP for content
- Pictorem MCP for product images
- Neo4j MCP for knowledge updates

## Implementation Checklist

### Phase 1: Core Infrastructure

- [ ] Deploy all director agent workflows
- [ ] Configure webhook endpoints
- [ ] Set up MCP credentials
- [ ] Test basic connectivity

### Phase 2: Data Validation

- [ ] Implement input validation nodes
- [ ] Add output standardization
- [ ] Configure error handling
- [ ] Test data flow integrity

### Phase 3: Integration Testing

- [ ] Test stakeholder → Business Manager flow
- [ ] Test Business Manager → Director delegation
- [ ] Test Director → Sub-agent coordination
- [ ] Test cross-director collaboration

### Phase 4: Monitoring Setup

- [ ] Configure execution logging
- [ ] Set up performance metrics
- [ ] Implement alert thresholds
- [ ] Create audit trails

## Testing Scenarios

### 1. Marketing Campaign Test

```bash
curl -X POST https://n8n.vividwalls.blog/webhook/business-manager-marketing-campaign \
  -H "Content-Type: application/json" \
  -d '{
    "directive_type": "marketing_campaign",
    "request_id": "test_001",
    "stakeholder": {"id": "kingler_bercy"},
    "campaign_details": {
      "name": "Test Spring Campaign",
      "budget": 5000,
      "timeline": {
        "start_date": "2025-03-01",
        "end_date": "2025-04-30"
      },
      "targets": {
        "revenue": 50000,
        "new_customers": 200
      }
    }
  }'
```

### 2. CX Optimization Test

```bash
curl -X POST https://n8n.vividwalls.blog/webhook/business-manager-cx-optimization \
  -H "Content-Type: application/json" \
  -d '{
    "directive_type": "customer_experience_optimization",
    "request_id": "test_002",
    "optimization_goals": {
      "primary_metric": "customer_satisfaction_score",
      "target_improvement": 0.15,
      "budget": 3000,
      "timeline_days": 60
    }
  }'
```

## Monitoring and Maintenance

### 1. Health Checks

Each workflow should expose health endpoints:

```javascript
// Health check node
{
  "parameters": {
    "path": "health",
    "options": {
      "responseCode": 200
    }
  },
  "type": "n8n-nodes-base.webhook",
  "webhookId": "agent-health-check"
}
```

### 2. Performance Metrics

Track these KPIs:

- Average response time per agent
- Success rate per directive type
- MCP tool availability
- Error frequency and types

### 3. Audit Requirements

Log all:

- Directive receipts
- Agent delegations
- MCP tool invocations
- Error occurrences
- Response completions

## Troubleshooting Guide

### Common Issues

1. **"MCP tool not responding"**
   - Check MCP server status
   - Verify credentials
   - Test connectivity

2. **"Invalid directive format"**
   - Validate JSON structure
   - Check required fields
   - Verify enum values

3. **"Delegation timeout"**
   - Check target agent status
   - Verify webhook configuration
   - Review execution logs

4. **"Data transformation error"**
   - Debug Code node logic
   - Check input data types
   - Validate field mappings

## Best Practices

1. **Always validate inputs** before processing
2. **Use structured logging** for debugging
3. **Implement retry logic** for transient failures
4. **Monitor MCP availability** proactively
5. **Document data transformations** clearly
6. **Test edge cases** thoroughly
7. **Version control** workflow changes
8. **Maintain backward compatibility** in updates