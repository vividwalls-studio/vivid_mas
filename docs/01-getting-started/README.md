# VividWalls Multi-Agent System Documentation

This directory contains the comprehensive documentation for the VividWalls Multi-Agent System (MAS).

## Directory Structure

### 📁 architecture/
Core architectural documentation and system design files.

- **MAS_ORGANIZATIONAL_HIERARCHY.md** - Complete agent hierarchy with all 9 directors and ~48 specialized agents
- **CONSOLIDATED_AGENT_ARCHITECTURE.md** - Consolidated architecture with modern terminology
- **agent-architecture.md** - Visual architecture diagrams and flow charts
- **TERMINOLOGY_MIGRATION_COMPLETE.md** - Terminology guide (Task Agents → Specialized Agents)
- **MULTI_AGENT_SYSTEM_SCHEMA.md** - Database schema and data structures
- **agent-domain-knowledge.md** - Domain knowledge mappings for agents
- **task_agents_ontology_structure.md** - Ontology structure for specialized agents
- **ecommerce_sbvr_rules.md** - Business rules in SBVR format

### 📁 implementation/
Setup guides and implementation plans.

- **VIVID_MAS_MASTER_IMPLEMENTATION_PLAN.md** - Comprehensive 12-week implementation roadmap
- **VIVID_MAS_IMPLEMENTATION_DOCUMENTATION.md** - Complete implementation documentation
- **COMPLETE_SETUP_GUIDE.md** - Step-by-step setup instructions
- **UNIFIED_MAS_IMPLEMENTATION_PLAN.md** - Unified approach to MAS deployment
- **n8n_import_instructions.md** - Instructions for importing n8n workflows

### 📁 business/
Business model, financial planning, and market data.

- **VividWalls_Business_Model_Canvas.md** - Business model canvas
- **VividWalls_Financial_Model_Summary.md** - 5-year financial projections
- **FINANCIAL_TRACKING_SYSTEM_DESIGN.md** - Financial tracking system architecture

#### 📁 business/data/
Market research and data resources.

- **GEOGRAPHIC_INCOME_DATA_GUIDE.md** - Geographic income data for targeting
- **INCOME_DATA_INTEGRATION_SUMMARY.md** - Income data integration strategy
- **RESEARCH_REPORTS_TABLE_GUIDE.md** - Research reports database structure

#### 📁 business/marketing/
Marketing and lead generation strategies.

- **email-scrapping-nomenclature.md** - Email collection methodology
- **linkedIn-LeadGeneration.md** - LinkedIn lead generation strategies
- **MCP_LEAD_GENERATION_GUIDE.md** - MCP-based lead generation guide

### 📁 technical/
Technical documentation for developers and system administrators.

- **MCP_SERVERS_COMPLETE_DOCUMENTATION_UPDATED.md** - Complete MCP servers documentation
- **DATABASE_SEEDING_ANALYSIS.md** - Database seeding strategies
- **POPULATE_DATABASE_INSTRUCTIONS.md** - Database population procedures
- **N8N_AGENT_WORKFLOW_STANDARDS.md** - n8n workflow development standards
- **POSTGREST_SUPABASE_GUIDE.md** - PostgREST and Supabase integration guide
- **N8N_ENCRYPTION_KEY_MANAGEMENT.md** - Critical n8n encryption key management
- **N8N_ENCRYPTION_KEY_PREVENTION.md** - Preventing encryption key issues

#### 📁 technical/workflows/
Workflow documentation and diagrams.

- **VIVID_MAS_COMPLETE_WORKFLOW_DIAGRAM.md** - Complete system workflow diagrams
- **VividWalls_MAS_Organizational_Workflow_Structure.md** - Organizational workflow structure
- **MARKETING_WORKFLOW_DIAGRAM.md** - Marketing-specific workflows
- **ADDITIONAL_WORKFLOWS.md** - Additional workflow documentation
- **eval-n8n-workflow.md** - n8n workflow evaluation guide

#### 📁 technical/protocols/
System protocols and communication standards.

- **circuit_breakers.md** - Circuit breaker patterns for resilience
- **clarification_protocol.md** - Agent clarification protocols
- **message_acknowledgment.md** - Message acknowledgment patterns

