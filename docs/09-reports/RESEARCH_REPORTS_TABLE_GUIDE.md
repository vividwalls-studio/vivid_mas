# Research Reports Table Guide

## Overview

The `research_reports` table is designed to store comprehensive research outputs from the Research Agent workflows. It supports multiple research types including consumer studies, competitor research, trend analysis, and market analysis.

## Table Structure

### Core Fields

- **id**: UUID primary key
- **report_type**: Enum (consumer_study, competitor_research, trend_analysis, market_analysis)
- **report_scope**: Enum (healthcare_wellness_segment_expansion, luxury_segment_pricing_strategy, social_selling_optimization, corporate_hospitality_expansion, general_market, custom)
- **urgency**: Enum (immediate, standard, low, scheduled)
- **status**: Enum (in_progress, completed, failed, archived)

### Content Fields

- **executive_summary**: Brief overview of findings
- **full_report**: Complete research report text
- **report_sections**: JSONB for structured sections
- **key_findings**: JSONB containing main discoveries
- **recommendations**: JSONB with actionable recommendations
- **action_items**: JSONB with specific next steps

### Research Parameters

- **research_parameters**: JSONB for flexible research criteria
- **target_market**: JSONB with demographics, psychographics, behaviors
- **competitors**: JSONB listing direct, indirect, aspirational competitors
- **data_sources**: JSONB with primary, secondary, social sources
- **analysis_focus**: JSONB with metrics, timeframe, geographic scope
- **strategic_questions**: Array of key questions addressed

### Quality Metrics

- **confidence_level**: 0-1 score indicating confidence in findings
- **data_quality_score**: 0-1 score indicating data quality

## Usage in n8n Workflows

### Creating a Report

Use the Supabase node with the following configuration:

```json
{
  "operation": "executeRpc",
  "functionName": "create_research_report",
  "parameters": {
    "p_report_type": "trend_analysis",
    "p_report_scope": "social_selling_optimization", 
    "p_source_agent": "marketing_research_agent",
    "p_executive_summary": "{{ $json.executive_summary }}",
    "p_full_report": "{{ $json.initial_findings }}",
    "p_research_parameters": "{{ $json.research_parameters }}",
    "p_target_market": "{{ $json.target_market }}",
    "p_competitors": "{{ $json.competitors }}",
    "p_strategic_questions": "{{ $json.strategic_questions }}",
    "p_urgency": "{{ $json.trigger_condition.urgency }}",
    "p_tags": ["social_commerce", "trend_analysis", "q1_2024"]
  }
}
```

### Completing a Report

```json
{
  "operation": "executeRpc",
  "functionName": "complete_research_report",
  "parameters": {
    "p_report_id": "{{ $json.report_id }}",
    "p_full_report": "{{ $json.complete_report }}",
    "p_key_findings": "{{ $json.findings }}",
    "p_recommendations": "{{ $json.recommendations }}",
    "p_action_items": "{{ $json.action_items }}",
    "p_confidence_level": 0.85,
    "p_data_quality_score": 0.92
  }
}
```

### Searching Reports

```json
{
  "operation": "executeRpc",
  "functionName": "search_research_reports",
  "parameters": {
    "search_query": "social commerce instagram",
    "report_types": ["trend_analysis"],
    "min_confidence": 0.7
  }
}
```

## Key Findings Structure

The `key_findings` JSONB field should follow this structure:

```json
{
  "primary_insights": [
    {
      "finding": "Instagram drives 65% of social commerce art sales",
      "evidence": "Based on 3-month sales data analysis",
      "confidence": 0.9,
      "impact": "high"
    }
  ],
  "market_trends": [
    {
      "trend": "Rise in millennial art collectors",
      "growth_rate": "35% YoY",
      "timeframe": "2023-2024"
    }
  ],
  "competitive_insights": [
    {
      "competitor": "Society6",
      "observation": "Launched AI-powered art recommendations",
      "threat_level": "medium"
    }
  ]
}
```

## Recommendations Structure

```json
{
  "immediate_actions": [
    {
      "recommendation": "Launch Instagram Shopping integration",
      "priority": "high",
      "estimated_impact": "$150K additional revenue",
      "resources_needed": ["Instagram Business Account", "Product Catalog"]
    }
  ],
  "strategic_initiatives": [
    {
      "initiative": "Influencer partnership program",
      "timeline": "Q2 2024",
      "budget_estimate": "$25K",
      "expected_roi": "300%"
    }
  ]
}
```

## Integration with MCP Servers

The Research Agent can use these MCP servers to populate reports:

1. **Tavily MCP**: Web research and data gathering
2. **SEO Research MCP**: Content and keyword analysis  
3. **Email Marketing MCP**: Campaign performance data
4. **Supabase MCP**: Store and retrieve reports
5. **Marketing Director Resource/Prompts**: Strategic guidance

## Best Practices

1. Always include an executive summary for quick insights
2. Set appropriate confidence levels based on data quality
3. Use tags and keywords for better discoverability
4. Link related reports using parent_report_id
5. Update report sections incrementally as research progresses
6. Include measurable metrics in recommendations
7. Archive old reports rather than deleting them

## Example Report Workflow

1. **Initiate Research**: Create report with initial parameters
2. **Gather Data**: Use Tavily, SEO tools to collect information
3. **Analyze**: Process findings and identify patterns
4. **Update Sections**: Add findings incrementally
5. **Generate Recommendations**: Based on analysis
6. **Complete Report**: Mark as completed with final confidence score
7. **Distribute**: Share with relevant agents/stakeholders

## Performance Considerations

- Full-text search is indexed on executive_summary, full_report, and strategic_questions
- Use specific report_type and scope filters for faster queries
- JSONB fields are GIN indexed for efficient searches
- Consider pagination when retrieving multiple reports