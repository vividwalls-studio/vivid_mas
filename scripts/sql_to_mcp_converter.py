#!/usr/bin/env python3
"""
Convert SQL INSERT statements to MCP server-compatible operations.
This script transforms SQL to JSON format that can be used with the MCP insert-data tool.
"""

import json
import re
import os
from typing import List, Dict, Any, Tuple
from datetime import datetime

class SQLToMCPConverter:
    def __init__(self):
        self.tables_data = {}
        self.mcp_commands = []
        
    def parse_sql_file(self, sql_file: str) -> Dict[str, List[Dict]]:
        """Parse SQL file and extract INSERT statements."""
        print(f"Parsing SQL file: {sql_file}")
        
        with open(sql_file, 'r') as f:
            content = f.read()
        
        # Remove comments and empty lines
        lines = [line for line in content.split('\n') 
                if line.strip() and not line.strip().startswith('--')]
        content = '\n'.join(lines)
        
        # Split by semicolons to get individual statements
        statements = [s.strip() for s in content.split(';') if s.strip()]
        
        for statement in statements:
            if statement.upper().startswith('INSERT INTO'):
                self._parse_insert_statement(statement + ';')
        
        return self.tables_data
    
    def _parse_insert_statement(self, statement: str) -> None:
        """Parse a single INSERT statement."""
        # Match INSERT INTO table_name (columns) VALUES (values);
        pattern = r'INSERT INTO\s+(\w+)\s*\((.*?)\)\s*VALUES\s*\((.*?)\);'
        match = re.search(pattern, statement, re.IGNORECASE | re.DOTALL)
        
        if not match:
            return
        
        table_name = match.group(1)
        columns_str = match.group(2)
        values_str = match.group(3)
        
        # Parse columns
        columns = [col.strip() for col in columns_str.split(',')]
        
        # Parse values (handling quoted strings, NULL, etc.)
        values = self._parse_values(values_str)
        
        # Create data object
        if len(columns) == len(values):
            data_obj = {}
            for col, val in zip(columns, values):
                data_obj[col] = val
            
            # Add to table data
            if table_name not in self.tables_data:
                self.tables_data[table_name] = []
            self.tables_data[table_name].append(data_obj)
    
    def _parse_values(self, values_str: str) -> List[Any]:
        """Parse SQL values string into Python values."""
        values = []
        current_value = ''
        in_quotes = False
        escape_next = False
        
        i = 0
        while i < len(values_str):
            char = values_str[i]
            
            if escape_next:
                current_value += char
                escape_next = False
                i += 1
                continue
            
            if char == '\\':
                escape_next = True
                i += 1
                continue
            
            if char == "'" and not escape_next:
                if not in_quotes:
                    in_quotes = True
                else:
                    # Check if it's a double quote (escaped quote)
                    if i + 1 < len(values_str) and values_str[i + 1] == "'":
                        current_value += "'"
                        i += 2
                        continue
                    else:
                        in_quotes = False
            elif char == ',' and not in_quotes:
                # End of value
                values.append(self._convert_value(current_value.strip()))
                current_value = ''
            else:
                current_value += char
            
            i += 1
        
        # Don't forget the last value
        if current_value.strip():
            values.append(self._convert_value(current_value.strip()))
        
        return values
    
    def _convert_value(self, value: str) -> Any:
        """Convert SQL value to Python value."""
        value = value.strip()
        
        # NULL
        if value.upper() == 'NULL':
            return None
        
        # Boolean
        if value.lower() == 'true':
            return True
        if value.lower() == 'false':
            return False
        
        # String (quoted)
        if value.startswith("'") and value.endswith("'"):
            # Remove quotes and unescape
            return value[1:-1].replace("''", "'")
        
        # UUID or other unquoted strings
        if value:
            # Try to parse as number
            try:
                if '.' in value:
                    return float(value)
                else:
                    return int(value)
            except ValueError:
                # Return as string
                return value
        
        return value
    
    def generate_mcp_commands(self) -> List[Dict[str, Any]]:
        """Generate MCP server commands for data insertion."""
        # Define insertion order based on foreign key dependencies
        table_order = [
            'agents',  # Parent table first
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
        
        commands = []
        
        for table in table_order:
            if table in self.tables_data and self.tables_data[table]:
                # MCP command structure
                command = {
                    "tool": "mcp__supabase-server__insert-data",
                    "parameters": {
                        "table": table,
                        "data": self.tables_data[table]  # Can be array for bulk
                    },
                    "description": f"Insert {len(self.tables_data[table])} records into {table}"
                }
                commands.append(command)
        
        return commands
    
    def save_outputs(self, output_dir: str = 'mcp_conversion') -> None:
        """Save converted data and commands to files."""
        os.makedirs(output_dir, exist_ok=True)
        
        # Save individual table data
        for table, data in self.tables_data.items():
            file_path = os.path.join(output_dir, f"{table}.json")
            with open(file_path, 'w') as f:
                json.dump(data, f, indent=2)
            print(f"Saved {table} data to {file_path} ({len(data)} records)")
        
        # Save MCP commands
        commands = self.generate_mcp_commands()
        commands_file = os.path.join(output_dir, 'mcp_commands.json')
        with open(commands_file, 'w') as f:
            json.dump(commands, f, indent=2)
        print(f"\nSaved MCP commands to {commands_file}")
        
        # Save execution script
        self._create_execution_script(output_dir, commands)
        
        # Save summary
        summary = {
            "conversion_date": datetime.now().isoformat(),
            "tables": list(self.tables_data.keys()),
            "record_counts": {table: len(data) for table, data in self.tables_data.items()},
            "total_records": sum(len(data) for data in self.tables_data.values()),
            "mcp_commands": len(commands)
        }
        
        summary_file = os.path.join(output_dir, 'conversion_summary.json')
        with open(summary_file, 'w') as f:
            json.dump(summary, f, indent=2)
        
        print(f"\nConversion Summary:")
        print(f"- Tables: {len(self.tables_data)}")
        print(f"- Total Records: {summary['total_records']}")
        print(f"- MCP Commands: {len(commands)}")
    
    def _create_execution_script(self, output_dir: str, commands: List[Dict]) -> None:
        """Create a script showing how to execute the MCP commands."""
        script_content = '''#!/usr/bin/env python3
"""
Execute MCP commands to insert data into Supabase.
Generated from SQL conversion.
"""

import json
import os
import time

def load_mcp_commands():
    """Load the generated MCP commands."""
    with open('mcp_commands.json', 'r') as f:
        return json.load(f)

def execute_via_mcp():
    """
    Execute commands via MCP server.
    
    Note: This requires the MCP server to be properly configured
    and accessible from your environment.
    """
    commands = load_mcp_commands()
    
    print(f"Executing {len(commands)} MCP commands...")
    print("=" * 60)
    
    for i, cmd in enumerate(commands, 1):
        print(f"\\n{i}. {cmd['description']}")
        print(f"   Tool: {cmd['tool']}")
        print(f"   Table: {cmd['parameters']['table']}")
        
        # In actual implementation, you would call the MCP tool here
        # For now, this shows the structure
        
        # Example of how to call in Claude Desktop or other MCP client:
        # result = mcp_client.call_tool(
        #     cmd['tool'], 
        #     cmd['parameters']
        # )
        
        time.sleep(0.1)  # Rate limiting
    
    print("\\n" + "=" * 60)
    print("All commands prepared for execution.")

def generate_curl_commands():
    """Generate curl commands for direct PostgREST API calls."""
    commands = load_mcp_commands()
    
    SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://your-project.supabase.co')
    SUPABASE_KEY = os.getenv('SUPABASE_ANON_KEY', 'your-anon-key')
    
    curl_file = 'postgrest_curl_commands.sh'
    
    with open(curl_file, 'w') as f:
        f.write('#!/bin/bash\\n')
        f.write('# PostgREST API calls via curl\\n\\n')
        f.write(f'SUPABASE_URL="{SUPABASE_URL}"\\n')
        f.write(f'SUPABASE_KEY="{SUPABASE_KEY}"\\n\\n')
        
        for cmd in commands:
            table = cmd['parameters']['table']
            data = cmd['parameters']['data']
            
            f.write(f'# Insert into {table}\\n')
            f.write(f'curl -X POST \\\\\\n')
            f.write(f'  "${{SUPABASE_URL}}/rest/v1/{table}" \\\\\\n')
            f.write(f'  -H "apikey: ${{SUPABASE_KEY}}" \\\\\\n')
            f.write(f'  -H "Authorization: Bearer ${{SUPABASE_KEY}}" \\\\\\n')
            f.write(f'  -H "Content-Type: application/json" \\\\\\n')
            f.write(f'  -H "Prefer: return=minimal" \\\\\\n')
            f.write(f"  -d '{json.dumps(data)}'\\n\\n")
    
    print(f"\\nGenerated curl commands in: {curl_file}")

if __name__ == "__main__":
    print("MCP Command Execution Script")
    print("=" * 60)
    
    # Show available options
    print("\\n1. View MCP commands")
    print("2. Generate curl commands for PostgREST")
    print("3. Execute via MCP (requires MCP client)")
    
    # For demonstration, generate curl commands
    generate_curl_commands()
    
    # Show command structure
    execute_via_mcp()
'''
        
        script_path = os.path.join(output_dir, 'execute_mcp_commands.py')
        with open(script_path, 'w') as f:
            f.write(script_content)
        os.chmod(script_path, 0o755)
        print(f"\nCreated execution script: {script_path}")


def main():
    converter = SQLToMCPConverter()
    
    # Parse the SQL file
    sql_file = "/Volumes/SeagatePortableDrive/Projects/vivid_mas/scripts/populate_mas_complete.sql"
    
    print("SQL to MCP Converter")
    print("=" * 60)
    
    # Convert SQL to structured data
    tables_data = converter.parse_sql_file(sql_file)
    
    # Save outputs
    converter.save_outputs()
    
    print("\nConversion complete!")
    print("\nNext steps:")
    print("1. Review the generated JSON files in 'mcp_conversion/'")
    print("2. Use the MCP commands in 'mcp_commands.json' with your MCP client")
    print("3. Or use the generated curl commands for direct PostgREST API calls")


if __name__ == "__main__":
    main()