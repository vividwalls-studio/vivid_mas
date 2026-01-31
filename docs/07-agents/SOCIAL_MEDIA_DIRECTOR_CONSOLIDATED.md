# Social Media Director Agent - Consolidated Documentation

## Overview

The Social Media Director Agent manages multi-platform social media campaigns for VividWalls, coordinating with the Marketing Director and content creation teams. The agent has been enhanced from 88 to 103 nodes while preserving all original functionality.

## Directives from Marketing Director

### Social Media Campaign Directive (Primary)

**Trigger Conditions:**

- Campaign launch requirements
- Seasonal promotions  
- Product announcements
- Engagement initiatives

**Incoming Directive Structure:**

```json
{
  "directive_type": "social_campaign",
  "campaign_id": "spring_2025_botanical",
  "objectives": {
    "primary": "drive_sales",
    "secondary": ["brand_awareness", "engagement"]
  },
  "kpis": {
    "reach": 150000,
    "engagement_rate": 0.055,
    "click_throughs": 2000,
    "conversions": 50
  },
  "budget": {
    "total": 2000,
    "facebook": 500,
    "instagram": 700,
    "pinterest": 300,
    "organic": 500
  },
  "timeline": {
    "start": "2025-02-01",
    "end": "2025-03-31",
    "milestones": ["launch", "mid_campaign", "wrap_up"]
  },
  "content_requirements": {
    "posts_per_week": 15,
    "platform_distribution": {
      "facebook": 5,
      "instagram": 7,
      "pinterest": 3
    },
    "content_types": ["product_showcase", "behind_scenes", "user_generated"]
  }
}
```

**Required Response to Marketing Director:**
```json
{
  "response_type": "social_campaign_execution_plan",
  "status": "campaign_scheduled",
  "platform_strategies": {
    "facebook": {
      "posts_per_week": 5,
      "ad_spend": 500,
      "target_reach": 50000,
      "content_focus": "product_showcase"
    },
    "instagram": {
      "posts_per_week": 7,
      "stories_per_day": 2,
      "reels_per_week": 3,
      "content_focus": "lifestyle_inspiration"
    },
    "pinterest": {
      "pins_per_day": 10,
      "boards_created": 3,
      "rich_pins": 20,
      "content_focus": "room_inspiration"
    }
  },
  "content_calendar": {
    "week_1": ["product_launch", "behind_scenes", "contest_announcement"],
    "week_2": ["educational", "user_showcase", "promotional"]
  },
  "projected_results": {
    "total_reach": 150000,
    "engagement_rate": 0.055,
    "click_throughs": 2000,
    "roi_estimate": 12.5
  }
}
```

## Enhanced Workflow Architecture (103 Nodes)

### Original Components (88 nodes - Preserved)
- **65 Sticky Notes**: Comprehensive documentation
- **8 Set Nodes**: Trigger condition handling
- **5 Tool Workflows**: Pinterest, Facebook, Instagram, Analytics, Scheduler
- **Complex Routing**: Switch node for trigger types
- **Memory Integration**: Postgres chat memory

### Strategic Additions (15 new nodes)

#### 1. Content Creation Pipeline (4 nodes)
- **Copy Writer Agent Tool**: Creates platform-specific content
- **Copy Editor Agent Tool**: Reviews and optimizes content
- **Content Strategy Agent Tool**: Provides content calendar and briefs
- **Marketing Campaign Agent Tool**: Coordinates integrated campaigns

#### 2. Feedback Mechanisms (3 nodes)
- **Platform Feedback Webhook**: Receives performance data from agents
- **Process Platform Feedback**: Structures and analyzes feedback
- **Report to Marketing Director**: Sends consolidated insights upward

#### 3. Quality Control (2 nodes)
- **Approval Required?**: Conditional routing for sensitive content
- **Create Approval Task**: Linear task creation for human review

#### 4. Real-time Monitoring (1 node)
- **Sentiment Analysis MCP**: Crisis detection and brand monitoring

#### 5. Enhanced Documentation (5 sticky notes)
- Content pipeline flow documentation
- Feedback mechanisms documentation
- Crisis detection protocols
- Tool integration guidelines
- Performance optimization notes

## Key Workflows

### Content Creation Pipeline
```
Content Strategy Agent → Copy Writer Agent → Copy Editor Agent → Approval Check → Platform Distribution
```

### Feedback Loop
```
Platform Agents → Feedback Webhook → Process Metrics → Consolidate Analytics → Report to Marketing Director
```

### Crisis Management
```
Sentiment Analysis MCP → Threat Detection → Alert Threshold → Crisis Response Protocol → Marketing Director Alert
```

### Approval Workflow
```
Content Ready → Approval Required? → [Yes] → Human Approval → Continue
                                  → [No]  → Direct to Platforms
```

