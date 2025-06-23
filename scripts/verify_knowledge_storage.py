#!/usr/bin/env python3
"""
Verify that crawled data was stored in Neo4j knowledge graph
"""

from neo4j import GraphDatabase

# Configuration
NEO4J_URI = "bolt://157.230.13.13:7687"
NEO4J_USER = "neo4j"
NEO4J_PASSWORD = "VPofL3g9gTaquiXxA6ntvQDyK"

def main():
    driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
    
    with driver.session() as session:
        print("=== Verifying Knowledge Storage in Neo4j ===\n")
        
        # Check if Knowledge nodes exist
        result = session.run("MATCH (k:Knowledge) RETURN count(k) as count")
        knowledge_count = result.single()["count"]
        print(f"Total Knowledge nodes: {knowledge_count}")
        
        if knowledge_count > 0:
            # Sample some knowledge nodes
            print("\n=== Sample Knowledge Nodes ===")
            result = session.run("""
                MATCH (a:Agent)-[:HAS_KNOWLEDGE]->(k:Knowledge)
                RETURN a.name as agent, k.title as title, k.url as url, 
                       k.source as source, k.content_length as length
                LIMIT 10
            """)
            
            for record in result:
                print(f"\nAgent: {record['agent']}")
                print(f"  Title: {record['title']}")
                print(f"  Source: {record['source']}")
                print(f"  URL: {record['url']}")
                print(f"  Content Length: {record['length']} chars")
        
        # Check Topics
        result = session.run("MATCH (t:Topic) RETURN count(t) as count")
        topic_count = result.single()["count"]
        print(f"\n\nTotal Topic nodes: {topic_count}")
        
        if topic_count > 0:
            print("\n=== Sample Topics ===")
            result = session.run("""
                MATCH (t:Topic)<-[:RELATES_TO]-(k:Knowledge)
                RETURN t.name as topic, count(k) as knowledge_count
                ORDER BY knowledge_count DESC
                LIMIT 10
            """)
            
            for record in result:
                print(f"{record['topic']}: {record['knowledge_count']} knowledge items")
        
        # Check relationships
        print("\n\n=== Relationship Counts ===")
        relationships = [
            "HAS_KNOWLEDGE",
            "RELATES_TO",
            "REPORTS_TO",
            "BELONGS_TO",
            "OPERATES_IN"
        ]
        
        for rel in relationships:
            result = session.run(f"MATCH ()-[r:{rel}]->() RETURN count(r) as count")
            count = result.single()["count"]
            print(f"{rel}: {count}")
        
        # Check what data is stored in Knowledge nodes
        print("\n\n=== Knowledge Node Properties (Sample) ===")
        result = session.run("""
            MATCH (k:Knowledge)
            RETURN k
            LIMIT 1
        """)
        
        record = result.single()
        if record:
            knowledge_node = record["k"]
            print("Properties stored:")
            for key, value in knowledge_node.items():
                if key == "markdown_content" and value:
                    print(f"  {key}: {len(value)} characters")
                else:
                    print(f"  {key}: {value}")
    
    driver.close()

if __name__ == "__main__":
    main()