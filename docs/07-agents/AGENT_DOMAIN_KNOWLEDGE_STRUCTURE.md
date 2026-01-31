# VividWalls MAS - Agent Domain Knowledge & Vector Collection Structure

## Summary
Analysis of the Supabase database reveals the agent knowledge base architecture and vector collection setup for the VividWalls Multi-Agent System.

## Database Tables Overview

### Agent-Related Tables (19 tables)
1. **agents** - Main agent registry
2. **agent_beliefs** - Agent belief systems
3. **agent_desires** - Agent desires/wants
4. **agent_domain_knowledge** - Domain-specific knowledge
5. **agent_goals** - Agent objectives
6. **agent_heuristic_imperatives** - Decision-making rules
7. **agent_instructions** - Operational instructions
8. **agent_intentions** - Agent intentions
9. **agent_llm_config** - LLM configuration per agent
10. **agent_mcp_tools** - MCP tool assignments
11. **agent_objectives** - Specific objectives
12. **agent_personalities** - Personality traits
13. **agent_rules** - Business rules
14. **agent_skills** - Agent capabilities
15. **agent_tasks** - Task assignments
16. **agent_voice_config** - Voice/tone configuration
17. **agent_workflows** - Workflow associations

### Embedding/Vector Tables (2 tables)
1. **content_embeddings** - General content vectors
2. **customer_embeddings** - Customer-specific vectors

## Current Agent Hierarchy

### Orchestrator Level
- **Business Manager** (type: orchestrator)
  - Central coordinator for all operations

### Director Level (9 Directors)
All report to Business Manager:
1. **Analytics Director**
2. **Customer Experience Director**
3. **Finance Director**
4. **Marketing Director**
5. **Operations Director**
6. **Product Director**
7. **Sales Director**
8. **Technology Director**
9. **Social Media Director** (also reports to Marketing Director)

### Sub-Agents
Currently, no sub-agents are populated in the database. The system is designed to support ~48 specialized agents under the directors.

## Domain Knowledge Structure

### agent_domain_knowledge Table
```sql
CREATE TABLE agent_domain_knowledge (
    id UUID PRIMARY KEY,
    agent_id UUID REFERENCES agents(id),
    vector_database VARCHAR,      -- Reference to vector DB (e.g., "qdrant")
    knowledge_graph VARCHAR,       -- Reference to graph DB (e.g., "neo4j")
    created_at TIMESTAMP WITH TIME ZONE
);
```

**Current Status**: Empty (0 records)

