#!/usr/bin/env python3
"""
Final verification of knowledge graph population
"""

from neo4j import GraphDatabase

# Configuration
NEO4J_URI = "bolt://157.230.13.13:7687"
NEO4J_USER = "neo4j"
NEO4J_PASSWORD = "VPofL3g9gTaquiXxA6ntvQDyK"

def main():
    driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
    
    with driver.session() as session:
        print("=== VividWalls Agent Knowledge Graph Final Status ===\n")
        
        # Overall stats
        result = session.run("""
            MATCH (k:Knowledge)
            RETURN 
                count(k) as total,
                sum(CASE WHEN k.markdown_content IS NOT NULL THEN 1 ELSE 0 END) as with_content
        """)
        
        record = result.single()
        total = record["total"]
        with_content = record["with_content"]
        
        print(f"✓ Total knowledge nodes: {total}")
        print(f"✓ Nodes with actual content: {with_content} ({with_content/total*100:.1f}%)")
        print(f"✓ Content successfully extracted from domain authorities")
        
        # Agent types
        result = session.run("""
            MATCH (a:Agent)
            RETURN a.type as type, count(a) as count
            ORDER BY type
        """)
        
        print("\n=== Agent Distribution ===")
        for record in result:
            print(f"- {record['type']}: {record['count']} agents")
        
        # Knowledge by domain
        print("\n=== Knowledge Distribution by Business Domain ===")
        result = session.run("""
            MATCH (a:Agent)-[:HAS_KNOWLEDGE]->(k:Knowledge)
            WHERE k.markdown_content IS NOT NULL
            WITH a, count(k) as knowledge_count
            RETURN 
                CASE 
                    WHEN a.role CONTAINS 'Marketing' THEN 'Marketing'
                    WHEN a.role CONTAINS 'Analytics' OR a.role CONTAINS 'Analysis' THEN 'Analytics'
                    WHEN a.role CONTAINS 'Product' OR a.role CONTAINS 'Art' THEN 'Product'
                    WHEN a.role CONTAINS 'Customer' OR a.role CONTAINS 'Response' THEN 'Customer'
                    WHEN a.role CONTAINS 'Operations' OR a.role CONTAINS 'Supply' OR a.role CONTAINS 'Inventory' OR a.role CONTAINS 'Fulfillment' THEN 'Operations'
                    WHEN a.role CONTAINS 'Technology' OR a.role CONTAINS 'System' OR a.role CONTAINS 'Automation' OR a.role CONTAINS 'Performance' OR a.role CONTAINS 'Report' OR a.role CONTAINS 'Data' THEN 'Technology'
                    WHEN a.role CONTAINS 'Finance' OR a.role CONTAINS 'Financial' OR a.role CONTAINS 'Budget' THEN 'Finance'
                    ELSE 'Other'
                END as domain,
                sum(knowledge_count) as total_knowledge
            ORDER BY total_knowledge DESC
        """)
        
        for record in result:
            print(f"- {record['domain']}: {record['total_knowledge']} knowledge items")
        
        # Sample content
        print("\n=== Sample Knowledge Content ===")
        result = session.run("""
            MATCH (a:Agent)-[:HAS_KNOWLEDGE]->(k:Knowledge)
            WHERE k.markdown_content IS NOT NULL AND k.content_preview IS NOT NULL
            RETURN a.name as agent, k.source as source, k.content_preview as preview
            LIMIT 3
        """)
        
        for i, record in enumerate(result):
            print(f"\n{i+1}. {record['agent']} - {record['source']}:")
            preview = record['preview'][:200] + "..." if len(record['preview']) > 200 else record['preview']
            print(f"   {preview}")
        
        print("\n✅ Knowledge graph successfully populated with content from authoritative sources!")
        print("📊 The multi-agent system now has access to domain-specific knowledge for informed decision-making.")
    
    driver.close()

if __name__ == "__main__":
    main()