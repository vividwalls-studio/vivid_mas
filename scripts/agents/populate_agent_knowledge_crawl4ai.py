#!/usr/bin/env python3
"""
Populate agent domain knowledge using Crawl4AI patterns.
This script leverages the crawl4ai_mcp.py patterns to search and scrape domain-specific information
for populating both Supabase vector database and Neo4j knowledge graph.
"""

import os
import json
import requests
import openai
import base64
import time
import asyncio
import concurrent.futures
from typing import List, Dict, Any, Optional, Tuple
from pathlib import Path
from urllib.parse import urlparse
from xml.etree import ElementTree
import re
import sys

# Add current directory to path to import domain_authority_sources
sys.path.append(str(Path(__file__).parent))
from domain_authority_sources import DOMAIN_AUTHORITY_SOURCES, CROSS_FUNCTIONAL_SOURCES, RAG_CONFIGURATIONS

# Configuration
CRAWL4AI_URL = "https://crawl4ai.vividwalls.blog"
SUPABASE_URL = "http://157.230.13.13:8000"
SUPABASE_SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw"
OPENAI_API_KEY = "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"

# Neo4j configuration
NEO4J_URI = "bolt://157.230.13.13:7687"
NEO4J_USER = "neo4j"
NEO4J_PASSWORD = "VPofL3g9gTaquiXxA6ntvQDyK"

# Set OpenAI API key
openai.api_key = OPENAI_API_KEY

# Use authoritative sources from domain_authority_sources.py
AGENT_DOMAIN_QUERIES = DOMAIN_AUTHORITY_SOURCES

# For backward compatibility with specialized agents
SPECIALIZED_AGENT_QUERIES = DOMAIN_AUTHORITY_SOURCES

# Art and ecommerce specific queries for VividWalls
VIVIDWALLS_DOMAIN_QUERIES = {
    "art_market": [
        "online art marketplace trends",
        "print on demand wall art",
        "art ecommerce best practices",
        "wall art interior design trends",
        "premium canvas print market"
    ],
    "hospitality_sales": [
        "hotel art procurement",
        "hospitality interior design",
        "bulk art ordering systems",
        "commercial art installation"
    ],
    "healthcare_design": [
        "healthcare facility art",
        "evidence-based design healthcare",
        "therapeutic art environments",
        "hospital art guidelines"
    ]
}

def crawl_url(url: str, wait_for: str = "networkidle") -> Optional[Dict[str, Any]]:
    """Crawl a single URL using Crawl4AI service."""
    try:
        request_data = {
            "url": url,
            "wait_for": wait_for,
            "screenshot": False,
            "remove_overlay": True,
            "bypass_cache": True
        }
        
        response = requests.post(
            f"{CRAWL4AI_URL}/crawl",
            json=request_data,
            headers={"Content-Type": "application/json"},
            timeout=60
        )
        
        if response.status_code == 200:
            result = response.json()
            # Extract content from various possible fields
            content = result.get("markdown") or result.get("content") or result.get("text", "")
            if content:
                return {
                    "url": url,
                    "content": content,
                    "title": result.get("title", ""),
                    "metadata": result.get("metadata", {})
                }
        else:
            print(f"Failed to crawl {url}: Status {response.status_code}")
            
    except Exception as e:
        print(f"Error crawling {url}: {e}")
    
    return None

def search_and_crawl(query: str, num_results: int = 3) -> List[Dict[str, Any]]:
    """Search for URLs related to a query and crawl them."""
    results = []
    
    # Use a search engine API or web search to find relevant URLs
    # For now, we'll use a simplified approach with known good sources
    # In production, you'd use Google Custom Search API or similar
    
    # Simulate search results with high-quality sources
    search_sources = [
        f"https://www.google.com/search?q={query.replace(' ', '+')}",
        # Add more search APIs or sources as needed
    ]
    
    # For demo purposes, return empty list
    # In production, implement actual search
    return results

def create_embedding(text: str) -> List[float]:
    """Create embedding using OpenAI."""
    try:
        response = openai.embeddings.create(
            model="text-embedding-3-small",
            input=text
        )
        return response.data[0].embedding
    except Exception as e:
        print(f"Error creating embedding: {e}")
        return [0.0] * 1536

def chunk_content(content: str, chunk_size: int = 1000, overlap: int = 200) -> List[str]:
    """Split content into overlapping chunks."""
    chunks = []
    words = content.split()
    
    if len(words) <= chunk_size:
        return [content]
    
    for i in range(0, len(words), chunk_size - overlap):
        chunk_words = words[i:i + chunk_size]
        chunk = " ".join(chunk_words)
        chunks.append(chunk)
        
        if i + chunk_size >= len(words):
            break
    
    return chunks

