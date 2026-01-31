#!/usr/bin/env python3
"""
Smart crawl implementation for agent knowledge population.
Directly implements patterns from crawl4ai_mcp.py including smart URL detection,
sitemap parsing, and intelligent content extraction.
"""

import os
import json
import requests
import openai
import base64
import time
import asyncio
import xml.etree.ElementTree as ET
from typing import List, Dict, Any, Optional, Tuple, Set
from pathlib import Path
from urllib.parse import urlparse, urljoin, urldefrag
import re
import concurrent.futures
from collections import defaultdict

# Configuration
CRAWL4AI_URL = "https://crawl4ai.vividwalls.blog"
SUPABASE_URL = "http://157.230.13.13:8000"
SUPABASE_SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw"
OPENAI_API_KEY = "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"

# Set OpenAI API key
openai.api_key = OPENAI_API_KEY

# Headers for requests
AUTH_STRING = base64.b64encode(b"supabase:this_password_is_insecure_and_should_be_updated").decode()
SUPABASE_HEADERS = {
    "Authorization": f"Basic {AUTH_STRING}",
    "apikey": SUPABASE_SERVICE_KEY,
    "Content-Type": "application/json",
    "Prefer": "return=representation"
}

class SmartCrawler:
    """Smart crawler that detects URL types and crawls accordingly."""
    
    def __init__(self):
        self.crawled_urls = set()
        self.max_pages_per_domain = 10
        
    def detect_url_type(self, url: str) -> str:
        """Detect the type of URL (sitemap, robots.txt, regular page)."""
        url_lower = url.lower()
        
        if url_lower.endswith('sitemap.xml') or 'sitemap' in url_lower:
            return 'sitemap'
        elif url_lower.endswith('robots.txt'):
            return 'robots'
        elif url_lower.endswith('.txt'):
            return 'txt'
        else:
            return 'webpage'
    
    def crawl_sitemap(self, url: str) -> List[str]:
        """Extract URLs from a sitemap."""
        try:
            response = requests.get(url, timeout=10)
            if response.status_code != 200:
                return []
            
            # Parse XML
            root = ET.fromstring(response.content)
            
            # Handle both sitemap index and regular sitemap
            urls = []
            
            # Check for sitemap index
            for sitemap in root.findall('.//{http://www.sitemaps.org/schemas/sitemap/0.9}sitemap'):
                loc = sitemap.find('{http://www.sitemaps.org/schemas/sitemap/0.9}loc')
                if loc is not None and loc.text:
                    # Recursively crawl sub-sitemaps
                    sub_urls = self.crawl_sitemap(loc.text)
                    urls.extend(sub_urls)
            
            # Check for regular URLs
            for url_elem in root.findall('.//{http://www.sitemaps.org/schemas/sitemap/0.9}url'):
                loc = url_elem.find('{http://www.sitemaps.org/schemas/sitemap/0.9}loc')
                if loc is not None and loc.text:
                    urls.append(loc.text)
            
            return urls[:self.max_pages_per_domain]
            
        except Exception as e:
            print(f"Error parsing sitemap {url}: {e}")
            return []
    
    def crawl_robots_txt(self, url: str) -> List[str]:
        """Extract sitemap URLs from robots.txt."""
        try:
            response = requests.get(url, timeout=10)
            if response.status_code != 200:
                return []
            
            sitemaps = []
            lines = response.text.split('\n')
            
            for line in lines:
                if line.strip().lower().startswith('sitemap:'):
                    sitemap_url = line.split(':', 1)[1].strip()
                    sitemaps.append(sitemap_url)
            
            return sitemaps
            
        except Exception as e:
            print(f"Error parsing robots.txt {url}: {e}")
            return []
    
    def crawl_single_page(self, url: str) -> Optional[Dict[str, Any]]:
        """Crawl a single webpage using Crawl4AI service."""
        if url in self.crawled_urls:
            return None
            
        try:
            request_data = {
                "url": url,
                "wait_for": "networkidle",
                "screenshot": False,
                "remove_overlay": True,
                "bypass_cache": True,
                "exclude_tags": ["nav", "footer", "aside"]
            }
            
            response = requests.post(
                f"{CRAWL4AI_URL}/crawl",
                json=request_data,
                headers={"Content-Type": "application/json"},
                timeout=60
            )
            
            if response.status_code == 200:
                self.crawled_urls.add(url)
                result = response.json()
                
                content = result.get("markdown") or result.get("content") or result.get("text", "")
                if content and len(content) > 100:  # Minimum content length
                    return {
                        "url": url,
                        "content": content,
                        "title": result.get("title", ""),
                        "metadata": result.get("metadata", {})
                    }
            
        except Exception as e:
            print(f"Error crawling {url}: {e}")
        
        return None
    
    def smart_crawl_url(self, url: str, max_pages: int = 5) -> List[Dict[str, Any]]:
        """Intelligently crawl URL based on its type."""
        url_type = self.detect_url_type(url)
        results = []
        
        print(f"  Detected URL type: {url_type}")
        
        if url_type == 'sitemap':
            # Get URLs from sitemap
            sitemap_urls = self.crawl_sitemap(url)
            print(f"  Found {len(sitemap_urls)} URLs in sitemap")
            
            # Crawl pages from sitemap
            for page_url in sitemap_urls[:max_pages]:
                result = self.crawl_single_page(page_url)
                if result:
                    results.append(result)
                    
        elif url_type == 'robots':
            # Get sitemaps from robots.txt
            sitemaps = self.crawl_robots_txt(url)
            print(f"  Found {len(sitemaps)} sitemaps in robots.txt")
            
            # Crawl each sitemap
            for sitemap_url in sitemaps:
                sitemap_results = self.smart_crawl_url(sitemap_url, max_pages)
                results.extend(sitemap_results)
                
        else:
            # Regular webpage or txt file
            result = self.crawl_single_page(url)
            if result:
                results.append(result)
                
                # Try to find sitemap
                parsed = urlparse(url)
                base_url = f"{parsed.scheme}://{parsed.netloc}"
                
                # Common sitemap locations
                common_sitemaps = [
                    f"{base_url}/sitemap.xml",
                    f"{base_url}/sitemap_index.xml",
                    f"{base_url}/robots.txt"
                ]
                
                for sitemap_url in common_sitemaps:
                    if sitemap_url not in self.crawled_urls:
                        sitemap_results = self.smart_crawl_url(sitemap_url, max_pages - len(results))
                        results.extend(sitemap_results)
                        if len(results) >= max_pages:
                            break
        
        return results[:max_pages]

