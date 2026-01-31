# Business Manager → Marketing Director Payload Schema

## Overview
This document defines the standardized data payload structure for communication between the Business Manager Agent and Marketing Director Agent in the VividWalls MAS.

## Message Envelope
All messages must follow the standard acknowledgment protocol with this base structure:

```json
{
  "message": {
    "id": "uuid-v4",
    "from": "business-manager-agent",
    "to": "marketing-director-agent",
    "timestamp": "ISO-8601",
    "workflow_execution_id": "n8n-execution-id",
    "correlation_id": "original-request-id",
    "priority": "high|medium|low",
    "requires_ack": true,
    "content": {
      "type": "directive|inquiry|report_request|approval",
      "data": {} // Specific payload based on type
    }
  }
}
```

## Content Types & Payloads

### 1. Marketing Directive (type: "directive")
Used for strategic instructions and campaign initiatives.

```json
{
  "type": "directive",
  "data": {
    "directive_type": "campaign_launch|budget_adjustment|strategy_change|segment_focus",
    "priority": "urgent|high|normal|low",
    "parameters": {
      "campaign": {
        "name": "string",
        "objectives": ["brand_awareness", "lead_generation", "sales_conversion"],
        "target_segments": ["hospitality", "healthcare", "luxury_home", "corporate", "eco_millennials", "interior_designers"],
        "channels": ["facebook", "instagram", "pinterest", "google_ads", "email", "linkedin"],
        "timeline": {
          "start_date": "YYYY-MM-DD",
          "end_date": "YYYY-MM-DD",
          "milestones": []
        }
      },
      "budget": {
        "total_amount": 0,
        "currency": "USD",
        "allocation": {
          "by_channel": {},
          "by_segment": {},
          "by_objective": {}
        },
        "constraints": []
      },
      "performance_targets": {
        "overall_roas": 4.0,
        "segment_targets": {
          "hospitality": {"cac": 150, "roas": 3.0},
          "healthcare": {"cac": 100, "roas": 2.5},
          "luxury_home": {"cac": 75, "roas": 2.5},
          "corporate": {"cac": 200, "roas": 3.0},
          "eco_millennials": {"cac": 25, "roas": 2.0},
          "interior_designers": {"cac": 50, "roas": 4.0}
        }
      }
    },
    "context": {
      "business_objectives": [],
      "market_conditions": {},
      "competitive_landscape": {}
    }
  }
}
```

### 2. Performance Inquiry (type: "inquiry")
Used to request specific marketing performance data.

```json
{
  "type": "inquiry",
  "data": {
    "inquiry_type": "performance_metrics|campaign_status|segment_analysis|channel_effectiveness",
    "parameters": {
      "metrics": ["cac", "roas", "ltv", "conversion_rate", "engagement_rate"],
      "segments": ["all"] | ["specific_segment_ids"],
      "channels": ["all"] | ["specific_channels"],
      "date_range": {
        "start": "YYYY-MM-DD",
        "end": "YYYY-MM-DD"
      },
      "comparison_period": "previous_period|year_over_year|custom",
      "granularity": "daily|weekly|monthly"
    },
    "output_format": "summary|detailed|dashboard"
  }
}
```

### 3. Report Request (type: "report_request")
Used to request formal marketing reports.

```json
{
  "type": "report_request",
  "data": {
    "report_type": "executive_summary|campaign_analysis|roi_report|competitive_analysis",
    "parameters": {
      "period": "daily|weekly|monthly|quarterly",
      "include_sections": [
        "executive_summary",
        "segment_performance",
        "channel_analysis",
        "budget_utilization",
        "recommendations"
      ],
      "format": "pdf|html|json",
      "distribution": ["stakeholder_email"],
      "urgency": "immediate|scheduled"
    }
  }
}
```

### 4. Budget/Strategy Approval (type: "approval")
Used for approving or modifying marketing proposals.

```json
{
  "type": "approval",
  "data": {
    "approval_type": "budget|campaign|strategy|creative",
    "reference_id": "proposal-uuid",
    "decision": "approved|rejected|modify",
    "parameters": {
      "approved_amount": 0,
      "conditions": [],
      "modifications": {},
      "feedback": "string"
    }
  }
}
```

## Response Format

Marketing Director responses should follow this structure:

```json
{
  "response": {
    "to_message_id": "original-message-uuid",
    "status": "success|partial|failure",
    "data": {
      // Response data based on request type
    },
    "metadata": {
      "processing_time_ms": 0,
      "data_freshness": "ISO-8601",
      "confidence_level": 0.95
    },
    "errors": [] // If any
  }
}
```

## Validation Rules

1. **Required Fields**: All messages must include type and data
2. **Segment Values**: Must be from the predefined list
3. **Budget Amounts**: Must be positive numbers with 2 decimal places
4. **Dates**: Must be in ISO-8601 format
5. **Channel Names**: Must match predefined channel identifiers

## Error Handling

### Common Error Codes
- `MD001`: Invalid segment identifier
- `MD002`: Budget exceeds approved limits
- `MD003`: Invalid date range
- `MD004`: Missing required parameters
- `MD005`: Channel not available

## Implementation Notes

1. **AI Parameter Extraction**: Update Business Manager's `$fromAI()` calls to extract structured data matching this schema
2. **Validation Layer**: Add schema validation before sending messages
3. **Type Safety**: Implement TypeScript interfaces for all payload types
4. **Monitoring**: Track message success rates and validation failures

## Example Usage

### Business Manager Sending Campaign Directive
```javascript
const message = {
  message: {
    id: generateUUID(),
    from: "business-manager-agent",
    to: "marketing-director-agent",
    timestamp: new Date().toISOString(),
    priority: "high",
    requires_ack: true,
    content: {
      type: "directive",
      data: {
        directive_type: "campaign_launch",
        priority: "high",
        parameters: {
          campaign: {
            name: "Q1 Luxury Segment Push",
            objectives: ["sales_conversion", "brand_awareness"],
            target_segments: ["luxury_home", "interior_designers"],
            channels: ["instagram", "pinterest"],
            timeline: {
              start_date: "2025-02-01",
              end_date: "2025-03-31"
            }
          },
          budget: {
            total_amount: 15000,
            currency: "USD",
            allocation: {
              by_channel: {
                "instagram": 10000,
                "pinterest": 5000
              },
              by_segment: {
                "luxury_home": 10000,
                "interior_designers": 5000
              }
            }
          },
          performance_targets: {
            overall_roas: 4.0,
            segment_targets: {
              "luxury_home": {"cac": 75, "roas": 2.5},
              "interior_designers": {"cac": 50, "roas": 4.0}
            }
          }
        }
      }
    }
  }
};
```

## Version History
- v1.0 (2025-01-30): Initial schema definition
- v1.1 (Planned): Add creative brief integration
- v1.2 (Planned): Add A/B testing parameters

---
*Owner: Technology Director*
*Last Updated: 2025-01-30*