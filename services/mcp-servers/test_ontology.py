#!/usr/bin/env python3
"""Test ontology seeding for a single agent"""

import os
import sys
import asyncio
from pathlib import Path
from neo4j import GraphDatabase
from dotenv import load_dotenv

# Load environment variables
load_dotenv(Path(__file__).parent / "mcp-crawl4ai-rag/.env")

# Configuration
NEO4J_URI = os.getenv("NEO4J_URI", "bolt://157.230.13.13:7687")
NEO4J_USER = os.getenv("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.getenv("NEO4J_PASSWORD")

async def test_neo4j_and_crawl():
    """Test basic Neo4j connection and create a simple ontology"""
    
    print("Testing Neo4j connection...")
    driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
    
    try:
        with driver.session() as session:
            # Test connection
            result = session.run("RETURN 1 as test")
            print(f"✓ Neo4j connected: {result.single()['test']}")
            
            # Create a test agent node
            print("\nCreating test agent node...")
            session.run("""
                MERGE (a:Agent {key: 'TestAgent'})
                SET a.name = 'Test Marketing Agent',
                    a.updated_at = datetime(),
                    a.topics = ['marketing', 'digital', 'seo']
            """)
            
            # Create test concept nodes
            concepts = ['digital marketing', 'content strategy', 'SEO optimization', 'social media']
            for concept in concepts:
                session.run("""
                    MERGE (c:Concept {name: $concept})
                    MERGE (a:Agent {key: 'TestAgent'})
                    MERGE (a)-[:KNOWS_ABOUT]->(c)
                    ON CREATE SET c.discovered_at = datetime()
                """, concept=concept)
            
            print(f"✓ Created {len(concepts)} concept nodes")
            
            # Query to verify
            result = session.run("""
                MATCH (a:Agent {key: 'TestAgent'})-[:KNOWS_ABOUT]->(c:Concept)
                RETURN a.name as agent, collect(c.name) as concepts
            """)
            
            for record in result:
                print(f"\n{record['agent']} knows about:")
                for concept in record['concepts']:
                    print(f"  - {concept}")
                    
    finally:
        driver.close()
        
    print("\n✓ Test completed successfully!")

if __name__ == "__main__":
    asyncio.run(test_neo4j_and_crawl())