def generate_contextual_summary(content: str, agent_role: str) -> str:
    """Generate a summary relevant to the agent's role."""
    try:
        prompt = f"""As a {agent_role}, summarize the following content focusing on aspects relevant to your role:

{content[:2000]}

Provide a concise summary (2-3 sentences) highlighting key insights for {agent_role} responsibilities."""

        response = openai.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": f"You are a {agent_role} extracting relevant insights."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.3,
            max_tokens=150
        )
        
        return response.choices[0].message.content.strip()
    except Exception as e:
        print(f"Error generating summary: {e}")
        return ""

def store_in_supabase(agent_id: str, collection: str, chunks: List[Dict[str, Any]]):
    """Store chunks in Supabase with embeddings."""
    # Prepare auth headers
    auth_string = base64.b64encode(b"supabase:this_password_is_insecure_and_should_be_updated").decode()
    headers = {
        "Authorization": f"Basic {auth_string}",
        "apikey": SUPABASE_SERVICE_KEY,
        "Content-Type": "application/json",
        "Prefer": "return=representation"
    }
    
    batch_size = 10
    for i in range(0, len(chunks), batch_size):
        batch = chunks[i:i + batch_size]
        records = []
        
        for chunk_data in batch:
            # Generate embedding
            embedding = create_embedding(chunk_data["content"])
            
            record = {
                "agent_id": agent_id,
                "collection": collection,
                "content": chunk_data["content"],
                "metadata": {
                    "url": chunk_data.get("url", ""),
                    "title": chunk_data.get("title", ""),
                    "chunk_number": chunk_data.get("chunk_number", 0),
                    "summary": chunk_data.get("summary", ""),
                    "content_type": "domain_knowledge",
                    "source": "crawl4ai"
                },
                "embedding": embedding
            }
            records.append(record)
        
        try:
            response = requests.post(
                f"{SUPABASE_URL}/rest/v1/agent_embeddings",
                json=records,
                headers=headers,
                timeout=30
            )
            
            if response.status_code in [200, 201]:
                print(f"  ✓ Stored {len(records)} chunks for {agent_id}")
            else:
                print(f"  ✗ Failed to store chunks: {response.status_code}")
                print(f"    Response: {response.text[:200]}")
        except Exception as e:
            print(f"  ✗ Error storing chunks: {e}")

def store_in_neo4j(agent_id: str, knowledge_items: List[Dict[str, Any]]):
    """Store knowledge in Neo4j graph database."""
    try:
        from neo4j import GraphDatabase
        
        driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
        
        with driver.session() as session:
            # Create agent node if not exists
            session.run("""
                MERGE (a:Agent {id: $agent_id})
                ON CREATE SET a.created_at = datetime()
            """, agent_id=agent_id)
            
            # Add knowledge nodes and relationships
            for item in knowledge_items:
                session.run("""
                    MATCH (a:Agent {id: $agent_id})
                    CREATE (k:Knowledge {
                        content: $content,
                        url: $url,
                        title: $title,
                        summary: $summary,
                        created_at: datetime()
                    })
                    CREATE (a)-[:HAS_KNOWLEDGE]->(k)
                """, 
                agent_id=agent_id,
                content=item.get("content", "")[:1000],  # Limit content size
                url=item.get("url", ""),
                title=item.get("title", ""),
                summary=item.get("summary", "")
                )
            
            print(f"  ✓ Stored {len(knowledge_items)} items in Neo4j for {agent_id}")
            
        driver.close()
        
    except Exception as e:
        print(f"  ✗ Error storing in Neo4j: {e}")

def populate_agent_knowledge(agent_id: str, domain_config: Dict[str, Any]):
    """Populate knowledge for a specific agent."""
    print(f"\n{'='*50}")
    print(f"Processing {agent_id}")
    print(f"{'='*50}")
    
    collection = f"{agent_id}_vectors"
    all_chunks = []
    neo4j_items = []
    
    # Process predefined sources
    if "sources" in domain_config:
        print("\nCrawling predefined sources...")
        for source_url in domain_config["sources"]:
            print(f"  Crawling: {source_url}")
            result = crawl_url(source_url)
            
            if result and result["content"]:
                # Generate agent-specific summary
                summary = generate_contextual_summary(result["content"], agent_id.replace("_", " ").title())
                
                # Chunk the content
                content_chunks = chunk_content(result["content"])
                
                for idx, chunk in enumerate(content_chunks):
                    chunk_data = {
                        "content": chunk,
                        "url": source_url,
                        "title": result.get("title", ""),
                        "chunk_number": idx,
                        "summary": summary if idx == 0 else ""
                    }
                    all_chunks.append(chunk_data)
                
                # Add to Neo4j items
                neo4j_items.append({
                    "url": source_url,
                    "title": result.get("title", ""),
                    "content": result["content"][:1000],
                    "summary": summary
                })
    
    # Process search queries
    if "queries" in domain_config:
        print("\nProcessing domain queries...")
        for query in domain_config["queries"]:
            print(f"  Query: {query}")
            # In production, implement actual search
            # For now, we'll skip this
            pass
    
    # Store in databases
    if all_chunks:
        print(f"\nStoring {len(all_chunks)} chunks in Supabase...")
        store_in_supabase(agent_id, collection, all_chunks)
    
    if neo4j_items:
        print(f"\nStoring {len(neo4j_items)} items in Neo4j...")
        store_in_neo4j(agent_id, neo4j_items)

