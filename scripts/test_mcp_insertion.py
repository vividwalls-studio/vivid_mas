#!/usr/bin/env python3
"""
Test MCP server insertion capabilities step by step.
This script will help debug and execute the MCP insertions.
"""

import json
import os
import sys

def load_json_file(file_path):
    """Load JSON data from file."""
    with open(file_path, 'r') as f:
        return json.load(f)

def test_single_agent_insert():
    """Test inserting a single agent record."""
    print("\n" + "="*60)
    print("TEST 1: Single Agent Insert")
    print("="*60)
    
    # Create a minimal test agent
    test_agent = {
        "id": "test-agent-001",
        "name": "TestAgent",
        "role": "Test Role",
        "backstory": "Test backstory",
        "short_term_memory": "Test STM",
        "long_term_memory": "Test LTM",
        "episodic_memory": "Test EM"
    }
    
    print("\nTest agent data:")
    print(json.dumps(test_agent, indent=2))
    
    print("\nMCP Command structure:")
    print(json.dumps({
        "tool": "mcp__supabase-server__insert-data",
        "parameters": {
            "table": "agents",
            "data": test_agent
        }
    }, indent=2))
    
    return test_agent

def test_bulk_agent_insert():
    """Test inserting multiple agents at once."""
    print("\n" + "="*60)
    print("TEST 2: Bulk Agent Insert")
    print("="*60)
    
    # Load first 3 agents from converted data
    agents_file = "mcp_conversion/agents.json"
    if os.path.exists(agents_file):
        all_agents = load_json_file(agents_file)
        test_agents = all_agents[:3]  # First 3 agents
        
        print(f"\nTesting bulk insert with {len(test_agents)} agents:")
        for agent in test_agents:
            print(f"  - {agent['name']} ({agent['id']})")
        
        print("\nMCP Command structure:")
        print(json.dumps({
            "tool": "mcp__supabase-server__insert-data",
            "parameters": {
                "table": "agents",
                "data": test_agents  # Array for bulk insert
            }
        }, indent=2))
        
        return test_agents
    else:
        print("Error: agents.json not found")
        return None

def create_postgrest_curl_test():
    """Create curl commands to test PostgREST directly."""
    print("\n" + "="*60)
    print("TEST 3: Direct PostgREST curl commands")
    print("="*60)
    
    # Get environment variables
    SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://supabase.vividwalls.blog')
    SUPABASE_KEY = os.getenv('SUPABASE_KEY', 'your-key-here')
    
    if SUPABASE_KEY == 'your-key-here':
        print("\nWARNING: SUPABASE_KEY environment variable not set!")
        print("Set it with: export SUPABASE_KEY='your-anon-or-service-key'")
        return
    
    # Create test curl commands
    curl_commands = f"""
# Test connection - List agents table
curl -X GET \\
  "{SUPABASE_URL}/rest/v1/agents?select=id,name&limit=1" \\
  -H "apikey: {SUPABASE_KEY}" \\
  -H "Authorization: Bearer {SUPABASE_KEY}"

# Insert single agent
curl -X POST \\
  "{SUPABASE_URL}/rest/v1/agents" \\
  -H "apikey: {SUPABASE_KEY}" \\
  -H "Authorization: Bearer {SUPABASE_KEY}" \\
  -H "Content-Type: application/json" \\
  -H "Prefer: return=representation" \\
  -d '{{"id": "test-001", "name": "TestAgent", "role": "Test"}}'

# Bulk insert agents
curl -X POST \\
  "{SUPABASE_URL}/rest/v1/agents" \\
  -H "apikey: {SUPABASE_KEY}" \\
  -H "Authorization: Bearer {SUPABASE_KEY}" \\
  -H "Content-Type: application/json" \\
  -H "Prefer: return=minimal" \\
  -d '[{{"id": "test-002", "name": "Agent2"}}, {{"id": "test-003", "name": "Agent3"}}]'
"""
    
    print("\nCurl commands for testing:")
    print(curl_commands)
    
    # Save to file
    with open('test_postgrest_curl.sh', 'w') as f:
        f.write("#!/bin/bash\n")
        f.write(f"# PostgREST API test commands\n")
        f.write(f"# Generated: {os.popen('date').read().strip()}\n\n")
        f.write(f"SUPABASE_URL='{SUPABASE_URL}'\n")
        f.write(f"SUPABASE_KEY='{SUPABASE_KEY}'\n\n")
        f.write(curl_commands)
    
    os.chmod('test_postgrest_curl.sh', 0o755)
    print("\nSaved curl commands to: test_postgrest_curl.sh")

def generate_mcp_execution_plan():
    """Generate a step-by-step MCP execution plan."""
    print("\n" + "="*60)
    print("MCP EXECUTION PLAN")
    print("="*60)
    
    # Load all MCP commands
    commands_file = "mcp_conversion/mcp_commands.json"
    if not os.path.exists(commands_file):
        print("Error: mcp_commands.json not found")
        return
    
    commands = load_json_file(commands_file)
    
    print(f"\nTotal MCP commands to execute: {len(commands)}")
    print("\nExecution order (respecting foreign keys):")
    
    for i, cmd in enumerate(commands, 1):
        table = cmd['parameters']['table']
        record_count = len(cmd['parameters']['data']) if isinstance(cmd['parameters']['data'], list) else 1
        print(f"\n{i}. {table}")
        print(f"   Records: {record_count}")
        print(f"   Tool: {cmd['tool']}")
        
        # Show first record as example
        if isinstance(cmd['parameters']['data'], list) and cmd['parameters']['data']:
            first_record = cmd['parameters']['data'][0]
            print(f"   First record example:")
            for key, value in list(first_record.items())[:3]:  # Show first 3 fields
                print(f"     - {key}: {value}")

def main():
    print("MCP Server Insertion Test Suite")
    print("==============================")
    
    # Check if conversion was done
    if not os.path.exists("mcp_conversion"):
        print("\nError: Run sql_to_mcp_converter.py first!")
        return
    
    # Run tests
    test_single_agent_insert()
    test_bulk_agent_insert()
    create_postgrest_curl_test()
    generate_mcp_execution_plan()
    
    print("\n" + "="*60)
    print("NEXT STEPS:")
    print("="*60)
    print("\n1. First, test the PostgREST connection:")
    print("   ./test_postgrest_curl.sh")
    print("\n2. If PostgREST works, use the MCP commands from mcp_conversion/")
    print("\n3. If MCP server has issues, use direct Supabase client instead")
    print("\n4. Monitor the Supabase dashboard for successful insertions")

if __name__ == "__main__":
    main()