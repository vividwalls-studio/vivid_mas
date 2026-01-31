#!/usr/bin/env python3
"""
Populate Supabase vector database using Crawl4AI service running on droplet.
This script reads agent prompts and uses the Crawl4AI service to process and store them.
"""

import os
import json
import time
import requests
from typing import List, Dict, Any
from pathlib import Path
from supabase import create_client, Client
import openai
from datetime import datetime

# Configuration
CRAWL4AI_URL = "https://crawl4ai.vividwalls.blog"
SUPABASE_URL = "http://157.230.13.13:8000"
SUPABASE_SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw"
OPENAI_API_KEY = "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"

# Set OpenAI API key
openai.api_key = OPENAI_API_KEY

# Paths
PROMPTS_DIR = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/prompts")
KNOWLEDGE_GATHERER_FILES = [
    "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/copywriting_knowledge_gatherer_agent.json",
    "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/customer_experience_knowledge_gatherer_agent.json",
    "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/facebook_marketing_knowledge_gatherer_agent.json",
    "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/finance_analytics_knowledge_gatherer_agent.json",
    "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/instagram_marketing_knowledge_gatherer_agent.json",
    "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/marketing_director_mcp_integration_example.json",
    "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/operations_knowledge_gatherer_agent.json",
    "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/pinterest_marketing_knowledge_gatherer_agent.json",
    "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/sales_agent_knowledge_enhanced_example.json",
    "/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/agents/technology_automation_knowledge_gatherer_agent.json"
]

