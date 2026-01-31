# n8n Import Instructions

## Workflows to Import

The following workflows have been prepared for import:

- **Performance Analytics Sub-Agent**: `import_performance_analytics_workflow.json`
- **Budget Optimization Sub-Agent**: `import_budget_optimization_workflow.json`
- **Campaign Coordination Sub-Agent**: `import_campaign_coordination_workflow.json`
- **Workflow Automation Sub-Agent**: `import_workflow_automation_workflow.json`
- **Stakeholder Communications Sub-Agent**: `import_stakeholder_communications_workflow.json`

## Import Steps

1. **Open n8n UI** at http://localhost:5678

2. **Import Each Workflow**:
   - Go to Workflows page
   - Click "Add workflow" → "Import from file"
   - Select each prepared JSON file
   - Save the workflow

3. **Update Workflow References**:
   - Note the workflow IDs after import
   - Update any workflow tool references to use correct IDs

4. **Configure Credentials**:
   - Ensure OpenAI credentials are configured
   - Ensure PostgreSQL credentials are configured
   - Configure any MCP client credentials

5. **Test Each Workflow**:
   - Use the chat trigger to test
   - Verify agent responses
   - Check memory persistence

## Workflow ID Mapping

After import, update this mapping:

```json
{
  "strategic_orchestrator": "WORKFLOW_ID_HERE",
  "performance_analytics": "WORKFLOW_ID_HERE",
  "budget_optimization": "WORKFLOW_ID_HERE",
  "campaign_coordination": "WORKFLOW_ID_HERE",
  "workflow_automation": "WORKFLOW_ID_HERE",
  "stakeholder_communications": "WORKFLOW_ID_HERE"
}
```

## Update Business Manager Orchestrator

After importing all sub-agents, update the Business Manager orchestrator workflow to reference the correct sub-agent workflow IDs in the execute workflow nodes.
