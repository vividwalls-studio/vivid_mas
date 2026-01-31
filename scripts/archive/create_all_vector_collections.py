#!/usr/bin/env python3
"""
Create all vector collections for VividWalls MAS agents.
Based on the comprehensive list from agent-domain-knowledge.md
"""

import os
import json
import requests
import base64
from typing import List, Dict, Any
from datetime import datetime

# Configuration
SUPABASE_URL = "http://157.230.13.13:8000"
SUPABASE_SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw"

# Headers for Supabase
AUTH_STRING = base64.b64encode(b"supabase:this_password_is_insecure_and_should_be_updated").decode()
SUPABASE_HEADERS = {
    "Authorization": f"Basic {AUTH_STRING}",
    "apikey": SUPABASE_SERVICE_KEY,
    "Content-Type": "application/json"
}

# Complete list of vector collections from agent-domain-knowledge.md
VECTOR_COLLECTIONS = {
    "Director-Level Collections": [
        "marketing_director_vectors",
        "analytics_director_vectors",
        "finance_director_vectors",
        "operations_director_vectors",
        "customer_experience_director_vectors",
        "product_director_vectors",
        "technology_director_vectors",
        "sales_director_vectors",
        "social_media_director_vectors"
    ],
    
    "Marketing Domain": [
        "content_strategy_vectors",
        "campaign_management_vectors",
        "creative_execution_vectors",
        "email_marketing_vectors",
        "sms_marketing_vectors",
        "keyword_research_vectors",
        "copy_writing_vectors"
    ],
    
    "Sales Domain": [
        "hospitality_sales_vectors",
        "corporate_sales_vectors",
        "healthcare_sales_vectors",
        "retail_sales_vectors",
        "real_estate_sales_vectors",
        "homeowner_sales_vectors",
        "renter_sales_vectors",
        "interior_designer_sales_vectors",
        "art_collector_sales_vectors",
        "gift_buyer_sales_vectors",
        "millennial_genz_sales_vectors",
        "global_customer_sales_vectors"
    ],
    
    "Social Media Domain": [
        "instagram_agent_vectors",
        "facebook_agent_vectors",
        "pinterest_agent_vectors"
    ],
    
    "Analytics Domain": [
        "performance_analytics_vectors",
        "data_insights_vectors",
        "campaign_analytics_vectors",
        "revenue_analytics_vectors"
    ],
    
    "Operations Domain": [
        "inventory_management_vectors",
        "fulfillment_analytics_vectors",
        "supply_chain_vectors",
        "shopify_integration_vectors"
    ],
    
    "Customer Experience Domain": [
        "customer_support_vectors",
        "satisfaction_monitoring_vectors",
        "customer_sentiment_vectors",
        "customer_lifecycle_vectors"
    ],
    
    "Product Domain": [
        "product_strategy_vectors",
        "market_research_vectors",
        "product_content_vectors",
        "art_trend_intelligence_vectors"
    ],
    
    "Finance Domain": [
        "budget_management_vectors",
        "roi_analysis_vectors",
        "financial_calculation_vectors",
        "budget_intelligence_vectors"
    ],
    
    "Technology Domain": [
        "system_monitoring_vectors",
        "integration_management_vectors",
        "automation_development_vectors",
        "performance_optimization_vectors"
    ],
    
    "Cross-Functional Collections": [
        "vividwalls_business_knowledge",
        "vividwalls_product_catalog",
        "vividwalls_customer_insights",
        "vividwalls_market_intelligence"
    ]
}

