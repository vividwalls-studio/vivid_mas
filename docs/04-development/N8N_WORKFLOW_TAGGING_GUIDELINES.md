# N8N Workflow Tagging Guidelines

## Overview

This document outlines the standardized tagging strategy for organizing n8n workflows across multiple clients and projects. Proper tagging ensures efficient workflow management, easy discovery, and clear categorization.

## Tag Categories

### 1. Primary Category Tags (Client/Project)

These tags identify which client or project the workflow belongs to:

| Tag | Description | Use Case |
|-----|-------------|----------|
| `VividWalls-MAS` | VividWalls Multi-Agent System | All VividWalls MAS client workflows |
| `DesignThru-AI` | DesignThru AI client | DesignThru AI client workflows |
| `N8N-Course-Demo` | Course demonstrations | Educational and demo workflows |

**Rule**: Every workflow MUST have exactly ONE primary category tag.

### 2. Secondary Classification Tags (Status)

These tags indicate the workflow's lifecycle stage:

| Tag | Description | Use Case |
|-----|-------------|----------|
| `Production` | Live workflows | Active, client-facing workflows |
| `Development` | In development | Workflows being built or tested |
| `Template` | Reusable templates | Base workflows for creating new ones |
| `Archive` | Deprecated | Old workflows kept for reference |

**Rule**: Every workflow SHOULD have ONE classification tag.

### 3. Functional Tags (Purpose)

These tags describe what the workflow does:

| Tag | Description | Examples |
|-----|-------------|----------|
| `Data-Processing` | Data transformation | ETL, data cleaning, formatting |
| `API-Integration` | External API calls | Shopify, Stripe, SendGrid |
| `Automation` | Process automation | Business logic, task automation |
| `Notification` | Alerts and messages | Email, SMS, Slack notifications |
| `Webhook` | Webhook-triggered | External event responses |
| `Scheduled` | Time-based | Cron jobs, periodic tasks |
| `Agent-Workflow` | AI agent orchestration | MAS agent workflows |
| `MCP-Integration` | MCP server usage | Workflows using MCP tools |

**Rule**: Workflows can have MULTIPLE functional tags as appropriate.

### 4. Department/Agent Tags (VividWalls-MAS specific)

For VividWalls MAS workflows, these tags identify the responsible agent or department:

| Tag | Description |
|-----|-------------|
| `Business-Manager` | Business Manager agent workflows |
| `Marketing` | Marketing department/director |
| `Sales` | Sales department/director |
| `Operations` | Operations department/director |
| `Customer-Experience` | Customer experience workflows |
| `Product` | Product management workflows |
| `Finance` | Finance department workflows |
| `Analytics` | Analytics and reporting |
| `Technology` | Technology and IT workflows |
| `Social-Media` | Social media management |

## Naming Conventions

### Standard Format

```
[Client]-[Department/Function]-[Specific Purpose]-[Version/Variant]
```

### Examples

#### VividWalls MAS Workflows
- `VividWalls-Business-Manager-Orchestrator`
- `VividWalls-Marketing-Director-Campaign-Manager`
- `VividWalls-Sales-Director-Lead-Processor`
- `VividWalls-Shopify-Product-Sync`
- `VividWalls-Analytics-KPI-Dashboard`

#### DesignThru AI Workflows
- `DesignThru-Image-Generator`
- `DesignThru-Style-Transfer`
- `DesignThru-Customer-Onboarding`

#### Course Demo Workflows
- `Demo-Webhook-Basics`
- `Demo-API-Integration-Example`
- `Template-Email-Automation`

### Naming Rules

1. **Use hyphens** to separate words (not underscores or spaces)
2. **Start with client/project prefix** ( DesignThru, Demo, Template)
3. **Include functional area** (Marketing, Sales, Analytics, etc.)
4. **Be descriptive but concise** (max 5-6 words)
5. **Add version suffix if needed** (V2, Beta, Test)

## Tagging Process

### For New Workflows

1. **Determine Primary Category**
   - Which client/project does this belong to?
   - Apply ONE primary tag

