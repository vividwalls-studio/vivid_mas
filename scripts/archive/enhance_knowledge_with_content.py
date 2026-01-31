#!/usr/bin/env python3
"""
Enhance existing knowledge nodes with actual content from crawled pages
"""

import asyncio
from crawl4ai import AsyncWebCrawler
from neo4j import GraphDatabase
import time

# Configuration
NEO4J_URI = "bolt://157.230.13.13:7687"
NEO4J_USER = "neo4j"
NEO4J_PASSWORD = "VPofL3g9gTaquiXxA6ntvQDyK"

class KnowledgeEnhancer:
    def __init__(self):
        self.crawler = None
        self.neo4j_driver = None
        
    async def initialize(self):
        """Initialize crawler and database connections"""
        print("Initializing knowledge enhancer...")
        self.crawler = AsyncWebCrawler()
        
        try:
            self.neo4j_driver = GraphDatabase.driver(
                NEO4J_URI, 
                auth=(NEO4J_USER, NEO4J_PASSWORD)
            )
            print("✓ Connected to Neo4j")
        except Exception as e:
            print(f"⚠️  Neo4j connection failed: {e}")
            return False
        return True
    
    async def enhance_knowledge_nodes(self, limit=10):
        """Enhance existing knowledge nodes with content"""
        with self.neo4j_driver.session() as session:
            # Get knowledge nodes without content
            result = session.run("""
                MATCH (k:Knowledge)
                WHERE k.markdown_content IS NULL OR NOT (k.markdown_content IS NOT NULL)
                RETURN k.url as url, id(k) as node_id
                LIMIT $limit
            """, limit=limit)
            
            urls_to_enhance = [(record["url"], record["node_id"]) for record in result]
            
        if not urls_to_enhance:
            print("All knowledge nodes already have content!")
            return
        
        print(f"\nFound {len(urls_to_enhance)} knowledge nodes to enhance with content")
        
        for url, node_id in urls_to_enhance:
            print(f"\nEnhancing: {url}")
            try:
                # Crawl the URL
                result = await self.crawler.arun(
                    url=url,
                    bypass_cache=False  # Use cache if available
                )
                
                if result.success and result.markdown:
                    # Extract key insights from content
                    content_preview = result.markdown[:500] + "..." if len(result.markdown) > 500 else result.markdown
                    
                    # Update the knowledge node with content
                    with self.neo4j_driver.session() as session:
                        session.run("""
                            MATCH (k:Knowledge)
                            WHERE id(k) = $node_id
                            SET k.markdown_content = $content,
                                k.content_preview = $preview,
                                k.enhanced_at = datetime()
                        """, 
                        node_id=node_id,
                        content=result.markdown[:50000],  # Limit to 50k chars
                        preview=content_preview)
                    
                    print(f"  ✓ Enhanced with {len(result.markdown)} chars of content")
                else:
                    print(f"  ✗ Failed to crawl")
                    
            except Exception as e:
                print(f"  ✗ Error: {e}")
            
            # Brief pause between requests
            await asyncio.sleep(0.5)
    
    def close(self):
        """Close connections"""
        if self.neo4j_driver:
            self.neo4j_driver.close()

async def main():
    """Main execution"""
    enhancer = KnowledgeEnhancer()
    
    if not await enhancer.initialize():
        return
    
    print("\n=== Enhancing Knowledge Nodes with Content ===")
    
    # Process in batches
    batch_size = 20
    total_enhanced = 0
    
    while True:
        start_count = total_enhanced
        await enhancer.enhance_knowledge_nodes(limit=batch_size)
        
        # Check how many we've enhanced
        with enhancer.neo4j_driver.session() as session:
            result = session.run("""
                MATCH (k:Knowledge)
                WHERE k.markdown_content IS NOT NULL
                RETURN count(k) as count
            """)
            total_enhanced = result.single()["count"]
        
        if total_enhanced == start_count:
            # No more to enhance
            break
        
        print(f"\nTotal enhanced so far: {total_enhanced}")
        await asyncio.sleep(1)  # Brief pause between batches
    
    # Final summary
    with enhancer.neo4j_driver.session() as session:
        result = session.run("""
            MATCH (k:Knowledge)
            RETURN 
                count(k) as total,
                sum(CASE WHEN k.markdown_content IS NOT NULL THEN 1 ELSE 0 END) as with_content
        """)
        record = result.single()
        print(f"\n=== Final Summary ===")
        print(f"Total knowledge nodes: {record['total']}")
        print(f"Nodes with content: {record['with_content']}")
        print(f"Enhancement rate: {record['with_content']/record['total']*100:.1f}%")
    
    enhancer.close()

if __name__ == "__main__":
    asyncio.run(main())