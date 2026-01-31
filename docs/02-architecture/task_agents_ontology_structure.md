# VividWalls Task-Specific Agents Ontology Structure

## Overview
This document outlines the ontology structure for all 23 task-specific agents in the VividWalls multi-agent system. Each agent has specialized domain authorities that provide knowledge for their specific areas of expertise.

## Task Agent Categories and Domain Authorities

### 1. Marketing Task Agents (3 agents)

#### Audience Intelligence Agent
- **ID**: 46d67126-b4e1-40f3-8a73-ae7beaf28ff4
- **Reports to**: Marketing Director
- **Specializations**: Customer segmentation, lookalike audiences, behavioral analysis
- **Domain Authorities**:
  - Social Media Examiner - Audience insights, social targeting
  - Neil Patel - Audience segmentation, customer profiling
  - HubSpot Marketing - Buyer personas, audience analysis

#### Campaign Analytics Agent
- **ID**: 6d1fb6a0-5a58-47c6-8768-aff935e16f39
- **Reports to**: Marketing Director
- **Specializations**: ROAS calculation, attribution modeling, A/B testing
- **Domain Authorities**:
  - Occam's Razor - Campaign metrics, analytics
  - ConversionXL - Conversion optimization, A/B testing
  - Analytics Mania - Campaign tracking, attribution

#### Creative Content Agent
- **ID**: 5d08e634-cf7d-4f82-a2a9-63d9c64aa9b9
- **Reports to**: Marketing Director
- **Specializations**: Ad copy generation, product descriptions, social content
- **Domain Authorities**:
  - Copyblogger - Copywriting, content creation
  - Copy Hackers - Ad copy, conversion copy
  - Unbounce - Landing pages, creative optimization

### 2. Analytics Task Agents (5 agents)

#### Budget Intelligence Agent
- **ID**: 9adc64aa-b2e1-492b-91b6-8290a6eff2e9
- **Reports to**: Analytics Director
- **Specializations**: Budget optimization, variance analysis, allocation
- **Domain Authorities**:
  - ProfitWell - Budget optimization, CAC analysis
  - Klipfolio - Budget metrics, financial KPIs
  - Baremetrics - SaaS metrics, budget planning

#### Customer Lifecycle Agent
- **ID**: 6da3910e-a5ce-47c8-96e2-9699fe153c1f
- **Reports to**: Analytics Director
- **Specializations**: LTV calculation, churn prediction, retention
- **Domain Authorities**:
  - Amplitude - Customer lifecycle, retention analytics
  - Reforge - Growth metrics, LTV optimization
  - Chaotic Flow - Subscription metrics, churn analysis

#### Predictive Modeling Agent
- **ID**: e18f66d5-ef52-4a6e-aea6-7e693148552b
- **Reports to**: Analytics Director
- **Specializations**: Demand forecasting, price optimization, ML models
- **Domain Authorities**:
  - Machine Learning Mastery - Predictive models, forecasting
  - Data Science Central - ML algorithms, predictive analytics
  - Analytics Vidhya - Data modeling, predictions

#### Revenue Analytics Agent
- **ID**: 4c5c5bc1-040d-4921-bab3-5403fe26c3e0
- **Reports to**: Analytics Director
- **Specializations**: Revenue recognition, MRR/ARR analysis, growth metrics
- **Domain Authorities**:
  - SaaS Metrics - Revenue analytics, MRR/ARR
  - ChartMogul - Revenue recognition, growth metrics
  - Geckoboard - Revenue dashboards, KPI tracking

#### Statistical Analysis Agent
- **ID**: 0588b12e-6f01-4d7d-895d-63d3910e8270
- **Reports to**: Analytics Director
- **Specializations**: A/B testing statistics, correlation analysis, regression
- **Domain Authorities**:
  - Evan Miller - A/B testing statistics, significance
  - Cross Validated - Statistical methods, data analysis
  - Optimizely - Experimentation, statistics

