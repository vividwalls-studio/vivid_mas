#!/usr/bin/env python3
"""Test Neo4j connection and create initial ontology structure"""

from neo4j import GraphDatabase
import os

# Neo4j configuration
NEO4J_URI = "bolt://157.230.13.13:7687"
NEO4J_USER = "neo4j"
NEO4J_PASSWORD = "VPofL3g9gTaquiXxA6ntvQDyK"

def test_connection():
    """Test Neo4j connection"""
    print(f"Testing connection to Neo4j at {NEO4J_URI}...")
    
    try:
        driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
        
        with driver.session() as session:
            result = session.run("RETURN 'Connection successful!' as message")
            record = result.single()
            print(f"✓ {record['message']}")
            
            # Get database info
            result = session.run("CALL dbms.components() YIELD name, versions RETURN name, versions")
            for record in result:
                print(f"  Component: {record['name']}, Version: {record['versions']}")
        
        driver.close()
        return True
        
    except Exception as e:
        print(f"✗ Connection failed: {e}")
        print("\nPossible issues:")
        print("1. Neo4j password might be different than default")
        print("2. Neo4j might not be accessible from outside the droplet")
        print("3. Firewall rules might be blocking port 7687")
        return False

def create_base_ontology():
    """Create base ontology structure for VividWalls agents"""
    print("\nCreating base ontology structure...")
    
    try:
        driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
        
        with driver.session() as session:
            # Clear existing data (careful in production!)
            print("Clearing existing agent data...")
            session.run("MATCH (n:Agent) DETACH DELETE n")
            session.run("MATCH (n:Concept) DETACH DELETE n")
            session.run("MATCH (n:Metric) DETACH DELETE n")
            
            # Create CustomerExperienceDirector
            print("Creating CustomerExperienceDirector agent...")
            session.run("""
                CREATE (a:Agent {
                    id: '00000000-0000-0000-0001-000000000001',
                    name: 'Emily Chen',
                    role: 'Customer Experience Director',
                    type: 'Director',
                    backstory: 'Chief Customer Officer responsible for support and retention'
                })
            """)
            
            # Create core concepts
            print("Creating core concepts...")
            session.run("""
                MATCH (a:Agent {id: '00000000-0000-0000-0001-000000000001'})
                CREATE (cs:Concept {name: 'Customer Service', type: 'Core', definition: 'Activities to ensure customer satisfaction'})
                CREATE (cr:Concept {name: 'Customer Retention', type: 'Core', definition: 'Strategies to keep customers engaged and loyal'})
                CREATE (cf:Concept {name: 'Customer Feedback', type: 'Core', definition: 'Collection and analysis of customer opinions'})
                CREATE (st:Concept {name: 'Support Technology', type: 'Core', definition: 'Tools and systems for customer support'})
                CREATE (a)-[:MANAGES]->(cs)
                CREATE (a)-[:MANAGES]->(cr)
                CREATE (a)-[:MANAGES]->(cf)
                CREATE (a)-[:MANAGES]->(st)
            """)
            
            # Create key metrics
            print("Creating key metrics...")
            session.run("""
                MATCH (a:Agent {id: '00000000-0000-0000-0001-000000000001'})
                CREATE (nps:Metric {name: 'NPS', fullName: 'Net Promoter Score', target: '>70', type: 'KPI'})
                CREATE (csat:Metric {name: 'CSAT', fullName: 'Customer Satisfaction Score', target: '>90%', type: 'KPI'})
                CREATE (churn:Metric {name: 'Churn Rate', fullName: 'Customer Churn Rate', target: '<5%', type: 'KPI'})
                CREATE (fcr:Metric {name: 'FCR', fullName: 'First Contact Resolution', target: '>80%', type: 'Operational'})
                CREATE (art:Metric {name: 'ART', fullName: 'Average Response Time', target: '<2 hours', type: 'Operational'})
                CREATE (a)-[:TRACKS]->(nps)
                CREATE (a)-[:TRACKS]->(csat)
                CREATE (a)-[:TRACKS]->(churn)
                CREATE (a)-[:TRACKS]->(fcr)
                CREATE (a)-[:TRACKS]->(art)
            """)
            
            print("✓ Base ontology created successfully!")
            
            # Verify creation
            result = session.run("MATCH (a:Agent) RETURN count(a) as agent_count")
            agent_count = result.single()['agent_count']
            
            result = session.run("MATCH (c:Concept) RETURN count(c) as concept_count")
            concept_count = result.single()['concept_count']
            
            result = session.run("MATCH (m:Metric) RETURN count(m) as metric_count")
            metric_count = result.single()['metric_count']
            
            print(f"\nCreated:")
            print(f"  - {agent_count} Agent(s)")
            print(f"  - {concept_count} Concept(s)")
            print(f"  - {metric_count} Metric(s)")
        
        driver.close()
        return True
        
    except Exception as e:
        print(f"✗ Failed to create ontology: {e}")
        return False

if __name__ == "__main__":
    if test_connection():
        create_base_ontology()