#### 📁 technical/integrations/
Third-party integration guides.

- **crawl4ai-setup-instructions.md** - Crawl4AI setup guide
- **SEO_RESEARCH_MCP_CONFIGURATION.md** - SEO Research MCP configuration

### 📁 monitoring/
Monitoring, testing, and resilience documentation.

- **VIVID_MAS_MONITORING_DASHBOARD_DESIGN.md** - Monitoring dashboard specifications
- **VIVID_MAS_TESTING_PROCEDURES.md** - Comprehensive testing procedures
- **MAS_RESILIENCE_PLAN_ENHANCED.md** - System resilience and recovery planning

### 📁 archive/
Historical documentation and superseded files.

#### 📁 archive/2024-06-26/
Snapshot from June 26, 2024.

#### 📁 archive/superseded/
Files that have been replaced by newer versions.

#### 📁 archive/department-specific/
Department-specific historical documentation.

#### 📁 archive/legacy/
Legacy documentation from earlier versions.

## Key Documents Quick Reference

### 🚀 Getting Started
1. Start with `implementation/COMPLETE_SETUP_GUIDE.md`
2. Review `architecture/MAS_ORGANIZATIONAL_HIERARCHY.md`
3. Follow `implementation/VIVID_MAS_MASTER_IMPLEMENTATION_PLAN.md`

### 🏗️ Architecture & Design
- Agent hierarchy: `architecture/MAS_ORGANIZATIONAL_HIERARCHY.md`
- System architecture: `architecture/CONSOLIDATED_AGENT_ARCHITECTURE.md`
- Database schema: `architecture/MULTI_AGENT_SYSTEM_SCHEMA.md`
- Medusa MCP Server: `architecture/medusa-mcp-server.md`

### 🔧 Technical Implementation
- MCP servers: `technical/MCP_SERVERS_COMPLETE_DOCUMENTATION_UPDATED.md`
- n8n workflows: `technical/N8N_AGENT_WORKFLOW_STANDARDS.md`
- Encryption keys: `technical/N8N_ENCRYPTION_KEY_MANAGEMENT.md`
- Reasoning Engine: `AGENT_REASONING_ENGINE_INTEGRATION_COMPLETE.md`
- Decision Support Queries: `../services/mcp-servers/agents/decision-support-queries/README.md`

### 💼 Business & Strategy
- Business model: `business/VividWalls_Business_Model_Canvas.md`
- Financial projections: `business/VividWalls_Financial_Model_Summary.md`
- Lead generation: `business/marketing/MCP_LEAD_GENERATION_GUIDE.md`

### 📊 Monitoring & Operations
- Dashboard design: `monitoring/VIVID_MAS_MONITORING_DASHBOARD_DESIGN.md`
- Testing procedures: `monitoring/VIVID_MAS_TESTING_PROCEDURES.md`
- Resilience planning: `monitoring/MAS_RESILIENCE_PLAN_ENHANCED.md`

## Recent Updates (January 2025)

### 🆕 New Documentation
- **Reasoning Engine Integration**: Complete documentation for agent reasoning capabilities
- **Decision Support Queries**: MCP resource server providing multi-database decision support
- **Agent Knowledge Infrastructure**: Neo4j, vector embeddings, and memory pipeline documentation

### 🔄 Updated Documentation
- Agent configurations now include reasoning methods and knowledge domains
- MCP server documentation expanded with new servers
- Technical guides updated with integration patterns

## Version History

- **Current Version**: 2.1 (January 2025)
- **Latest Update**: Added reasoning engine and decision support documentation
- **Major Update**: 2.0 - Consolidated documentation structure, removed duplicates
- **Previous Version**: 1.0 (June-December 2024) - Available in archive/

## Contributing

When adding new documentation:
1. Place files in the appropriate category directory
2. Update this README with the new file
3. Archive superseded versions in `archive/superseded/`
4. Follow naming conventions: `CATEGORY_TOPIC_TYPE.md`

## Support

For questions about the documentation structure, refer to:
- Technical issues: See `technical/` directory
- Architecture questions: See `architecture/` directory
- Implementation help: See `implementation/` directory