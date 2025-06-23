#!/usr/bin/env python3
"""
Check the status of enhanced knowledge nodes
"""

from neo4j import GraphDatabase

# Configuration
NEO4J_URI = "bolt://157.230.13.13:7687"
NEO4J_USER = "neo4j"
NEO4J_PASSWORD = "VPofL3g9gTaquiXxA6ntvQDyK"

def main():
    driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
    
    with driver.session() as session:
        print("=== Knowledge Enhancement Status ===\n")
        
        # Get overall stats
        result = session.run("""
            MATCH (k:Knowledge)
            RETURN 
                count(k) as total,
                sum(CASE WHEN k.markdown_content IS NOT NULL THEN 1 ELSE 0 END) as with_content,
                sum(CASE WHEN k.content_preview IS NOT NULL THEN 1 ELSE 0 END) as with_preview
        """)
        
        record = result.single()
        total = record["total"]
        with_content = record["with_content"]
        with_preview = record["with_preview"]
        
        print(f"Total knowledge nodes: {total}")
        print(f"Nodes with full content: {with_content} ({with_content/total*100:.1f}%)")
        print(f"Nodes with preview: {with_preview} ({with_preview/total*100:.1f}%)")
        print(f"Nodes still to enhance: {total - with_content}")
        
        # Show sample enhanced nodes
        print("\n=== Sample Enhanced Knowledge Nodes ===")
        result = session.run("""
            MATCH (a:Agent)-[:HAS_KNOWLEDGE]->(k:Knowledge)
            WHERE k.markdown_content IS NOT NULL
            RETURN a.name as agent, k.title as title, k.source as source,
                   length(k.markdown_content) as content_length,
                   k.content_preview as preview
            ORDER BY k.enhanced_at DESC
            LIMIT 5
        """)
        
        for record in result:
            print(f"\nAgent: {record['agent']}")
            print(f"Title: {record['title']}")
            print(f"Source: {record['source']}")
            print(f"Content Length: {record['content_length']} chars")
            print(f"Preview: {record['preview'][:100]}...")
        
        # Show distribution by agent
        print("\n\n=== Enhanced Content by Agent (Top 10) ===")
        result = session.run("""
            MATCH (a:Agent)-[:HAS_KNOWLEDGE]->(k:Knowledge)
            WHERE k.markdown_content IS NOT NULL
            RETURN a.name as agent, count(k) as enhanced_count
            ORDER BY enhanced_count DESC
            LIMIT 10
        """)
        
        for record in result:
            print(f"{record['agent']}: {record['enhanced_count']} enhanced nodes")
    
    driver.close()

if __name__ == "__main__":
    main()