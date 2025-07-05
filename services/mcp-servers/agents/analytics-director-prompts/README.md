# Analytics Director Prompts MCP Server

This MCP server provides prompt templates for the Analytics Director agent, enabling sophisticated analytics operations and data-driven decision making.

## Available Prompts

1. **analyze-business-metrics** - Analyze key business metrics and KPIs for strategic insights
2. **generate-analytics-dashboard** - Design and structure analytics dashboards for different stakeholders
3. **perform-cohort-analysis** - Conduct cohort analysis for customer behavior and retention
4. **attribution-modeling** - Analyze marketing attribution across channels and touchpoints
5. **predictive-analytics** - Generate predictive models and forecasts for business metrics
6. **competitive-intelligence** - Analyze competitive landscape and market positioning
7. **data-quality-audit** - Audit data quality and integrity across systems
8. **custom-analytics-report** - Generate custom analytics reports for specific business needs
9. **real-time-alerts** - Configure real-time analytics alerts and monitoring
10. **analytics-roadmap** - Develop analytics strategy and implementation roadmap

## Installation

```bash
npm install
npm run build
```

## Usage

The server runs on stdio transport and can be integrated with n8n workflows. Each prompt accepts template variables that should be provided when invoking the prompt.

## Development

```bash
npm run dev  # Run in development mode with hot reload
npm test     # Run tests
```

## Integration with n8n

Add to n8n's MCP configuration to make these prompts available to the Analytics Director agent workflow.