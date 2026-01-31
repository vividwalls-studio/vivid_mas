#!/usr/bin/env python3
"""
Populate Supabase vector database with agent domain knowledge.
This script creates embeddings for agent-specific knowledge and stores them in Supabase.
"""

import os
import json
import time
from typing import List, Dict, Any
from supabase import create_client, Client
import openai
from datetime import datetime

# Configuration
SUPABASE_URL = "http://157.230.13.13:8000"
SUPABASE_SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw"
OPENAI_API_KEY = "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"

# Set OpenAI API key
openai.api_key = OPENAI_API_KEY

# Agent domain knowledge structure
AGENT_DOMAINS = {
    # Director-Level Collections
    "marketing_director_vectors": {
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
    
    "sales_director_vectors": {
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
            }
        ]
    },
    
    "analytics_director_vectors": {
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
            }
        ]
    },
    
    # Specialized Agent Collections - Marketing Domain
    "content_strategy_vectors": {
        "agent_id": "content_strategy_agent",
        "domain": "marketing",
        "knowledge": [
            {
                "content": "Content Strategy Agent develops and executes content plans including blog posts, social media content, email newsletters, and product descriptions.",
                "content_type": "role_definition"
            },
            {
                "content": "Content pillars: Art education, interior design tips, artist spotlights, customer success stories, behind-the-scenes content, seasonal collections.",
                "content_type": "content_strategy"
            }
        ]
    },
    
    "email_marketing_vectors": {
        "agent_id": "email_marketing_agent",
        "domain": "marketing",
        "knowledge": [
            {
                "content": "Email Marketing Agent manages email campaigns, list segmentation, automation workflows, A/B testing, and performance optimization.",
                "content_type": "role_definition"
            },
            {
                "content": "Email segments: New subscribers, active customers, VIP collectors, trade professionals, abandoned cart, win-back campaigns.",
                "content_type": "segmentation_strategy"
            }
        ]
    },
    
    # Cross-Functional Collections
    "vividwalls_business_knowledge": {
        "agent_id": "system",
        "domain": "business",
        "knowledge": [
            {
                "content": "VividWalls is a premium wall art e-commerce platform specializing in vibrant, museum-quality prints for discerning customers seeking to transform their spaces.",
                "content_type": "company_overview"
            },
            {
                "content": "Mission: To bring gallery-quality art into every space, making premium wall art accessible while supporting artists and sustainable practices.",
                "content_type": "mission_statement"
            },
            {
                "content": "Core values: Artistic excellence, customer delight, sustainability, innovation, community support, ethical sourcing.",
                "content_type": "company_values"
            }
        ]
    }
}

def create_embedding(text: str) -> List[float]:
    """Create an embedding for a single text using OpenAI's API."""
    max_retries = 3
    retry_delay = 1.0
    
    for retry in range(max_retries):
        try:
            response = openai.embeddings.create(
                model="text-embedding-3-small",
                input=text
            )
            return response.data[0].embedding
        except Exception as e:
            if retry < max_retries - 1:
                print(f"Error creating embedding (attempt {retry + 1}/{max_retries}): {e}")
                time.sleep(retry_delay)
                retry_delay *= 2
            else:
                print(f"Failed to create embedding after {max_retries} attempts: {e}")
                return [0.0] * 1536  # Return zero vector as fallback

def populate_vector_collection(supabase: Client, collection_name: str, collection_data: Dict[str, Any]):
    """Populate a vector collection with agent domain knowledge."""
    print(f"\nPopulating collection: {collection_name}")
    
    agent_id = collection_data["agent_id"]
    domain = collection_data["domain"]
    knowledge_items = collection_data["knowledge"]
    
    for item in knowledge_items:
        try:
            # Create embedding
            embedding = create_embedding(item["content"])
            
            # Prepare data for insertion
            data = {
                "content": item["content"],
                "metadata": {
                    "agent_id": agent_id,
                    "domain": domain,
                    "content_type": item["content_type"],
                    "collection": collection_name,
                    "created_at": datetime.utcnow().isoformat()
                },
                "embedding": embedding
            }
            
            # Insert into Supabase
            # Note: You'll need to create the appropriate table structure
            # For now, we'll use a generic 'embeddings' table
            result = supabase.table("embeddings").insert(data).execute()
            
            print(f"  ✓ Added: {item['content_type']} - {item['content'][:50]}...")
            
        except Exception as e:
            print(f"  ✗ Error adding item: {e}")
        
        # Rate limiting
        time.sleep(0.5)

def main():
    """Main function to populate all agent vector collections."""
    print("Starting agent domain knowledge population...")
    print(f"Connecting to Supabase at: {SUPABASE_URL}")
    
    try:
        # Create Supabase client
        supabase = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)
        
        # Test connection
        result = supabase.table("agents").select("id").limit(1).execute()
        print("✓ Successfully connected to Supabase")
        
    except Exception as e:
        print(f"✗ Failed to connect to Supabase: {e}")
        print("\nNote: This script requires direct database access.")
        print("Alternative approaches:")
        print("1. Use n8n workflows with Supabase nodes")
        print("2. Run this script on the droplet with local database access")
        print("3. Use the Supabase Dashboard SQL editor")
        return
    
    # Populate each collection
    total_collections = len(AGENT_DOMAINS)
    
    for i, (collection_name, collection_data) in enumerate(AGENT_DOMAINS.items(), 1):
        print(f"\n[{i}/{total_collections}] Processing {collection_name}")
        populate_vector_collection(supabase, collection_name, collection_data)
    
    print("\n✓ Population complete!")
    print("\nNext steps:")
    print("1. Verify data in Supabase Dashboard")
    print("2. Test vector search functionality")
    print("3. Configure n8n workflows to use these collections")

if __name__ == "__main__":
    main()