class AgentKnowledgeBuilder:
    """Build domain-specific knowledge for agents."""
    
    def __init__(self):
        self.crawler = SmartCrawler()
        self.chunk_size = 1000
        self.chunk_overlap = 200
        
    def create_embeddings_batch(self, texts: List[str]) -> List[List[float]]:
        """Create embeddings for multiple texts efficiently."""
        if not texts:
            return []
        
        max_retries = 3
        retry_delay = 1.0
        
        for retry in range(max_retries):
            try:
                response = openai.embeddings.create(
                    model="text-embedding-3-small",
                    input=texts
                )
                return [item.embedding for item in response.data]
                
            except Exception as e:
                if retry < max_retries - 1:
                    print(f"    Retry {retry + 1}/{max_retries} after error: {e}")
                    time.sleep(retry_delay)
                    retry_delay *= 2
                else:
                    print(f"    Failed to create embeddings: {e}")
                    return [[0.0] * 1536 for _ in texts]
    
    def generate_contextual_embedding(self, full_document: str, chunk: str, agent_role: str) -> str:
        """Generate contextual information for a chunk."""
        try:
            prompt = f"""<document>
{full_document[:5000]}
</document>

<chunk>
{chunk}
</chunk>

As a {agent_role}, provide a brief context (1-2 sentences) that situates this chunk within the document for better retrieval. Focus on aspects relevant to {agent_role} responsibilities."""

            response = openai.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": f"You are a {agent_role} providing context."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.3,
                max_tokens=100
            )
            
            context = response.choices[0].message.content.strip()
            return f"{context}\n---\n{chunk}"
            
        except Exception as e:
            print(f"    Error generating context: {e}")
            return chunk
    
    def chunk_and_embed_content(self, content: str, url: str, title: str, agent_id: str) -> List[Dict[str, Any]]:
        """Chunk content and create embeddings with contextual information."""
        chunks = []
        words = content.split()
        
        if len(words) <= self.chunk_size:
            # Single chunk
            contextual_content = self.generate_contextual_embedding(content, content, agent_id)
            embedding = self.create_embeddings_batch([contextual_content])[0]
            
            return [{
                "content": contextual_content,
                "embedding": embedding,
                "metadata": {
                    "url": url,
                    "title": title,
                    "chunk_number": 0,
                    "total_chunks": 1,
                    "agent_id": agent_id
                }
            }]
        
        # Multiple chunks with overlap
        chunk_texts = []
        for i in range(0, len(words), self.chunk_size - self.chunk_overlap):
            chunk_words = words[i:i + self.chunk_size]
            chunk_text = " ".join(chunk_words)
            chunk_texts.append(chunk_text)
            
            if i + self.chunk_size >= len(words):
                break
        
        # Generate contextual embeddings for all chunks
        contextual_chunks = []
        print(f"    Creating contextual embeddings for {len(chunk_texts)} chunks...")
        
        with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
            future_to_idx = {
                executor.submit(self.generate_contextual_embedding, content, chunk, agent_id): idx
                for idx, chunk in enumerate(chunk_texts)
            }
            
            results = [None] * len(chunk_texts)
            for future in concurrent.futures.as_completed(future_to_idx):
                idx = future_to_idx[future]
                try:
                    results[idx] = future.result()
                except Exception as e:
                    print(f"    Error processing chunk {idx}: {e}")
                    results[idx] = chunk_texts[idx]
            
            contextual_chunks = results
        
        # Create embeddings in batch
        embeddings = self.create_embeddings_batch(contextual_chunks)
        
        # Combine chunks with embeddings
        for i, (chunk_text, embedding) in enumerate(zip(contextual_chunks, embeddings)):
            chunks.append({
                "content": chunk_text,
                "embedding": embedding,
                "metadata": {
                    "url": url,
                    "title": title,
                    "chunk_number": i,
                    "total_chunks": len(contextual_chunks),
                    "agent_id": agent_id,
                    "contextual": True
                }
            })
        
        return chunks
    
    def store_chunks_in_supabase(self, agent_id: str, collection: str, chunks: List[Dict[str, Any]]):
        """Store chunks in Supabase with batch processing."""
        if not chunks:
            return
        
        print(f"  Storing {len(chunks)} chunks in Supabase...")
        
        batch_size = 20
        successful = 0
        
        for i in range(0, len(chunks), batch_size):
            batch = chunks[i:i + batch_size]
            records = []
            
            for chunk in batch:
                record = {
                    "agent_id": agent_id,
                    "collection": collection,
                    "content": chunk["content"],
                    "metadata": chunk["metadata"],
                    "embedding": chunk["embedding"]
                }
                records.append(record)
            
            try:
                response = requests.post(
                    f"{SUPABASE_URL}/rest/v1/agent_embeddings",
                    json=records,
                    headers=SUPABASE_HEADERS,
                    timeout=30
                )
                
                if response.status_code in [200, 201]:
                    successful += len(records)
                else:
                    print(f"    Failed batch: {response.status_code} - {response.text[:100]}")
                    
            except Exception as e:
                print(f"    Error storing batch: {e}")
        
        print(f"  ✓ Successfully stored {successful}/{len(chunks)} chunks")
    
    def build_knowledge_for_agent(self, agent_id: str, sources: List[str], queries: List[str]):
        """Build comprehensive knowledge base for an agent."""
        print(f"\n{'='*60}")
        print(f"Building knowledge for {agent_id}")
        print(f"{'='*60}")
        
        collection = f"{agent_id}_vectors"
        all_chunks = []
        
        # Process each source with smart crawling
        for source in sources:
            print(f"\n  Smart crawling: {source}")
            results = self.crawler.smart_crawl_url(source, max_pages=5)
            
            for result in results:
                print(f"    Processing: {result['url']}")
                chunks = self.chunk_and_embed_content(
                    result["content"],
                    result["url"],
                    result.get("title", ""),
                    agent_id
                )
                all_chunks.extend(chunks)
        
        # Store all chunks
        if all_chunks:
            self.store_chunks_in_supabase(agent_id, collection, all_chunks)
            print(f"\n  Total: {len(all_chunks)} chunks processed for {agent_id}")

