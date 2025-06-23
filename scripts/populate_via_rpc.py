#!/usr/bin/env python3
"""
Populate agents using Supabase RPC with PostgREST.
This uses a stored procedure for efficient bulk insertion.
"""

import json
import os
from typing import Dict, Any

try:
    from supabase import create_client
except ImportError:
    print("Please install supabase: pip install supabase")
    exit(1)

def load_all_data(data_dir: str = 'mcp_data') -> Dict[str, Any]:
    """Load all JSON data files into a single structure."""
    
    tables = [
        'agents',
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
    
    all_data = {}
    
    for table in tables:
        file_path = os.path.join(data_dir, f"{table}.json")
        if os.path.exists(file_path):
            with open(file_path, 'r') as f:
                all_data[table] = json.load(f)
            print(f"Loaded {len(all_data[table])} records from {table}")
    
    return all_data

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
    
    # Load all data
    print("\nLoading data files...")
    all_data = load_all_data()
    
    print(f"\nTotal tables loaded: {len(all_data)}")
    total_records = sum(len(records) for records in all_data.values())
    print(f"Total records to insert: {total_records}")
    
    # Call RPC function
    print("\nCalling bulk_insert_agents RPC function...")
    try:
        result = supabase.rpc('bulk_insert_agents', {'agent_data': all_data}).execute()
        
        if result.data:
            print("\nResult:")
            print(json.dumps(result.data, indent=2))
        else:
            print("No data returned from RPC call")
            
    except Exception as e:
        print(f"\nError calling RPC: {e}")
        print("\nNote: The bulk_insert_agents function must be created in your database first.")
        print("Run the SQL in 'create_bulk_insert_function.sql' via the Supabase SQL editor.")
        
        # Fallback to direct inserts
        print("\nFalling back to direct table inserts...")
        fallback_direct_inserts(supabase, all_data)

def fallback_direct_inserts(supabase, all_data):
    """Fallback method using direct PostgREST inserts."""
    
    # Order matters due to foreign keys
    insert_order = [
        'agents',  # Parent table first
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
    
    success_count = 0
    
    for table in insert_order:
        if table not in all_data:
            continue
            
        data = all_data[table]
        if not data:
            continue
            
        try:
            # PostgREST supports bulk insert via array
            result = supabase.table(table).insert(data).execute()
            print(f"✓ Inserted {len(data)} records into {table}")
            success_count += len(data)
        except Exception as e:
            print(f"✗ Error with {table}: {e}")
            # Try one by one if bulk fails
            individual_success = 0
            for record in data:
                try:
                    supabase.table(table).insert(record).execute()
                    individual_success += 1
                except:
                    pass
            if individual_success > 0:
                print(f"  → Inserted {individual_success} records individually")
                success_count += individual_success
    
    print(f"\nTotal records inserted: {success_count}")

if __name__ == "__main__":
    main()