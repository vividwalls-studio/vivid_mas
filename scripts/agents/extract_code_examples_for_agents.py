#!/usr/bin/env python3
"""
Extract code examples for technical agents using crawl4ai patterns.
Implements the extract_code_blocks and code example storage patterns from crawl4ai_mcp.py.
"""

import os
import json
import requests
import openai
import base64
import time
import re
from typing import List, Dict, Any, Optional
from urllib.parse import urlparse
import concurrent.futures

# Configuration
CRAWL4AI_URL = "https://crawl4ai.vividwalls.blog"
SUPABASE_URL = "http://157.230.13.13:8000"
SUPABASE_SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw"
OPENAI_API_KEY = "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"

# Set OpenAI API key
openai.api_key = OPENAI_API_KEY

# Headers for Supabase
AUTH_STRING = base64.b64encode(b"supabase:this_password_is_insecure_and_should_be_updated").decode()
SUPABASE_HEADERS = {
    "Authorization": f"Basic {AUTH_STRING}",
    "apikey": SUPABASE_SERVICE_KEY,
    "Content-Type": "application/json",
    "Prefer": "return=representation"
}

# Technical documentation sources for code examples
TECHNICAL_SOURCES = {
    "shopify_integration": {
        "urls": [
            "https://shopify.dev/docs/api/admin-rest",
            "https://shopify.dev/docs/apps/getting-started",
            "https://shopify.dev/docs/api/liquid"
        ],
        "topics": ["Shopify API", "Liquid templates", "App development"]
    },
    "n8n_workflows": {
        "urls": [
            "https://docs.n8n.io/code-examples/",
            "https://docs.n8n.io/integrations/",
            "https://docs.n8n.io/workflows/"
        ],
        "topics": ["n8n automation", "workflow examples", "node development"]
    },
    "ai_integration": {
        "urls": [
            "https://platform.openai.com/docs/guides/text-generation",
            "https://platform.openai.com/docs/guides/embeddings",
            "https://docs.anthropic.com/claude/docs"
        ],
        "topics": ["AI API integration", "prompt engineering", "embeddings"]
    },
    "ecommerce_patterns": {
        "urls": [
            "https://stripe.com/docs/payments",
            "https://developers.google.com/analytics/devguides/collection/ga4",
            "https://developers.facebook.com/docs/marketing-api"
        ],
        "topics": ["payment processing", "analytics tracking", "marketing APIs"]
    }
}

def extract_code_blocks(markdown_content: str, min_length: int = 100) -> List[Dict[str, Any]]:
    """
    Extract code blocks from markdown content along with context.
    Based on the pattern from crawl4ai_mcp.py.
    """
    code_blocks = []
    
    # Skip if content starts with triple backticks
    content = markdown_content.strip()
    start_offset = 0
    if content.startswith('```'):
        start_offset = 3
    
    # Find all occurrences of triple backticks
    backtick_positions = []
    pos = start_offset
    while True:
        pos = markdown_content.find('```', pos)
        if pos == -1:
            break
        backtick_positions.append(pos)
        pos += 3
    
    # Process pairs of backticks
    i = 0
    while i < len(backtick_positions) - 1:
        start_pos = backtick_positions[i]
        end_pos = backtick_positions[i + 1]
        
        # Extract the content between backticks
        code_section = markdown_content[start_pos+3:end_pos]
        
        # Check if there's a language specifier on the first line
        lines = code_section.split('\n', 1)
        if len(lines) > 1:
            first_line = lines[0].strip()
            if first_line and not ' ' in first_line and len(first_line) < 20:
                language = first_line
                code_content = lines[1].strip() if len(lines) > 1 else ""
            else:
                language = ""
                code_content = code_section.strip()
        else:
            language = ""
            code_content = code_section.strip()
        
        # Skip if code block is too short
        if len(code_content) < min_length:
            i += 2
            continue
        
        # Extract context before (500 chars)
        context_start = max(0, start_pos - 500)
        context_before = markdown_content[context_start:start_pos].strip()
        
        # Extract context after (500 chars)
        context_end = min(len(markdown_content), end_pos + 3 + 500)
        context_after = markdown_content[end_pos + 3:context_end].strip()
        
        code_blocks.append({
            'code': code_content,
            'language': language,
            'context_before': context_before,
            'context_after': context_after,
            'full_context': f"{context_before}\n\n{code_content}\n\n{context_after}"
        })
        
        # Move to next pair
        i += 2
    
    return code_blocks

