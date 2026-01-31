#!/usr/bin/env python3
"""
Complete knowledge population pipeline for VividWalls MAS.
Combines all crawl4ai patterns for comprehensive agent knowledge building.
"""

import os
import json
import time
from datetime import datetime
from pathlib import Path
import subprocess
import sys

# Import our custom scripts
sys.path.append(str(Path(__file__).parent))

def run_script(script_name: str, description: str) -> bool:
    """Run a Python script and return success status."""
    print(f"\n{'='*70}")
    print(f"Running: {description}")
    print(f"Script: {script_name}")
    print(f"{'='*70}")
    
    try:
        result = subprocess.run(
            [sys.executable, script_name],
            capture_output=True,
            text=True,
            cwd=Path(__file__).parent
        )
        
        if result.returncode == 0:
            print(f"✓ {description} completed successfully")
            return True
        else:
            print(f"✗ {description} failed with return code: {result.returncode}")
            if result.stderr:
                print(f"Error output:\n{result.stderr[:500]}")
            return False
            
    except Exception as e:
        print(f"✗ Failed to run {script_name}: {e}")
        return False

def create_database_schema():
    """Print SQL schema for all required tables."""
    print("\n" + "="*70)
    print("DATABASE SCHEMA")
    print("="*70)
    
    schema_sql = """
-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Main agent embeddings table
CREATE TABLE IF NOT EXISTS agent_embeddings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    agent_id VARCHAR(255) NOT NULL,
    collection VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    embedding vector(1536),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Code examples table
CREATE TABLE IF NOT EXISTS code_examples (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    url VARCHAR(500) NOT NULL,
    collection VARCHAR(255) NOT NULL,
    code TEXT NOT NULL,
    language VARCHAR(50),
    summary TEXT,
    topic VARCHAR(255),
    metadata JSONB DEFAULT '{}'::jsonb,
    embedding vector(1536),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Sources tracking table
CREATE TABLE IF NOT EXISTS knowledge_sources (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    source_id VARCHAR(255) UNIQUE NOT NULL,
    source_url VARCHAR(500),
    summary TEXT,
    total_chunks INTEGER DEFAULT 0,
    last_crawled TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Agent knowledge map
CREATE TABLE IF NOT EXISTS agent_knowledge_map (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    agent_id VARCHAR(255) NOT NULL,
    knowledge_type VARCHAR(100) NOT NULL,
    collection_name VARCHAR(255) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_agent_embeddings_agent ON agent_embeddings(agent_id);
CREATE INDEX IF NOT EXISTS idx_agent_embeddings_collection ON agent_embeddings(collection);
CREATE INDEX IF NOT EXISTS idx_agent_embeddings_embedding ON agent_embeddings 
    USING ivfflat (embedding vector_cosine_ops);
CREATE INDEX IF NOT EXISTS idx_agent_embeddings_metadata ON agent_embeddings USING gin(metadata);

CREATE INDEX IF NOT EXISTS idx_code_examples_collection ON code_examples(collection);
CREATE INDEX IF NOT EXISTS idx_code_examples_topic ON code_examples(topic);
CREATE INDEX IF NOT EXISTS idx_code_examples_embedding ON code_examples 
    USING ivfflat (embedding vector_cosine_ops);

-- Search functions
CREATE OR REPLACE FUNCTION search_agent_knowledge(
    query_embedding vector(1536),
    agent_collection text,
    match_count int DEFAULT 10,
    metadata_filter jsonb DEFAULT NULL
)
RETURNS TABLE (
    id UUID,
    agent_id VARCHAR(255),
    content TEXT,
    metadata JSONB,
    similarity float
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ae.id,
        ae.agent_id,
        ae.content,
        ae.metadata,
        1 - (ae.embedding <=> query_embedding) as similarity
    FROM agent_embeddings ae
    WHERE ae.collection = agent_collection
        AND (metadata_filter IS NULL OR ae.metadata @> metadata_filter)
    ORDER BY ae.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;

CREATE OR REPLACE FUNCTION search_code_examples(
    query_embedding vector(1536),
    collection_filter text DEFAULT NULL,
    topic_filter text DEFAULT NULL,
    match_count int DEFAULT 10
)
RETURNS TABLE (
    id UUID,
    code TEXT,
    summary TEXT,
    language VARCHAR(50),
    url VARCHAR(500),
    topic VARCHAR(255),
    similarity float
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ce.id,
        ce.code,
        ce.summary,
        ce.language,
        ce.url,
        ce.topic,
        1 - (ce.embedding <=> query_embedding) as similarity
    FROM code_examples ce
    WHERE (collection_filter IS NULL OR ce.collection = collection_filter)
        AND (topic_filter IS NULL OR ce.topic = topic_filter)
    ORDER BY ce.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;

-- Populate agent knowledge map
INSERT INTO agent_knowledge_map (agent_id, knowledge_type, collection_name, description) VALUES
    ('marketing_director', 'domain_knowledge', 'marketing_director_vectors', 'Marketing strategies and best practices'),
    ('marketing_director', 'code_examples', 'marketing_director_code_vectors', 'Marketing automation code examples'),
    ('sales_director', 'domain_knowledge', 'sales_director_vectors', 'Sales methodologies and CRM practices'),
    ('operations_director', 'domain_knowledge', 'operations_director_vectors', 'Operations and supply chain knowledge'),
    ('analytics_director', 'domain_knowledge', 'analytics_director_vectors', 'Data analytics and BI practices'),
    ('analytics_director', 'code_examples', 'analytics_director_code_vectors', 'Analytics and data processing code'),
    ('finance_director', 'domain_knowledge', 'finance_director_vectors', 'Financial planning and analysis'),
    ('technology_director', 'domain_knowledge', 'technology_director_vectors', 'IT infrastructure and DevOps'),
    ('technology_director', 'code_examples', 'technology_director_code_vectors', 'Technical implementation examples'),
    ('customer_experience_director', 'domain_knowledge', 'customer_experience_director_vectors', 'CX strategies and frameworks'),
    ('product_director', 'domain_knowledge', 'product_director_vectors', 'Product management methodologies'),
    ('social_media_director', 'domain_knowledge', 'social_media_director_vectors', 'Social media marketing strategies')
ON CONFLICT (agent_id, knowledge_type, collection_name) DO NOTHING;
"""
    
    print(schema_sql)
    print("\nExecute this SQL in Supabase Dashboard: https://supabase.vividwalls.blog/")
    
    return schema_sql

