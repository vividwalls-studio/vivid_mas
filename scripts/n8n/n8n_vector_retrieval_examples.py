#!/usr/bin/env python3
"""
N8N Vector Retrieval Examples for VividWalls MAS Agents.
Shows how to configure n8n Supabase Vector Store node for each agent.
"""

import json
from typing import Dict, List

def generate_n8n_examples():
    """Generate n8n workflow examples for different agent types."""
    
    examples = {
        "Marketing Director Agent": {
            "description": "Marketing Director accessing marketing domain knowledge",
            "vector_store_config": {
                "operation": "retrieve",
                "collectionName": "marketing_director_vectors",
                "topK": 5,
                "filters": {
                    "metadata": {
                        "content_type": {"$in": ["strategy", "best_practice", "framework"]}
                    }
                }
            },
            "related_collections": [
                "content_strategy_vectors",
                "campaign_management_vectors",
                "creative_execution_vectors",
                "email_marketing_vectors",
                "keyword_research_vectors"
            ]
        },
        
        "Sales Director Agent": {
            "description": "Sales Director accessing sales strategies and segment knowledge",
            "vector_store_config": {
                "operation": "retrieve",
                "collectionName": "sales_director_vectors",
                "topK": 5,
                "filters": {
                    "metadata": {
                        "domain": "sales"
                    }
                }
            },
            "related_collections": [
                "hospitality_sales_vectors",
                "corporate_sales_vectors",
                "healthcare_sales_vectors",
                "interior_designer_sales_vectors"
            ]
        },
        
        "Instagram Agent": {
            "description": "Instagram specialist accessing platform-specific knowledge",
            "vector_store_config": {
                "operation": "retrieve",
                "collectionName": "instagram_agent_vectors",
                "topK": 3,
                "filters": {
                    "metadata": {
                        "content_type": {"$in": ["instagram_strategy", "content_tips", "algorithm_updates"]}
                    }
                }
            },
            "parent_collection": "social_media_director_vectors"
        },
        
        "Hospitality Sales Agent": {
            "description": "Specialized agent for hotel and hospitality sales",
            "vector_store_config": {
                "operation": "retrieve",
                "collectionName": "hospitality_sales_vectors",
                "topK": 5,
                "filters": {
                    "metadata": {
                        "content_type": {"$in": ["hotel_procurement", "bulk_orders", "hospitality_design"]}
                    }
                }
            },
            "parent_collection": "sales_director_vectors",
            "cross_reference": ["corporate_sales_vectors", "art_trend_intelligence_vectors"]
        },
        
        "Analytics Director Agent": {
            "description": "Analytics Director accessing BI and data analysis knowledge",
            "vector_store_config": {
                "operation": "retrieve",
                "collectionName": "analytics_director_vectors",
                "topK": 5
            },
            "related_collections": [
                "performance_analytics_vectors",
                "revenue_analytics_vectors",
                "campaign_analytics_vectors"
            ]
        },
        
        "Cross-Functional Query": {
            "description": "Query across multiple collections for comprehensive insights",
            "vector_store_configs": [
                {
                    "operation": "retrieve",
                    "collectionName": "vividwalls_business_knowledge",
                    "topK": 3
                },
                {
                    "operation": "retrieve",
                    "collectionName": "vividwalls_market_intelligence",
                    "topK": 2
                }
            ]
        }
    }
    
    return examples

