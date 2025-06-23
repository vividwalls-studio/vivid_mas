import { PromptDefinition } from '@modelcontextprotocol/sdk'

// System prompt for Newsletter Agent
export const newsletterAgentSystem: PromptDefinition = {
  name: 'newsletter-agent-system',
  description: 'System prompt for Newsletter Agent: orchestrate newsletter generation using research, templates, copy, and images.',
  template: `
You are the Newsletter Agent. Your task is to produce a final composed newsletter using the following steps:
1. Load newsletter templates using "marketing-research-get-newsletters".
2. Fetch market insights via "marketing-research-get-report" and summarize using "marketing-research-summarize-report".
3. Invoke "copy-writer-agent" workflow for draft copy: <invoke name="n8n:triggerWorkflow">{"workflowId":"CopyWriterWorkflowId","input": {"topic":"{{topic}}","tone":"{{tone}}"}}</invoke>.
4. Send draft copy to "copy-editor-agent": <invoke name="n8n:triggerWorkflow">{"workflowId":"CopyEditorWorkflowId","input": {"draft":"{{draftText}}"}}</invoke>.
5. Select images via "image-picker-resource": <invoke name="image-picker">{"criteria": {"theme":"{{theme}}","color":"{{color}}"}}</invoke>.
6. Compose final newsletter using "compose-newsletter" prompt below.
` }

// Prompt to load newsletter templates
export const loadNewsletterTemplates: PromptDefinition = {
  name: 'load-newsletter-templates',
  description: 'Invoke resource to fetch newsletter templates.',
  template: `
<invoke name="marketing-research-get-newsletters">
  {"templateType":"{{templateType}}"}
</invoke>
` }

// Prompt to request and summarize market report
export const summarizeMarketReport: PromptDefinition = {
  name: 'summarize-market-report',
  description: 'Fetch and summarize market research.',
  template: `
<invoke name="marketing-research-get-report">
  {"reportId":"{{reportId}}"}
</invoke>

{{#summarize}}
` }

// Prompt to compose final newsletter
export const composeNewsletter: PromptDefinition = {
  name: 'compose-newsletter',
  description: 'Compose the newsletter by merging template, edited copy, and chosen images.',
  template: `
Use the loaded template:
{{template.body_template}}

Insert editor-approved copy:
{{editedCopy}}

Embed images:
{{#each selectedImages}}
  ![{{this.alt}}]({{this.uri}})
{{/each}}

Finalize the newsletter content ready for sending.
` }

// Prompt to generate final newsletter HTML
export const generateNewsletterHtml: PromptDefinition = {
  name: 'generate-newsletter-html',
  description: 'Generate the final newsletter HTML using provided content, images, and metadata.',
  template: `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{subject}}</title>
  <style>
    body { margin:0; padding:0; background:#F3F3F3; font-family:Inter, sans-serif; }
    .container { max-width:684px; margin:0 auto; background:#fff; padding:20px; }
    .banner img { width:100%; border-radius:5px; }
    h1 { font-size:32px; margin-bottom:10px; }
    p { font-size:16px; line-height:24px; margin-bottom:16px; }
    .divider { border-top:1px solid #BFC0C3; margin:20px 0; }
  </style>
</head>
<body>
  <div class="container">
    <div class="banner">
      <img src="{{bannerImageUrl}}" alt="Banner Image" />
    </div>
    <h1>{{newsletterTitle}}</h1>
    <p><em>{{newsletterHook}}</em></p>
    <div class="divider"></div>
    {{#each sections}}
      <h2>{{this.heading}}</h2>
      <p>{{this.content}}</p>
      {{#if this.imageUrl}}
        <div class="section-image"><img src="{{this.imageUrl}}" alt="{{this.altText}}" style="width:100%;border-radius:5px;"/></div>
      {{/if}}
      <div class="divider"></div>
    {{/each}}
    <footer>
      <p>© VividWalls Studio, Inc. | <a href="{{unsubscribeLink}}">Unsubscribe</a></p>
    </footer>
  </div>
</body>
</html>
` }
