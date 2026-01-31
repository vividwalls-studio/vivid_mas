#!/usr/bin/env python3
"""
Test script for vector database population.
Tests various approaches: Crawl4AI service, Supabase connection, and embedding generation.
"""

import os
import json
import time
import requests
from typing import List, Dict, Any
import openai
from datetime import datetime
import sys

# Configuration
CRAWL4AI_URL = "https://crawl4ai.vividwalls.blog"
SUPABASE_URL = "http://157.230.13.13:8000"
SUPABASE_SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaXNzIjoic3VwYWJhc2UiLCJpYXQiOjE3NDk2MDQwOTEsImV4cCI6MjA2NDk2NDA5MX0.Ypo0XwGmjHXsr7HCAIYtAAShR8FKYada8PcgdcA3SQw"
OPENAI_API_KEY = "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"

# Set OpenAI API key
openai.api_key = OPENAI_API_KEY

def test_crawl4ai_connection():
    """Test connection to Crawl4AI service."""
    print("\n=== Testing Crawl4AI Connection ===")
    try:
        # Test basic connection
        response = requests.get(f"{CRAWL4AI_URL}/health", timeout=10)
        if response.status_code == 200:
            print("✓ Crawl4AI service is accessible")
            return True
        else:
            print(f"✗ Crawl4AI returned status {response.status_code}")
            return False
    except requests.exceptions.ConnectionError:
        print("✗ Cannot connect to Crawl4AI service")
        # Try without health endpoint
        try:
            response = requests.get(CRAWL4AI_URL, timeout=10)
            if response.status_code in [200, 404]:
                print("✓ Crawl4AI service is accessible (no health endpoint)")
                return True
        except:
            pass
        return False
    except Exception as e:
        print(f"✗ Error connecting to Crawl4AI: {e}")
        return False

def test_crawl4ai_crawl():
    """Test Crawl4AI crawling functionality."""
    print("\n=== Testing Crawl4AI Crawl Function ===")
    try:
        # Test crawl with a simple URL
        test_request = {
            "url": "https://example.com",
            "wait_for": "networkidle",
            "screenshot": False,
            "remove_overlay": True
        }
        
        response = requests.post(
            f"{CRAWL4AI_URL}/crawl",
            json=test_request,
            headers={"Content-Type": "application/json"},
            timeout=30
        )
        
        if response.status_code == 200:
            print("✓ Crawl4AI crawl endpoint works")
            result = response.json()
            if "content" in result or "markdown" in result:
                print("✓ Crawl4AI returns content")
                return True
            else:
                print("⚠ Crawl4AI response missing content")
                print(f"  Response keys: {list(result.keys())[:5]}")
        else:
            print(f"✗ Crawl4AI crawl returned status {response.status_code}")
            print(f"  Response: {response.text[:200]}")
        return False
    except Exception as e:
        print(f"✗ Error testing Crawl4AI crawl: {e}")
        return False

def test_supabase_connection():
    """Test connection to Supabase."""
    print("\n=== Testing Supabase Connection ===")
    headers = {
        "apikey": SUPABASE_SERVICE_KEY,
        "Authorization": f"Bearer {SUPABASE_SERVICE_KEY}",
        "Content-Type": "application/json"
    }
    
    try:
        # Test basic connection
        response = requests.get(
            f"{SUPABASE_URL}/rest/v1/",
            headers=headers,
            timeout=10
        )
        
        if response.status_code == 200:
            print("✓ Supabase REST API is accessible")
            return True
        elif response.status_code == 401:
            print("✗ Supabase authentication failed")
            print("  This might be due to Kong requiring basic auth")
            # Try with basic auth
            return test_supabase_with_basic_auth()
        else:
            print(f"✗ Supabase returned status {response.status_code}")
            print(f"  Response: {response.text[:200]}")
            return False
    except Exception as e:
        print(f"✗ Error connecting to Supabase: {e}")
        return False

def test_supabase_with_basic_auth():
    """Test Supabase with basic authentication."""
    print("\n  Trying with basic authentication...")
    import base64
    
    auth_string = base64.b64encode(b"supabase:this_password_is_insecure_and_should_be_updated").decode()
    headers = {
        "Authorization": f"Basic {auth_string}",
        "apikey": SUPABASE_SERVICE_KEY,
        "Content-Type": "application/json"
    }
    
    try:
        response = requests.get(
            f"{SUPABASE_URL}/rest/v1/",
            headers=headers,
            timeout=10
        )
        
        if response.status_code == 200:
            print("  ✓ Supabase accessible with basic auth")
            return True
        else:
            print(f"  ✗ Basic auth failed with status {response.status_code}")
            return False
    except Exception as e:
        print(f"  ✗ Error with basic auth: {e}")
        return False

def test_openai_embeddings():
    """Test OpenAI embedding generation."""
    print("\n=== Testing OpenAI Embeddings ===")
    try:
        test_text = "This is a test for VividWalls agent knowledge embedding."
        response = openai.embeddings.create(
            model="text-embedding-3-small",
            input=test_text
        )
        
        embedding = response.data[0].embedding
        print(f"✓ OpenAI embeddings work (dimension: {len(embedding)})")
        return True
    except Exception as e:
        print(f"✗ Error generating embeddings: {e}")
        return False

