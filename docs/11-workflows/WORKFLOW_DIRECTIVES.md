# Workflow Directives

This document defines structured JSON workflows for stakeholder-initiated business activities. Each workflow has clear input/output schemas to ensure proper data flow between agents.

## Table of Contents
1. [Marketing Campaign Launch](#1-marketing-campaign-launch)
2. [Marketing Research Initiatives](#2-marketing-research-initiatives)
3. [Customer Experience Optimization](#3-customer-experience-optimization)
4. [Order Management](#4-order-management)
5. [Supply Chain Management](#5-supply-chain-management)
6. [E-commerce Shop Management](#6-e-commerce-shop-management)

---

## 1. Marketing Campaign Launch

### Stakeholder Request to Business Manager

```json
{
  "directive_type": "marketing_campaign",
  "request_id": "req_20250117_001",
  "timestamp": "2025-01-17T10:00:00Z",
  "stakeholder": {
    "id": "kingler_bercy",
    "role": "owner"
  },
  "campaign_details": {
    "name": "Spring Collection 2025",
    "objective": "Launch new botanical art collection",
    "budget": 5000,
    "timeline": {
      "start_date": "2025-03-01",
      "end_date": "2025-04-30"
    },
    "targets": {
      "revenue": 50000,
      "new_customers": 200,
      "engagement_rate": 0.05
    },
    "channels": ["email", "social_media", "content_marketing", "paid_ads"]
  }
}
```

### Business Manager to Marketing Director

```json
{
  "directive_type": "marketing_campaign_execution",
  "directive_id": "dir_20250117_001",
  "source": "business_manager",
  "target": "marketing_director",
  "priority": "high",
  "deadline": "2025-02-15T23:59:59Z",
  "campaign_specification": {
    "campaign_id": "spring_2025_botanical",
    "campaign_name": "Spring Collection 2025",
    "business_objectives": {
      "primary": "revenue_generation",
      "secondary": ["brand_awareness", "customer_acquisition"]
    },
    "budget_allocation": {
      "total": 5000,
      "email_marketing": 1000,
      "social_media": 1500,
      "content_creation": 1000,
      "paid_advertising": 1500
    },
    "performance_targets": {
      "revenue": 50000,
      "roas": 10,
      "new_customers": 200,
      "email_open_rate": 0.25,
      "social_engagement_rate": 0.05,
      "conversion_rate": 0.035
    },
    "creative_requirements": {
      "theme": "botanical_spring",
      "assets_needed": ["email_templates", "social_posts", "blog_content", "ad_creatives"],
      "brand_guidelines": "maintain_premium_positioning"
    }
  },
  "delegation_instructions": {
    "coordinate_with": ["creative_director", "social_media_director"],
    "reporting_frequency": "weekly",
    "escalation_threshold": {
      "budget_overrun": 0.1,
      "performance_underrun": 0.2
    }
  }
}
```

### Marketing Director Output

```json
{
  "response_type": "campaign_execution_plan",
  "response_id": "resp_20250117_001",
  "directive_id": "dir_20250117_001",
  "status": "plan_created",
  "execution_plan": {
    "phases": [
      {
        "phase": 1,
        "name": "pre_launch",
        "duration": "2 weeks",
        "activities": ["audience_research", "creative_development", "email_list_segmentation"]
      },
      {
        "phase": 2,
        "name": "launch",
        "duration": "1 week",
        "activities": ["email_blast", "social_media_launch", "blog_publication"]
      },
      {
        "phase": 3,
        "name": "sustain",
        "duration": "7 weeks",
        "activities": ["paid_ads", "content_marketing", "engagement_campaigns"]
      }
    ],
    "sub_agent_assignments": {
      "email_marketing_agent": {
        "tasks": ["segment_list", "create_templates", "schedule_campaigns"],
        "budget": 1000
      },
      "social_media_director": {
        "tasks": ["create_content_calendar", "schedule_posts", "manage_engagement"],
        "budget": 1500
      },
      "creative_director": {
        "tasks": ["design_assets", "ensure_brand_consistency", "create_ad_creatives"],
        "budget": 1000
      }
    }
  },
  "estimated_outcomes": {
    "revenue_projection": 52000,
    "customer_acquisition": 210,
    "timeline_feasibility": "achievable"
  }
}
```

---

## 2. Marketing Research Initiatives

### Trigger Methods
- **Direct Webhook**: `POST https://n8n.vividwalls.blog/webhook/marketing-research-agent`
- **Workflow Execution**: Called by other workflows (Marketing Director, Business Manager)
- **Chat Interface**: `POST https://n8n.vividwalls.blog/webhook/marketing-research-chat-webhook`

### 2.1 Market Analysis Directive

#### Marketing Director to Marketing Research Agent

```json
{
  "directive_type": "market_analysis",
  "directive_id": "dir_20250117_006",
  "source": "marketing_director",
  "target": "marketing_research_agent",
  "priority": "high",
  "deadline": "2025-01-31T23:59:59Z",
  "research_request": {
    "type": "market_analysis",
    "scope": "social_selling_optimization",
    "urgency": "high"
  },
  "title": "Q1 2025 Social Commerce Market Analysis",
  "research_parameters": {
    "objectives": [
      "Identify social commerce opportunities",
      "Analyze competitor strategies",
      "Map customer journey on social platforms"
    ],
    "methodology": "mixed_methods",
    "sample_size": 500,
    "geographic_scope": "North America",
    "timeframe": "Q1 2025",
    "budget": 5000
  },
  "target_market": {
    "demographics": {
      "age_range": "25-45",
      "income": "$50K-$150K",
      "education": "College+"
    },
    "psychographics": {
      "values": ["aesthetics", "sustainability", "authenticity"],
      "interests": ["art", "interior design", "home decor"],
      "shopping_behavior": "social_discovery_driven"
    }
  },
  "strategic_questions": [
    "How are consumers discovering art through social media?",
    "What drives purchase decisions in social commerce?",
    "Which platforms show highest conversion rates?",
    "What content formats generate most engagement?"
  ],
  "analysis_focus": {
    "metrics": ["conversion_rate", "customer_acquisition_cost", "lifetime_value"],
    "kpis": ["social_engagement", "click_through_rate", "purchase_intent"],
    "benchmarks": ["industry_average", "competitor_performance", "platform_standards"]
  }
}
```

#### Marketing Research Agent Output

```json
{
  "response_type": "research_report_completed",
  "response_id": "resp_20250117_006",
  "directive_id": "dir_20250117_006",
  "report_id": "RPT-2025-001",
  "status": "completed",
  "research_type": "market_analysis",
  "executive_summary": "Social commerce represents a $45B opportunity with Instagram and Pinterest driving 67% of art discovery. Conversion rates peak at 4.2% for user-generated content featuring products in-situ.",
  "key_findings": {
    "primary_insights": [
      "Instagram Shopping delivers 3.8% conversion rate vs 2.1% industry average",
      "User-generated content increases purchase intent by 47%",
      "Mobile-first shoppers account for 78% of social commerce"
    ],
    "market_trends": [
      "Rise of live shopping events (+127% YoY)",
      "AR try-before-you-buy features adoption",
      "Influencer partnerships shifting to micro-influencers"
    ],
    "competitive_insights": [
      "Minted leverages Pinterest Shopping extensively",
      "Society6 uses Instagram Reels for product discovery",
      "Art.com focuses on Facebook Marketplace"
    ],
    "opportunities": [
      "Untapped TikTok Shop potential for younger demographics",
      "Pinterest Predicts trend alignment opportunity",
      "Instagram Live artist showcase events"
    ],
    "threats": [
      "Platform algorithm changes affecting organic reach",
      "Rising social media advertising costs",
      "Competitor investment in social commerce infrastructure"
    ]
  },
  "recommendations": {
    "immediate_actions": [
      "Launch Instagram Shopping catalog",
      "Partner with 10 micro-influencers",
      "Create shoppable Pinterest boards"
    ],
    "short_term_initiatives": [
      "Develop AR wall preview feature",
      "Implement social proof widgets",
      "Launch monthly artist live events"
    ],
    "long_term_strategies": [
      "Build TikTok Shop presence",
      "Develop social commerce analytics dashboard",
      "Create influencer affiliate program"
    ]
  },
  "confidence_level": 0.87,
  "data_quality_score": 0.92,
  "next_steps": [
    "Present findings to Marketing Director",
    "Develop implementation roadmap",
    "Schedule follow-up research Q2 2025"
  ]
}
```

### 2.2 Trend Analysis Directive

#### Business Manager to Marketing Research Agent

```json
{
  "directive_type": "trend_analysis",
  "directive_id": "dir_20250117_007",
  "source": "business_manager",
  "target": "marketing_research_agent",
  "priority": "standard",
  "deadline": "2025-02-15T23:59:59Z",
  "research_request": {
    "type": "trend_analysis",
    "scope": "luxury_segment_pricing_strategy",
    "urgency": "standard"
  },
  "title": "Luxury Wall Art Pricing Trends 2025",
  "research_parameters": {
    "objectives": [
      "Analyze luxury art pricing trends",
      "Identify pricing opportunities",
      "Understand price elasticity in premium segment"
    ],
    "methodology": "quantitative_analysis",
    "timeframe": "2024-2025",
    "data_points_required": 1000
  },
  "competitors": {
    "direct": ["Minted", "Society6", "Art.com"],
    "indirect": ["Etsy", "1stDibs", "Saatchi Art"],
    "competitive_advantages": ["Curated selection", "Artist relationships", "Custom framing"],
    "competitive_threats": ["Lower prices", "Wider selection", "Established brands"]
  },
  "data_sources": {
    "primary": ["Sales data", "Customer surveys", "A/B test results"],
    "secondary": ["Industry reports", "Market research", "Competitor analysis"],
    "internal": ["Shopify analytics", "Email metrics", "Customer feedback"]
  }
}
```

### 2.3 Competitor Research Directive

#### Sales Director to Marketing Research Agent

```json
{
  "directive_type": "competitor_research",
  "directive_id": "dir_20250117_008",
  "source": "sales_director",
  "target": "marketing_research_agent",
  "priority": "high",
  "deadline": "2025-01-25T23:59:59Z",
  "research_request": {
    "type": "competitor_research",
    "scope": "general_market",
    "urgency": "high"
  },
  "title": "Competitive Landscape Analysis Q1 2025",
  "research_parameters": {
    "objectives": [
      "Map competitor strategies",
      "Identify market gaps",
      "Analyze competitive positioning"
    ],
    "methodology": "competitive_intelligence"
  },
  "competitors": {
    "direct": ["Society6", "Minted", "Art.com", "Desenio"],
    "analysis_areas": [
      "pricing_strategy",
      "product_range",
      "marketing_channels",
      "customer_experience",
      "technology_features",
      "fulfillment_options"
    ]
  },
  "deliverables": {
    "swot_analysis": true,
    "competitive_matrix": true,
    "gap_analysis": true,
    "positioning_map": true
  }
}
```

### 2.4 Customer Insights Directive

#### Customer Experience Director to Marketing Research Agent

```json
{
  "directive_type": "customer_insights",
  "directive_id": "dir_20250117_009",
  "source": "customer_experience_director",
  "target": "marketing_research_agent",
  "priority": "standard",
  "deadline": "2025-02-28T23:59:59Z",
  "research_request": {
    "type": "customer_insights",
    "scope": "healthcare_wellness_segment_expansion",
    "urgency": "standard"
  },
  "title": "Healthcare Facility Art Buyer Research",
  "target_market": {
    "demographics": {
      "industry": "Healthcare",
      "decision_makers": [
        "Facility Managers",
        "Interior Designers",
        "Procurement Officers"
      ],
      "organization_size": "100+ employees",
      "budget_range": "$10K-$100K per project"
    },
    "behaviors": {
      "purchasing": "Committee-based decisions",
      "budget_cycle": "Annual or project-based",
      "priorities": [
        "Calming aesthetics",
        "Durability",
        "Easy maintenance",
        "Evidence-based design"
      ]
    }
  },
  "strategic_questions": [
    "What art types are preferred in healthcare settings?",
    "What is the typical procurement process?",
    "What are the budget ranges for healthcare art projects?",
    "Who are the key decision makers and influencers?",
    "What compliance requirements exist?"
  ],
  "research_methods": {
    "interviews": 20,
    "surveys": 100,
    "case_studies": 5,
    "site_visits": 3
  }
}
```

### 2.5 Product Research Directive

#### Product Director to Marketing Research Agent

```json
{
  "directive_type": "product_research",
  "directive_id": "dir_20250117_010",
  "source": "product_director",
  "target": "marketing_research_agent",
  "priority": "low",
  "deadline": "2025-03-31T23:59:59Z",
  "research_request": {
    "type": "product_research",
    "scope": "custom",
    "urgency": "low"
  },
  "title": "AR Try-Before-You-Buy Feature Research",
  "research_parameters": {
    "objectives": [
      "Assess AR technology adoption in e-commerce",
      "Evaluate implementation feasibility",
      "Measure customer interest and willingness to use"
    ],
    "methodology": "user_research",
    "sample_size": 200,
    "test_duration": "4 weeks"
  },
  "hypotheses": [
    "AR features will increase conversion by 25%",
    "Mobile users are more likely to use AR features",
    "AR reduces return rates by 15%",
    "Customers will pay premium for AR-enabled shopping"
  ],
  "success_metrics": {
    "engagement_rate": "Percentage using AR feature",
    "conversion_impact": "Conversion rate with vs without AR",
    "satisfaction_score": "User satisfaction with AR experience",
    "technical_performance": "Load time and stability metrics"
  }
}
```

### Marketing Research Response Structure

All research reports follow this standardized structure:

```json
{
  "response_type": "research_report_completed",
  "report_id": "UUID",
  "status": "completed",
  "research_type": "[market_analysis|trend_analysis|competitor_research|customer_insights|product_research]",
  "executive_summary": "High-level summary of findings",
  "key_findings": {
    "primary_insights": [],
    "market_trends": [],
    "competitive_insights": [],
    "opportunities": [],
    "threats": []
  },
  "recommendations": {
    "immediate_actions": [],
    "short_term_initiatives": [],
    "long_term_strategies": []
  },
  "confidence_level": 0.00,
  "data_quality_score": 0.00,
  "completeness_score": 0.00,
  "business_impact_score": 0.00,
  "estimated_roi": 0.00,
  "next_steps": []
}
```

### High Confidence Trigger

When research confidence level exceeds 0.8, the system automatically notifies the requesting director:

```json
{
  "condition": "confidence_level >= 0.8",
  "action": "Notify requesting director",
  "payload": {
    "directive_type": "research_report_ready",
    "report_id": "UUID",
    "research_type": "type",
    "confidence_level": "number",
    "key_findings": "object",
    "recommendations": "object",
    "action_required": true
  }
}
```

---

## 3. Customer Experience Optimization

### Stakeholder Request to Business Manager

```json
{
  "directive_type": "customer_experience_optimization",
  "request_id": "req_20250117_002",
  "timestamp": "2025-01-17T11:00:00Z",
  "stakeholder": {
    "id": "kingler_bercy",
    "role": "owner"
  },
  "optimization_goals": {
    "primary_metric": "customer_satisfaction_score",
    "target_improvement": 0.15,
    "focus_areas": ["response_time", "personalization", "post_purchase_support"],
    "budget": 3000,
    "timeline_days": 60
  }
}
```

### Business Manager to Customer Experience Director

```json
{
  "directive_type": "cx_optimization_initiative",
  "directive_id": "dir_20250117_002",
  "source": "business_manager",
  "target": "customer_experience_director",
  "priority": "high",
  "deadline": "2025-03-17T23:59:59Z",
  "optimization_specification": {
    "initiative_id": "cx_opt_q1_2025",
    "current_metrics": {
      "satisfaction_score": 4.2,
      "avg_response_time_hours": 24,
      "resolution_rate": 0.85,
      "nps_score": 45
    },
    "target_metrics": {
      "satisfaction_score": 4.6,
      "avg_response_time_hours": 4,
      "resolution_rate": 0.95,
      "nps_score": 60
    },
    "improvement_areas": {
      "response_time": {
        "current": "24 hours",
        "target": "4 hours",
        "strategy": "implement_ai_triage"
      },
      "personalization": {
        "current": "basic_segmentation",
        "target": "ai_driven_personalization",
        "strategy": "deploy_recommendation_engine"
      },
      "post_purchase": {
        "current": "reactive_support",
        "target": "proactive_engagement",
        "strategy": "automated_follow_up_sequences"
      }
    },
    "resource_allocation": {
      "total_budget": 3000,
      "technology": 1500,
      "training": 500,
      "process_improvement": 1000
    }
  },
  "coordination_requirements": {
    "collaborate_with": ["technology_director", "operations_director"],
    "data_sources": ["shopify_orders", "support_tickets", "customer_feedback"],
    "reporting_cadence": "bi_weekly"
  }
}
```

### Customer Experience Director Output

```json
{
  "response_type": "cx_optimization_roadmap",
  "response_id": "resp_20250117_002",
  "directive_id": "dir_20250117_002",
  "status": "roadmap_approved",
  "implementation_plan": {
    "phase_1": {
      "name": "quick_wins",
      "duration": "2 weeks",
      "initiatives": [
        {
          "name": "ai_chatbot_deployment",
          "impact": "reduce_response_time_50%",
          "cost": 800
        },
        {
          "name": "faq_optimization",
          "impact": "deflect_30%_tickets",
          "cost": 200
        }
      ]
    },
    "phase_2": {
      "name": "personalization_engine",
      "duration": "4 weeks",
      "initiatives": [
        {
          "name": "customer_segmentation",
          "impact": "improve_targeting",
          "cost": 500
        },
        {
          "name": "recommendation_system",
          "impact": "increase_aov_20%",
          "cost": 1000
        }
      ]
    },
    "phase_3": {
      "name": "proactive_support",
      "duration": "2 weeks",
      "initiatives": [
        {
          "name": "post_purchase_automation",
          "impact": "increase_retention_15%",
          "cost": 500
        }
      ]
    }
  },
  "sub_agent_tasks": {
    "customer_service_agent": ["implement_chatbot", "train_on_responses"],
    "customer_lifecycle_agent": ["design_follow_up_sequences", "segment_customers"],
    "satisfaction_monitor_agent": ["track_metrics", "generate_insights"]
  },
  "projected_outcomes": {
    "satisfaction_improvement": 0.4,
    "response_time_reduction": "80%",
    "cost_savings_monthly": 2000
  }
}
```

---

## 4. Order Management

### Stakeholder Request to Business Manager

```json
{
  "directive_type": "order_management",
  "request_id": "req_20250117_003",
  "timestamp": "2025-01-17T12:00:00Z",
  "stakeholder": {
    "id": "kingler_bercy",
    "role": "owner"
  },
  "order_concerns": {
    "issue_type": "fulfillment_delays",
    "affected_orders": 45,
    "priority": "urgent",
    "customer_impact": "high",
    "required_action": "expedite_and_communicate"
  }
}
```

### Business Manager to Operations Director

```json
{
  "directive_type": "order_fulfillment_crisis",
  "directive_id": "dir_20250117_003",
  "source": "business_manager",
  "target": "operations_director",
  "priority": "critical",
  "deadline": "2025-01-17T18:00:00Z",
  "crisis_details": {
    "incident_id": "inc_20250117_001",
    "affected_orders": {
      "total_count": 45,
      "order_ids": ["ORD-2025-1001", "ORD-2025-1002"],
      "total_value": 15750,
      "avg_delay_days": 3
    },
    "root_cause": "supplier_stock_shortage",
    "customer_segments_affected": {
      "vip": 12,
      "regular": 28,
      "new": 5
    }
  },
  "required_actions": {
    "immediate": [
      "assess_current_inventory",
      "identify_alternative_fulfillment",
      "prepare_customer_communications"
    ],
    "short_term": [
      "expedite_shipping_available_orders",
      "source_alternative_suppliers",
      "implement_compensation_strategy"
    ],
    "preventive": [
      "review_inventory_forecasting",
      "establish_backup_suppliers",
      "create_early_warning_system"
    ]
  },
  "coordination_needs": {
    "customer_experience": "prepare_apology_communications",
    "finance": "approve_expedited_shipping_costs",
    "marketing": "pause_promotional_activities"
  }
}
```

### Operations Director Output

```json
{
  "response_type": "crisis_resolution_plan",
  "response_id": "resp_20250117_003",
  "directive_id": "dir_20250117_003",
  "status": "action_plan_initiated",
  "resolution_strategy": {
    "immediate_actions": {
      "inventory_assessment": {
        "available_stock": 28,
        "can_fulfill_immediately": 28,
        "require_alternatives": 17
      },
      "alternative_fulfillment": {
        "pictorem_direct_ship": 10,
        "competitor_sourcing": 5,
        "custom_production_rush": 2
      },
      "customer_communication": {
        "template_prepared": true,
        "personalized_for_vip": true,
        "compensation_offered": "20%_discount_next_order"
      }
    },
    "execution_timeline": [
      {
        "time": "T+2 hours",
        "action": "ship_available_inventory",
        "orders_resolved": 28
      },
      {
        "time": "T+24 hours",
        "action": "pictorem_direct_fulfillment",
        "orders_resolved": 10
      },
      {
        "time": "T+48 hours",
        "action": "alternative_sourcing_complete",
        "orders_resolved": 7
      }
    ],
    "cost_impact": {
      "expedited_shipping": 450,
      "compensation_discounts": 3150,
      "rush_production": 200,
      "total_crisis_cost": 3800
    }
  },
  "sub_agent_assignments": {
    "fulfillment_agent": ["process_expedited_orders", "coordinate_shipping"],
    "inventory_management_agent": ["update_stock_levels", "forecast_adjustments"],
    "shopify_agent": ["update_order_status", "process_refunds"]
  },
  "preventive_measures": {
    "implemented": ["backup_supplier_contract", "inventory_alert_system"],
    "timeline": "within_7_days"
  }
}
```

---

## 5. Supply Chain Management

### Stakeholder Request to Business Manager

```json
{
  "directive_type": "supply_chain_optimization",
  "request_id": "req_20250117_004",
  "timestamp": "2025-01-17T13:00:00Z",
  "stakeholder": {
    "id": "kingler_bercy",
    "role": "owner"
  },
  "optimization_request": {
    "focus": "cost_reduction",
    "target_savings": 0.15,
    "constraints": ["maintain_quality", "no_delivery_delays"],
    "timeline_months": 3
  }
}
```

### Business Manager to Operations Director

```json
{
  "directive_type": "supply_chain_optimization",
  "directive_id": "dir_20250117_004",
  "source": "business_manager",
  "target": "operations_director",
  "priority": "medium",
  "deadline": "2025-04-17T23:59:59Z",
  "optimization_parameters": {
    "initiative_id": "sc_opt_2025_q1",
    "current_metrics": {
      "avg_cost_per_unit": 45,
      "lead_time_days": 14,
      "defect_rate": 0.02,
      "supplier_count": 3
    },
    "target_metrics": {
      "avg_cost_per_unit": 38.25,
      "lead_time_days": 14,
      "defect_rate": 0.015,
      "supplier_count": 5
    },
    "optimization_strategies": [
      "negotiate_volume_discounts",
      "diversify_supplier_base",
      "implement_just_in_time",
      "optimize_shipping_routes"
    ],
    "constraints": {
      "quality_standards": "maintain_or_improve",
      "delivery_performance": "no_degradation",
      "supplier_reliability": "minimum_95_percent"
    }
  },
  "analysis_requirements": {
    "data_needed": ["historical_orders", "supplier_performance", "shipping_costs"],
    "collaboration": ["finance_director", "product_director"],
    "reporting": "monthly_progress"
  }
}
```

### Operations Director Output

```json
{
  "response_type": "supply_chain_optimization_plan",
  "response_id": "resp_20250117_004",
  "directive_id": "dir_20250117_004",
  "status": "optimization_plan_ready",
  "optimization_roadmap": {
    "phase_1": {
      "name": "supplier_expansion",
      "duration": "4 weeks",
      "actions": [
        {
          "task": "identify_new_suppliers",
          "target_additions": 3,
          "evaluation_criteria": ["quality", "cost", "reliability"]
        },
        {
          "task": "negotiate_volume_agreements",
          "expected_savings": "8%",
          "minimum_order_quantities": [100, 250, 500]
        }
      ]
    },
    "phase_2": {
      "name": "process_optimization",
      "duration": "6 weeks",
      "actions": [
        {
          "task": "implement_jit_inventory",
          "inventory_reduction": "30%",
          "cash_flow_improvement": 15000
        },
        {
          "task": "optimize_shipping_consolidation",
          "cost_savings": "12%",
          "frequency": "bi_weekly"
        }
      ]
    },
    "phase_3": {
      "name": "technology_integration",
      "duration": "2 weeks",
      "actions": [
        {
          "task": "deploy_inventory_forecasting",
          "accuracy_improvement": "25%",
          "stockout_reduction": "40%"
        }
      ]
    }
  },
  "cost_benefit_analysis": {
    "implementation_cost": 5000,
    "monthly_savings": 3200,
    "roi_months": 1.6,
    "annual_savings": 38400
  },
  "risk_mitigation": {
    "supplier_diversification": "reduces_single_point_failure",
    "quality_audits": "monthly_reviews",
    "contingency_stock": "5%_safety_buffer"
  }
}
```

---

## 6. E-commerce Shop Management

### Stakeholder Request to Business Manager

```json
{
  "directive_type": "ecommerce_shop_update",
  "request_id": "req_20250117_005",
  "timestamp": "2025-01-17T14:00:00Z",
  "stakeholder": {
    "id": "kingler_bercy",
    "role": "owner"
  },
  "shop_updates": {
    "type": "seasonal_refresh",
    "requirements": [
      "update_homepage",
      "add_new_collections",
      "optimize_checkout",
      "improve_mobile_experience"
    ],
    "launch_date": "2025-03-01",
    "budget": 8000
  }
}
```

### Business Manager Multi-Director Coordination

```json
{
  "directive_type": "ecommerce_shop_overhaul",
  "directive_id": "dir_20250117_005",
  "source": "business_manager",
  "targets": ["product_director", "technology_director", "marketing_director"],
  "priority": "high",
  "deadline": "2025-02-28T23:59:59Z",
  "project_specification": {
    "project_id": "shop_refresh_spring_2025",
    "objectives": {
      "primary": "increase_conversion_rate",
      "secondary": ["improve_user_experience", "showcase_new_products"]
    },
    "requirements": {
      "homepage": {
        "hero_banner": "spring_collection_featured",
        "featured_sections": ["new_arrivals", "bestsellers", "artist_spotlight"],
        "performance_target": "load_under_3_seconds"
      },
      "collections": {
        "new_collections": ["botanical_prints", "abstract_geometrics", "coastal_scenes"],
        "organization": "by_theme_and_artist",
        "filtering": "advanced_multi_select"
      },
      "checkout": {
        "optimization": "reduce_steps_to_2",
        "payment_options": ["apple_pay", "google_pay", "klarna"],
        "trust_signals": "security_badges_visible"
      },
      "mobile": {
        "responsive_design": "mobile_first",
        "touch_optimization": "large_tap_targets",
        "performance": "amp_pages_for_products"
      }
    },
    "budget_allocation": {
      "design_development": 3000,
      "technical_implementation": 3000,
      "content_creation": 1500,
      "testing_optimization": 500
    }
  },
  "coordination_matrix": {
    "product_director": {
      "responsibilities": ["curate_collections", "product_descriptions", "merchandising"],
      "budget": 1500
    },
    "technology_director": {
      "responsibilities": ["technical_implementation", "performance_optimization", "testing"],
      "budget": 3500
    },
    "marketing_director": {
      "responsibilities": ["content_creation", "seo_optimization", "launch_campaign"],
      "budget": 3000
    }
  }
}
```

### Coordinated Director Outputs

```json
{
  "response_type": "multi_director_project_plan",
  "response_id": "resp_20250117_005",
  "directive_id": "dir_20250117_005",
  "status": "coordinated_plan_approved",
  "integrated_timeline": {
    "week_1": {
      "product_director": ["finalize_collection_curation", "prepare_product_data"],
      "technology_director": ["setup_development_environment", "begin_homepage_redesign"],
      "marketing_director": ["create_content_calendar", "start_copywriting"]
    },
    "week_2": {
      "product_director": ["optimize_product_images", "create_collection_stories"],
      "technology_director": ["implement_new_collections", "mobile_optimization"],
      "marketing_director": ["produce_lifestyle_photography", "write_seo_descriptions"]
    },
    "week_3": {
      "product_director": ["quality_assurance", "merchandising_setup"],
      "technology_director": ["checkout_optimization", "performance_testing"],
      "marketing_director": ["prepare_launch_materials", "email_campaigns"]
    },
    "week_4": {
      "all_directors": ["integration_testing", "soft_launch", "final_adjustments"]
    }
  },
  "success_metrics": {
    "conversion_rate": {
      "current": 0.023,
      "target": 0.035,
      "measurement": "google_analytics"
    },
    "page_load_time": {
      "current": 4.5,
      "target": 2.8,
      "measurement": "lighthouse"
    },
    "mobile_engagement": {
      "current": 0.45,
      "target": 0.65,
      "measurement": "user_session_data"
    }
  },
  "risk_management": {
    "identified_risks": [
      {
        "risk": "integration_delays",
        "mitigation": "parallel_development_tracks",
        "owner": "technology_director"
      },
      {
        "risk": "content_bottleneck",
        "mitigation": "pre_approved_templates",
        "owner": "marketing_director"
      }
    ]
  }
}
```

---

## Standard Workflow Components

### Error Handling Schema

```json
{
  "error_response": {
    "status": "error",
    "error_code": "RESOURCE_UNAVAILABLE",
    "error_message": "Required MCP server not responding",
    "directive_id": "dir_20250117_XXX",
    "fallback_action": "escalate_to_business_manager",
    "retry_policy": {
      "attempts": 3,
      "backoff": "exponential",
      "max_delay_seconds": 300
    }
  }
}
```

### Progress Update Schema

```json
{
  "update_type": "progress_report",
  "directive_id": "dir_20250117_XXX",
  "reporting_agent": "marketing_director",
  "timestamp": "2025-01-17T15:00:00Z",
  "progress": {
    "completion_percentage": 45,
    "milestones_completed": ["phase_1", "phase_2_partial"],
    "blockers": ["awaiting_creative_assets"],
    "next_steps": ["launch_email_campaign", "begin_social_media_push"]
  },
  "metrics": {
    "budget_utilization": 0.42,
    "timeline_adherence": "on_track",
    "quality_score": 0.92
  }
}
```

### Completion Report Schema

```json
{
  "report_type": "directive_completion",
  "directive_id": "dir_20250117_XXX",
  "final_status": "completed_successfully",
  "outcomes": {
    "objectives_met": ["primary", "secondary_1"],
    "objectives_partial": ["secondary_2"],
    "kpi_achievement": {
      "revenue": 1.05,
      "customer_acquisition": 0.98,
      "engagement": 1.12
    }
  },
  "lessons_learned": [
    "email_segmentation_critical",
    "social_media_timing_important"
  ],
  "recommendations": [
    "increase_budget_social_media",
    "earlier_creative_development"
  ]
}
```

## Implementation Notes

1. **All workflows must include**:
   - Unique request/directive IDs for tracking
   - Clear source and target agent identification
   - Priority levels and deadlines
   - Structured data inputs/outputs
   - Error handling capabilities

2. **Data validation requirements**:
   - All monetary values in USD
   - All dates in ISO 8601 format
   - All percentages as decimals (0.15 = 15%)
   - All IDs must be unique and traceable

3. **Communication patterns**:
   - Stakeholder → Business Manager only
   - Business Manager → Directors only
   - Directors → Their subordinate agents only
   - No cross-director communication without Business Manager

4. **Escalation thresholds**:
   - Budget overrun > 10%
   - Timeline delay > 20%
   - Performance underachievement > 25%
   - Any critical customer impact

5. **Reporting cadence**:
   - Critical issues: Immediate
   - High priority: Daily
   - Medium priority: Weekly
   - Low priority: Monthly