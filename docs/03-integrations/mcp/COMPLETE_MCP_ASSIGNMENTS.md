# Complete MCP Assignments for VividWalls Multi-Agent System

Based on the ecosystem diagram and system architecture, this document provides the definitive MCP (Model Context Protocol) server assignments for each agent in the hierarchy.

## 1. Business Manager Agent (Orchestrator)

**Executive Communication MCPs:**
- `telegram-mcp` - Direct stakeholder notifications to Kingler Bercy
- `sendgrid-mcp` - Formal executive reports via email  
- `html-report-generator-mcp` - Interactive dashboards

**Management MCPs:**
- `linear-mcp-server` - Project management and task delegation
- `n8n-mcp-server` - Workflow orchestration oversight
- `business-manager-prompts` - Strategic prompt templates
- `business-manager-resource` - Executive frameworks

**Analytics MCPs:**
- `kpi-dashboard-mcp-server` - Cross-department KPIs
- `business-scorecard-mcp-server` - Executive scorecard

## 2. Marketing Director

**Agent-Specific MCPs:**
- `marketing-director-prompts` - Marketing strategy prompts
- `marketing-director-resource` - Marketing knowledge base

**Marketing Tools:**
- `shopify-mcp-server` - Product catalog and customer data
- `wordpress-mcp-server` - Content management
- `sendgrid-mcp-server` - Email campaign management
- `marketing-analytics-aggregator` - Campaign analytics

**Shared MCPs:**
- `linear-mcp-server` - Task management
- `neo4j-mcp-server` - Knowledge graph (marketing domain)

**Manages:**
- Social Media Director
- Creative Director
- 9 specialized marketing agents

## 3. Sales Director  

**Agent-Specific MCPs:**
- `sales-director-prompts` - Sales strategy prompts
- `sales-director-resource` - Sales playbooks and frameworks

**Sales Tools:**
- `shopify-mcp-server` - Order management and customer data
- `stripe-mcp-server` - Payment processing and revenue analytics
- `twenty-mcp-server` - CRM operations
- `sales-analytics-mcp` - Sales performance metrics

**Shared MCPs:**
- `linear-mcp-server` - Task management
- `neo4j-mcp-server` - Knowledge graph (sales domain)

**Manages:**
- 13 specialized sales persona agents (5 commercial, 5 residential, 2 digital)

## 4. Operations Director

**Agent-Specific MCPs:**
- `operations-director-prompts` - Operations strategy prompts
- `operations-director-resource` - Operations procedures

**Operations Tools:**
- `shopify-mcp-server` - Inventory and fulfillment management
- `medusa-mcp-server` - Advanced e-commerce operations
- `pictorem-mcp-server` - Print-on-demand integration

**Shared MCPs:**
- `linear-mcp-server` - Task management
- `neo4j-mcp-server` - Knowledge graph (operations domain)

**Manages:**
- 6 specialized operations agents

## 5. Customer Experience Director

**Agent-Specific MCPs:**
- `customer-experience-director-prompts` - CX strategy prompts
- `customer-experience-director-resource` - CX frameworks

**Customer Tools:**
- `twenty-mcp-server` - Customer relationship management
- `sendgrid-mcp-server` - Customer communications
- `listmonk-mcp-server` - Newsletter management
- `shopify-mcp-server` - Customer order history

**Shared MCPs:**
- `linear-mcp-server` - Task management
- `neo4j-mcp-server` - Knowledge graph (customer domain)

**Manages:**
- 6 specialized CX agents

## 6. Product Director

**Agent-Specific MCPs:**
- `product-director-prompts` - Product strategy prompts
- `product-director-resource` - Product development frameworks

**Product Tools:**
- `shopify-mcp-server` - Product catalog management
- `pictorem-mcp-server` - Artwork and print specifications
- `wordpress-mcp-server` - Product content and descriptions

**Shared MCPs:**
- `linear-mcp-server` - Task management
- `neo4j-mcp-server` - Knowledge graph (product domain)

**Manages:**
- 4 specialized product agents

## 7. Finance Director

**Agent-Specific MCPs:**
- `finance-director-prompts` - Financial strategy prompts
- `finance-director-resource` - Financial models and frameworks

**Financial Tools:**
- `stripe-mcp-server` - Payment analytics and revenue tracking
- `shopify-mcp-server` - Sales data and financial metrics
- `financial-analytics-mcp` - Budget and ROI analysis

**Shared MCPs:**
- `linear-mcp-server` - Task management
- `neo4j-mcp-server` - Knowledge graph (finance domain)

**Manages:**
- 3 specialized finance agents

## 8. Analytics Director

**Agent-Specific MCPs:**
- `analytics-director-prompts` - Analytics strategy prompts
- `analytics-director-resource` - Analytics frameworks

