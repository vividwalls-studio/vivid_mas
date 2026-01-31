# VividWalls MAS Data Deduplication Strategy

## Executive Summary

The VividWalls Multi-Agent System currently suffers from significant data duplication across multiple storage systems. This document outlines a comprehensive strategy to eliminate redundancies, establish clear data ownership, and create unified access patterns.

## Current State Analysis

### 1. Agent Configuration Duplication

**Problem**: Agent data is scattered across multiple tables
- `agents` table: Core agent info
- `agent_personalities`: Big Five traits
- `agent_voice_config`: Communication style
- `agent_llm_config`: Model settings
- `agent_beliefs`, `agent_desires`, `agent_intentions`: BDI architecture
- `agent_goals`, `agent_objectives`: Goal hierarchy
- `agent_rules`, `agent_instructions`: Behavioral constraints

**Neo4j Duplication**:
- Agent nodes with similar properties
- SpecializedPersona nodes duplicating agent functionality
- PersonaKnowledge nodes overlapping with agent_domain_knowledge

### 2. Knowledge Storage Duplication

**Problem**: Knowledge is stored in multiple locations
- Supabase: `content_embeddings`, `product_embeddings`, `customer_embeddings`, `enhanced_product_embeddings`
- Neo4j: Knowledge nodes, PersonaKnowledge nodes
- Vector stores: Qdrant (separate from Supabase pgvector)

### 3. Product Data Duplication

**Problem**: Product information exists in both systems
- Supabase: Complete product schema (products, variants, images, inventory)
- Neo4j: Product nodes with partial information

### 4. Workflow Definition Duplication

**Problem**: Workflow data in multiple places
- Supabase: `agent_workflows` table
- n8n: Internal workflow storage
- File system: JSON workflow files

## Deduplication Strategy

### Phase 1: Consolidate Agent Configuration

#### 1.1 Create Unified Agent Schema

```sql
-- New consolidated agent table
CREATE TABLE agent_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    -- Core Identity
    name VARCHAR(255) NOT NULL UNIQUE,
    role TEXT,
    backstory TEXT,
    agent_type VARCHAR(50) DEFAULT 'specialist',
    hierarchy_level INTEGER DEFAULT 3,
    parent_agent_id UUID REFERENCES agent_profiles(id),
    
    -- Personality & Voice (consolidated)
    personality JSONB DEFAULT '{}', -- Big Five traits
    voice_style VARCHAR(255),
    voice_tone VARCHAR(255),
    
    -- BDI Architecture (consolidated)
    beliefs TEXT[],
    desires TEXT[],
    intentions TEXT[],
    
    -- Goals & Objectives (consolidated)
    goals JSONB DEFAULT '[]', -- Array of {goal, priority, objectives[]}
    
    -- Rules & Instructions (consolidated)
    rules TEXT[],
    instructions TEXT[],
    
    -- LLM Configuration (consolidated)
    llm_config JSONB DEFAULT '{}', -- {model, temperature, max_tokens, etc.}
    
    -- Memory (consolidated)
    memory JSONB DEFAULT '{}', -- {short_term, long_term, episodic}
    
    -- MCP Tools
    mcp_tools JSONB DEFAULT '[]', -- Array of tool configurations
    
    -- Skills & Tasks
    skills JSONB DEFAULT '[]',
    active_tasks JSONB DEFAULT '[]',
    
    -- Metadata
    department VARCHAR(100),
    team VARCHAR(100),
    is_director BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    metadata JSONB DEFAULT '{}',
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

### Phase 2: Unify Knowledge Storage

#### 2.1 Establish Single Source of Truth

**Decision**: Use Supabase as the primary knowledge store with pgvector
- Consolidate all embedding tables into one
- Use Neo4j only for relationship graphs, not content storage
- Sync embeddings to Qdrant for specialized vector operations

#### 2.2 Create Unified Embeddings Table

```sql
CREATE TABLE unified_embeddings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    -- Content Reference
    content_type VARCHAR(50) NOT NULL,
    content_id UUID NOT NULL,
    content_subtype VARCHAR(50), -- For specialized types
    
    -- Embedding Data
    chunk_index INTEGER DEFAULT 0,
    chunk_text TEXT NOT NULL,
    embedding vector(1536),
    
    -- Metadata
    token_count INTEGER,
    model_version VARCHAR(50),
    metadata JSONB DEFAULT '{}',
    
    -- Search & Filtering
    tags TEXT[],
    category VARCHAR(100),
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_unified_content (content_type, content_id),
    INDEX idx_unified_tags USING GIN(tags),
    INDEX idx_unified_metadata USING GIN(metadata)
);
```

### Phase 3: Product Data Ownership

**Decision**: Supabase owns all product data
- Neo4j only stores product relationships and graph analytics
- Remove duplicate product properties from Neo4j
- Create sync mechanism for essential graph data

### Phase 4: Workflow Management

**Decision**: n8n is the source of truth for workflows
- Remove `agent_workflows` table from Supabase
- Create read-only sync to database for querying
- Use n8n API for all workflow operations

## Data Ownership Matrix

| Data Type | Primary Owner | Secondary Storage | Sync Method |
|-----------|---------------|-------------------|-------------|
| Agent Configuration | Supabase (agent_profiles) | Neo4j (relationships only) | Real-time sync |
| Agent Hierarchy | Supabase | Neo4j (graph traversal) | Real-time sync |
| Knowledge/Embeddings | Supabase (unified_embeddings) | Qdrant (vector search) | Batch sync |
| Product Data | Supabase | Neo4j (relationships) | Daily sync |
| Workflows | n8n | Supabase (read-only) | Webhook sync |
| Customer Data | Supabase | None | N/A |
| Analytics Data | Supabase | None | N/A |

## Implementation Plan

### Step 1: Migration Scripts (Week 1)
1. Create migration to consolidate agent tables
2. Create migration to unify embeddings
3. Create Neo4j cleanup scripts

### Step 2: Sync Mechanisms (Week 2)
1. Implement Supabase → Neo4j agent sync
2. Implement Supabase → Qdrant embedding sync
3. Implement n8n → Supabase workflow sync

### Step 3: Access Layer (Week 3)
1. Create unified API views
2. Update MCP servers to use new structure
3. Create compatibility layer for existing code

### Step 4: Cleanup (Week 4)
1. Remove deprecated tables
2. Archive old data
3. Update documentation

## Benefits

1. **Reduced Storage**: ~60% reduction in duplicate data
2. **Improved Performance**: Single source queries, no join complexity
3. **Easier Maintenance**: Clear ownership, single update point
4. **Better Consistency**: No sync issues between duplicates
5. **Simplified Development**: Clear APIs and access patterns

## Risk Mitigation

1. **Backward Compatibility**: Maintain views with old schema during transition
2. **Data Integrity**: Full backup before migration
3. **Testing**: Comprehensive test suite for all migrations
4. **Rollback Plan**: Keep archived data for 90 days
5. **Monitoring**: Track query performance and data consistency

## Success Metrics

- Zero data duplication across systems
- 50% reduction in database size
- 30% improvement in query performance
- 100% data consistency across all systems
- Zero data loss during migration