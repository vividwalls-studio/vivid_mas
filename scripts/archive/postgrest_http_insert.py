#!/usr/bin/env python3
"""
Direct PostgREST insertion using HTTP requests.
This bypasses any SDK and talks directly to the PostgREST API.
"""

import json
import os
import requests
import time
from typing import Dict, List, Any

class PostgRESTClient:
    def __init__(self, base_url: str, api_key: str):
        self.base_url = base_url.rstrip('/')
        self.headers = {
            'apikey': api_key,
            'Authorization': f'Bearer {api_key}',
            'Content-Type': 'application/json'
        }
    
    def insert(self, table: str, data: List[Dict[str, Any]], 
               prefer: str = 'return=minimal') -> requests.Response:
        """Insert data into table via PostgREST."""
        url = f"{self.base_url}/rest/v1/{table}"
        headers = {**self.headers, 'Prefer': prefer}
        
        # PostgREST accepts both single objects and arrays
        # Arrays enable bulk insert
        return requests.post(url, json=data, headers=headers)
    
    def upsert(self, table: str, data: List[Dict[str, Any]], 
               on_conflict: str = 'id') -> requests.Response:
        """Upsert data (insert or update on conflict)."""
        url = f"{self.base_url}/rest/v1/{table}?on_conflict={on_conflict}"
        headers = {
            **self.headers,
            'Prefer': 'resolution=merge-duplicates,return=minimal'
        }
        return requests.post(url, json=data, headers=headers)
    
    def select(self, table: str, columns: str = '*', 
               filters: Dict[str, str] = None) -> requests.Response:
        """Select data from table."""
        url = f"{self.base_url}/rest/v1/{table}?select={columns}"
        
        if filters:
            for key, value in filters.items():
                url += f"&{key}={value}"
        
        return requests.get(url, headers=self.headers)
    
    def count(self, table: str) -> int:
        """Get row count for table."""
        headers = {
            **self.headers,
            'Prefer': 'count=exact',
            'Range': '0-0'
        }
        response = requests.get(
            f"{self.base_url}/rest/v1/{table}?select=*",
            headers=headers
        )
        
        if response.status_code == 200:
            # Count is in Content-Range header
            content_range = response.headers.get('Content-Range', '')
            if '/' in content_range:
                return int(content_range.split('/')[-1])
        return 0
    
    def rpc(self, function_name: str, params: Dict[str, Any]) -> requests.Response:
        """Call RPC function."""
        url = f"{self.base_url}/rest/v1/rpc/{function_name}"
        return requests.post(url, json=params, headers=self.headers)


def load_json_file(filepath: str) -> Any:
    """Load JSON data from file."""
    with open(filepath, 'r') as f:
        return json.load(f)


def main():
    # Configuration
    SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://supabase.vividwalls.blog')
    SUPABASE_ANON_KEY = os.getenv('SUPABASE_ANON_KEY', '')
    
    if not SUPABASE_ANON_KEY:
        print("Error: SUPABASE_ANON_KEY not set")
        print("Run: export SUPABASE_ANON_KEY='your-anon-key'")
        return
    
    # Initialize client
    client = PostgRESTClient(SUPABASE_URL, SUPABASE_ANON_KEY)
    
    print("PostgREST Direct HTTP Insertion")
    print("=" * 50)
    print(f"URL: {SUPABASE_URL}")
    print()
    
    # Define tables in dependency order
    tables = [
        'agents',
        'agent_beliefs',
        'agent_desires', 
        'agent_intentions',
        'agent_heuristic_imperatives',
        'agent_domain_knowledge',
        'agent_personalities',
        'agent_goals',
        'agent_llm_config',
        'agent_voice_config'
    ]
    
    # Check current state
    print("Current database state:")
    for table in tables[:3]:  # Check first 3 tables
        count = client.count(table)
        print(f"  {table}: {count} records")
    print()
    
    # Ask for confirmation
    response = input("Proceed with insertion? (y/N): ")
    if response.lower() != 'y':
        print("Cancelled.")
        return
    
    print("\nInserting data...")
    print("-" * 50)
    
    successful = 0
    failed = 0
    
    for table in tables:
        json_path = f"mcp_conversion/{table}.json"
        
        if not os.path.exists(json_path):
            print(f"⚠️  {table}: File not found")
            continue
        
        try:
            # Load data
            data = load_json_file(json_path)
            
            # Insert via PostgREST
            print(f"📤 {table}: Inserting {len(data)} records...", end='', flush=True)
            
            response = client.insert(table, data)
            
            if response.status_code in [200, 201]:
                print(f" ✅ Success")
                successful += 1
            else:
                print(f" ❌ Failed (HTTP {response.status_code})")
                if response.text:
                    print(f"   Error: {response.text}")
                failed += 1
                
        except Exception as e:
            print(f" ❌ Error: {str(e)}")
            failed += 1
        
        # Rate limiting
        time.sleep(0.5)
    
    print("\n" + "=" * 50)
    print(f"Complete! Success: {successful}, Failed: {failed}")
    
    # Verify final count
    print("\nFinal agent count:", client.count('agents'))
    
    # Show sample data
    print("\nSample agents:")
    response = client.select('agents', 'id,name,role', {'limit': '3'})
    if response.status_code == 200:
        agents = response.json()
        for agent in agents:
            print(f"  - {agent['name']} ({agent['role']})")


if __name__ == "__main__":
    main()