**Analytics Tools:**
- `supabase-mcp-server` - Database queries and analytics
- `kpi-dashboard-mcp-server` - Performance metrics
- `shopify-mcp-server` - E-commerce analytics
- `marketing-analytics-aggregator` - Marketing data analysis

**Shared MCPs:**
- `linear-mcp-server` - Task management
- `neo4j-mcp-server` - Knowledge graph (full access)

**Manages:**
- 4 specialized analytics agents

## 9. Technology Director

**Agent-Specific MCPs:**
- `technology-director-prompts` - Tech strategy prompts
- `technology-director-resource` - Technical documentation

**Technical Tools:**
- `n8n-mcp-server` - Workflow automation management
- `supabase-mcp-server` - Database administration
- `neo4j-mcp-server` - Knowledge graph administration

**Shared MCPs:**
- `linear-mcp-server` - Task management

**Manages:**
- 3 specialized tech agents

## 10. Social Media Director (Reports to Marketing)

**Agent-Specific MCPs:**
- `social-media-director-prompts` - Social strategy prompts
- `social-media-director-resource` - Platform best practices

**Platform Tools:**
- `facebook-analytics-mcp` - Facebook/Meta insights
- `pinterest-mcp-server` - Pinterest management
- `postiz-mcp-server` - Social media scheduling

**Shared MCPs:**
- `linear-mcp-server` - Task management
- `neo4j-mcp-server` - Knowledge graph (social media domain)

**Manages:**
- Facebook Agent
- Instagram Agent  
- Pinterest Agent

## 11. Creative Director (Reports to Marketing)

**Agent-Specific MCPs:**
- `creative-director-prompts` - Creative strategy prompts
- `creative-director-resource` - Design guidelines

**Creative Tools:**
- `pictorem-mcp-server` - Artwork management
- `wordpress-mcp-server` - Content creation
- `figma-mcp-server` - Design collaboration

**Shared MCPs:**
- `linear-mcp-server` - Task management
- `neo4j-mcp-server` - Knowledge graph (creative domain)

**Manages:**
- Design Agent
- Content Creation Agent
- Brand Consistency Agent

## 12. Compliance & Risk Director

**Agent-Specific MCPs:**
- `compliance-director-prompts` - Compliance strategy prompts
- `compliance-director-resource` - Legal and regulatory frameworks

**Compliance Tools:**
- `compliance-monitoring-mcp` - Regulatory tracking
- `risk-assessment-mcp` - Risk analysis tools

**Shared MCPs:**
- `linear-mcp-server` - Task management
- `neo4j-mcp-server` - Knowledge graph (compliance domain)

**Manages:**
- Data Privacy Agent
- Crisis Management Agent

## 13. Vendor & Partner Director

**Agent-Specific MCPs:**
- `vendor-director-prompts` - Vendor management prompts
- `vendor-director-resource` - Partner frameworks

**Vendor Tools:**
- `vendor-management-mcp` - Vendor tracking
- `contract-management-mcp` - Contract administration

**Shared MCPs:**
- `linear-mcp-server` - Task management
- `neo4j-mcp-server` - Knowledge graph (vendor domain)

**Manages:**
- Vendor Management Agent

## Communication Rules

### Hierarchical Access
1. **Business Manager Only**: Telegram, Email (to stakeholder)
2. **Directors Only**: Can delegate to their direct reports
3. **No Cross-Director Access**: Directors cannot directly access other directors' agents
4. **Shared Resources**: All can access Linear and Neo4j (domain-filtered)

### Tool Access Patterns
1. **Read-Write Access**: Agents have full access to their assigned MCPs
2. **Read-Only Access**: Analytics Director can read from all data MCPs
3. **Domain Filtering**: Neo4j access is filtered by agent domain
4. **Audit Trail**: All MCP actions are logged for compliance

## Special Implementation Task Agents

### Task Agent 1: MCP Integration Specialist
- Ensures all MCP connections are properly configured
- Validates credential setup
- Tests tool accessibility

### Task Agent 2: Workflow Implementation
- Creates missing agent workflows
- Ensures proper node connections
- Validates trigger configurations

### Task Agent 3: Vector Store Integration
- Implements Supabase pgvector connections
- Sets up knowledge retrieval patterns
- Configures embedding pipelines

### Task Agent 4: Sales Consolidation
- Consolidates 13 sales persona agents
- Implements unified sales workflows
- Ensures proper MCP access for each persona

### Task Agent 5: Error Handling & Resilience
- Implements error handling for MCP failures
- Adds retry logic and fallback patterns
- Ensures system resilience

## Implementation Priority

1. **Phase 1**: Business Manager executive tools (Telegram, Email, Reports)
2. **Phase 2**: Director-level prompts and resources
3. **Phase 3**: Core service MCPs (Shopify, Linear, Supabase)
4. **Phase 4**: Specialized tool MCPs per department
5. **Phase 5**: Cross-functional integrations and testing