def generate_code_example_summary(code: str, context_before: str, context_after: str, topic: str) -> str:
    """Generate a summary for a code example using its surrounding context."""
    try:
        prompt = f"""<context_before>
{context_before[-300:] if len(context_before) > 300 else context_before}
</context_before>

<code_example>
{code[:1000] if len(code) > 1000 else code}
</code_example>

<context_after>
{context_after[:300] if len(context_after) > 300 else context_after}
</context_after>

Topic: {topic}

Provide a concise summary (2-3 sentences) that describes what this code example demonstrates and its practical application for {topic}."""

        response = openai.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a technical documentation expert providing concise code example summaries."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.3,
            max_tokens=100
        )
        
        return response.choices[0].message.content.strip()
    
    except Exception as e:
        print(f"Error generating code example summary: {e}")
        return f"Code example for {topic}"

def crawl_and_extract_code(url: str, topic: str) -> List[Dict[str, Any]]:
    """Crawl a URL and extract code examples."""
    try:
        # Crawl the page
        request_data = {
            "url": url,
            "wait_for": "networkidle",
            "screenshot": False,
            "remove_overlay": True,
            "bypass_cache": True
        }
        
        response = requests.post(
            f"{CRAWL4AI_URL}/crawl",
            json=request_data,
            headers={"Content-Type": "application/json"},
            timeout=60
        )
        
        if response.status_code != 200:
            print(f"  Failed to crawl {url}: {response.status_code}")
            return []
        
        result = response.json()
        content = result.get("markdown") or result.get("content") or result.get("text", "")
        
        if not content:
            return []
        
        # Extract code blocks
        code_blocks = extract_code_blocks(content)
        
        if not code_blocks:
            return []
        
        print(f"  Found {len(code_blocks)} code examples in {url}")
        
        # Generate summaries for each code block
        enriched_blocks = []
        for block in code_blocks:
            summary = generate_code_example_summary(
                block['code'],
                block['context_before'],
                block['context_after'],
                topic
            )
            
            enriched_blocks.append({
                'url': url,
                'code': block['code'],
                'language': block['language'],
                'summary': summary,
                'topic': topic,
                'context_before': block['context_before'],
                'context_after': block['context_after']
            })
        
        return enriched_blocks
        
    except Exception as e:
        print(f"  Error processing {url}: {e}")
        return []

def create_embeddings_batch(texts: List[str]) -> List[List[float]]:
    """Create embeddings for multiple texts."""
    if not texts:
        return []
    
    try:
        response = openai.embeddings.create(
            model="text-embedding-3-small",
            input=texts
        )
        return [item.embedding for item in response.data]
    except Exception as e:
        print(f"Error creating embeddings: {e}")
        return [[0.0] * 1536 for _ in texts]

def store_code_examples(examples: List[Dict[str, Any]], collection: str):
    """Store code examples in Supabase with embeddings."""
    if not examples:
        return
    
    print(f"\nStoring {len(examples)} code examples...")
    
    # Create table if needed
    create_table_sql = """
    CREATE TABLE IF NOT EXISTS code_examples (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        url VARCHAR(500) NOT NULL,
        collection VARCHAR(255) NOT NULL,
        code TEXT NOT NULL,
        language VARCHAR(50),
        summary TEXT,
        topic VARCHAR(255),
        metadata JSONB DEFAULT '{}'::jsonb,
        embedding vector(1536),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );
    
    CREATE INDEX IF NOT EXISTS idx_code_examples_collection ON code_examples(collection);
    CREATE INDEX IF NOT EXISTS idx_code_examples_topic ON code_examples(topic);
    CREATE INDEX IF NOT EXISTS idx_code_examples_embedding ON code_examples 
        USING ivfflat (embedding vector_cosine_ops);
    """
    
    batch_size = 10
    successful = 0
    
    for i in range(0, len(examples), batch_size):
        batch = examples[i:i + batch_size]
        
        # Create embeddings for batch
        texts = [f"{ex['code']}\n\nSummary: {ex['summary']}" for ex in batch]
        embeddings = create_embeddings_batch(texts)
        
        # Prepare records
        records = []
        for j, (example, embedding) in enumerate(zip(batch, embeddings)):
            parsed_url = urlparse(example['url'])
            source_id = parsed_url.netloc or parsed_url.path
            
            record = {
                'url': example['url'],
                'collection': collection,
                'code': example['code'],
                'language': example.get('language', ''),
                'summary': example['summary'],
                'topic': example['topic'],
                'metadata': {
                    'source_id': source_id,
                    'context_length': len(example.get('context_before', '')) + len(example.get('context_after', ''))
                },
                'embedding': embedding
            }
            records.append(record)
        
        # Store in Supabase
        try:
            response = requests.post(
                f"{SUPABASE_URL}/rest/v1/code_examples",
                json=records,
                headers=SUPABASE_HEADERS,
                timeout=30
            )
            
            if response.status_code in [200, 201]:
                successful += len(records)
            else:
                print(f"  Failed to store batch: {response.status_code}")
                if response.status_code == 404:
                    print("  Table 'code_examples' does not exist. Create it using:")
                    print(create_table_sql)
                    
        except Exception as e:
            print(f"  Error storing batch: {e}")
    
    print(f"  ✓ Successfully stored {successful}/{len(examples)} code examples")

