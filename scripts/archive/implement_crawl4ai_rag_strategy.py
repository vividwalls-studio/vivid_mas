#!/usr/bin/env python3
"""
Implement Crawl4AI RAG MCP Server Strategy for VividWalls MAS.
Following the specific implementation instructions from instructions.md.
"""

import os
import json
import requests
import time
from typing import List, Dict, Any, Optional
from pathlib import Path
import sys
import subprocess

# Add current directory for imports
sys.path.append(str(Path(__file__).parent))
from domain_authority_sources import DOMAIN_AUTHORITY_SOURCES, RAG_CONFIGURATIONS

class Crawl4AIRAGImplementation:
    """Implement the complete Crawl4AI RAG strategy for agent knowledge."""
    
    def __init__(self):
        self.crawl4ai_url = "https://crawl4ai.vividwalls.blog"
        self.supabase_url = "http://157.230.13.13:8000"
        self.n8n_url = "https://n8n.vividwalls.blog"
        
    def configure_rag_strategies(self):
        """Configure RAG strategies as specified in instructions."""
        print("\n" + "="*70)
        print("CONFIGURING RAG STRATEGIES")
        print("="*70)
        
        # Recommended configuration for ontology building
        ontology_config = """
# Add to .env file for ontology construction
USE_CONTEXTUAL_EMBEDDINGS=true
USE_HYBRID_SEARCH=true
USE_AGENTIC_RAG=false
USE_RERANKING=true
USE_KNOWLEDGE_GRAPH=true
MODEL_CHOICE=gpt-3.5-turbo
"""
        
        print("Ontology Building Configuration:")
        print(ontology_config)
        
        # Save configuration
        with open("rag_config_ontology.env", "w") as f:
            f.write(ontology_config)
        print("✓ Saved to: rag_config_ontology.env")
        
        return ontology_config
    
    def setup_mcp_integration(self):
        """Setup MCP integration for agents."""
        print("\n" + "="*70)
        print("SETTING UP MCP INTEGRATION")
        print("="*70)
        
        # Agent MCP configuration
        mcp_config = {
            "mcpServers": {
                "crawl4ai-rag": {
                    "transport": "sse",
                    "url": "http://localhost:8051/sse"
                }
            }
        }
        
        print("Add this to your agent configuration:")
        print(json.dumps(mcp_config, indent=2))
        
        # Tools available for agents
        agent_tools = {
            "search_tools": [
                "smart_crawl_url - Recursively crawl websites with domain concepts",
                "crawl_single_page - Extract specific pages",
                "perform_rag_query - Retrieve domain concepts with filters",
                "search_code_examples - Retrieve ontology patterns"
            ],
            "knowledge_graph_tools": [
                "parse_github_repository - Extract concepts from repos",
                "query_knowledge_graph - Traverse taxonomies",
                "check_ai_script_hallucinations - Validate content"
            ]
        }
        
        print("\nAvailable tools for agents:")
        for category, tools in agent_tools.items():
            print(f"\n{category}:")
            for tool in tools:
                print(f"  - {tool}")
        
        return mcp_config
    
    def crawl_domain_sources(self, agent_id: str, domain_config: Dict[str, Any]):
        """Crawl domain-specific sources for an agent."""
        print(f"\n{'='*60}")
        print(f"Crawling sources for {agent_id}")
        print(f"{'='*60}")
        
        collection = f"{agent_id}_vectors"
        crawled_data = []
        
        # 1. Crawl ontology sources
        ontology_sources = domain_config.get("ontology_sources", [])
        for source in ontology_sources:
            print(f"\nCrawling ontology source: {source}")
            
            # Use smart_crawl_url for comprehensive crawling
            crawl_request = {
                "url": source,
                "collection": collection,
                "metadata": {
                    "agent_id": agent_id,
                    "content_type": "ontology",
                    "domain": agent_id.replace("_director", "").replace("_agent", ""),
                    "source": source
                }
            }
            
            try:
                # Simulate MCP tool call
                print(f"  invoke smart_crawl_url url=\"{source}\" collection=\"{collection}\"")
                
                # In production, this would use the actual MCP tool
                response = requests.post(
                    f"{self.crawl4ai_url}/crawl",
                    json={"url": source, "wait_for": "networkidle"},
                    headers={"Content-Type": "application/json"},
                    timeout=60
                )
                
                if response.status_code == 200:
                    print("  ✓ Successfully crawled")
                    crawled_data.append(crawl_request)
                    
            except Exception as e:
                print(f"  ✗ Error: {e}")
        
        # 2. Crawl primary sources
        primary_sources = domain_config.get("sources", [])[:3]
        for source in primary_sources:
            print(f"\nCrawling primary source: {source}")
            
            crawl_request = {
                "url": source,
                "collection": collection,
                "metadata": {
                    "agent_id": agent_id,
                    "content_type": "domain_knowledge",
                    "domain": agent_id.replace("_director", "").replace("_agent", ""),
                    "source": source
                }
            }
            
            try:
                print(f"  invoke crawl_single_page url=\"{source}\"")
                crawled_data.append(crawl_request)
                
            except Exception as e:
                print(f"  ✗ Error: {e}")
        
        return crawled_data
    
    def build_knowledge_graph(self, agent_id: str, sources: List[str]):
        """Build knowledge graph from sources."""
        print(f"\n{'='*60}")
        print(f"Building knowledge graph for {agent_id}")
        print(f"{'='*60}")
        
        # Parse repositories if GitHub URLs
        github_repos = [s for s in sources if "github.com" in s]
        
        for repo_url in github_repos:
            print(f"\nParsing repository: {repo_url}")
            print(f"  invoke parse_github_repository url=\"{repo_url}\"")
            
            # Example: Extract concepts from repo
            # In production, this would use the actual MCP tool
            
        # Query graph for validation
        cypher_queries = {
            "marketing": """
                MATCH (c:Concept)-[:SUBCLASS_OF]->(d:Domain {name:"Marketing"}) 
                RETURN c.name as concept, count(*) as connections
                ORDER BY connections DESC LIMIT 10
            """,
            "sales": """
                MATCH (c:Concept {domain:"Sales"})-[r]->(related:Concept)
                RETURN c.name, type(r) as relationship, related.name
                LIMIT 20
            """,
            "product": """
                MATCH path = (p:Concept {name:"Product"})-[*1..3]->(related)
                RETURN path LIMIT 10
            """
        }
        
        domain = agent_id.replace("_director", "")
        if domain in cypher_queries:
            print(f"\nQuerying knowledge graph:")
            print(f"  {cypher_queries[domain]}")
        
        return True
    
    def setup_automated_maintenance(self):
        """Setup automated ontology maintenance."""
        print("\n" + "="*70)
        print("AUTOMATED MAINTENANCE SETUP")
        print("="*70)
        
        # n8n workflow for scheduled crawls
        n8n_workflow = {
            "name": "Ontology Maintenance Workflow",
            "nodes": [
                {
                    "name": "Schedule Trigger",
                    "type": "n8n-nodes-base.scheduleTrigger",
                    "parameters": {
                        "rule": {
                            "interval": [{"field": "weeks", "triggerAtWeek": [1]}]
                        }
                    }
                },
                {
                    "name": "Crawl Sources",
                    "type": "n8n-nodes-base.httpRequest",
                    "parameters": {
                        "url": "http://localhost:8051/tools/smart_crawl_url",
                        "method": "POST"
                    }
                },
                {
                    "name": "Validate Ontology",
                    "type": "n8n-nodes-base.executeCommand",
                    "parameters": {
                        "command": "python knowledge_graphs/ai_hallucination_detector.py agent_ontologies.py"
                    }
                }
            ]
        }
        
        print("n8n Workflow Configuration:")
        print(json.dumps(n8n_workflow, indent=2))
        
        # Save workflow
        with open("ontology_maintenance_workflow.json", "w") as f:
            json.dump(n8n_workflow, f, indent=2)
        print("\n✓ Saved workflow to: ontology_maintenance_workflow.json")
        
        return n8n_workflow
    
    def create_agent_specific_configuration(self, agent_id: str):
        """Create agent-specific configuration."""
        collection = f"{agent_id}_vectors"
        ontology_collection = f"{agent_id}_ontology"
        
        config = {
            "agent_id": agent_id,
            "collections": {
                "primary": collection,
                "ontology": ontology_collection,
                "code_examples": f"{agent_id}_code_vectors"
            },
            "rag_tools": {
                "domain_search": f"perform_rag_query collection=\"{collection}\"",
                "ontology_lookup": f"perform_rag_query collection=\"{ontology_collection}\"",
                "code_search": f"search_code_examples collection=\"{agent_id}_code_vectors\""
            },
            "knowledge_graph": {
                "subgraph": f"{agent_id}_subgraph",
                "query_example": f"MATCH (n:Concept {{domain:'{agent_id}'}}) RETURN n"
            }
        }
        
        return config