### 3. Product Task Agents (3 agents)

#### Art Trend Intelligence Agent
- **ID**: ab88bcd7-33ab-4544-b6e8-916b23508a74
- **Reports to**: Product Director
- **Specializations**: Visual trends, color analysis, style evolution
- **Domain Authorities**:
  - Artnet - Art trends, market analysis
  - ARTnews - Contemporary art, trend reports
  - Designboom - Design trends, visual arts

#### Product Content Agent
- **ID**: 4f93b651-6a2f-440a-a81a-43a3d8083cbe
- **Reports to**: Product Director
- **Specializations**: SEO descriptions, category content, schema markup
- **Domain Authorities**:
  - Salsify - Product content, PIM best practices
  - BigCommerce - Product descriptions, SEO
  - Shopify Blog - Product pages, content optimization

#### Product Performance Agent
- **ID**: 6525191e-7652-415c-a5f2-5ff7a9fe5f22
- **Reports to**: Product Director
- **Specializations**: Conversion analysis, price elasticity, lifecycle management
- **Domain Authorities**:
  - Productboard - Product analytics, performance metrics
  - Pendo - Product usage, feature adoption
  - Mixpanel - Product metrics, user behavior

### 4. Customer Task Agents (2 agents)

#### Customer Sentiment Agent
- **ID**: e2f91aef-8ebf-4431-8d3b-21bf89e41b7d
- **Reports to**: Customer Experience Director
- **Specializations**: Review sentiment, ticket classification, satisfaction prediction
- **Domain Authorities**:
  - Lexalytics - Sentiment analysis, text analytics
  - MonkeyLearn - NLP, customer feedback analysis
  - Brandwatch - Social sentiment, brand monitoring

#### Response Generation Agent
- **ID**: 46240834-f320-42cd-8156-f2fa7ea7c990
- **Reports to**: Customer Experience Director
- **Specializations**: Service responses, proactive communication, escalation handling
- **Domain Authorities**:
  - Groove - Customer service templates, response strategies
  - Intercom - Customer messaging, support automation
  - Kayako - Help desk, response optimization

### 5. Operations Task Agents (4 agents)

#### Fulfillment Analytics Agent
- **ID**: 5dd31779-8c6d-452c-aa15-32569c758883
- **Reports to**: Operations Director
- **Specializations**: Order processing, shipping optimization, delivery tracking
- **Domain Authorities**:
  - ShipBob - Fulfillment metrics, 3PL insights
  - EasyPost - Shipping analytics, carrier optimization
  - Freightos - Logistics analytics, shipping costs

#### Inventory Optimization Agent
- **ID**: aeaa8ad0-53a2-489c-93ad-d31d350c078b
- **Reports to**: Operations Director
- **Specializations**: Demand forecasting, reorder optimization, seasonal analysis
- **Domain Authorities**:
  - Inventory Ops - Inventory management, optimization strategies
  - TradeGecko - Inventory control, demand planning
  - Skubana - Multichannel inventory, stock optimization

#### Supply Chain Intelligence Agent
- **ID**: ab7bb3bc-8f4f-4df8-8d7f-7e9ac133c3a2
- **Reports to**: Operations Director
- **Specializations**: Supplier assessment, cost analysis, quality monitoring
- **Domain Authorities**:
  - SCM World - Supply chain trends, best practices
  - Supply Chain Quarterly - SCM strategies, risk management
  - Inbound Logistics - Supplier management, logistics

#### Data Extraction Agent
- **ID**: 7af343c8-02e5-4de8-b169-326ce1ef9c60
- **Reports to**: Operations Director
- **Specializations**: Multi-platform extraction, API integration, data validation
- **Domain Authorities**:
  - Import.io - Web scraping, data extraction
  - Apify - Automation, data collection
  - ParseHub - Data parsing, API integration

### 6. Technology Task Agents (4 agents)

