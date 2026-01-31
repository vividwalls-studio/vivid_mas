# VividWalls MAS Agent Knowledge Retrieval & Reasoning System Deployment Guide

This guide provides step-by-step instructions for deploying the comprehensive agent knowledge retrieval and reasoning system that ensures all VividWalls agents have access to vector and graph databases with proper domain filtering and reasoning capabilities.

## 🏗️ System Architecture Overview

The knowledge retrieval and reasoning system consists of four main components:

1. **Vector Database (PostgreSQL + pgvector)** - Domain-filtered semantic search
2. **Knowledge Graph (Neo4j)** - Relationship and pattern queries  
3. **Memory Cache (Redis)** - Real-time conversation context
4. **Reasoning Engine (MCP Server)** - Multi-method reasoning capabilities

## 📋 Prerequisites

- PostgreSQL with pgvector extension installed
- Neo4j database running
- Redis cache running
- Python 3.8+ environment
- n8n workflows deployed
- VividWalls MAS agents configured

## 🚀 Deployment Steps

### Step 1: Deploy Database Schema Updates

Execute the SQL schema updates to add domain filtering capabilities:

```bash
# Navigate to VividWalls project root
cd /path/to/vivid_mas

# Execute PostgreSQL schema updates
psql -h your_postgres_host -U your_username -d your_database_name -f sql_chunks/agent_knowledge_domain_setup.sql
```

**Key Changes:**
- Adds domain filtering columns to `agent_domain_knowledge` table
- Creates domain-specific access mappings for each agent
- Implements SQL functions for dynamic filtering
- Sets up audit logging for knowledge access

### Step 2: Deploy Neo4j Reasoning Patterns

Deploy the knowledge graph structure for reasoning patterns:

```bash
# Execute Neo4j Cypher script
cat services/neo4j/data/reasoning_patterns.cypher | cypher-shell -u your_neo4j_username -p your_neo4j_password
```

**Key Components:**
- 8 reasoning pattern nodes (deductive, inductive, case-based, strategic, analytical, holistic, creative, empathetic)
- Knowledge access nodes for vector DB, graph DB, and Redis cache
- Agent-to-reasoning-method relationships
- Performance monitoring structure

### Step 3: Deploy Reasoning Engine MCP Server

Deploy the multi-method reasoning engine as an MCP server:

```bash
# Install dependencies
cd services/mcp-servers/reasoning-engine
pip install -r requirements.txt

# Configure the MCP server in your MCP configuration
# Add to mcp_servers configuration:
```

```json
{
  "mcpServers": {
    "vividwalls-reasoning-engine": {
      "command": "python",
      "args": ["services/mcp-servers/reasoning-engine/reasoning_engine_mcp.py"],
      "env": {
        "ANTHROPIC_API_KEY": "your_api_key",
        "POSTGRES_CONNECTION": "your_postgres_connection_string",
        "NEO4J_URI": "your_neo4j_uri",
        "REDIS_URL": "your_redis_url"
      }
    }
  }
}
```

### Step 4: Configure n8n Vector Store Nodes

Deploy domain-specific vector store configurations for each agent:

```bash
# Copy n8n vector configurations
cp services/n8n-vector-store-configs/agents/*.json /path/to/n8n/workflows/

# Import each agent's vector store configuration into n8n
# Example for Marketing Director:
curl -X POST "http://your-n8n-host:5678/api/v1/workflows" \
  -H "Content-Type: application/json" \
  -d @services/n8n-vector-store-configs/agents/n8n_vector_node_marketingdirectoragent.json
```

### Step 5: Update Agent Configurations

Update each agent's workflow to include their domain-specific vector store and reasoning engine access:

For each agent workflow in n8n, add:

1. **Vector Store Node** - Domain-filtered knowledge retrieval
2. **Reasoning Engine Tool** - Access to appropriate reasoning methods
3. **Graph Query Node** - Knowledge graph pattern matching

## 🔧 Configuration Details

### Agent Domain Mappings

Each agent has specific domain access as defined in the system:

