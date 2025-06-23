#!/usr/bin/env python3
"""Extract agent data from SQL and create JSON files for MCP insertion."""

import json
import re
import os

def parse_sql_inserts(sql_file):
    """Parse SQL INSERT statements more carefully."""
    
    with open(sql_file, 'r') as f:
        content = f.read()
    
    # Split into individual statements
    statements = content.split(';')
    
    tables_data = {}
    
    for statement in statements:
        statement = statement.strip()
        if not statement or not statement.upper().startswith('INSERT INTO'):
            continue
        
        # Extract table name and columns
        match = re.match(r'INSERT INTO (\w+)\s*\((.*?)\)\s*VALUES', statement, re.IGNORECASE | re.DOTALL)
        if not match:
            continue
            
        table_name = match.group(1)
        columns = [col.strip() for col in match.group(2).split(',')]
        
        # Extract values section
        values_match = re.search(r'VALUES\s*\((.*)\)', statement, re.IGNORECASE | re.DOTALL)
        if not values_match:
            continue
            
        values_str = values_match.group(1)
        
        # Parse values more carefully
        values = []
        current_value = ''
        in_quotes = False
        paren_depth = 0
        
        i = 0
        while i < len(values_str):
            char = values_str[i]
            
            if char == "'" and (i == 0 or values_str[i-1] != "'"):
                in_quotes = not in_quotes
                current_value += char
            elif char == ',' and not in_quotes and paren_depth == 0:
                values.append(current_value.strip())
                current_value = ''
            else:
                current_value += char
                if char == '(' and not in_quotes:
                    paren_depth += 1
                elif char == ')' and not in_quotes:
                    paren_depth -= 1
            
            i += 1
        
        if current_value.strip():
            values.append(current_value.strip())
        
        # Clean up values and create data object
        data_obj = {}
        for col, val in zip(columns, values):
            val = val.strip()
            
            # Remove surrounding quotes
            if val.startswith("'") and val.endswith("'"):
                val = val[1:-1]
                # Unescape single quotes
                val = val.replace("''", "'")
            
            # Convert special values
            if val == 'NULL':
                data_obj[col] = None
            elif val.lower() == 'true':
                data_obj[col] = True
            elif val.lower() == 'false':
                data_obj[col] = False
            else:
                # Try to parse as number
                try:
                    if '.' in val:
                        data_obj[col] = float(val)
                    else:
                        data_obj[col] = int(val)
                except:
                    data_obj[col] = val
        
        # Add to table data
        if table_name not in tables_data:
            tables_data[table_name] = []
        tables_data[table_name].append(data_obj)
    
    return tables_data

def save_table_data(tables_data, output_dir='mcp_data'):
    """Save each table's data as a separate JSON file."""
    
    os.makedirs(output_dir, exist_ok=True)
    
    # Define table order based on dependencies
    table_order = [
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
    
    print("Saving data files...")
    total_records = 0
    
    for table in table_order:
        if table in tables_data:
            filename = os.path.join(output_dir, f"{table}.json")
            with open(filename, 'w') as f:
                json.dump(tables_data[table], f, indent=2)
            count = len(tables_data[table])
            total_records += count
            print(f"  {table}: {count} records -> {filename}")
    
    # Save summary
    summary = {
        "tables": list(tables_data.keys()),
        "record_counts": {table: len(data) for table, data in tables_data.items()},
        "total_records": total_records,
        "insertion_order": table_order
    }
    
    with open(os.path.join(output_dir, 'summary.json'), 'w') as f:
        json.dump(summary, f, indent=2)
    
    print(f"\nTotal records: {total_records}")
    return summary

def create_test_insertion():
    """Create a small test to verify MCP insertion works."""
    
    test_agent = {
        "id": "test-agent-001",
        "name": "TestAgent",
        "role": "Test Agent for MCP Verification",
        "backstory": "A simple test agent to verify MCP insertion works",
        "short_term_memory": "Test short term memory",
        "long_term_memory": "Test long term memory", 
        "episodic_memory": "Test episodic memory"
    }
    
    with open('mcp_data/test_agent.json', 'w') as f:
        json.dump(test_agent, f, indent=2)
    
    print("\nCreated test_agent.json for testing MCP insertion")

if __name__ == "__main__":
    sql_file = "/Volumes/SeagatePortableDrive/Projects/vivid_mas/scripts/populate_mas_complete.sql"
    
    print("Parsing SQL file...")
    tables_data = parse_sql_inserts(sql_file)
    
    print(f"\nFound {len(tables_data)} tables")
    
    summary = save_table_data(tables_data)
    
    create_test_insertion()
    
    print("\nNext steps:")
    print("1. First test with: mcp_data/test_agent.json")
    print("2. Then insert data from each table's JSON file")
    print("3. Use the insertion order from summary.json")