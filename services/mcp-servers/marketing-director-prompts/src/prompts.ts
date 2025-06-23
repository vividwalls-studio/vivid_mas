import { PromptDefinition } from '@modelcontextprotocol/sdk'

export const marketingDirectorSystem: PromptDefinition = {
  name: 'marketing-director-system',
  description: 'System prompt for the Marketing Director agent: orchestrate marketing strategies, budgets, and delegate tasks.',
  template: `
# Marketing Director Agent System Prompt

You are the Marketing Director Agent for VividWalls, responsible for customer acquisition, brand growth, and campaign performance.

Invoke the "marketing-director" resource to fetch your tasks and domain knowledge from Supabase:
<invoke name="marketing-director">
  {"agentId": "{{agentId}}"}
</invoke>

After loading tasks and knowledge, proceed with the following core responsibilities:
- Strategy development
- Budget allocation
- Campaign orchestration
- Cross-agent coordination
- Performance monitoring
`}

export const delegateEmailCampaign: PromptDefinition = {
  name: 'marketing-director-delegate-email',
  description: 'Prompt to delegate an email marketing campaign to the Email Marketing Agent via n8n workflow.',
  template: `
Use the MCP workflow tool to delegate an email campaign:
<invoke name="n8n:triggerWorkflow">
  {"workflowId":"EmailMarketingAgentWorkflowId","input":{
    "campaign_type":"{{campaignType}}",
    "email_subject":"{{emailSubject}}",
    "content_request":{{contentRequest}},
    "target_audience":"{{targetAudience}}",
    "send_immediately":{{sendImmediately}}
  }}
</invoke>
`}

export const requestMarketResearch: PromptDefinition = {
  name: 'marketing-director-request-research',
  description: 'Prompt to request market research from the Marketing Research Agent.',
  template: `
Use the MCP workflow tool to request market insights:
<invoke name="n8n:triggerWorkflow">
  {"workflowId":"MarketingResearchAgentWorkflowId","input":{
    "research_type":"{{researchType}}",
    "focus_areas":{{focusAreas}},
    "competitors":{{competitors}},
    "deliverables":{{deliverables}}
  }}
</invoke>
`}

export const coordinateSocialMedia: PromptDefinition = {
  name: 'marketing-director-coordinate-social',
  description: 'Prompt to coordinate social media strategies with the Social Media Director Agent.',
  template: `
Delegate social media coordination:
<invoke name="n8n:triggerWorkflow">
  {"workflowId":"SocialMediaDirectorWorkflowId","input":{
    "task_type":"{{taskType}}",
    "campaign_brief":{{campaignBrief}},
    "platforms":{{platforms}},
    "timeline":"{{timeline}}"
  }}
</invoke>
`}

export const requestAnalyticsReport: PromptDefinition = {
  name: 'marketing-director-request-analytics',
  description: 'Prompt to request performance analytics from the Analytics Director Agent.',
  template: `
Request analytics report:
<invoke name="n8n:triggerWorkflow">
  {"workflowId":"AnalyticsDirectorWorkflowId","input":{
    "report_type":"marketing_performance",
    "date_range":"{{dateRange}}",
    "metrics":{{metrics}},
    "segments":{{segments}},
    "format":"marketing_dashboard"
  }}
</invoke>
`}

export const coordinateSalesPromotion: PromptDefinition = {
  name: 'marketing-director-coordinate-sales',
  description: 'Prompt to coordinate promotional campaigns with the Sales Agent.',
  template: `
Coordinate sales promotion:
<invoke name="n8n:triggerWorkflow">
  {"workflowId":"SalesAgentWorkflowId","input":{
    "task_type":"promotional_campaign",
    "promotion_details":{{promotionDetails}},
    "customer_segment":{{customerSegment}},
    "sales_goals":{{salesGoals}}
  }}
</invoke>
`}

export const marketingKnowledgeBase: PromptDefinition = {
  name: 'marketing-knowledge-base',
  description: 'Prompt to query the marketing best-practices knowledge base.',
  template: `
Access marketing knowledge base for templates and guidelines:
<invoke name="marketing_knowledge_base">
  {"query":"{{query}}"}
</invoke>
`}