def generate_sql_schema():
    """Generate SQL schema for all collections."""
    print("\n" + "="*70)
    print("GENERATING SQL SCHEMA")
    print("="*70)
    
    sql = """-- Enable vector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Create main agent embeddings table if not exists
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

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_agent_embeddings_agent ON agent_embeddings(agent_id);
CREATE INDEX IF NOT EXISTS idx_agent_embeddings_collection ON agent_embeddings(collection);
CREATE INDEX IF NOT EXISTS idx_agent_embeddings_embedding ON agent_embeddings 
    USING ivfflat (embedding vector_cosine_ops);
CREATE INDEX IF NOT EXISTS idx_agent_embeddings_metadata ON agent_embeddings USING gin(metadata);

-- Create collection metadata table
CREATE TABLE IF NOT EXISTS vector_collections (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    collection_name VARCHAR(255) UNIQUE NOT NULL,
    domain VARCHAR(100) NOT NULL,
    agent_id VARCHAR(255),
    description TEXT,
    item_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert all collections
"""
    
    # Add INSERT statements for each collection
    for domain, collections in VECTOR_COLLECTIONS.items():
        sql += f"\n-- {domain}\n"
        for collection in collections:
            agent_id = collection.replace("_vectors", "").replace("_agent", "")
            sql += f"INSERT INTO vector_collections (collection_name, domain, agent_id, description) "
            sql += f"VALUES ('{collection}', '{domain}', '{agent_id}', '{domain} - {collection}') "
            sql += f"ON CONFLICT (collection_name) DO NOTHING;\n"
    
    sql += """
-- Create function to get collection stats
CREATE OR REPLACE FUNCTION get_collection_stats()
RETURNS TABLE (
    collection_name VARCHAR(255),
    domain VARCHAR(100),
    item_count BIGINT,
    last_updated TIMESTAMP WITH TIME ZONE
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vc.collection_name,
        vc.domain,
        COUNT(ae.id) as item_count,
        MAX(ae.created_at) as last_updated
    FROM vector_collections vc
    LEFT JOIN agent_embeddings ae ON ae.collection = vc.collection_name
    GROUP BY vc.collection_name, vc.domain
    ORDER BY vc.domain, vc.collection_name;
END;
$$;

-- Create metadata standards view
CREATE OR REPLACE VIEW collection_metadata_standards AS
SELECT 
    'agent_id' as field_name,
    'VARCHAR(255)' as data_type,
    'The agent that created/owns the data' as description,
    true as required
UNION ALL
SELECT 'content_type', 'VARCHAR(100)', 'Type of content (policy, procedure, knowledge, etc.)', true
UNION ALL
SELECT 'domain', 'VARCHAR(100)', 'The business domain', true
UNION ALL
SELECT 'timestamp', 'TIMESTAMP', 'When the embedding was created', true
UNION ALL
SELECT 'source', 'VARCHAR(500)', 'Where the data came from', true
UNION ALL
SELECT 'url', 'VARCHAR(500)', 'Source URL if applicable', false
UNION ALL
SELECT 'title', 'VARCHAR(500)', 'Title or heading of content', false
UNION ALL
SELECT 'summary', 'TEXT', 'Brief summary of content', false;
"""
    
    return sql

def verify_collections():
    """Verify which collections already exist."""
    print("\n" + "="*70)
    print("VERIFYING EXISTING COLLECTIONS")
    print("="*70)
    
    try:
        # Query to check existing collections
        response = requests.get(
            f"{SUPABASE_URL}/rest/v1/agent_embeddings?select=collection&limit=1000",
            headers=SUPABASE_HEADERS
        )
        
        if response.status_code == 200:
            data = response.json()
            existing_collections = set(item['collection'] for item in data if 'collection' in item)
            print(f"Found {len(existing_collections)} unique collections in use")
            
            # Check against our complete list
            all_collections = []
            for collections in VECTOR_COLLECTIONS.values():
                all_collections.extend(collections)
            
            missing = set(all_collections) - existing_collections
            if missing:
                print(f"\nMissing collections ({len(missing)}):")
                for coll in sorted(missing):
                    print(f"  - {coll}")
            else:
                print("\nAll collections have data!")
                
            return existing_collections
        else:
            print(f"Failed to query collections: {response.status_code}")
            return set()
            
    except Exception as e:
        print(f"Error verifying collections: {e}")
        return set()