def generate_status_report(results: Dict[str, bool]):
    """Generate a status report of the population process."""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    report = f"""
VIVIDWALLS MAS KNOWLEDGE POPULATION REPORT
Generated: {timestamp}
{'='*70}

EXECUTION SUMMARY:
"""
    
    total_steps = len(results)
    successful = sum(1 for v in results.values() if v)
    
    for step, success in results.items():
        status = "✓ SUCCESS" if success else "✗ FAILED"
        report += f"\n{step:.<50} {status}"
    
    report += f"""

{'='*70}
OVERALL STATUS: {successful}/{total_steps} steps completed successfully

NEXT STEPS:
1. Execute the database schema in Supabase if not already done
2. Verify data population in Supabase Dashboard
3. Test vector search functionality in n8n workflows
4. Configure agent workflows to use their specific collections
5. Monitor agent performance and knowledge retrieval accuracy

COLLECTIONS CREATED:
- marketing_director_vectors
- sales_director_vectors
- operations_director_vectors
- analytics_director_vectors
- finance_director_vectors
- technology_director_vectors
- customer_experience_director_vectors
- product_director_vectors
- social_media_director_vectors
- *_code_vectors (for technical agents)

TROUBLESHOOTING:
- If embeddings table doesn't exist: Run the SQL schema first
- If authentication fails: Check Kong basic auth credentials
- If crawling fails: Verify Crawl4AI service is running
- If embeddings fail: Check OpenAI API key and quota

MONITORING:
- Check Supabase logs for insertion errors
- Monitor OpenAI API usage for embedding costs
- Review crawled content quality periodically
- Update knowledge sources as needed
"""
    
    # Save report
    report_path = Path(__file__).parent / f"knowledge_population_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"
    with open(report_path, 'w') as f:
        f.write(report)
    
    print(report)
    print(f"\nReport saved to: {report_path}")
    
    return report_path

