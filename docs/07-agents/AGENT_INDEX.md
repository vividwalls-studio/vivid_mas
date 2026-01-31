# VividWalls Multi-Agent System Index

This document provides a comprehensive index of all agents in the VividWalls Multi-Agent System (MAS), including their roles, responsibilities, relationships, and links to their system prompts and n8n workflows.

## Table of Contents
- [Agent Hierarchy Overview](#agent-hierarchy-overview)
- [Core Director Agents](#core-director-agents)
- [Marketing Department Agents](#marketing-department-agents)
- [Operational Department Agents](#operational-department-agents)
- [Agent Communication Matrix](#agent-communication-matrix)

## Agent Types

VividWalls MAS distinguishes **two high-level categories** of agents:

1. **Director / Orchestrator Agents** – set strategy, allocate resources, and route tasks.  These agents own complete n8n workflows and may call other agents.
2. **Action / Task-oriented Agents** – perform scoped work and *always* operate inside a parent workflow via the
   - **Call n8n Workflow Tool** node (for delegating to a sub-workflow)
   - **MCP Client** node from `n8n-nodes-mcp` with two modes:  
     • **List Tools** – discover available tools on the target MCP server  
     • **Execute Tool** – invoke the selected tool

Agents may communicate **only within the bounds of the active workflow** they share; otherwise the communication is routed through their supervising Director.

## Agent Hierarchy Overview

The VividWalls MAS follows a hierarchical structure:
1. **Business Manager Agent** - Central orchestrator overseeing all operations
2. **Director-Level Agents** - Department heads managing specific business areas
3. **Specialist Agents** - Platform-specific and function-specific agents
4. **Task Agents** - Specialized execution agents for specific tasks

## Core Director Agents

### 1. Business Manager Agent
**Role**: Central Orchestrator & Strategic Oversight  
**Key Responsibilities**: Resource management, agent coordination, performance analysis, executive reporting  
**Coordinates With**: All director agents  
**System Prompt**: [business_manager_agent_system_prompt.md](prompts/core/business_manager_agent_system_prompt.md)  
**n8n Workflow**: [business_manager_agent.json](workflows/business_manager_agent.json)

### 2. Marketing Director Agent
**Role**: Chief Marketing Officer - Customer Acquisition & Brand Growth  
**Key Responsibilities**: Marketing strategy, budget management, CAC/LTV optimization, A/B testing  
**Coordinates With**: Business Manager, Social Media Director, Marketing specialists  
**System Prompt**: [marketing_director_agent_system_prompt.md](prompts/core/marketing_director_agent_system_prompt.md)  
**n8n Workflow**: [marketing_director_agent.json](workflows/marketing_director_agent.json)

### 3. Operations Director Agent
**Role**: Chief Operations Officer - Fulfillment & Supply Chain  
**Key Responsibilities**: Order fulfillment, inventory management, quality control, shipping logistics  
**Coordinates With**: Business Manager, Customer Experience Director, operational specialists  
**System Prompt**: [operations_director_agent.md](prompts/core/operations_director_agent.md)  
**n8n Workflow**: [operations_director_agent.json](workflows/operations_director_agent.json)

### 4. Customer Experience Director Agent
**Role**: Chief Customer Officer - Support & Retention  
**Key Responsibilities**: Customer service, retention programs, feedback management, satisfaction metrics  
**Coordinates With**: Business Manager, Operations Director, customer service agents  
**System Prompt**: [customer_experience_director_agent.md](prompts/core/customer_experience_director_agent.md)  
**n8n Workflow**: [customer_experience_director_agent.json](workflows/customer_experience_director_agent.json)

### 5. Product Director Agent
**Role**: Chief Product Officer - Catalog & Art Curation  
**Key Responsibilities**: Art curation, catalog management, pricing strategy, seasonal planning  
**Coordinates With**: Business Manager, Marketing Director, product specialists  
**System Prompt**: [product_director_agent.md](prompts/core/product_director_agent.md)  
**n8n Workflow**: [product_director_agent.json](workflows/product_director_agent.json)

### 6. Finance Director Agent
**Role**: Chief Financial Officer - Financial Management & Analysis  
**Key Responsibilities**: Revenue monitoring, budget allocation, unit economics, financial forecasting  
**Coordinates With**: Business Manager, all directors for budget approvals  
**System Prompt**: [finance_director_agent.md](prompts/core/finance_director_agent.md)  
**n8n Workflow**: [finance_director_agent.json](workflows/finance_director_agent.json)

### 7. Analytics Director Agent
**Role**: Chief Data Officer - Business Intelligence & Insights  
**Key Responsibilities**: BI dashboards, cohort analysis, KPI tracking, predictive analytics  
**Coordinates With**: Business Manager, all directors for insights  
**System Prompt**: [analytics_director_agent.md](prompts/core/analytics_director_agent.md)  
**n8n Workflow**: [analytics_director_agent.json](workflows/analytics_director_agent.json)

### 8. Technology Director Agent
**Role**: Chief Technology Officer - Systems & Automation  
**Key Responsibilities**: Platform optimization, automation workflows, API management, security  
**Coordinates With**: Business Manager, all agents for technical support  
**System Prompt**: [technology_director_agent.md](prompts/core/technology_director_agent.md)  
**n8n Workflow**: [technology_director_agent.json](workflows/technology_director_agent.json)

### 9. Social Media Director Agent
**Role**: Social Media Strategy Leader - Multi-Platform Orchestration  
**Key Responsibilities**: Social strategy, cross-platform campaigns, team management, brand consistency  
**Coordinates With**: Marketing Director, platform-specific agents  
**System Prompt**: [social_media_director_agent.md](prompts/core/social_media_director_agent.md)  
**n8n Workflow**: [social_media_director_agent.json](workflows/social_media_director_agent.json)

### 10. Creative Director Agent
**Role**: Chief Creative Officer - Visual Content & Brand Identity  
**Key Responsibilities**: Oversee image, video, and audio asset creation; define creative briefs; ensure brand identity and design principles; approve AI-generated visuals; maintain Brand Guidelines Knowledge Base  
**Coordinates With**: Marketing Director, Social Media Director, Content Strategy Agent  
**System Prompt**: [creative_director_agent_system_prompt.md](prompts/core/creative_director_agent_system_prompt.md)  
**n8n Workflow**: [creative_director_agent.json](workflows/marketing/creative_director_agent.json)

### 11. Sales Director Agent
**Role**: Chief Sales Officer - Revenue Generation & Customer Acquisition  
**Key Responsibilities**: Sales strategy, pipeline management, customer segmentation, team coordination, revenue optimization  
**Coordinates With**: Business Manager, Marketing Director, Customer Experience Director, sales specialists  
**System Prompt**: [sales_director_agent.md](prompts/core/sales_director_agent.md)  
**n8n Workflow**: [sales_director_agent.json](workflows/sales/sales_director_agent.json)

## Marketing Department Agents

### Platform Specialists

#### Facebook Agent
**Role**: Facebook Marketing Specialist  
**Focus**: Facebook/Instagram presence, social commerce, targeted advertising  
**Reports To**: Social Media Director  
**System Prompt**: [facebook_agent.md](prompts/marketing/facebook_agent.md)  
**n8n Workflow**: [facebook_agent.json](workflows/facebook_agent.json)

#### Instagram Agent
**Role**: Instagram Content Specialist  
**Focus**: Visual content, Stories/Reels, Instagram shopping  
**Reports To**: Social Media Director  
**System Prompt**: [instagram_agent.md](prompts/marketing/instagram_agent.md)  
**n8n Workflow**: [instagram_agent.json](workflows/instagram_agent.json)

#### Pinterest Agent
**Role**: Pinterest Marketing Specialist  
**Focus**: Visual discovery, Rich Pins, high-intent traffic  
**Reports To**: Social Media Director  
**System Prompt**: [pinterest_agent.md](prompts/marketing/pinterest_agent.md)  
**n8n Workflow**: [pinterest_agent.json](workflows/pinterest_agent.json)

#### Email Marketing Agent
**Role**: Email Campaign Specialist  
**Focus**: Email automation, segmentation, conversion optimization  
**Reports To**: Marketing Director  
**System Prompt**: [email_marketing_agent.md](prompts/marketing/email_marketing_agent.md)  
**n8n Workflow**: [email_marketing_agent.json](workflows/email_marketing_agent.json)

### Content Specialists

#### Copy Writer Agent
**Role**: Creative Content Creator  
**Focus**: Conversion copy, emotional storytelling, brand narrative  
**Coordinates With**: Copy Editor Agent  
**System Prompt**: [copy_writer_agent.md](prompts/marketing/copy_writer_agent.md)  
**n8n Workflow**: [copy_writer_agent.json](workflows/copy_writer_agent.json)

#### Copy Editor Agent
**Role**: Content Quality Specialist  
**Focus**: Editorial standards, brand consistency, SEO optimization  
**Coordinates With**: Copy Writer Agent  
**System Prompt**: [copy_editor_agent.md](prompts/marketing/copy_editor_agent.md)  
**n8n Workflow**: [copy_editor_agent.json](workflows/copy_editor_agent.json)

#### Newsletter Agent
**Role**: Newsletter Content Specialist  
**Focus**: Editorial planning, subscriber engagement  
**Reports To**: Marketing Director  
**System Prompt**: [newsletter_agent.md](prompts/marketing/newsletter_agent.md)  
**n8n Workflow**: Not available

### Marketing Task Agents

#### Creative Content Task Agent
**Focus**: Ad copy generation, product descriptions, social content  
**Reports To**: Marketing Director Department  
**System Prompt**: [creative_content_agent.md](prompts/marketing/creative_content_agent.md)  
**n8n Workflow**: Not available

#### Keyword Agent
**Role**: SEO & Keyword Research Specialist  
**Focus**: SEO optimization, keyword strategy, search visibility  
**Reports To**: Marketing Director  
**System Prompt**: [keyword_agent.md](prompts/marketing/keyword_agent.md)  
**n8n Workflow**: [keyword_agent.json](workflows/keyword_agent.json)

#### Marketing Research Agent
**Role**: Market Intelligence Analyst  
**Focus**: Market research, competitive analysis, trend identification  
**Reports To**: Marketing Director  
**System Prompt**: [marketing_research_agent.md](prompts/marketing/marketing_research_agent.md)  
**n8n Workflow**: [marketing_research_agent.json](workflows/marketing_research_agent.json)

#### Audience Intelligence Task Agent
**Focus**: Customer segmentation, lookalike audiences, demographic analysis  
**Reports To**: Marketing Director Department  
**System Prompt**: [audience_intelligence_agent.md](prompts/marketing/audience_intelligence_agent.md)  
**n8n Workflow**: Not available

#### Campaign Analytics Task Agent
**Focus**: ROAS calculation, attribution modeling, A/B test analysis  
**Reports To**: Marketing Director Department  
**System Prompt**: [campaign_analytics_agent.md](prompts/marketing/campaign_analytics_agent.md)  
**n8n Workflow**: Not available

## Sales Department Agents

### Commercial Buyers Team

#### Hospitality Sales Agent
**Role**: Hospitality Industry Specialist  
**Focus**: Hotels, restaurants, bars - bulk orders, ambiance enhancement  
**Reports To**: Sales Director  
**System Prompt**: [hospitality_sales_agent.md](prompts/operational/sales/hospitality_sales_agent.md)  
**n8n Workflow**: [hospitality_sales_agent.json](workflows/sales/hospitality_sales_agent.json)

#### Corporate Sales Agent
**Role**: B2B Enterprise Sales Specialist  
**Focus**: Corporate offices, workspace enhancement, employee wellness  
**Reports To**: Sales Director  
**System Prompt**: [corporate_sales_agent.md](prompts/operational/sales/corporate_sales_agent.md)  
**n8n Workflow**: [corporate_sales_agent.json](workflows/sales/corporate_sales_agent.json)

#### Healthcare Sales Agent
**Role**: Medical Facility Sales Specialist  
**Focus**: Hospitals, clinics - therapeutic art, calming environments  
**Reports To**: Sales Director  
**System Prompt**: [healthcare_sales_agent.md](prompts/operational/sales/healthcare_sales_agent.md)  
**n8n Workflow**: [healthcare_sales_agent.json](workflows/sales/healthcare_sales_agent.json)

#### Retail Sales Agent
**Role**: Retail Partnership Specialist  
**Focus**: Stores, boutiques - visual merchandising, customer experience  
**Reports To**: Sales Director  
**System Prompt**: [retail_sales_agent.md](prompts/operational/sales/retail_sales_agent.md)  
**n8n Workflow**: [retail_sales_agent.json](workflows/sales/retail_sales_agent.json)

#### Real Estate Sales Agent
**Role**: Property Staging Specialist  
**Focus**: Stagers, developers - temporary installations, model homes  
**Reports To**: Sales Director  
**System Prompt**: [real_estate_sales_agent.md](prompts/operational/sales/real_estate_sales_agent.md)  
**n8n Workflow**: [real_estate_sales_agent.json](workflows/sales/real_estate_sales_agent.json)

### Residential Buyers Team

#### Homeowner Sales Agent
**Role**: Residential Sales Specialist  
**Focus**: Personal homes, customization, room-by-room consultation  
**Reports To**: Sales Director  
**System Prompt**: [homeowner_sales_agent.md](prompts/operational/sales/homeowner_sales_agent.md)  
**n8n Workflow**: [homeowner_sales_agent.json](workflows/sales/homeowner_sales_agent.json)

#### Renter Sales Agent
**Role**: Rental Market Specialist  
**Focus**: Damage-free solutions, affordability, flexibility  
**Reports To**: Sales Director  
**System Prompt**: [renter_sales_agent.md](prompts/operational/sales/renter_sales_agent.md)  
**n8n Workflow**: [renter_sales_agent.json](workflows/sales/renter_sales_agent.json)

#### Interior Designer Sales Agent
**Role**: Trade Program Specialist  
**Focus**: Designer partnerships, trade discounts, custom projects  
**Reports To**: Sales Director  
**System Prompt**: [interior_designer_sales_agent.md](prompts/operational/sales/interior_designer_sales_agent.md)  
**n8n Workflow**: [interior_designer_sales_agent.json](workflows/sales/interior_designer_sales_agent.json)

#### Art Collector Sales Agent
**Role**: Investment Art Specialist  
**Focus**: Limited editions, provenance, collection curation  
**Reports To**: Sales Director  
**System Prompt**: [art_collector_sales_agent.md](prompts/operational/sales/art_collector_sales_agent.md)  
**n8n Workflow**: [art_collector_sales_agent.json](workflows/sales/art_collector_sales_agent.json)

#### Gift Buyer Sales Agent
**Role**: Gift Sales Specialist  
**Focus**: Special occasions, gift packages, registries  
**Reports To**: Sales Director  
**System Prompt**: [gift_buyer_sales_agent.md](prompts/operational/sales/gift_buyer_sales_agent.md)  
**n8n Workflow**: [gift_buyer_sales_agent.json](workflows/sales/gift_buyer_sales_agent.json)

### Online Shoppers Team

#### Millennial/Gen Z Sales Agent
**Role**: Digital-First Sales Specialist  
**Focus**: Social commerce, mobile experience, influencer partnerships  
**Reports To**: Sales Director  
**System Prompt**: [millennial_genz_sales_agent.md](prompts/operational/sales/millennial_genz_sales_agent.md)  
**n8n Workflow**: [millennial_genz_sales_agent.json](workflows/sales/millennial_genz_sales_agent.json)

#### Global Customer Sales Agent
**Role**: International Sales Specialist  
**Focus**: Cross-border commerce, shipping, localization  
**Reports To**: Sales Director  
**System Prompt**: [global_customer_sales_agent.md](prompts/operational/sales/global_customer_sales_agent.md)  
**n8n Workflow**: [global_customer_sales_agent.json](workflows/sales/global_customer_sales_agent.json)

## Operational Department Agents

### Sales & Customer Service

#### Sales Agent
**Role**: Sales Conversion Specialist  
**Focus**: Lead qualification, product recommendations, deal closing  
**Coordinates With**: Customer Service, Shopify Agent  
**System Prompt**: [sales_agent.md](prompts/operational/sales_agent.md)  
**n8n Workflow**: [sales_agent.json](workflows/sales_agent.json)

#### Customer Service Agent
**Role**: Support Specialist  
**Focus**: Issue resolution, customer satisfaction  
**Coordinates With**: Orders Fulfillment, Sales Agent  
**System Prompt**: [customer_service_agent.md](prompts/operational/customer_service_agent.md)  
**n8n Workflow**: [customer_service_agent.json](workflows/customer_service_agent.json)

#### Customer Relationship Agent
**Role**: CRM Specialist  
**Focus**: Customer lifecycle management, loyalty programs  
**Coordinates With**: Sales, Customer Service agents  
**System Prompt**: [customer_relationship_agent.md](prompts/operational/customer_relationship_agent.md)  
**n8n Workflow**: [customer_relationship_agent.json](workflows/customer_relationship_agent.json)

### E-commerce & Fulfillment

#### Shopify Agent
**Role**: E-commerce Platform Specialist  
**Focus**: Store management, catalog sync, order processing  
**Coordinates With**: Sales, Orders Fulfillment, Product agents  
**System Prompt**: [shopify_agent.md](prompts/operational/shopify_agent.md)  
**n8n Workflow**: [shopify_agent.json](workflows/shopify_agent.json)

#### Orders Fulfillment Agent
**Role**: Fulfillment Operations Specialist  
**Focus**: Order processing, shipping coordination  
**Coordinates With**: Pictorem Agent, Shopify, Customer Service  
**System Prompt**: [orders_fulfillment_agent.md](prompts/operational/orders_fulfillment_agent.md)  
**n8n Workflow**: [orders_fulfillment_agent.json](workflows/orders_fulfillment_agent.json)

#### Pictorem Agent Node
**Role**: Print Partner Integration Specialist  
**Focus**: Print-on-demand integration, production management  
**Coordinates With**: Orders Fulfillment Agent  
**System Prompt**: [pictorem_agent_node.md](prompts/operational/pictorem_agent_node.md)  
**n8n Workflow**: [pictorem_agent_node.json](workflows/pictorem_agent_node.json)

### Product & Analytics Task Agents

#### Color Analysis Agent
**Role**: Visual Design Specialist  
**Focus**: Color analysis, visual aesthetics optimization  
**Coordinates With**: Product Content, Art Trend Intelligence agents  
**System Prompt**: [color_analysis_agent.md](prompts/operational/color_analysis_agent.md)  
**n8n Workflow**: [color_analysis_agent.json](workflows/color_analysis_agent.json)

#### Product Content Task Agent
**Focus**: SEO-optimized descriptions, meta tags, content generation  
**Reports To**: Product Director Department  
**System Prompt**: [product_content_agent.md](prompts/operational/product_content_agent.md)  
**n8n Workflow**: Not available

#### Art Trend Intelligence Task Agent
**Focus**: Visual trends, style evolution, market demand  
**Reports To**: Product Director Department  
**System Prompt**: [art_trend_intelligence_agent.md](prompts/operational/art_trend_intelligence_agent.md)  
**n8n Workflow**: Not available

#### Product Performance Task Agent
**Focus**: Conversion analysis, price elasticity, lifecycle management  
**Reports To**: Product Director Department  
**System Prompt**: [product_performance_agent.md](prompts/operational/product_performance_agent.md)  
**n8n Workflow**: Not available

### Operations Task Agents

#### Inventory Optimization Task Agent
**Focus**: Demand forecasting, reorder optimization, seasonal analysis  
**Reports To**: Operations Director Department  
**System Prompt**: [Inventory Optimization Agent.md](prompts/operational/Inventory%20Optimization%20Agent.md)  
**n8n Workflow**: Not available

#### Fulfillment Analytics Task Agent
**Focus**: Order efficiency, shipping optimization, returns analysis  
**Reports To**: Operations Director Department  
**System Prompt**: [fulfillment_analytics_agent.md](prompts/operational/fulfillment_analytics_agent.md)  
**n8n Workflow**: Not available

#### Supply Chain Intelligence Task Agent
**Focus**: Supplier risk, cost analysis, quality monitoring  
**Reports To**: Operations Director Department  
**System Prompt**: [supply_chain_intelligence_agent.md](prompts/operational/supply_chain_intelligence_agent.md)  
**n8n Workflow**: Not available

### Finance Task Agents

#### Financial Calculation Task Agent
**Focus**: Unit economics, cash flow, pricing optimization  
**Reports To**: Finance Director Department  
**System Prompt**: [financial_calculation_agent.md](prompts/operational/financial_calculation_agent.md)  
**n8n Workflow**: Not available

#### Revenue Analytics Task Agent
**Focus**: Revenue streams, cohort tracking, channel attribution  
**Reports To**: Finance Director Department  
**System Prompt**: [revenue_analytics_agent.md](prompts/operational/revenue_analytics_agent.md)  
**n8n Workflow**: Not available

#### Budget Intelligence Task Agent
**Focus**: Budget optimization, variance analysis, cost centers  
**Reports To**: Finance Director Department  
**System Prompt**: [budget_intelligence_agent.md](prompts/operational/budget_intelligence_agent.md)  
**n8n Workflow**: Not available

### Customer Experience Task Agents

#### Customer Lifecycle Task Agent
**Focus**: CLV calculation, churn prediction, retention strategies  
**Reports To**: Customer Experience Director Department  
**System Prompt**: [customer_lifecycle_agent.md](prompts/operational/customer_lifecycle_agent.md)  
**n8n Workflow**: Not available

#### Customer Sentiment Task Agent
**Focus**: Review analysis, satisfaction prediction, emotion detection  
**Reports To**: Customer Experience Director Department  
**System Prompt**: [customer_sentiment_agent.md](prompts/operational/customer_sentiment_agent.md)  
**n8n Workflow**: Not available

#### Response Generation Task Agent
**Focus**: Personalized responses, proactive communication  
**Reports To**: Customer Experience Director Department  
**System Prompt**: [response_generation_agent.md](prompts/operational/response_generation_agent.md)  
**n8n Workflow**: Not available

### Analytics Task Agents

#### Data Extraction Task Agent
**Focus**: Multi-platform data extraction, API integration  
**Reports To**: Analytics Director Department  
**System Prompt**: [data_extraction_agent.md](prompts/operational/data_extraction_agent.md)  
**n8n Workflow**: Not available

#### Report Generation Task Agent
**Focus**: Dashboard creation, automated reporting, visualization  
**Reports To**: Analytics Director Department  
**System Prompt**: [report_generation_agent.md](prompts/operational/report_generation_agent.md)  
**n8n Workflow**: Not available

#### Statistical Analysis Task Agent
**Focus**: A/B testing, regression modeling, significance testing  
**Reports To**: Analytics Director Department  
**System Prompt**: [statistical_analysis_agent.md](prompts/operational/statistical_analysis_agent.md)  
**n8n Workflow**: Not available

#### Predictive Modeling Task Agent
**Focus**: ML models, demand forecasting, recommendation systems  
**Reports To**: Analytics Director Department  
**System Prompt**: [predictive_modeling_agent.md](prompts/operational/predictive_modeling_agent.md)  
**n8n Workflow**: Not available

### Technology Task Agents

#### Automation Development Task Agent
**Focus**: n8n workflows, API integration, process automation  
**Reports To**: Technology Director Department  
**System Prompt**: [automation_development_agent.md](prompts/operational/automation_development_agent.md)  
**n8n Workflow**: Not available

#### System Integration Task Agent
**Focus**: Shopify apps, third-party integrations, microservices  
**Reports To**: Technology Director Department  
**System Prompt**: [system_integration_agent.md](prompts/operational/system_integration_agent.md)  
**n8n Workflow**: Not available

#### Performance Optimization Task Agent
**Focus**: Website speed, database optimization, monitoring  
**Reports To**: Technology Director Department  
**System Prompt**: [performance_optimization_agent.md](prompts/operational/performance_optimization_agent.md)  
**n8n Workflow**: Not available

## Agent Communication Matrix

The agents communicate following these patterns:

### Hierarchical Communication
1. **Business Manager** ↔ All Directors
2. **Directors** ↔ Their Department Specialists/Task Agents
3. **Task Agents** → Report to their Department Directors

### Cross-Functional Communication

| From/To | Marketing | Operations | Customer Exp | Product | Finance | Analytics | Technology |
|---------|-----------|------------|--------------|---------|---------|-----------|------------|
| **Marketing** | - | Inventory needs | Customer feedback | Performance data | Budget requests | Campaign metrics | Landing page optimization |
| **Operations** | Fulfillment capacity | - | Shipping updates | Stock levels | Cost data | Operational metrics | Automation needs |
| **Customer Exp** | Customer insights | Delivery issues | - | Product feedback | Refund costs | Satisfaction data | Support tool needs |
| **Product** | Launch coordination | Inventory planning | Product issues | - | Pricing input | Performance data | Catalog optimization |
| **Finance** | Budget allocation | Cost optimization | Refund approvals | Pricing strategy | - | Financial metrics | Cost tracking |
| **Analytics** | Performance insights | Efficiency metrics | Experience data | Product analytics | Financial analysis | - | Data requirements |
| **Technology** | Platform optimization | Process automation | Support tools | Catalog management | Financial systems | Data infrastructure | - |

### Example Workflow: New Product Launch
1. **Product Director** identifies new art piece
2. **Color Analysis Agent** analyzes visual elements
3. **Product Content Agent** creates descriptions
4. **Marketing Director** plans launch campaign
5. **Creative Content Agent** generates marketing copy
6. **Inventory Optimization Agent** plans stock levels
7. **Financial Calculation Agent** sets pricing
8. **Campaign Analytics Agent** tracks performance

## Technical Infrastructure

### Common Tools & Platforms
- **n8n MCP**: Workflow automation (used by all agents)
- **Supabase MCP**: Central database (used by most agents)
- **Shopify MCP**: E-commerce platform
- **Facebook Ads MCP**: Social advertising
- **Pinterest MCP**: Visual discovery platform
- **Neo4j MCP**: Knowledge graph and memory
- **Google Drive MCP**: Document storage

### Key Integrations
- Pictorem API for print-on-demand
- SendGrid/Listmonk for email marketing
- Stripe for payments
- Web scraping and research tools

## Notes

- Task Agents typically don't have dedicated n8n workflows but are invoked by their parent Director agents
- All agents maintain memory using PostgreSQL or Neo4j for context retention
- The system is designed for autonomous operation with human oversight primarily through the Business Manager Agent
- Each agent has specific KPIs and decision frameworks aligned with VividWalls' business objectives