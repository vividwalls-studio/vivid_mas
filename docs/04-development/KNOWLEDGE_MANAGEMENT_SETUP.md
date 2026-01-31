# VividWalls MAS Knowledge Management System - Setup Guide

## Overview
This comprehensive n8n workflow integrates PostgreSQL/Supabase, Vector Store, and Neo4j for complete agent knowledge management in the VividWalls Multi-Agent System.

## Database Setup Scripts

### 1. PostgreSQL/Supabase Setup

```sql
-- Create agent_interactions table if not exists
CREATE TABLE IF NOT EXISTS agent_interactions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    agent_id UUID REFERENCES agents(id),
    user_query TEXT,
    response JSONB,
    metadata JSONB,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX idx_agent_interactions_agent_id ON agent_interactions(agent_id);
CREATE INDEX idx_agent_interactions_timestamp ON agent_interactions(timestamp DESC);

-- Create chat_memory table for conversation context
CREATE TABLE IF NOT EXISTS chat_memory (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    session_id VARCHAR(255),
    agent_id UUID REFERENCES agents(id),
    role VARCHAR(50),
    content TEXT,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    metadata JSONB
);

CREATE INDEX idx_chat_memory_session ON chat_memory(session_id);
CREATE INDEX idx_chat_memory_agent ON chat_memory(agent_id);

-- Ensure vector extension is enabled
CREATE EXTENSION IF NOT EXISTS vector;

-- Create or verify n8n_vectors table for Supabase Vector Store
CREATE TABLE IF NOT EXISTS n8n_vectors (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    content TEXT,
    metadata JSONB,
    embedding vector(1536),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create similarity search function
CREATE OR REPLACE FUNCTION match_documents (
    query_embedding vector(1536),
    match_count INT DEFAULT 10,
    filter JSONB DEFAULT '{}'::JSONB
)
RETURNS TABLE (
    id UUID,
    content TEXT,
    metadata JSONB,
    similarity FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        n8n_vectors.id,
        n8n_vectors.content,
        n8n_vectors.metadata,
        1 - (n8n_vectors.embedding <=> query_embedding) AS similarity
    FROM n8n_vectors
    WHERE 
        CASE 
            WHEN filter::text != '{}'::text 
            THEN n8n_vectors.metadata @> filter
            ELSE TRUE
        END
    ORDER BY n8n_vectors.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;

-- Create index for vector similarity search
CREATE INDEX ON n8n_vectors USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);
```

### 2. Neo4j Knowledge Graph Setup

```cypher
// Create constraints and indexes
CREATE CONSTRAINT agent_id IF NOT EXISTS ON (a:Agent) ASSERT a.id IS UNIQUE;
CREATE CONSTRAINT knowledge_id IF NOT EXISTS ON (k:Knowledge) ASSERT k.id IS UNIQUE;
CREATE INDEX agent_name IF NOT EXISTS FOR (a:Agent) ON (a.name);
CREATE INDEX knowledge_domain IF NOT EXISTS FOR (k:Knowledge) ON (k.domain);

// Create agent hierarchy
MERGE (bm:Agent {
    id: '17f4dcdd-bf55-4e6e-ad1d-dac2598d1514',
    name: 'Business Manager',
    type: 'orchestrator',
    role: 'director'
})

MERGE (md:Agent {
    id: '4b7b0e6d-743d-448f-8f0b-9818a8923a4b',
    name: 'Marketing Director',
    type: 'director',
    role: 'director'
})
MERGE (md)-[:REPORTS_TO]->(bm)

MERGE (sd:Agent {
    id: '962f5670-bb55-4cf6-90f8-f72cefca3bdf',
    name: 'Sales Director',
    type: 'director',
    role: 'director'
})
MERGE (sd)-[:REPORTS_TO]->(bm)

// Add more directors...

// Create domain nodes
MERGE (marketing:Domain {name: 'Marketing', description: 'Marketing strategies and campaigns'})
MERGE (sales:Domain {name: 'Sales', description: 'Sales techniques and customer acquisition'})
MERGE (product:Domain {name: 'Product', description: 'Product management and development'})
MERGE (finance:Domain {name: 'Finance', description: 'Financial planning and analysis'})

// Link agents to domains
MERGE (md)-[:SPECIALIZES_IN]->(marketing)
MERGE (sd)-[:SPECIALIZES_IN]->(sales)

// Create knowledge template
MERGE (k1:Knowledge {
    id: 'knowledge-001',
    title: 'Social Media Marketing Best Practices',
    content: 'Comprehensive guide for social media campaigns...',
    domain: 'Marketing',
    confidence: 0.95,
    created_at: datetime(),
    updated_at: datetime()
})

MERGE (md)-[:KNOWS {strength: 0.9, created_at: datetime()}]->(k1)
```

## Workflow Configuration

### Required Credentials

1. **PostgreSQL MAS Database**
   - Host: postgres (container name) or localhost:5433
   - Database: postgres
   - User: postgres
   - Password: [from .env file]

2. **Supabase API**
   - URL: https://supabase.vividwalls.blog or your Supabase project URL
   - Service Role Key: [from Supabase dashboard]

3. **Neo4j Knowledge Graph**
   - URI: bolt://localhost:7687 or bolt://neo4j:7687
   - Username: neo4j
   - Password: [configured password]

