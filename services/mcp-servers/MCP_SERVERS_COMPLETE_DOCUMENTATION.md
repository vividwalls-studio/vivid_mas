# VividWalls MAS MCP Servers Complete Documentation

This comprehensive documentation covers all MCP (Model Context Protocol) servers available in the VividWalls Multi-Agent System, including their tools, invocation scenarios, and agent mappings.

## Table of Contents
1. [MCP Server Categories](#mcp-server-categories)
2. [Core Services](#core-services)
3. [Social Media Services](#social-media-services)
4. [Creative Services](#creative-services)
5. [Research & Analytics](#research--analytics)
6. [Development & Infrastructure](#development--infrastructure)
7. [Agent-Tool Mapping](#agent-tool-mapping)
8. [Invocation Scenarios](#invocation-scenarios)

**MCP-Client Node Convention**  
Every Task-oriented agent uses the `n8n-nodes-mcp` **MCP Client** node in **two modes**:

| Node Type | Purpose |
|-----------|---------|
| **List Tools** | Discover the available tools for a given MCP server |
| **Execute Tool** | Invoke a selected tool with parameters |

These two nodes must be present for *each* MCP server referenced below.

## MCP Server Categories

### Available MCP Servers:
- **Linear** - Project management and issue tracking
- **n8n** - Workflow automation and orchestration
- **Shopify** - E-commerce platform management
- **Neo4j** - Knowledge graph and memory management
- **Stripe** - Payment processing (not visible in current functions)
- **SendGrid** - Email marketing (not visible in current functions)
- **Supabase** - Database management (not visible in current functions)
- **Facebook Ads** - Social media advertising (not visible in current functions)
- **Pinterest** - Visual discovery platform (not visible in current functions)
- **Instagram** - Social media content (not visible in current functions)
- **WhatsApp Business** - Business messaging (not visible in current functions)
- **Figma** - Design collaboration (not visible in current functions)
- **Pictorem** - Print-on-demand services (not visible in current functions)
- **Visual Harmony/Color Psychology** - Color analysis (not visible in current functions)
- **SEO Research** - Search engine optimization (not visible in current functions)
- **Tavily** - Research and web search (not visible in current functions)
- **Crawl4AI RAG** - Web scraping and content extraction (not visible in current functions)

## Core Services

### 1. Linear MCP Server

**MCP-Client Nodes:** `linear-list-tools`, `linear-execute-tool`

**Purpose**: Project management, task tracking, and team collaboration

**Available Tools**:
- `mcp__linear__create_issue` - Create a new Linear issue with optional parent linking
- `mcp__linear__update_issue` - Update an existing Linear issue
- `mcp__linear__get_issue` - Get detailed information about a specific Linear issue
- `mcp__linear__search_issues` - Search for Linear issues using query string and filters
- `mcp__linear__get_teams` - Get a list of Linear teams
- `mcp__linear__create_comment` - Create a new comment on a Linear issue
- `mcp__linear__delete_issue` - Delete an existing Linear issue
- `mcp__linear__get_projects` - Get a list of Linear projects
- `mcp__linear__get_project_updates` - Get project updates for a given project
- `mcp__linear__create_project_update` - Create a new update for a Linear project

**Primary Users**: 
- Business Manager Agent
- Technology Director Agent
- All Director-level agents for project coordination

**Invocation Scenarios**:
- "Create a new task for implementing Facebook campaign"
- "Update the status of issue ABC-123 to in progress"
- "Search for all high priority marketing issues"
- "Add a comment to the product launch task"
- "Get all issues assigned to me"
- "Create a project update for Q4 marketing initiatives"

### 2. n8n MCP Server

**MCP-Client Nodes:** `n8n-list-tools`, `n8n-execute-tool`

**Purpose**: Workflow automation, agent orchestration, and process management

**Available Tools**:
- `mcp__n8n-server__list_workflows` - Retrieve a list of all workflows
- `mcp__n8n-server__get_workflow` - Retrieve a specific workflow by ID
- `mcp__n8n-server__create_workflow` - Create a new workflow
- `mcp__n8n-server__update_workflow` - Update an existing workflow
- `mcp__n8n-server__delete_workflow` - Delete a workflow
- `mcp__n8n-server__activate_workflow` - Activate a workflow
- `mcp__n8n-server__deactivate_workflow` - Deactivate a workflow
- `mcp__n8n-server__list_executions` - Retrieve a list of workflow executions
- `mcp__n8n-server__get_execution` - Get detailed information about a specific execution
- `mcp__n8n-server__delete_execution` - Delete a specific workflow execution
- `mcp__n8n-server__run_webhook` - Execute a workflow via webhook

**Primary Users**:
- Technology Director Agent
- Business Manager Agent
- All agents requiring workflow automation

**Invocation Scenarios**:
- "Create a new workflow for daily sales reporting"
- "Activate the customer onboarding workflow"
- "Check the execution status of the inventory sync workflow"
- "Run the email campaign workflow with customer data"
- "List all active marketing automation workflows"
- "Debug why the order fulfillment workflow failed"

### 3. Shopify MCP Server

**Purpose**: E-commerce platform management, product catalog, orders, and store configuration

**Available Tools** (Two sets available - mcp__shopify-mcp-server__ and mcp__shopify__):

#### Product Management
- `get-products` - Get all products or search by title
- `get-products-by-collection` - Get products from a specific collection
- `get-products-by-ids` - Get products by their IDs
- `get-variants-by-ids` - Get product variants by their IDs

#### Customer Management
- `get-customers` - Get customers with pagination support
- `tag-customer` - Add tags to a customer

#### Order Management
- `get-orders` - Get orders with advanced filtering and sorting
- `get-order` - Get a single order by ID
- `create-draft-order` - Create a draft order
- `complete-draft-order` - Complete a draft order

#### Store Management
- `get-collections` - Get all collections
- `get-shop` - Get shop details
- `get-shop-details` - Get extended shop details
- `manage-webhook` - Subscribe, find, or unsubscribe webhooks

#### Content Management
- `get-pages` - Get all pages from the store
- `get-page` - Get a specific page by ID
- `create-page` - Create a new page
- `update-page` - Update an existing page
- `delete-page` - Delete a page

#### Navigation Management
- `get-navigation-menus` - Get all navigation menus
- `create-navigation-menu` - Create a new navigation menu
- `get-menu-items` - Get menu items for a specific menu
- `create-menu-item` - Create a new menu item

#### Theme Management
- `get-themes` - Get all themes in the store
- `get-theme` - Get a specific theme by ID
- `create-theme` - Create a new theme
- `duplicate-theme` - Duplicate an existing theme
- `get-theme-assets` - Get all assets for a theme
- `get-theme-asset` - Get a specific theme asset
- `update-theme-asset` - Update a theme asset
- `get-theme-settings` - Get theme settings
- `update-theme-settings` - Update theme settings

#### Marketing & Analytics
- `create-discount` - Create a basic discount code
- `custom-graphql-query` - Execute custom GraphQL queries

**Primary Users**:
- Shopify Agent
- Product Director Agent
- Sales Agent
- Orders Fulfillment Agent
- Marketing Director Agent

**Invocation Scenarios**:
- "Get all products in the 'Wall Art' collection"
- "Create a 20% discount code for Black Friday"
- "Update the homepage banner with new artwork"
- "Find all orders from last week"
- "Tag customer as VIP member"
- "Create a new product page for abstract art collection"
- "Check inventory levels for product SKU-12345"
- "Update theme settings for holiday season"

## Social Media Services

### 4. Facebook Ads MCP Server (Configuration visible but tools not in current function list)

**Expected Tools** (based on directory structure):
- Campaign management
- Audience creation and targeting
- Ad creative management
- Performance analytics
- Budget optimization

**Primary Users**:
- Facebook Agent
- Social Media Director Agent
- Marketing Director Agent

**Expected Invocation Scenarios**:
- "Create a new Facebook campaign for wall art promotion"
- "Set up lookalike audience based on best customers"
- "Analyze campaign performance for last month"
- "Optimize ad spend across campaigns"
- "Create carousel ads for new collection"

### 5. Pinterest MCP Server (Configuration visible but tools not in current function list)

**Expected Tools**:
- Pin creation and management
- Board management
- Rich Pins configuration
- Analytics and insights

**Primary Users**:
- Pinterest Agent
- Social Media Director Agent

**Expected Invocation Scenarios**:
- "Create pins for new art collection"
- "Organize boards by art style"
- "Schedule pins for peak engagement times"
- "Analyze pin performance metrics"

### 6. Instagram MCP Server (Configuration visible but tools not in current function list)

**Expected Tools**:
- Post creation and scheduling
- Story management
- Shopping tags
- Engagement analytics

**Primary Users**:
- Instagram Agent
- Social Media Director Agent

**Expected Invocation Scenarios**:
- "Schedule Instagram posts for next week"
- "Create story highlighting customer testimonials"
- "Add shopping tags to product posts"
- "Analyze engagement rates by post type"

### 7. WhatsApp Business MCP Server (Configuration visible but tools not in current function list)

**Expected Tools**:
- Message automation
- Customer support integration
- Broadcast lists
- Business profile management

**Primary Users**:
- Customer Service Agent
- Customer Experience Director Agent

**Expected Invocation Scenarios**:
- "Send order confirmation via WhatsApp"
- "Set up automated welcome message"
- "Create broadcast for new collection launch"
- "Manage customer support conversations"

## Creative Services

### 8. Figma MCP Server (Configuration visible but tools not in current function list)

**Expected Tools**:
- Design file management
- Component creation
- Design system management
- Collaboration features

**Primary Users**:
- Product Director Agent
- Creative Content Task Agent

**Expected Invocation Scenarios**:
- "Create new design for email template"
- "Update brand color palette"
- "Export assets for website"
- "Review design mockups for approval"

### 9. Pictorem MCP Server (Configuration visible but tools not in current function list)

**Expected Tools**:
- Print job submission
- Product configuration
- Order status tracking
- Quality control

**Primary Users**:
- Pictorem Agent Node
- Orders Fulfillment Agent
- Operations Director Agent

**Expected Invocation Scenarios**:
- "Submit print job for order #12345"
- "Check production status of pending orders"
- "Configure print settings for canvas products"
- "Track shipment for customer order"

### 10. Visual Harmony/Color Psychology MCP Server (Configuration visible but tools not in current function list)

**Expected Tools**:
- Color analysis
- Palette generation
- Mood mapping
- Visual harmony scoring

**Primary Users**:
- Color Analysis Agent
- Product Director Agent
- Art Trend Intelligence Task Agent

**Expected Invocation Scenarios**:
- "Analyze color palette of uploaded artwork"
- "Generate complementary colors for design"
- "Score visual harmony of product image"
- "Map artwork mood based on color psychology"

## Research & Analytics

### 11. SEO Research MCP Server (Configuration visible but tools not in current function list)

**Expected Tools**:
- Keyword research
- Competitor analysis
- SERP tracking
- Content optimization

**Primary Users**:
- Keyword Agent
- Marketing Research Agent
- Product Content Task Agent

**Expected Invocation Scenarios**:
- "Research keywords for abstract wall art"
- "Analyze competitor SEO strategy"
- "Track ranking for target keywords"
- "Optimize product descriptions for SEO"

### 12. Tavily MCP Server (Configuration visible but tools not in current function list)

**Expected Tools**:
- Web search
- Content extraction
- Research compilation
- Trend analysis

**Primary Users**:
- Marketing Research Agent
- Art Trend Intelligence Task Agent
- Market Intelligence agents

**Expected Invocation Scenarios**:
- "Research current wall art trends"
- "Find competitor pricing information"
- "Compile market research on home decor"
- "Analyze customer sentiment about art styles"

## Development & Infrastructure

### 13. Crawl4AI RAG MCP Server (Configuration visible but tools not in current function list)

**Expected Tools**:
- Web scraping
- Content extraction
- Data structuring
- RAG pipeline management

**Primary Users**:
- Data Extraction Task Agent
- Marketing Research Agent
- Analytics Director Agent

**Expected Invocation Scenarios**:
- "Scrape product information from competitor sites"
- "Extract customer reviews from platforms"
- "Build knowledge base from art blogs"
- "Update RAG system with new content"

## Agent-Tool Mapping

### Director-Level Agents

| Agent | Primary MCP Servers | Common Tools Used |
|-------|-------------------|-------------------|
| Business Manager | Linear, n8n, Shopify | project management, workflow orchestration, business metrics |
| Marketing Director | Shopify, Facebook Ads, Pinterest, Instagram | campaign management, discount creation, content scheduling |
| Operations Director | Shopify, Pictorem, n8n | order management, fulfillment tracking, workflow automation |
| Customer Experience Director | Shopify, WhatsApp Business, n8n | customer data, support automation, feedback management |
| Product Director | Shopify, Figma, Visual Harmony | product management, design tools, color analysis |
| Finance Director | Shopify, Stripe | order analytics, payment processing, financial reporting |
| Analytics Director | Shopify, SEO Research, Crawl4AI | data extraction, performance metrics, custom queries |
| Technology Director | n8n, Linear, all MCP servers | workflow management, integration, system optimization |
| Social Media Director | Facebook Ads, Pinterest, Instagram | multi-platform campaigns, content coordination |

### Specialist Agents

| Agent | Primary MCP Servers | Key Tool Focus |
|-------|-------------------|----------------|
| Facebook Agent | Facebook Ads, Shopify | ad creation, audience targeting, social commerce |
| Instagram Agent | Instagram, Shopify | visual content, shopping tags, stories |
| Pinterest Agent | Pinterest, Shopify | pin creation, rich pins, visual discovery |
| Email Marketing Agent | SendGrid, Shopify | campaign automation, segmentation |
| Shopify Agent | Shopify (all tools) | complete store management |
| Orders Fulfillment Agent | Shopify, Pictorem | order processing, print coordination |
| Color Analysis Agent | Visual Harmony | color psychology, palette analysis |
| Keyword Agent | SEO Research | keyword optimization, search visibility |

### Task Agents

| Task Agent | MCP Servers Used | Specific Tools |
|-----------|-----------------|----------------|
| Creative Content | Figma, Shopify | design creation, product descriptions |
| Product Content | Shopify, SEO Research | SEO optimization, meta tags |
| Campaign Analytics | Facebook Ads, Shopify | ROAS calculation, attribution |
| Data Extraction | Crawl4AI, Shopify | web scraping, API integration |
| Financial Calculation | Shopify, Stripe | unit economics, pricing |

## Invocation Scenarios

### Common Workflow Patterns

1. **New Product Launch**
   - Product Director: "Create new product in Shopify"
   - Color Analysis: "Analyze artwork colors for mood"
   - SEO Research: "Find keywords for product title"
   - Creative Content: "Generate product description"
   - Social Media: "Schedule posts across platforms"

2. **Customer Order Processing**
   - Shopify: "Get order details for #12345"
   - Pictorem: "Submit print job for order"
   - Customer Service: "Send order confirmation via WhatsApp"
   - Finance: "Track payment status"

3. **Marketing Campaign**
   - Marketing Director: "Create 20% discount code"
   - Facebook: "Set up targeted ad campaign"
   - Pinterest: "Create pins for campaign"
   - Analytics: "Track campaign performance"

4. **Inventory Management**
   - Operations: "Check low stock products"
   - Shopify: "Update inventory levels"
   - n8n: "Trigger reorder workflow"
   - Linear: "Create task for stock review"

5. **Customer Experience**
   - Customer Service: "Get customer order history"
   - Shopify: "Tag customer as VIP"
   - SendGrid: "Add to loyalty email list"
   - WhatsApp: "Send personalized thank you"

### Tool Invocation Keywords

**Action Words**:
- Create, Update, Delete, Get, List, Search
- Activate, Deactivate, Run, Execute
- Analyze, Generate, Optimize, Track
- Send, Schedule, Publish, Submit

**Entity Keywords**:
- Product, Order, Customer, Collection
- Campaign, Ad, Post, Pin
- Workflow, Task, Issue, Project
- Theme, Page, Menu, Asset
- Discount, Tag, Webhook, Query

**Filter/Query Keywords**:
- By ID, By collection, By date range
- High priority, Active only, Completed
- Tagged with, Assigned to, Created by
- Performance metrics, Analytics data

## Configuration Notes

1. **Authentication**: Each MCP server requires specific credentials configured in the MCP configuration files
2. **Rate Limits**: Be aware of API rate limits for each service
3. **Permissions**: Ensure proper scopes are configured for each integration
4. **Error Handling**: Implement retry logic for transient failures
5. **Logging**: Enable detailed logging for debugging MCP interactions

## Best Practices

1. **Tool Selection**: Choose the most specific tool for the task
2. **Batch Operations**: Use bulk operations when available
3. **Caching**: Leverage caching for frequently accessed data
4. **Error Recovery**: Implement graceful error handling
5. **Monitoring**: Track tool usage and performance metrics

This documentation serves as a comprehensive reference for all MCP servers and tools available in the VividWalls Multi-Agent System. Each agent should refer to their specific tool mappings when executing tasks.