# Enhanced domain sources with focus on quality content
ENHANCED_AGENT_SOURCES = {
    "marketing_director": {
        "sources": [
            "https://blog.hubspot.com/marketing/sitemap.xml",
            "https://contentmarketinginstitute.com/",
            "https://neilpatel.com/blog/",
            "https://www.marketingevolution.com/marketing-essentials",
            "https://blog.hootsuite.com/sitemap.xml"
        ],
        "queries": [
            "digital marketing strategies 2024",
            "content marketing ROI measurement",
            "marketing automation best practices"
        ]
    },
    "sales_director": {
        "sources": [
            "https://blog.hubspot.com/sales/sitemap.xml",
            "https://www.salesforce.com/resources/",
            "https://www.saleshacker.com/",
            "https://blog.close.com/"
        ],
        "queries": [
            "B2B sales methodologies",
            "sales enablement tools",
            "revenue operations best practices"
        ]
    },
    "operations_director": {
        "sources": [
            "https://www.mckinsey.com/capabilities/operations",
            "https://hbr.org/topic/operations",
            "https://www.supplychaindive.com/"
        ],
        "queries": [
            "supply chain resilience",
            "operational excellence frameworks",
            "lean six sigma implementation"
        ]
    },
    "analytics_director": {
        "sources": [
            "https://www.tableau.com/learn",
            "https://towardsdatascience.com/",
            "https://www.kdnuggets.com/"
        ],
        "queries": [
            "data visualization best practices",
            "predictive analytics implementation",
            "data governance frameworks"
        ]
    },
    "technology_director": {
        "sources": [
            "https://www.infoworld.com/",
            "https://techcrunch.com/category/enterprise/",
            "https://www.cio.com/"
        ],
        "queries": [
            "cloud architecture patterns",
            "cybersecurity frameworks 2024",
            "IT infrastructure modernization"
        ]
    }
}

