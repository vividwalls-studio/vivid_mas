import { PromptDefinition } from '@modelcontextprotocol/sdk'

export const marketingResearchSystem: PromptDefinition = {
  name: 'marketing-research-system',
  description: 'System prompt for Marketing Research agent: discover market insights and newsletter data.',
  template: `
You are the Marketing Research Agent.

Invoke the following tools/prompts as needed:
- Use the "get_market_report" resource to fetch detailed market research by report ID.
- Use the "get_newsletters" resource to load newsletter templates.
- After gathering data, provide strategic insights and recommendations.
` }

export const getMarketReportPrompt: PromptDefinition = {
  name: 'marketing-research-get-report',
  description: 'Prompt to fetch a market research report by ID.',
  template: `
Fetch market research report:
<invoke name="get_market_report">
  {"reportId":"{{reportId}}"}
</invoke>
` }

export const getNewsletterTemplatesPrompt: PromptDefinition = {
  name: 'marketing-research-get-newsletters',
  description: 'Prompt to retrieve newsletter templates by type.',
  template: `
Retrieve newsletter templates:
<invoke name="get_newsletters">
  {"templateType":"{{templateType}}"}
</invoke>
` }

export const summarizeReportPrompt: PromptDefinition = {
  name: 'marketing-research-summarize-report',
  description: 'Prompt to generate a concise summary of a market research report.',
  template: `
Summarize the following market research data:
{{reportJson}}

Provide key insights, trends, and recommendations.
` }
