#!/usr/bin/env python3
"""
Neo4j-only Ontology Seeding Script for VividMAS Agent System
Populates Neo4j knowledge graph without Supabase dependency
"""

import os
import sys
import asyncio
import json
from datetime import datetime
from typing import Dict, List, Optional
from pathlib import Path
import requests
from neo4j import GraphDatabase
from dotenv import load_dotenv
import re
from collections import Counter

# Load environment variables
load_dotenv(Path(__file__).parent / "mcp-crawl4ai-rag/.env")

# Configuration - Use the Digital Ocean droplet Crawl4AI instance
CRAWL4AI_URL = "http://157.230.13.13:11235"
NEO4J_URI = os.getenv("NEO4J_URI", "bolt://157.230.13.13:7687")
NEO4J_USER = os.getenv("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.getenv("NEO4J_PASSWORD")

# Agent ontology sources mapping
AGENT_SOURCES = {
    "MarketingDirectorAgent": {
        "name": "Marketing Director",
        "sources": [
            "https://www.reddit.com/r/marketing.json?limit=10",
            "https://contentmarketinginstitute.com/articles/"
        ],
        "topics": ["digital marketing", "content strategy", "brand management", "marketing automation"]
    },
    "AnalyticsDirectorAgent": {
        "name": "Analytics Director", 
        "sources": [
            "https://www.reddit.com/r/datascience.json?limit=10",
            "https://towardsdatascience.com/"
        ],
        "topics": ["data analytics", "business intelligence", "predictive modeling", "data visualization"]
    },
    "ProductDirectorAgent": {
        "name": "Product Director",
        "sources": [
            "https://www.reddit.com/r/ProductManagement.json?limit=10",
            "https://www.productplan.com/blog/"
        ],
        "topics": ["product development", "product strategy", "roadmapping", "feature prioritization"]
    }
}

class Neo4jOntologySeeder:
    def __init__(self):
        self.neo4j_driver = GraphDatabase.driver(
            NEO4J_URI, 
            auth=(NEO4J_USER, NEO4J_PASSWORD)
        )
        
    def close(self):
        self.neo4j_driver.close()
        
    async def crawl_source(self, url: str, agent_key: str) -> Optional[str]:
        """Crawl a single source URL and return content"""
        print(f"  Crawling: {url}")
        
        try:
            if ".json" in url:
                # Handle Reddit JSON API
                response = requests.get(url, headers={'User-Agent': 'VividMAS/1.0'})
                if response.status_code == 200:
                    data = response.json()
                    return self._extract_reddit_content(data)
            else:
                # Use Crawl4AI Docker API
                crawl_request = {
                    "url": url,
                    "priority": 10,
                    "session_id": f"ontology_{agent_key}",
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
            print(f"    Error: {str(e)}")
            
        return None
        
    def _extract_reddit_content(self, data: Dict) -> str:
        """Extract relevant content from Reddit JSON"""
        content_parts = []
        
        if "data" in data and "children" in data["data"]:
            for post in data["data"]["children"]:
                post_data = post.get("data", {})
                title = post_data.get("title", "")
                selftext = post_data.get("selftext", "")
                
                if title:
                    content_parts.append(title)
                    if selftext:
                        content_parts.append(selftext[:500])
                    
        return " ".join(content_parts)
        
    def _extract_concepts(self, text: str, min_length: int = 4) -> List[str]:
        """Extract key concepts from text"""
        # Clean text
        text = text.lower()
        text = re.sub(r'[^a-z0-9\s-]', ' ', text)
        text = re.sub(r'\s+', ' ', text)
        
        # Split into words
        words = [w for w in text.split() if len(w) >= min_length]
        
        # Extract meaningful phrases
        phrases = []
        
        # Single important words (filter common words)
        common_words = {'this', 'that', 'with', 'from', 'have', 'been', 'were', 'what', 'when', 'where', 'which', 'their', 'there', 'these', 'those'}
        important_words = [w for w in words if w not in common_words and len(w) > 5]
        phrases.extend(important_words[:20])
        
        # 2-word phrases
        for i in range(len(words) - 1):
            if words[i] not in common_words and words[i+1] not in common_words:
                phrase = f"{words[i]} {words[i+1]}"
                phrases.append(phrase)
                
        # Count and return most common
        phrase_counts = Counter(phrases)
        return [phrase for phrase, count in phrase_counts.most_common(30) if count > 1]
        
    async def seed_agent_ontology(self, agent_key: str, agent_config: Dict):
        """Seed ontology for a specific agent"""
        print(f"\nSeeding ontology for {agent_config['name']}...")
        
        # Crawl sources and collect content
        all_content = ""
        sources_crawled = 0
        
        for source in agent_config["sources"]:
            content = await self.crawl_source(source, agent_key)
            if content:
                all_content += " " + content
                sources_crawled += 1
                
        print(f"  Crawled {sources_crawled} sources")
        
        # Extract concepts from crawled content
        concepts = self._extract_concepts(all_content) if all_content else []
        print(f"  Extracted {len(concepts)} concepts")
        
        # Store in Neo4j
        with self.neo4j_driver.session() as session:
            # Create/update agent node
            session.run("""
                MERGE (a:Agent {key: $key})
                SET a.name = $name,
                    a.updated_at = datetime(),
                    a.topics = $topics,
                    a.sources_count = $sources_count,
                    a.concepts_count = $concepts_count
            """, 
                key=agent_key,
                name=agent_config["name"],
                topics=agent_config["topics"],
                sources_count=sources_crawled,
                concepts_count=len(concepts)
            )
            
            # Create domain topic nodes
            for topic in agent_config["topics"]:
                session.run("""
                    MERGE (c:Concept {name: $topic})
                    SET c.type = 'domain_topic'
                    MERGE (a:Agent {key: $agent_key})
                    MERGE (a)-[:SPECIALIZES_IN]->(c)
                """,
                    topic=topic,
                    agent_key=agent_key
                )
                
            # Create discovered concept nodes
            for concept in concepts[:25]:  # Top 25 concepts
                session.run("""
                    MERGE (c:Concept {name: $concept})
                    SET c.type = 'discovered',
                        c.discovered_at = coalesce(c.discovered_at, datetime())
                    MERGE (a:Agent {key: $agent_key})
                    MERGE (a)-[:KNOWS_ABOUT {weight: $weight}]->(c)
                """,
                    concept=concept,
                    agent_key=agent_key,
                    weight=1.0  # Could be based on frequency
                )
                
        print(f"  ✓ Created agent node with {len(concepts[:25])} concept relationships")
        
    async def seed_all_agents(self):
        """Seed ontologies for all agents"""
        print("Starting Neo4j ontology seeding...")
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
            
        # Clear existing data (optional)
        with self.neo4j_driver.session() as session:
            print("\nClearing existing ontology data...")
            session.run("MATCH (a:Agent)-[r]->(c:Concept) DELETE r")
            session.run("MATCH (a:Agent) DELETE a")
            session.run("MATCH (c:Concept) WHERE NOT (c)<-[:KNOWS_ABOUT]-() DELETE c")
            
        # Seed each agent
        for agent_key, agent_config in AGENT_SOURCES.items():
            await self.seed_agent_ontology(agent_key, agent_config)
            
        # Create inter-concept relationships
        print("\nCreating concept relationships...")
        with self.neo4j_driver.session() as session:
            # Link related concepts
            session.run("""
                MATCH (c1:Concept), (c2:Concept)
                WHERE c1.name CONTAINS 'marketing' AND c2.name CONTAINS 'content'
                  AND c1 <> c2
                MERGE (c1)-[:RELATED_TO]->(c2)
            """)
            
            session.run("""
                MATCH (c1:Concept), (c2:Concept)
                WHERE c1.name CONTAINS 'data' AND c2.name CONTAINS 'analytics'
                  AND c1 <> c2
                MERGE (c1)-[:RELATED_TO]->(c2)
            """)
            
        print("\n✓ Ontology seeding completed!")
        
        # Show summary
        with self.neo4j_driver.session() as session:
            result = session.run("""
                MATCH (a:Agent)
                RETURN count(a) as agent_count
            """)
            agent_count = result.single()["agent_count"]
            
            result = session.run("""
                MATCH (c:Concept)
                RETURN count(c) as concept_count
            """)
            concept_count = result.single()["concept_count"]
            
            result = session.run("""
                MATCH ()-[r]->()
                RETURN count(r) as relationship_count
            """)
            rel_count = result.single()["relationship_count"]
            
            print(f"\nKnowledge Graph Summary:")
            print(f"  Agents: {agent_count}")
            print(f"  Concepts: {concept_count}")
            print(f"  Relationships: {rel_count}")
            
            # Show sample of knowledge graph
            print("\nSample Agent Knowledge:")
            result = session.run("""
                MATCH (a:Agent)-[:KNOWS_ABOUT]->(c:Concept)
                RETURN a.name as agent, collect(c.name)[..5] as concepts
                ORDER BY a.name
            """)
            
            for record in result:
                print(f"\n{record['agent']}:")
                for concept in record['concepts']:
                    print(f"  - {concept}")


async def main():
    seeder = Neo4jOntologySeeder()
    try:
        await seeder.seed_all_agents()
    finally:
        seeder.close()


if __name__ == "__main__":
    asyncio.run(main())