#!/usr/bin/env python3
"""
Agent-Based Ontology Seeding Script for VividMAS
Extracts agent roles, skills, and domain authorities from agent definitions
and seeds Neo4j knowledge graph with relevant domain knowledge
"""

import os
import sys
import asyncio
import json
import re
from datetime import datetime
from typing import Dict, List, Optional, Tuple
from pathlib import Path
import requests
from neo4j import GraphDatabase
from dotenv import load_dotenv
from collections import defaultdict

# Load environment variables
load_dotenv(Path(__file__).parent / "mcp-crawl4ai-rag/.env")

# Configuration
CRAWL4AI_URL = "http://157.230.13.13:11235"
NEO4J_URI = os.getenv("NEO4J_URI", "bolt://157.230.13.13:7687")
NEO4J_USER = os.getenv("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.getenv("NEO4J_PASSWORD")

# Agent definitions path
AGENTS_PATH = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/prompts")

# Domain-specific search sources
DOMAIN_SOURCES = {
    "marketing": [
        "https://www.reddit.com/r/marketing.json?limit=20",
        "https://www.reddit.com/r/digital_marketing.json?limit=20",
        "https://contentmarketinginstitute.com/",
        "https://blog.hubspot.com/marketing"
    ],
    "analytics": [
        "https://www.reddit.com/r/datascience.json?limit=20",
        "https://www.reddit.com/r/businessintelligence.json?limit=20",
        "https://towardsdatascience.com/",
        "https://www.analyticsvidhya.com/"
    ],
    "customer_experience": [
        "https://www.reddit.com/r/CustomerSuccess.json?limit=20",
        "https://www.reddit.com/r/userexperience.json?limit=20",
        "https://www.zendesk.com/blog/",
        "https://www.helpscout.com/blog/"
    ],
    "product": [
        "https://www.reddit.com/r/ProductManagement.json?limit=20",
        "https://www.producthunt.com/",
        "https://www.productplan.com/blog/"
    ],
    "finance": [
        "https://www.reddit.com/r/finance.json?limit=20",
        "https://www.reddit.com/r/financialplanning.json?limit=20"
    ],
    "operations": [
        "https://www.reddit.com/r/supplychain.json?limit=20",
        "https://www.reddit.com/r/operations.json?limit=20"
    ],
    "technology": [
        "https://www.reddit.com/r/programming.json?limit=20",
        "https://www.reddit.com/r/devops.json?limit=20",
        "https://dev.to/",
        "https://hackernoon.com/"
    ],
    "art": [
        "https://www.reddit.com/r/Art.json?limit=20",
        "https://www.reddit.com/r/AbstractArt.json?limit=20",
        "https://www.reddit.com/r/ArtistLounge.json?limit=20"
    ],
    "ecommerce": [
        "https://www.reddit.com/r/ecommerce.json?limit=20",
        "https://www.shopify.com/blog"
    ],
    "social_media": [
        "https://www.reddit.com/r/socialmedia.json?limit=20",
        "https://www.reddit.com/r/Instagram.json?limit=20",
        "https://sproutsocial.com/insights/"
    ]
}

class AgentOntologySeeder:
    def __init__(self):
        self.neo4j_driver = GraphDatabase.driver(
            NEO4J_URI, 
            auth=(NEO4J_USER, NEO4J_PASSWORD)
        )
        self.agents = []
        
    def close(self):
        self.neo4j_driver.close()
        
    def extract_agent_info(self, content: str) -> Dict:
        """Extract agent information from markdown content"""
        info = {
            "name": "",
            "role": "",
            "capabilities": [],
            "specializations": [],
            "core_functions": [],
            "responsibilities": [],
            "kpis": [],
            "tools": [],
            "domains": []
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
            
        # Extract core functions
        func_section = re.search(r'## Core Functions?:(.*?)(?=##|\Z)', content, re.DOTALL)
        if func_section:
            funcs = re.findall(r'- (\w+)\(', func_section.group(1))
            info["core_functions"] = funcs
            
        # Extract responsibilities
        resp_section = re.search(r'## Core Responsibilities(.*?)(?=##|\Z)', content, re.DOTALL)
        if resp_section:
            resps = re.findall(r'- (.+)', resp_section.group(1))
            info["responsibilities"] = resps
            
        # Extract KPIs
        kpi_section = re.search(r'## Key Performance Indicators(.*?)(?=##|\Z)', content, re.DOTALL)
        if kpi_section:
            kpis = re.findall(r'- (.+)', kpi_section.group(1))
            info["kpis"] = kpis
            
        # Extract tools
        tools_section = re.search(r'## Available MCP Tools(.*?)(?=##|\Z)', content, re.DOTALL)
        if tools_section:
            tools = re.findall(r'- ([^:]+):', tools_section.group(1))
            info["tools"] = tools
            
        # Determine domains based on content
        info["domains"] = self.determine_domains(content, info)
        
        return info
        
    def determine_domains(self, content: str, info: Dict) -> List[str]:
        """Determine relevant domains based on agent content"""
        domains = []
        content_lower = content.lower()
        
        # Check for domain keywords
        domain_keywords = {
            "marketing": ["marketing", "advertising", "campaign", "brand", "acquisition"],
            "analytics": ["analytics", "data", "metrics", "analysis", "intelligence"],
            "customer_experience": ["customer", "experience", "satisfaction", "support"],
            "product": ["product", "feature", "roadmap", "development"],
            "finance": ["finance", "budget", "revenue", "cost", "pricing"],
            "operations": ["operations", "supply chain", "fulfillment", "inventory"],
            "technology": ["technology", "development", "automation", "integration"],
            "art": ["art", "design", "creative", "visual", "aesthetic"],
            "ecommerce": ["e-commerce", "ecommerce", "online", "shop", "store"],
            "social_media": ["social media", "instagram", "facebook", "pinterest"]
        }
        
        for domain, keywords in domain_keywords.items():
            if any(keyword in content_lower for keyword in keywords):
                domains.append(domain)
                
        # Also check specializations and responsibilities
        all_text = " ".join(info.get("specializations", []) + 
                          info.get("responsibilities", []) + 
                          [info.get("role", "")])
        all_text_lower = all_text.lower()
        
        for domain, keywords in domain_keywords.items():
            if domain not in domains and any(keyword in all_text_lower for keyword in keywords):
                domains.append(domain)
                
        return domains if domains else ["general"]
        
    def load_agents(self):
        """Load all agent definitions from markdown files"""
        print("Loading agent definitions...")
        
        for agent_file in AGENTS_PATH.rglob("*agent*.md"):
            if "matrix" not in agent_file.name.lower():  # Skip communication matrix
                try:
                    content = agent_file.read_text()
                    agent_info = self.extract_agent_info(content)
                    if agent_info["name"]:
                        agent_info["file_path"] = str(agent_file)
                        self.agents.append(agent_info)
                        print(f"  Loaded: {agent_info['name']}")
                except Exception as e:
                    print(f"  Error loading {agent_file}: {e}")
                    
        print(f"Loaded {len(self.agents)} agents")
        
    async def crawl_source(self, url: str, domains: List[str]) -> Optional[str]:
        """Crawl a source URL and return relevant content"""
        try:
            if ".json" in url:
                # Reddit API
                response = requests.get(url, headers={'User-Agent': 'VividMAS/1.0'}, timeout=10)
                if response.status_code == 200:
                    data = response.json()
                    return self._extract_reddit_content(data)
            else:
                # Web crawling
                crawl_request = {
                    "url": url,
                    "priority": 10,
                    "session_id": f"ontology_{domains[0]}",
                    "crawler_params": {
                        "headless": True,
                        "verbose": False,
                        "cache_mode": "bypass"
                    }
                }
                
                response = requests.post(
                    f"{CRAWL4AI_URL}/crawl",
                    json=crawl_request,
                    headers={"Content-Type": "application/json"},
                    timeout=30
                )
                
                if response.status_code == 200:
                    result = response.json()
                    if result.get("success"):
                        return result.get("markdown", "")
                        
        except Exception as e:
            print(f"    Error crawling {url}: {str(e)}")
            
        return None
        
    def _extract_reddit_content(self, data: Dict) -> str:
        """Extract content from Reddit JSON"""
        content_parts = []
        
        if "data" in data and "children" in data["data"]:
            for post in data["data"]["children"]:
                post_data = post.get("data", {})
                title = post_data.get("title", "")
                selftext = post_data.get("selftext", "")
                
                if title:
                    content_parts.append(title)
                    if selftext:
                        content_parts.append(selftext[:1000])
                    
        return " ".join(content_parts)
        
    def extract_domain_concepts(self, content: str, agent_info: Dict) -> List[Tuple[str, float]]:
        """Extract concepts relevant to agent's specializations and functions"""
        concepts = []
        content_lower = content.lower()
        
        # Extract based on specializations
        for spec in agent_info.get("specializations", []):
            # Create search terms from specialization
            terms = re.findall(r'\b\w+\b', spec.lower())
            important_terms = [t for t in terms if len(t) > 4]
            
            # Look for these terms in content
            for term in important_terms:
                count = content_lower.count(term)
                if count > 0:
                    concepts.append((term, count))
                    
            # Also look for the full specialization
            if spec.lower() in content_lower:
                concepts.append((spec.lower(), 2.0))
                
        # Extract based on capabilities
        for cap in agent_info.get("capabilities", []):
            cap_lower = cap.lower()
            if cap_lower in content_lower:
                concepts.append((cap_lower, 1.5))
                
        # Extract based on core functions
        for func in agent_info.get("core_functions", []):
            # Convert camelCase to words
            words = re.sub(r'([A-Z])', r' \1', func).lower().split()
            for word in words:
                if len(word) > 4 and word in content_lower:
                    concepts.append((word, 1.0))
                    
        # Aggregate and sort by relevance
        concept_scores = defaultdict(float)
        for concept, score in concepts:
            concept_scores[concept] += score
            
        # Return top concepts sorted by score
        sorted_concepts = sorted(concept_scores.items(), key=lambda x: x[1], reverse=True)
        return sorted_concepts[:30]
        
    async def seed_agent_ontology(self, agent_info: Dict):
        """Seed ontology for a specific agent"""
        print(f"\nSeeding ontology for {agent_info['name']}...")
        print(f"  Role: {agent_info['role']}")
        print(f"  Domains: {', '.join(agent_info['domains'])}")
        
        # Collect content from relevant domain sources
        all_content = ""
        sources_crawled = 0
        
        for domain in agent_info['domains']:
            if domain in DOMAIN_SOURCES:
                print(f"  Crawling {domain} sources...")
                for source in DOMAIN_SOURCES[domain][:2]:  # Limit to 2 sources per domain
                    content = await self.crawl_source(source, agent_info['domains'])
                    if content:
                        all_content += " " + content
                        sources_crawled += 1
                        
        print(f"  Crawled {sources_crawled} sources")
        
        # Extract domain-specific concepts
        concepts = self.extract_domain_concepts(all_content, agent_info) if all_content else []
        print(f"  Extracted {len(concepts)} relevant concepts")
        
        # Store in Neo4j
        with self.neo4j_driver.session() as session:
            # Create agent node
            session.run("""
                MERGE (a:Agent {name: $name})
                SET a.role = $role,
                    a.updated_at = datetime(),
                    a.domains = $domains,
                    a.capabilities = $capabilities,
                    a.specializations = $specializations,
                    a.core_functions = $core_functions,
                    a.tools = $tools
            """, 
                name=agent_info["name"],
                role=agent_info["role"],
                domains=agent_info["domains"],
                capabilities=agent_info["capabilities"],
                specializations=agent_info["specializations"][:10],
                core_functions=agent_info["core_functions"][:10],
                tools=agent_info["tools"][:5]
            )
            
            # Create domain nodes
            for domain in agent_info["domains"]:
                session.run("""
                    MERGE (d:Domain {name: $domain})
                    MERGE (a:Agent {name: $agent_name})
                    MERGE (a)-[:OPERATES_IN]->(d)
                """,
                    domain=domain,
                    agent_name=agent_info["name"]
                )
                
            # Create specialization nodes
            for spec in agent_info["specializations"][:10]:
                session.run("""
                    MERGE (s:Specialization {name: $spec})
                    MERGE (a:Agent {name: $agent_name})
                    MERGE (a)-[:SPECIALIZES_IN]->(s)
                """,
                    spec=spec,
                    agent_name=agent_info["name"]
                )
                
            # Create concept nodes from crawled content
            for concept, score in concepts[:20]:
                session.run("""
                    MERGE (c:Concept {name: $concept})
                    SET c.discovered_at = coalesce(c.discovered_at, datetime())
                    MERGE (a:Agent {name: $agent_name})
                    MERGE (a)-[r:KNOWS_ABOUT]->(c)
                    SET r.relevance_score = $score
                """,
                    concept=concept,
                    agent_name=agent_info["name"],
                    score=score
                )
                
            # Link specializations to concepts
            for spec in agent_info["specializations"][:5]:
                spec_terms = re.findall(r'\b\w+\b', spec.lower())
                for concept, _ in concepts[:10]:
                    if any(term in concept for term in spec_terms if len(term) > 4):
                        session.run("""
                            MATCH (s:Specialization {name: $spec})
                            MATCH (c:Concept {name: $concept})
                            MERGE (s)-[:RELATED_TO]->(c)
                        """,
                            spec=spec,
                            concept=concept
                        )
                        
        print(f"  ✓ Created agent node with {len(concepts[:20])} concept relationships")
        
    async def seed_all_agents(self):
        """Seed ontologies for all agents"""
        print("\nStarting agent-based ontology seeding...")
        print(f"Neo4j: {NEO4J_URI}")
        print(f"Crawl4AI: {CRAWL4AI_URL}")
        
        # Test connections
        try:
            with self.neo4j_driver.session() as session:
                result = session.run("RETURN 1 as test")
                print("✓ Neo4j connection successful")
                
            response = requests.get(f"{CRAWL4AI_URL}/health", timeout=5)
            if response.status_code == 200:
                print("✓ Crawl4AI connection successful")
        except Exception as e:
            print(f"✗ Connection error: {str(e)}")
            return
            
        # Load agent definitions
        self.load_agents()
        
        # Clear existing data
        print("\nClearing existing ontology data...")
        with self.neo4j_driver.session() as session:
            # Delete all relationships first
            session.run("MATCH ()-[r]-() DELETE r")
            # Then delete all nodes
            session.run("MATCH (n) DELETE n")
            
        # Seed each agent
        for agent_info in self.agents[:5]:  # Limit to first 5 for testing
            await self.seed_agent_ontology(agent_info)
            
        # Create inter-agent relationships based on shared domains
        print("\nCreating inter-agent relationships...")
        with self.neo4j_driver.session() as session:
            session.run("""
                MATCH (a1:Agent)-[:OPERATES_IN]->(d:Domain)<-[:OPERATES_IN]-(a2:Agent)
                WHERE a1.name < a2.name
                MERGE (a1)-[r:COLLABORATES_WITH]->(a2)
                SET r.shared_domains = 
                    [d IN [(a1)-[:OPERATES_IN]->(domain)<-[:OPERATES_IN]-(a2) | domain.name] | d]
            """)
            
        print("\n✓ Agent-based ontology seeding completed!")
        
        # Show summary
        with self.neo4j_driver.session() as session:
            # Agent summary
            result = session.run("""
                MATCH (a:Agent)
                RETURN count(a) as count
            """)
            agent_count = result.single()["count"]
            
            # Show sample agents with their knowledge
            print(f"\nKnowledge Graph Summary:")
            print(f"  Total Agents: {agent_count}")
            
            result = session.run("""
                MATCH (a:Agent)
                OPTIONAL MATCH (a)-[:KNOWS_ABOUT]->(c:Concept)
                OPTIONAL MATCH (a)-[:SPECIALIZES_IN]->(s:Specialization)
                OPTIONAL MATCH (a)-[:OPERATES_IN]->(d:Domain)
                RETURN a.name as agent,
                       a.role as role,
                       collect(DISTINCT d.name) as domains,
                       collect(DISTINCT s.name)[..3] as specializations,
                       collect(DISTINCT c.name)[..5] as concepts
                ORDER BY a.name
                LIMIT 5
            """)
            
            print("\nAgent Knowledge Profiles:")
            for record in result:
                print(f"\n{record['agent']}")
                print(f"  Role: {record['role']}")
                print(f"  Domains: {', '.join(record['domains'])}")
                print(f"  Specializations: {', '.join(record['specializations'])}")
                print(f"  Key Concepts: {', '.join(record['concepts'])}")


async def main():
    seeder = AgentOntologySeeder()
    try:
        await seeder.seed_all_agents()
    finally:
        seeder.close()


if __name__ == "__main__":
    asyncio.run(main())