#!/usr/bin/env python3
"""
Build ontologies for all VividWalls agents by crawling domain authorities
and populating Neo4j knowledge graph
"""

import asyncio
import json
from datetime import datetime
from typing import List, Dict, Any
from crawl4ai import AsyncWebCrawler
from neo4j import GraphDatabase
import time

# Configuration
NEO4J_URI = "bolt://157.230.13.13:7687"
NEO4J_USER = "neo4j"
NEO4J_PASSWORD = "VPofL3g9gTaquiXxA6ntvQDyK"

# Agent definitions with their domain authorities
AGENTS_CONFIG = {
    "directors": [
        {
            "id": "00000000-0000-0000-0001-000000000001",
            "name": "Emily Chen",
            "role": "Customer Experience Director",
            "domains": [
                {"url": "https://www.zendesk.com/blog/", "name": "Zendesk", "topics": ["customer service", "support"]},
                {"url": "https://www.helpscout.com/blog/", "name": "HelpScout", "topics": ["customer support", "satisfaction"]},
                {"url": "https://customerthink.com/", "name": "CustomerThink", "topics": ["customer experience", "CX strategy"]}
            ]
        },
        {
            "id": "00000000-0000-0000-0002-000000000002",
            "name": "Michael Rodriguez",
            "role": "Finance Director",
            "domains": [
                {"url": "https://www.cfo.com/", "name": "CFO.com", "topics": ["financial management", "CFO insights"]},
                {"url": "https://www.financialexecutives.org/", "name": "Financial Executives", "topics": ["finance leadership"]},
                {"url": "https://www.accountingtoday.com/", "name": "Accounting Today", "topics": ["accounting", "finance"]}
            ]
        },
        {
            "id": "00000000-0000-0000-0003-000000000003",
            "name": "Sarah Johnson",
            "role": "Marketing Director",
            "domains": [
                {"url": "https://www.marketingevolution.com/", "name": "Marketing Evolution", "topics": ["marketing strategy"]},
                {"url": "https://contentmarketinginstitute.com/", "name": "Content Marketing Institute", "topics": ["content marketing"]},
                {"url": "https://www.adweek.com/", "name": "AdWeek", "topics": ["advertising", "marketing trends"]}
            ]
        },
        {
            "id": "00000000-0000-0000-0004-000000000004",
            "name": "David Kim",
            "role": "Operations Director",
            "domains": [
                {"url": "https://www.supplychainbrain.com/", "name": "Supply Chain Brain", "topics": ["supply chain", "logistics"]},
                {"url": "https://www.dcvelocity.com/", "name": "DC Velocity", "topics": ["distribution", "fulfillment"]},
                {"url": "https://www.logisticsmgmt.com/", "name": "Logistics Management", "topics": ["logistics", "operations"]}
            ]
        },
        {
            "id": "00000000-0000-0000-0005-000000000005",
            "name": "Sophia Williams",
            "role": "Product Director",
            "domains": [
                {"url": "https://www.producthunt.com/", "name": "Product Hunt", "topics": ["product discovery", "trends"]},
                {"url": "https://www.artsy.net/", "name": "Artsy", "topics": ["art market", "art curation"]},
                {"url": "https://www.artbusiness.com/", "name": "Art Business", "topics": ["art commerce", "valuation"]}
            ]
        },
        {
            "id": "00000000-0000-0000-0006-000000000006",
            "name": "Alex Thompson",
            "role": "Technology Director",
            "domains": [
                {"url": "https://www.infoworld.com/", "name": "InfoWorld", "topics": ["technology", "IT management"]},
                {"url": "https://devops.com/", "name": "DevOps.com", "topics": ["DevOps", "automation"]},
                {"url": "https://thenewstack.io/", "name": "The New Stack", "topics": ["cloud", "infrastructure"]}
            ]
        },
        {
            "id": "00000000-0000-0000-0007-000000000007",
            "name": "Jessica Davis",
            "role": "Analytics Director",
            "domains": [
                {"url": "https://www.kdnuggets.com/", "name": "KDnuggets", "topics": ["data science", "analytics"]},
                {"url": "https://towardsdatascience.com/", "name": "Towards Data Science", "topics": ["data analysis", "ML"]},
                {"url": "https://www.dataversity.net/", "name": "DATAVERSITY", "topics": ["data management", "BI"]}
            ]
        }
    ]
}

