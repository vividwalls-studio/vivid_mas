# VividMAS MCP Servers Documentation

## Overview

This document provides a comprehensive listing of all Model Context Protocol (MCP) servers available in the VividMAS project, including their tools and capabilities.

## MCP Server Categories

### 1. Core Services

#### Shopify MCP Server
**Location**: `/services/mcp-servers/core/shopify-mcp-server`  
**Purpose**: Shopify store administration and management through GraphQL API

**Available Tools**:
- **Product Management**:
  - `get-products` - Get all products or search by title
  - `get-products-by-collection` - Get products from a specific collection
  - `get-products-by-ids` - Get products by their IDs
  - `get-variants-by-ids` - Get product variants by their IDs

- **Customer Management**:
  - `get-customers` - Get customers with pagination support
  - `tag-customer` - Add tags to a customer

- **Order Management**:
  - `get-orders` - Get orders with advanced filtering and sorting
  - `get-order` - Get a single order by ID
  - `create-draft-order` - Create a draft order
  - `complete-draft-order` - Complete a draft order

- **Collection Management**:
  - `get-collections` - Get all collections

- **Page Management**:
  - `get-pages` - Get all pages from the store
  - `get-page` - Get a specific page by ID
  - `create-page` - Create a new page in the store
  - `update-page` - Update an existing page
  - `delete-page` - Delete a page from the store

- **Navigation Management**:
  - `get-navigation-menus` - Get all navigation menus
  - `create-navigation-menu` - Create a new navigation menu
  - `get-menu-items` - Get menu items for a specific navigation menu
  - `create-menu-item` - Create a new menu item

- **Theme Management**:
  - `get-themes` - Get all themes in the store
  - `get-theme` - Get a specific theme by ID
  - `create-theme` - Create a new theme
  - `duplicate-theme` - Duplicate an existing theme
  - `get-theme-assets` - Get all assets for a specific theme
  - `get-theme-asset` - Get a specific theme asset
  - `update-theme-asset` - Update a theme asset
  - `get-theme-settings` - Get theme settings
  - `update-theme-settings` - Update theme settings

- **Other Features**:
  - `create-discount` - Create a basic discount code
  - `get-shop` - Get basic shop details
  - `get-shop-details` - Get extended shop details including shipping countries
  - `manage-webhook` - Subscribe, find, or unsubscribe webhooks
  - `custom-graphql-query` - Execute custom GraphQL queries against Shopify Admin API

#### Neo4j MCP Servers
**Location**: `/services/mcp-servers/core/neo4j-mcp-server`  
**Purpose**: Neo4j graph database management and knowledge graph operations

**Three Specialized Servers**:

1. **mcp-neo4j-cypher** - Natural language to Cypher queries
   - `read-neo4j-cypher` - Execute read queries
   - `write-neo4j-cypher` - Execute write queries
   - `get-neo4j-schema` - Get database schema

2. **mcp-neo4j-memory** - Knowledge graph memory management
   - `read_graph` - Read graph data
   - `search_nodes` - Search for nodes
   - `find_nodes` - Find specific nodes
   - `create_entities` - Create new entities
   - `delete_entities` - Delete entities
   - `create_relations` - Create relationships
   - `delete_relations` - Delete relationships
   - `add_observations` - Add observations
   - `delete_observations` - Delete observations

3. **mcp-neo4j-cloud-aura-api** - Neo4j Aura cloud service management
   - Manage cloud instances
   - Scale instances
   - Enable features

#### Stripe MCP Server
**Location**: `/services/mcp-servers/core/stripe-mcp-server`  
**Purpose**: Stripe payment processing and management

**Features**:
- Payment link creation
- Customer management
- Subscription handling
- Webhook management
- Checkout sessions
- Integration with multiple agent frameworks (OpenAI, LangChain, CrewAI)