2. **Set Classification**
   - Is it ready for production?
   - Is it a template for reuse?
   - Apply ONE classification tag

3. **Identify Functions**
   - What does the workflow do?
   - Does it process data? Call APIs? Send notifications?
   - Apply ALL relevant functional tags

4. **Assign Department** (if VividWalls-MAS)
   - Which agent/department owns this?
   - Apply relevant department tag

### For Existing Workflows

1. **Audit current state**
   - Review workflow name and purpose
   - Check if active or inactive
   - Examine nodes for functionality

2. **Apply tags systematically**
   - Start with primary category
   - Add classification based on status
   - Add functional tags based on nodes
   - Add department tags if applicable

## Tag Combinations

### Common Patterns

#### Active VividWalls Agent
```
Tags: [VividWalls-MAS, Production, Agent-Workflow, Marketing, Webhook, MCP-Integration]
```

#### Development Template
```
Tags: [N8N-Course-Demo, Template, Development, API-Integration]
```

#### Scheduled Report
```
Tags: [VividWalls-MAS, Production, Scheduled, Analytics, Data-Processing]
```

## Implementation Script

Use the provided script to automatically apply tags:

```bash
# From the project root
cd /Volumes/SeagatePortableDrive/Projects/vivid_mas
node scripts/n8n_workflow_tagging_system.js
```

The script will:
1. Create all defined tags in n8n
2. Analyze existing workflows
3. Suggest and apply appropriate tags
4. Generate a tagging report

## Maintenance Guidelines

### Weekly Tasks
- Review new workflows and ensure proper tagging
- Check for untagged workflows
- Update classification tags as workflows move to production

### Monthly Tasks
- Audit tag usage and remove unused tags
- Review archived workflows for potential deletion
- Update template workflows with latest patterns

### Quarterly Tasks
- Review and refine tagging strategy
- Document new tag requirements
- Train team on tagging best practices

## Search and Filter Examples

### Find all production VividWalls workflows
```
Tags: VividWalls-MAS AND Production
```

### Find all webhook-based marketing workflows
```
Tags: Marketing AND Webhook
```

### Find all templates for API integration
```
Tags: Template AND API-Integration
```

### Find all archived workflows for cleanup
```
Tags: Archive
```

## Best Practices

1. **Be Consistent** - Follow naming conventions strictly
2. **Tag Immediately** - Tag workflows when creating them
3. **Update Tags** - Keep tags current as workflows evolve
4. **Document Changes** - Note why tags were changed
5. **Review Regularly** - Audit tags during workflow reviews
6. **Train Users** - Ensure all users understand the system
7. **Use Filters** - Leverage tags for workflow discovery
8. **Avoid Over-tagging** - Use only relevant tags
9. **Maintain Hierarchy** - Respect tag category rules
10. **Clean Up** - Remove obsolete tags periodically

## Troubleshooting

### Workflow has no tags
- Run the tagging script to auto-suggest tags
- Manually review and apply appropriate tags

### Conflicting tags
- A workflow shouldn't be both Production and Development
- Remove incorrect classification tags

### Missing primary category
- Every workflow needs a client/project tag
- Default to N8N-Course-Demo if unsure

### Too many tags
- Review and remove redundant functional tags
- Keep only the most relevant ones

## API Reference

### Create a tag
```javascript
POST https://n8n.vividwalls.blog/api/v1/tags
{
  "name": "TagName"
}
```

### Apply tags to workflow
```javascript
PUT https://n8n.vividwalls.blog/api/v1/workflows/{id}
{
  ...workflowData,
  "tags": ["Tag1", "Tag2", "Tag3"]
}
```

### Filter workflows by tag
```javascript
GET https://n8n.vividwalls.blog/api/v1/workflows?tags=Tag1,Tag2
```

## Support

For questions or suggestions about the tagging system:
1. Review this documentation
2. Check existing tagged workflows for examples
3. Run the tagging audit script for analysis
4. Contact the workflow management team