| Agent | Primary Domains | Reasoning Methods | Graph Patterns |
|-------|----------------|------------------|----------------|
| Business Manager | all_domains, business_strategy | deductive, strategic, holistic | MANAGES, OVERSEES, COORDINATES |
| Marketing Director | marketing, content, branding | creative, inductive, analytical | MARKETING_STRATEGY, CAMPAIGN, CONTENT |
| Sales Director | sales, customer_segments, pricing | case_based, analytical, strategic | SALES_STRATEGY, CUSTOMER_SEGMENT, DEAL |
| Analytics Director | analytics, metrics, forecasting | analytical, deductive, inductive | ANALYZES, PREDICTS, MEASURES |
| Operations Director | operations, inventory, logistics | deductive, analytical, case_based | OPERATES, FULFILLS, MANAGES_INVENTORY |
| Product Director | products, art_styles, collections | creative, inductive, case_based | PRODUCT_LINE, COLLECTION, CURATES |
| Customer Experience Director | customer_service, support, satisfaction | empathetic, case_based, analytical | SUPPORTS, RESOLVES, SATISFIES |
| Finance Director | finance, accounting, budgeting | analytical, deductive, strategic | FINANCIAL_ANALYSIS, BUDGET, INVESTMENT |
| Technology Director | technology, systems, automation | deductive, analytical, strategic | IMPLEMENTS, INTEGRATES, AUTOMATES |
| Social Media Director | social_media, engagement, content | creative, analytical, inductive | ENGAGES, PUBLISHES, INFLUENCES |

### Vector Store Filtering

Each agent's vector store access is automatically filtered using SQL:

```sql
-- Example for Marketing Director
SELECT * FROM content_embeddings 
WHERE metadata->>'domain' IN ('marketing', 'content', 'social_media', 'branding', 'customer_acquisition')
```

### Reasoning Engine Tools

The reasoning engine provides 8 distinct reasoning methods:

1. **Deductive Reasoning** - Apply business rules to specific scenarios
2. **Inductive Reasoning** - Derive patterns from observations
3. **Case-Based Reasoning** - Apply solutions from similar past cases
4. **Strategic Reasoning** - Evaluate options against goals and constraints
5. **Analytical Reasoning** - Analyze data patterns and trends
6. **Holistic Reasoning** - Integrate multiple reasoning approaches
7. **Creative Reasoning** - Generate innovative solutions
8. **Empathetic Reasoning** - Understand customer emotions and respond appropriately

## 🔍 Testing and Validation

### Step 1: Verify Database Setup

```sql
-- Check agent domain knowledge configuration
SELECT * FROM agent_knowledge_stats ORDER BY accessible_domains DESC;

-- Test domain filtering function
SELECT get_agent_domain_filter('MarketingDirectorAgent');

-- Verify vector filter clauses
SELECT agent_name, vector_filter_clause FROM agent_vector_filters;
```

### Step 2: Test Neo4j Reasoning Patterns

```cypher
// Verify reasoning pattern setup
MATCH (a:Agent)-[ur:USES_REASONING]->(r:ReasoningPattern)
RETURN a.name, collect(r.name) as reasoning_methods
ORDER BY a.name;

// Check knowledge access setup
MATCH (a:Agent)-[ha:HAS_ACCESS_TO]->(k:KnowledgeAccess)
RETURN a.name, collect(k.name) as knowledge_sources
ORDER BY a.name;
```

### Step 3: Test MCP Server

```bash
# Test reasoning engine MCP server
python -m pytest services/mcp-servers/reasoning-engine/tests/

# Test specific reasoning method
curl -X POST "http://localhost:8000/reasoning" \
  -H "Content-Type: application/json" \
  -d '{
    "method": "analytical_reasoning",
    "data": [{"value": 100, "timestamp": "2024-01-01"}, {"value": 150, "timestamp": "2024-01-02"}],
    "metrics": ["average", "trend"],
    "context": {"agent_name": "AnalyticsDirectorAgent"}
  }'
```

