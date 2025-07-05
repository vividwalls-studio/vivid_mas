export const analyzeBusinessMetrics = {
  name: 'analyze-business-metrics',
  description: 'Analyze key business metrics and KPIs for strategic insights',
  template: `
    Analyze the following business metrics and provide strategic insights:
    
    Context: {{context}}
    Metrics: {{metrics}}
    Time Period: {{time_period}}
    
    Perform comprehensive analysis including:
    - Trend identification and pattern recognition
    - YoY and MoM comparisons
    - Anomaly detection and root cause analysis
    - Correlation between different metrics
    - Strategic recommendations based on findings
    
    Structure your response with:
    1. Executive Summary
    2. Key Findings
    3. Detailed Analysis
    4. Strategic Recommendations
    5. Action Items
  `
};

export const generateAnalyticsDashboard = {
  name: 'generate-analytics-dashboard',
  description: 'Design and structure analytics dashboards for different stakeholders',
  template: `
    Design an analytics dashboard for {{stakeholder_type}} with the following requirements:
    
    Business Goals: {{business_goals}}
    Key Metrics: {{key_metrics}}
    Update Frequency: {{update_frequency}}
    
    Create a dashboard specification including:
    - Dashboard layout and visual hierarchy
    - Widget types for each metric (charts, gauges, tables)
    - Data sources and refresh schedules
    - Drill-down capabilities
    - Alert thresholds and notification rules
    - Mobile responsiveness requirements
    
    Provide implementation guidance for n8n workflows to populate the dashboard.
  `
};

export const performCohortAnalysis = {
  name: 'perform-cohort-analysis',
  description: 'Conduct cohort analysis for customer behavior and retention',
  template: `
    Perform cohort analysis with the following parameters:
    
    Cohort Definition: {{cohort_definition}}
    Analysis Period: {{analysis_period}}
    Metrics to Track: {{metrics}}
    Segmentation Criteria: {{segmentation}}
    
    Analysis should include:
    - Cohort retention curves
    - Revenue per cohort over time
    - Behavioral patterns by cohort
    - Cohort quality comparison
    - Predictive lifetime value by cohort
    - Recommendations for improving cohort performance
    
    <invoke name="supabase-query">
    {
      "query": "SELECT cohort data based on {{cohort_definition}}"
    }
    </invoke>
  `
};

export const attributionModeling = {
  name: 'attribution-modeling',
  description: 'Analyze marketing attribution across channels and touchpoints',
  template: `
    Perform multi-touch attribution analysis:
    
    Channels: {{marketing_channels}}
    Attribution Model: {{attribution_model}}
    Conversion Window: {{conversion_window}}
    
    Analysis requirements:
    - First-touch vs last-touch attribution
    - Multi-touch attribution modeling
    - Channel interaction effects
    - Cross-device attribution
    - ROI by channel and campaign
    - Budget reallocation recommendations
    
    <invoke name="shopify-analytics">
    {
      "action": "get_attribution_data",
      "channels": "{{marketing_channels}}"
    }
    </invoke>
    
    <invoke name="facebook-analytics">
    {
      "action": "get_campaign_attribution"
    }
    </invoke>
  `
};

export const predictiveAnalytics = {
  name: 'predictive-analytics',
  description: 'Generate predictive models and forecasts for business metrics',
  template: `
    Create predictive analytics for:
    
    Target Metric: {{target_metric}}
    Prediction Horizon: {{prediction_horizon}}
    Input Variables: {{input_variables}}
    Model Type: {{model_type}}
    
    Deliverables:
    - Historical trend analysis
    - Seasonality and cyclical patterns
    - Predictive model selection rationale
    - Forecast with confidence intervals
    - Scenario analysis (best/likely/worst case)
    - Model accuracy metrics
    - Recommendations based on predictions
    
    Include implementation plan for automated forecasting in n8n.
  `
};

export const competitiveIntelligence = {
  name: 'competitive-intelligence',
  description: 'Analyze competitive landscape and market positioning',
  template: `
    Conduct competitive intelligence analysis:
    
    Competitors: {{competitors}}
    Analysis Dimensions: {{dimensions}}
    Data Sources: {{data_sources}}
    
    Analysis framework:
    - Market share analysis
    - Pricing strategy comparison
    - Product feature matrix
    - Marketing channel effectiveness
    - Customer sentiment analysis
    - SWOT analysis
    - Strategic positioning recommendations
    
    <invoke name="web-search">
    {
      "query": "{{competitors}} market analysis {{dimensions}}"
    }
    </invoke>
  `
};

export const dataQualityAudit = {
  name: 'data-quality-audit',
  description: 'Audit data quality and integrity across systems',
  template: `
    Perform data quality audit for:
    
    Data Systems: {{data_systems}}
    Quality Dimensions: {{quality_dimensions}}
    Critical Metrics: {{critical_metrics}}
    
    Audit checklist:
    - Data completeness assessment
    - Accuracy verification
    - Consistency across systems
    - Timeliness of updates
    - Duplicate detection
    - Missing value analysis
    - Data lineage documentation
    - Remediation recommendations
    
    Generate data quality scorecard and improvement roadmap.
  `
};

export const customAnalyticsReport = {
  name: 'custom-analytics-report',
  description: 'Generate custom analytics reports for specific business needs',
  template: `
    Create custom analytics report:
    
    Report Title: {{report_title}}
    Audience: {{audience}}
    Key Questions: {{key_questions}}
    Data Sources: {{data_sources}}
    Delivery Format: {{format}}
    
    Report structure:
    - Executive summary
    - Methodology
    - Key findings with visualizations
    - Detailed analysis sections
    - Conclusions and recommendations
    - Appendix with raw data
    
    Ensure report is actionable and aligned with business objectives.
  `
};

export const realTimeAlerts = {
  name: 'real-time-alerts',
  description: 'Configure real-time analytics alerts and monitoring',
  template: `
    Set up real-time monitoring for:
    
    Metrics to Monitor: {{metrics}}
    Alert Thresholds: {{thresholds}}
    Alert Recipients: {{recipients}}
    Alert Channels: {{channels}}
    
    Configuration includes:
    - Metric definition and calculation
    - Threshold types (absolute, percentage, trend-based)
    - Alert frequency and cooldown periods
    - Escalation rules
    - Alert message templates
    - Integration with n8n workflows
    - Dashboard integration
    
    Provide implementation guide for monitoring system.
  `
};

export const analyticsRoadmap = {
  name: 'analytics-roadmap',
  description: 'Develop analytics strategy and implementation roadmap',
  template: `
    Develop analytics roadmap for:
    
    Business Objectives: {{objectives}}
    Current State: {{current_state}}
    Timeline: {{timeline}}
    Budget: {{budget}}
    
    Roadmap components:
    - Analytics maturity assessment
    - Gap analysis
    - Priority matrix for initiatives
    - Technology stack recommendations
    - Data governance framework
    - Team structure and skills required
    - Implementation phases
    - Success metrics and milestones
    - Risk assessment and mitigation
    
    Create actionable roadmap with clear deliverables and timelines.
  `
};