## Platform-Specific Strategies

### Facebook
- **Focus**: Product showcases, promotional content
- **Frequency**: 5 posts/week
- **Ad Strategy**: Lookalike audiences, retargeting
- **Budget**: $500/month typical allocation

### Instagram
- **Focus**: Lifestyle inspiration, behind-the-scenes
- **Frequency**: 7 posts/week, 2 stories/day, 3 reels/week
- **Engagement**: User-generated content, influencer partnerships
- **Budget**: $700/month typical allocation

### Pinterest
- **Focus**: Room inspiration, DIY ideas
- **Frequency**: 10 pins/day across multiple boards
- **Strategy**: Rich pins for products, seasonal boards
- **Budget**: $300/month typical allocation

## Performance Metrics & Reporting

### Key Performance Indicators
- **Reach**: Target 150K+ per campaign
- **Engagement Rate**: Maintain 5.5%+ average
- **Click-through Rate**: Achieve 1.3%+ 
- **Conversion Rate**: Target 2.5% from social traffic
- **ROI**: Minimum 12x return on ad spend

### Reporting Schedule
- **Daily**: Platform performance snapshots
- **Weekly**: Consolidated report to Marketing Director
- **Monthly**: Comprehensive campaign analysis
- **Quarterly**: Strategic recommendations

### Report Format to Marketing Director
```json
{
  "report_type": "weekly_social_performance",
  "period": "2025-W07",
  "summary": {
    "total_reach": 185000,
    "engagement_rate": 0.062,
    "conversions": 67,
    "revenue_attributed": 8500,
    "roi": 14.2
  },
  "platform_breakdown": {
    "facebook": {
      "reach": 55000,
      "engagement": 3400,
      "conversions": 25
    },
    "instagram": {
      "reach": 85000,
      "engagement": 5270,
      "conversions": 32
    },
    "pinterest": {
      "reach": 45000,
      "engagement": 2790,
      "conversions": 10
    }
  },
  "top_performing_content": [
    "botanical_collection_reel",
    "customer_transformation_post",
    "limited_time_offer_story"
  ],
  "recommendations": [
    "increase_reel_production",
    "expand_ugc_campaigns",
    "test_new_pinterest_boards"
  ]
}
```

## Integration Points

### Upward Communication
- **Marketing Director**: Campaign plans, performance reports, escalations
- **Business Manager**: Critical alerts, monthly summaries

### Lateral Communication
- **Content Strategy Agent**: Content calendars, themes
- **Copy Writer Agent**: Content creation requests
- **Copy Editor Agent**: Content review and optimization
- **Marketing Campaign Agent**: Integrated campaign coordination

### Downward Communication
- **Facebook Agent**: Platform-specific instructions
- **Instagram Agent**: Content and engagement directives
- **Pinterest Agent**: Board and pin strategies

## MCP Server Assignments

### Core MCPs
- **social-media-director-prompts**: Strategy prompts and templates
- **social-media-director-resource**: Platform best practices and guidelines

### Platform MCPs
- **facebook-analytics-mcp**: Facebook/Meta insights and analytics
- **pinterest-mcp-server**: Pinterest API and management
- **postiz-mcp-server**: Cross-platform scheduling

### Monitoring MCPs
- **sentiment-analysis-mcp**: Brand monitoring and crisis detection

## Success Metrics

### Immediate (Week 1)
- All platform agents responsive
- Content pipeline operational
- Feedback loops active

### Short-term (Month 1)
- 50% reduction in content errors
- 30% faster content production
- Real-time crisis detection operational

### Long-term (Quarter 1)
- 20% improvement in engagement rates
- 25% increase in content velocity
- 95% brand consistency score
- 15x+ average ROI on campaigns

## Implementation Notes

### Priority Level
- **Critical Directives**: 1-hour response time
- **High Priority**: 4-hour response time
- **Standard**: 24-hour response time
- **Low Priority**: 72-hour response time

### Error Handling
- 3x retry attempts with exponential backoff
- Fallback to manual processing if automated fails
- Escalation to Marketing Director for critical failures

### Quality Gates
- All content passes through Copy Editor review
- Sensitive content requires human approval
- Brand consistency check on all visuals
- Performance threshold monitoring

## Maintenance Schedule

### Daily Tasks
- Monitor platform health
- Check feedback webhooks
- Review approval queue

### Weekly Tasks
- Compile performance reports
- Analyze engagement trends
- Update content calendar

### Monthly Tasks
- Full workflow audit
- Performance optimization
- Strategy adjustment based on data

---

*Last Updated: January 2025*
*Version: 2.0 (Enhanced from 88 to 103 nodes)*
*Next Review: February 2025*