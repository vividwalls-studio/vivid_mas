#!/usr/bin/env python3
"""
Generate SQL statements to populate Supabase vector database with agent domain knowledge.
This script creates SQL INSERT statements that can be executed in Supabase SQL editor.
"""

import json
from datetime import datetime

# Agent domain knowledge structure (same as before)
AGENT_DOMAINS = {
    # Director-Level Collections
    "marketing_director": {
        "agent_id": "marketing_director",
        "domain": "marketing",
        "knowledge": [
            {
                "content": "Marketing Director oversees all marketing operations including digital marketing, content strategy, campaign management, and brand development for VividWalls premium art business.",
                "content_type": "role_definition"
            },
            {
                "content": "Key responsibilities: Strategic marketing planning, budget allocation, team leadership, ROI optimization, cross-functional collaboration with sales and product teams.",
                "content_type": "responsibilities"
            },
            {
                "content": "Marketing channels: Email marketing, SMS campaigns, social media (Instagram, Facebook, Pinterest), content marketing, SEO/SEM, influencer partnerships, art gallery collaborations.",
                "content_type": "channel_strategy"
            },
            {
                "content": "Target audiences: Interior designers, art collectors, hospitality sector (hotels, restaurants), corporate offices, healthcare facilities, residential homeowners, gift buyers.",
                "content_type": "target_markets"
            },
            {
                "content": "VividWalls USP: Premium wall art with vibrant colors, museum-quality prints, sustainable materials, custom sizing options, white-glove delivery service.",
                "content_type": "unique_selling_proposition"
            }
        ]
    },
    
    "sales_director": {
        "agent_id": "sales_director",
        "domain": "sales",
        "knowledge": [
            {
                "content": "Sales Director manages all sales operations including B2B and B2C channels, sales team performance, pipeline management, and revenue growth strategies.",
                "content_type": "role_definition"
            },
            {
                "content": "Sales segments: Hospitality (hotels, restaurants), Corporate (offices, workspaces), Healthcare (hospitals, clinics), Retail (stores, boutiques), Real Estate (staging, model homes).",
                "content_type": "market_segments"
            },
            {
                "content": "Sales process: Lead qualification, needs assessment, custom art consultation, pricing strategy, contract negotiation, post-sale support, relationship management.",
                "content_type": "sales_methodology"
            },
            {
                "content": "Pricing strategies: Volume discounts for bulk orders, trade pricing for interior designers, seasonal promotions, limited edition premium pricing, custom size surcharges.",
                "content_type": "pricing_strategy"
            }
        ]
    },
    
    "analytics_director": {
        "agent_id": "analytics_director",
        "domain": "analytics",
        "knowledge": [
            {
                "content": "Analytics Director provides data-driven insights for business decisions, performance monitoring, predictive analytics, and ROI measurement across all departments.",
                "content_type": "role_definition"
            },
            {
                "content": "Key metrics: Customer acquisition cost (CAC), lifetime value (LTV), conversion rates, average order value (AOV), return on ad spend (ROAS), inventory turnover.",
                "content_type": "kpi_framework"
            },
            {
                "content": "Analytics tools: Google Analytics, Shopify Analytics, Facebook Pixel, email marketing analytics, custom dashboards, A/B testing frameworks.",
                "content_type": "tools_stack"
            }
        ]
    },
    
    "finance_director": {
        "agent_id": "finance_director",
        "domain": "finance",
        "knowledge": [
            {
                "content": "Finance Director manages financial planning, budgeting, cash flow management, financial reporting, and ROI analysis for VividWalls operations.",
                "content_type": "role_definition"
            },
            {
                "content": "Financial KPIs: Gross margin (target 65%), operating margin (target 20%), cash conversion cycle, working capital ratio, monthly burn rate.",
                "content_type": "financial_targets"
            }
        ]
    },
    
    "operations_director": {
        "agent_id": "operations_director",
        "domain": "operations",
        "knowledge": [
            {
                "content": "Operations Director oversees supply chain, inventory management, fulfillment, quality control, and vendor relationships for seamless order execution.",
                "content_type": "role_definition"
            },
            {
                "content": "Fulfillment process: Order processing within 24 hours, print production 2-3 days, quality inspection, secure packaging, white-glove shipping options.",
                "content_type": "fulfillment_sla"
            }
        ]
    },
    
    "customer_experience_director": {
        "agent_id": "customer_experience_director",
        "domain": "customer_experience",
        "knowledge": [
            {
                "content": "Customer Experience Director ensures exceptional customer journey from discovery to post-purchase, managing support team and satisfaction metrics.",
                "content_type": "role_definition"
            },
            {
                "content": "Support channels: Email (24hr response), live chat (business hours), phone support for VIP customers, self-service knowledge base, video consultations.",
                "content_type": "support_framework"
            }
        ]
    },
    
    "product_director": {
        "agent_id": "product_director",
        "domain": "product",
        "knowledge": [
            {
                "content": "Product Director manages product catalog, new product development, artist partnerships, quality standards, and product-market fit analysis.",
                "content_type": "role_definition"
            },
            {
                "content": "Product categories: Abstract art, landscape photography, modern minimalist, botanical prints, architectural photography, limited edition collections.",
                "content_type": "product_taxonomy"
            }
        ]
    },
    
    "technology_director": {
        "agent_id": "technology_director",
        "domain": "technology",
        "knowledge": [
            {
                "content": "Technology Director oversees e-commerce platform, integrations, cybersecurity, performance optimization, and technical innovation initiatives.",
                "content_type": "role_definition"
            },
            {
                "content": "Tech stack: Shopify Plus, Supabase, n8n automation, Neo4j knowledge graphs, AI/ML tools, CDN for image delivery, payment processing systems.",
                "content_type": "technology_stack"
            }
        ]
    },
    
    "social_media_director": {
        "agent_id": "social_media_director",
        "domain": "social_media",
        "knowledge": [
            {
                "content": "Social Media Director manages brand presence across social platforms, community engagement, influencer partnerships, and social commerce strategies.",
                "content_type": "role_definition"
            },
            {
                "content": "Platform strategies: Instagram (visual storytelling), Pinterest (discovery and inspiration), Facebook (community building), LinkedIn (B2B networking).",
                "content_type": "platform_strategy"
            }
        ]
    }
}

