#!/usr/bin/env python3
"""
Ontology Seeding Script for VividMAS Agent System
Crawls domain-specific sources and populates Neo4j knowledge graph
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
import hashlib

# Add mcp-crawl4ai-rag to path
sys.path.append(str(Path(__file__).parent / "mcp-crawl4ai-rag/src"))

from utils import get_supabase_client, add_documents_to_supabase, update_source_info

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
            "https://www.reddit.com/r/marketing.json",
            "https://trends.google.com/trends/api/explore?cat=12",
            "https://marketinginstitute.com/resources",
            "https://contentmarketinginstitute.com/articles/"
        ],
        "topics": ["digital marketing", "content strategy", "brand management", "marketing automation"]
    },
    "AnalyticsDirectorAgent": {
        "name": "Analytics Director", 
        "sources": [
            "https://www.reddit.com/r/datascience.json",
            "https://www.reddit.com/r/businessintelligence.json",
            "https://towardsdatascience.com/",
            "https://www.analyticsvidhya.com/blog/"
        ],
        "topics": ["data analytics", "business intelligence", "predictive modeling", "data visualization"]
    },
    "CustomerExperienceDirectorAgent": {
        "name": "Customer Experience Director",
        "sources": [
            "https://www.reddit.com/r/CustomerSuccess.json",
            "https://www.customerexperiencemagazine.com/",
            "https://www.zendesk.com/blog/",
            "https://www.helpscout.com/blog/"
        ],
        "topics": ["customer journey", "user experience", "customer satisfaction", "service design"]
    },
    "ProductDirectorAgent": {
        "name": "Product Director",
        "sources": [
            "https://www.reddit.com/r/ProductManagement.json",
            "https://www.reddit.com/r/ecommerce.json",
            "https://www.producthunt.com/",
            "https://www.productplan.com/blog/"
        ],
        "topics": ["product development", "product strategy", "roadmapping", "feature prioritization"]
    },
    "TechnologyDirectorAgent": {
        "name": "Technology Director",
        "sources": [
            "https://www.reddit.com/r/programming.json",
            "https://www.reddit.com/r/devops.json",
            "https://techcrunch.com/",
            "https://www.infoq.com/"
        ],
        "topics": ["software architecture", "cloud computing", "DevOps", "emerging technologies"]
    }
}

class OntologySeeder:
    def __init__(self):
        self.neo4j_driver = GraphDatabase.driver(
            NEO4J_URI, 
            auth=(NEO4J_USER, NEO4J_PASSWORD)
        )
        self.supabase_client = get_supabase_client()
        
    def close(self):
        self.neo4j_driver.close()
        
    async def crawl_source(self, url: str, agent_key: str) -> Optional[Dict]:
        """Crawl a single source URL"""
        print(f"  Crawling: {url}")
        
        try:
            # Use Crawl4AI Docker instance
            if ".json" in url:
                # Handle Reddit JSON API
                response = requests.get(url, headers={'User-Agent': 'VividMAS/1.0'})
                if response.status_code == 200:
                    data = response.json()
                    # Extract relevant content from Reddit
                    content = self._extract_reddit_content(data)
                    return {
                        "url": url,
                        "content": content,
                        "metadata": {
                            "agent": agent_key,
                            "source_type": "reddit",
                            "crawled_at": datetime.now().isoformat()
                        }
                    }
            else:
                # Use Crawl4AI Docker API for regular web pages
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
                    headers={"Content-Type": "application/json"}
                )
                
                if response.status_code == 200:
                    result = response.json()
                    if result.get("success"):
                        return {
                            "url": url,
                            "content": result.get("markdown", ""),
                            "metadata": {
                                "agent": agent_key,
                                "source_type": "webpage", 
                                "title": result.get("metadata", {}).get("title", ""),
                                "crawled_at": datetime.now().isoformat()
                            }
                        }
                        
        except Exception as e:
            print(f"    Error crawling {url}: {str(e)}")
            
        return None
        
    def _extract_reddit_content(self, data: Dict) -> str:
        """Extract relevant content from Reddit JSON response"""
        content_parts = []
        
        if "data" in data and "children" in data["data"]:
            for post in data["data"]["children"][:10]:  # Top 10 posts
                post_data = post.get("data", {})
                title = post_data.get("title", "")
                selftext = post_data.get("selftext", "")
                score = post_data.get("score", 0)
                
                if title:
                    content_parts.append(f"## {title} (Score: {score})")
                    if selftext:
                        content_parts.append(selftext[:500])  # Limit text length
                    content_parts.append("")
                    
        return "\n\n".join(content_parts)
        
    async def seed_agent_ontology(self, agent_key: str, agent_config: Dict):
        """Seed ontology for a specific agent"""
        print(f"\nSeeding ontology for {agent_config['name']}...")
        
        # Crawl all sources for this agent
        crawled_docs = []
        for source in agent_config["sources"]:
            doc = await self.crawl_source(source, agent_key)
            if doc:
                crawled_docs.append(doc)
                
        print(f"  Crawled {len(crawled_docs)} sources")
        
        # Store in Supabase for RAG
        if crawled_docs:
            # Extract components for add_documents_to_supabase
            urls = []
            contents = []
            metadatas = []
            chunk_numbers = []
            url_to_full_document = {}
            source_id = agent_key
            
            for i, doc in enumerate(crawled_docs):
                url = doc["url"]
                content = doc["content"]
                urls.append(url)
                contents.append(content)
                # Add source_id to metadata
                doc["metadata"]["source_id"] = agent_key
                metadatas.append(doc["metadata"])
                chunk_numbers.append(0)  # Single chunk per document for now
                url_to_full_document[url] = content  # For contextual embeddings
                
            # Generate source ID using hash
            source_hash = hashlib.sha256(source_id.encode()).hexdigest()[:8]
            
            # Calculate total word count
            total_content = " ".join(contents)
            word_count = len(total_content.split())
            
            # Create a summary for the agent
            summary = f"{agent_config['name']} - Ontology seeding from {len(crawled_docs)} sources covering topics: {', '.join(agent_config['topics'][:3])}"
            
            # Update source info
            update_source_info(self.supabase_client, source_hash, summary, word_count)
            
            # Add documents to Supabase
            add_documents_to_supabase(
                self.supabase_client,
                urls,
                chunk_numbers,
                contents,
                metadatas,
                url_to_full_document
            )
            
        # Create/update agent node in Neo4j
        with self.neo4j_driver.session() as session:
            session.run("""
                MERGE (a:Agent {key: $key})
                SET a.name = $name,
                    a.updated_at = datetime(),
                    a.topics = $topics,
                    a.sources_count = $sources_count
            """, 
                key=agent_key,
                name=agent_config["name"],
                topics=agent_config["topics"],
                sources_count=len(crawled_docs)
            )
            
            # Create concept nodes from topics
            for topic in agent_config["topics"]:
                session.run("""
                    MERGE (c:Concept {name: $topic})
                    MERGE (a:Agent {key: $agent_key})
                    MERGE (a)-[:SPECIALIZES_IN]->(c)
                """,
                    topic=topic,
                    agent_key=agent_key
                )
                
            # Extract and link key concepts from crawled content
            all_content = " ".join([doc["content"] for doc in crawled_docs])
            concepts = self._extract_concepts(all_content)
            
            for concept in concepts[:20]:  # Top 20 concepts
                session.run("""
                    MERGE (c:Concept {name: $concept})
                    MERGE (a:Agent {key: $agent_key})
                    MERGE (a)-[:KNOWS_ABOUT]->(c)
                    ON CREATE SET c.discovered_at = datetime()
                """,
                    concept=concept,
                    agent_key=agent_key
                )
                
        print(f"  Created {len(concepts[:20])} concept nodes in Neo4j")
        
    def _extract_concepts(self, text: str) -> List[str]:
        """Extract key concepts from text using simple NLP"""
        # Simple concept extraction - in production, use proper NLP
        import re
        from collections import Counter
        
        # Clean text
        text = text.lower()
        text = re.sub(r'[^a-z0-9\s-]', ' ', text)
        
        # Extract meaningful phrases (2-3 word combinations)
        words = text.split()
        phrases = []
        
        for i in range(len(words) - 1):
            # 2-word phrases
            phrase = f"{words[i]} {words[i+1]}"
            if len(words[i]) > 3 and len(words[i+1]) > 3:
                phrases.append(phrase)
                
            # 3-word phrases
            if i < len(words) - 2:
                phrase3 = f"{words[i]} {words[i+1]} {words[i+2]}"
                if len(words[i]) > 3 and len(words[i+2]) > 3:
                    phrases.append(phrase3)
                    
        # Count and return most common
        phrase_counts = Counter(phrases)
        return [phrase for phrase, _ in phrase_counts.most_common(50)]
        
    async def seed_all_agents(self):
        """Seed ontologies for all agents"""
        print("Starting ontology seeding for all agents...")
        print(f"Neo4j: {NEO4J_URI}")
        print(f"Crawl4AI: {CRAWL4AI_URL}")
        
        # Check connections
        try:
            # Check Neo4j
            with self.neo4j_driver.session() as session:
                result = session.run("RETURN 1 as test")
                print("✓ Neo4j connection successful")
                
            # Check Crawl4AI
            response = requests.get(f"{CRAWL4AI_URL}/health")
            if response.status_code == 200:
                print("✓ Crawl4AI connection successful")
            else:
                print(f"✗ Crawl4AI health check failed: {response.status_code}")
                
        except Exception as e:
            print(f"✗ Connection error: {str(e)}")
            return
            
        # Seed each agent
        for agent_key, agent_config in AGENT_SOURCES.items():
            await self.seed_agent_ontology(agent_key, agent_config)
            
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
            
            print(f"\nKnowledge Graph Summary:")
            print(f"  Agents: {agent_count}")
            print(f"  Concepts: {concept_count}")


async def main():
    seeder = OntologySeeder()
    try:
        await seeder.seed_all_agents()
    finally:
        seeder.close()


if __name__ == "__main__":
    asyncio.run(main())