#### SendGrid MCP Server
**Location**: `/services/mcp-servers/core/sendgrid-mcp-server`  
**Purpose**: Email marketing and SMS messaging through SendGrid and Twilio

**Email Tools (SendGrid)**:
- Contact Management:
  - `list_contacts` - List all contacts
  - `add_contact` - Add a contact
  - `delete_contacts` - Delete contacts
  - `get_contacts_by_list` - Get contacts in a list
- List Management:
  - `list_contact_lists` - List all contact lists
  - `create_contact_list` - Create a new list
- Email sending and template management
- Analytics and validation
- Suppression group handling

**SMS Tools (Twilio)**:
- Send individual and bulk SMS
- MMS support
- Delivery tracking
- Message history

#### Supabase MCP Server
**Location**: `/services/mcp-servers/core/supabase-mcp-server`  
**Purpose**: Supabase database operations

**Tools**:
- `check-connection` - Verify database connection
- `query-table` - Query database tables
- `insert-data` - Insert data into tables
- `update-data` - Update existing data
- `delete-data` - Delete data from tables

#### n8n MCP Server
**Location**: `/services/mcp-servers/core/n8n-mcp-server`  
**Purpose**: n8n workflow automation management

**Tools**:
- Workflow Management:
  - `list_workflows` - List all workflows
  - `get_workflow` - Get specific workflow
  - `create_workflow` - Create new workflow
  - `update_workflow` - Update workflow
  - `delete_workflow` - Delete workflow
  - `activate_workflow` - Activate workflow
  - `deactivate_workflow` - Deactivate workflow
  - `execute_workflow` - Execute workflow
- Execution Management:
  - `get_executions` - Get workflow executions
  - `get_execution` - Get specific execution
- Credential Management:
  - `list_credentials` - List credentials
  - `get_credential` - Get specific credential
  - `create_credential` - Create credential
  - `update_credential` - Update credential
  - `delete_credential` - Delete credential

#### WordPress MCP Server
**Location**: `/services/mcp-servers/core/wordpress-mcp-server`  
**Purpose**: WordPress content management

**Tools**:
- `get_posts` - Get posts
- `create_post` - Create new post
- `update_post` - Update post
- `delete_post` - Delete post
- `get_pages` - Get pages
- `manage_media` - Media management
- `manage_users` - User management
- `manage_categories` - Category management
- `seo_optimization` - SEO optimization
- `content_generation` - Content generation

### 2. Social Media Services

#### Facebook Ads MCP Server
**Location**: `/services/mcp-servers/social-media/facebook-ads-mcp-server`  
**Purpose**: Facebook Ads management and analytics

**Tools**:
- Account Management:
  - `list_ad_accounts` - List ad accounts
  - `get_details_of_ad_account` - Get account details
  - `update_ad_account` - Update account
- Campaign Tools:
  - `get_campaign_by_id` - Get campaign details
  - `create_campaign` - Create campaign
  - `update_campaign` - Update campaign
  - `delete_campaign` - Delete campaign
  - `bulk_update_campaigns` - Bulk update campaigns
- Ad Set Tools:
  - `get_adset_by_id` - Get ad set details
  - `create_adset` - Create ad set
  - `update_adset` - Update ad set
  - `delete_adset` - Delete ad set
  - `bulk_update_adsets` - Bulk update ad sets
- Ad Tools:
  - `get_ad_by_id` - Get ad details
  - `create_ad` - Create ad
  - `update_ad` - Update ad
  - `delete_ad` - Delete ad
  - `bulk_update_ads` - Bulk update ads
- Analytics:
  - `get_adaccount_insights` - Account insights
  - `get_campaign_insights` - Campaign insights
  - `get_adset_insights` - Ad set insights
  - `get_ad_insights` - Ad insights
- Instagram Integration:
  - `get_instagram_accounts` - Get Instagram accounts
  - `get_instagram_media` - Get Instagram media
  - `create_instagram_ad_creative` - Create Instagram ad

