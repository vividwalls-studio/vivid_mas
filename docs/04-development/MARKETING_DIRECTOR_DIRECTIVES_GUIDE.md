# Marketing Director Agent - Directives Guide

**Version:** 1.0  
**Date:** January 2025  
**Agent:** Marketing Director  
**Purpose:** Comprehensive guide for all directive types, expected responses, and communication patterns

---

## Table of Contents

1. [Directives from Business Manager](#1-directives-from-business-manager)
2. [Directives from Other Directors](#2-directives-from-other-directors)
3. [Directives to Subordinate Agents](#3-directives-to-subordinate-agents)
4. [Status Updates & Reports](#4-status-updates--reports)
5. [Escalation Triggers](#5-escalation-triggers)

---

## 1. Directives from Business Manager

### 1.1 Marketing Campaign Execution

**Description:**  
Primary directive for comprehensive marketing campaign implementation. Includes full campaign specifications, budget allocations, performance targets, and coordination requirements.

**Trigger Conditions:**
- New product launch
- Seasonal campaigns
- Revenue generation initiatives
- Brand awareness campaigns

**Key Components:**
- Campaign objectives (primary and secondary)
- Budget breakdown by channel
- Performance KPIs with specific targets
- Creative requirements and brand guidelines
- Timeline with key milestones

**Expected Response from Marketing Director:**

```json
{
  "response_type": "campaign_execution_plan",
  "status": "plan_created",
  "execution_plan": {
    "phases": [
      {
        "phase": "pre_launch",
        "duration": "2 weeks",
        "activities": ["audience_research", "creative_development", "list_segmentation"]
      },
      {
        "phase": "launch",
        "duration": "1 week",
        "activities": ["email_blast", "social_launch", "content_publication"]
      },
      {
        "phase": "sustain",
        "duration": "7 weeks",
        "activities": ["paid_ads", "content_marketing", "engagement_campaigns"]
      }
    ],
    "sub_agent_assignments": {
      "social_media_director": {
        "tasks": ["content_calendar", "post_scheduling", "engagement"],
        "budget": 1500
      },
      "email_marketing_agent": {
        "tasks": ["list_segmentation", "template_creation", "automation"],
        "budget": 1000
      }
    }
  },
  "estimated_outcomes": {
    "revenue_projection": 52000,
    "roi_estimate": 15.2,
    "timeline_feasibility": "achievable"
  }
}
```

**Success Metrics:**
- Campaign ROI ≥ 15x
- On-time milestone delivery
- Budget adherence ±10%
- Quality score ≥ 0.9

---

### 1.2 Brand Strategy Update

**Description:**  
Directive to implement changes in brand positioning, messaging framework, or visual identity across all marketing channels.

**Trigger Conditions:**
- Market repositioning
- Competitive pressure
- Customer feedback insights
- Business pivot or expansion

**Key Components:**
- Positioning changes with rationale
- Updated messaging framework
- Visual identity modifications
- Implementation requirements by channel
- Rollout phases and timeline

**Expected Response from Marketing Director:**

```json
{
  "response_type": "brand_strategy_implementation",
  "status": "strategy_approved",
  "implementation_plan": {
    "audit_results": {
      "channels_requiring_update": 12,
      "assets_to_modify": 145,
      "estimated_hours": 80
    },
    "phased_rollout": {
      "phase_1": {
        "channels": ["website", "email"],
        "completion_date": "2025-02-15"
      },
      "phase_2": {
        "channels": ["social_media", "advertising"],
        "completion_date": "2025-03-01"
      }
    },
    "resource_requirements": {
      "creative_hours": 40,
      "copywriting_hours": 20,
      "technical_hours": 20
    }
  }
}
```

**Success Metrics:**
- Brand consistency score ≥ 95%
- Implementation timeline adherence
- Stakeholder approval rating
- Customer sentiment improvement

---

### 1.3 ROI Optimization Mandate

**Description:**  
Critical directive to improve marketing return on investment through channel optimization, budget reallocation, and performance enhancement.

**Trigger Conditions:**
- ROI below target threshold
- Budget constraints
- Performance review periods
- Competitive pressure

**Key Components:**
- Current vs. target ROI metrics
- Improvement percentage required
- Focus channels for optimization
- Constraints and requirements
- Analysis scope

**Expected Response from Marketing Director:**

```json
{
  "response_type": "roi_optimization_strategy",
  "status": "optimization_initiated",
  "optimization_plan": {
    "current_analysis": {
      "overall_roi": 12.5,
      "channel_performance": {
        "email": 18.2,
        "social_paid": 8.4,
        "social_organic": 22.1,
        "content": 14.3
      }
    },
    "optimization_actions": [
      {
        "action": "reallocate_budget_from_paid_to_organic",
        "impact": "+2.5 ROI points",
        "timeline": "2 weeks"
      },
      {
        "action": "implement_ai_content_generation",
        "impact": "-30% content costs",
        "timeline": "1 week"
      }
    ],
    "projected_improvements": {
      "new_roi": 16.8,
      "cost_savings": 1200,
      "timeline": "30 days"
    }
  }
}
```

**Success Metrics:**
- ROI improvement achieved
- Cost reduction targets met
- Channel efficiency gains
- Maintained brand quality

---

## 2. Directives from Other Directors

### 2.1 Sales Collaboration Request (from Sales Director)

**Description:**  
Request for marketing support to achieve specific sales targets through lead generation, sales enablement materials, or promotional campaigns.

**Trigger Conditions:**
- Sales pipeline gaps
- New sales initiatives
- Segment-specific campaigns
- Sales team requests

**Key Components:**
- Request type (lead generation, enablement, promotion)
- Sales targets and segments
- Required marketing support
- Resource sharing agreements

**Expected Response from Marketing Director:**

```json
{
  "response_type": "sales_collaboration_confirmed",
  "status": "collaboration_plan_ready",
  "support_plan": {
    "lead_generation": {
      "target_leads": 500,
      "qualified_leads": 150,
      "channels": ["email", "linkedin", "content"],
      "timeline": "4 weeks"
    },
    "sales_enablement": {
      "materials": ["pitch_deck", "case_studies", "roi_calculator"],
      "delivery_date": "2025-02-10"
    },
    "joint_metrics": {
      "sql_target": 50,
      "conversion_target": 0.15,
      "revenue_target": 25000
    }
  }
}
```

**Success Metrics:**
- Lead quality score ≥ 0.7
- Sales acceptance rate ≥ 80%
- Conversion improvement
- Revenue attribution

---

### 2.2 Product Launch Coordination (from Product Director)

**Description:**  
Coordination request for go-to-market strategy and marketing execution for new product launches.

**Trigger Conditions:**
- New product ready for market
- Product line extensions
- Seasonal collections
- Limited edition releases

**Key Components:**
- Product specifications and USPs
- Target audience definition
- Launch requirements and timeline
- Go-to-market strategy needs

**Expected Response from Marketing Director:**

```json
{
  "response_type": "product_launch_plan",
  "status": "launch_strategy_defined",
  "launch_plan": {
    "pre_launch": {
      "teaser_campaign": "2 weeks before",
      "email_list_warming": "3 weeks before",
      "influencer_outreach": "4 weeks before"
    },
    "launch_week": {
      "channels": ["email", "social", "paid_ads", "pr"],
      "content_pieces": 24,
      "budget_allocation": 5000
    },
    "post_launch": {
      "sustain_period": "6 weeks",
      "optimization_cycles": 3,
      "performance_reviews": "weekly"
    }
  }
}
```

**Success Metrics:**
- Launch awareness reach
- First-week sales target
- Customer engagement rate
- Media coverage achieved

---

### 2.3 Customer Insights Sharing (from Customer Experience Director)

**Description:**  
Sharing of customer feedback, satisfaction scores, and behavioral insights to inform marketing strategy adjustments.

**Trigger Conditions:**
- Monthly customer surveys
- Significant feedback trends
- Satisfaction score changes
- Support ticket patterns

**Key Components:**
- Feedback summary and themes
- Satisfaction scores by segment
- Identified pain points
- Opportunity recommendations

**Expected Response from Marketing Director:**

```json
{
  "response_type": "insights_action_plan",
  "status": "insights_incorporated",
  "adjustments": {
    "messaging_updates": [
      "emphasize_quality_over_price",
      "highlight_customer_service",
      "add_social_proof"
    ],
    "channel_shifts": {
      "increase_email": "based_on_preference",
      "reduce_sms": "low_engagement"
    },
    "content_priorities": [
      "how_to_guides",
      "customer_stories",
      "behind_scenes"
    ]
  }
}
```

**Success Metrics:**
- Sentiment improvement
- Message resonance increase
- Engagement rate improvement
- Customer satisfaction lift

---

### 2.4 Financial Constraint Notification (from Finance Director)

**Description:**  
Notification of budget adjustments, spending freezes, or financial constraints requiring marketing plan modifications.

**Trigger Conditions:**
- Budget cuts or reallocations
- Cash flow constraints
- Unexpected expenses
- Economic conditions

**Key Components:**
- Budget adjustment details
- Effective dates
- Affected categories
- Required actions

**Expected Response from Marketing Director:**

```json
{
  "response_type": "budget_adjustment_plan",
  "status": "constraints_acknowledged",
  "revised_plan": {
    "budget_reallocation": {
      "from": ["paid_advertising", "influencer_marketing"],
      "to": ["organic_social", "email_marketing"],
      "savings": 2000
    },
    "campaign_prioritization": {
      "continue": ["high_roi_email", "organic_content"],
      "pause": ["low_performing_ads"],
      "cancel": ["experimental_channels"]
    },
    "impact_assessment": {
      "revenue_impact": -5000,
      "timeline_impact": "2_week_delay",
      "mitigation": "increase_organic_efforts"
    }
  }
}
```

**Success Metrics:**
- Budget compliance 100%
- ROI maintenance
- Minimal revenue impact
- Timeline adherence

---

### 2.5 Analytics Performance Report (from Analytics Director)

**Description:**  
Comprehensive performance analysis with insights, trends, and optimization recommendations.

**Trigger Conditions:**
- Weekly/monthly reporting cycles
- Performance anomalies
- Significant trends identified
- Optimization opportunities

**Key Components:**
- Campaign performance metrics
- Channel effectiveness analysis
- Customer acquisition metrics
- Actionable recommendations

**Expected Response from Marketing Director:**

```json
{
  "response_type": "analytics_action_items",
  "status": "recommendations_accepted",
  "implementation_plan": {
    "immediate_actions": [
      "pause_underperforming_campaigns",
      "increase_budget_top_performers",
      "a_b_test_new_creatives"
    ],
    "strategic_adjustments": [
      "shift_focus_to_high_ltv_segments",
      "optimize_conversion_funnel",
      "implement_predictive_targeting"
    ],
    "measurement_plan": {
      "new_kpis": ["customer_lifetime_value", "attribution_accuracy"],
      "reporting_frequency": "weekly",
      "dashboard_updates": "real_time"
    }
  }
}
```

**Success Metrics:**
- Recommendation implementation rate
- Performance improvement achieved
- Data-driven decision accuracy
- ROI optimization success

---

## 3. Directives to Subordinate Agents

### 3.1 Social Media Campaign Directive (to Social Media Director)

**Description:**  
Comprehensive directive for multi-platform social media campaign execution with specific objectives, content requirements, and performance targets.

**Trigger Conditions:**
- Campaign launch requirements
- Seasonal promotions
- Product announcements
- Engagement initiatives

**Key Components:**
- Campaign objectives and KPIs
- Platform-specific strategies
- Content calendar requirements
- Budget allocation by platform
- Engagement tactics

**Expected Response from Social Media Director:**

```json
{
  "response_type": "social_campaign_execution_plan",
  "status": "campaign_scheduled",
  "platform_strategies": {
    "facebook": {
      "posts_per_week": 5,
      "ad_spend": 500,
      "target_reach": 50000
    },
    "instagram": {
      "posts_per_week": 7,
      "stories_per_day": 2,
      "reels_per_week": 3
    },
    "pinterest": {
      "pins_per_day": 10,
      "boards_created": 3,
      "rich_pins": 20
    }
  },
  "content_calendar": {
    "week_1": ["product_showcase", "behind_scenes", "user_content"],
    "week_2": ["educational", "inspirational", "promotional"]
  },
  "projected_results": {
    "total_reach": 150000,
    "engagement_rate": 0.055,
    "click_throughs": 2000
  }
}
```

**Success Metrics:**
- Platform engagement rates
- Follower growth rate
- Content performance scores
- Conversion tracking

---

### 3.2 Content Creation Directive (to Content Strategy Agent/Copy Writer)

**Description:**  
Detailed brief for content creation including topic, format, SEO requirements, and brand guidelines.

**Trigger Conditions:**
- Content calendar requirements
- SEO opportunities
- Campaign content needs
- Educational initiatives

**Key Components:**
- Content type and format
- Topic and angle
- SEO keywords and requirements
- Word count and structure
- Brand voice and tone

**Expected Response from Content Agents:**

```json
{
  "response_type": "content_delivery",
  "status": "content_created",
  "deliverables": {
    "primary_content": {
      "title": "10 Ways to Transform Your Living Room with Wall Art",
      "word_count": 1500,
      "seo_score": 92,
      "readability_score": 78
    },
    "supporting_assets": {
      "meta_description": "150 characters",
      "social_snippets": 5,
      "email_preview": "50 words"
    },
    "optimization": {
      "keywords_included": 15,
      "internal_links": 5,
      "cta_placement": 3
    }
  }
}
```

**Success Metrics:**
- Content quality score
- SEO optimization level
- Engagement metrics
- Conversion impact

---

### 3.3 Email Campaign Directive (to Email Marketing Agent)

**Description:**  
Complete email campaign specifications including segmentation, content, automation rules, and success metrics.

**Trigger Conditions:**
- Campaign schedules
- Nurture sequence needs
- Promotional events
- Customer lifecycle triggers

**Key Components:**
- Campaign type and objectives
- Audience segmentation criteria
- Email sequence details
- Content requirements
- Success metrics

**Expected Response from Email Marketing Agent:**

```json
{
  "response_type": "email_campaign_setup",
  "status": "campaign_activated",
  "campaign_details": {
    "segments_created": 3,
    "total_recipients": 3500,
    "email_sequence": [
      {
        "email_1": "welcome",
        "scheduled": "immediately",
        "subject": "Welcome to VividWalls"
      },
      {
        "email_2": "product_showcase",
        "scheduled": "day_3",
        "subject": "Discover Your Perfect Art"
      }
    ],
    "automation_rules": {
      "open_trigger": "send_follow_up",
      "click_trigger": "add_to_engaged_segment",
      "purchase_trigger": "start_loyalty_sequence"
    }
  },
  "projected_performance": {
    "open_rate": 0.28,
    "click_rate": 0.045,
    "conversion_rate": 0.025
  }
}
```

**Success Metrics:**
- Open rate achievement
- Click-through rate
- Conversion rate
- List growth rate

---

### 3.4 Creative Asset Request (to Creative Director)

**Description:**  
Request for visual assets, design elements, or creative materials for marketing campaigns.

**Trigger Conditions:**
- Campaign creative needs
- Asset refresh requirements
- New channel requirements
- A/B testing needs

**Key Components:**
- Asset type and specifications
- Dimensions and formats
- Style guidelines
- Copy elements
- Usage context

**Expected Response from Creative Director:**

```json
{
  "response_type": "creative_assets_delivered",
  "status": "assets_ready",
  "deliverables": {
    "primary_assets": [
      {
        "type": "hero_banner",
        "versions": 3,
        "formats": ["jpg", "png", "webp"],
        "dimensions": "1920x600"
      },
      {
        "type": "social_posts",
        "quantity": 10,
        "platforms": ["instagram", "facebook"],
        "variations": "a_b_test_ready"
      }
    ],
    "brand_compliance": {
      "color_accuracy": 100,
      "typography_match": 100,
      "style_consistency": 98
    },
    "delivery": {
      "location": "dropbox_link",
      "organized_by": "campaign_and_channel",
      "naming_convention": "applied"
    }
  }
}
```

**Success Metrics:**
- Asset quality score
- Brand compliance rate
- Delivery timeliness
- Usage effectiveness

---

### 3.5 SEO Optimization Directive (to SEO Agent)

**Description:**  
Directive for search engine optimization of specific pages, content, or overall website improvements.

**Trigger Conditions:**
- New content publication
- SEO audit findings
- Ranking opportunities
- Technical issues

**Key Components:**
- Optimization scope
- Target keywords
- Technical requirements
- Content optimization needs
- Performance targets

**Expected Response from SEO Agent:**

```json
{
  "response_type": "seo_optimization_complete",
  "status": "optimization_implemented",
  "optimizations": {
    "on_page": {
      "title_tags_updated": 15,
      "meta_descriptions": 15,
      "header_optimization": 45,
      "internal_links_added": 30
    },
    "technical": {
      "page_speed_improvement": "25%",
      "mobile_optimization": "complete",
      "schema_markup": "implemented",
      "sitemap": "updated"
    },
    "content": {
      "keywords_integrated": 50,
      "content_expanded": "500_words",
      "readability_improved": "15%"
    }
  },
  "expected_impact": {
    "ranking_improvement": "3-5_positions",
    "organic_traffic_increase": "20%",
    "timeline": "6-8_weeks"
  }
}
```

**Success Metrics:**
- Ranking improvements
- Organic traffic growth
- Page speed scores
- Technical health score

---

## 4. Status Updates & Reports

### 4.1 Campaign Progress Update

**Description:**  
Regular updates on campaign execution status, performance metrics, and any issues or risks.

**Frequency:** Based on priority (daily for critical, weekly for high, monthly for medium/low)

**Key Components:**
- Campaign phase and completion percentage
- Performance against KPIs
- Budget utilization
- Issues and mitigation
- Next steps

**Format:**

```json
{
  "update_type": "campaign_progress",
  "campaign_id": "spring_2025_botanical",
  "reporting_period": "week_2",
  "status_summary": {
    "overall_health": "on_track",
    "completion": 35,
    "budget_used": 38,
    "roi_current": 12.5
  },
  "achievements": [
    "email_campaign_launched",
    "social_content_published",
    "influencer_partnerships_secured"
  ],
  "challenges": [
    {
      "issue": "lower_than_expected_engagement",
      "action": "creative_refresh_scheduled",
      "impact": "minimal"
    }
  ],
  "next_7_days": [
    "launch_paid_advertising",
    "publish_blog_series",
    "begin_retargeting"
  ]
}
```

---

### 4.2 Weekly Marketing Report

**Description:**  
Comprehensive weekly summary of all marketing activities, channel performance, and strategic insights.

**Frequency:** Every Monday morning

**Key Components:**
- Executive summary
- Channel performance metrics
- Budget status
- Key achievements
- Upcoming priorities

**Format:**

```json
{
  "report_type": "weekly_marketing_summary",
  "week_ending": "2025-01-21",
  "executive_summary": "Strong performance across email and organic social, paid ads underperforming",
  "kpi_dashboard": {
    "revenue_generated": 12500,
    "roi": 14.2,
    "new_customers": 85,
    "total_reach": 250000
  },
  "channel_breakdown": {
    "email": {
      "campaigns": 3,
      "revenue": 8000,
      "roi": 22.5
    },
    "social_organic": {
      "posts": 35,
      "engagement": 12000,
      "followers_gained": 450
    },
    "paid_ads": {
      "spend": 800,
      "conversions": 15,
      "roi": 8.5
    }
  },
  "wins": [
    "email_campaign_exceeded_targets",
    "viral_instagram_reel",
    "successful_influencer_collaboration"
  ],
  "priorities_next_week": [
    "optimize_paid_ad_targeting",
    "launch_spring_collection_campaign",
    "implement_new_email_automation"
  ]
}
```

---

## 5. Escalation Triggers

### 5.1 Budget Overrun Alert

**Description:**  
Automatic alert when campaign spending exceeds or is projected to exceed allocated budget.

**Trigger Threshold:** 
- Warning: 90% of budget consumed
- Critical: 105% projected overrun

**Required Actions:**
- Immediate spending pause
- Budget reallocation assessment
- Stakeholder notification
- Mitigation plan development

**Alert Format:**

```json
{
  "alert_type": "budget_overrun",
  "severity": "critical",
  "campaign_id": "spring_2025_botanical",
  "budget_status": {
    "allocated": 5000,
    "spent": 4800,
    "committed": 700,
    "projected_overrun": 500
  },
  "immediate_actions": [
    "pause_all_paid_advertising",
    "review_committed_spend",
    "identify_reallocation_sources"
  ],
  "recommendation": "request_additional_budget_or_reduce_scope"
}
```

---

### 5.2 Performance Underachievement Alert

**Description:**  
Alert when campaign performance falls significantly below targets, requiring intervention.

**Trigger Threshold:**
- Warning: 75% of target
- Critical: 50% of target

**Required Actions:**
- Root cause analysis
- Strategy adjustment
- Resource reallocation
- Stakeholder communication

**Alert Format:**

```json
{
  "alert_type": "performance_underachievement",
  "severity": "warning",
  "metric": "conversion_rate",
  "performance_gap": {
    "target": 0.035,
    "actual": 0.025,
    "gap_percentage": -28.5
  },
  "analysis": {
    "likely_causes": [
      "creative_fatigue",
      "targeting_mismatch",
      "competitive_pressure"
    ],
    "data_points": {
      "ctr_declining": true,
      "bounce_rate_high": true,
      "cart_abandonment": 0.72
    }
  },
  "corrective_actions": [
    "refresh_creative_assets",
    "refine_audience_targeting",
    "implement_urgency_messaging",
    "add_social_proof"
  ]
}
```

---

## Processing Guidelines

### Priority Levels and Response Times

| Priority | Response Time | Escalation | Processing Mode |
|----------|--------------|------------|-----------------|
| Critical | 1 hour | Automatic | Parallel |
| High | 4 hours | If delayed | Sequential |
| Medium | 24 hours | No | Sequential |
| Low | 72 hours | No | Batch |

### Validation Requirements

All directives must include:
- Unique directive ID
- Source and target agents
- Priority level
- Timestamp
- Valid JSON structure

### Error Handling

Failed directives trigger:
1. Retry attempts (3x with exponential backoff)
2. Fallback to manual processing
3. Escalation to Business Manager
4. Error logging and analysis

### Success Criteria

Each directive type has specific success metrics:
- **Acknowledgment:** < 5 minutes
- **Initial Response:** Per priority level
- **Completion Rate:** > 95%
- **Quality Score:** > 0.9

---

## Integration Notes

### Webhook Endpoint
```
https://n8n.vividwalls.blog/webhook/marketing-director-agent
```

### Authentication
- Type: Bearer Token
- Header: `Authorization: Bearer {{WEBHOOK_AUTH_TOKEN}}`

### Content Type
- Request: `application/json`
- Response: `application/json`

### Rate Limiting
- Max requests: 100/minute
- Burst limit: 20/second
- Retry after: 60 seconds

---

## Appendix: Common Patterns

### Successful Campaign Pattern
1. Receive directive from Business Manager
2. Analyze requirements and constraints
3. Create execution plan with phases
4. Delegate to specialized agents
5. Monitor progress daily
6. Adjust based on performance
7. Report weekly to Business Manager
8. Complete with final analysis

### Crisis Response Pattern
1. Receive alert or escalation
2. Immediate assessment (< 15 minutes)
3. Pause affected activities
4. Develop mitigation plan
5. Implement corrections
6. Monitor closely
7. Report to stakeholders
8. Document lessons learned

### Cross-Director Collaboration Pattern
1. Receive collaboration request
2. Assess resource availability
3. Propose support plan
4. Agree on shared metrics
5. Execute joint initiatives
6. Share data and insights
7. Report combined results
8. Optimize for future collaboration

---

*This document serves as the authoritative guide for Marketing Director agent directive processing and response patterns.*