def generate_n8n_workflow_template(agent_name: str, config: Dict) -> Dict:
    """Generate a complete n8n workflow template for an agent."""
    
    workflow = {
        "name": f"{agent_name} Vector Retrieval Workflow",
        "nodes": [
            {
                "parameters": {
                    "authentication": "webhook",
                    "path": f"{agent_name.lower().replace(' ', '-')}-query",
                    "responseMode": "lastNode",
                    "options": {}
                },
                "id": "webhook_1",
                "name": "Webhook",
                "type": "n8n-nodes-base.webhook",
                "position": [250, 300]
            },
            {
                "parameters": {
                    "model": "text-embedding-3-small",
                    "options": {}
                },
                "id": "embedding_1",
                "name": "Create Query Embedding",
                "type": "@n8n/n8n-nodes-langchain.embeddingOpenAi",
                "position": [450, 300]
            },
            {
                "parameters": config["vector_store_config"],
                "id": "vector_1",
                "name": f"Search {agent_name} Knowledge",
                "type": "@n8n/n8n-nodes-langchain.vectorStoreSupabase",
                "position": [650, 300],
                "credentials": {
                    "supabaseApi": {
                        "id": "supabase_creds",
                        "name": "Supabase account"
                    }
                }
            }
        ],
        "connections": {
            "Webhook": {
                "main": [[{"node": "Create Query Embedding", "type": "main", "index": 0}]]
            },
            "Create Query Embedding": {
                "main": [[{"node": f"Search {agent_name} Knowledge", "type": "main", "index": 0}]]
            }
        }
    }
    
    # Add additional vector searches for related collections
    if "related_collections" in config:
        y_position = 500
        for i, collection in enumerate(config["related_collections"][:3]):  # Limit to 3
            node_id = f"vector_{i+2}"
            node_name = f"Search {collection}"
            
            workflow["nodes"].append({
                "parameters": {
                    "operation": "retrieve",
                    "collectionName": collection,
                    "topK": 3
                },
                "id": node_id,
                "name": node_name,
                "type": "@n8n/n8n-nodes-langchain.vectorStoreSupabase",
                "position": [850, y_position]
            })
            
            # Connect embedding to this vector search
            if "Create Query Embedding" not in workflow["connections"]:
                workflow["connections"]["Create Query Embedding"] = {"main": [[]]}
            workflow["connections"]["Create Query Embedding"]["main"][0].append({
                "node": node_name,
                "type": "main",
                "index": 0
            })
            
            y_position += 150
    
    # Add merge node if multiple vector searches
    if len([n for n in workflow["nodes"] if n["type"].endswith("vectorStoreSupabase")]) > 1:
        workflow["nodes"].append({
            "parameters": {
                "mode": "combine",
                "combinationMode": "multiplex"
            },
            "id": "merge_1",
            "name": "Merge Results",
            "type": "n8n-nodes-base.merge",
            "position": [1050, 300]
        })
        
        # Connect all vector searches to merge
        for node in workflow["nodes"]:
            if node["type"].endswith("vectorStoreSupabase"):
                if node["name"] not in workflow["connections"]:
                    workflow["connections"][node["name"]] = {"main": [[]]}
                workflow["connections"][node["name"]]["main"][0].append({
                    "node": "Merge Results",
                    "type": "main",
                    "index": 0
                })
    
    # Add AI processing node
    workflow["nodes"].append({
        "parameters": {
            "model": "gpt-3.5-turbo",
            "options": {
                "systemMessage": f"You are the {agent_name} for VividWalls. Use the retrieved knowledge to provide accurate, domain-specific responses."
            }
        },
        "id": "ai_1",
        "name": "Process with AI",
        "type": "@n8n/n8n-nodes-langchain.lmChatOpenAi",
        "position": [1250, 300]
    })
    
    return workflow

def generate_supabase_function_examples():
    """Generate PostgreSQL functions for vector search."""
    
    functions = """
-- Function to search within a specific agent's domain
CREATE OR REPLACE FUNCTION search_agent_domain(
    p_agent_id VARCHAR(255),
    p_query_embedding vector(1536),
    p_limit INT DEFAULT 5
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
        ae.id,
        ae.content,
        ae.metadata,
        1 - (ae.embedding <=> p_query_embedding) as similarity
    FROM agent_embeddings ae
    WHERE ae.agent_id = p_agent_id
        OR ae.collection = p_agent_id || '_vectors'
    ORDER BY ae.embedding <=> p_query_embedding
    LIMIT p_limit;
END;
$$;

-- Function to search across multiple collections
CREATE OR REPLACE FUNCTION search_multiple_collections(
    p_collections TEXT[],
    p_query_embedding vector(1536),
    p_limit INT DEFAULT 10
)
RETURNS TABLE (
    id UUID,
    collection VARCHAR(255),
    content TEXT,
    metadata JSONB,
    similarity FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ae.id,
        ae.collection,
        ae.content,
        ae.metadata,
        1 - (ae.embedding <=> p_query_embedding) as similarity
    FROM agent_embeddings ae
    WHERE ae.collection = ANY(p_collections)
    ORDER BY ae.embedding <=> p_query_embedding
    LIMIT p_limit;
END;
$$;

-- Function to get related knowledge for an agent
CREATE OR REPLACE FUNCTION get_agent_related_knowledge(
    p_agent_id VARCHAR(255),
    p_query_embedding vector(1536),
    p_include_parent BOOLEAN DEFAULT true,
    p_limit INT DEFAULT 10
)
RETURNS TABLE (
    id UUID,
    collection VARCHAR(255),
    content TEXT,
    metadata JSONB,
    similarity FLOAT,
    relevance_type VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    -- Direct agent knowledge
    SELECT 
        ae.id,
        ae.collection,
        ae.content,
        ae.metadata,
        1 - (ae.embedding <=> p_query_embedding) as similarity,
        'direct'::VARCHAR(50) as relevance_type
    FROM agent_embeddings ae
    WHERE ae.agent_id = p_agent_id
    
    UNION ALL
    
    -- Parent domain knowledge (if applicable)
    SELECT 
        ae.id,
        ae.collection,
        ae.content,
        ae.metadata,
        1 - (ae.embedding <=> p_query_embedding) as similarity,
        'parent'::VARCHAR(50) as relevance_type
    FROM agent_embeddings ae
    WHERE p_include_parent 
        AND ae.collection IN (
            SELECT DISTINCT collection_name 
            FROM vector_collections 
            WHERE domain = (
                SELECT domain 
                FROM vector_collections 
                WHERE agent_id = p_agent_id 
                LIMIT 1
            )
            AND collection_name LIKE '%_director_vectors'
        )
    
    ORDER BY similarity DESC
    LIMIT p_limit;
END;
$$;
"""
    
    return functions

