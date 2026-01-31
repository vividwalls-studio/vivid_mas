# SEO Research MCP Server Configuration

## Overview

The SEO Research MCP Server provides comprehensive SEO analysis tools for content strategists and marketing agents. It integrates with DataForSEO and other SEO data providers to deliver keyword research, backlink analysis, SERP analysis, and competitor insights.

## Server Details

- **Name**: seo-research-mcp
- **Version**: 0.1.0
- **Location**: `/opt/mcp-servers/research/seo-research-mcp`
- **Command**: `node /opt/mcp-servers/research/seo-research-mcp/dist/index.js`

## Available Tools

### 1. health_check
Check server health and API configuration status.

**Parameters**: None

### 2. keyword_research
Research keywords using DataForSEO Keywords Data API. Provides search volume, CPC, competition data, and trends.

**Parameters**:
- `keywords` (required): Array of keywords to research (1-100 keywords)
- `location` (optional): Location for search volume data (e.g., "United States")
- `language` (optional): Language for search volume data (e.g., "English")
- `includeSerp` (optional): Include SERP information in results (default: true)
- `includeClickstream` (optional): Include clickstream data in results (default: true)
- `limit` (optional): Maximum number of results to return (default: 100)

### 3. backlink_analysis
Analyze backlinks for a domain or URL using DataForSEO Backlinks API.

**Parameters**:
- `target` (required): Target domain or URL to analyze
- `mode` (optional): Analysis mode - "as_is", "one_per_domain", "one_per_anchor" (default: "as_is")
- `statusType` (optional): Backlink status - "all", "live", "lost" (default: "live")
- `includeSubdomains` (optional): Include subdomains in analysis (default: false)
- `excludeInternal` (optional): Exclude internal backlinks (default: true)
- `limit` (optional): Maximum number of backlinks to return (default: 100)

### 4. serp_analysis
Analyze SERP (Search Engine Results Page) for a keyword using DataForSEO SERP API.

**Parameters**:
- `keyword` (required): Keyword to analyze SERP for
- `location` (optional): Location for SERP analysis (e.g., "United States")
- `language` (optional): Language for SERP analysis (e.g., "English")
- `device` (optional): Device type - "desktop" or "mobile" (default: "desktop")
- `depth` (optional): Number of SERP results to analyze (default: 10, max: 100)

### 5. dataforseo_connection_test
Test DataForSEO API connectivity and authentication.

**Parameters**: None

## Agent Access Configuration

### Content Strategy Agent
The Content Strategy Agent should have access to all SEO Research MCP tools for:
- Keyword research and topic planning
- Content gap analysis
- SERP feature identification
- Competitor content analysis

### Marketing Director Agent
The Marketing Director Agent should have access to:
- keyword_research - For campaign planning
- serp_analysis - For market positioning
- competitor_analysis - For competitive intelligence

### Marketing Research Agent
The Marketing Research Agent should have full access to all tools for:
- Market analysis
- Competitor research
- Keyword trends
- Search behavior analysis

### Content Marketing Agents
Content-focused agents (Copy Writer, Copy Editor) should have access to:
- keyword_research - For content optimization
- serp_analysis - For understanding search intent

## n8n Configuration

To add the SEO Research MCP server to n8n:

1. Go to Credentials > Add Credential > MCP Client
2. Set the following:
   - **Name**: SEO Research MCP
   - **Command**: `node`
   - **Arguments**: `/opt/mcp-servers/research/seo-research-mcp/dist/index.js`
   - **Environment**: Leave empty

3. In your workflow, add an MCP Client node
4. Select the SEO Research MCP credential
5. Choose the tool you want to use
6. Configure the tool parameters

## Usage Examples

### Example 1: Keyword Research for Wall Art
```json
{
  "keywords": ["abstract wall art", "modern wall decor", "minimalist prints"],
  "location": "United States",
  "language": "English",
  "includeSerp": true,
  "limit": 50
}
```

### Example 2: Competitor Backlink Analysis
```json
{
  "target": "competitor-domain.com",
  "mode": "one_per_domain",
  "statusType": "live",
  "excludeInternal": true,
  "limit": 200
}
```

### Example 3: SERP Analysis for Target Keywords
```json
{
  "keyword": "large canvas wall art",
  "location": "United States",
  "device": "desktop",
  "depth": 20
}
```

## API Keys Required

The server requires the following API keys to be configured:

- **DataForSEO**: Currently configured and active
- **Brave Search API**: Optional (not yet implemented)
- **Perplexity API**: Optional (not yet implemented)
- **Tavily API**: Optional (not yet implemented)
- **SerpAPI**: Optional (not yet implemented)

## Future Enhancements

The following tools are planned for future implementation:
- `competitor_analysis`: Comprehensive competitor analysis
- `long_tail_generator`: Generate long-tail keyword variations
- `keyword_clustering`: Semantic keyword grouping
- `trend_analysis`: Historical trend analysis
- `content_extraction`: Extract content from URLs

## Troubleshooting

1. **Connection Issues**: Check that the server is running on the droplet
2. **API Errors**: Verify DataForSEO credentials in the .env file
3. **No Results**: Check API quotas and rate limits
4. **Tool Not Found**: Ensure you're using the correct tool name

## Support

For issues or questions about the SEO Research MCP server:
1. Check server logs at `/opt/mcp-servers/research/seo-research-mcp/logs`
2. Run the health_check tool to verify configuration
3. Contact the MAS technical team for assistance