### agents Table Structure
```sql
CREATE TABLE agents (
    id UUID PRIMARY KEY,
    name VARCHAR,
    type VARCHAR,                 -- "orchestrator" or "director"
    role VARCHAR,                 -- Specific role
    department VARCHAR,
    level VARCHAR,
    status VARCHAR,
    parent_agent_id UUID,         -- Hierarchical relationship
    system_prompt TEXT,
    mcp_servers TEXT[],          -- Array of MCP server assignments
    description TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

**Current Status**: 10 agents (1 orchestrator, 9 directors)

## Vector Database Architecture

### PostgreSQL Vector Extension
- **Status**: Installed and active
- **Extension**: pgvector enabled

### content_embeddings Table
```sql
CREATE TABLE content_embeddings (
    id UUID PRIMARY KEY,
    content_type VARCHAR,
    content_id TEXT,
    content_text TEXT,
    embedding VECTOR,            -- Vector type from pgvector
    metadata JSONB,
    model VARCHAR,               -- Embedding model used
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);
```

**Current Status**: Empty (0 records)

### customer_embeddings Table
```sql
CREATE TABLE customer_embeddings (
    id UUID PRIMARY KEY,
    customer_id TEXT,
    preference_embedding VECTOR,
    purchase_history_embedding VECTOR,
    browsing_behavior_embedding VECTOR,
    metadata JSONB,
    last_updated TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE
);
```

**Current Status**: Empty (0 records)

## Knowledge Graph Database

### Neo4j Container
- **Status**: Running and healthy
- **Ports**: 7474 (HTTP), 7687 (Bolt)
- **Container**: neo4j:latest

## External Vector Databases

### Qdrant
- **Status**: Not running (container not found)
- **Expected Port**: 6333

## Agent Knowledge Configuration Status

### Current State
All knowledge-related tables are empty:
- agent_beliefs: 0 records
- agent_goals: 0 records
- agent_personalities: 0 records
- agent_domain_knowledge: 0 records
- agent_skills: 0 records
- agent_mcp_tools: 0 records

### MCP Server Assignments
- **Current Status**: No MCP servers assigned to any agents (mcp_servers field is NULL for all agents)

## Recommended Knowledge Base Structure

### Per-Agent Vector Collections
Each agent should have dedicated vector collections for:

1. **Domain Knowledge Collection**
   - Collection name: `{agent_name}_domain_knowledge`
   - Content: Industry-specific information, best practices, regulations
   - Embedding model: text-embedding-ada-002 or similar

2. **Task Knowledge Collection**
   - Collection name: `{agent_name}_task_knowledge`
   - Content: Previous task executions, outcomes, learnings
   - Embedding model: Same as domain

3. **Communication Templates**
   - Collection name: `{agent_name}_templates`
   - Content: Email templates, response patterns, communication styles
   - Embedding model: Same as domain

### Director-Level Collections

#### Marketing Director
- `marketing_campaigns` - Campaign history and performance
- `marketing_strategies` - Strategic plans and frameworks
- `marketing_analytics` - Market research and insights

#### Sales Director
- `sales_playbooks` - Sales strategies and techniques
- `customer_profiles` - Customer segment knowledge
- `sales_performance` - Historical sales data and patterns

#### Product Director
- `product_catalog` - Product information and specifications
- `product_feedback` - Customer reviews and feedback
- `product_roadmap` - Development plans and features

#### Finance Director
- `financial_models` - Financial planning and analysis
- `compliance_rules` - Regulatory requirements
- `budget_templates` - Budgeting frameworks

#### Technology Director
- `tech_stack` - Technology documentation
- `api_documentation` - Integration guides
- `security_policies` - Security best practices

#### Operations Director
- `operational_procedures` - SOPs and workflows
- `vendor_information` - Supplier and partner data
- `logistics_data` - Shipping and fulfillment info

#### Customer Experience Director
- `customer_journeys` - Customer experience maps
- `support_knowledge` - Support documentation
- `satisfaction_metrics` - Customer feedback data

#### Analytics Director
- `kpi_definitions` - Key performance indicators
- `reporting_templates` - Report formats
- `data_models` - Analytics frameworks

## Implementation Plan

### Phase 1: Infrastructure Setup
1. ✅ PostgreSQL with pgvector (COMPLETE)
2. ✅ Neo4j knowledge graph (COMPLETE)
3. ⏳ Qdrant vector database (NEEDS DEPLOYMENT)
4. ⏳ MCP server assignments (NEEDS CONFIGURATION)

### Phase 2: Knowledge Population
1. Create vector collections for each agent
2. Populate agent_domain_knowledge references
3. Import initial knowledge base content
4. Configure embedding pipelines

### Phase 3: Agent Configuration
1. Assign MCP servers to agents
2. Configure agent personalities and goals
3. Set up agent skills and capabilities
4. Define agent rules and heuristics

### Phase 4: Integration
1. Connect agents to vector collections
2. Link Neo4j knowledge graph
3. Set up embedding generation workflows
4. Configure RAG pipelines

## Next Steps

1. **Deploy Qdrant** for dedicated vector storage
2. **Assign MCP servers** to each agent based on responsibilities
3. **Create vector collections** for each agent's domain
4. **Populate knowledge bases** with initial content
5. **Configure embedding pipelines** in n8n workflows
6. **Test RAG functionality** for each agent

## SQL Commands for Knowledge Setup

```sql
-- Example: Assign MCP servers to Business Manager
UPDATE agents 
SET mcp_servers = ARRAY['telegram-mcp-server', 'email-mcp-server', 'supabase-mcp-server']
WHERE name = 'Business Manager';

-- Example: Add domain knowledge reference
INSERT INTO agent_domain_knowledge (id, agent_id, vector_database, knowledge_graph, created_at)
SELECT 
    gen_random_uuid(),
    id,
    'qdrant:marketing_director_knowledge',
    'neo4j:marketing_graph',
    NOW()
FROM agents WHERE name = 'Marketing Director';

-- Example: Create agent personality
INSERT INTO agent_personalities (id, agent_id, trait, value)
SELECT 
    gen_random_uuid(),
    id,
    'communication_style',
    'Professional, data-driven, strategic'
FROM agents WHERE name = 'Analytics Director';
```

## Conclusion

The database structure is well-designed to support a comprehensive knowledge management system for the Multi-Agent System. However, the knowledge bases and vector collections are currently empty and need to be populated. The infrastructure (PostgreSQL with pgvector, Neo4j) is in place, but requires configuration and data population to enable the agents' domain expertise and RAG capabilities.