def extract_code_for_agents():
    """Extract code examples relevant to different agent types."""
    all_examples = []
    
    # Technology Director and related technical agents
    print("\n" + "="*60)
    print("Extracting Code Examples for Technical Agents")
    print("="*60)
    
    for category, config in TECHNICAL_SOURCES.items():
        print(f"\nProcessing {category}...")
        category_examples = []
        
        for url in config['urls']:
            print(f"  Crawling: {url}")
            examples = crawl_and_extract_code(url, config['topics'][0])
            category_examples.extend(examples)
            time.sleep(2)  # Rate limiting
        
        if category_examples:
            # Store by category
            store_code_examples(category_examples, f"{category}_code_examples")
            all_examples.extend(category_examples)
    
    # Agent-specific code examples
    agent_code_mappings = {
        "technology_director": ["n8n_workflows", "ai_integration"],
        "marketing_director": ["shopify_integration", "ecommerce_patterns"],
        "analytics_director": ["ai_integration", "ecommerce_patterns"],
        "operations_director": ["n8n_workflows", "shopify_integration"]
    }
    
    print("\n" + "="*60)
    print("Mapping Code Examples to Agents")
    print("="*60)
    
    for agent_id, categories in agent_code_mappings.items():
        agent_examples = [ex for ex in all_examples if any(cat in ex.get('topic', '') for cat in categories)]
        if agent_examples:
            print(f"\n{agent_id}: {len(agent_examples)} relevant code examples")
            store_code_examples(agent_examples, f"{agent_id}_code_vectors")

def search_code_examples_test():
    """Test searching for code examples."""
    print("\n" + "="*60)
    print("Testing Code Example Search")
    print("="*60)
    
    test_queries = [
        "Shopify API authentication",
        "n8n webhook setup",
        "OpenAI embeddings example",
        "Stripe payment integration"
    ]
    
    for query in test_queries:
        print(f"\nSearching for: {query}")
        
        # Create query embedding
        query_embedding = create_embeddings_batch([f"Code example for {query}"])[0]
        
        # This would normally use the Supabase RPC function
        print(f"  Would search with embedding dimension: {len(query_embedding)}")

def main():
    """Main execution function."""
    print("Code Example Extraction for VividWalls Agents")
    print("Using patterns from crawl4ai_mcp.py")
    print("="*70)
    
    # Test basic crawl
    print("\nTesting code extraction...")
    test_url = "https://platform.openai.com/docs/guides/embeddings"
    test_examples = crawl_and_extract_code(test_url, "OpenAI Embeddings")
    print(f"✓ Test extraction found {len(test_examples)} examples")
    
    # Extract code examples
    extract_code_for_agents()
    
    # Test search
    search_code_examples_test()
    
    print("\n" + "="*70)
    print("CODE EXTRACTION COMPLETE")
    print("="*70)
    print("\nCode examples have been:")
    print("- Extracted from technical documentation")
    print("- Summarized with context")
    print("- Embedded for semantic search")
    print("- Organized by topic and agent")
    
    print("\nSQL to create code_examples table:")
    print("""
CREATE TABLE IF NOT EXISTS code_examples (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    url VARCHAR(500) NOT NULL,
    collection VARCHAR(255) NOT NULL,
    code TEXT NOT NULL,
    language VARCHAR(50),
    summary TEXT,
    topic VARCHAR(255),
    metadata JSONB DEFAULT '{}'::jsonb,
    embedding vector(1536),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create search function
CREATE OR REPLACE FUNCTION search_code_examples(
    query_embedding vector(1536),
    collection_filter text DEFAULT NULL,
    match_count int DEFAULT 10
)
RETURNS TABLE (
    id UUID,
    code TEXT,
    summary TEXT,
    language VARCHAR(50),
    url VARCHAR(500),
    similarity float
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ce.id,
        ce.code,
        ce.summary,
        ce.language,
        ce.url,
        1 - (ce.embedding <=> query_embedding) as similarity
    FROM code_examples ce
    WHERE (collection_filter IS NULL OR ce.collection = collection_filter)
    ORDER BY ce.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;
""")

if __name__ == "__main__":
    main()