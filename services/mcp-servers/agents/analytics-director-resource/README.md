# Analytics Director Resource MCP Server

This MCP server provides read-only access to analytics data and insights for the Analytics Director agent.

## Available Resources

1. **analytics://vividwalls/executive-dashboard** - Real-time executive dashboard with key business metrics
2. **analytics://vividwalls/real-time-metrics** - Live stream of business metrics updated every minute
3. **analytics://vividwalls/customer-insights** - Comprehensive customer behavior and segmentation data
4. **analytics://vividwalls/marketing-attribution** - Multi-touch attribution data across all marketing channels
5. **analytics://vividwalls/predictive-insights** - AI-powered predictions and business forecasts
6. **analytics://vividwalls/competitive-analysis** - Market positioning and competitive landscape analysis
7. **analytics://vividwalls/data-quality-scorecard** - Assessment of data quality across all systems
8. **analytics://vividwalls/anomaly-alerts** - Real-time anomaly detection across business metrics
9. **analytics://vividwalls/analytics-catalog** - Directory of all available analytics resources and capabilities

## Installation

```bash
npm install
npm run build
```

## Usage

The server runs on stdio transport and can be integrated with n8n workflows. Resources are read-only and return JSON data.

## Development

```bash
npm run dev  # Run in development mode with hot reload
npm test     # Run tests
```

## Data Sources

Currently using mock data for demonstration. In production, this should be connected to:
- Supabase for stored analytics
- Shopify Analytics API
- Facebook/Instagram Insights
- Pinterest Analytics
- Real-time metrics from n8n workflows

## Integration with n8n

Add to n8n's MCP configuration to make these resources available to the Analytics Director agent workflow.