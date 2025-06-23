#!/usr/bin/env python3
"""
Script to crawl top domain authorities for Customer Experience knowledge
using the crawl4AI MCP server
"""

import json
import requests
import time
from typing import List, Dict

# MCP server configuration
MCP_SERVER_URL = "http://localhost:8051"

# Domain authorities from the ontology
CUSTOMER_EXPERIENCE_DOMAINS = [
    {
        "url": "https://www.zendesk.com/blog/",
        "description": "Zendesk customer service blog",
        "topics": ["customer service", "support technology", "best practices"]
    },
    {
        "url": "https://www.salesforce.com/resources/articles/customer-service/",
        "description": "Salesforce customer service resources",
        "topics": ["CRM", "customer engagement", "service cloud"]
    },
    {
        "url": "https://www.helpscout.com/blog/",
        "description": "Help Scout customer support blog",
        "topics": ["customer support", "help desk", "team collaboration"]
    },
    {
        "url": "https://www.intercom.com/blog/",
        "description": "Intercom customer messaging blog",
        "topics": ["customer communication", "chatbots", "engagement"]
    },
    {
        "url": "https://customerthink.com/",
        "description": "CustomerThink community insights",
        "topics": ["customer experience", "CX strategy", "industry trends"]
    },
    {
        "url": "https://hbr.org/topic/customer-service",
        "description": "Harvard Business Review customer service",
        "topics": ["leadership", "strategy", "research"]
    }
]

def send_mcp_request(method: str, params: Dict) -> Dict:
    """Send request to MCP server"""
    payload = {
        "jsonrpc": "2.0",
        "method": method,
        "params": params,
        "id": 1
    }
    
    headers = {"Content-Type": "application/json"}
    
    try:
        response = requests.post(MCP_SERVER_URL, json=payload, headers=headers)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"Error sending MCP request: {e}")
        return {"error": str(e)}

def crawl_domain(domain_info: Dict) -> bool:
    """Crawl a single domain using smart_crawl_url"""
    print(f"\nCrawling {domain_info['url']}...")
    
    params = {
        "url": domain_info["url"],
        "max_pages": 50,  # Limit pages per domain
        "tags": ["customer_experience", "vivid_walls"] + domain_info["topics"],
        "metadata": {
            "agent": "CustomerExperienceDirectorAgent",
            "domain_type": "authority",
            "description": domain_info["description"]
        }
    }
    
    result = send_mcp_request("smart_crawl_url", params)
    
    if "error" in result:
        print(f"Error crawling {domain_info['url']}: {result['error']}")
        return False
    
    print(f"Successfully crawled {domain_info['url']}")
    return True

def verify_crawled_data() -> Dict:
    """Check what sources are available in the database"""
    print("\nVerifying crawled data...")
    
    result = send_mcp_request("get_available_sources", {})
    
    if "error" in result:
        print(f"Error getting sources: {result['error']}")
        return {}
    
    return result.get("result", {})

def perform_test_query() -> None:
    """Test RAG query on crawled data"""
    print("\nTesting RAG query...")
    
    test_queries = [
        "What are the best practices for reducing customer churn?",
        "How can we improve first contact resolution rates?",
        "What metrics should we track for customer satisfaction?"
    ]
    
    for query in test_queries:
        print(f"\nQuery: {query}")
        
        params = {
            "query": query,
            "source_filter": "customer_experience",
            "limit": 5
        }
        
        result = send_mcp_request("perform_rag_query", params)
        
        if "error" in result:
            print(f"Error: {result['error']}")
        else:
            response = result.get("result", {})
            print(f"Response: {response.get('answer', 'No answer found')[:200]}...")

def main():
    """Main execution function"""
    print("Starting Customer Experience domain crawling...")
    
    # Track successful crawls
    successful_crawls = 0
    
    # Crawl each domain
    for domain in CUSTOMER_EXPERIENCE_DOMAINS:
        if crawl_domain(domain):
            successful_crawls += 1
            # Add delay between crawls to be respectful
            time.sleep(5)
    
    print(f"\n✓ Crawled {successful_crawls}/{len(CUSTOMER_EXPERIENCE_DOMAINS)} domains successfully")
    
    # Verify what was crawled
    sources = verify_crawled_data()
    if sources:
        print(f"\nAvailable sources: {json.dumps(sources, indent=2)}")
    
    # Test the RAG functionality
    if successful_crawls > 0:
        perform_test_query()

if __name__ == "__main__":
    main()