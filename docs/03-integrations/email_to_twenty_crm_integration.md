# Email Campaign to Twenty CRM Lead Capture Integration Guide

## Overview
This guide explains how VividWalls automatically captures email campaign recipients as leads in Twenty CRM using the MCP server tools.

## Architecture

```
Email Campaign Flow:
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│ Email Marketing │ --> │ Email Service    │ --> │ Lead Processor  │
│ Agent           │     │ (Listmonk/SG)    │     │ Webhook         │
└─────────────────┘     └──────────────────┘     └─────────────────┘
                                |                           |
                                v                           v
                        ┌──────────────────┐     ┌─────────────────┐
                        │ Tracking Events  │     │ Twenty CRM      │
                        │ (open/click/etc) │ --> │ (via MCP)       │
                        └──────────────────┘     └─────────────────┘
```

## Lead Capture Process

### 1. Campaign Setup (Email Marketing Agent)
When creating an email campaign, the agent configures:
- **Tracking Pixels**: For open tracking
- **Click Tracking**: UTM parameters on all links
- **Webhook Callbacks**: For real-time event processing
- **Reply Tracking**: For direct responses

### 2. Email Service Configuration

#### Listmonk Setup:
```javascript
// Configure campaign with webhook
listmonk_create_campaign({
  name: "Spring Collection Launch",
  lists: ["subscribers", "prospects"],
  template_id: "promotional_template",
  track_opens: true,
  track_clicks: true,
  webhook_url: "https://n8n.vividwalls.com/webhook/email-campaign-events",
  webhook_events: ["sent", "opened", "clicked", "bounced"]
})
```

#### SendGrid Setup:
```javascript
// Configure event webhooks
sendgrid_configure_webhooks({
  url: "https://n8n.vividwalls.com/webhook/email-campaign-events",
  events: [
    "delivered",
    "opened",
    "clicked",
    "replied",
    "bounced",
    "unsubscribed"
  ],
  include_metadata: true
})
```

### 3. Event Processing (Lead Processor Webhook)

The webhook receives events in real-time:

```json
{
  "event_type": "email.clicked",
  "email": "john.doe@example.com",
  "campaign_id": "camp_123",
  "campaign_name": "Spring Collection",
  "timestamp": "2024-01-15T10:30:00Z",
  "clicked_link": "https://vividwalls.com/product/abstract-001",
  "utm_source": "email",
  "utm_campaign": "spring-2024",
  "ip_address": "192.168.1.1",
  "user_agent": "Mozilla/5.0..."
}
```

### 4. Twenty CRM Lead Creation

The processor automatically:

1. **Checks for Existing Lead**:
```javascript
twenty_search_person({ email: "john.doe@example.com" })
```

2. **Creates New Lead** (if not exists):
```javascript
twenty_create_person({
  email: "john.doe@example.com",
  firstName: "John",
  lastName: "Doe",
  leadSource: "email_campaign",
  leadStatus: "engaged",
  customFields: {
    campaign_source: "Spring Collection",
    first_interaction: "email.clicked",
    lead_score: 25,
    clicked_products: ["abstract-001"]
  }
})
```

3. **Updates Existing Lead** (if exists):
```javascript
twenty_update_person({
  id: "person_123",
  customFields: {
    lead_score: existingScore + 25,
    last_interaction: "email.clicked",
    engagement_count: engagementCount + 1,
    campaign_history: [...history, newInteraction]
  }
})
```

## Lead Scoring System

### Automatic Scoring Rules:
- **Email Delivered**: +5 points
- **Email Opened**: +10 points
- **Link Clicked**: +25 points
- **Multiple Clicks**: +50 points
- **Reply/Inquiry**: +100 points
- **Form Submitted**: +150 points
- **Unsubscribed**: -100 points

### Lead Status Based on Score:
- **0-9**: New Lead
- **10-24**: Aware Lead
- **25-49**: Engaged Lead
- **50-99**: Warm Lead
- **100-149**: Hot Lead
- **150+**: Qualified Lead

## Sales Handoff

### Automatic Actions:
1. **Score >= 100**: Create sales task in Twenty
2. **Score >= 150**: High-priority notification to Sales Director
3. **Multiple Interactions**: Tag for personalized outreach

### Sales Task Creation:
```javascript
twenty_create_task({
  title: "Follow up with hot lead: john.doe@example.com",
  description: "Lead score: 125\nClicked: Abstract Art Collection\nCampaign: Spring Collection",
  dueDate: "2024-01-15T14:00:00Z", // 2 hours for hot leads
  priority: "high",
  assignedTo: "sales_team",
  personId: "person_123"
})
```

## Implementation Checklist

### Email Service Setup:
- [ ] Configure webhook endpoints in Listmonk
- [ ] Set up SendGrid event webhooks
- [ ] Enable tracking pixels and click tracking
- [ ] Configure reply tracking email address

### N8N Workflows:
- [ ] Deploy Email Campaign Lead Processor workflow
- [ ] Configure Twenty CRM MCP credentials
- [ ] Set up webhook endpoints with proper authentication
- [ ] Test event processing pipeline

### Twenty CRM Configuration:
- [ ] Create custom fields for lead scoring
- [ ] Set up lead source tracking
- [ ] Configure sales task automation
- [ ] Create views for email-generated leads

### Testing:
- [ ] Send test campaign to internal list
- [ ] Verify webhook events are received
- [ ] Confirm leads are created in Twenty
- [ ] Check lead scoring calculations
- [ ] Validate sales task creation

## Monitoring and Analytics

### Key Metrics to Track:
1. **Lead Capture Rate**: % of email recipients becoming leads
2. **Engagement Rate**: % of leads with score > 25
3. **Qualification Rate**: % of leads reaching score 150+
4. **Response Time**: Time from lead creation to first contact
5. **Conversion Rate**: % of email leads becoming customers

### Dashboard Views in Twenty:
- Email Campaign Leads (filtered by source)
- High-Score Leads (score >= 100)
- Today's Email Leads
- Campaign Performance by Source
- Sales Task Queue from Email Leads

## Troubleshooting

### Common Issues:

1. **Leads Not Created**:
   - Check webhook endpoint is accessible
   - Verify MCP credentials are valid
   - Ensure email field is present in events

2. **Duplicate Leads**:
   - Verify search is working before create
   - Check email normalization (lowercase)
   - Ensure proper error handling

3. **Missing Engagement Data**:
   - Confirm tracking is enabled in email service
   - Check webhook event configuration
   - Verify UTM parameters on links

4. **Sales Tasks Not Created**:
   - Check lead score thresholds
   - Verify Twenty task API permissions
   - Ensure assignee exists in system

## Best Practices

1. **Always Include**:
   - Clear unsubscribe links
   - Privacy policy compliance
   - Tracking consent where required

2. **Data Quality**:
   - Validate email addresses before sending
   - Maintain clean subscriber lists
   - Regular database hygiene

3. **Performance**:
   - Process webhooks asynchronously
   - Batch update operations where possible
   - Monitor API rate limits

4. **Security**:
   - Authenticate webhook endpoints
   - Validate webhook signatures
   - Encrypt sensitive data in transit