def implement_complete_strategy():
    """Implement the complete Crawl4AI RAG strategy."""
    print("""
╔══════════════════════════════════════════════════════════════════════╗
║          CRAWL4AI RAG MCP SERVER IMPLEMENTATION STRATEGY             ║
║                    For VividWalls MAS Agents                         ║
╚══════════════════════════════════════════════════════════════════════╝
""")
    
    impl = Crawl4AIRAGImplementation()
    
    # 1. Configure RAG strategies
    rag_config = impl.configure_rag_strategies()
    
    # 2. Setup MCP integration
    mcp_config = impl.setup_mcp_integration()
    
    # 3. Create SQL schema
    sql_schema = """
-- Required tables from crawled_pages.sql
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS crawled_pages (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    url TEXT UNIQUE NOT NULL,
    chunk_number INTEGER NOT NULL,
    content TEXT NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    source_id TEXT,
    embedding vector(1536),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_url_chunk UNIQUE (url, chunk_number)
);

CREATE TABLE IF NOT EXISTS code_examples (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    url TEXT NOT NULL,
    chunk_number INTEGER NOT NULL,
    content TEXT NOT NULL,
    summary TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    source_id TEXT,
    embedding vector(1536),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_code_url_chunk UNIQUE (url, chunk_number)
);

CREATE TABLE IF NOT EXISTS sources (
    source_id TEXT PRIMARY KEY,
    summary TEXT,
    total_word_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_crawled_pages_embedding ON crawled_pages 
    USING ivfflat (embedding vector_cosine_ops);
CREATE INDEX IF NOT EXISTS idx_code_examples_embedding ON code_examples 
    USING ivfflat (embedding vector_cosine_ops);
"""
    
    print("\n" + "="*70)
    print("DATABASE SETUP")
    print("="*70)
    print("Execute in Supabase SQL Editor:")
    print(sql_schema[:500] + "...")
    
    with open("crawl4ai_schema.sql", "w") as f:
        f.write(sql_schema)
    print("\n✓ Full schema saved to: crawl4ai_schema.sql")
    
    # 4. Process priority agents
    priority_agents = ["marketing_director", "sales_director", "product_director"]
    
    print("\n" + "="*70)
    print("AGENT IMPLEMENTATION")
    print("="*70)
    
    for agent_id in priority_agents:
        if agent_id in DOMAIN_AUTHORITY_SOURCES:
            print(f"\n{agent_id.upper()}:")
            
            # Get configuration
            domain_config = DOMAIN_AUTHORITY_SOURCES[agent_id]
            agent_config = impl.create_agent_specific_configuration(agent_id)
            
            # Save agent configuration
            config_file = f"{agent_id}_crawl4ai_config.json"
            with open(config_file, "w") as f:
                json.dump(agent_config, f, indent=2)
            print(f"  ✓ Configuration saved to: {config_file}")
            
            # Show example commands
            print(f"\n  Example MCP commands:")
            for tool_name, command in agent_config["rag_tools"].items():
                print(f"    {tool_name}: {command}")
    
    # 5. Setup automation
    automation = impl.setup_automated_maintenance()
    
    # 6. Create implementation checklist
    checklist = """
IMPLEMENTATION CHECKLIST:

□ 1. Database Setup
   □ Run crawl4ai_schema.sql in Supabase
   □ Create vector indexes
   □ Verify table creation

□ 2. Neo4j Setup
   □ Install Local AI Package with Neo4j
   □ Configure Neo4j credentials
   □ Create agent-specific subgraphs

□ 3. MCP Server Configuration
   □ Update .env with RAG settings
   □ Configure agent MCP connections
   □ Test SSE/HTTP transport

□ 4. Agent Integration
   □ Import agent configurations
   □ Configure vector collections
   □ Test RAG queries

□ 5. Automation
   □ Import n8n workflow
   □ Schedule crawl jobs
   □ Setup hallucination checks

□ 6. Monitoring
   □ Check Supabase logs
   □ Monitor Neo4j queries
   □ Track embedding costs
"""
    
    with open("implementation_checklist.md", "w") as f:
        f.write(checklist)
    
    print("\n" + "="*70)
    print("IMPLEMENTATION COMPLETE")
    print("="*70)
    print("\nFiles created:")
    print("- rag_config_ontology.env")
    print("- crawl4ai_schema.sql")
    print("- ontology_maintenance_workflow.json")
    print("- *_crawl4ai_config.json (per agent)")
    print("- implementation_checklist.md")
    
    print("\nNext steps:")
    print("1. Execute SQL schema in Supabase")
    print("2. Configure MCP server with RAG settings")
    print("3. Test agent connections")
    print("4. Begin crawling domain sources")

if __name__ == "__main__":
    implement_complete_strategy()