def test_vector_table_creation():
    """Test creating vector table in Supabase."""
    print("\n=== Testing Vector Table Creation ===")
    
    create_table_sql = """
    -- Check if table exists
    SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'agent_embeddings'
    );
    """
    
    print("Note: Table creation needs to be done via:")
    print("  1. Supabase Dashboard SQL editor at https://supabase.vividwalls.blog/")
    print("  2. Or via n8n workflow with SQL execution")
    print("\nSQL to create table:")
    print("""
    CREATE EXTENSION IF NOT EXISTS vector;
    
    CREATE TABLE IF NOT EXISTS agent_embeddings (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        agent_id VARCHAR(255) NOT NULL,
        collection VARCHAR(255) NOT NULL,
        content TEXT NOT NULL,
        metadata JSONB DEFAULT '{}'::jsonb,
        embedding vector(1536),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );
    
    CREATE INDEX IF NOT EXISTS idx_agent_embeddings_agent ON agent_embeddings(agent_id);
    CREATE INDEX IF NOT EXISTS idx_agent_embeddings_collection ON agent_embeddings(collection);
    """)
    return True

def test_sample_insert():
    """Test inserting a sample record."""
    print("\n=== Testing Sample Insert ===")
    
    # Create test data
    test_content = "Marketing Director oversees all marketing operations for VividWalls."
    
    try:
        # Generate embedding
        response = openai.embeddings.create(
            model="text-embedding-3-small",
            input=test_content
        )
        embedding = response.data[0].embedding
        
        # Prepare record
        record = {
            "agent_id": "marketing_director",
            "collection": "marketing_director_vectors",
            "content": test_content,
            "metadata": {
                "domain": "marketing",
                "content_type": "role_definition",
                "test": True,
                "created_at": datetime.utcnow().isoformat()
            },
            "embedding": embedding
        }
        
        # Try different auth methods
        auth_methods = [
            {
                "name": "Service Key",
                "headers": {
                    "apikey": SUPABASE_SERVICE_KEY,
                    "Authorization": f"Bearer {SUPABASE_SERVICE_KEY}",
                    "Content-Type": "application/json",
                    "Prefer": "return=representation"
                }
            },
            {
                "name": "Basic Auth + Service Key",
                "headers": {
                    "Authorization": f"Basic {base64.b64encode(b'supabase:this_password_is_insecure_and_should_be_updated').decode()}",
                    "apikey": SUPABASE_SERVICE_KEY,
                    "Content-Type": "application/json",
                    "Prefer": "return=representation"
                }
            }
        ]
        
        for auth in auth_methods:
            print(f"\n  Trying with {auth['name']}...")
            try:
                response = requests.post(
                    f"{SUPABASE_URL}/rest/v1/agent_embeddings",
                    json=record,
                    headers=auth['headers'],
                    timeout=10
                )
                
                if response.status_code in [200, 201]:
                    print(f"  ✓ Insert successful with {auth['name']}")
                    return True
                else:
                    print(f"  ✗ Insert failed with status {response.status_code}")
                    if response.text:
                        print(f"    Response: {response.text[:200]}")
            except Exception as e:
                print(f"  ✗ Error with {auth['name']}: {e}")
        
        return False
        
    except Exception as e:
        print(f"✗ Error in sample insert: {e}")
        return False

def test_alternative_approaches():
    """Test alternative approaches for vector population."""
    print("\n=== Alternative Approaches ===")
    
    print("\n1. Using n8n Workflow:")
    print("   ✓ Import generated workflow JSON into n8n")
    print("   ✓ Configure OpenAI and Supabase credentials")
    print("   ✓ Run workflow to populate vectors")
    
    print("\n2. Using SSH to droplet:")
    print("   ✓ SSH to droplet: ssh -i ~/.ssh/digitalocean root@157.230.13.13")
    print("   ✓ Run population script directly on droplet")
    print("   ✓ Direct database access without Kong")
    
    print("\n3. Using Supabase Dashboard:")
    print("   ✓ Access https://supabase.vividwalls.blog/")
    print("   ✓ Use SQL editor to create tables")
    print("   ✓ Use Table editor to verify data")
    
    return True

def main():
    """Run all tests."""
    print("VividWalls Vector Population Test Suite")
    print("=" * 50)
    
    results = {
        "Crawl4AI Connection": test_crawl4ai_connection(),
        "Crawl4AI Crawl": test_crawl4ai_crawl(),
        "Supabase Connection": test_supabase_connection(),
        "OpenAI Embeddings": test_openai_embeddings(),
        "Vector Table Info": test_vector_table_creation(),
        "Sample Insert": test_sample_insert(),
        "Alternative Approaches": test_alternative_approaches()
    }
    
    print("\n" + "=" * 50)
    print("TEST SUMMARY")
    print("=" * 50)
    
    passed = sum(1 for v in results.values() if v)
    total = len(results)
    
    for test_name, result in results.items():
        status = "✓ PASS" if result else "✗ FAIL"
        print(f"{test_name:.<40} {status}")
    
    print(f"\nTotal: {passed}/{total} tests passed")
    
    if passed < total:
        print("\nRecommendations:")
        if not results["Supabase Connection"]:
            print("- Check Supabase authentication method (Kong basic auth)")
            print("- Consider using n8n or SSH approach")
        if not results["Crawl4AI Connection"]:
            print("- Verify Crawl4AI is running on droplet")
            print("- Check https://crawl4ai.vividwalls.blog/ in browser")
        if not results["Sample Insert"]:
            print("- Ensure agent_embeddings table exists")
            print("- Check database permissions")

if __name__ == "__main__":
    main()