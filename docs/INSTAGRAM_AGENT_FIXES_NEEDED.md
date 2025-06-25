# Instagram Agent - Required Fixes

## Current Issues

### 1. MCP Server Misalignment
**Problem**: Instagram Agent uses Facebook Ads MCP instead of Instagram-specific MCP
**Fix**: Create proper Instagram MCP integration or use Instagram features within Facebook Graph API

### 2. No Feedback Mechanism
**Problem**: No way to report performance back to Social Media Director
**Fix**: Add webhook calls after task completion

### 3. Missing Content Creation Integration
**Problem**: No connection to Copy Writer/Editor for caption creation
**Fix**: Add tool connections before content posting

## Required Updates

### 1. Add Feedback Webhook Call
```json
{
  "parameters": {
    "method": "POST",
    "url": "={{ $env.SOCIAL_MEDIA_DIRECTOR_FEEDBACK_URL }}",
    "sendBody": true,
    "bodyParameters": {
      "parameters": [
        {
          "name": "feedback_type",
          "value": "task_completion"
        },
        {
          "name": "platform",
          "value": "instagram"
        },
        {
          "name": "performance_data",
          "value": "={{ $json.metrics }}"
        },
        {
          "name": "status",
          "value": "={{ $json.success ? 'success' : 'failed' }}"
        }
      ]
    }
  },
  "type": "n8n-nodes-base.httpRequest",
  "name": "Report to Social Media Director"
}
```

### 2. Add Analytics Collection
```json
{
  "parameters": {
    "operation": "executeTool",
    "toolName": "get_instagram_insights",
    "toolParameters": "={{ $json.post_id }}"
  },
  "type": "n8n-nodes-mcp.mcpClientTool",
  "name": "Get Post Analytics"
}
```

### 3. Add Error Handling
```json
{
  "parameters": {
    "continueOnFail": true,
    "errorMessage": "Instagram posting failed: {{ $json.error }}"
  },
  "type": "n8n-nodes-base.errorTrigger",
  "name": "Handle Posting Errors"
}
```

### 4. Add Content Review Loop
Before posting content:
1. Check if content needs approval
2. If yes, send to Copy Editor
3. Wait for approval
4. Then proceed with posting

### 5. Implement Proper Instagram MCP
Currently using Facebook Ads MCP, should have:
- Instagram Graph API integration
- Story-specific features
- Reels optimization
- Shopping tag management
- IGTV support

## Workflow Updates Needed

### Current Flow:
```
Trigger → AI Agent → Facebook MCP → Shopify MCP → Response
```

### Updated Flow:
```
Trigger → AI Agent → Content Review → Instagram MCP → Post Content → 
Collect Analytics → Report Feedback → Response
```

## Sticky Notes to Add

### 1. Instagram Features Note
```markdown
## Instagram Platform Capabilities
**Native Instagram Features**

### Content Types:
- Feed Posts (single/carousel)
- Stories (24-hour content)
- Reels (short-form video)
- IGTV (long-form video)
- Live broadcasts

### Shopping Features:
- Product tags
- Shopping stickers
- Checkout integration
- Collection tags
```

### 2. Performance Metrics Note
```markdown
## Instagram Analytics
**Key Metrics to Track**

### Engagement:
- Likes, Comments, Shares
- Saves (high-value metric)
- Story replies
- Profile visits

### Reach:
- Impressions
- Reach (unique views)
- Discovery percentage
- Hashtag performance
```

### 3. Content Guidelines Note
```markdown
## Instagram Best Practices
**Platform-Specific Guidelines**

### Visual Standards:
- Square (1:1) or vertical (4:5) for feed
- 9:16 for stories and reels
- High-quality imagery only
- Consistent filter/aesthetic

### Caption Strategy:
- Front-load key message
- Include call-to-action
- Strategic hashtag use (10-15)
- Accessibility: Add alt text
```

## Testing Requirements

1. **Post Creation Test**
   - Create test post with all content types
   - Verify shopping tags work
   - Check hashtag functionality

2. **Analytics Test**
   - Post content
   - Wait 24 hours
   - Retrieve and verify metrics
   - Send feedback to director

3. **Error Handling Test**
   - Test with invalid image
   - Test with banned hashtags
   - Test API rate limits
   - Verify graceful failures

## Priority: HIGH
Instagram is a key visual platform for VividWalls. These fixes are critical for:
- Proper platform utilization
- Performance tracking
- Content quality control
- Strategic optimization

---

*Created: [Current Date]*
*Priority: HIGH - Implement within 1 week*
*Dependencies: Social Media Director update must be complete first*