def read_prompt_files() -> Dict[str, Dict[str, Any]]:
    """Read all agent prompt files and organize by agent type."""
    agent_knowledge = {}
    
    # Read markdown prompts from prompts directory
    prompt_dirs = ["core", "marketing", "operational", "knowledge-gathering"]
    
    for prompt_dir in prompt_dirs:
        dir_path = PROMPTS_DIR / prompt_dir
        if dir_path.exists():
            for file_path in dir_path.glob("*.md"):
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    # Extract agent name from file
                    agent_name = file_path.stem.replace("_system_prompt", "").replace("_agent", "")
                    
                    # Determine domain from directory
                    domain = prompt_dir if prompt_dir != "knowledge-gathering" else "knowledge"
                    
                    if agent_name not in agent_knowledge:
                        agent_knowledge[agent_name] = {
                            "agent_id": agent_name,
                            "domain": domain,
                            "knowledge": []
                        }
                    
                    # Parse content sections
                    sections = parse_markdown_sections(content)
                    for section in sections:
                        agent_knowledge[agent_name]["knowledge"].append({
                            "content": section["content"],
                            "content_type": section["type"],
                            "source": str(file_path)
                        })
                    
                except Exception as e:
                    print(f"Error reading {file_path}: {e}")
    
    # Read JSON knowledge gatherer files
    for json_file in KNOWLEDGE_GATHERER_FILES:
        if Path(json_file).exists():
            try:
                with open(json_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                
                agent_name = Path(json_file).stem.replace("_knowledge_gatherer_agent", "").replace("_example", "")
                
                if agent_name not in agent_knowledge:
                    agent_knowledge[agent_name] = {
                        "agent_id": agent_name,
                        "domain": "integration",
                        "knowledge": []
                    }
                
                # Extract workflow description
                if "nodes" in data:
                    for node in data.get("nodes", []):
                        if node.get("type") == "n8n-nodes-base.stickyNote":
                            content = node.get("parameters", {}).get("content", "")
                            if content:
                                agent_knowledge[agent_name]["knowledge"].append({
                                    "content": content,
                                    "content_type": "workflow_description",
                                    "source": json_file
                                })
                
            except Exception as e:
                print(f"Error reading {json_file}: {e}")
    
    return agent_knowledge

def parse_markdown_sections(content: str) -> List[Dict[str, str]]:
    """Parse markdown content into sections."""
    sections = []
    
    # Split by headers
    lines = content.split('\n')
    current_section = []
    current_header = ""
    
    for line in lines:
        if line.startswith('#'):
            # Save previous section
            if current_section and current_header:
                section_content = '\n'.join(current_section).strip()
                if section_content:
                    sections.append({
                        "type": normalize_section_type(current_header),
                        "content": section_content
                    })
            
            # Start new section
            current_header = line.strip('#').strip()
            current_section = []
        else:
            current_section.append(line)
    
    # Save last section
    if current_section and current_header:
        section_content = '\n'.join(current_section).strip()
        if section_content:
            sections.append({
                "type": normalize_section_type(current_header),
                "content": section_content
            })
    
    return sections

def normalize_section_type(header: str) -> str:
    """Normalize section headers to content types."""
    header_lower = header.lower()
    
    if "role" in header_lower or "purpose" in header_lower:
        return "role_definition"
    elif "responsibilit" in header_lower:
        return "responsibilities"
    elif "knowledge domain" in header_lower or "domain" in header_lower:
        return "knowledge_domains"
    elif "strateg" in header_lower:
        return "strategy"
    elif "tool" in header_lower or "mcp" in header_lower:
        return "tools_usage"
    elif "metric" in header_lower or "kpi" in header_lower:
        return "performance_metrics"
    elif "source" in header_lower:
        return "authority_sources"
    elif "integration" in header_lower:
        return "integration_patterns"
    else:
        return "general_knowledge"

def create_embedding(text: str) -> List[float]:
    """Create an embedding using OpenAI's API."""
    max_retries = 3
    retry_delay = 1.0
    
    for retry in range(max_retries):
        try:
            response = openai.embeddings.create(
                model="text-embedding-3-small",
                input=text
            )
            return response.data[0].embedding
        except Exception as e:
            if retry < max_retries - 1:
                print(f"Error creating embedding (attempt {retry + 1}/{max_retries}): {e}")
                time.sleep(retry_delay)
                retry_delay *= 2
            else:
                print(f"Failed to create embedding after {max_retries} attempts: {e}")
                return [0.0] * 1536

def process_with_crawl4ai(content: str, metadata: Dict[str, Any]) -> Dict[str, Any]:
    """Process content using Crawl4AI service for enhanced extraction."""
    try:
        # Prepare request for Crawl4AI
        crawl_request = {
            "url": f"data:text/plain,{content[:1000]}",  # Use data URL for text content
            "wait_for": "networkidle",
            "screenshot": False,
            "extractors": [
                {
                    "type": "schema",
                    "schema": {
                        "type": "object",
                        "properties": {
                            "key_concepts": {"type": "array", "items": {"type": "string"}},
                            "domain_terms": {"type": "array", "items": {"type": "string"}},
                            "relationships": {"type": "array", "items": {"type": "string"}},
                            "summary": {"type": "string"}
                        }
                    }
                }
            ]
        }
        
        # Send request to Crawl4AI
        response = requests.post(
            f"{CRAWL4AI_URL}/crawl",
            json=crawl_request,
            headers={"Content-Type": "application/json"},
            timeout=30
        )
        
        if response.status_code == 200:
            result = response.json()
            extracted_data = result.get("extracted_data", {})
            
            # Enhance metadata with extracted information
            if extracted_data:
                metadata["key_concepts"] = extracted_data.get("key_concepts", [])
                metadata["domain_terms"] = extracted_data.get("domain_terms", [])
                metadata["relationships"] = extracted_data.get("relationships", [])
                metadata["ai_summary"] = extracted_data.get("summary", "")
            
            return metadata
        else:
            print(f"Crawl4AI request failed with status {response.status_code}")
            return metadata
            
    except Exception as e:
        print(f"Error processing with Crawl4AI: {e}")
        return metadata

def populate_supabase(agent_knowledge: Dict[str, Dict[str, Any]]):
    """Populate Supabase with agent knowledge."""
    print(f"Connecting to Supabase at: {SUPABASE_URL}")
    
    try:
        # Create Supabase client
        supabase = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)
        
        # Create embeddings table if not exists
        create_table_sql = """
        CREATE TABLE IF NOT EXISTS agent_embeddings (
            id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
            agent_id VARCHAR(255) NOT NULL,
            collection VARCHAR(255) NOT NULL,
            content TEXT NOT NULL,
            metadata JSONB DEFAULT '{}'::jsonb,
            embedding vector(1536),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );
        
        CREATE INDEX IF NOT EXISTS idx_agent_embeddings_agent ON agent_embeddings(agent_id);
        CREATE INDEX IF NOT EXISTS idx_agent_embeddings_collection ON agent_embeddings(collection);
        CREATE INDEX IF NOT EXISTS idx_agent_embeddings_metadata ON agent_embeddings USING GIN(metadata);
        """
        
        # Note: Table creation would need to be done via SQL editor or migration
        
    except Exception as e:
        print(f"Failed to connect to Supabase: {e}")
        print("\nUsing direct HTTP API approach instead...")
        
        # Use direct HTTP API
        headers = {
            "apikey": SUPABASE_SERVICE_KEY,
            "Authorization": f"Bearer {SUPABASE_SERVICE_KEY}",
            "Content-Type": "application/json"
        }
        
        total_processed = 0
        
        for agent_name, agent_data in agent_knowledge.items():
            print(f"\nProcessing {agent_name}...")
            
            collection_name = f"{agent_name}_vectors"
            
            for item in agent_data["knowledge"]:
                try:
                    # Create embedding
                    embedding = create_embedding(item["content"])
                    
                    # Prepare metadata
                    metadata = {
                        "agent_id": agent_data["agent_id"],
                        "domain": agent_data["domain"],
                        "content_type": item["content_type"],
                        "source": item["source"],
                        "collection": collection_name,
                        "created_at": datetime.utcnow().isoformat()
                    }
                    
                    # Enhance with Crawl4AI if possible
                    metadata = process_with_crawl4ai(item["content"], metadata)
                    
                    # Prepare data for insertion
                    record = {
                        "agent_id": agent_data["agent_id"],
                        "collection": collection_name,
                        "content": item["content"],
                        "metadata": metadata,
                        "embedding": embedding
                    }
                    
                    # Insert via REST API
                    response = requests.post(
                        f"{SUPABASE_URL}/rest/v1/agent_embeddings",
                        json=record,
                        headers=headers
                    )
                    
                    if response.status_code in [200, 201]:
                        print(f"  ✓ Added: {item['content_type']} - {item['content'][:50]}...")
                        total_processed += 1
                    else:
                        print(f"  ✗ Failed to insert: {response.status_code} - {response.text}")
                    
                except Exception as e:
                    print(f"  ✗ Error processing item: {e}")
                
                # Rate limiting
                time.sleep(0.5)
        
        print(f"\n✓ Total records processed: {total_processed}")

def main():
    """Main function to populate agent vector collections."""
    print("Starting agent knowledge extraction and population...")
    
    # Read all agent prompt files
    print("\n1. Reading agent prompt files...")
    agent_knowledge = read_prompt_files()
    
    print(f"   Found knowledge for {len(agent_knowledge)} agents:")
    for agent_name, data in agent_knowledge.items():
        print(f"   - {agent_name}: {len(data['knowledge'])} knowledge items")
    
    # Populate Supabase
    print("\n2. Populating Supabase vector database...")
    populate_supabase(agent_knowledge)
    
    print("\n✓ Population complete!")
    print("\nNext steps:")
    print("1. Verify data in Supabase Dashboard at https://supabase.vividwalls.blog/")
    print("2. Test vector search functionality")
    print("3. Configure n8n workflows to use these collections")
    print("4. Set up regular knowledge updates via Crawl4AI")

if __name__ == "__main__":
    main()