def generate_sql_statements():
    """Generate SQL INSERT statements for vector database population."""
    
    sql_statements = []
    
    # Create the embeddings table if not exists
    create_table_sql = """
-- Create embeddings table with pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS embeddings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    collection VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    embedding vector(1536),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_embeddings_collection ON embeddings(collection);
CREATE INDEX IF NOT EXISTS idx_embeddings_metadata ON embeddings USING GIN(metadata);
CREATE INDEX IF NOT EXISTS idx_embeddings_embedding ON embeddings USING ivfflat (embedding vector_cosine_ops);

-- Create function to generate embeddings (placeholder - actual implementation depends on your setup)
-- You'll need to implement this based on your OpenAI integration
"""
    
    sql_statements.append(create_table_sql)
    
    # Generate INSERT statements for each domain
    for collection_name, collection_data in AGENT_DOMAINS.items():
        agent_id = collection_data["agent_id"]
        domain = collection_data["domain"]
        
        for item in collection_data["knowledge"]:
            # Escape single quotes in content
            content = item["content"].replace("'", "''")
            
            # Create metadata JSON
            metadata = {
                "agent_id": agent_id,
                "domain": domain,
                "content_type": item["content_type"],
                "collection": f"{collection_name}_vectors"
            }
            
            # Generate INSERT statement
            # Note: The embedding vector would need to be generated separately
            insert_sql = f"""
-- Insert {collection_name} - {item['content_type']}
INSERT INTO embeddings (collection, content, metadata)
VALUES (
    '{collection_name}_vectors',
    '{content}',
    '{json.dumps(metadata)}'::jsonb
);"""
            
            sql_statements.append(insert_sql)
    
    # Add helper queries
    helper_sql = """

-- Helper queries to verify data
-- Count records by collection
SELECT collection, COUNT(*) as count
FROM embeddings
GROUP BY collection
ORDER BY collection;

-- View sample records
SELECT collection, 
       metadata->>'agent_id' as agent_id,
       metadata->>'content_type' as content_type,
       LEFT(content, 100) as content_preview
FROM embeddings
LIMIT 10;

-- Function to search by similarity (after embeddings are populated)
CREATE OR REPLACE FUNCTION search_embeddings(
    query_embedding vector(1536),
    collection_filter VARCHAR(255) DEFAULT NULL,
    limit_count INTEGER DEFAULT 10
)
RETURNS TABLE (
    id UUID,
    content TEXT,
    metadata JSONB,
    similarity FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id,
        e.content,
        e.metadata,
        1 - (e.embedding <=> query_embedding) as similarity
    FROM embeddings e
    WHERE (collection_filter IS NULL OR e.collection = collection_filter)
    ORDER BY e.embedding <=> query_embedding
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;
"""
    
    sql_statements.append(helper_sql)
    
    return sql_statements

def main():
    """Generate SQL file for vector database population."""
    
    output_file = "/Volumes/SeagatePortableDrive/Projects/vivid_mas/scripts/populate_agent_vectors.sql"
    
    print("Generating SQL statements for agent domain knowledge...")
    
    sql_statements = generate_sql_statements()
    
    # Write to file
    with open(output_file, 'w') as f:
        f.write("-- Agent Domain Knowledge Vector Population\n")
        f.write(f"-- Generated on: {datetime.now().isoformat()}\n")
        f.write("-- This script populates the vector database with agent domain knowledge\n")
        f.write("-- Note: Embeddings need to be generated separately using OpenAI API\n\n")
        
        for statement in sql_statements:
            f.write(statement)
            f.write("\n")
    
    print(f"✓ SQL file generated: {output_file}")
    print("\nNext steps:")
    print("1. Copy this SQL to Supabase SQL editor")
    print("2. Run the CREATE TABLE statements first")
    print("3. Generate embeddings using OpenAI API")
    print("4. Update INSERT statements with actual embedding vectors")
    print("5. Execute the INSERT statements")
    print("\nAlternatively, use n8n workflows to:")
    print("- Read the knowledge content")
    print("- Generate embeddings via OpenAI node")
    print("- Insert into Supabase with embeddings")
    
    # Also create a JSON file for easier processing
    json_file = "/Volumes/SeagatePortableDrive/Projects/vivid_mas/scripts/agent_domain_knowledge.json"
    with open(json_file, 'w') as f:
        json.dump(AGENT_DOMAINS, f, indent=2)
    
    print(f"\n✓ JSON file also created: {json_file}")
    print("  This can be used with n8n workflows for automated processing")

if __name__ == "__main__":
    main()