4. **OpenAI API** (for embeddings)
   - API Key: [from OpenAI dashboard]
   - Model: text-embedding-3-small

### Environment Variables

Add to your n8n environment:

```bash
# Database connections
POSTGRES_HOST=postgres
POSTGRES_DB=postgres
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password

# Supabase
SUPABASE_URL=https://supabase.vividwalls.blog
SUPABASE_SERVICE_ROLE_KEY=your_service_key

# Neo4j
NEO4J_URI=bolt://neo4j:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=your_neo4j_password

# OpenAI
OPENAI_API_KEY=your_openai_key
```

## Usage Examples

### 1. Retrieve Agent Knowledge

```json
POST /webhook/knowledge-management
{
  "agent_id": "Marketing Director",
  "query_type": "knowledge_retrieval",
  "search_query": "social media campaign strategies",
  "operation": "retrieve"
}
```

### 2. Store New Knowledge

```json
POST /webhook/knowledge-management
{
  "agent_id": "Sales Director",
  "operation": "store",
  "content_text": "New customer acquisition technique involving personalized outreach...",
  "content_type": "knowledge",
  "domain": "sales",
  "confidence": 0.85
}
```

### 3. Query Agent Hierarchy

```json
POST /webhook/knowledge-management
{
  "agent_id": "Business Manager",
  "query_type": "hierarchy",
  "operation": "retrieve"
}
```

## Workflow Features

### Multi-Database Integration
- **PostgreSQL**: Stores relational data, agent configurations, and interaction history
- **Vector Store**: Enables semantic search with OpenAI embeddings
- **Neo4j**: Manages knowledge relationships and agent hierarchy

### Dynamic Query Building
- Uses n8n expressions (`{{ }}`) for parameterized queries
- Supports conditional logic based on operation type
- Handles missing data gracefully

### Error Handling
- Each database node includes fallback mechanisms
- Workflow continues even if one database fails
- Errors are logged but don't break the flow

### Performance Optimization
- Parallel database queries for faster response
- Indexed columns for quick lookups
- Caching support for frequently accessed data

## Testing the Workflow

### Manual Testing
1. Import the workflow JSON into n8n
2. Configure all database credentials
3. Use the Manual Trigger node with test data
4. Verify results in each database

### Webhook Testing
```bash
# Test knowledge retrieval
curl -X POST https://n8n.vividwalls.blog/webhook/knowledge-management \
  -H "Content-Type: application/json" \
  -d '{
    "agent_id": "Marketing Director",
    "query_type": "knowledge_retrieval",
    "search_query": "email marketing",
    "operation": "retrieve"
  }'

# Test knowledge storage
curl -X POST https://n8n.vividwalls.blog/webhook/knowledge-management \
  -H "Content-Type: application/json" \
  -d '{
    "agent_id": "Sales Director",
    "operation": "store",
    "content_text": "Customer feedback indicates preference for video demos",
    "domain": "sales",
    "confidence": 0.9
  }'
```

## Monitoring & Maintenance

### Key Metrics to Track
- Query response times
- Embedding generation speed
- Database connection health
- Knowledge retrieval accuracy
- Agent interaction frequency

### Regular Maintenance Tasks
1. **Weekly**: Review and optimize slow queries
2. **Monthly**: Update embeddings for modified content
3. **Quarterly**: Analyze knowledge graph patterns
4. **Annually**: Archive old interactions

## Troubleshooting

### Common Issues and Solutions

1. **Vector similarity search returns no results**
   - Check if embeddings are properly generated
   - Verify metadata filters are correct
   - Ensure content_embeddings table has data

2. **Neo4j connection fails**
   - Verify Neo4j container is running: `docker ps | grep neo4j`
   - Check bolt protocol port (7687) is accessible
   - Confirm authentication credentials

3. **PostgreSQL query timeout**
   - Add appropriate indexes
   - Optimize complex queries
   - Consider query result caching

4. **Embedding generation fails**
   - Verify OpenAI API key is valid
   - Check API rate limits
   - Ensure text length is within limits

## Extension Points

### Adding New Knowledge Sources
1. Create new webhook endpoint
2. Add embedding generation node
3. Store in appropriate database
4. Update knowledge graph relationships

### Custom Agent Behaviors
1. Extend agent_personalities table
2. Add behavior rules in Neo4j
3. Implement custom query patterns
4. Update workflow logic

### Integration with Other Systems
1. Add HTTP Request nodes for external APIs
2. Configure OAuth for third-party services
3. Implement data transformation nodes
4. Set up scheduled synchronization

## Best Practices

1. **Always use parameterized queries** to prevent SQL injection
2. **Implement rate limiting** for embedding generation
3. **Cache frequently accessed data** in Redis or memory
4. **Monitor database performance** with appropriate tools
5. **Backup knowledge data** regularly
6. **Version control** workflow changes
7. **Document custom modifications** thoroughly
8. **Test thoroughly** before production deployment

## Conclusion

This knowledge management workflow provides a robust foundation for the VividWalls MAS agent system. It integrates three powerful database technologies to enable intelligent, context-aware agent behaviors with semantic search capabilities and relationship-based knowledge retrieval.