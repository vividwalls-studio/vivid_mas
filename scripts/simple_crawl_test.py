#!/usr/bin/env python3
"""Simple test to crawl and see what we get"""

import asyncio
from crawl4ai import AsyncWebCrawler
from neo4j import GraphDatabase

# Configuration
NEO4J_URI = "bolt://157.230.13.13:7687"
NEO4J_USER = "neo4j"
NEO4J_PASSWORD = "VPofL3g9gTaquiXxA6ntvQDyK"

async def test_simple_crawl():
    """Test basic crawling"""
    print("Starting simple crawl test...")
    
    # Initialize crawler
    crawler = AsyncWebCrawler()
    
    # Test URL
    test_url = "https://www.zendesk.com/blog/"
    
    print(f"Crawling {test_url}...")
    result = await crawler.arun(
        url=test_url,
        bypass_cache=True
    )
    
    if result.success:
        print(f"Success! Crawled {len(result.markdown)} characters")
        print(f"Title: {result.metadata.get('title', 'No title')}")
        print(f"Links found: {len(result.links)}")
        
        # Save content sample
        with open("/Volumes/SeagatePortableDrive/Projects/vivid_mas/logs/crawl_sample.md", "w") as f:
            f.write(result.markdown[:5000])
        print("Saved sample to logs/crawl_sample.md")
        
        # Store basic info in Neo4j
        store_basic_info(test_url, result.metadata.get('title', 'Zendesk Blog'))
    else:
        print(f"Failed to crawl: {result.error_message}")
    
    await crawler.close()

def store_basic_info(url, title):
    """Store basic crawl info in Neo4j"""
    print("\nStoring in Neo4j...")
    
    try:
        driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
        
        with driver.session() as session:
            # Create a simple knowledge node
            result = session.run("""
                MATCH (a:Agent {id: '00000000-0000-0000-0001-000000000001'})
                CREATE (k:Knowledge {
                    title: $title,
                    url: $url,
                    source: 'Zendesk',
                    type: 'Blog',
                    crawled_at: datetime()
                })
                CREATE (a)-[:HAS_KNOWLEDGE]->(k)
                RETURN k
            """, 
            title=title,
            url=url)
            
            print("✓ Successfully stored in Neo4j")
            
            # Check what we have
            result = session.run("""
                MATCH (a:Agent)-[:HAS_KNOWLEDGE]->(k:Knowledge)
                RETURN k.title as title, k.url as url
            """)
            
            print("\nCurrent knowledge base:")
            for record in result:
                print(f"- {record['title']}")
        
        driver.close()
        
    except Exception as e:
        print(f"Error storing in Neo4j: {e}")

if __name__ == "__main__":
    asyncio.run(test_simple_crawl())