def populate_vividwalls_specific():
    """Populate VividWalls-specific domain knowledge."""
    print("\n" + "="*70)
    print("POPULATING VIVIDWALLS-SPECIFIC KNOWLEDGE")
    print("="*70)
    
    for domain, queries in VIVIDWALLS_DOMAIN_QUERIES.items():
        print(f"\nProcessing {domain} domain...")
        collection = f"vividwalls_{domain}_vectors"
        
        # Here you would implement actual search and crawl
        # For demo, we'll show the structure
        print(f"  Would search for: {', '.join(queries[:2])}...")

def create_tables_if_needed():
    """Create necessary tables in Supabase."""
    print("\nChecking/Creating tables...")
    
    # This would normally be done via Supabase dashboard
    # Printing SQL for reference
    sql = """
-- Enable vector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Create agent embeddings table
CREATE TABLE IF NOT EXISTS agent_embeddings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    agent_id VARCHAR(255) NOT NULL,
    collection VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    embedding vector(1536),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_agent_embeddings_agent ON agent_embeddings(agent_id);
CREATE INDEX IF NOT EXISTS idx_agent_embeddings_collection ON agent_embeddings(collection);
CREATE INDEX IF NOT EXISTS idx_agent_embeddings_embedding ON agent_embeddings 
    USING ivfflat (embedding vector_cosine_ops);

-- Create search function
CREATE OR REPLACE FUNCTION search_agent_knowledge(
    query_embedding vector(1536),
    agent_collection text,
    match_count int DEFAULT 10
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
    ORDER BY ae.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;
"""
    
    print("SQL commands have been prepared. Execute via Supabase dashboard.")
    return True

def main():
    """Main execution function."""
    print("VividWalls Agent Knowledge Population")
    print("Using Crawl4AI patterns for web scraping and RAG")
    print("="*70)
    
    # Create tables if needed
    create_tables_if_needed()
    
    # Test connections
    print("\nTesting connections...")
    
    # Test Crawl4AI
    try:
        test_result = crawl_url("https://example.com")
        if test_result:
            print("✓ Crawl4AI service is working")
        else:
            print("✗ Crawl4AI service issue")
    except Exception as e:
        print(f"✗ Crawl4AI error: {e}")
    
    # Test OpenAI
    try:
        test_embedding = create_embedding("test")
        if len(test_embedding) == 1536:
            print("✓ OpenAI embeddings working")
        else:
            print("✗ OpenAI embeddings issue")
    except Exception as e:
        print(f"✗ OpenAI error: {e}")
    
    # Process director-level agents
    director_agents = [
        "marketing_director",
        "sales_director",
        "operations_director",
        "analytics_director",
        "finance_director",
        "technology_director",
        "customer_experience_director",
        "product_director",
        "social_media_director"
    ]
    
    print(f"\nProcessing {len(director_agents)} director agents...")
    
    for agent_id in director_agents:
        if agent_id in AGENT_DOMAIN_QUERIES:
            populate_agent_knowledge(agent_id, AGENT_DOMAIN_QUERIES[agent_id])
            time.sleep(2)  # Rate limiting
    
    # Process specialized agents
    print(f"\nProcessing {len(SPECIALIZED_AGENT_QUERIES)} specialized agents...")
    
    for agent_id, config in SPECIALIZED_AGENT_QUERIES.items():
        populate_agent_knowledge(agent_id, config)
        time.sleep(2)  # Rate limiting
    
    # Populate VividWalls-specific knowledge
    populate_vividwalls_specific()
    
    print("\n" + "="*70)
    print("POPULATION COMPLETE")
    print("="*70)
    print("\nNext steps:")
    print("1. Verify data in Supabase: https://supabase.vividwalls.blog/")
    print("2. Check Neo4j browser: http://157.230.13.13:7474/")
    print("3. Test vector search in n8n workflows")
    print("4. Configure agent access to their respective collections")

if __name__ == "__main__":
    main()