#### Automation Development Agent
- **ID**: 0d5e0a14-d703-4fd4-898e-996e4a52e294
- **Reports to**: Technology Director
- **Specializations**: n8n workflows, API development, process automation
- **Domain Authorities**:
  - n8n Blog - Workflow automation, n8n tutorials
  - Zapier - Automation patterns, integration recipes
  - Make - Automation workflows, no-code solutions

#### Performance Optimization Agent
- **ID**: 0ed609c8-efe7-46af-9fc7-9938abc35b3e
- **Reports to**: Technology Director
- **Specializations**: Website speed, database optimization, system monitoring
- **Domain Authorities**:
  - web.dev - Web performance, optimization techniques
  - WebPageTest - Performance testing, metrics
  - CSS Wizardry - Frontend performance, optimization

#### System Integration Agent
- **ID**: 117d5975-929f-4cd5-98aa-74d779e9f664
- **Reports to**: Technology Director
- **Specializations**: Shopify apps, third-party integration, database design
- **Domain Authorities**:
  - MuleSoft - API integration, system connectivity
  - TIBCO - Integration patterns, middleware
  - Tray.io - iPaaS, integration automation

#### Report Generation Agent
- **ID**: f53551f4-d825-40f0-bd3c-68686ec5e2ff
- **Reports to**: Technology Director
- **Specializations**: Dashboard creation, automated reports, data visualization
- **Domain Authorities**:
  - Tableau - Data visualization, dashboards
  - Power BI - Reporting tools, BI solutions
  - Sisense - Analytics reporting, data storytelling

### 7. Finance Task Agents (1 agent)

#### Financial Calculation Agent
- **ID**: 5798712f-c4b4-4ac8-a9b0-1a278eebf894
- **Reports to**: Finance Director
- **Specializations**: Unit economics, cash flow forecasting, pricing algorithms
- **Domain Authorities**:
  - WallStreetMojo - Financial modeling, calculations
  - CFI - Financial analysis, valuation
  - Investopedia - Financial formulas, metrics

## Neo4j Graph Structure

### Node Types
- **Agent**: All 30 agents (7 directors + 23 task agents)
- **Knowledge**: Crawled domain knowledge items
- **Topic**: Subject matter topics from domain authorities
- **BusinessDomain**: High-level business domains
- **Specialization**: Specific areas of expertise

### Relationship Types
- **REPORTS_TO**: Task agents → Director agents
- **HAS_KNOWLEDGE**: Agents → Knowledge items
- **COVERS**: Knowledge → Topics
- **OPERATES_IN**: Agents → Business domains
- **BELONGS_TO**: Specializations → Business domains
- **SPECIALIZES_IN**: Agents → Specializations

## Usage Instructions

1. **Run the complete ontology builder**:
   ```bash
   cd /Volumes/SeagatePortableDrive/Projects/vivid_mas/scripts
   python build_complete_ontologies.py
   ```

2. **Query the knowledge graph**:
   ```cypher
   # Find all knowledge for a specific task agent
   MATCH (a:Agent {type: 'TaskAgent'})-[:HAS_KNOWLEDGE]->(k:Knowledge)
   WHERE a.role CONTAINS 'Audience Intelligence'
   RETURN a.name, k.title, k.url, k.topics
   
   # Show reporting structure
   MATCH (task:Agent)-[:REPORTS_TO]->(director:Agent)
   RETURN director.name, collect(task.name) as reports
   ```

3. **Extend the ontology**:
   - Add new domain authorities to `task_agents_config.py`
   - Run the builder script to crawl and add new knowledge
   - The system automatically creates relationships and specializations

## Benefits

1. **Specialized Knowledge**: Each task agent has access to domain-specific knowledge from authoritative sources
2. **Hierarchical Structure**: Clear reporting relationships between task and director agents
3. **Topic Clustering**: Knowledge is organized by topics for efficient retrieval
4. **Collaborative Intelligence**: Agents can discover related knowledge through graph traversal
5. **Scalable Architecture**: Easy to add new agents or knowledge sources