def create_test_embeddings():
    """Create test embeddings for verification."""
    import openai
    
    openai.api_key = "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"
    
    print("\n" + "="*70)
    print("CREATING TEST EMBEDDINGS")
    print("="*70)
    
    test_data = {
        "marketing_director_vectors": {
            "content": "Test: Marketing Director oversees all marketing operations including digital marketing, content strategy, and brand development.",
            "agent_id": "marketing_director"
        },
        "sales_director_vectors": {
            "content": "Test: Sales Director manages B2B and B2C sales channels, pipeline management, and revenue growth.",
            "agent_id": "sales_director"
        },
        "instagram_agent_vectors": {
            "content": "Test: Instagram Agent specializes in Instagram marketing, content creation, and engagement strategies.",
            "agent_id": "instagram_agent"
        }
    }
    
    for collection, data in test_data.items():
        try:
            # Generate embedding
            response = openai.embeddings.create(
                model="text-embedding-3-small",
                input=data["content"]
            )
            embedding = response.data[0].embedding
            
            # Prepare record
            record = {
                "agent_id": data["agent_id"],
                "collection": collection,
                "content": data["content"],
                "metadata": {
                    "content_type": "test",
                    "domain": "test",
                    "timestamp": datetime.utcnow().isoformat(),
                    "source": "test_script"
                },
                "embedding": embedding
            }
            
            # Insert test record
            response = requests.post(
                f"{SUPABASE_URL}/rest/v1/agent_embeddings",
                json=record,
                headers=SUPABASE_HEADERS
            )
            
            if response.status_code in [200, 201]:
                print(f"✓ Test embedding created for {collection}")
            else:
                print(f"✗ Failed to create test for {collection}: {response.status_code}")
                
        except Exception as e:
            print(f"✗ Error creating test for {collection}: {e}")

def generate_n8n_collection_config():
    """Generate n8n configuration for all collections."""
    print("\n" + "="*70)
    print("N8N COLLECTION CONFIGURATION")
    print("="*70)
    
    config = {
        "collections": {},
        "agent_mappings": {}
    }
    
    # Create collection configurations
    for domain, collections in VECTOR_COLLECTIONS.items():
        for collection in collections:
            agent_id = collection.replace("_vectors", "").replace("_agent", "")
            config["collections"][collection] = {
                "domain": domain,
                "agent_id": agent_id,
                "description": f"{domain} knowledge for {agent_id}"
            }
            
            # Map agents to their collections
            if agent_id not in config["agent_mappings"]:
                config["agent_mappings"][agent_id] = []
            config["agent_mappings"][agent_id].append(collection)
    
    # Save configuration
    config_path = "vector_collections_config.json"
    with open(config_path, 'w') as f:
        json.dump(config, f, indent=2)
    
    print(f"Configuration saved to: {config_path}")
    print(f"Total collections: {sum(len(c) for c in VECTOR_COLLECTIONS.values())}")
    print(f"Total agents: {len(config['agent_mappings'])}")
    
    return config

def print_collection_summary():
    """Print a summary of all collections."""
    print("\n" + "="*70)
    print("VECTOR COLLECTION SUMMARY")
    print("="*70)
    
    total = 0
    for domain, collections in VECTOR_COLLECTIONS.items():
        count = len(collections)
        total += count
        print(f"\n{domain}: {count} collections")
        for coll in collections[:3]:  # Show first 3
            print(f"  - {coll}")
        if count > 3:
            print(f"  ... and {count - 3} more")
    
    print(f"\nTOTAL COLLECTIONS: {total}")

def main():
    """Main execution function."""
    print("""
╔══════════════════════════════════════════════════════════════════════╗
║              VIVIDWALLS MAS VECTOR COLLECTION SETUP                  ║
║                    Complete Collection Creation                      ║
╚══════════════════════════════════════════════════════════════════════╝
""")
    
    # 1. Print collection summary
    print_collection_summary()
    
    # 2. Generate SQL schema
    sql_schema = generate_sql_schema()
    schema_path = "create_all_collections_schema.sql"
    with open(schema_path, 'w') as f:
        f.write(sql_schema)
    print(f"\nSQL schema saved to: {schema_path}")
    
    # 3. Verify existing collections
    existing = verify_collections()
    
    # 4. Create test embeddings
    create_test_embeddings()
    
    # 5. Generate n8n configuration
    n8n_config = generate_n8n_collection_config()
    
    print("\n" + "="*70)
    print("SETUP COMPLETE")
    print("="*70)
    print("\nNext steps:")
    print("1. Execute SQL schema in Supabase Dashboard")
    print("2. Run population scripts for each agent domain")
    print("3. Import n8n configuration for agent workflows")
    print("4. Test vector search for each collection")
    print("\nKey files created:")
    print(f"- {schema_path}")
    print("- vector_collections_config.json")

if __name__ == "__main__":
    main()