#### Pinterest MCP Server
**Location**: `/services/mcp-servers/social-media/pinterest-mcp-server`  
**Purpose**: Pinterest marketing and content management

**Tools**:
- `get_user_profile` - Get user profile
- `get_boards` - Get boards
- `create_board` - Create board
- `get_pins` - Get pins
- `create_pin` - Create pin
- `get_analytics` - Get analytics
- `bulk_pin_creation` - Bulk pin creation
- `board_management` - Board management

#### Instagram MCP Server
**Location**: `/services/mcp-servers/social-media/instagram-mcp-server`  
**Purpose**: Instagram content and account management

#### WhatsApp Business MCP Server
**Location**: `/services/mcp-servers/social-media/whatsapp-business-mcp-server`  
**Purpose**: WhatsApp Business API integration

### 3. Creative Services

#### Figma MCP Server
**Location**: `/services/mcp-servers/creative/figma`  
**Purpose**: Figma design system integration

**Tools**:
- File Operations:
  - `get-file` - Get file details
  - `get-file-nodes` - Get file nodes
  - `get-images` - Get images
  - `get-image-fills` - Get image fills
- Component Management:
  - `get-components` - Get components
  - `get-component-sets` - Get component sets
  - `create-component` - Create component
  - `update-component` - Update component
  - `delete-component` - Delete component
- Design System:
  - `get-styles` - Get styles
  - `get-variables` - Get variables
  - `get-variable-collections` - Get variable collections
  - `sync-design-tokens` - Sync design tokens
  - `export-assets` - Export assets
  - `analyze-design-system` - Analyze design system

#### Pictorem MCP Server
**Location**: `/services/mcp-servers/creative/pictorem-mcp-server`  
**Purpose**: Print-on-demand product management

**Tools**:
- `get_products` - Get products
- `get_product` - Get specific product
- `search_products` - Search products
- `get_categories` - Get categories
- `update_pricing` - Update pricing
- `bulk_operations` - Bulk operations
- `extract_data` - Extract data
- `manage_inventory` - Manage inventory

#### Visual Harmony MCP Server (Color Psychology)
**Location**: `/services/mcp-servers/creative/visual-harmony-mcp-server`  
**Purpose**: Color psychology analysis for design

**Tools**:
- `analyze_color_palette` - Analyze color palette
- `get_color_emotions` - Get color emotions
- `generate_color_scheme` - Generate color scheme
- `get_room_recommendations` - Get room recommendations
- `analyze_artwork_colors` - Analyze artwork colors
- `color_harmony_analysis` - Color harmony analysis
- `seasonal_color_analysis` - Seasonal color analysis

### 4. Research & Analytics

#### SEO Research MCP Server
**Location**: `/services/mcp-servers/research/seo-research-mcp`  
**Purpose**: SEO research and analysis

**Tools**:
- `keyword_research` - Keyword research
- `competitor_analysis` - Competitor analysis
- `backlink_analysis` - Backlink analysis
- `rank_tracking` - Rank tracking
- `content_analysis` - Content analysis
- `site_audit` - Site audit
- `serp_analysis` - SERP analysis

#### Tavily MCP Server
**Location**: `/services/mcp-servers/research/tavily-mcp`  
**Purpose**: Advanced web search and research

**Tools**:
- `search` - General web search
- `extract` - Extract content from URLs
- `qna_search` - Question-answering search
- `get_search_context` - Get search context
- `news_search` - News search
- `academic_search` - Academic search

#### Analytics MCP Server
**Location**: `/services/mcp-servers/analytics`  
**Purpose**: Business analytics and insights

**Tools**:
- `get_business_metrics` - Get business metrics
- `generate_insights` - Generate insights
- `predict_trends` - Predict trends
- `analyze_performance` - Analyze performance
- `create_dashboard` - Create dashboard
- `export_data` - Export data
- `cohort_analysis` - Cohort analysis
- `revenue_optimization` - Revenue optimization
- `customer_lifetime_value` - Customer lifetime value
- `predictive_modeling` - Predictive modeling

