#!/usr/bin/env python3
"""
Check the completed ontology in Neo4j
"""

from neo4j import GraphDatabase

# Configuration
NEO4J_URI = "bolt://157.230.13.13:7687"
NEO4J_USER = "neo4j"
NEO4J_PASSWORD = "VPofL3g9gTaquiXxA6ntvQDyK"

def main():
    driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
    
    with driver.session() as session:
        print("=== VividWalls Agent Ontology Summary ===\n")
        
        # Count agents by type
        result = session.run("""
            MATCH (a:Agent)
            RETURN a.type as agent_type, count(a) as count
            ORDER BY agent_type
        """)
        
        print("Agent Counts by Type:")
        for record in result:
            print(f"  - {record['agent_type']}: {record['count']}")
        
        # Count knowledge items
        result = session.run("MATCH (k:Knowledge) RETURN count(k) as count")
        knowledge_count = result.single()["count"]
        
        # Count topics
        result = session.run("MATCH (t:Topic) RETURN count(t) as count")
        topic_count = result.single()["count"]
        
        # Count relationships
        result = session.run("MATCH ()-[r:REPORTS_TO]->() RETURN count(r) as count")
        reports_to = result.single()["count"]
        
        print(f"\n✓ Total Knowledge Items: {knowledge_count}")
        print(f"✓ Total Topics: {topic_count}")
        print(f"✓ Reporting Relationships: {reports_to}")
        
        # Show directors and their reports
        print("\n=== Reporting Structure ===")
        result = session.run("""
            MATCH (director:Agent {type: 'Director'})
            OPTIONAL MATCH (task:Agent)-[:REPORTS_TO]->(director)
            RETURN director.name as director_name, 
                   director.role as director_role,
                   collect(task.role) as reports
            ORDER BY director_name
        """)
        
        for record in result:
            print(f"\n{record['director_name']} ({record['director_role']}):")
            if record['reports']:
                for report in record['reports']:
                    print(f"  - {report}")
            else:
                print("  - No direct reports")
        
        # Show knowledge distribution
        print("\n=== Knowledge Distribution (Top 10) ===")
        result = session.run("""
            MATCH (a:Agent)
            OPTIONAL MATCH (a)-[:HAS_KNOWLEDGE]->(k:Knowledge)
            RETURN a.name as agent_name, a.role as role, count(k) as knowledge_count
            ORDER BY knowledge_count DESC
            LIMIT 10
        """)
        
        for record in result:
            print(f"{record['agent_name']} ({record['role']}): {record['knowledge_count']} items")
    
    driver.close()

if __name__ == "__main__":
    main()