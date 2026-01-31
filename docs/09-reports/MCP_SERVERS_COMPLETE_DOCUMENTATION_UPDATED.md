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
10. [Analytics & Monitoring](#analytics--monitoring)
11. [Communication & Collaboration](#communication--collaboration)
12. [Specialized Tools](#specialized-tools)
13. [Deployment & Testing Notes](#deployment--testing-notes)
14. [Deprecated/Removed Servers](#deprecatedremoved-servers)
15. [Agent-Tool Mapping](#agent-tool-mapping)

**MCP-Client Node Convention**
Every Task-oriented agent uses the `n8n-nodes-mcp` **MCP Client** node in **two modes**:

| Node Type      | Purpose                                      |
| -------------- | -------------------------------------------- |
| **List Tools** | Discover the available tools for a given MCP server |
| **Execute Tool** | Invoke a selected tool with parameters       |

These two nodes must be present for *each* MCP server referenced below.

## MCP Server Deployment Standard

As per project convention, all MCP servers are designed to be deployed on the DigitalOcean droplet under the `/opt/mcp-servers/` directory. The deployment location for each server listed below follows this standard, with each server residing in its own subdirectory.

## Important: Environment Variable Configuration

### For n8n MCP Client Node Usage

**The `${VARIABLE_NAME}` syntax is NOT supported in n8n MCP Client node configurations.** You must use one of these approaches:

1. **Direct Values**: Enter actual credential values in the `env` object
2. **Docker Environment Variables**: Use `MCP_` prefix when running n8n in Docker:

   ```yaml
   environment:
     - MCP_LISTMONK_PASSWORD=your-actual-password
     - MCP_SHOPIFY_ACCESS_TOKEN=your-token
   ```

3. **n8n Credential Overwrites**: Use `CREDENTIALS_OVERWRITE_DATA` for bulk credential management

### Security Best Practices

- Never commit actual credentials to version control
- Use n8n's built-in credential management system
- For production, use environment variables on the host system
- Rotate credentials regularly

## MCP Server Categories

This list is generated based on the current directory structure at `services/mcp-servers/` and serves as the source of truth for all existing MCP servers.

---

## Core Services

### 1. n8n MCP Server

- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/n8n-mcp-server`
- **Purpose:** Workflow automation, agent orchestration, and process management.
- **MCP Client Configuration:**

```json
{
    "name": "n8n-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/n8n-mcp-server/dist/index.js"
    ],
    "env": {
        "N8N_API_URL": "http://157.230.13.13:5678/api/v1",
        "N8N_API_KEY": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZDAxYzZjZC1lNjY5LTQ4YWQtYTY5ZS1mMDU0YTY4NjU1YzQiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzUwNDQ5MzEzfQ.uBJrDT3a0pQdA5hA28Zf5egmhFLryv8DUNLvsoleXcs"
    }
}
```

- **Environment Variables:**

- `N8N_API_URL`: http://157.230.13.13:5678/api/v1
- `N8N_API_KEY`: Your n8n API key (JWT token)

### 2. Shopify MCP Server

- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/shopify-mcp-server`
- **Purpose:** E-commerce platform management, product catalog, orders, and store configuration.

- **MCP Client Configuration:**

```json
{
    "name": "shopify-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/shopify-mcp-server/build/index.js"
    ],
    "env": {
        "SHOPIFY_STORE_URL": "vividwalls-2.myshopify.com",
        "SHOPIFY_ACCESS_TOKEN": "***REMOVED***"
    }
}
```

- **Environment Variables:**

    - `SHOPIFY_STORE_URL`: vividwalls-2.myshopify.com
    - `SHOPIFY_ACCESS_TOKEN`: ***REMOVED***

### 3. Neo4j MCP Server

- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/neo4j-mcp-server`
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
    "cwd": "/opt/mcp-servers/neo4j-mcp-server",
    "env": {
        "NEO4J_URI": "bolt://vividwalls-neo4j:7687",
        "NEO4J_USER": "neo4j",
        "NEO4J_PASSWORD": "vividwalls2024",
        "NEO4J_DATABASE": "neo4j",
        "NEO4J_EXTERNAL_URI": "bolt://157.230.13.13:7687"
    }
}
```

- **Environment Variables:**

    - `NEO4J_URI`: bolt://vividwalls-neo4j:7687 (internal)
    - `NEO4J_USER`: neo4j
    - `NEO4J_PASSWORD`: vividwalls2024
    - `NEO4J_DATABASE`: neo4j
    - `NEO4J_EXTERNAL_URI`: bolt://157.230.13.13:7687 (external access)

### 4. Stripe MCP Server

- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/stripe-mcp-server`
- **Purpose:** Payment processing.
- **MCP Client Configuration:**

```json
{
    "name": "stripe-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/stripe-mcp-server/dist/index.js"
    ],
    "env": {
        "STRIPE_API_KEY": "${STRIPE_API_KEY}"
    }
}
```

- **Environment Variables:**
    - `STRIPE_API_KEY`: Your Stripe API key.

### 5. SendGrid MCP Server

- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/sendgrid-mcp-server`
- **Purpose:** Email marketing and transactional emails.
- **MCP Client Configuration:**

```json
{
    "name": "sendgrid-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/sendgrid-mcp-server/dist/index.js"
    ],
    "env": {
        "SENDGRID_API_KEY": "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",
        "TWILIO_ACCOUNT_SID": "AC8163659c173e8a5640ab0de6d3f6ea4e",
        "TWILIO_AUTH_TOKEN": "716c5da0974b59f1ab2ed3754b35c52a",
        "TWILIO_PHONE_NUMBER": "+18556202206"
    }
}
```

- **Environment Variables:**
- `SENDGRID_API_KEY`: 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
- `TWILIO_ACCOUNT_SID`: AC8163659c173e8a5640ab0de6d3f6ea4e (for SMS features)
- `TWILIO_AUTH_TOKEN`: 716c5da0974b59f1ab2ed3754b35c52a
- `TWILIO_PHONE_NUMBER`: +18556202206

### 6. Supabase MCP Server

- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/supabase-mcp-server`
- **Purpose:** Database management, authentication, and storage.
- **MCP Client Configuration:**

```json
{
    "name": "supabase-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/supabase-mcp-server/build/index.js"
    ],
    "env": {
        "SUPABASE_URL": "https://supabase.vividwalls.blog",
        "SUPABASE_KEY": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzQ5NjA0MDkxLCJleHAiOjIwNjQ5NjQwOTF9.I-ofdpcJwdSKKZ5rRN_DSnfp98iBH862UruU6XsNkcI",
        "SUPABASE_SERVICE_ROLE_KEY": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw",
        "POSTGRES_PASSWORD": "myqP9lSMLobnuIfkUpXQzZg07"
    }
}
```
- **Environment Variables:**
    - `SUPABASE_URL`: https://supabase.vividwalls.blog
    - `SUPABASE_KEY`: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzQ5NjA0MDkxLCJleHAiOjIwNjQ5NjQwOTF9.I-ofdpcJwdSKKZ5rRN_DSnfp98iBH862UruU6XsNkcI
    - `SUPABASE_SERVICE_ROLE_KEY`: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw
    - `POSTGRES_PASSWORD`: myqP9lSMLobnuIfkUpXQzZg07

### 7. WordPress MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/wordpress-mcp-server`
- **Purpose:** Content management for the Art of Space blog.
- **MCP Client Configuration:**
```json
{
    "name": "wordpress-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/wordpress-mcp-server/dist/index.js"
    ],
    "env": {
        "WORDPRESS_URL": "https://wordpress.vividwalls.blog/",
        "WORDPRESS_USERNAME": "kingler-admin",
        "WORDPRESS_PASSWORD": "TempPass123!",
        "ART_OF_SPACE_BRAND": "Art of Space",
        "ART_OF_SPACE_CONTACT_EMAIL": "kingler@mvividwalls.co"
    }
}
```
- **Environment Variables:**
    - `WORDPRESS_URL`: https://wordpress.vividwalls.blog/
    - `WORDPRESS_USERNAME`: kingler-admin
    - `WORDPRESS_PASSWORD`: TempPass123!
    - `ART_OF_SPACE_BRAND`: Art of Space
    - `ART_OF_SPACE_CONTACT_EMAIL`: kingler@mvividwalls.co

### 8. Sync Manager
- **Status:** Partially Documented
- **Deployment Location:** `/opt/mcp-servers/core/sync-manager`
- **Purpose:** Handles data synchronization between different services.
- **MCP Client Configuration:**
```json
{
    "name": "sync-manager-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/core/sync-manager/index.js"
    ]
}
```

---

## Sales & CRM

### 9. Sales CRM MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/sales/sales-crm-mcp-server`
- **Purpose:** Legacy customer relationship management, lead tracking, and sales pipeline analytics.
- **MCP Client Configuration:**
```json
{
    "name": "sales-crm-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/sales/sales-crm-mcp-server/dist/index.js"
    ],
    "env": {
        "DB_HOST": "${DB_HOST}",
        "DB_USER": "${DB_USER}",
        "DB_PASSWORD": "${DB_PASSWORD}",
        "DB_NAME": "${DB_NAME}"
    }
}
```
- **Environment Variables:**
    - `DB_HOST`: Your database host.
    - `DB_USER`: Your database user.
    - `DB_PASSWORD`: Your database password.
    - `DB_NAME`: Your database name.

### 10. Twenty CRM MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/core/twenty-mcp-server`
- **Purpose:** Modern CRM platform for comprehensive customer relationship management, contact tracking, and sales pipeline management.
- **MCP Client Configuration:**
```json
{
    "name": "twenty-crm-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/core/twenty-mcp-server/dist/index.js"
    ],
    "env": {
        "TWENTY_API_URL": "https://crm.vividwalls.blog",
        "TWENTY_API_KEY": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxZmI5ZmUyMy01MTNjLTQ4NzQtOTVkYi1hOTgwZjMwMGMxYzgiLCJ0eXBlIjoiQVBJX0tFWSIsIndvcmtzcGFjZUlkIjoiMWZiOWZlMjMtNTEzYy00ODc0LTk1ZGItYTk4MGYzMDBjMWM4IiwiaWF0IjoxNzUxMTUzNzk4LCJleHAiOjQ5MDQ3NTM3OTcsImp0aSI6IjRjZjRiNWU1LWMwMDktNGQxNy04MjVmLWJmYjQ1YzkxMGNlOSJ9.WyX0eBJ5PdY21gWEQ7nBsy172sXY4lEt8J6kxvfVwWY"
    }
}
```
- **Environment Variables:**
    - `TWENTY_API_URL`: https://crm.vividwalls.blog
    - `TWENTY_API_KEY`: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxZmI5ZmUyMy01MTNjLTQ4NzQtOTVkYi1hOTgwZjMwMGMxYzgiLCJ0eXBlIjoiQVBJX0tFWSIsIndvcmtzcGFjZUlkIjoiMWZiOWZlMjMtNTEzYy00ODc0LTk1ZGItYTk4MGYzMDBjMWM4IiwiaWF0IjoxNzUxMTUzNzk4LCJleHAiOjQ5MDQ3NTM3OTcsImp0aSI6IjRjZjRiNWU1LWMwMDktNGQxNy04MjVmLWJmYjQ1YzkxMGNlOSJ9.WyX0eBJ5PdY21gWEQ7nBsy172sXY4lEt8J6kxvfVwWY

### 11. Listmonk MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/core/listmonk-mcp-server`
- **Purpose:** Self-hosted email marketing platform for newsletters and campaigns.
- **MCP Client Configuration:**
```json
{
    "name": "listmonk-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/core/listmonk-mcp-server/dist/index.js"
    ],
    "env": {
        "LISTMONK_URL": "http://localhost:9003",
        "LISTMONK_USERNAME": "admin",
        "LISTMONK_PASSWORD": "admin123"
    }
}
```
- **Environment Variables:**
    - `LISTMONK_URL`: http://localhost:9003
    - `LISTMONK_USERNAME`: admin
    - `LISTMONK_PASSWORD`: admin123

### 12. Email Marketing MCP Server
- **Status:** Partially Documented
- **Deployment Location:** `/opt/mcp-servers/core/email-marketing-mcp-server`
- **Purpose:** Generic wrapper for email services integration.
- **MCP Client Configuration:**
```json
{
    "name": "email-marketing-mcp",
    "command": "python",
    "args": [
        "/opt/mcp-servers/email-marketing-mcp-server/server.py"
    ],
    "env": {
        "SENDGRID_API_KEY": "${SENDGRID_API_KEY}",
        "SMTP_HOST": "${SMTP_HOST}",
        "SMTP_PORT": "${SMTP_PORT}",
        "SMTP_USER": "${SMTP_USER}",
        "SMTP_PASS": "${SMTP_PASS}"
    }
}
```

---

## Social Media Services

### 13. Facebook Ads MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/social-media/facebook-ads-mcp-server`
- **Purpose:** Facebook advertising management and campaign optimization.
- **MCP Client Configuration:**
```json
{
    "name": "facebook-ads-mcp",
    "command": "python",
    "args": [
        "/opt/mcp-servers/social-media/facebook-ads-mcp-server/server.py"
    ],
    "env": {
        "FB_APP_ID": "1043439837544028",
        "FB_APP_SECRET": "5ec4cca6bade03e5992abb4b2af05cba",
        "FB_ACCESS_TOKEN": "EAAO1AMTcflwBOyk95KCV5szZCXKMx63njHgdf1eDfI0YZCQYG0FsXyRgmQhIpHNPdZBWG7rtVHKWjGpZAQWMgAlipMYOdCJ4ac2xWelfBrL0XBYMZCflSzfapGjjYKOXeofmVyrkUof34MKpCxkfrAsUjB4xItXqinifBv9CcpzvGCAMiMmminx61pAu6hwHyy8r6And0QogYWdgRu8XZBLpuV",
        "FB_AD_ACCOUNT_ID": "777751590847461"
    }
}
```
- **Environment Variables:**
    - `FB_APP_ID`: 1043439837544028
    - `FB_APP_SECRET`: 5ec4cca6bade03e5992abb4b2af05cba
    - `FB_ACCESS_TOKEN`: EAAO1AMTcflwBOyk95KCV5szZCXKMx63njHgdf1eDfI0YZCQYG0FsXyRgmQhIpHNPdZBWG7rtVHKWjGpZAQWMgAlipMYOdCJ4ac2xWelfBrL0XBYMZCflSzfapGjjYKOXeofmVyrkUof34MKpCxkfrAsUjB4xItXqinifBv9CcpzvGCAMiMmminx61pAu6hwHyy8r6And0QogYWdgRu8XZBLpuV
    - `FB_AD_ACCOUNT_ID`: 777751590847461

### 14. Pinterest MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/social-media/pinterest-mcp-server`
- **Purpose:** Visual discovery platform for marketing and content scheduling.
- **MCP Client Configuration:**
```json
{
    "name": "pinterest-mcp",
    "command": "python",
    "args": [
        "/opt/mcp-servers/social-media/pinterest-mcp-server/server.py"
    ],
    "env": {
        "PINTEREST_ACCESS_TOKEN": "${PINTEREST_ACCESS_TOKEN}",
        "PINTEREST_APP_ID": "${PINTEREST_APP_ID}",
        "PINTEREST_APP_SECRET": "${PINTEREST_APP_SECRET}"
    }
}
```
- **Environment Variables:**
    - `PINTEREST_ACCESS_TOKEN`: Your Pinterest access token.
    - `PINTEREST_APP_ID`: Your Pinterest App ID.
    - `PINTEREST_APP_SECRET`: Your Pinterest App Secret.

### 15. Instagram MCP Server
- **Status:** Partially Documented
- **Deployment Location:** `/opt/mcp-servers/social-media/instagram-mcp-server`
- **Purpose:** Instagram content management and analytics.
- **MCP Client Configuration:**
```json
{
    "name": "instagram-mcp",
    "command": "python",
    "args": [
        "/opt/mcp-servers/social-media/instagram-mcp-server/server.py"
    ],
    "env": {
        "INSTAGRAM_APP_NAME": "vivid_mas-IG",
        "INSTAGRAM_APP_ID": "612135724855411",
        "INSTAGRAM_APP_SECRET": "ab1bbcf405be0f36b013ae41db1aa52a",
        "FACEBOOK_ACCESS_TOKEN": "EAAO1AMTcflwBOyk95KCV5szZCXKMx63njHgdf1eDfI0YZCQYG0FsXyRgmQhIpHNPdZBWG7rtVHKWjGpZAQWMgAlipMYOdCJ4ac2xWelfBrL0XBYMZCflSzfapGjjYKOXeofmVyrkUof34MKpCxkfrAsUjB4xItXqinifBv9CcpzvGCAMiMmminx61pAu6hwHyy8r6And0QogYWdgRu8XZBLpuV"
    }
}
```
- **Environment Variables:**
    - `INSTAGRAM_APP_NAME`: vivid_mas-IG
    - `INSTAGRAM_APP_ID`: 612135724855411
    - `INSTAGRAM_APP_SECRET`: ab1bbcf405be0f36b013ae41db1aa52a
    - `FACEBOOK_ACCESS_TOKEN`: Uses the same Facebook access token

---

## Creative Services

### 16. Figma MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/creative/figma`
- **Purpose:** Design collaboration and asset management.
- **MCP Client Configuration:**
```json
{
    "name": "figma-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/creative/figma/index.js"
    ],
    "env": {
        "FIGMA_ACCESS_TOKEN": "figd_4VVax6a090cbpCW0ysCVRdYDfm7qqWGvwUlHp_fs"
    }
}
```
- **Environment Variables:**
    - `FIGMA_ACCESS_TOKEN`: figd_4VVax6a090cbpCW0ysCVRdYDfm7qqWGvwUlHp_fs

### 17. Pictorem MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/creative/pictorem-mcp-server`
- **Purpose:** Print-on-demand services and order fulfillment.
- **MCP Client Configuration:**
```json
{
    "name": "pictorem-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/creative/pictorem-mcp-server/dist/index.js"
    ],
    "env": {
        "PICTOREM_USERNAME": "kingler@me.com",
        "PICTOREM_PASSWORD": "#Freedom2023#",
        "HEADLESS": "true"
    }
}
```
- **Environment Variables:**
    - `PICTOREM_USERNAME`: kingler@me.com
    - `PICTOREM_PASSWORD`: #Freedom2023#
    - `HEADLESS`: true (for production)

---

## Research & Analytics

### 18. SEO Research MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/research/seo-research-mcp`
- **Purpose:** Search engine optimization, keyword research, backlink analysis, SERP analysis, and competitor intelligence.
- **MCP Client Configuration:**
```json
{
    "name": "seo-research-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/research/seo-research-mcp/dist/index.js"
    ],
    "env": {
        "DATAFORSEO_API_KEY": "kingler@vividwalls.co:63e2b2fca6af8eac",
        "DATAFORSEO_BASE_URL": "https://api.dataforseo.com/v3",
        "LOG_LEVEL": "info"
    }
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

### 19. Tavily MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/research/tavily-mcp`
- **Purpose:** Advanced web search and research compilation.
- **MCP Client Configuration:**
```json
{
    "name": "tavily-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/research/tavily-mcp/build/index.js"
    ],
    "env": {
        "TAVILY_API_KEY": "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",
        "TAVILY_BASE_URL": "https://api.tavily.com/search",
        "TAVILY_EXTRACT_URL": "https://api.tavily.com/extract"
    }
}
```
- **Environment Variables:**
    - `TAVILY_API_KEY`: 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
    - `TAVILY_BASE_URL`: https://api.tavily.com/search
    - `TAVILY_EXTRACT_URL`: https://api.tavily.com/extract

### 20. Crawl4AI RAG MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/mcp-crawl4ai-rag`
- **Purpose:** Web scraping and content extraction for Retrieval-Augmented Generation.
- **MCP Client Configuration:**
```json
{
    "name": "crawl4ai-rag-mcp",
    "command": "python",
    "args": [
        "/opt/mcp-servers/mcp-crawl4ai-rag/server.py"
    ],
    "env": {
        "OPENAI_API_KEY": "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",
        "SUPABASE_URL": "https://supabase.vividwalls.blog",
        "SUPABASE_SERVICE_KEY": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw"
    }
}
```
- **Environment Variables:**
    - `OPENAI_API_KEY`: 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
    - `SUPABASE_URL`: https://supabase.vividwalls.blog
    - `SUPABASE_SERVICE_KEY`: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw

### 21. PDF to Text MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/pdf-to-text-mcp`
- **Purpose:** Extracts text content from PDF files.
- **MCP Client Configuration:**
```json
{
    "name": "pdf-to-text-mcp",
    "command": "python",
    "args": [
        "/opt/mcp-servers/pdf-to-text-mcp/server.py"
    ]
}
```
- **Environment Variables:** None required.

---

## Development & Infrastructure

### 22. GitHub MCP Server
- **Status:** Partially Documented
- **Deployment Location:** `/opt/mcp-servers/dev/github-mcp-server`
- **Purpose:** Repository management and CI/CD automation.
- **MCP Client Configuration:**
```json
{
    "name": "github-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/dev/github-mcp-server/dist/index.js"
    ],
    "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}",
        "GITHUB_OWNER": "${GITHUB_OWNER}",
        "GITHUB_REPO": "${GITHUB_REPO}"
    }
}
```

### 23. Docker MCP Server
- **Status:** Partially Documented
- **Deployment Location:** `/opt/mcp-servers/dev/docker-mcp-server`
- **Purpose:** Container management and deployment automation.
- **MCP Client Configuration:**
```json
{
    "name": "docker-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/dev/docker-mcp-server/dist/index.js"
    ],
    "env": {
        "DOCKER_HOST": "${DOCKER_HOST}",
        "DOCKER_CERT_PATH": "${DOCKER_CERT_PATH}"
    }
}
```

---

## Agent-Specific Prompt & Resource Servers

This category includes servers that provide standardized prompt templates and data resources for specific AI agents, enabling consistent and scalable agent behavior.

### 24. Business Manager Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/business-manager-prompts`, `/opt/mcp-servers/agents/business-manager-resource`
- **Purpose:** Provides standardized prompts and resources for the Business Manager Agent.
- **MCP Client Configuration:**
```json
{
    "name": "business-manager-prompts-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/business-manager-prompts/dist/index.js"
    ]
}
```
```json
{
    "name": "business-manager-resource-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/business-manager-resource/dist/index.js"
    ]
}
```

### 25. Marketing Director Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/marketing-director-prompts`, `/opt/mcp-servers/agents/marketing-director-resource`
- **Purpose:** Provides standardized prompts and resources for the Marketing Director Agent.
- **MCP Client Configuration:**
```json
{
    "name": "marketing-director-prompts-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/marketing-director-prompts/dist/index.js"
    ]
}
```
```json
{
    "name": "marketing-director-resource-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/marketing-director-resource/dist/index.js"
    ]
}
```

### 26. Creative Director Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/creative-director-prompts`, `/opt/mcp-servers/agents/creative-director-resource`
- **Purpose:** Provides standardized prompts and resources for the Creative Director Agent.
- **MCP Client Configuration:**
```json
{
    "name": "creative-director-prompts-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/creative-director-prompts/dist/index.js"
    ]
}
```
```json
{
    "name": "creative-director-resource-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/creative-director-resource/dist/index.js"
    ]
}
```

### 27. Content Strategy Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/content-strategy-prompts`, `/opt/mcp-servers/agents/content-strategy-resource`
- **Purpose:** Provides tools for content planning, calendar creation, and content performance analysis.
- **MCP Client Configuration:**
```json
{
    "name": "content-strategy-prompts-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/content-strategy-prompts/dist/index.js"
    ]
}
```
```json
{
    "name": "content-strategy-resource-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/content-strategy-resource/dist/index.js"
    ]
}
```

### 28. Copy Editor Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/copy-editor-prompts`, `/opt/mcp-servers/agents/copy-editor-resource`
- **Purpose:** Provides copy editing, grammar checking, and brand voice alignment tools.
- **MCP Client Configuration:**
```json
{
    "name": "copy-editor-prompts-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/copy-editor-prompts/dist/index.js"
    ]
}
```
```json
{
    "name": "copy-editor-resource-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/copy-editor-resource/dist/index.js"
    ]
}
```

### 29. Copy Writer Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/copy-writer-prompts`, `/opt/mcp-servers/agents/copy-writer-resource`
- **Purpose:** Provides tools for creating compelling marketing copy across various channels.
- **MCP Client Configuration:**
```json
{
    "name": "copy-writer-prompts-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/copy-writer-prompts/dist/index.js"
    ]
}
```
```json
{
    "name": "copy-writer-resource-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/copy-writer-resource/dist/index.js"
    ]
}
```

### 30. Email Marketing Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/email-marketing-prompts`, `/opt/mcp-servers/agents/email-marketing-resource`
- **Purpose:** Provides email campaign creation, A/B testing, and performance optimization tools.
- **MCP Client Configuration:**
```json
{
    "name": "email-marketing-prompts-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/email-marketing-prompts/dist/index.js"
    ]
}
```
```json
{
    "name": "email-marketing-resource-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/email-marketing-resource/dist/index.js"
    ]
}
```

### 31. Keyword Agent Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/keyword-agent-prompts`, `/opt/mcp-servers/agents/keyword-agent-resource`
- **Purpose:** Provides SEO keyword research, analysis, and competitor keyword tracking tools.
- **MCP Client Configuration:**
```json
{
    "name": "keyword-agent-prompts-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/keyword-agent-prompts/dist/index.js"
    ]
}
```
```json
{
    "name": "keyword-agent-resource-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/keyword-agent-resource/dist/index.js"
    ]
}
```

### 32. Marketing Campaign Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/marketing-campaign-prompts`, `/opt/mcp-servers/agents/marketing-campaign-resource`
- **Purpose:** Provides comprehensive campaign planning, coordination, and tracking tools.
- **MCP Client Configuration:**
```json
{
    "name": "marketing-campaign-prompts-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/marketing-campaign-prompts/dist/index.js"
    ]
}
```
```json
{
    "name": "marketing-campaign-resource-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/marketing-campaign-resource/dist/index.js"
    ]
}
```

### 33. Social Media Director Prompts & Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/social-media-director-prompts`, `/opt/mcp-servers/agents/social-media-director-resource`
- **Purpose:** Provides social media strategy orchestration and multi-platform management tools.
- **MCP Client Configuration:**
```json
{
    "name": "social-media-director-prompts-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/social-media-director-prompts/dist/index.js"
    ]
}
```
```json
{
    "name": "social-media-director-resource-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/social-media-director-resource/dist/index.js"
    ],
    "env": {
        "SUPABASE_URL": "${SUPABASE_URL}",
        "SUPABASE_SERVICE_ROLE_KEY": "${SUPABASE_SERVICE_ROLE_KEY}"
    }
}
```

### 34. Sales Director Prompts & Resource
- **Status:** Partially Documented
- **Deployment Location:** `/opt/mcp-servers/agents/sales-director-prompts`, `/opt/mcp-servers/agents/sales-director-resource`
- **Purpose:** Provides standardized prompts and resources for the Sales Director Agent.
- **MCP Client Configuration:**
```json
{
    "name": "sales-director-prompts-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/sales-director-prompts/dist/index.js"
    ]
}
```
```json
{
    "name": "sales-director-resource-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/sales-director-resource/dist/index.js"
    ]
}
```

---

## Analytics & Monitoring

### 35. Analytics Dashboard MCP Server
- **Status:** Partially Documented
- **Deployment Location:** `/opt/mcp-servers/analytics/dashboard-mcp-server`
- **Purpose:** Real-time business metrics and KPI monitoring.
- **MCP Client Configuration:**
```json
{
    "name": "analytics-dashboard-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/analytics/dashboard-mcp-server/dist/index.js"
    ],
    "env": {
        "SUPABASE_URL": "${SUPABASE_URL}",
        "SUPABASE_SERVICE_ROLE_KEY": "${SUPABASE_SERVICE_ROLE_KEY}"
    }
}
```

### 36. Performance Metrics MCP Server
- **Status:** Partially Documented
- **Deployment Location:** `/opt/mcp-servers/analytics/performance-metrics-mcp`
- **Purpose:** System performance monitoring and optimization.
- **MCP Client Configuration:**
```json
{
    "name": "performance-metrics-mcp",
    "command": "python",
    "args": [
        "/opt/mcp-servers/analytics/performance-metrics-mcp/server.py"
    ],
    "env": {
        "PROMETHEUS_URL": "${PROMETHEUS_URL}",
        "GRAFANA_API_KEY": "${GRAFANA_API_KEY}"
    }
}
```

### 37. Marketing Analytics Aggregator
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/analytics/marketing-analytics-aggregator`
- **Purpose:** Aggregates marketing data from multiple sources (Listmonk, Facebook, Instagram, Twenty CRM, Shopify, Google Analytics) for comprehensive analytics reporting.
- **MCP Client Configuration:**
```json
{
    "name": "marketing-analytics-aggregator",
    "command": "node",
    "args": [
        "/opt/mcp-servers/analytics/marketing-analytics-aggregator/dist/index.js"
    ],
    "env": {
        "SUPABASE_URL": "${SUPABASE_URL}",
        "SUPABASE_ANON_KEY": "${SUPABASE_ANON_KEY}",
        "LISTMONK_URL": "${LISTMONK_URL}",
        "LISTMONK_USER": "${LISTMONK_USER}",
        "LISTMONK_PASSWORD": "${LISTMONK_PASSWORD}",
        "FACEBOOK_ACCESS_TOKEN": "${FACEBOOK_ACCESS_TOKEN}",
        "TWENTY_API_TOKEN": "${TWENTY_API_TOKEN}",
        "SHOPIFY_ACCESS_TOKEN": "${SHOPIFY_ACCESS_TOKEN}",
        "MYSHOPIFY_DOMAIN": "${MYSHOPIFY_DOMAIN}"
    }
}
```
- **Available Tools:**
    - `generate-research-report`: Generate comprehensive analytics reports
    - `store-report-supabase`: Store generated reports in Supabase
- **Available Resources:**
    - `analytics://campaign-performance`: Campaign performance metrics
    - `analytics://customer-segments`: Customer segmentation data
    - `analytics://channel-attribution`: Channel attribution analysis
    - `analytics://market-trends`: Market trend analysis
    - `analytics://executive-summary`: Executive summary dashboard
- **Used By:** Analytics Director Agent, Data Analytics Agent, Marketing Director Agent

### 38. Analytics Director Prompts
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/analytics-director-prompts`
- **Purpose:** Provides strategic analytics prompts and templates for the Analytics Director agent.
- **MCP Client Configuration:**
```json
{
    "name": "analytics-director-prompts",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/analytics-director-prompts/dist/index.js"
    ],
    "env": {}
}
```
- **Available Prompts:**
    - `analyze-business-metrics`: Analyze key business metrics and KPIs for strategic insights
    - `generate-analytics-dashboard`: Design and structure analytics dashboards for different stakeholders
    - `perform-cohort-analysis`: Conduct cohort analysis for customer behavior and retention
    - `attribution-modeling`: Analyze marketing attribution across channels and touchpoints
    - `predictive-analytics`: Generate predictive models and forecasts for business metrics
    - `competitive-intelligence`: Analyze competitive landscape and market positioning
    - `data-quality-audit`: Audit data quality and integrity across systems
    - `custom-analytics-report`: Generate custom analytics reports for specific business needs
    - `real-time-alerts`: Configure real-time analytics alerts and monitoring
    - `analytics-roadmap`: Develop analytics strategy and implementation roadmap
- **Used By:** Analytics Director Agent

### 39. Analytics Director Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/analytics-director-resource`
- **Purpose:** Provides real-time analytics resources and insights for the Analytics Director agent.
- **MCP Client Configuration:**
```json
{
    "name": "analytics-director-resource",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/analytics-director-resource/dist/index.js"
    ],
    "env": {
        "SUPABASE_URL": "${SUPABASE_URL}",
        "SUPABASE_ANON_KEY": "${SUPABASE_ANON_KEY}"
    }
}
```
- **Available Resources:**
    - `analytics://vividwalls/executive-dashboard`: Real-time executive dashboard with key business metrics
    - `analytics://vividwalls/real-time-metrics`: Live stream of business metrics updated every minute
    - `analytics://vividwalls/customer-insights`: Comprehensive customer behavior and segmentation data
    - `analytics://vividwalls/marketing-attribution`: Multi-touch attribution data across all marketing channels
    - `analytics://vividwalls/predictive-insights`: AI-powered predictions and business forecasts
    - `analytics://vividwalls/competitive-analysis`: Market positioning and competitive landscape analysis
    - `analytics://vividwalls/data-quality-scorecard`: Assessment of data quality across all systems
    - `analytics://vividwalls/anomaly-alerts`: Real-time anomaly detection across business metrics
    - `analytics://vividwalls/analytics-catalog`: Directory of all available analytics resources and capabilities
- **Used By:** Analytics Director Agent

### 40. Data Analytics Prompts
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/data-analytics-prompts`
- **Purpose:** Provides specialized prompts for data analysis operations.
- **MCP Client Configuration:**
```json
{
    "name": "data-analytics-prompts",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/data-analytics-prompts/dist/index.js"
    ],
    "env": {}
}
```
- **Available Prompts:**
    - `analyze-performance-trends`: Analyze performance trends over time
    - `generate-kpi-dashboard`: Generate KPI dashboards
    - `segment-analysis`: Perform customer segmentation analysis
    - `anomaly-detection`: Detect anomalies in data
    - `cohort-analysis`: Analyze customer cohorts
    - `competitive-benchmarking`: Benchmark against competitors
    - `forecasting-analysis`: Create forecasts and predictions
    - `channel-attribution`: Analyze channel attribution
    - `data-quality-assessment`: Assess data quality
    - `executive-summary`: Generate executive summaries
- **Used By:** Data Analytics Agent, Performance Analytics Agent

### 41. Data Analytics Resource
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/data-analytics-resource`
- **Purpose:** Provides pre-computed analytics and KPIs for data analysis operations.
- **MCP Client Configuration:**
```json
{
    "name": "data-analytics-resource",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/data-analytics-resource/dist/index.js"
    ],
    "env": {
        "SUPABASE_URL": "${SUPABASE_URL}",
        "SUPABASE_ANON_KEY": "${SUPABASE_ANON_KEY}"
    }
}
```
- **Available Resources:**
    - `analytics://vividwalls/business-health-score`: Overall business health metric (0-100)
    - `analytics://vividwalls/real-time-metrics`: Current performance metrics
    - `analytics://vividwalls/kpi-summary`: Executive summary of KPIs
    - `analytics://vividwalls/alerts-and-anomalies`: Active alerts and anomalies
    - `analytics://vividwalls/performance-benchmarks`: Industry benchmark comparisons
    - `analytics://vividwalls/data-catalog`: Available data sources and status
- **Used By:** Data Analytics Agent, Performance Analytics Agent

---

## Communication & Collaboration

### 42. Telegram MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/core/telegram-mcp-server`
- **Purpose:** Telegram bot integration for notifications and communication.
- **MCP Client Configuration:**
```json
{
    "name": "telegram-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/core/telegram-mcp-server/dist/index.js"
    ],
    "env": {
        "TELEGRAM_BOT_TOKEN": "7337234973:AAF2BRCAVmOKKaW3Gz_P1VtqV93e506lKRI"
    }
}
```
- **Environment Variables:**
    - `TELEGRAM_BOT_TOKEN`: 7337234973:AAF2BRCAVmOKKaW3Gz_P1VtqV93e506lKRI

### 38. Slack MCP Server
- **Status:** Partially Documented
- **Deployment Location:** `/opt/mcp-servers/core/slack-mcp-server`
- **Purpose:** Slack workspace integration for team communication.
- **MCP Client Configuration:**
```json
{
    "name": "slack-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/core/slack-mcp-server/dist/index.js"
    ],
    "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}",
        "SLACK_APP_TOKEN": "${SLACK_APP_TOKEN}"
    }
}
```

---

## Specialized Tools

### 39. Newsletter Agent MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/newsletter-agent-prompts`
- **Purpose:** Newsletter generation and content curation.
- **MCP Client Configuration:**
```json
{
    "name": "newsletter-agent-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/newsletter-agent-prompts/dist/index.js"
    ]
}
```

### 41. Image Picker Resource MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/image-picker-resource`
- **Purpose:** Image selection and management for marketing content.
- **MCP Client Configuration:**
```json
{
    "name": "image-picker-resource-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/image-picker-resource/dist/index.js"
    ],
    "env": {
        "IMAGE_STORAGE_PATH": "${IMAGE_STORAGE_PATH}",
        "SUPABASE_URL": "${SUPABASE_URL}",
        "SUPABASE_SERVICE_ROLE_KEY": "${SUPABASE_SERVICE_ROLE_KEY}"
    }
}
```

### 42. Marketing Research MCP Server
- **Status:** Fully Documented
- **Deployment Location:** `/opt/mcp-servers/agents/marketing-research-prompts`, `/opt/mcp-servers/agents/marketing-research-resource`
- **Purpose:** Market analysis and competitor research tools.
- **MCP Client Configuration:**
```json
{
    "name": "marketing-research-prompts-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/marketing-research-prompts/dist/index.js"
    ]
}
```
```json
{
    "name": "marketing-research-resource-mcp",
    "command": "node",
    "args": [
        "/opt/mcp-servers/agents/marketing-research-resource/dist/index.js"
    ]
}
```

---

## Deployment & Testing Notes

### Environment Variable Management

All environment variables referenced in the configurations above should be:
1. Stored securely in the droplet's environment or `.env` files
2. Never hardcoded in configuration files
3. Properly escaped when containing special characters
4. Regularly rotated for security

### Testing MCP Servers

To test an MCP server configuration:

```bash
# For Node.js servers
node /opt/mcp-servers/[server-name]/dist/index.js --test

# For Python servers
python /opt/mcp-servers/[server-name]/server.py --test
```

### Common Issues & Solutions

1. **Module not found errors**: Ensure all dependencies are installed in the server directory
2. **Permission errors**: Check file permissions and ownership
3. **Environment variable issues**: Verify all required environment variables are set
4. **Path issues**: Use absolute paths in production configurations

---

## Deprecated/Removed Servers

This section lists servers that were present in previous documentation but are no longer active:

| Server | Status    | Notes                                                              |
| ------ | --------- | ------------------------------------------------------------------ |
| Linear | Deprecated | Project management server replaced by n8n workflow management      |

---

## Agent-Tool Mapping Summary

| Agent Type | Primary MCP Servers | Secondary MCP Servers |
|------------|--------------------|--------------------|
| Business Manager | n8n, Supabase, Neo4j | All director-level servers |
| Marketing Director | Shopify, WordPress, SEO Research | Social media servers, Creative servers |
| Sales Director | Twenty CRM, Shopify, Stripe | Email marketing, Analytics |
| Operations Director | Shopify, Pictorem, Sync Manager | Inventory, Fulfillment |
| Creative Director | Figma, Pictorem | Image Picker, Creative resources |
| Social Media Director | Facebook, Instagram, Pinterest | Content scheduling, Analytics |
| Technology Director | GitHub, Docker, n8n | System monitoring, Performance |
| Analytics Director | Marketing Analytics Aggregator, Analytics Director Prompts/Resource, Data Analytics Prompts/Resource | Analytics Dashboard, Performance Metrics, All data-generating servers |
| Finance Director | Stripe, Shopify | Analytics, Reporting |
| Customer Experience | Twenty CRM, Listmonk | Support tools, Feedback systems |

This mapping ensures each agent has access to the appropriate tools for their domain responsibilities while maintaining clear boundaries and preventing overlap.