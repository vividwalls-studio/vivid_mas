#!/usr/bin/env python3
"""
Check current database state for Virtual Agent Architecture
Uses MCP servers to query Neo4j and Supabase
"""

import asyncio
import json
import subprocess
from typing import Dict, List

# Configuration
NEO4J_MCP_PATH = "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/core/neo4j-mcp-server"
SUPABASE_MCP_PATH = "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/core/supabase-mcp-server"

async def check_neo4j_state():
    """Check Neo4j for existing agent data"""
    print("\n=== Neo4j Database State ===")
    
    queries = [
        {
            "name": "Agent Count",
            "query": "MATCH (a:Agent) RETURN count(a) as count, collect(DISTINCT a.type) as types"
        },
        {
            "name": "Agent Hierarchy",
            "query": """
                MATCH (a:Agent)
                OPTIONAL MATCH (a)-[:REPORTS_TO]->(b:Agent)
                RETURN a.name as agent, a.type as type, b.name as reports_to
                ORDER BY a.type, a.name
                LIMIT 10
            """
        },
        {
            "name": "Concepts and Specializations",
            "query": """
                MATCH (n)
                WHERE n:Concept OR n:Specialization
                RETURN labels(n)[0] as type, count(n) as count
            """
        },
        {
            "name": "Virtual Agent Check",
            "query": "MATCH (va:VirtualAgent) RETURN count(va) as count"
        },
        {
            "name": "Sample Agent Knowledge",
            "query": """
                MATCH (a:Agent)-[:KNOWS_ABOUT]->(c:Concept)
                WITH a, collect(c.name)[..5] as concepts
                RETURN a.name as agent, concepts
                LIMIT 5
            """
        }
    ]
    
    for query_info in queries:
        print(f"\n{query_info['name']}:")
        print(f"Query: {query_info['query']}")
        # In a real implementation, execute via MCP or direct Neo4j connection
        print("(Would execute query here)")

async def check_supabase_state():
    """Check Supabase for virtual agent tables"""
    print("\n\n=== Supabase Database State ===")
    
    queries = [
        {
            "name": "Check Virtual Agent Tables",
            "query": """
                SELECT table_name 
                FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name IN ('virtual_agents', 'execution_agents', 'activation_rules', 'agent_personas')
            """
        },
        {
            "name": "Check PGVector Extension",
            "query": "SELECT extname FROM pg_extension WHERE extname = 'vector'"
        }
    ]
    
    for query_info in queries:
        print(f"\n{query_info['name']}:")
        print(f"Query: {query_info['query']}")
        # In a real implementation, execute via MCP or direct Supabase connection
        print("(Would execute query here)")

