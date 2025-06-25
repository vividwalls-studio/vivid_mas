# Marketing Director Agent - Required Fixes

## Current Issues

### 1. Missing Content Team Connections
**Problem**: No direct tool connections to Copy Writer and Copy Editor agents
**Impact**: Cannot orchestrate content creation pipeline effectively

### 2. No Content Strategy Integration
**Problem**: Content Strategy Agent exists but isn't connected
**Impact**: Disconnected content planning and execution

### 3. Limited Feedback Processing
**Problem**: Can send tasks but doesn't process performance feedback
**Impact**: No learning or optimization based on results

### 4. No Approval Workflows
**Problem**: No mechanism for reviewing high-stakes campaigns
**Impact**: Risk of inappropriate content or messaging

## Required Updates

### 1. Add Copy Writer Agent Tool
```json
{
  "parameters": {
    "description": "Request copy writing for marketing materials",
    "workflowId": {
      "__rl": true,
      "value": "CopyWriterAgentWorkflowId",
      "mode": "list",
      "cachedResultName": "Copy Writer Agent"
    },
    "workflowInputs": {
      "mappingMode": "defineBelow",
      "value": {
        "content_type": "={{ $fromAI('content_type', 'email, blog, ad_copy, product_description') }}",
        "brief": "={{ $fromAI('brief', 'content requirements and key messages') }}",
        "tone": "={{ $fromAI('tone', 'brand voice and emotional tone') }}",
        "keywords": "={{ $fromAI('keywords', 'seo keywords to include') }}",
        "deadline": "={{ $fromAI('deadline', 'when content is needed') }}"
      }
    }
  },
  "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
  "name": "Copy Writer Agent Tool"
}
```

### 2. Add Copy Editor Agent Tool
```json
{
  "parameters": {
    "description": "Review and edit marketing content",
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
        "content_type": "={{ $fromAI('content_type', 'type of content') }}",
        "style_guide": "={{ $fromAI('style_guide', 'brand voice guidelines') }}",
        "seo_keywords": "={{ $fromAI('seo_keywords', 'target keywords') }}"
      }
    }
  },
  "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
  "name": "Copy Editor Agent Tool"
}
```

### 3. Add Content Strategy Agent Tool
```json
{
  "parameters": {
    "description": "Coordinate content planning and calendar",
    "workflowId": {
      "__rl": true,
      "value": "ContentStrategyAgentWorkflowId",
      "mode": "list",
      "cachedResultName": "Content Strategy Agent"
    },
    "workflowInputs": {
      "mappingMode": "defineBelow",
      "value": {
        "request_type": "={{ $fromAI('request_type', 'plan_content, get_calendar, analyze_performance') }}",
        "timeframe": "={{ $fromAI('timeframe', 'planning period') }}",
        "objectives": "={{ $fromAI('objectives', 'content goals') }}",
        "channels": "={{ $fromAI('channels', 'distribution channels') }}"
      }
    }
  },
  "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
  "name": "Content Strategy Agent Tool"
}
```

### 4. Add Feedback Processing Webhook
```json
{
  "parameters": {
    "path": "marketing-director-feedback",
    "responseMode": "responseNode",
    "options": {
      "allowedOrigins": "*"
    }
  },
  "type": "n8n-nodes-base.webhook",
  "name": "Performance Feedback Webhook",
  "webhookId": "marketing-director-feedback"
}
```

### 5. Add Campaign Approval Workflow
```json
{
  "parameters": {
    "conditions": {
      "conditions": [
        {
          "leftValue": "={{ $json.campaign_budget }}",
          "rightValue": 10000,
          "operator": {
            "type": "number",
            "operation": "larger"
          }
        }
      ]
    }
  },
  "type": "n8n-nodes-base.if",
  "name": "High-Value Campaign?"
}
```

## Workflow Architecture Updates

### Current Tools:
- Email Marketing Agent ✓
- Marketing Research Agent ✓
- Social Media Director ✓
- Analytics Director ✓
- Sales Agent ✓

### Missing Tools to Add:
- Copy Writer Agent
- Copy Editor Agent
- Content Strategy Agent
- Marketing Campaign Agent (already exists but not connected)

### New Nodes Needed:
- Performance Feedback Webhook
- Process Feedback Data
- Campaign Approval Router
- Human Approval Node
- Consolidate Reports

## Updated Information Flow

### Campaign Creation Flow:
```
Marketing Director → Content Strategy → Copy Writer → Copy Editor → 
Channel Agents (Email/Social/etc) → Execute → Collect Metrics → 
Report Back to Director
```

### Feedback Processing Flow:
```
Channel Agents → Feedback Webhook → Process & Analyze → 
Update Strategy → Inform Business Manager
```

## Sticky Notes to Add

### 1. Content Team Coordination
```markdown
## Content Team Management
**Copy Creation Pipeline**

### Workflow:
1. Content Strategy provides calendar
2. Marketing Director creates briefs
3. Copy Writer produces content
4. Copy Editor reviews and optimizes
5. Approved content sent to channels

### Quality Gates:
- Brand voice compliance
- SEO optimization check
- Legal/compliance review
- Accessibility standards
```

### 2. Performance Dashboard
```markdown
## Marketing Performance Hub
**Consolidated Metrics**

### Data Sources:
- Email Marketing: Open rates, CTR, conversions
- Social Media: Engagement, reach, ROI
- SEO: Rankings, organic traffic
- Paid Ads: ROAS, CAC, conversions
- Content: Views, shares, leads

### Analysis:
- Weekly performance reviews
- Monthly strategy adjustments
- Quarterly planning sessions
```

### 3. Budget Management
```markdown
## Budget Allocation & Control
**Resource Management**

### Allocation Rules:
- 40% to highest ROI channel
- 30% to growth channels
- 20% to experimental
- 10% reserve for opportunities

### Approval Thresholds:
- < $1,000: Auto-approve
- $1,000-$10,000: Director approval
- > $10,000: Business Manager approval
```

## Testing Protocol

### 1. Content Pipeline Test
- Create brief for blog post
- Send to Copy Writer
- Review with Copy Editor
- Verify quality output

### 2. Feedback Loop Test
- Execute campaign through Email Marketing
- Wait for performance data
- Verify feedback received
- Check strategy updates

### 3. Approval Workflow Test
- Create high-budget campaign
- Verify approval triggered
- Test approval/rejection paths
- Ensure proper routing

## Implementation Priority

### Week 1: Core Connections
1. Add Copy Writer/Editor tools
2. Add Content Strategy tool
3. Test content pipeline

### Week 2: Feedback Systems
1. Implement feedback webhook
2. Add processing logic
3. Create performance dashboard

### Week 3: Advanced Features
1. Add approval workflows
2. Implement budget controls
3. Create reporting automation

## Success Metrics

### Immediate:
- All content team agents connected
- Feedback loops operational
- Basic approval workflow active

### 30 Days:
- 50% faster content production
- 100% campaign tracking
- Automated performance reports

### 90 Days:
- Full marketing automation
- Predictive optimization
- Self-improving campaigns

## Dependencies

1. **Copy Writer/Editor Agents**: Must have workflows created
2. **Content Strategy Agent**: Workflow must be active
3. **Webhook Infrastructure**: Endpoints must be configured
4. **Business Manager Integration**: For high-value approvals

---

*Created: [Current Date]*
*Priority: CRITICAL - Marketing Director is central orchestrator*
*Timeline: Complete within 2 weeks*