class OntologyBuilder:
    def __init__(self):
        self.crawler = None
        self.neo4j_driver = None
        
    async def initialize(self):
        """Initialize crawler and database connections"""
        print("Initializing ontology builder...")
        self.crawler = AsyncWebCrawler()
        
        try:
            self.neo4j_driver = GraphDatabase.driver(
                NEO4J_URI, 
                auth=(NEO4J_USER, NEO4J_PASSWORD)
            )
            with self.neo4j_driver.session() as session:
                session.run("RETURN 1")
            print("✓ Connected to Neo4j")
        except Exception as e:
            print(f"⚠️  Neo4j connection failed: {e}")
            self.neo4j_driver = None
    
    def create_agent_in_neo4j(self, agent: Dict[str, Any]):
        """Create or update agent node in Neo4j"""
        if not self.neo4j_driver:
            return
        
        with self.neo4j_driver.session() as session:
            session.run("""
                MERGE (a:Agent {id: $id})
                SET a.name = $name,
                    a.role = $role,
                    a.type = 'Director',
                    a.created_at = datetime()
            """, 
            id=agent["id"],
            name=agent["name"],
            role=agent["role"])
            
            print(f"✓ Created/updated agent: {agent['name']}")
    
    async def crawl_domain(self, agent_id: str, domain: Dict[str, Any]) -> Dict[str, Any]:
        """Crawl a single domain for an agent"""
        print(f"  Crawling {domain['name']} ({domain['url']})...")
        
        try:
            result = await self.crawler.arun(
                url=domain["url"],
                bypass_cache=True
            )
            
            if result.success:
                # Extract basic info
                knowledge = {
                    "agent_id": agent_id,
                    "title": result.metadata.get("title", domain["name"]),
                    "url": domain["url"],
                    "source": domain["name"],
                    "topics": domain["topics"],
                    "content_length": len(result.markdown),
                    "links_found": len(result.links),
                    "crawled_at": datetime.now().isoformat()
                }
                
                # Store in Neo4j
                self.store_knowledge_in_neo4j(knowledge)
                
                print(f"    ✓ Crawled {knowledge['content_length']} characters")
                return knowledge
            else:
                print(f"    ✗ Failed: {result.error_message}")
                return None
                
        except Exception as e:
            print(f"    ✗ Error: {e}")
            return None
    
    def store_knowledge_in_neo4j(self, knowledge: Dict[str, Any]):
        """Store crawled knowledge in Neo4j"""
        if not self.neo4j_driver:
            return
        
        try:
            with self.neo4j_driver.session() as session:
                # Create knowledge node
                session.run("""
                    MATCH (a:Agent {id: $agent_id})
                    CREATE (k:Knowledge {
                        title: $title,
                        url: $url,
                        source: $source,
                        content_length: $content_length,
                        links_found: $links_found,
                        crawled_at: datetime($crawled_at)
                    })
                    CREATE (a)-[:HAS_KNOWLEDGE]->(k)
                    WITH k
                    UNWIND $topics as topic
                    MERGE (t:Topic {name: topic})
                    CREATE (k)-[:COVERS]->(t)
                """, 
                agent_id=knowledge["agent_id"],
                title=knowledge["title"],
                url=knowledge["url"],
                source=knowledge["source"],
                content_length=knowledge["content_length"],
                links_found=knowledge["links_found"],
                crawled_at=knowledge["crawled_at"],
                topics=knowledge["topics"])
                
        except Exception as e:
            print(f"    Error storing in Neo4j: {e}")
    
    async def build_agent_ontology(self, agent: Dict[str, Any]):
        """Build ontology for a single agent"""
        print(f"\nBuilding ontology for {agent['name']} ({agent['role']})...")
        
        # Create agent in Neo4j
        self.create_agent_in_neo4j(agent)
        
        # Crawl each domain
        for domain in agent["domains"]:
            await self.crawl_domain(agent["id"], domain)
            # Be respectful with rate limiting
            await asyncio.sleep(2)
    
    async def build_all_ontologies(self):
        """Build ontologies for all agents"""
        await self.initialize()
        
        # Process director agents
        print("\n=== Building Director Agent Ontologies ===")
        for agent in AGENTS_CONFIG["directors"]:
            await self.build_agent_ontology(agent)
        
        # Summary
        self.print_summary()
        
        # Cleanup
        if self.crawler:
            await self.crawler.close()
        if self.neo4j_driver:
            self.neo4j_driver.close()
    
    def print_summary(self):
        """Print summary of ontology building"""
        if not self.neo4j_driver:
            return
        
        print("\n=== Ontology Building Summary ===")
        
        with self.neo4j_driver.session() as session:
            # Count agents
            result = session.run("MATCH (a:Agent) RETURN count(a) as count")
            agent_count = result.single()["count"]
            
            # Count knowledge items
            result = session.run("MATCH (k:Knowledge) RETURN count(k) as count")
            knowledge_count = result.single()["count"]
            
            # Count topics
            result = session.run("MATCH (t:Topic) RETURN count(t) as count")
            topic_count = result.single()["count"]
            
            print(f"✓ Agents created: {agent_count}")
            print(f"✓ Knowledge items: {knowledge_count}")
            print(f"✓ Topics identified: {topic_count}")
            
            # Show knowledge per agent
            print("\nKnowledge distribution:")
            result = session.run("""
                MATCH (a:Agent)-[:HAS_KNOWLEDGE]->(k:Knowledge)
                RETURN a.name as agent, a.role as role, count(k) as knowledge_count
                ORDER BY a.name
            """)
            
            for record in result:
                print(f"  - {record['agent']} ({record['role']}): {record['knowledge_count']} items")

async def main():
    """Main execution"""
    print("Starting VividWalls Agent Ontology Building...")
    print("=" * 60)
    
    builder = OntologyBuilder()
    await builder.build_all_ontologies()
    
    print("\n✓ Ontology building complete!")

if __name__ == "__main__":
    asyncio.run(main())