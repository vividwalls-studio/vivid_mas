#!/usr/bin/env python3
"""Test script to crawl a single page and store in Neo4j"""

import asyncio
import json
from crawl4ai import AsyncWebCrawler, LLMConfig
from crawl4ai.extraction_strategy import LLMExtractionStrategy
from neo4j import GraphDatabase
import os

# Configuration
NEO4J_URI = "bolt://157.230.13.13:7687"
NEO4J_USER = "neo4j"
NEO4J_PASSWORD = "VPofL3g9gTaquiXxA6ntvQDyK"
OPENAI_API_KEY = "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"

async def test_crawl():
    """Test crawling a single customer service article"""
    print("Starting test crawl...")
    
    # Initialize crawler
    crawler = AsyncWebCrawler()
    await crawler.arun(url="https://example.com", bypass_cache=True)  # Warm up
    
    # Test URL - HelpScout blog article
    test_url = "https://www.helpscout.com/blog/customer-service-skills/"
    
    # Define extraction schema
    extraction_strategy = LLMExtractionStrategy(
        llm_config=LLMConfig(
            provider="openai",
            api_token=OPENAI_API_KEY
        ),
        schema={
            "type": "object",
            "properties": {
                "title": {"type": "string"},
                "topic": {"type": "string"},
                "key_insights": {
                    "type": "array",
                    "items": {"type": "string"},
                    "maxItems": 5
                },
                "best_practices": {
                    "type": "array",
                    "items": {"type": "string"},
                    "maxItems": 5
                },
                "skills_mentioned": {
                    "type": "array",
                    "items": {"type": "string"}
                }
            }
        },
        instruction="Extract key customer service insights from this article. Focus on skills, best practices, and actionable advice."
    )
    
    print(f"Crawling {test_url}...")
    result = await crawler.arun(
        url=test_url,
        extraction_strategy=extraction_strategy,
        bypass_cache=True
    )
    
    if result.success and result.extracted_content:
        content_data = json.loads(result.extracted_content)
        print("\nExtracted content:")
        print(json.dumps(content_data, indent=2))
        
        # Store in Neo4j
        store_in_neo4j(content_data, test_url)
    else:
        print(f"Failed to crawl: {result.error_message}")
    
    await crawler.close()

def store_in_neo4j(content_data, url):
    """Store extracted content in Neo4j"""
    print("\nStoring in Neo4j...")
    
    try:
        driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
        
        with driver.session() as session:
            # Ensure agent exists
            agent_id = "00000000-0000-0000-0001-000000000001"
            
            # Create knowledge node
            result = session.run("""
                MATCH (a:Agent {id: $agent_id})
                CREATE (k:Knowledge {
                    title: $title,
                    topic: $topic,
                    url: $url,
                    source: 'HelpScout',
                    type: 'Article',
                    crawled_at: datetime()
                })
                CREATE (a)-[:HAS_KNOWLEDGE]->(k)
                RETURN k
            """, 
            agent_id=agent_id,
            title=content_data.get("title", "Customer Service Skills"),
            topic=content_data.get("topic", "Customer Service"),
            url=url)
            
            # Add insights
            for insight in content_data.get("key_insights", []):
                session.run("""
                    MATCH (k:Knowledge {url: $url})
                    CREATE (i:Insight {content: $content, type: 'Key Insight'})
                    CREATE (k)-[:CONTAINS]->(i)
                """, url=url, content=insight)
            
            # Add best practices
            for practice in content_data.get("best_practices", []):
                session.run("""
                    MATCH (k:Knowledge {url: $url})
                    CREATE (bp:BestPractice {content: $content})
                    CREATE (k)-[:RECOMMENDS]->(bp)
                """, url=url, content=practice)
            
            # Add skills
            for skill in content_data.get("skills_mentioned", []):
                session.run("""
                    MATCH (k:Knowledge {url: $url})
                    MERGE (s:Skill {name: $skill})
                    CREATE (k)-[:REQUIRES]->(s)
                """, url=url, skill=skill)
            
            print("✓ Successfully stored in Neo4j")
            
            # Verify storage
            result = session.run("""
                MATCH (a:Agent {id: $agent_id})-[:HAS_KNOWLEDGE]->(k:Knowledge)
                RETURN count(k) as knowledge_count
            """, agent_id=agent_id)
            
            count = result.single()['knowledge_count']
            print(f"Total knowledge items for agent: {count}")
        
        driver.close()
        
    except Exception as e:
        print(f"Error storing in Neo4j: {e}")

if __name__ == "__main__":
    asyncio.run(test_crawl())