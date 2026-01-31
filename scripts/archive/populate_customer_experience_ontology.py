#!/usr/bin/env python3
"""
Script to populate the Customer Experience Director Agent ontology
by crawling domain authorities and storing in Neo4j knowledge graph
"""

import os
import sys
import json
import asyncio
from typing import List, Dict, Any
from datetime import datetime

# Add the crawl4ai MCP server path to import the client
sys.path.append('/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/mcp-crawl4ai-rag/src')

# Import crawl4ai functionality directly
from crawl4ai import AsyncWebCrawler
from crawl4ai.extraction_strategy import JsonCssExtractionStrategy, LLMExtractionStrategy
import chromadb
from neo4j import GraphDatabase
from dotenv import load_dotenv

# Load environment variables
load_dotenv('/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/mcp-crawl4ai-rag/.env')

# Neo4j configuration
NEO4J_URI = os.getenv("NEO4J_URI", "bolt://157.230.13.13:7687")
NEO4J_USER = os.getenv("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.getenv("NEO4J_PASSWORD", "VPofL3g9gTaquiXxA6ntvQDyK")

# Customer Experience domain authorities
DOMAIN_AUTHORITIES = [
    {
        "name": "Zendesk",
        "url": "https://www.zendesk.com/blog/",
        "topics": ["customer service", "support technology", "help desk"],
        "max_pages": 20
    },
    {
        "name": "HelpScout",
        "url": "https://www.helpscout.com/blog/",
        "topics": ["customer support", "team collaboration", "customer success"],
        "max_pages": 20
    },
    {
        "name": "Intercom",
        "url": "https://www.intercom.com/blog/",
        "topics": ["customer messaging", "chatbots", "engagement"],
        "max_pages": 20
    },
    {
        "name": "CustomerThink",
        "url": "https://customerthink.com/",
        "topics": ["customer experience", "CX strategy", "best practices"],
        "max_pages": 15
    },
    {
        "name": "Harvard Business Review",
        "url": "https://hbr.org/topic/customer-service",
        "topics": ["leadership", "strategy", "research"],
        "max_pages": 10
    }
]

class CustomerExperienceOntologyBuilder:
    def __init__(self):
        self.crawler = None
        self.neo4j_driver = None
        self.agent_id = "00000000-0000-0000-0001-000000000001"
        self.agent_name = "Emily Chen"
        self.agent_role = "Customer Experience Director"
        
    async def initialize(self):
        """Initialize the crawler and database connections"""
        print("Initializing ontology builder...")
        self.crawler = AsyncWebCrawler()
        await self.crawler.arun(url="https://example.com", bypass_cache=True)  # Warm up
        
        # Initialize Neo4j connection
        try:
            self.neo4j_driver = GraphDatabase.driver(
                NEO4J_URI, 
                auth=(NEO4J_USER, NEO4J_PASSWORD)
            )
            # Test connection
            with self.neo4j_driver.session() as session:
                session.run("RETURN 1")
            print("✓ Connected to Neo4j")
        except Exception as e:
            print(f"⚠️  Neo4j connection failed: {e}")
            print("Continuing without Neo4j storage...")
            self.neo4j_driver = None
    
    async def crawl_domain(self, domain: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Crawl a single domain and extract relevant content"""
        print(f"\nCrawling {domain['name']} ({domain['url']})...")
        
        extracted_content = []
        
        try:
            # Define extraction strategy for customer experience content
            extraction_strategy = LLMExtractionStrategy(
                provider="openai",
                api_token=os.getenv("OPENAI_API_KEY"),
                schema={
                    "type": "object",
                    "properties": {
                        "title": {"type": "string"},
                        "topic": {"type": "string"},
                        "key_insights": {
                            "type": "array",
                            "items": {"type": "string"}
                        },
                        "best_practices": {
                            "type": "array",
                            "items": {"type": "string"}
                        },
                        "metrics_mentioned": {
                            "type": "array",
                            "items": {"type": "string"}
                        },
                        "tools_mentioned": {
                            "type": "array",
                            "items": {"type": "string"}
                        }
                    }
                },
                instruction="""Extract customer experience insights from this content. 
                Focus on: best practices, metrics, tools, and actionable insights 
                related to customer service, support, retention, and satisfaction."""
            )
            
            # Crawl the main page
            result = await self.crawler.arun(
                url=domain["url"],
                extraction_strategy=extraction_strategy,
                bypass_cache=True
            )
            
            if result.success and result.extracted_content:
                content_data = json.loads(result.extracted_content)
                content_data["source"] = domain["name"]
                content_data["url"] = domain["url"]
                content_data["crawled_at"] = datetime.now().isoformat()
                extracted_content.append(content_data)
            
            # Get additional pages (simplified for now)
            # In production, you'd want to follow links intelligently
            
            print(f"✓ Extracted {len(extracted_content)} items from {domain['name']}")
            
        except Exception as e:
            print(f"✗ Error crawling {domain['name']}: {e}")
        
        return extracted_content
    
    def store_in_neo4j(self, content: List[Dict[str, Any]]):
        """Store extracted content in Neo4j knowledge graph"""
        if not self.neo4j_driver:
            print("Skipping Neo4j storage (no connection)")
            return
        
        print(f"\nStoring {len(content)} items in Neo4j...")
        
        with self.neo4j_driver.session() as session:
            # Ensure agent node exists
            session.run("""
                MERGE (a:Agent {id: $agent_id})
                SET a.name = $agent_name,
                    a.role = $agent_role,
                    a.type = 'Director'
            """, agent_id=self.agent_id, agent_name=self.agent_name, agent_role=self.agent_role)
            
            # Store content as knowledge nodes
            for item in content:
                try:
                    # Create knowledge node
                    result = session.run("""
                        MATCH (a:Agent {id: $agent_id})
                        CREATE (k:Knowledge {
                            title: $title,
                            source: $source,
                            url: $url,
                            topic: $topic,
                            crawled_at: $crawled_at,
                            type: 'Article'
                        })
                        CREATE (a)-[:HAS_KNOWLEDGE]->(k)
                        RETURN k
                    """, 
                    agent_id=self.agent_id,
                    title=item.get("title", "Untitled"),
                    source=item.get("source"),
                    url=item.get("url"),
                    topic=item.get("topic", "General"),
                    crawled_at=item.get("crawled_at"))
                    
                    knowledge_node = result.single()
                    
                    # Add insights as separate nodes
                    for insight in item.get("key_insights", []):
                        session.run("""
                            MATCH (k:Knowledge {url: $url})
                            CREATE (i:Insight {content: $content, type: 'Key Insight'})
                            CREATE (k)-[:CONTAINS]->(i)
                        """, url=item.get("url"), content=insight)
                    
                    # Add best practices
                    for practice in item.get("best_practices", []):
                        session.run("""
                            MATCH (k:Knowledge {url: $url})
                            CREATE (bp:BestPractice {content: $content})
                            CREATE (k)-[:RECOMMENDS]->(bp)
                        """, url=item.get("url"), content=practice)
                    
                    # Add metrics
                    for metric in item.get("metrics_mentioned", []):
                        session.run("""
                            MATCH (k:Knowledge {url: $url})
                            MERGE (m:Metric {name: $metric})
                            CREATE (k)-[:MENTIONS]->(m)
                        """, url=item.get("url"), metric=metric)
                    
                    # Add tools
                    for tool in item.get("tools_mentioned", []):
                        session.run("""
                            MATCH (k:Knowledge {url: $url})
                            MERGE (t:Tool {name: $tool})
                            CREATE (k)-[:USES]->(t)
                        """, url=item.get("url"), tool=tool)
                    
                except Exception as e:
                    print(f"Error storing item: {e}")
        
        print("✓ Knowledge stored in Neo4j")
    
    def create_ontology_summary(self, all_content: List[Dict[str, Any]]):
        """Create a summary of the ontology"""
        print("\n=== Customer Experience Ontology Summary ===")
        
        # Collect all unique metrics, tools, and topics
        all_metrics = set()
        all_tools = set()
        all_topics = set()
        insight_count = 0
        practice_count = 0
        
        for content in all_content:
            all_metrics.update(content.get("metrics_mentioned", []))
            all_tools.update(content.get("tools_mentioned", []))
            if content.get("topic"):
                all_topics.add(content["topic"])
            insight_count += len(content.get("key_insights", []))
            practice_count += len(content.get("best_practices", []))
        
        print(f"\nAgent: {self.agent_name} ({self.agent_role})")
        print(f"Knowledge items: {len(all_content)}")
        print(f"Key insights: {insight_count}")
        print(f"Best practices: {practice_count}")
        print(f"\nTopics covered: {', '.join(sorted(all_topics))}")
        print(f"\nMetrics identified: {', '.join(sorted(all_metrics))}")
        print(f"\nTools mentioned: {', '.join(sorted(all_tools))}")
    
    async def build_ontology(self):
        """Main method to build the complete ontology"""
        await self.initialize()
        
        all_content = []
        
        # Crawl each domain
        for domain in DOMAIN_AUTHORITIES:
            content = await self.crawl_domain(domain)
            all_content.extend(content)
            
            # Be respectful with rate limiting
            await asyncio.sleep(2)
        
        # Store in Neo4j
        if all_content:
            self.store_in_neo4j(all_content)
            self.create_ontology_summary(all_content)
        else:
            print("\n⚠️  No content extracted")
        
        # Cleanup
        if self.neo4j_driver:
            self.neo4j_driver.close()

async def main():
    """Main execution"""
    print("Starting Customer Experience Director ontology population...")
    print("=" * 60)
    
    builder = CustomerExperienceOntologyBuilder()
    await builder.build_ontology()
    
    print("\n✓ Ontology building complete!")

if __name__ == "__main__":
    asyncio.run(main())