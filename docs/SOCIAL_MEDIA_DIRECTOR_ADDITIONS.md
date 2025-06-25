# Social Media Director Agent - Required Additions

## Overview

This document lists the specific nodes and connections to ADD to the existing Social Media Director Agent workflow (which has 88 nodes) to address the identified gaps.

## New Nodes to Add

### 1. Content Creation Tools (4 nodes)

#### Copy Writer Agent Tool
```json
{
  "parameters": {
    "description": "Request copy writing services for social media content",
    "workflowId": {
      "__rl": true,
      "value": "CopyWriterAgentWorkflowId",
      "mode": "list",
      "cachedResultName": "Copy Writer Agent"
    },
    "workflowInputs": {
      "mappingMode": "defineBelow",
      "value": {
        "content_type": "={{ $fromAI('content_type', 'social_caption, ad_copy, story_text') }}",
        "platform": "={{ $fromAI('platform', 'facebook, instagram, pinterest') }}",
        "brief": "={{ $fromAI('brief', 'content requirements and key messages') }}",
        "tone": "={{ $fromAI('tone', 'inspirational, sophisticated, accessible') }}",
        "word_limit": "={{ $fromAI('word_limit', 'character or word count') }}",
        "keywords": "={{ $fromAI('keywords', 'seo keywords to include') }}"
      }
    }
  },
  "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
  "typeVersion": 2.2,
  "position": [6700, 1840],
  "name": "Copy Writer Agent Tool"
}
```

#### Copy Editor Agent Tool
```json
{
  "parameters": {
    "description": "Review and edit content before publishing",
    "workflowId": {
      "__rl": true,
      "value": "CopyEditorAgentWorkflowId",
      "mode": "list",
      "cachedResultName": "Copy Editor Agent"
    },
    "workflowInputs": {
      "mappingMode": "defineBelow",
      "value": {
        "content": "={{ $fromAI('content', 'content to review') }}",
        "content_type": "={{ $fromAI('content_type', 'social_post, ad_copy') }}",
        "platform": "={{ $fromAI('platform', 'target platform') }}",
        "style_guide": "={{ $fromAI('style_guide', 'brand voice guidelines') }}",
        "seo_keywords": "={{ $fromAI('seo_keywords', 'keywords to optimize') }}"
      }
    }
  },
  "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
  "typeVersion": 2.2,
  "position": [7900, 1840],
  "name": "Copy Editor Agent Tool"
}
```

#### Content Strategy Agent Tool
```json
{
  "parameters": {
    "description": "Get content strategy and calendar from Content Strategy Agent",
    "workflowId": {
      "__rl": true,
      "value": "ContentStrategyAgentWorkflowId",
      "mode": "list",
      "cachedResultName": "Content Strategy Agent"
    },
    "workflowInputs": {
      "mappingMode": "defineBelow",
      "value": {
        "request_type": "={{ $fromAI('request_type', 'get_calendar, content_brief, performance_report') }}",
        "timeframe": "={{ $fromAI('timeframe', 'week, month, quarter') }}",
        "channels": "={{ $fromAI('channels', 'social platforms to include') }}",
        "focus_areas": "={{ $fromAI('focus_areas', 'specific content themes') }}"
      }
    }
  },
  "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
  "typeVersion": 2.2,
  "position": [9100, 1840],
  "name": "Content Strategy Agent Tool"
}
```

#### Marketing Campaign Agent Tool
```json
{
  "parameters": {
    "description": "Coordinate with Marketing Campaign Agent for integrated campaigns",
    "workflowId": {
      "__rl": true,
      "value": "MarketingCampaignAgentWorkflowId",
      "mode": "list",
      "cachedResultName": "Marketing Campaign Agent"
    },
    "workflowInputs": {
      "mappingMode": "defineBelow",
      "value": {
        "campaign_id": "={{ $fromAI('campaign_id', 'campaign identifier') }}",
        "request_type": "={{ $fromAI('request_type', 'get_brief, update_status, report_results') }}",
        "social_deliverables": "={{ $fromAI('social_deliverables', 'social media requirements') }}",
        "performance_data": "={{ $fromAI('performance_data', 'metrics to report') }}"
      }
    }
  },
  "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
  "typeVersion": 2.2,
  "position": [10300, 1840],
  "name": "Marketing Campaign Agent Tool"
}
```

### 2. Feedback Mechanisms (3 nodes)

#### Platform Feedback Webhook
```json
{
  "parameters": {
    "path": "social-media-feedback-webhook",
    "responseMode": "responseNode",
    "options": {
      "allowedOrigins": "*"
    }
  },
  "type": "n8n-nodes-base.webhook",
  "typeVersion": 2,
  "position": [720, 1600],
  "name": "Platform Feedback Webhook",
  "webhookId": "social-media-feedback-webhook"
}
```

#### Process Platform Feedback
```json
{
  "parameters": {
    "mode": "raw",
    "jsonOutput": "={{ { \n  'feedback_type': $json.feedback_type,\n  'platform': $json.platform,\n  'performance_data': $json.performance_data,\n  'timestamp': $now.toISO(),\n  'status': $json.status\n} }}",
    "options": {}
  },
  "type": "n8n-nodes-base.set",
  "typeVersion": 3.3,
  "position": [1000, 1600],
  "name": "Process Platform Feedback"
}
```

