#!/usr/bin/env python3
"""Insert MCP data into Supabase.

This script shows how to insert the data using the MCP tools.
Since we can't execute this directly through MCP, you'll need to:

1. Use the Supabase Dashboard SQL editor
2. Or create a Python script using the Supabase client
"""

import json
import os

# Table insertion order (respects foreign key constraints)
TABLE_ORDER = ["agents", "agent_beliefs", "agent_desires", "agent_intentions", "agent_heuristic_imperatives", "agent_domain_knowledge", "agent_personalities", "agent_goals", "agent_objectives", "agent_instructions", "agent_rules", "agent_llm_config", "agent_workflows", "agent_skills", "agent_tasks", "agent_mcp_tools", "agent_voice_config"]

def get_insert_commands():
    """Generate the MCP tool commands for insertion."""
    
    commands = []
    data_dir = 'mcp_data'
    
    for table in TABLE_ORDER:
        file_path = os.path.join(data_dir, f"{table}.json")
        if os.path.exists(file_path):
            with open(file_path, 'r') as f:
                data = json.load(f)
            
            # MCP insert-data accepts arrays for bulk insert
            command = {
                "tool": "mcp__supabase-server__insert-data",
                "parameters": {
                    "table": table,
                    "data": data  # Can be array for bulk insert
                }
            }
            commands.append(command)
    
    return commands

if __name__ == "__main__":
    commands = get_insert_commands()
    
    print("MCP Commands to execute:")
    print("=" * 60)
    
    for i, cmd in enumerate(commands, 1):
        print(f"\n{i}. Insert into {cmd['parameters']['table']}:")
        print(f"   Records: {len(cmd['parameters']['data']) if isinstance(cmd['parameters']['data'], list) else 1}")
    
    print("\n" + "=" * 60)
    print("\nNote: The MCP server may have limitations on bulk inserts.")
    print("If bulk insert fails, you may need to insert records one by one.")
