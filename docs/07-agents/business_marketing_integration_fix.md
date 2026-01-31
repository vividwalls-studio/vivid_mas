# Business Manager → Marketing Director Integration Fix

## Problem Summary
The current integration between Business Manager and Marketing Director lacks a clear, consistent data payload structure. The Business Manager uses generic AI extraction while the Marketing Director expects specific structured data.

## Current Issues

### 1. Business Manager Tool Configuration (Current)
```javascript
"workflowInputs": {
  "value": {
    "task_type": "={{ $fromAI('task_type', 'description') }}",
    "objectives": "={{ $fromAI('objectives', 'description') }}",
    "budget": "={{ $fromAI('budget', 'description') }}",
    "timeline": "={{ $fromAI('timeline', 'description') }}",
    "context": "={{ $fromAI('context', 'description') }}"
  }
}
```

### 2. Marketing Director Expectations
- Micro audience segments (6 specific types)
- Performance metrics with segment-specific targets
- Channel allocations
- Structured campaign parameters

## Solution: Updated Tool Configuration

### Business Manager Marketing Director Tool (Fixed)
```javascript
{
  "parameters": {
    "description": "Coordinate with Marketing Director for strategic alignment",
    "workflowId": {
      "__rl": true,
      "value": "FmyORnR3mSnCoXMq",
      "mode": "list",
      "cachedResultName": "Marketing Director Agent"
    },
    "workflowInputs": {
      "mappingMode": "defineBelow",
      "value": {
        "message": {
          "id": "={{ $uuid() }}",
          "from": "business-manager-agent",
          "to": "marketing-director-agent",
          "timestamp": "={{ $now.toISO() }}",
          "workflow_execution_id": "={{ $execution.id }}",
          "priority": "={{ $fromAI('priority', 'high, medium, or low based on urgency') }}",
          "requires_ack": true,
          "content": {
            "type": "={{ $fromAI('content_type', 'directive, inquiry, report_request, or approval') }}",
            "data": {
              "directive_type": "={{ $fromAI('directive_type', 'campaign_launch, budget_adjustment, strategy_change, or segment_focus') }}",
              "parameters": {
                "campaign": {
                  "name": "={{ $fromAI('campaign_name', 'name of the marketing campaign') }}",
                  "objectives": "={{ $fromAI('campaign_objectives', 'array of: brand_awareness, lead_generation, sales_conversion') }}",
                  "target_segments": "={{ $fromAI('target_segments', 'array from: hospitality, healthcare, luxury_home, corporate, eco_millennials, interior_designers') }}",
                  "channels": "={{ $fromAI('channels', 'array from: facebook, instagram, pinterest, google_ads, email, linkedin') }}",
                  "timeline": {
                    "start_date": "={{ $fromAI('start_date', 'campaign start date in YYYY-MM-DD format') }}",
                    "end_date": "={{ $fromAI('end_date', 'campaign end date in YYYY-MM-DD format') }}"
                  }
                },
                "budget": {
                  "total_amount": "={{ $fromAI('budget_amount', 'total budget in USD as number') }}",
                  "currency": "USD",
                  "allocation": {
                    "by_channel": "={{ $fromAI('channel_allocation', 'object with channel names as keys and amounts as values') }}",
                    "by_segment": "={{ $fromAI('segment_allocation', 'object with segment names as keys and amounts as values') }}"
                  }
                },
                "performance_targets": {
                  "overall_roas": "={{ $fromAI('target_roas', 'target ROAS as number, default 4.0') }}",
                  "segment_targets": "={{ $fromAI('segment_targets', 'object with segment-specific CAC and ROAS targets') }}"
                }
              },
              "context": {
                "business_objectives": "={{ $fromAI('business_objectives', 'array of current business objectives') }}",
                "urgency": "={{ $fromAI('urgency', 'immediate, high, normal, or low') }}"
              }
            }
          }
        }
      }
    }
  }
}
```

## Marketing Director Webhook Response Handler
The Marketing Director should be configured to:

1. **Parse the structured message**
2. **Validate against the schema**
3. **Send acknowledgment within timeout**
4. **Process based on content type**
5. **Return structured response**

### Example Response Flow
```javascript
// In Marketing Director workflow
const incomingMessage = $json.message;

// Validate message structure
if (!incomingMessage.content || !incomingMessage.content.type) {
  return {
    acknowledgment: {
      message_id: incomingMessage.id,
      status: "NACK",
      reason: "Invalid message structure"
    }
  };
}

// Send ACK
const ack = {
  acknowledgment: {
    message_id: incomingMessage.id,
    from: "marketing-director-agent",
    to: incomingMessage.from,
    timestamp: new Date().toISOString(),
    status: "ACK",
    processing_time_ms: 150
  }
};

// Process based on type
switch (incomingMessage.content.type) {
  case "directive":
    return processDirective(incomingMessage.content.data);
  case "inquiry":
    return processInquiry(incomingMessage.content.data);
  case "report_request":
    return generateReport(incomingMessage.content.data);
  case "approval":
    return processApproval(incomingMessage.content.data);
}
```

## Implementation Steps

1. **Update Business Manager Workflow**
   - Replace the Marketing Director Tool configuration
   - Add message validation logic
   - Implement timeout handling

2. **Update Marketing Director Workflow**
   - Add webhook message parser
   - Implement acknowledgment sender
   - Add response formatter

3. **Add Monitoring**
   - Track message success rates
   - Monitor acknowledgment times
   - Log validation failures

4. **Test Integration**
   - Send test directives
   - Verify acknowledgments
   - Check response structure

## Benefits
- Clear, predictable message structure
- Type-safe communication
- Built-in acknowledgment tracking
- Easier debugging and monitoring
- Supports all marketing use cases

## Next Steps
1. Update both workflows with new configurations
2. Test with sample marketing directives
3. Add error handling for edge cases
4. Document common message patterns
5. Create monitoring dashboard