#### Report to Marketing Director
```json
{
  "parameters": {
    "method": "POST",
    "url": "={{ $env.MARKETING_DIRECTOR_WEBHOOK_URL }}/feedback",
    "sendBody": true,
    "bodyParameters": {
      "parameters": [
        {
          "name": "agent",
          "value": "Social Media Director"
        },
        {
          "name": "performance_summary",
          "value": "={{ $json.consolidated_metrics }}"
        },
        {
          "name": "recommendations",
          "value": "={{ $json.strategic_recommendations }}"
        }
      ]
    }
  },
  "type": "n8n-nodes-base.httpRequest",
  "typeVersion": 4.1,
  "position": [3800, 640],
  "name": "Report to Marketing Director"
}
```

### 3. Quality Control (3 nodes)

#### Approval Required Check
```json
{
  "parameters": {
    "conditions": {
      "options": {
        "caseSensitive": true,
        "leftValue": "",
        "typeValidation": "strict"
      },
      "conditions": [
        {
          "leftValue": "={{ $json.approval_required }}",
          "rightValue": true,
          "operator": {
            "type": "boolean",
            "operation": "true",
            "singleValue": true
          }
        }
      ],
      "combinator": "and"
    }
  },
  "type": "n8n-nodes-base.if",
  "typeVersion": 2,
  "position": [3200, 1200],
  "name": "Approval Required?"
}
```

#### Human Approval Node
```json
{
  "parameters": {
    "description": "Send content for human approval before publishing",
    "name": "Human Approval",
    "actionDescription": "Review and approve social media content",
    "responsePrompt": "Please review the following content for publication:\n\n{{ $json.content_preview }}\n\nPlatform: {{ $json.platform }}\nCampaign: {{ $json.campaign }}\n\nApprove or Reject with comments."
  },
  "type": "n8n-nodes-base.humanTrigger",
  "typeVersion": 1,
  "position": [3500, 1100],
  "name": "Human Approval Node"
}
```

### 4. Monitoring (1 node)

#### Sentiment Analysis MCP
```json
{
  "parameters": {
    "operation": "executeTool",
    "toolName": "={{ $fromAI('sentiment_tool', 'analyze_sentiment, detect_crisis, monitor_mentions') }}",
    "toolParameters": "={{ $fromAI('tool_parameters', 'Parameters for sentiment analysis', 'json') }}"
  },
  "type": "n8n-nodes-mcp.mcpClientTool",
  "typeVersion": 1,
  "position": [11500, 1840],
  "name": "Sentiment Analysis MCP - Execute Tool",
  "credentials": {
    "mcpClientApi": {
      "id": "SentimentAnalysisMCP",
      "name": "Sentiment Analysis MCP account"
    }
  }
}
```

## New Sticky Notes to Add (15 notes)

### 1. Copy Writer Tool Documentation
```
Position: [5900, 1740]
Content: Document Copy Writer Agent capabilities, parameters, and integration
```

### 2. Copy Editor Tool Documentation
```
Position: [7100, 1740]
Content: Document Copy Editor Agent capabilities and review process
```

### 3. Content Strategy Tool Documentation
```
Position: [8300, 1740]
Content: Document Content Strategy Agent integration and calendar management
```

### 4. Marketing Campaign Tool Documentation
```
Position: [9500, 1740]
Content: Document Marketing Campaign Agent coordination
```

### 5. Content Pipeline Flow
```
Position: [7000, 2400]
Content: Document the complete content creation pipeline
```

### 6. Feedback Mechanism Documentation
```
Position: [720, 1900]
Content: Document bi-directional feedback flows
```

### 7. Approval Workflow Documentation
```
Position: [3200, 1400]
Content: Document approval criteria and human-in-the-loop process
```

### 8. Crisis Management Enhancement
```
Position: [11500, 2100]
Content: Document enhanced crisis detection with sentiment analysis
```

### 9. Reporting Structure
```
Position: [3800, 940]
Content: Document upward reporting to Marketing Director
```

### 10-15. Integration Documentation
Various positions documenting:
- How feedback loops integrate with existing tools
- Content quality gates
- Performance consolidation
- Cross-agent communication protocols
- Error handling for new features

## Connection Updates

### New Connections to Add:

1. **Platform Feedback Webhook** → **Process Platform Feedback**
2. **Process Platform Feedback** → **Social Media Director Agent**
3. **Social Media Director Agent** → **Approval Required?**
4. **Approval Required?** → **Human Approval Node** (true path)
5. **Approval Required?** → **Continue to platforms** (false path)
6. **Human Approval Node** → **Platform agents**
7. **All Platform Agents** → **Report to Marketing Director**
8. **Copy Writer Agent Tool** → **Copy Editor Agent Tool** (content flow)
9. **Content Strategy Agent Tool** → **Copy Writer Agent Tool** (brief flow)
10. **Sentiment Analysis MCP** → **Social Media Director Agent** (monitoring)

### Tool Connections to AI Agent:
Add all new tool workflows to the Social Media Director Agent's available tools

## Summary

This approach adds **11 new nodes** and **15 new sticky notes** to the existing 88-node workflow, bringing the total to approximately **99 nodes** with comprehensive documentation. This maintains the original's sophistication while addressing all identified gaps:

- ✅ Feedback loops from platform agents
- ✅ Direct connections to Copy Writer/Editor
- ✅ Content Strategy integration
- ✅ Approval workflows for sensitive content
- ✅ Real-time sentiment monitoring
- ✅ Upward reporting to Marketing Director

The original workflow structure and documentation remain intact, with new features seamlessly integrated to enhance capabilities without disrupting existing functionality.