def create_initialization_scripts():
    """Create scripts to initialize the Virtual Agent Architecture"""
    print("\n\n=== Creating Initialization Scripts ===")
    
    # Supabase initialization
    supabase_init = """
-- Virtual Agent Architecture Schema for Supabase

-- Enable PGVector if not already enabled
CREATE EXTENSION IF NOT EXISTS vector;

-- Execution Agents (Physical Directors)
CREATE TABLE IF NOT EXISTS execution_agents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL UNIQUE,
  workflow_id VARCHAR(255),
  agent_type VARCHAR(50) NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Virtual Agent Definitions
CREATE TABLE IF NOT EXISTS virtual_agents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  parent_executor_id UUID NOT NULL,
  agent_type VARCHAR(50) NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (parent_executor_id) REFERENCES execution_agents(id)
);

-- Activation Rules
CREATE TABLE IF NOT EXISTS activation_rules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  virtual_agent_id UUID NOT NULL,
  rule_type VARCHAR(50),
  rule_value JSONB NOT NULL,
  priority INTEGER DEFAULT 0,
  FOREIGN KEY (virtual_agent_id) REFERENCES virtual_agents(id)
);

-- Agent Personas
CREATE TABLE IF NOT EXISTS agent_personas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  virtual_agent_id UUID NOT NULL,
  tone VARCHAR(100),
  expertise TEXT[],
  communication_style TEXT,
  response_templates JSONB,
  FOREIGN KEY (virtual_agent_id) REFERENCES virtual_agents(id)
);

-- Performance Metrics
CREATE TABLE IF NOT EXISTS agent_metrics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  virtual_agent_id UUID,
  execution_agent_id UUID,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  response_time_ms INTEGER,
  confidence_score FLOAT,
  success BOOLEAN,
  escalated BOOLEAN DEFAULT false,
  session_id VARCHAR(255),
  FOREIGN KEY (virtual_agent_id) REFERENCES virtual_agents(id),
  FOREIGN KEY (execution_agent_id) REFERENCES execution_agents(id)
);

-- Knowledge Base Tables
CREATE TABLE IF NOT EXISTS knowledge_bases (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  agent_type VARCHAR(50),
  is_active BOOLEAN DEFAULT true
);

CREATE TABLE IF NOT EXISTS knowledge_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  knowledge_base_id VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  metadata JSONB,
  embedding vector(1536),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (knowledge_base_id) REFERENCES knowledge_bases(id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_virtual_agents_parent ON virtual_agents(parent_executor_id);
CREATE INDEX IF NOT EXISTS idx_activation_rules_agent ON activation_rules(virtual_agent_id);
CREATE INDEX IF NOT EXISTS idx_agent_metrics_timestamp ON agent_metrics(timestamp);
CREATE INDEX IF NOT EXISTS knowledge_entries_embedding_idx ON knowledge_entries 
USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);
"""
    
    # Neo4j initialization
    neo4j_init = """
// Virtual Agent Architecture Extensions for Neo4j

// Create Virtual Agent nodes for Sales Director
CREATE (corp:VirtualAgent {
  id: 'corp_sales_va',
  name: 'Corporate Sales Specialist',
  type: 'sales',
  parent_executor: 'sales_director',
  created_at: datetime()
})

CREATE (health:VirtualAgent {
  id: 'health_sales_va',
  name: 'Healthcare Sales Specialist',
  type: 'sales',
  parent_executor: 'sales_director',
  created_at: datetime()
})

CREATE (retail:VirtualAgent {
  id: 'retail_sales_va',
  name: 'Retail Sales Specialist',
  type: 'sales',
  parent_executor: 'sales_director',
  created_at: datetime()
})

// Link to execution agent
MATCH (va:VirtualAgent {parent_executor: 'sales_director'})
MATCH (ea:Agent {name: 'Sales Director'})
CREATE (va)-[:EXECUTED_BY]->(ea)

// Create knowledge inheritance
MATCH (va:VirtualAgent)-[:EXECUTED_BY]->(ea:Agent)-[:KNOWS_ABOUT]->(c:Concept)
CREATE (va)-[:INHERITS_KNOWLEDGE]->(c)

// Create virtual agent communication patterns
MATCH (v1:VirtualAgent), (v2:VirtualAgent)
WHERE v1.parent_executor = v2.parent_executor AND v1.id < v2.id
CREATE (v1)-[:CAN_COMMUNICATE_WITH]->(v2)
"""
    
    with open("init_supabase_virtual_agents.sql", "w") as f:
        f.write(supabase_init)
    print("Created: init_supabase_virtual_agents.sql")
    
    with open("init_neo4j_virtual_agents.cypher", "w") as f:
        f.write(neo4j_init)
    print("Created: init_neo4j_virtual_agents.cypher")

async def main():
    print("VividMAS Database State Check")
    print("=" * 50)
    
    # Check current state
    await check_neo4j_state()
    await check_supabase_state()
    
    # Create initialization scripts
    create_initialization_scripts()
    
    print("\n\n=== Summary ===")
    print("1. Run existing seeding scripts to populate base Neo4j data:")
    print("   - python services/mcp-servers/vivid_mas_ontology_seeder.py")
    print("   - python services/mcp-servers/agent_ontology_seeder.py")
    print("\n2. Execute Supabase initialization:")
    print("   - Run init_supabase_virtual_agents.sql via Supabase MCP")
    print("\n3. Execute Neo4j extensions:")
    print("   - Run init_neo4j_virtual_agents.cypher via Neo4j MCP")
    print("\n4. Begin testing with Sales Director virtual agents")

if __name__ == "__main__":
    asyncio.run(main())