### Step 4: Test n8n Integration

1. Create a test workflow in n8n
2. Add the domain-specific vector store node
3. Test vector similarity search with domain filtering
4. Verify reasoning engine integration

## 📊 Monitoring and Performance

### Key Metrics to Monitor

1. **Vector Search Performance**
   - Query response time (target: < 100ms)
   - Semantic similarity accuracy
   - Domain filtering effectiveness

2. **Reasoning Engine Performance**
   - Reasoning method execution time (target: < 2 seconds)
   - Decision quality scores
   - Agent satisfaction ratings

3. **Knowledge Graph Performance**
   - Pattern matching query time
   - Relationship traversal efficiency
   - Graph update synchronization

### Performance Optimization

1. **Database Indexing**
   - Vector similarity indexes on embeddings
   - Domain filtering indexes on metadata
   - Agent access pattern indexes

2. **Caching Strategy**
   - Redis cache for frequent queries
   - Materialized views for complex aggregations
   - Connection pooling for database access

3. **Load Balancing**
   - Multiple MCP server instances
   - Database read replicas
   - CDN for static knowledge content

## 🔐 Security and Access Control

### Authentication and Authorization

1. **Agent Authentication**
   - Unique agent tokens for MCP access
   - Role-based access control (RBAC)
   - Domain-specific permissions

2. **Data Encryption**
   - TLS encryption for all data in transit
   - Database-level encryption for sensitive data
   - API key encryption for external services

3. **Audit Logging**
   - All knowledge access logged in `agent_knowledge_access_log`
   - Reasoning method usage tracking
   - Performance metrics collection

## 🛠️ Troubleshooting

### Common Issues

1. **Vector Search Not Working**
   - Check pgvector extension installation
   - Verify embedding dimensions match
   - Ensure domain metadata is properly set

2. **Reasoning Engine Errors**
   - Check MCP server logs
   - Verify API key configuration
   - Test individual reasoning methods

3. **Knowledge Graph Queries Slow**
   - Check Neo4j indexes
   - Optimize Cypher queries
   - Monitor memory usage

### Diagnostic Commands

```bash
# Check MCP server status
curl -X GET "http://localhost:8000/health"

# Verify PostgreSQL vector extension
psql -c "SELECT * FROM pg_extension WHERE extname = 'vector';"

# Check Neo4j connectivity
cypher-shell "MATCH (n) RETURN count(n) as total_nodes;"

# Test Redis cache
redis-cli ping
```

## 📈 Future Enhancements

### Planned Improvements

1. **Advanced Reasoning Methods**
   - Probabilistic reasoning
   - Fuzzy logic integration
   - Machine learning-enhanced pattern recognition

2. **Enhanced Knowledge Integration**
   - Real-time knowledge graph updates
   - Automated domain classification
   - Multi-modal knowledge embeddings

3. **Performance Optimizations**
   - GPU-accelerated vector search
   - Distributed reasoning engine
   - Predictive caching mechanisms

### Integration Roadmap

1. **Q1 2024**: Basic deployment and testing
2. **Q2 2024**: Performance optimization and monitoring
3. **Q3 2024**: Advanced reasoning methods
4. **Q4 2024**: Multi-modal knowledge integration

## 🎯 Success Criteria

The deployment is considered successful when:

✅ All 10 agents have domain-filtered vector store access  
✅ Reasoning engine provides 8 distinct reasoning methods  
✅ Knowledge graph queries execute within performance targets  
✅ Vector similarity search returns relevant domain-specific results  
✅ Audit logging captures all knowledge access events  
✅ Performance monitoring shows system health within acceptable ranges  

## 📞 Support and Maintenance

For ongoing support:

1. **Development Team**: Technical implementation questions
2. **DevOps Team**: Infrastructure and deployment issues  
3. **Data Team**: Knowledge base content and quality
4. **Agent Team**: Agent-specific reasoning configuration

---

**Last Updated**: January 2024  
**Version**: 1.0  
**Maintained by**: VividWalls MAS Development Team 