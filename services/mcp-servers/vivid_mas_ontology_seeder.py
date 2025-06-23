#!/usr/bin/env python3
"""
VividMAS Ontology Seeder
Seeds Neo4j knowledge graph with agent-specific domain knowledge
based on their roles, specializations, and capabilities
"""

import os
import asyncio
import re
from pathlib import Path
from typing import Dict, List, Set
from neo4j import GraphDatabase
from dotenv import load_dotenv
import requests

# Load environment variables
load_dotenv(Path(__file__).parent / "mcp-crawl4ai-rag/.env")

# Configuration
CRAWL4AI_URL = "http://157.230.13.13:11235"
NEO4J_URI = os.getenv("NEO4J_URI", "bolt://157.230.13.13:7687")
NEO4J_USER = os.getenv("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.getenv("NEO4J_PASSWORD")

# Agent definitions path
AGENTS_PATH = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/prompts")

# Specialization to search query mapping
SPECIALIZATION_QUERIES = {
    # Marketing specializations
    "ad copy generation": ["advertising copywriting tips", "effective ad copy examples", "conversion copywriting"],
    "product description": ["ecommerce product descriptions", "SEO product copy", "product description templates"],
    "social media content": ["social media marketing strategies", "instagram content ideas", "social media engagement"],
    "email campaign": ["email marketing best practices", "email campaign strategies", "email automation"],
    "brand voice": ["brand voice guidelines", "brand personality", "consistent brand messaging"],
    "hashtag research": ["instagram hashtag strategy", "trending hashtags", "hashtag analytics"],
    
    # Analytics specializations
    "data analysis": ["business analytics techniques", "data visualization", "KPI analysis"],
    "predictive modeling": ["predictive analytics methods", "machine learning forecasting", "business predictions"],
    "customer analytics": ["customer behavior analysis", "customer segmentation", "CLV analysis"],
    "performance metrics": ["business performance indicators", "metric tracking", "dashboard design"],
    
    # Product specializations
    "product development": ["product management strategies", "agile product development", "MVP development"],
    "feature prioritization": ["product feature ranking", "prioritization frameworks", "user story mapping"],
    "market research": ["market analysis techniques", "competitor research", "customer research"],
    "product analytics": ["product metrics", "user behavior tracking", "feature adoption"],
    
    # Art & Creative specializations
    "visual trend": ["design trends 2024", "visual design trends", "art movement trends"],
    "color palette": ["color theory design", "color psychology", "trending color palettes"],
    "art movement": ["contemporary art movements", "abstract art trends", "modern art styles"],
    "creative direction": ["creative strategy", "visual storytelling", "brand aesthetics"],
    
    # Customer Experience specializations
    "customer support": ["customer service best practices", "support ticket management", "customer satisfaction"],
    "retention strategies": ["customer retention tactics", "churn prevention", "loyalty programs"],
    "feedback analysis": ["customer feedback systems", "sentiment analysis", "review management"],
    "user experience": ["UX design principles", "customer journey mapping", "usability testing"],
    
    # Operations specializations
    "inventory optimization": ["inventory management strategies", "stock optimization", "demand forecasting"],
    "supply chain": ["supply chain optimization", "logistics management", "vendor relationships"],
    "fulfillment": ["order fulfillment process", "shipping optimization", "warehouse management"],
    "automation": ["business process automation", "workflow automation", "RPA implementation"]
}

class VividMasOntologySeeder:
    def __init__(self):
        self.neo4j_driver = GraphDatabase.driver(
            NEO4J_URI, 
            auth=(NEO4J_USER, NEO4J_PASSWORD)
        )
        self.agents = []
        self.processed_queries = set()
        
    def close(self):
        self.neo4j_driver.close()
        
    def extract_agent_info(self, content: str, file_path: str) -> Dict:
        """Extract comprehensive agent information from markdown"""
        info = {
            "name": "",
            "role": "",
            "type": "task" if "task" in file_path.lower() else "director",
            "capabilities": [],
            "specializations": [],
            "core_functions": [],
            "responsibilities": [],
            "reports_to": "",
            "file_path": file_path
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
            
        # Extract reports to
        reports_match = re.search(r'Reports to:\s*([^\n]+)', content)
        if reports_match:
            info["reports_to"] = reports_match.group(1).strip()
            
        # Extract specializations
        spec_section = re.search(r'## Specializations?:(.*?)(?=##|\Z)', content, re.DOTALL)
        if spec_section:
            specs = re.findall(r'- (.+)', spec_section.group(1))
            info["specializations"] = [s.strip() for s in specs]
            
        # Extract core functions
        func_section = re.search(r'## Core Functions?:(.*?)(?=##|\Z)', content, re.DOTALL)
        if func_section:
            funcs = re.findall(r'- ([^\n(]+)', func_section.group(1))
            info["core_functions"] = [f.strip() for f in funcs]
            
        # Extract responsibilities
        resp_section = re.search(r'## Core Responsibilities(.*?)(?=##|\Z)', content, re.DOTALL)
        if resp_section:
            resps = re.findall(r'- (.+)', resp_section.group(1))
            info["responsibilities"] = [r.strip() for r in resps]
            
        return info
        
    def load_agents(self):
        """Load all agent definitions"""
        print("Loading agent definitions...")
        
        for agent_file in AGENTS_PATH.rglob("*agent*.md"):
            if "matrix" not in agent_file.name.lower():
                try:
                    content = agent_file.read_text()
                    agent_info = self.extract_agent_info(content, str(agent_file))
                    if agent_info["name"]:
                        self.agents.append(agent_info)
                        print(f"  Loaded: {agent_info['name']} ({agent_info['type']})")
                except Exception as e:
                    print(f"  Error loading {agent_file}: {e}")
                    
        print(f"\nLoaded {len(self.agents)} agents")
        print(f"  Directors: {sum(1 for a in self.agents if a['type'] == 'director')}")
        print(f"  Task Agents: {sum(1 for a in self.agents if a['type'] == 'task')}")
        
    async def search_knowledge(self, query: str) -> List[str]:
        """Search for knowledge using various sources"""
        concepts = []
        
        # Avoid duplicate searches
        if query in self.processed_queries:
            return []
        self.processed_queries.add(query)
        
        try:
            # Try Google search via SerpAPI or similar (placeholder)
            # In production, use actual search API
            search_terms = query.split()[:3]  # First 3 words
            concepts.extend(search_terms)
            
            # Extract key concepts from query
            important_words = [w for w in query.split() if len(w) > 4]
            concepts.extend(important_words[:5])
            
        except Exception as e:
            print(f"    Search error for '{query}': {e}")
            
        return list(set(concepts))
        
    async def seed_agent_knowledge(self, agent: Dict):
        """Seed knowledge for a specific agent based on specializations"""
        print(f"\nProcessing {agent['name']}...")
        print(f"  Type: {agent['type']}")
        print(f"  Specializations: {len(agent['specializations'])}")
        
        # Collect all relevant concepts
        all_concepts = set()
        
        # Process each specialization
        for spec in agent['specializations']:
            spec_lower = spec.lower()
            
            # Find matching queries for this specialization
            for key, queries in SPECIALIZATION_QUERIES.items():
                if key in spec_lower or any(word in spec_lower for word in key.split()):
                    print(f"  Searching for: {spec}")
                    for query in queries[:2]:  # Limit queries per specialization
                        concepts = await self.search_knowledge(query)
                        all_concepts.update(concepts)
                        
        # Add concepts from capabilities and functions
        for cap in agent['capabilities']:
            all_concepts.add(cap.lower())
            
        for func in agent['core_functions'][:5]:
            # Extract meaningful words from function names
            words = re.sub(r'([A-Z])', r' \1', func).lower().split()
            all_concepts.update([w for w in words if len(w) > 3])
            
        print(f"  Collected {len(all_concepts)} concepts")
        
        # Store in Neo4j
        with self.neo4j_driver.session() as session:
            # Create agent node
            session.run("""
                MERGE (a:Agent {name: $name})
                SET a.role = $role,
                    a.type = $type,
                    a.updated_at = datetime(),
                    a.capabilities = $capabilities,
                    a.specialization_count = $spec_count,
                    a.function_count = $func_count
            """, 
                name=agent['name'],
                role=agent['role'],
                type=agent['type'],
                capabilities=agent['capabilities'][:5],
                spec_count=len(agent['specializations']),
                func_count=len(agent['core_functions'])
            )
            
            # Create hierarchy relationship
            if agent['reports_to'] and agent['type'] == 'task':
                session.run("""
                    MATCH (subordinate:Agent {name: $subordinate})
                    MERGE (superior:Agent {name: $superior})
                    MERGE (subordinate)-[:REPORTS_TO]->(superior)
                """, 
                    subordinate=agent['name'],
                    superior=agent['reports_to']
                )
            
            # Create specialization nodes
            for spec in agent['specializations']:
                session.run("""
                    MERGE (s:Specialization {name: $spec})
                    SET s.created_at = coalesce(s.created_at, datetime())
                    MERGE (a:Agent {name: $agent})
                    MERGE (a)-[:SPECIALIZES_IN]->(s)
                """, spec=spec, agent=agent['name'])
                
            # Create concept nodes from collected knowledge
            for concept in list(all_concepts)[:30]:  # Top 30 concepts
                if len(concept) > 2:  # Filter very short concepts
                    session.run("""
                        MERGE (c:Concept {name: $concept})
                        SET c.discovered_at = coalesce(c.discovered_at, datetime())
                        MERGE (a:Agent {name: $agent})
                        MERGE (a)-[:KNOWS_ABOUT]->(c)
                    """, concept=concept, agent=agent['name'])
                    
            # Link related specializations and concepts
            for spec in agent['specializations'][:3]:
                spec_words = spec.lower().split()
                for concept in list(all_concepts)[:10]:
                    if any(word in concept for word in spec_words if len(word) > 3):
                        session.run("""
                            MATCH (s:Specialization {name: $spec})
                            MATCH (c:Concept {name: $concept})
                            MERGE (s)-[:RELATES_TO]->(c)
                        """, spec=spec, concept=concept)
                        
    async def create_domain_structure(self):
        """Create domain structure and relationships"""
        print("\nCreating domain structure...")
        
        with self.neo4j_driver.session() as session:
            # Define VividWalls business domains
            domains = {
                "Marketing & Sales": ["marketing", "sales", "advertising", "brand", "customer acquisition"],
                "Product & Creative": ["product", "art", "design", "creative", "visual"],
                "Customer Experience": ["customer", "support", "experience", "retention", "satisfaction"],
                "Operations & Fulfillment": ["operations", "supply chain", "inventory", "fulfillment", "logistics"],
                "Analytics & Intelligence": ["analytics", "data", "intelligence", "insights", "metrics"],
                "Finance & Strategy": ["finance", "budget", "revenue", "pricing", "strategy"],
                "Technology & Automation": ["technology", "automation", "integration", "development", "systems"]
            }
            
            for domain, keywords in domains.items():
                # Create domain node
                session.run("""
                    MERGE (d:BusinessDomain {name: $domain})
                    SET d.keywords = $keywords,
                        d.created_at = datetime()
                """, domain=domain, keywords=keywords)
                
                # Link agents to domains based on their specializations
                for keyword in keywords:
                    session.run("""
                        MATCH (a:Agent)
                        WHERE ANY(spec IN a.specialization_count 
                              WHERE toLower(spec) CONTAINS $keyword)
                           OR toLower(a.role) CONTAINS $keyword
                        MATCH (d:BusinessDomain {name: $domain})
                        MERGE (a)-[:OPERATES_IN]->(d)
                    """, keyword=keyword, domain=domain)
                    
    async def seed_all(self):
        """Main seeding process"""
        print("\nVividMAS Ontology Seeding")
        print("=" * 50)
        
        # Test connections
        try:
            with self.neo4j_driver.session() as session:
                result = session.run("RETURN 1 as test")
                print("✓ Neo4j connection successful")
        except Exception as e:
            print(f"✗ Neo4j connection failed: {e}")
            return
            
        # Load agents
        self.load_agents()
        
        # Clear existing data
        print("\nClearing existing ontology...")
        with self.neo4j_driver.session() as session:
            session.run("MATCH ()-[r]-() DELETE r")
            session.run("MATCH (n) DELETE n")
            
        # Create domain structure
        await self.create_domain_structure()
        
        # Process each agent
        for agent in self.agents[:10]:  # Process first 10 agents
            await self.seed_agent_knowledge(agent)
            
        # Create collaboration network
        print("\nCreating collaboration network...")
        with self.neo4j_driver.session() as session:
            # Link agents who share specializations
            session.run("""
                MATCH (a1:Agent)-[:SPECIALIZES_IN]->(s:Specialization)<-[:SPECIALIZES_IN]-(a2:Agent)
                WHERE a1.name < a2.name
                MERGE (a1)-[r:CAN_COLLABORATE_WITH]->(a2)
                SET r.shared_specializations = 
                    size([(a1)-[:SPECIALIZES_IN]->(spec)<-[:SPECIALIZES_IN]-(a2) | spec.name])
            """)
            
        # Show summary
        print("\n" + "=" * 50)
        print("Ontology Summary")
        print("=" * 50)
        
        with self.neo4j_driver.session() as session:
            # Count nodes
            result = session.run("""
                MATCH (n)
                RETURN labels(n)[0] as type, count(n) as count
                ORDER BY count DESC
            """)
            
            for record in result:
                print(f"{record['type']:20} {record['count']:>10}")
                
            # Show agent hierarchy
            print("\nAgent Hierarchy:")
            result = session.run("""
                MATCH (director:Agent {type: 'director'})
                OPTIONAL MATCH (task:Agent)-[:REPORTS_TO]->(director)
                RETURN director.name as director, 
                       collect(task.name) as task_agents
                ORDER BY director
            """)
            
            for record in result:
                if record['task_agents']:
                    print(f"\n{record['director']}:")
                    for task in record['task_agents']:
                        print(f"  └─ {task}")
                        
            # Show top concepts
            print("\nTop Concepts by Agent Connections:")
            result = session.run("""
                MATCH (c:Concept)<-[:KNOWS_ABOUT]-(a:Agent)
                RETURN c.name as concept, count(a) as agent_count
                ORDER BY agent_count DESC
                LIMIT 10
            """)
            
            for record in result:
                print(f"  {record['concept']:30} ({record['agent_count']} agents)")
                
        print("\n✓ VividMAS ontology seeding completed!")


async def main():
    seeder = VividMasOntologySeeder()
    try:
        await seeder.seed_all()
    finally:
        seeder.close()


if __name__ == "__main__":
    asyncio.run(main())