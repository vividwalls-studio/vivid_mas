# VividWalls Multi-Agent System (MAS) - Complete Agent Compendium

**Version:** 2.0  
**Date:** July 19, 2025  
**Document Owner:** VividWalls Product Team  
**Status:** Final Draft  

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Agent Hierarchy Overview](#agent-hierarchy-overview)
3. [Business Manager Agent](#business-manager-agent)
4. [Director Agents](#director-agents)
5. [Specialized Agents](#specialized-agents)
6. [MCP Server Infrastructure](#mcp-server-infrastructure)
7. [Integration Points](#integration-points)
8. [Webhook Configuration](#webhook-configuration)
9. [Development Guidelines](#development-guidelines)

---

## Executive Summary

The VividWalls Multi-Agent System (MAS) orchestrates 70+ specialized AI agents across 12 departments to enable 24/7 autonomous business operations. The system implements a hierarchical architecture with a central Business Manager Agent coordinating 10 Director agents who manage specialized operational agents.

**Key Statistics:**
- **Total Agents:** 70+ specialized agents
- **Director Agents:** 10 department heads
- **MCP Servers:** 50+ Model Context Protocol servers
- **Webhook Endpoints:** 100+ integration points
- **Target ROI:** 15x marketing return ($30K from $2K investment)

---

## Agent Hierarchy Overview

```
Business Manager Agent (Central Orchestrator)
    │
    ├── Marketing Director
    │   ├── Social Media Director
    │   │   ├── Facebook Agent
    │   │   ├── Instagram Agent
    │   │   └── Pinterest Agent
    │   ├── Creative Director
    │   │   ├── Design Agent
    │   │   ├── Brand Consistency Agent
    │   │   └── Visual Content Agent
    │   ├── Content Strategy Agent
    │   ├── Copy Writer Agent
    │   ├── Copy Editor Agent
    │   ├── Email Marketing Agent
    │   ├── SEO Agent
    │   ├── A/B Testing Agent
    │   └── Marketing Campaign Agent
    │
    ├── Sales Director
    │   ├── Commercial Sales Agents (5)
    │   │   ├── Hospitality Sales Agent
    │   │   ├── Corporate Sales Agent
    │   │   ├── Healthcare Sales Agent
    │   │   ├── Retail Sales Agent
    │   │   └── Real Estate Sales Agent
    │   ├── Residential Sales Agents (5)
    │   │   ├── Homeowner Sales Agent
    │   │   ├── Renter Sales Agent
    │   │   ├── Interior Designer Agent
    │   │   ├── Art Collector Agent
    │   │   └── Gift Buyer Agent
    │   └── Digital Sales Agents (2)
    │       ├── Millennial/Gen Z Agent
    │       └── Global Customer Agent
    │
    ├── Operations Director
    │   ├── Inventory Management Agent
    │   ├── Fulfillment Agent
    │   ├── Vendor Management Agent
    │   └── Quality Control Agent
    │
    ├── Customer Experience Director
    │   ├── Customer Support Agent
    │   ├── Satisfaction Monitoring Agent
    │   ├── Feedback Analysis Agent
    │   └── Loyalty Program Agent
    │
    ├── Finance Director
    │   ├── Budget Management Agent
    │   ├── ROI Analysis Agent
    │   ├── Cash Flow Agent
    │   └── Financial Reporting Agent
    │
    ├── Analytics Director
    │   ├── Performance Analytics Agent
    │   ├── Data Insights Agent
    │   ├── KPI Tracking Agent
    │   └── Business Intelligence Agent
    │
    ├── Product Director
    │   ├── Product Strategy Agent
    │   ├── Market Research Agent
    │   ├── Competitive Analysis Agent
    │   └── Product Development Agent
    │
    ├── Technology Director
    │   ├── System Monitoring Agent
    │   ├── Infrastructure Agent
    │   ├── Security Agent
    │   └── Integration Agent
    │
    ├── Creative Director
    │   ├── Visual Design Agent
    │   ├── Content Creation Agent
    │   ├── Brand Management Agent
    │   └── Creative Strategy Agent
    │
    └── Compliance & Risk Director
        ├── Data Privacy Agent
        ├── Regulatory Compliance Agent
        ├── Risk Assessment Agent
        └── Crisis Management Agent
```

---

## Business Manager Agent

### Role & Objectives
**Primary Role:** Central orchestrator and strategic decision maker for all VividWalls business operations.

**Core Objectives:**
- Achieve $30K+ monthly revenue from $2K marketing investment (15x ROI)
- Coordinate 10 Director agents across all business functions
- Maintain strategic alignment with VividWalls vision
- Provide executive reporting to stakeholder Kingler Bercy
- Optimize resource allocation and performance across departments

### Webhook Configuration
- **Production URL:** `https://n8n.vividwalls.blog/webhook/business-manager`
- **Test URL:** `http://localhost:5678/webhook-test/business-manager`
- **Method:** POST
- **Content-Type:** application/json

### MCP Servers
1. **Business Manager Prompts MCP**
   - **Port:** 3002
   - **Purpose:** Strategic prompt templates
   - **Tools:** business-manager-system, strategic-planning, director-coordination

2. **Business Manager Resources MCP**
   - **Port:** 3001
   - **Purpose:** Strategic frameworks and knowledge
   - **Resources:** OKR Framework, Executive KPI Dashboard, RACI Matrix

3. **Telegram MCP**
   - **Purpose:** Real-time stakeholder notifications
   - **Bot Token:** 7337234973:AAF2BRCAVmOKKaW3Gz_P1VtqV93e506lKRI

4. **Email MCP**
   - **Purpose:** Formal executive reports
   - **Target:** kingler@vividwalls.co

5. **HTML Report Generator MCP**
   - **Purpose:** Interactive executive dashboards

### Available Tools
- `marketing_director_tool` - Brand strategy and campaign orchestration
- `analytics_director_tool` - Data insights and performance optimization
- `finance_director_tool` - Financial planning and budget control
- `operations_director_tool` - Supply chain and fulfillment excellence
- `customer_experience_director_tool` - Customer satisfaction and support
- `product_director_tool` - Product strategy and market positioning
- `technology_director_tool` - Technical infrastructure and innovation
- `creative_director_tool` - Visual identity and creative excellence
- `social_media_director_tool` - Platform-specific campaign coordination
- `sales_director_tool` - Revenue optimization and sales strategy

### System Prompt
Located at: `services/mcp-servers/business_manager_system_prompt.txt`

**Key Responsibilities:**
1. **Strategic Oversight** - Monitor overall business performance
2. **Director Coordination** - Delegate tasks to appropriate Director Agents
3. **Resource Management** - Optimize budget allocation across departments
4. **Performance Analysis** - Consolidate metrics from all directors
5. **Executive Reporting** - Create comprehensive stakeholder reports

---

## Director Agents

### 1. Marketing Director Agent

**Role & Objectives:**
- Orchestrate comprehensive marketing campaigns across all channels
- Achieve 15x ROI on marketing spend ($30K from $2K investment)
- Build 3,000+ email subscriber base through automated outreach
- Maintain daily social media presence across multiple platforms
- Implement AI-powered SEO content strategy

**Webhook Configuration:**
- **Production URL:** `https://n8n.vividwalls.blog/webhook/marketing-director`
- **Test URL:** `http://localhost:5678/webhook-test/marketing-director`
- **Method:** POST

**MCP Servers:**
1. **Marketing Director Prompts MCP** (Port: 3003)
2. **Marketing Director Resources MCP** (Port: 3004)
3. **SendGrid MCP** - Email campaign management
4. **Shopify MCP** - E-commerce integration
5. **Analytics MCP** - Performance tracking

**Specialized Agents Managed:**
- Social Media Director (Facebook, Instagram, Pinterest)
- Creative Director (Design, Brand Consistency, Visual Content)
- Content Strategy Agent
- Copy Writer Agent
- Copy Editor Agent
- Email Marketing Agent
- SEO Agent
- A/B Testing Agent
- Campaign Analytics Agent

### 2. Sales Director Agent

**Role & Objectives:**
- Deploy 13 specialized sales personas for targeted conversion
- Achieve 3.5%+ conversion rate on art sales
- Personalize customer journeys based on segment
- Optimize pricing dynamically based on demand
- Manage CRM integration and lead scoring

**Webhook Configuration:**
- **Production URL:** `https://n8n.vividwalls.blog/webhook/sales-director`
- **Test URL:** `http://localhost:5678/webhook-test/sales-director`
- **Method:** POST

**MCP Servers:**
1. **Sales Director Prompts MCP** (Port: 3005)
2. **Sales Director Resources MCP** (Port: 3006)
3. **Twenty CRM MCP** - Customer relationship management
4. **Stripe MCP** - Payment processing
5. **Shopify MCP** - E-commerce integration

**Specialized Agents Managed:**
- **Commercial Sales (5):** Hospitality, Corporate, Healthcare, Retail, Real Estate
- **Residential Sales (5):** Homeowner, Renter, Interior Designer, Art Collector, Gift Buyer
- **Digital Sales (2):** Millennial/Gen Z, Global Customer

### 3. Operations Director Agent

**Role & Objectives:**
- Manage supply chain and fulfillment operations
- Optimize inventory levels and vendor relationships
- Ensure quality control and customer satisfaction
- Coordinate with print partners (Pictorem, Printful, Gooten)
- Maintain operational efficiency and cost control

**Webhook Configuration:**
- **Production URL:** `https://n8n.vividwalls.blog/webhook/operations-director`
- **Test URL:** `http://localhost:5678/webhook-test/operations-director`
- **Method:** POST

**MCP Servers:**
1. **Operations Director Prompts MCP** (Port: 3007)
2. **Operations Director Resources MCP** (Port: 3008)
3. **Shopify MCP** - Order management
4. **Pictorem MCP** - Print partner integration
5. **Inventory MCP** - Stock management

**Specialized Agents Managed:**
- Inventory Management Agent
- Fulfillment Agent
- Vendor Management Agent
- Quality Control Agent

### 4. Customer Experience Director Agent

**Role & Objectives:**
- Optimize customer satisfaction and support operations
- Monitor customer feedback and sentiment
- Implement loyalty programs and retention strategies
- Ensure seamless customer journey across all touchpoints
- Maintain high Net Promoter Score (NPS)

**Webhook Configuration:**
- **Production URL:** `https://n8n.vividwalls.blog/webhook/customer-experience-director`
- **Test URL:** `http://localhost:5678/webhook-test/customer-experience-director`
- **Method:** POST

**MCP Servers:**
1. **Customer Experience Prompts MCP** (Port: 3009)
2. **Customer Experience Resources MCP** (Port: 3010)
3. **Twenty CRM MCP** - Customer data management
4. **Support MCP** - Ticket management
5. **Feedback MCP** - Sentiment analysis

**Specialized Agents Managed:**
- Customer Support Agent
- Satisfaction Monitoring Agent
- Feedback Analysis Agent
- Loyalty Program Agent

### 5. Finance Director Agent

**Role & Objectives:**
- Manage financial planning and budget control
- Optimize ROI across all marketing channels
- Monitor cash flow and financial performance
- Generate comprehensive financial reports
- Ensure compliance with financial regulations

**Webhook Configuration:**
- **Production URL:** `https://n8n.vividwalls.blog/webhook/finance-director`
- **Test URL:** `http://localhost:5678/webhook-test/finance-director`
- **Method:** POST

**MCP Servers:**
1. **Finance Director Prompts MCP** (Port: 3011)
2. **Finance Director Resources MCP** (Port: 3012)
3. **Stripe MCP** - Payment analytics
4. **Shopify MCP** - Revenue tracking
5. **Budget MCP** - Financial planning

**Specialized Agents Managed:**
- Budget Management Agent
- ROI Analysis Agent
- Cash Flow Agent
- Financial Reporting Agent

### 6. Analytics Director Agent

**Role & Objectives:**
- Provide data insights and performance optimization
- Track KPIs across all business functions
- Generate actionable business intelligence
- Monitor system performance and agent efficiency
- Create comprehensive reporting dashboards

**Webhook Configuration:**
- **Production URL:** `https://n8n.vividwalls.blog/webhook/analytics-director`
- **Test URL:** `http://localhost:5678/webhook-test/analytics-director`
- **Method:** POST

**MCP Servers:**
1. **Analytics Director Prompts MCP** (Port: 3013)
2. **Analytics Director Resources MCP** (Port: 3014)
3. **KPI Dashboard MCP** - Performance metrics
4. **Data Processing MCP** - Analytics pipeline
5. **Reporting MCP** - Dashboard generation

**Specialized Agents Managed:**
- Performance Analytics Agent
- Data Insights Agent
- KPI Tracking Agent
- Business Intelligence Agent

### 7. Product Director Agent

**Role & Objectives:**
- Develop product strategy and market positioning
- Conduct market research and competitive analysis
- Optimize product offerings and pricing
- Identify new market opportunities
- Ensure product-market fit

**Webhook Configuration:**
- **Production URL:** `https://n8n.vividwalls.blog/webhook/product-director`
- **Test URL:** `http://localhost:5678/webhook-test/product-director`
- **Method:** POST

**MCP Servers:**
1. **Product Director Prompts MCP** (Port: 3015)
2. **Product Director Resources MCP** (Port: 3016)
3. **Market Research MCP** - Competitive analysis
4. **Product Strategy MCP** - Positioning optimization
5. **Pricing MCP** - Dynamic pricing

**Specialized Agents Managed:**
- Product Strategy Agent
- Market Research Agent
- Competitive Analysis Agent
- Product Development Agent

### 8. Technology Director Agent

**Role & Objectives:**
- Manage technical infrastructure and innovation
- Monitor system performance and security
- Ensure seamless integration across all platforms
- Implement new technologies and tools
- Maintain system reliability and scalability

**Webhook Configuration:**
- **Production URL:** `https://n8n.vividwalls.blog/webhook/technology-director`
- **Test URL:** `http://localhost:5678/webhook-test/technology-director`
- **Method:** POST

**MCP Servers:**
1. **Technology Director Prompts MCP** (Port: 3017)
2. **Technology Director Resources MCP** (Port: 3018)
3. **System Monitoring MCP** - Infrastructure health
4. **Security MCP** - Threat detection
5. **Integration MCP** - Platform connectivity

**Specialized Agents Managed:**
- System Monitoring Agent
- Infrastructure Agent
- Security Agent
- Integration Agent

### 9. Creative Director Agent

**Role & Objectives:**
- Manage visual identity and creative excellence
- Oversee design and content creation processes
- Ensure brand consistency across all channels
- Optimize creative assets for maximum engagement
- Coordinate with design and content teams

**Webhook Configuration:**
- **Production URL:** `https://n8n.vividwalls.blog/webhook/creative-director`
- **Test URL:** `http://localhost:5678/webhook-test/creative-director`
- **Method:** POST

**MCP Servers:**
1. **Creative Director Prompts MCP** (Port: 3019)
2. **Creative Director Resources MCP** (Port: 3020)
3. **Design MCP** - Visual asset creation
4. **Content MCP** - Creative content generation
5. **Brand MCP** - Identity management

**Specialized Agents Managed:**
- Visual Design Agent
- Content Creation Agent
- Brand Management Agent
- Creative Strategy Agent

### 10. Social Media Director Agent

**Role & Objectives:**
- Coordinate platform-specific campaign strategies
- Manage daily posting across Facebook, Instagram, Pinterest
- Optimize content for each platform's unique audience
- Monitor engagement and performance metrics
- Implement platform-specific best practices

**Webhook Configuration:**
- **Production URL:** `https://n8n.vividwalls.blog/webhook/social-media-director`
- **Test URL:** `http://localhost:5678/webhook-test/social-media-director`
- **Method:** POST

**MCP Servers:**
1. **Social Media Director Prompts MCP** (Port: 3021)
2. **Social Media Director Resources MCP** (Port: 3022)
3. **Facebook MCP** - Meta platform integration
4. **Instagram MCP** - Visual content platform
5. **Pinterest MCP** - Discovery platform

**Specialized Agents Managed:**
- Facebook Agent
- Instagram Agent
- Pinterest Agent

---

## Specialized Agents

### Marketing Specialized Agents

#### Content Strategy Agent
- **Role:** Develop comprehensive content strategies
- **Webhook:** `https://n8n.vividwalls.blog/webhook/content-strategy-agent`
- **MCP Servers:** Content Strategy Prompts MCP (Port: 3039), Content Strategy Resources MCP (Port: 3040)
- **Tools:** Content planning, keyword research, editorial calendar

#### Copy Writer Agent
- **Role:** Create compelling marketing copy
- **Webhook:** `https://n8n.vividwalls.blog/webhook/copy-writer-agent`
- **MCP Servers:** Copy Writer Prompts MCP (Port: 3043), Copy Writer Resources MCP (Port: 3044)
- **Tools:** AI writing assistance, tone optimization, A/B testing

#### Copy Editor Agent
- **Role:** Refine and optimize marketing content
- **Webhook:** `https://n8n.vividwalls.blog/webhook/copy-editor-agent`
- **MCP Servers:** Copy Editor Prompts MCP (Port: 3016), Copy Editor Resources MCP (Port: 3017)
- **Tools:** Grammar checking, style optimization, brand consistency

#### Email Marketing Agent
- **Role:** Manage email campaigns and nurture sequences
- **Webhook:** `https://n8n.vividwalls.blog/webhook/email-marketing-agent`
- **MCP Servers:** SendGrid MCP, Listmonk MCP
- **Tools:** Campaign automation, segmentation, performance tracking

#### SEO Agent
- **Role:** Optimize content for search engines
- **Webhook:** `https://n8n.vividwalls.blog/webhook/seo-agent`
- **MCP Servers:** SEO MCP, Keyword Research MCP
- **Tools:** Keyword optimization, content analysis, ranking tracking

#### A/B Testing Agent
- **Role:** Optimize campaigns through testing
- **Webhook:** `https://n8n.vividwalls.blog/webhook/ab-testing-agent`
- **MCP Servers:** Testing MCP, Analytics MCP
- **Tools:** Experiment design, statistical analysis, optimization

#### Campaign Analytics Agent
- **Role:** Track and analyze campaign performance
- **Webhook:** `https://n8n.vividwalls.blog/webhook/campaign-analytics-agent`
- **MCP Servers:** Analytics MCP, Reporting MCP
- **Tools:** Performance tracking, ROI analysis, attribution modeling

### Sales Specialized Agents

#### Commercial Sales Agents

**Hospitality Sales Agent**
- **Role:** Target hotel chains and hospitality businesses
- **Webhook:** `https://n8n.vividwalls.blog/webhook/hospitality-sales-agent`
- **MCP Servers:** Twenty CRM MCP, Hospitality MCP
- **Tools:** Lead generation, proposal creation, relationship management

**Corporate Sales Agent**
- **Role:** Target corporate offices and businesses
- **Webhook:** `https://n8n.vividwalls.blog/webhook/corporate-sales-agent`
- **MCP Servers:** Twenty CRM MCP, Corporate MCP
- **Tools:** B2B sales, contract negotiation, account management

**Healthcare Sales Agent**
- **Role:** Target healthcare facilities and medical offices
- **Webhook:** `https://n8n.vividwalls.blog/webhook/healthcare-sales-agent`
- **MCP Servers:** Twenty CRM MCP, Healthcare MCP
- **Tools:** Medical facility targeting, compliance requirements

**Retail Sales Agent**
- **Role:** Target retail stores and commercial spaces
- **Webhook:** `https://n8n.vividwalls.blog/webhook/retail-sales-agent`
- **MCP Servers:** Twenty CRM MCP, Retail MCP
- **Tools:** Store design consultation, bulk ordering

**Real Estate Sales Agent**
- **Role:** Target real estate agents and property managers
- **Webhook:** `https://n8n.vividwalls.blog/webhook/real-estate-sales-agent`
- **MCP Servers:** Twenty CRM MCP, Real Estate MCP
- **Tools:** Property staging, agent partnerships

#### Residential Sales Agents

**Homeowner Sales Agent**
- **Role:** Target individual homeowners
- **Webhook:** `https://n8n.vividwalls.blog/webhook/homeowner-sales-agent`
- **MCP Servers:** Twenty CRM MCP, Homeowner MCP
- **Tools:** Personalized recommendations, home decor consultation

**Renter Sales Agent**
- **Role:** Target apartment renters and temporary residents
- **Webhook:** `https://n8n.vividwalls.blog/webhook/renter-sales-agent`
- **MCP Servers:** Twenty CRM MCP, Renter MCP
- **Tools:** Temporary solutions, budget-friendly options

**Interior Designer Agent**
- **Role:** Target interior designers and decorators
- **Webhook:** `https://n8n.vividwalls.blog/webhook/interior-designer-agent`
- **MCP Servers:** Twenty CRM MCP, Designer MCP
- **Tools:** Professional partnerships, bulk pricing

**Art Collector Agent**
- **Role:** Target art collectors and enthusiasts
- **Webhook:** `https://n8n.vividwalls.blog/webhook/art-collector-agent`
- **MCP Servers:** Twenty CRM MCP, Collector MCP
- **Tools:** Limited editions, exclusive offerings

**Gift Buyer Agent**
- **Role:** Target gift shoppers and special occasions
- **Webhook:** `https://n8n.vividwalls.blog/webhook/gift-buyer-agent`
- **MCP Servers:** Twenty CRM MCP, Gift MCP
- **Tools:** Gift recommendations, occasion-based marketing

#### Digital Sales Agents

**Millennial/Gen Z Agent**
- **Role:** Target younger digital-native customers
- **Webhook:** `https://n8n.vividwalls.blog/webhook/millennial-genz-agent`
- **MCP Servers:** Twenty CRM MCP, Social Media MCP
- **Tools:** Social media marketing, influencer partnerships

**Global Customer Agent**
- **Role:** Target international customers
- **Webhook:** `https://n8n.vividwalls.blog/webhook/global-customer-agent`
- **MCP Servers:** Twenty CRM MCP, International MCP
- **Tools:** Multi-language support, international shipping

### Operations Specialized Agents

#### Inventory Management Agent
- **Role:** Optimize inventory levels and stock management
- **Webhook:** `https://n8n.vividwalls.blog/webhook/inventory-management-agent`
- **MCP Servers:** Shopify MCP, Inventory MCP
- **Tools:** Stock tracking, demand forecasting, reorder optimization

#### Fulfillment Agent
- **Role:** Manage order fulfillment and shipping
- **Webhook:** `https://n8n.vividwalls.blog/webhook/fulfillment-agent`
- **MCP Servers:** Shopify MCP, Shipping MCP
- **Tools:** Order processing, shipping optimization, tracking

#### Vendor Management Agent
- **Role:** Manage relationships with print partners and suppliers
- **Webhook:** `https://n8n.vividwalls.blog/webhook/vendor-management-agent`
- **MCP Servers:** Pictorem MCP, Printful MCP, Gooten MCP
- **Tools:** Vendor selection, quality control, cost optimization

#### Quality Control Agent
- **Role:** Ensure product quality and customer satisfaction
- **Webhook:** `https://n8n.vividwalls.blog/webhook/quality-control-agent`
- **MCP Servers:** Quality MCP, Feedback MCP
- **Tools:** Quality monitoring, defect tracking, improvement recommendations

### Creative Specialized Agents

#### Visual Design Agent
- **Role:** Create visual assets and design elements
- **Webhook:** `https://n8n.vividwalls.blog/webhook/visual-design-agent`
- **MCP Servers:** Design MCP, Creative MCP
- **Tools:** Graphic design, layout optimization, visual consistency

#### Brand Management Agent
- **Role:** Maintain brand consistency and identity
- **Webhook:** `https://n8n.vividwalls.blog/webhook/brand-management-agent`
- **MCP Servers:** Brand MCP, Guidelines MCP
- **Tools:** Brand guidelines, style consistency, identity management

#### Creative Strategy Agent
- **Role:** Develop creative strategies and concepts
- **Webhook:** `https://n8n.vividwalls.blog/webhook/creative-strategy-agent`
- **MCP Servers:** Strategy MCP, Creative MCP
- **Tools:** Concept development, creative direction, trend analysis

---

## MCP Server Infrastructure

### Core MCP Servers

#### Tool-based MCP Servers (services/mcp-servers/core/)

1. **Shopify MCP Server**
   - **Purpose:** E-commerce platform integration
   - **Tools:** Order management, product sync, customer data
   - **Port:** 4001

2. **Stripe MCP Server**
   - **Purpose:** Payment processing and analytics
   - **Tools:** Payment tracking, revenue analytics, refund management
   - **Port:** 4002

3. **Supabase MCP Server**
   - **Purpose:** Database and vector store operations
   - **Tools:** Data querying, vector search, real-time updates
   - **Port:** 4003

4. **SendGrid MCP Server**
   - **Purpose:** Email campaign management
   - **Tools:** Email sending, template management, analytics
   - **Port:** 4004

5. **Telegram MCP Server**
   - **Purpose:** Real-time notifications and messaging
   - **Tools:** Message sending, bot management, channel updates
   - **Port:** 4005

6. **Twenty CRM MCP Server**
   - **Purpose:** Customer relationship management
   - **Tools:** Contact management, lead tracking, deal pipeline
   - **Port:** 4006

7. **n8n MCP Server**
   - **Purpose:** Workflow automation and orchestration
   - **Tools:** Workflow execution, status monitoring, trigger management
   - **Port:** 4007

8. **Linear MCP Server**
   - **Purpose:** Project management and task tracking
   - **Tools:** Issue management, project coordination, team collaboration
   - **Port:** 4008

9. **Listmonk MCP Server**
   - **Purpose:** Newsletter and email list management
   - **Tools:** Subscriber management, campaign creation, analytics
   - **Port:** 4009

10. **Pictorem MCP Server**
    - **Purpose:** Print partner integration
    - **Tools:** Order submission, status tracking, pricing
    - **Port:** 4010

### Agent-Specific MCP Servers

#### Prompt-based MCP Servers (services/mcp-servers/agents/)

1. **Business Manager Prompts MCP** (Port: 3002)
2. **Business Manager Resources MCP** (Port: 3001)
3. **Marketing Director Prompts MCP** (Port: 3003)
4. **Marketing Director Resources MCP** (Port: 3004)
5. **Sales Director Prompts MCP** (Port: 3005)
6. **Sales Director Resources MCP** (Port: 3006)
7. **Operations Director Prompts MCP** (Port: 3007)
8. **Operations Director Resources MCP** (Port: 3008)
9. **Customer Experience Prompts MCP** (Port: 3009)
10. **Customer Experience Resources MCP** (Port: 3010)
11. **Finance Director Prompts MCP** (Port: 3011)
12. **Finance Director Resources MCP** (Port: 3012)
13. **Analytics Director Prompts MCP** (Port: 3013)
14. **Analytics Director Resources MCP** (Port: 3014)
15. **Product Director Prompts MCP** (Port: 3015)
16. **Product Director Resources MCP** (Port: 3016)
17. **Technology Director Prompts MCP** (Port: 3017)
18. **Technology Director Resources MCP** (Port: 3018)
19. **Creative Director Prompts MCP** (Port: 3019)
20. **Creative Director Resources MCP** (Port: 3020)
21. **Social Media Director Prompts MCP** (Port: 3021)
22. **Social Media Director Resources MCP** (Port: 3022)

### Specialized MCP Servers

#### Analytics MCP Servers
- **KPI Dashboard MCP** (Port: 5001)
- **Data Processing MCP** (Port: 5002)
- **Reporting MCP** (Port: 5003)
- **Performance Analytics MCP** (Port: 5004)

#### Creative MCP Servers
- **Design MCP** (Port: 6001)
- **Content MCP** (Port: 6002)
- **Brand MCP** (Port: 6003)
- **Creative MCP** (Port: 6004)

#### Social Media MCP Servers
- **Facebook MCP** (Port: 7001)
- **Instagram MCP** (Port: 7002)
- **Pinterest MCP** (Port: 7003)
- **Social Media MCP** (Port: 7004)

#### Sales MCP Servers
- **Hospitality MCP** (Port: 8001)
- **Corporate MCP** (Port: 8002)
- **Healthcare MCP** (Port: 8003)
- **Retail MCP** (Port: 8004)
- **Real Estate MCP** (Port: 8005)
- **Homeowner MCP** (Port: 8006)
- **Renter MCP** (Port: 8007)
- **Designer MCP** (Port: 8008)
- **Collector MCP** (Port: 8009)
- **Gift MCP** (Port: 8010)

---

## Integration Points

### Webhook Endpoints

#### Production Environment
- **Base URL:** `https://n8n.vividwalls.blog/webhook/`
- **Authentication:** Bearer token required
- **Rate Limiting:** 1000 requests/hour per endpoint

#### Test Environment
- **Base URL:** `http://localhost:5678/webhook-test/`
- **Authentication:** None required for testing
- **Rate Limiting:** None for development

### API Endpoints

#### n8n API
- **Base URL:** `https://n8n.vividwalls.blog/api/v1/`
- **Authentication:** API key required
- **Endpoints:**
  - `/workflows` - Workflow management
  - `/executions` - Execution monitoring
  - `/webhooks` - Webhook management

#### Supabase API
- **Base URL:** `https://supabase.vividwalls.blog/rest/v1/`
- **Authentication:** Service role key
- **Endpoints:**
  - `/agents` - Agent data management
  - `/workflows` - Workflow configurations
  - `/analytics` - Performance data

### External Service Integrations

#### Print Partners
- **Pictorem:** Production printing and fulfillment
- **Printful:** On-demand printing
- **Gooten:** Alternative print partner

#### E-commerce Platforms
- **Shopify:** Primary e-commerce platform
- **Stripe:** Payment processing
- **Twenty CRM:** Customer relationship management

#### Communication Platforms
- **SendGrid:** Email marketing
- **Telegram:** Real-time notifications
- **Listmonk:** Newsletter management

---

## Webhook Configuration

### Standard Webhook Payload Structure

```json
{
  "trigger": "agent_action",
  "timestamp": "2025-07-19T10:30:00Z",
  "agent_id": "agent_identifier",
  "action_type": "action_description",
  "data": {
    "input": "input_data",
    "parameters": "action_parameters",
    "context": "execution_context"
  },
  "metadata": {
    "workflow_id": "workflow_identifier",
    "execution_id": "execution_identifier",
    "priority": "high|medium|low",
    "requires_approval": true|false
  }
}
```

### Webhook Response Structure

```json
{
  "status": "success|error|pending",
  "message": "response_message",
  "data": {
    "result": "action_result",
    "next_steps": "subsequent_actions",
    "approval_required": true|false
  },
  "timestamp": "2025-07-19T10:30:00Z",
  "execution_id": "execution_identifier"
}
```

### Authentication

#### Production Authentication
```bash
# Bearer token authentication
Authorization: Bearer YOUR_WEBHOOK_TOKEN

# API key authentication
X-API-Key: YOUR_API_KEY
```

#### Test Environment
```bash
# No authentication required for local development
# Use localhost URLs for testing
```

### Error Handling

#### Standard Error Responses
```json
{
  "status": "error",
  "error_code": "ERROR_CODE",
  "message": "Error description",
  "details": "Additional error information",
  "timestamp": "2025-07-19T10:30:00Z"
}
```

#### Common Error Codes
- `INVALID_PAYLOAD` - Malformed request data
- `AUTHENTICATION_FAILED` - Invalid credentials
- `RATE_LIMIT_EXCEEDED` - Too many requests
- `AGENT_NOT_FOUND` - Agent identifier not found
- `WORKFLOW_FAILED` - Workflow execution error
- `APPROVAL_REQUIRED` - Human approval needed

---

## Development Guidelines

### Agent Development Standards

#### Naming Conventions
- **Agent Names:** `[Function]_[Target]_agent.json`
- **Webhook URLs:** `webhook/[agent-name]`
- **MCP Servers:** `[function]-[type]-mcp-server`

#### Required Fields
Every agent workflow must include:
- `id`: Unique identifier (UUID-based)
- `name`: Descriptive agent name
- `description`: Agent role and objectives
- `webhook_url`: Integration endpoint
- `mcp_servers`: Associated MCP servers
- `tools`: Available tools and capabilities

#### Testing Requirements
1. **Unit Testing:** Individual agent functionality
2. **Integration Testing:** MCP server connectivity
3. **End-to-End Testing:** Complete workflow execution
4. **Performance Testing:** Load and stress testing

### MCP Server Development

#### Tool-based MCP Servers
```typescript
// Standard structure for tool-based MCP servers
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const server = new McpServer({
  name: "service-name-tools",
  version: "1.0.0"
});

server.tool(
  "tool-name",
  "Tool description",
  {
    param1: z.string().describe("Parameter description"),
    param2: z.number().optional().describe("Optional parameter")
  },
  async ({ param1, param2 }) => {
    // Tool implementation
    return {
      content: [{ type: "text", text: JSON.stringify(result) }]
    };
  }
);
```

#### Prompt-based MCP Servers
```typescript
// Standard structure for prompt-based MCP servers
import { PromptDefinition } from '@modelcontextprotocol/sdk'

export const promptName: PromptDefinition = {
  name: 'prompt-identifier',
  description: 'What this prompt does',
  template: `
    Prompt template with {{variable}} placeholders
    Can include tool invocations:
    <invoke name="tool-name">
      {"param": "{{value}}"}
    </invoke>
  `
}
```

### Deployment Guidelines

#### Production Deployment
1. **Environment Setup:** Configure production environment variables
2. **Security:** Implement proper authentication and authorization
3. **Monitoring:** Set up comprehensive logging and monitoring
4. **Backup:** Establish data backup and recovery procedures
5. **Scaling:** Configure auto-scaling for high availability

#### Testing Deployment
1. **Local Development:** Use localhost for development and testing
2. **Staging Environment:** Deploy to staging for integration testing
3. **Production Testing:** Gradual rollout with monitoring
4. **Rollback Plan:** Maintain ability to rollback changes

### Maintenance Procedures

#### Regular Maintenance Tasks
- **Weekly:** Validate all agent workflows
- **Monthly:** Review and update documentation
- **Quarterly:** Audit agent performance and optimization
- **Annually:** Strategic architecture review

#### Monitoring and Alerting
- **Agent Health:** Monitor agent uptime and performance
- **MCP Connectivity:** Track MCP server availability
- **Webhook Performance:** Monitor webhook response times
- **Error Tracking:** Alert on critical errors and failures

---

## Conclusion

The VividWalls Multi-Agent System represents a comprehensive AI-powered business automation platform with 70+ specialized agents working in harmony to achieve business objectives. The system's hierarchical architecture, extensive MCP server infrastructure, and robust integration capabilities enable 24/7 autonomous operations while maintaining human oversight at critical decision points.

**Key Success Factors:**
- **Scalable Architecture:** Hierarchical agent structure supports growth
- **Comprehensive Integration:** 50+ MCP servers provide extensive capabilities
- **Robust Monitoring:** Real-time performance tracking and alerting
- **Flexible Deployment:** Support for both development and production environments
- **Continuous Improvement:** Regular optimization and enhancement procedures

This compendium serves as the definitive reference for all VividWalls MAS agents, their capabilities, and integration points, enabling effective development, deployment, and maintenance of the system.

---

**Document Version:** 2.0  
**Last Updated:** July 19, 2025  
**Next Review:** August 19, 2025  
**Maintained By:** VividWalls Product Team 