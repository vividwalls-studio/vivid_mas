#!/usr/bin/env python3
"""Test script to show agent structure and create initial ontology"""

import os
import sys
from pathlib import Path
from neo4j import GraphDatabase
from dotenv import load_dotenv
import re

# Load environment variables
load_dotenv(Path(__file__).parent / "mcp-crawl4ai-rag/.env")

NEO4J_URI = os.getenv("NEO4J_URI", "bolt://157.230.13.13:7687")
NEO4J_USER = os.getenv("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.getenv("NEO4J_PASSWORD")

AGENTS_PATH = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/prompts")

def extract_agent_info(content: str) -> dict:
    """Extract key information from agent markdown"""
    info = {
        "name": "",
        "role": "",
        "specializations": [],
        "capabilities": [],
        "responsibilities": [],
        "core_functions": []
    }
    
    # Extract name
    name_match = re.search(r'\*\*Name\*\*:\s*`([^`]+)`', content)
    if name_match:
        info["name"] = name_match.group(1)
        
    # Extract role
    role_match = re.search(r'\*\*Role\*\*:\s*([^\n]+)', content)
    if role_match:
        info["role"] = role_match.group(1).strip()
        
    # Extract capabilities
    cap_match = re.search(r'\*\*Capabilities\*\*:\s*([^\n]+)', content)
    if cap_match:
        info["capabilities"] = [c.strip() for c in cap_match.group(1).split(',')]
        
    # Extract specializations
    spec_section = re.search(r'## Specializations?:(.*?)(?=##|\Z)', content, re.DOTALL)
    if spec_section:
        specs = re.findall(r'- (.+)', spec_section.group(1))
        info["specializations"] = specs
        
    # Extract responsibilities
    resp_section = re.search(r'## Core Responsibilities(.*?)(?=##|\Z)', content, re.DOTALL)
    if resp_section:
        resps = re.findall(r'- (.+)', resp_section.group(1))
        info["responsibilities"] = resps
        
    # Extract core functions
    func_section = re.search(r'## Core Functions?:(.*?)(?=##|\Z)', content, re.DOTALL)
    if func_section:
        funcs = re.findall(r'- (\w+)\(', func_section.group(1))
        info["core_functions"] = funcs
        
    return info

def main():
    print("Analyzing agent structure and creating initial ontology...")
    
    # Connect to Neo4j
    driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
    
    # Load and analyze agents
    agents = []
    for agent_file in AGENTS_PATH.rglob("*agent*.md"):
        if "matrix" not in agent_file.name.lower():
            try:
                content = agent_file.read_text()
                agent_info = extract_agent_info(content)
                if agent_info["name"]:
                    agents.append(agent_info)
            except Exception as e:
                print(f"Error loading {agent_file}: {e}")
    
    print(f"\nFound {len(agents)} agents")
    
    # Show sample agents
    print("\nSample Agent Structures:")
    for agent in agents[:3]:
        print(f"\n{agent['name']}")
        print(f"  Role: {agent['role']}")
        print(f"  Capabilities: {', '.join(agent['capabilities'][:3])}")
        print(f"  Specializations ({len(agent['specializations'])}):")
        for spec in agent['specializations'][:3]:
            print(f"    - {spec}")
            
    # Create initial ontology with predefined concepts
    with driver.session() as session:
        # Clear existing data
        session.run("MATCH ()-[r]-() DELETE r")
        session.run("MATCH (n) DELETE n")
        
        print("\n\nCreating initial ontology...")
        
        # Create domain nodes
        domains = {
            "marketing": ["customer acquisition", "brand strategy", "advertising", "social media marketing", "content marketing"],
            "analytics": ["data analysis", "business intelligence", "predictive modeling", "KPI tracking", "reporting"],
            "product": ["product development", "feature prioritization", "roadmapping", "user research", "product analytics"],
            "customer_experience": ["customer support", "user experience", "customer satisfaction", "retention", "feedback analysis"],
            "technology": ["software development", "automation", "integration", "API management", "technical infrastructure"],
            "finance": ["budgeting", "financial analysis", "revenue optimization", "cost management", "pricing strategy"],
            "operations": ["supply chain", "inventory management", "fulfillment", "logistics", "process optimization"],
            "art": ["abstract art", "visual trends", "color theory", "artistic styles", "creative direction"]
        }
        
        for domain, concepts in domains.items():
            # Create domain node
            session.run("""
                MERGE (d:Domain {name: $domain})
                SET d.created_at = datetime()
            """, domain=domain)
            
            # Create concept nodes for domain
            for concept in concepts:
                session.run("""
                    MERGE (c:Concept {name: $concept})
                    SET c.type = 'domain_concept',
                        c.created_at = datetime()
                    MERGE (d:Domain {name: $domain})
                    MERGE (d)-[:CONTAINS]->(c)
                """, concept=concept, domain=domain)
        
        # Create agents with their specializations
        for agent in agents[:5]:
            print(f"\nCreating {agent['name']}...")
            
            # Create agent node
            session.run("""
                MERGE (a:Agent {name: $name})
                SET a.role = $role,
                    a.capabilities = $capabilities,
                    a.created_at = datetime()
            """, 
                name=agent['name'],
                role=agent['role'],
                capabilities=agent['capabilities']
            )
            
            # Link agent to relevant domains based on role/specializations
            agent_text = (agent['role'] + " " + " ".join(agent['specializations'])).lower()
            
            for domain in domains.keys():
                if domain in agent_text or any(keyword in agent_text for keyword in domain.split('_')):
                    session.run("""
                        MATCH (a:Agent {name: $agent})
                        MATCH (d:Domain {name: $domain})
                        MERGE (a)-[:OPERATES_IN]->(d)
                    """, agent=agent['name'], domain=domain)
                    
            # Create specialization relationships
            for spec in agent['specializations'][:5]:
                session.run("""
                    MERGE (s:Specialization {name: $spec})
                    MERGE (a:Agent {name: $agent})
                    MERGE (a)-[:HAS_SPECIALIZATION]->(s)
                    
                    // Link specialization to related concepts
                    WITH s, a
                    MATCH (c:Concept)
                    WHERE toLower(c.name) CONTAINS toLower(s.name) 
                       OR toLower(s.name) CONTAINS toLower(c.name)
                    MERGE (s)-[:RELATED_TO]->(c)
                """, spec=spec, agent=agent['name'])
        
        # Create agent collaboration network
        session.run("""
            MATCH (a1:Agent)-[:OPERATES_IN]->(d:Domain)<-[:OPERATES_IN]-(a2:Agent)
            WHERE a1.name < a2.name
            MERGE (a1)-[r:CAN_COLLABORATE_WITH]->(a2)
            SET r.shared_domains = 
                size([(a1)-[:OPERATES_IN]->(domain)<-[:OPERATES_IN]-(a2) | domain.name])
        """)
        
    # Show results
    with driver.session() as session:
        result = session.run("""
            MATCH (n)
            RETURN labels(n)[0] as type, count(n) as count
            ORDER BY count DESC
        """)
        
        print("\n\nOntology Summary:")
        for record in result:
            print(f"  {record['type']}: {record['count']}")
            
        print("\n\nAgent Domain Coverage:")
        result = session.run("""
            MATCH (a:Agent)-[:OPERATES_IN]->(d:Domain)
            RETURN a.name as agent, collect(d.name) as domains
            ORDER BY a.name
            LIMIT 5
        """)
        
        for record in result:
            print(f"\n{record['agent']}:")
            print(f"  Domains: {', '.join(record['domains'])}")
    
    driver.close()
    print("\n✓ Initial ontology created successfully!")

if __name__ == "__main__":
    main()