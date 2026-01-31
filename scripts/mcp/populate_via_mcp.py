#!/usr/bin/env python3
"""Convert SQL to MCP-compatible data format for insertion."""

import json
import re
import os

def extract_insert_data(sql_file):
    """Extract INSERT statements and convert to MCP format."""
    
    with open(sql_file, 'r') as f:
        content = f.read()
    
    # Extract all INSERT statements
    insert_pattern = r"INSERT INTO (\w+) \((.*?)\) VALUES \((.*?)\);"
    
    tables_data = {}
    
    for match in re.finditer(insert_pattern, content, re.DOTALL):
        table_name = match.group(1)
        columns = [col.strip() for col in match.group(2).split(',')]
        values_str = match.group(3)
        
        # Parse values - handle quoted strings and line breaks
        values = []
        current_value = ''
        in_quotes = False
        escape_next = False
        
        for char in values_str:
            if escape_next:
                current_value += char
                escape_next = False
                continue
                
            if char == '\\':
                escape_next = True
                continue
                
            if char == "'" and not escape_next:
                if in_quotes:
                    in_quotes = False
                else:
                    in_quotes = True
            elif char == ',' and not in_quotes:
                values.append(current_value.strip().strip("'"))
                current_value = ''
                continue
                
            current_value += char
        
        if current_value:
            values.append(current_value.strip().strip("'"))
        
        # Create data object
        data_obj = {}
        for col, val in zip(columns, values):
            if val == 'NULL' or val == '':
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
                    data_obj[col] = val.replace("''", "'")  # Unescape quotes
        
        # Group by table
        if table_name not in tables_data:
            tables_data[table_name] = []
        tables_data[table_name].append(data_obj)
    
    return tables_data

def create_mcp_json_files(tables_data, output_dir='mcp_data'):
    """Create JSON files for each table's data."""
    
    os.makedirs(output_dir, exist_ok=True)
    
    # Order tables by dependencies
    table_order = [
        'agents',  # Must be first
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
    
    print(f"Creating MCP data files in {output_dir}/...")
    
    for table in table_order:
        if table in tables_data:
            filename = os.path.join(output_dir, f"{table}.json")
            with open(filename, 'w') as f:
                json.dump(tables_data[table], f, indent=2)
            print(f"Created {filename} with {len(tables_data[table])} records")
    
    # Create a summary file
    summary = {
        "tables": list(tables_data.keys()),
        "record_counts": {table: len(data) for table, data in tables_data.items()},
        "total_records": sum(len(data) for data in tables_data.values())
    }
    
    with open(os.path.join(output_dir, 'summary.json'), 'w') as f:
        json.dump(summary, f, indent=2)
    
    print(f"\nTotal records to insert: {summary['total_records']}")
    
    # Create insertion script
    create_insertion_script(output_dir, table_order)

def create_insertion_script(data_dir, table_order):
    """Create a script showing how to insert the data."""
    
    script_content = '''#!/usr/bin/env python3
"""Insert MCP data into Supabase.

This script shows how to insert the data using the MCP tools.
Since we can't execute this directly through MCP, you'll need to:

1. Use the Supabase Dashboard SQL editor
2. Or create a Python script using the Supabase client
"""

import json
import os

# Table insertion order (respects foreign key constraints)
TABLE_ORDER = %s

def get_insert_commands():
    """Generate the MCP tool commands for insertion."""
    
    commands = []
    data_dir = '%s'
    
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
        print(f"\\n{i}. Insert into {cmd['parameters']['table']}:")
        print(f"   Records: {len(cmd['parameters']['data']) if isinstance(cmd['parameters']['data'], list) else 1}")
    
    print("\\n" + "=" * 60)
    print("\\nNote: The MCP server may have limitations on bulk inserts.")
    print("If bulk insert fails, you may need to insert records one by one.")
''' % (json.dumps(table_order), data_dir)
    
    script_path = os.path.join(data_dir, 'insert_via_mcp.py')
    with open(script_path, 'w') as f:
        f.write(script_content)
    os.chmod(script_path, 0o755)
    
    print(f"\nCreated insertion script: {script_path}")

if __name__ == "__main__":
    # Process the SQL file
    sql_file = "/Volumes/SeagatePortableDrive/Projects/vivid_mas/scripts/populate_mas_complete.sql"
    
    print("Extracting data from SQL file...")
    tables_data = extract_insert_data(sql_file)
    
    # Create MCP-compatible JSON files
    create_mcp_json_files(tables_data)
    
    print("\nNext steps:")
    print("1. Review the generated JSON files in mcp_data/")
    print("2. Use the MCP insert-data tool to insert the data")
    print("3. Or use the Supabase Dashboard for bulk SQL execution")