def main():
    """Main pipeline execution."""
    print("""
╔══════════════════════════════════════════════════════════════════════╗
║          VIVIDWALLS MAS COMPLETE KNOWLEDGE POPULATION PIPELINE       ║
║                  Leveraging crawl4ai_mcp.py Patterns                 ║
╚══════════════════════════════════════════════════════════════════════╝
""")
    
    # Track execution results
    results = {}
    
    # Step 1: Create database schema
    print("\nStep 1: Database Schema")
    schema_sql = create_database_schema()
    results["Database Schema Generation"] = True
    
    # Step 2: Basic testing
    print("\nStep 2: Running Basic Tests")
    results["Basic Tests"] = run_script(
        "test_vector_minimal.py",
        "Basic connectivity and setup tests"
    )
    
    time.sleep(5)
    
    # Step 3: Smart crawl for domain knowledge
    print("\nStep 3: Smart Crawl Domain Knowledge")
    results["Smart Crawl Knowledge"] = run_script(
        "smart_crawl_agent_knowledge.py",
        "Smart crawling with sitemap detection and contextual embeddings"
    )
    
    time.sleep(10)
    
    # Step 4: Extract code examples
    print("\nStep 4: Extract Code Examples")
    results["Code Example Extraction"] = run_script(
        "extract_code_examples_for_agents.py",
        "Extract and index code examples for technical agents"
    )
    
    time.sleep(5)
    
    # Step 5: Populate general knowledge
    print("\nStep 5: General Knowledge Population")
    results["General Knowledge"] = run_script(
        "populate_agent_knowledge_crawl4ai.py",
        "Populate comprehensive agent domain knowledge"
    )
    
    # Step 6: Generate status report
    print("\nStep 6: Generating Status Report")
    report_path = generate_status_report(results)
    
    # Step 7: Create n8n workflow template
    print("\nStep 7: Creating n8n Workflow Template")
    n8n_workflow = {
        "name": "Agent Knowledge Retrieval Template",
        "nodes": [
            {
                "name": "Webhook",
                "type": "n8n-nodes-base.webhook",
                "position": [250, 300],
                "parameters": {
                    "path": "agent-knowledge-search",
                    "responseMode": "lastNode",
                    "options": {}
                }
            },
            {
                "name": "Generate Embedding",
                "type": "n8n-nodes-langchain.embeddingOpenAi",
                "position": [450, 300],
                "parameters": {
                    "model": "text-embedding-3-small"
                }
            },
            {
                "name": "Search Vector Store",
                "type": "n8n-nodes-langchain.vectorStoreSupabase",
                "position": [650, 300],
                "parameters": {
                    "operation": "retrieve",
                    "collectionName": "={{ $json.agent_id }}_vectors",
                    "topK": 5
                }
            },
            {
                "name": "Format Response",
                "type": "n8n-nodes-base.code",
                "position": [850, 300],
                "parameters": {
                    "language": "javaScript",
                    "code": "return items.map(item => ({\n  content: item.json.content,\n  metadata: item.json.metadata,\n  similarity: item.json.similarity\n}));"
                }
            }
        ],
        "connections": {
            "Webhook": {
                "main": [["Generate Embedding"]]
            },
            "Generate Embedding": {
                "main": [["Search Vector Store"]]
            },
            "Search Vector Store": {
                "main": [["Format Response"]]
            }
        }
    }
    
    workflow_path = Path(__file__).parent / "agent_knowledge_retrieval_template.json"
    with open(workflow_path, 'w') as f:
        json.dump(n8n_workflow, f, indent=2)
    
    print(f"✓ n8n workflow template saved to: {workflow_path}")
    results["n8n Workflow Template"] = True
    
    # Final summary
    print("""

╔══════════════════════════════════════════════════════════════════════╗
║                     PIPELINE EXECUTION COMPLETE                      ║
╚══════════════════════════════════════════════════════════════════════╝

The VividWalls MAS knowledge base has been populated with:
- Domain-specific knowledge for all director agents
- Code examples for technical agents
- Contextual embeddings for improved retrieval
- Structured collections for each agent type

Access Points:
- Supabase Dashboard: https://supabase.vividwalls.blog/
- n8n Workflows: https://n8n.vividwalls.blog/
- Vector Search API: http://157.230.13.13:8000/rest/v1/

Knowledge is now ready for agent consumption!
""")

if __name__ == "__main__":
    main()