import { PromptDefinition } from '@modelcontextprotocol/sdk'

export const businessManagerSystem: PromptDefinition = {
  name: 'business-manager-system',
  description: 'System prompt for the Business Manager agent: load tasks and domain knowledge, set objectives.',
  template: `
You are the Business Manager Agent for VividWalls.

Invoke the "business-manager" resource to fetch your tasks and domain knowledge:
<invoke name="business-manager">
  {"agentId": "{{agentId}}"}
</invoke>

After receiving the JSON response (tasks and knowledge), integrate them into your context and proceed with strategic oversight, resource management, and coordination.
` 
}

export const coordinateAgentWorkflow: PromptDefinition = {
  name: 'business-manager-coordinate-agent',
  description: 'Prompt to delegate a task to another agent via MCP workflow.',
  template: `
You need to assign a task to a specialist agent.

Use the MCP tool to invoke the appropriate n8n workflow:
<invoke name="n8n:triggerWorkflow">
  {"workflowId": "{{workflowId}}", "input": {{input}}}
</invoke>

Provide clear instructions: specify the workflowId for the target agent and the input payload.
` 
}

export const generateStakeholderReport: PromptDefinition = {
  name: 'business-manager-stakeholder-report',
  description: 'Prompt to generate an interactive HTML report for stakeholder.',
  template: `
Task: Create a daily performance report as an interactive HTML dashboard for the stakeholder.

Use the prompts and data in context to build:
- Executive Summary header
- Interactive charts and tables
- Actionable recommendations

Output must be valid HTML/CSS/JS according to the design specs.
` 
}
