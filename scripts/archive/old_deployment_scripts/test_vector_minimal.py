#!/usr/bin/env python3
"""
Minimal test script for vector population - tests only the essentials.
"""

import os
import json
import base64
import requests
import openai

# Configuration
SUPABASE_URL = "http://157.230.13.13:8000"
SUPABASE_SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw"
OPENAI_API_KEY = "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"

# Sample agent knowledge
SAMPLE_KNOWLEDGE = {
    "marketing_director": {
        "content": "Marketing Director oversees all marketing operations including digital marketing, content strategy, campaign management, and brand development for VividWalls premium art business.",
        "metadata": {
            "agent_id": "marketing_director",
            "domain": "marketing",
            "content_type": "role_definition"
        }
    },
    "sales_director": {
        "content": "Sales Director manages all sales operations including B2B and B2C channels, sales team performance, pipeline management, and revenue growth strategies.",
        "metadata": {
            "agent_id": "sales_director",
            "domain": "sales",
            "content_type": "role_definition"
        }
    }
}

def test_basic_setup():
    """Test basic setup and connections."""
    print("Testing Basic Setup...")
    
    # Test 1: OpenAI API
    print("\n1. Testing OpenAI API...")
    try:
        openai.api_key = OPENAI_API_KEY
        response = openai.embeddings.create(
            model="text-embedding-3-small",
            input="test"
        )
        print("✓ OpenAI API works")
    except Exception as e:
        print(f"✗ OpenAI API failed: {e}")
        return False
    
    # Test 2: Supabase connection with basic auth
    print("\n2. Testing Supabase connection...")
    auth_string = base64.b64encode(b"supabase:this_password_is_insecure_and_should_be_updated").decode()
    headers = {
        "Authorization": f"Basic {auth_string}",
        "apikey": SUPABASE_SERVICE_KEY,
        "Content-Type": "application/json"
    }
    
    try:
        response = requests.get(f"{SUPABASE_URL}/rest/v1/", headers=headers, timeout=10)
        if response.status_code == 200:
            print("✓ Supabase connection works")
        else:
            print(f"✗ Supabase returned status {response.status_code}")
            return False
    except Exception as e:
        print(f"✗ Supabase connection failed: {e}")
        return False
    
    return True

def test_populate_sample():
    """Test populating a sample vector."""
    print("\n\nTesting Sample Population...")
    
    # Prepare auth headers
    auth_string = base64.b64encode(b"supabase:this_password_is_insecure_and_should_be_updated").decode()
    headers = {
        "Authorization": f"Basic {auth_string}",
        "apikey": SUPABASE_SERVICE_KEY,
        "Content-Type": "application/json",
        "Prefer": "return=representation"
    }
    
    for agent_name, data in SAMPLE_KNOWLEDGE.items():
        print(f"\nProcessing {agent_name}...")
        
        try:
            # Generate embedding
            response = openai.embeddings.create(
                model="text-embedding-3-small",
                input=data["content"]
            )
            embedding = response.data[0].embedding
            
            # Prepare record
            record = {
                "agent_id": data["metadata"]["agent_id"],
                "collection": f"{agent_name}_vectors",
                "content": data["content"],
                "metadata": data["metadata"],
                "embedding": embedding
            }
            
            # Insert to Supabase
            response = requests.post(
                f"{SUPABASE_URL}/rest/v1/agent_embeddings",
                json=record,
                headers=headers,
                timeout=10
            )
            
            if response.status_code in [200, 201]:
                print(f"✓ Successfully inserted {agent_name}")
            else:
                print(f"✗ Failed to insert {agent_name}: {response.status_code}")
                print(f"  Response: {response.text[:200]}")
                
        except Exception as e:
            print(f"✗ Error processing {agent_name}: {e}")

def print_sql_setup():
    """Print SQL commands for manual setup."""
    print("\n\n=== SQL Setup Commands ===")
    print("Run these in Supabase SQL editor at https://supabase.vividwalls.blog/\n")
    
    sql = """-- Enable vector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Create agent embeddings table
CREATE TABLE IF NOT EXISTS agent_embeddings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    agent_id VARCHAR(255) NOT NULL,
    collection VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    embedding vector(1536),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_agent_embeddings_agent ON agent_embeddings(agent_id);
CREATE INDEX IF NOT EXISTS idx_agent_embeddings_collection ON agent_embeddings(collection);
CREATE INDEX IF NOT EXISTS idx_agent_embeddings_embedding ON agent_embeddings 
    USING ivfflat (embedding vector_cosine_ops);

-- Test query
SELECT COUNT(*) FROM agent_embeddings;"""
    
    print(sql)

def main():
    """Run minimal tests."""
    print("=== Minimal Vector Population Test ===\n")
    
    if test_basic_setup():
        test_populate_sample()
    
    print_sql_setup()
    
    print("\n\n=== Next Steps ===")
    print("1. Check if data was inserted: https://supabase.vividwalls.blog/")
    print("2. If table doesn't exist, run the SQL commands above")
    print("3. Use the full population script after testing succeeds")

if __name__ == "__main__":
    main()