def main():
    """Main execution function."""
    print("Smart Agent Knowledge Population System")
    print("Using advanced crawl4ai patterns")
    print("="*70)
    
    # Initialize builder
    builder = AgentKnowledgeBuilder()
    
    # Test crawl
    print("\nTesting smart crawl capabilities...")
    test_results = builder.crawler.smart_crawl_url("https://blog.hubspot.com/marketing", max_pages=2)
    print(f"✓ Test crawl returned {len(test_results)} pages")
    
    # Process priority agents
    priority_agents = ["marketing_director", "sales_director", "analytics_director"]
    
    for agent_id in priority_agents:
        if agent_id in ENHANCED_AGENT_SOURCES:
            config = ENHANCED_AGENT_SOURCES[agent_id]
            builder.build_knowledge_for_agent(
                agent_id,
                config["sources"],
                config["queries"]
            )
            time.sleep(5)  # Rate limiting
    
    print("\n" + "="*70)
    print("SMART CRAWL COMPLETE")
    print("="*70)
    print("\nKnowledge has been populated using:")
    print("- Smart URL detection (sitemap, robots.txt, etc.)")
    print("- Contextual embeddings for better retrieval")
    print("- Batch processing for efficiency")
    print("- Agent-specific content focus")
    
    print("\nNext steps:")
    print("1. Test vector search in n8n: https://n8n.vividwalls.blog/")
    print("2. Verify embeddings: https://supabase.vividwalls.blog/")
    print("3. Configure agent workflows to use their collections")

if __name__ == "__main__":
    main()