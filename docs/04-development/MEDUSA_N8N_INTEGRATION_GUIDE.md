# Medusa + n8n AI Agent Integration Guide

## Overview

This guide documents the integration between Medusa workflows and n8n AI agent workflows, enabling powerful AI-enhanced e-commerce automation for the VividWalls Multi-Agent System.

## Architecture

### Components

1. **Medusa Workflows**: Event-driven, durable execution engine for e-commerce operations
2. **n8n AI Agents**: Visual workflow automation with LLM-powered agents
3. **MCP Server**: Model Context Protocol server providing tools for integration
4. **Webhook Handler**: Bidirectional communication system

### Integration Points

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  Medusa         │────▶│  Webhook Handler │────▶│  n8n AI Agents  │
│  Workflows      │◀────│                  │◀────│                 │
└─────────────────┘     └──────────────────┘     └─────────────────┘
         │                                                  │
         │                                                  │
         └──────────────── MCP Server ─────────────────────┘
```

## Implementation

### 1. Medusa Workflow Endpoints

Located in `services/medusa/workflows/workflow-endpoints.ts`:

- **AI Order Processing**: Analyzes orders and applies AI recommendations
- **n8n Integration**: Syncs events and data with n8n workflows
- **Inventory Management**: AI-powered inventory predictions
- **Customer Segmentation**: Dynamic customer analysis

#### Example Usage:

```javascript
// Trigger AI order processing
POST /admin/workflows/ai-order-processing
{
  "orderId": "order_123",
  "customerId": "cus_456"
}

// Sync with n8n
POST /admin/workflows/n8n-sync
{
  "eventType": "order.created",
  "data": { /* order data */ }
}
```

### 2. Enhanced Medusa MCP Server

New tools added to `services/mcp-servers/core/medusa-mcp-server/`:

#### Workflow Execution Tools

- **execute-workflow**: Execute Medusa workflows with optional n8n triggering
- **sync-with-n8n**: Send events/data to n8n agents
- **get-workflow-status**: Check workflow execution status
- **register-n8n-webhook**: Register webhook endpoints

#### Example MCP Tool Usage:

```json
{
  "tool": "execute-workflow",
  "parameters": {
    "workflowType": "ai-order-processing",
    "parameters": {
      "orderId": "order_123",
      "customerId": "cus_456"
    },
    "triggerN8n": true
  }
}
```

### 3. n8n Integration Workflows

Example workflows in `services/n8n/agents/workflows/examples/`:

#### Order Processing Workflow

**File**: `medusa-integration-workflow.json`

**Features**:
- Webhook trigger for Medusa orders
- AI analysis using OpenAI
- Customer segmentation
- Dynamic discount creation
- Callback to Medusa

#### Inventory Management Workflow

**File**: `medusa-inventory-ai-workflow.json`

**Features**:
- Scheduled inventory checks
- AI demand prediction
- Critical stock alerts
- Automatic reorder triggering
- Slack notifications

### 4. Webhook Handler

Located in `services/medusa/webhooks/n8n-webhook-handler.ts`:

#### Features:

- **Webhook Registration**: Dynamic webhook management
- **Event Processing**: Handle n8n webhook callbacks
- **Event Forwarding**: Forward Medusa events to n8n
- **Security**: Signature verification for production

#### Endpoints:

```
POST   /webhooks/n8n         - Receive n8n webhooks
POST   /webhooks/register    - Register new webhook
GET    /webhooks            - List registered webhooks
DELETE /webhooks/:id        - Unregister webhook
POST   /webhooks/trigger    - Trigger test webhook
```

## Configuration

### Environment Variables

```bash
# Medusa Configuration
MEDUSA_BASE_URL=http://localhost:9000
MEDUSA_API_TOKEN=your_api_token

# n8n Configuration
N8N_WEBHOOK_URL=http://localhost:5678/webhook/medusa-event
N8N_WEBHOOK_BASE_URL=http://localhost:5678

# Security
WEBHOOK_SECRET=your_webhook_secret
```

### n8n Webhook Setup

1. Create webhook node in n8n workflow
2. Set path to `medusa-order-webhook` (or custom)
3. Configure authentication if needed
4. Connect to AI agent nodes

### Medusa Event Subscriptions

Events automatically forwarded to n8n:
- `order.placed`
- `order.completed`
- `inventory.item.low_stock`
- `customer.created`

## Usage Examples

### 1. AI-Enhanced Order Processing

```javascript
// When order is placed in Medusa
eventBus.emit("order.placed", orderData);

// Triggers n8n workflow which:
// 1. Analyzes order with AI
// 2. Segments customer
// 3. Creates personalized discount
// 4. Sends results back to Medusa
```

### 2. Inventory Prediction

```javascript
// Scheduled n8n workflow:
// 1. Fetches low stock items via MCP
// 2. AI predicts demand
// 3. Triggers reorder workflows in Medusa
// 4. Alerts team for critical items
```

### 3. Customer Segmentation

```javascript
// Customer makes purchase
// n8n workflow analyzes behavior
// Updates segment in Medusa
// Triggers targeted marketing
```

## Best Practices

### 1. Error Handling

- Implement compensation in Medusa workflows
- Use try-catch in webhook handlers
- Log all webhook communications
- Implement retry logic for failed webhooks

### 2. Performance

- Use async processing for heavy AI tasks
- Batch similar operations
- Cache AI predictions when appropriate
- Monitor webhook response times

### 3. Security

- Always verify webhook signatures in production
- Use environment variables for sensitive data
- Implement rate limiting on webhook endpoints
- Audit webhook registrations regularly

### 4. Monitoring

- Track workflow execution times
- Monitor AI agent response accuracy
- Log all webhook events
- Set up alerts for critical failures

## Troubleshooting

### Common Issues

1. **Webhook Not Triggering**
   - Check webhook URL configuration
   - Verify n8n workflow is active
   - Check network connectivity

2. **MCP Tools Not Working**
   - Verify MCP server is running
   - Check authentication credentials
   - Review tool parameter format

3. **AI Analysis Failing**
   - Check OpenAI API key
   - Verify model availability
   - Review prompt formatting

4. **Event Not Forwarding**
   - Ensure event subscriptions are set up
   - Check N8N_WEBHOOK_URL env var
   - Verify event data structure

### Debug Commands

```bash
# Test webhook connectivity
curl -X POST http://localhost:9000/admin/webhooks/trigger \
  -H "Content-Type: application/json" \
  -d '{"eventType": "test.event", "data": {"test": true}}'

# Check webhook registrations
curl http://localhost:9000/admin/webhooks

# Test MCP server
npm test --prefix services/mcp-servers/core/medusa-mcp-server
```

## Future Enhancements

1. **Advanced AI Features**
   - Multi-model ensemble predictions
   - Real-time demand forecasting
   - Automated pricing optimization

2. **Workflow Orchestration**
   - Complex multi-step workflows
   - Parallel execution optimization
   - Dynamic workflow generation

3. **Integration Extensions**
   - More Medusa event types
   - Custom AI model integration
   - External service webhooks

4. **Monitoring & Analytics**
   - Workflow performance dashboard
   - AI decision tracking
   - ROI measurement tools