### 5. Development & Infrastructure

#### Crawl4AI RAG MCP Server
**Location**: `/services/mcp-servers/mcp-crawl4ai-rag`  
**Purpose**: Web crawling and RAG (Retrieval-Augmented Generation) capabilities

**Core Tools**:
- `crawl_single_page` - Crawl a single web page
- `smart_crawl_url` - Intelligently crawl a website
- `get_available_sources` - Get available sources
- `perform_rag_query` - Perform RAG query

**Conditional Tools** (when enabled):
- `search_code_examples` - Search for code examples (requires USE_AGENTIC_RAG=true)
- `parse_github_repository` - Parse GitHub repo into knowledge graph (requires USE_KNOWLEDGE_GRAPH=true)
- `check_ai_script_hallucinations` - Check for AI hallucinations (requires USE_KNOWLEDGE_GRAPH=true)
- `query_knowledge_graph` - Query knowledge graph (requires USE_KNOWLEDGE_GRAPH=true)

**Advanced Features**:
- Contextual embeddings
- Hybrid search (vector + keyword)
- Agentic RAG for code examples
- Reranking for improved relevance
- Knowledge graph for hallucination detection

#### Email Marketing MCP Server
**Location**: `/services/mcp-servers/core/email-marketing-mcp-server`  
**Purpose**: Email marketing automation

**Tools**:
- `send_email` - Send email
- `create_campaign` - Create campaign
- `manage_subscribers` - Manage subscribers
- `get_analytics` - Get analytics
- `create_template` - Create template
- `segment_audience` - Segment audience
- `a_b_test` - A/B testing

## Configuration Examples

### Claude Desktop Configuration
Add servers to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "shopify-admin": {
      "command": "node",
      "args": ["path/to/shopify-mcp-server/build/index.js"],
      "env": {
        "SHOPIFY_ACCESS_TOKEN": "your_access_token"
      }
    },
    "neo4j-cypher": {
      "command": "python",
      "args": ["-m", "mcp_neo4j_cypher"],
      "env": {
        "NEO4J_URI": "bolt://localhost:7687",
        "NEO4J_USER": "neo4j",
        "NEO4J_PASSWORD": "your_password"
      }
    }
  }
}
```

### Remote Server Configuration (SSH)
For servers running on remote hosts:

```json
{
  "n8n-server": {
    "command": "ssh",
    "args": [
      "-i", "~/.ssh/digitalocean",
      "root@157.230.13.13",
      "cd /opt/mcp-servers/n8n-mcp-server && node build/index.js"
    ],
    "env": {
      "N8N_API_URL": "http://localhost:5678/api/v1",
      "N8N_API_KEY": "your_api_key"
    }
  }
}
```

### SSE Transport Configuration
For servers using Server-Sent Events:

```json
{
  "crawl4ai-rag": {
    "transport": "sse",
    "url": "http://localhost:8051/sse"
  }
}
```

## Best Practices

1. **Security**: Always use environment variables for sensitive credentials
2. **Paths**: Use absolute paths in configurations to avoid working directory issues
3. **Logging**: Check MCP logs for debugging: `tail -f ~/Library/Logs/Claude/mcp*.log`
4. **Testing**: Use the MCP Inspector tool for testing server functionality
5. **Updates**: Regularly update servers to get new features and bug fixes

## Troubleshooting

Common issues and solutions:

1. **Authentication Errors**: Verify API keys and access tokens
2. **Connection Issues**: Check network connectivity and firewall settings
3. **Path Issues**: Ensure all paths in configuration are absolute
4. **Permission Problems**: Verify file and directory permissions
5. **Environment Variables**: Ensure all required environment variables are set

For more detailed troubleshooting, refer to individual server documentation and logs.