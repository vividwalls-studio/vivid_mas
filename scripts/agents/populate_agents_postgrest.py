#!/usr/bin/env python3
"""
Populate agents using Supabase Python client with PostgREST.
This script works within PostgREST limitations by using bulk inserts.
"""

import json
import os
from typing import List, Dict, Any
import time

# Import Supabase client
try:
    from supabase import create_client, Client
except ImportError:
    print("Please install supabase: pip install supabase")
    exit(1)

def load_json_data(file_path: str) -> List[Dict[str, Any]]:
    """Load JSON data from file."""
    with open(file_path, 'r') as f:
        return json.load(f)

def chunk_data(data: List[Dict], chunk_size: int = 50) -> List[List[Dict]]:
    """Split data into chunks for batch processing."""
    return [data[i:i + chunk_size] for i in range(0, len(data), chunk_size)]

def insert_with_postgrest(supabase: Client, table: str, data: List[Dict]) -> bool:
    """
    Insert data using PostgREST bulk insert.
    PostgREST supports bulk inserts by sending an array in the POST body.
    """
    try:
        # PostgREST bulk insert - send array of objects
        response = supabase.table(table).insert(data).execute()
        print(f"✓ Inserted {len(data)} records into {table}")
        return True
    except Exception as e:
        print(f"✗ Error inserting into {table}: {str(e)}")
        return False

def main():
    # Configuration
    SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://supabase.vividwalls.blog')
    SUPABASE_KEY = os.getenv('SUPABASE_KEY', '')
    
    if not SUPABASE_KEY:
        print("Error: SUPABASE_KEY environment variable not set")
        print("Please set it with: export SUPABASE_KEY='your-key-here'")
        return
    
    # Initialize Supabase client
    print(f"Connecting to Supabase at {SUPABASE_URL}...")
    supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
    
    # Define table insertion order (respects foreign key constraints)
    table_order = [
        'agents',  # Must be first (parent table)
        'agent_beliefs',
        'agent_desires',
        'agent_intentions',
        'agent_heuristic_imperatives',
        'agent_domain_knowledge',
        'agent_personalities',
        'agent_goals',
        'agent_objectives',
        'agent_instructions',
        'agent_rules',
        'agent_llm_config',
        'agent_workflows',
        'agent_skills',
        'agent_tasks',
        'agent_mcp_tools',
        'agent_voice_config'
    ]
    
    # Load and insert data
    data_dir = 'mcp_data'
    total_success = 0
    total_records = 0
    
    print("\nStarting data population...")
    print("=" * 60)
    
    for table in table_order:
        file_path = os.path.join(data_dir, f"{table}.json")
        
        if not os.path.exists(file_path):
            print(f"⚠ Skipping {table} - file not found")
            continue
        
        # Load data
        data = load_json_data(file_path)
        total_records += len(data)
        
        if not data:
            print(f"⚠ Skipping {table} - no data")
            continue
        
        # For large datasets, chunk the inserts
        if len(data) > 100:
            print(f"\nProcessing {table} in chunks ({len(data)} records)...")
            chunks = chunk_data(data, 50)
            
            for i, chunk in enumerate(chunks, 1):
                print(f"  Chunk {i}/{len(chunks)} ({len(chunk)} records)...", end=' ')
                if insert_with_postgrest(supabase, table, chunk):
                    total_success += len(chunk)
                time.sleep(0.5)  # Rate limiting
        else:
            # Small dataset - insert all at once
            if insert_with_postgrest(supabase, table, data):
                total_success += len(data)
    
    print("\n" + "=" * 60)
    print(f"Population complete!")
    print(f"Successfully inserted: {total_success}/{total_records} records")
    
    # Verify agent count
    print("\nVerifying data...")
    try:
        result = supabase.table('agents').select('id', count='exact').execute()
        print(f"Total agents in database: {result.count}")
    except Exception as e:
        print(f"Could not verify: {e}")

if __name__ == "__main__":
    main()