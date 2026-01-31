# VividWalls MAS MCP Servers Complete Documentation

This comprehensive documentation covers all MCP (Model Context Protocol) servers available in the VividWalls Multi-Agent System, including their tools, invocation scenarios, and agent mappings.

## Table of Contents
1. [MCP Server Deployment Standard](#mcp-server-deployment-standard)
2. [MCP Server Categories](#mcp-server-categories)
3. [Core Services](#core-services)
4. [Sales & CRM](#sales--crm)
5. [Social Media Services](#social-media-services)
6. [Creative Services](#creative-services)
7. [Research & Analytics](#research--analytics)
8. [Development & Infrastructure](#development--infrastructure)
9. [Agent-Specific Prompt & Resource Servers](#agent-specific-prompt--resource-servers)
10. [Deprecated/Removed Servers](#deprecatedremoved-servers)
11. [Agent-Tool Mapping](#agent-tool-mapping)
12. [Invocation Scenarios](#invocation-scenarios)

**MCP-Client Node Convention**
Every Task-oriented agent uses the `n8n-nodes-mcp` **MCP Client** node in **two modes**:

| Node Type      | Purpose                                      |
| -------------- | -------------------------------------------- |
| **List Tools** | Discover the available tools for a given MCP server |
| **Execute Tool** | Invoke a selected tool with parameters       |

These two nodes must be present for *each* MCP server referenced below.

## MCP Server Deployment Standard

As per project convention, all MCP servers are designed to be deployed on the DigitalOcean droplet under the `/root/vivid_mas/services/mcp-servers/` directory. The deployment location for each server listed below follows this standard, with each server residing in its own subdirectory.

## MCP Server Categories

This list is generated based on the current directory structure at `services/mcp-servers/` and serves as the source of truth for all existing MCP servers.

---

## Core Services

### 1. n8n MCP Server
- **Status:** Partially Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/n8n-mcp-server`
- **Purpose:** Workflow automation, agent orchestration, and process management.
- **MCP Client Configuration:**
```json
{
    "name": "n8n-mcp",
    "command": "node",
    "args": [
        "/root/vivid_mas/services/mcp-servers/n8n-mcp-server/dist/index.js"
    ],
    "transport": "stdio"
}
```
- **Environment Variables:**
    - `N8N_API_KEY`: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MjE0ZmE5OS1iYzM2LTQwNWUtYjU2Zi01MWI1MDk3N2IxZGIiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUyNTAyNTU0fQ.stkXNJ8HK7jKxMLeUOtw3bY1n-y6wm7Rq5dK6zgcaOY

### 2. Shopify MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/shopify-mcp-server`
- **Purpose:** E-commerce platform management, product catalog, orders, and store configuration.
- **MCP Client Configuration:**
```json
{
    "name": "shopify-mcp",
    "command": "node",
    "args": [
        "/root/vivid_mas/services/mcp-servers/shopify-mcp-server/build/index.js"
    ],
    "transport": "stdio"
}
```
- **Environment Variables:**
    - `SHOPIFY_STORE_URL`: Your Shopify store URL (e.g., `your-store.myshopify.com`).
    - `SHOPIFY_ACCESS_TOKEN`: Your Shopify Admin API access token.

### 3. Neo4j MCP Server
- **Status:** Partially Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/neo4j-mcp-server`
- **Purpose:** Knowledge graph and memory management.
- **MCP Client Configuration:**
```json
{
    "name": "neo4j-cypher-mcp",
    "command": "python",
    "args": [
        "-m",
        "mcp_neo4j_cypher"
    ],
    "cwd": "/root/vivid_mas/services/mcp-servers/neo4j-mcp-server",
    "transport": "stdio"
}
```
- **Environment Variables:**
    - `NEO4J_URI`: bolt://localhost:7687
    - `NEO4J_USER`: neo4j
    - `NEO4J_PASSWORD`: vivid_mas_neo4j_2024_password
    - `NEO4J_AUTH`: neo4j/vivid_mas_neo4j_2024_password
    - `NEO4J_AURA_CONNECTION_URI`: The connection URI for your Neo4j Aura instance.
    - `NEO4J_AURA_USERNAME`: The username for your Neo4j Aura instance.
    - `NEO4J_AURA_PASSWORD`: The password for your Neo4j Aura instance.

### 4. Stripe MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/stripe-mcp-server`
- **Purpose:** Payment processing.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:**
    - `STRIPE_API_KEY`: Your Stripe API key.

### 5. SendGrid MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/sendgrid-mcp-server`
- **Purpose:** Email marketing and transactional emails.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:**
    - `SENDGRID_API_KEY`: Your SendGrid API key.

### 6. Supabase MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/supabase-mcp-server`
- **Purpose:** Database management, authentication, and storage.
- **MCP Client Configuration:**
```json
{
    "name": "supabase-mcp",
    "command": "node",
    "args": [
        "/root/vivid_mas/services/mcp-servers/supabase-mcp-server/build/index.js"
    ],
    "transport": "stdio"
}
```
- **Environment Variables:**
    - `SUPABASE_URL`: https://supabase.vividwalls.blog
    - `SUPABASE_KEY`: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzQ5NjA0MDkxLCJleHAiOjIwNjQ5NjQwOTF9.I-ofdpcJwdSKKZ5rRN_DSnfp98iBH862UruU6XsNkcI
    - `SUPABASE_SERVICE_ROLE_KEY`: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw
    - `SUPABASE_ANON_KEY`: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzQ5NjA0MDkxLCJleHAiOjIwNjQ5NjQwOTF9.I-ofdpcJwdSKKZ5rRN_DSnfp98iBH862UruU6XsNkcI
    - `JWT_SECRET`: CMl9X2lC-ane2RR4xDtqPkDAkfQNooTOmMzfBYYcBts
    - `SUPABASE_DB_USER`: vividwalls_admin
    - `SUPABASE_DB_PASSWORD`: PoyzLpLg4xZH4GOQGfKFCNQ0pFe7Dvwq3WPTr6+d+SE=
    - `SUPABASE_DB_URL`: Your Supabase database connection URL.

### 7. WordPress MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/wordpress-mcp-server`
- **Purpose:** Content management for the Art of Space blog.
- **MCP Client Configuration:**
```json
{
    "name": "wordpress-mcp",
    "command": "node",
    "args": [
        "/root/vivid_mas/services/mcp-servers/wordpress-mcp-server/dist/index.js"
    ],
    "transport": "stdio"
}
```
- **Environment Variables:**
    - `WORDPRESS_API_URL`: https://wordpress.vividwalls.blog/wp-json/wp/v2
    - `WORDPRESS_USERNAME`: kingler-admin
    - `WORDPRESS_PASSWORD`: 17oHjUWbOs5k!A9J1u
    - `WORDPRESS_DB_PASSWORD`: myqP9lSMLobnuIfkUpXQzZg07
    - `WORDPRESS_DB_HOST`: wordpress-mysql
    - `WORDPRESS_DB_USER`: wordpress
    - `WORDPRESS_DB_NAME`: wordpress
    - `WORDPRESS_ADMIN_EMAIL`: admin@vividwalls.blog

### 8. Sync Manager
- **Status:** Undocumented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/core/sync-manager`
- **Purpose:** To be determined. Likely handles data synchronization between different services.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:** Not specified in a README.

---

## Sales & CRM

### 9. Sales CRM MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/sales/sales-crm-mcp-server`
- **Purpose:** Legacy customer relationship management, lead tracking, and sales pipeline analytics.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:**
    - `DB_HOST`: postgres
    - `DB_USER`: postgres
    - `DB_PASSWORD`: myqP9lSMLobnuIfkUpXQzZg07
    - `DB_NAME`: postgres

### 10. Twenty CRM MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/core/twenty-mcp-server`
- **Purpose:** Modern CRM platform for comprehensive customer relationship management, contact tracking, and sales pipeline management.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:**
    - `TWENTY_API_URL`: https://crm.vividwalls.blog/graphql
    - `TWENTY_API_TOKEN`: Your Twenty CRM API token.
    - `TWENTY_DB_PASSWORD`: twenty_password_secure_2024
    - `TWENTY_ACCESS_TOKEN_SECRET`: twenty_access_token_secret_vivid_mas_2024
    - `TWENTY_LOGIN_TOKEN_SECRET`: twenty_login_token_secret_vivid_mas_2024
    - `TWENTY_REFRESH_TOKEN_SECRET`: twenty_refresh_token_secret_vivid_mas_2024
    - `TWENTY_FILE_TOKEN_SECRET`: twenty_file_token_secret_vivid_mas_2024

### 11. Listmonk MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/core/listmonk-mcp-server`
- **Purpose:** Self-hosted email marketing platform for newsletters and campaigns.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:**
    - `LISTMONK_API_URL`: https://listmonk.vividwalls.blog/api
    - `LISTMONK_USERNAME`: admin_kb
    - `LISTMONK_PASSWORD`: #Freedom2025#
    - `LISTMONK_DB_PASSWORD`: listmonk_password_secure_2024

### 12. Email Marketing MCP Server
- **Status:** Undocumented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/core/email-marketing-mcp-server`
- **Purpose:** To be determined. Potentially a generic wrapper for email services like SendGrid or Listmonk.
- **MCP Client Configuration:**
```json
{
    "name": "email-marketing-mcp",
    "command": "python",
    "args": [
        "server.py"
    ],
    "cwd": "/root/vivid_mas/services/mcp-servers/email-marketing-mcp-server",
    "transport": "stdio"
}
```
- **Environment Variables:** Not specified in a README.

---

## Social Media Services

### 13. Facebook Ads MCP Server (Main)
- **Status:** Partially Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/social-media/facebook-ads-mcp-server`
- **Purpose:** General Facebook advertising management.
- **MCP Client Configuration:**
```json
{
    "name": "facebook-ads-mcp",
    "command": "python",
    "args": [
        "server.py"
    ],
    "cwd": "/root/vivid_mas/services/mcp-servers/facebook-ads-mcp-server",
    "transport": "stdio"
}
```
- **Environment Variables:**
    - `FACEBOOK_APP_ID`: Your Facebook App ID.
    - `FACEBOOK_APP_SECRET`: Your Facebook App Secret.
    - `FACEBOOK_ACCESS_TOKEN`: Your Facebook User Access Token.
    - `FACEBOOK_AD_ACCOUNT_ID`: Your Facebook Ad Account ID.

### 14. Pinterest MCP Server
- **Status:** Partially Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/social-media/pinterest-mcp-server`
- **Purpose:** Visual discovery platform for marketing and content scheduling.
- **MCP Client Configuration:**
```json
{
    "name": "pinterest-mcp",
    "command": "python",
    "args": [
        "server.py"
    ],
    "cwd": "/root/vivid_mas/services/mcp-servers/pinterest-mcp-server",
    "transport": "stdio"
}
```
- **Environment Variables:** Not specified in a README.

---

## Creative Services

### 15. Figma MCP Server
- **Status:** Partially Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/creative/figma`
- **Purpose:** Design collaboration and asset management.
- **MCP Client Configuration:**
```json
{
    "name": "figma-mcp",
    "command": "node",
    "args": [
        "/Users/kinglerbercy/Projects/vivid_mas/services/mcp-servers/creative/figma/index.js"
    ],
    "env": {
        "FIGMA_ACCESS_TOKEN": "figd_4VVax6a090cbpCW0ysCVRdYDfm7qqWGvwUlHp_fs"
    }
}
```
- **Environment Variables:**
    - `FIGMA_ACCESS_TOKEN`: figd_4VVax6a090cbpCW0ysCVRdYDfm7qqWGvwUlHp_fs

### 16. Pictorem MCP Server
- **Status:** Partially Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/creative/pictorem-mcp-server`
- **Purpose:** Print-on-demand services and order fulfillment.
- **MCP Client Configuration:**
```json
{
    "name": "pictorem-mcp",
    "command": "node",
    "args": [
        "/root/vivid_mas/services/mcp-servers/pictorem-mcp-server/dist/index.js"
    ],
    "transport": "stdio"
}
```
- **Environment Variables:** Not specified in a README.

---

## Research & Analytics

### 17. Marketing Analytics Aggregator MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/analytics/marketing-analytics-aggregator`
- **Purpose:** Aggregates marketing data from multiple sources (Listmonk, Facebook, Instagram, Google Analytics, Twenty CRM) for comprehensive analysis and reporting.
- **MCP Client Configuration:**
```json
{
    "name": "marketing-analytics-aggregator",
    "command": "node",
    "args": [
        "/root/vivid_mas/services/mcp-servers/analytics/marketing-analytics-aggregator/dist/index.js"
    ],
    "transport": "stdio"
}
```
- **Environment Variables:**
    - `LISTMONK_API_URL`: Listmonk API endpoint
    - `LISTMONK_USERNAME`: Listmonk username
    - `LISTMONK_PASSWORD`: #Freedom2025#
    - `FACEBOOK_ACCESS_TOKEN`: Facebook Business API token
    - `INSTAGRAM_ACCESS_TOKEN`: Instagram Business API token
    - `TWENTY_API_URL`: Twenty CRM API endpoint
    - `TWENTY_API_TOKEN`: Twenty CRM API token
    - `SUPABASE_URL`: https://supabase.vividwalls.blog
    - `SUPABASE_ANON_KEY`: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzQ5NjA0MDkxLCJleHAiOjIwNjQ5NjQwOTF9.I-ofdpcJwdSKKZ5rRN_DSnfp98iBH862UruU6XsNkcI
- **Available Resources:**
    - `campaign-performance`: Aggregated campaign performance metrics
    - `customer-segments`: Customer segmentation analysis
    - `channel-attribution`: Multi-channel attribution report
    - `market-trends`: Market trends and analysis
    - `executive-summary`: Executive dashboard summary
- **Available Tools:**
    - `generate-research-report`: Generate comprehensive marketing research reports
    - `store-report-supabase`: Store generated reports in Supabase
- **Used By:** Marketing Research Agent, Marketing Director Agent, Data Analytics Agent

### 19. SEO Research MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/research/seo-research-mcp`
- **Purpose:** Search engine optimization, keyword research, backlink analysis, SERP analysis, and competitor intelligence.
- **MCP Client Configuration:**
```json
{
    "name": "seo-research-mcp",
    "command": "node",
    "args": [
        "/root/vivid_mas/services/mcp-servers/research/seo-research-mcp/dist/index.js"
    ],
    "transport": "stdio"
}
```
- **Environment Variables:**
    - `DATAFORSEO_API_KEY`: DataForSEO API credentials (format: `email:password`)
    - `DATAFORSEO_BASE_URL`: DataForSEO API base URL (default: `https://api.dataforseo.com/v3`)
    - `LOG_LEVEL`: Logging level (default: `info`)
- **Available Tools:**
    - `health_check`: Check server health and API configuration status
    - `keyword_research`: Research keywords with search volume, CPC, and competition data
    - `backlink_analysis`: Analyze backlinks for domains/URLs with authority metrics
    - `serp_analysis`: Analyze SERP results for keywords with ranking positions
    - `dataforseo_connection_test`: Test DataForSEO API connectivity
- **Used By:** Content Strategy Agent, Marketing Director Agent, Marketing Research Agent

### 20. Tavily MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/research/tavily-mcp`
- **Purpose:** Advanced web search and research compilation.
- **MCP Client Configuration:**
```json
{
    "name": "tavily-mcp",
    "command": "node",
    "args": [
        "/root/vivid_mas/services/mcp-servers/tavily-mcp/build/index.js"
    ],
    "transport": "stdio"
}
```
- **Environment Variables:**
    - `TAVILY_API_KEY`: Your Tavily API key.

### 21. Crawl4AI RAG MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/mcp-crawl4ai-rag`
- **Purpose:** Web scraping and content extraction for Retrieval-Augmented Generation.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:**
    - `OPENAI_API_KEY`: Your OpenAI API key.
    - `SUPABASE_URL`: https://supabase.vividwalls.blog
    - `SUPABASE_SERVICE_KEY`: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw

### 22. PDF to Text MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/pdf-to-text-mcp`
- **Purpose:** Extracts text content from PDF files.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:** None.

---

## Agent-Specific Prompt & Resource Servers

This category includes servers that provide standardized prompt templates and data resources for specific AI agents, enabling consistent and scalable agent behavior.

### 23. Business Manager Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/agents/business-manager-prompts`, `/root/vivid_mas/services/mcp-servers/agents/business-manager-resource`
- **Purpose:** Provides standardized prompts and resources for the Business Manager Agent.
- **MCP Client Configuration:** Not defined in `mcp.json`.
- **Environment Variables:** None.

### 24. Data Analytics Prompts MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/agents/data-analytics-prompts`
- **Purpose:** Provides specialized data analysis prompt templates for the Data Analytics Agent.
- **MCP Client Configuration:**
```json
{
    "name": "data-analytics-prompts",
    "command": "node",
    "args": [
        "/root/vivid_mas/services/mcp-servers/agents/data-analytics-prompts/dist/index.js"
    ],
    "transport": "stdio"
}
```
- **Environment Variables:** None
- **Available Prompts:**
    - `analyze-performance-trends`: Analyze performance trends across metrics and time periods
    - `generate-kpi-dashboard`: Generate executive KPI dashboard summary
    - `segment-analysis`: Perform detailed customer or product segmentation
    - `anomaly-detection`: Detect and analyze anomalies in business metrics
    - `cohort-analysis`: Analyze customer cohorts for retention and value patterns
    - `competitive-benchmarking`: Benchmark performance against industry standards
    - `forecasting-analysis`: Generate forecasts based on historical data
    - `channel-attribution`: Analyze multi-channel attribution and effectiveness
    - `data-quality-assessment`: Assess data quality and identify improvements
    - `executive-summary`: Create executive summary of business performance
- **Used By:** Data Analytics Agent

### 25. Data Analytics Resource MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/root/vivid_mas/services/mcp-servers/agents/data-analytics-resource`
- **Purpose:** Provides pre-computed analytics resources and real-time metrics for the Data Analytics Agent.
- **MCP Client Configuration:**
```json
{
    "name": "data-analytics-resource",
    "command": "ssh",
    "args": [
        "-i",
        "~/.ssh/digitalocean",
        "root@157.230.13.13",
        "cd /root/vivid_mas/services/mcp-servers/agents/data-analytics-resource && node dist/index.js"
    ]
}
```
- **Environment Variables:**
    - `SUPABASE_URL`: https://supabase.vividwalls.blog
    - `SUPABASE_ANON_KEY`: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzQ5NjA0MDkxLCJleHAiOjIwNjQ5NjQwOTF9.I-ofdpcJwdSKKZ5rRN_DSnfp98iBH862UruU6XsNkcI
- **Available Resources:**
    - `business-health-score`: Overall business health metric (0-100) based on multiple KPIs
    - `real-time-metrics`: Current performance metrics updated in real-time
    - `kpi-summary`: Executive summary of key performance indicators
    - `alerts-and-anomalies`: Active alerts and detected anomalies
    - `performance-benchmarks`: VividWalls metrics vs industry benchmarks
    - `data-catalog`: Available data sources and their current status
- **Used By:** Data Analytics Agent, Business Manager Agent, Director-level Agents

---

## Deprecated/Removed Servers

This section lists servers that were present in previous documentation but are no longer found in the project's directory structure.

| Server | Status    | Notes                                                              |
| ------ | --------- | ------------------------------------------------------------------ |
| Linear | Deprecated | This server for project management is no longer part of the project. |

---
*(The rest of the document, including Agent-Tool Mapping and Invocation Scenarios, would follow, updated to reflect the new, accurate server list.)*