def main():
    """Generate all examples and save to files."""
    print("""
╔══════════════════════════════════════════════════════════════════════╗
║            N8N VECTOR RETRIEVAL CONFIGURATION EXAMPLES               ║
║                  For VividWalls MAS Agents                          ║
╚══════════════════════════════════════════════════════════════════════╝
""")
    
    # Generate examples
    examples = generate_n8n_examples()
    
    print("\n" + "="*70)
    print("AGENT VECTOR RETRIEVAL EXAMPLES")
    print("="*70)
    
    for agent_name, config in examples.items():
        print(f"\n{agent_name}:")
        print(f"  Description: {config['description']}")
        
        if "vector_store_config" in config:
            print(f"  Primary Collection: {config['vector_store_config']['collectionName']}")
        
        if "related_collections" in config:
            print(f"  Related Collections: {', '.join(config['related_collections'][:3])}")
        
        if "parent_collection" in config:
            print(f"  Parent Collection: {config['parent_collection']}")
    
    # Generate workflow templates
    print("\n" + "="*70)
    print("GENERATING N8N WORKFLOW TEMPLATES")
    print("="*70)
    
    workflows_dir = "n8n_workflow_templates"
    import os
    os.makedirs(workflows_dir, exist_ok=True)
    
    for agent_name, config in examples.items():
        if "vector_store_config" in config:  # Skip cross-functional for now
            workflow = generate_n8n_workflow_template(agent_name, config)
            filename = f"{workflows_dir}/{agent_name.lower().replace(' ', '_')}_workflow.json"
            
            with open(filename, 'w') as f:
                json.dump(workflow, f, indent=2)
            
            print(f"✓ Created: {filename}")
    
    # Generate SQL functions
    sql_functions = generate_supabase_function_examples()
    sql_filename = "vector_search_functions.sql"
    
    with open(sql_filename, 'w') as f:
        f.write(sql_functions)
    
    print(f"\n✓ SQL functions saved to: {sql_filename}")
    
    # Generate quick reference
    quick_ref = """
# VividWalls MAS Vector Collections Quick Reference

## Director-Level Agents
- marketing_director → marketing_director_vectors
- sales_director → sales_director_vectors
- analytics_director → analytics_director_vectors
- operations_director → operations_director_vectors
- finance_director → finance_director_vectors
- technology_director → technology_director_vectors
- customer_experience_director → customer_experience_director_vectors
- product_director → product_director_vectors
- social_media_director → social_media_director_vectors

## Specialized Marketing Agents
- content_strategy → content_strategy_vectors
- campaign_management → campaign_management_vectors
- email_marketing → email_marketing_vectors
- keyword_research → keyword_research_vectors

## Specialized Sales Agents
- hospitality_sales → hospitality_sales_vectors
- corporate_sales → corporate_sales_vectors
- healthcare_sales → healthcare_sales_vectors
- interior_designer_sales → interior_designer_sales_vectors

## Social Media Agents
- instagram_agent → instagram_agent_vectors
- facebook_agent → facebook_agent_vectors
- pinterest_agent → pinterest_agent_vectors

## Cross-Functional Collections
- vividwalls_business_knowledge (company-wide knowledge)
- vividwalls_product_catalog (product information)
- vividwalls_customer_insights (customer data)
- vividwalls_market_intelligence (market research)

## N8N Configuration Example
```javascript
{
  "operation": "retrieve",
  "collectionName": "marketing_director_vectors",
  "topK": 5,
  "filters": {
    "metadata": {
      "content_type": {"$in": ["strategy", "best_practice"]}
    }
  }
}
```
"""
    
    with open("vector_collections_quick_reference.md", 'w') as f:
        f.write(quick_ref)
    
    print("\n" + "="*70)
    print("CONFIGURATION COMPLETE")
    print("="*70)
    print("\nFiles created:")
    print("- n8n_workflow_templates/ (directory with workflow JSONs)")
    print("- vector_search_functions.sql")
    print("- vector_collections_quick_reference.md")
    print("\nUse these in n8n by:")
    print("1. Import workflow templates into n8n")
    print("2. Configure Supabase credentials")
    print("3. Set collection names based on agent type")
    print("4. Add metadata filters as needed")

if __name__ == "__main__":
    main()