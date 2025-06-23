#!/usr/bin/env python3
"""
Build complete ontologies for all VividWalls agents (Directors + Task-specific)
by crawling domain authorities and populating Neo4j knowledge graph
"""

import asyncio
import json
from datetime import datetime
from typing import List, Dict, Any
from crawl4ai import AsyncWebCrawler
from neo4j import GraphDatabase
import time

# Import task agents configuration
from task_agents_config import TASK_AGENTS_CONFIG

# Configuration
NEO4J_URI = "bolt://157.230.13.13:7687"
NEO4J_USER = "neo4j"
NEO4J_PASSWORD = "VPofL3g9gTaquiXxA6ntvQDyK"

# Director agent definitions with their domain authorities
DIRECTORS_CONFIG = {
    "directors": [
        {
            "id": "167bbc92-05c0-4285-91fa-55d8f726011e",
            "name": "Emily Chen",
            "role": "Customer Experience Director",
            "domains": [
                {"url": "https://www.zendesk.com/blog/", "name": "Zendesk", "topics": ["customer service", "support"]},
                {"url": "https://www.helpscout.com/blog/", "name": "HelpScout", "topics": ["customer support", "satisfaction"]},
                {"url": "https://customerthink.com/", "name": "CustomerThink", "topics": ["customer experience", "CX strategy"]}
            ]
        },
        {
            "id": "db124b5f-cdc5-44d5-b74a-aea83081df64",
            "name": "Michael Rodriguez",
            "role": "Finance Director",
            "domains": [
                {"url": "https://www.cfo.com/", "name": "CFO.com", "topics": ["financial management", "CFO insights"]},
                {"url": "https://www.financialexecutives.org/", "name": "Financial Executives", "topics": ["finance leadership"]},
                {"url": "https://www.accountingtoday.com/", "name": "Accounting Today", "topics": ["accounting", "finance"]}
            ]
        },
        {
            "id": "56f395dc-48ee-421e-996f-53f5f35fa470",
            "name": "Sarah Johnson",
            "role": "Marketing Director",
            "domains": [
                {"url": "https://www.marketingevolution.com/", "name": "Marketing Evolution", "topics": ["marketing strategy"]},
                {"url": "https://contentmarketinginstitute.com/", "name": "Content Marketing Institute", "topics": ["content marketing"]},
                {"url": "https://www.adweek.com/", "name": "AdWeek", "topics": ["advertising", "marketing trends"]}
            ]
        },
        {
            "id": "4f2bdcc2-4e53-41c7-88f0-c4456bb4ef33",
            "name": "David Kim",
            "role": "Operations Director",
            "domains": [
                {"url": "https://www.supplychainbrain.com/", "name": "Supply Chain Brain", "topics": ["supply chain", "logistics"]},
                {"url": "https://www.dcvelocity.com/", "name": "DC Velocity", "topics": ["distribution", "fulfillment"]},
                {"url": "https://www.logisticsmgmt.com/", "name": "Logistics Management", "topics": ["logistics", "operations"]}
            ]
        },
        {
            "id": "05188674-63af-476a-b05a-ef374b64979f",
            "name": "Sophia Williams",
            "role": "Product Director",
            "domains": [
                {"url": "https://www.producthunt.com/", "name": "Product Hunt", "topics": ["product discovery", "trends"]},
                {"url": "https://www.artsy.net/", "name": "Artsy", "topics": ["art market", "art curation"]},
                {"url": "https://www.artbusiness.com/", "name": "Art Business", "topics": ["art commerce", "valuation"]}
            ]
        },
        {
            "id": "7de0448a-70ae-4e25-864a-04f71bf84c81",
            "name": "Alex Thompson",
            "role": "Technology Director",
            "domains": [
                {"url": "https://www.infoworld.com/", "name": "InfoWorld", "topics": ["technology", "IT management"]},
                {"url": "https://devops.com/", "name": "DevOps.com", "topics": ["DevOps", "automation"]},
                {"url": "https://thenewstack.io/", "name": "The New Stack", "topics": ["cloud", "infrastructure"]}
            ]
        },
        {
            "id": "9adc64aa-b2e1-492b-91b6-8290a6eff2e9",
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

class CompleteOntologyBuilder:
    def __init__(self):
        self.crawler = None
        self.neo4j_driver = None
        self.crawled_urls = set()  # Track crawled URLs to avoid duplicates
        
    async def initialize(self):
        """Initialize crawler and database connections"""
        print("Initializing complete ontology builder...")
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
    
    def create_agent_in_neo4j(self, agent: Dict[str, Any], agent_type: str):
        """Create or update agent node in Neo4j"""
        if not self.neo4j_driver:
            return
        
        with self.neo4j_driver.session() as session:
            # Create agent node
            session.run("""
                MERGE (a:Agent {id: $id})
                SET a.name = $name,
                    a.role = $role,
                    a.type = $type,
                    a.created_at = datetime()
            """, 
            id=agent["id"],
            name=agent.get("name", agent["role"]),
            role=agent["role"],
            type=agent_type)
            
            # If it's a task agent, create REPORTS_TO relationship
            if agent_type == "TaskAgent" and "reports_to" in agent:
                session.run("""
                    MATCH (task:Agent {id: $task_id})
                    MATCH (director:Agent {id: $director_id})
                    MERGE (task)-[:REPORTS_TO]->(director)
                """,
                task_id=agent["id"],
                director_id=agent["reports_to"])
            
            print(f"✓ Created/updated {agent_type}: {agent.get('name', agent['role'])}")
    
    async def crawl_domain(self, agent_id: str, domain: Dict[str, Any]) -> Dict[str, Any]:
        """Crawl a single domain for an agent"""
        # Skip if already crawled
        if domain["url"] in self.crawled_urls:
            print(f"  ⏭️  Already crawled {domain['name']} ({domain['url']})")
            return None
            
        print(f"  Crawling {domain['name']} ({domain['url']})...")
        self.crawled_urls.add(domain["url"])
        
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
    
    async def build_agent_ontology(self, agent: Dict[str, Any], agent_type: str):
        """Build ontology for a single agent"""
        print(f"\nBuilding ontology for {agent.get('name', agent['role'])} ({agent['role']})...")
        
        # Create agent in Neo4j
        self.create_agent_in_neo4j(agent, agent_type)
        
        # Crawl each domain
        if "domains" in agent:
            for domain in agent["domains"]:
                await self.crawl_domain(agent["id"], domain)
                # Be respectful with rate limiting
                await asyncio.sleep(2)
    
    async def build_all_ontologies(self):
        """Build ontologies for all agents"""
        await self.initialize()
        
        # Process director agents
        print("\n=== Building Director Agent Ontologies ===")
        for agent in DIRECTORS_CONFIG["directors"]:
            await self.build_agent_ontology(agent, "Director")
        
        # Process task agents
        print("\n=== Building Task-Specific Agent Ontologies ===")
        for agent in TASK_AGENTS_CONFIG["task_agents"]:
            await self.build_agent_ontology(agent, "TaskAgent")
        
        # Create additional relationships and specializations
        self.create_agent_specializations()
        
        # Summary
        self.print_summary()
        
        # Cleanup
        if self.crawler:
            await self.crawler.close()
        if self.neo4j_driver:
            self.neo4j_driver.close()
    
    def create_agent_specializations(self):
        """Create specialization nodes and relationships based on agent roles"""
        if not self.neo4j_driver:
            return
        
        print("\n=== Creating Agent Specializations ===")
        
        specializations = {
            "Marketing": ["audience analysis", "campaign optimization", "content creation", "brand strategy"],
            "Analytics": ["data analysis", "predictive modeling", "KPI tracking", "business intelligence"],
            "Product": ["product management", "art curation", "catalog optimization", "trend analysis"],
            "Customer": ["customer service", "sentiment analysis", "retention", "satisfaction"],
            "Operations": ["supply chain", "inventory management", "fulfillment", "logistics"],
            "Technology": ["automation", "system integration", "performance", "infrastructure"],
            "Finance": ["financial planning", "budget management", "revenue analysis", "cost optimization"]
        }
        
        with self.neo4j_driver.session() as session:
            for domain, specs in specializations.items():
                # Create domain node
                session.run("""
                    MERGE (d:BusinessDomain {name: $domain})
                """, domain=domain)
                
                # Create specialization nodes and connect to domain
                for spec in specs:
                    session.run("""
                        MERGE (s:Specialization {name: $spec})
                        MERGE (d:BusinessDomain {name: $domain})
                        MERGE (s)-[:BELONGS_TO]->(d)
                    """, spec=spec, domain=domain)
                
                # Connect agents to their specializations based on role
                session.run("""
                    MATCH (a:Agent)
                    WHERE a.role CONTAINS $domain
                    MATCH (d:BusinessDomain {name: $domain})
                    MERGE (a)-[:OPERATES_IN]->(d)
                """, domain=domain)
        
        print("✓ Created specialization structure")
    
    def print_summary(self):
        """Print summary of ontology building"""
        if not self.neo4j_driver:
            return
        
        print("\n=== Complete Ontology Building Summary ===")
        
        with self.neo4j_driver.session() as session:
            # Count agents by type
            result = session.run("""
                MATCH (a:Agent)
                RETURN a.type as type, count(a) as count
                ORDER BY type
            """)
            
            print("\nAgent counts by type:")
            for record in result:
                print(f"  - {record['type']}: {record['count']}")
            
            # Count knowledge items
            result = session.run("MATCH (k:Knowledge) RETURN count(k) as count")
            knowledge_count = result.single()["count"]
            
            # Count topics
            result = session.run("MATCH (t:Topic) RETURN count(t) as count")
            topic_count = result.single()["count"]
            
            # Count relationships
            result = session.run("""
                MATCH ()-[r:REPORTS_TO]->() RETURN count(r) as reports_to_count
            """)
            reports_to_count = result.single()["reports_to_count"]
            
            print(f"\n✓ Total agents: {30}")
            print(f"✓ Knowledge items: {knowledge_count}")
            print(f"✓ Topics identified: {topic_count}")
            print(f"✓ Reporting relationships: {reports_to_count}")
            
            # Show knowledge per agent
            print("\nKnowledge distribution:")
            result = session.run("""
                MATCH (a:Agent)-[:HAS_KNOWLEDGE]->(k:Knowledge)
                RETURN a.name as agent, a.role as role, count(k) as knowledge_count
                ORDER BY a.type DESC, a.name
                LIMIT 15
            """)
            
            for record in result:
                print(f"  - {record['agent']} ({record['role']}): {record['knowledge_count']} items")
            
            # Show reporting structure
            print("\nReporting structure:")
            result = session.run("""
                MATCH (task:Agent)-[:REPORTS_TO]->(director:Agent)
                RETURN director.name as director, director.role as director_role, 
                       collect(task.role) as reports
                ORDER BY director.name
            """)
            
            for record in result:
                print(f"\n  {record['director']} ({record['director_role']}):")
                for report in record['reports']:
                    print(f"    - {report}")

async def main():
    """Main execution"""
    print("Starting VividWalls Complete Agent Ontology Building...")
    print("=" * 60)
    
    builder = CompleteOntologyBuilder()
    await builder.build_all_ontologies()
    
    print("\n✓ Complete ontology building finished!")

if __name__ == "__main__":
    asyncio.run(main())