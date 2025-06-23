#!/usr/bin/env python3
"""
Extract agent information from prompt files and create SQL insert statements
"""

import os
import re
import json
import glob
from datetime import datetime
import uuid

def extract_agent_info(file_path, content):
    """Extract agent information from markdown file"""
    agent_info = {
        'id': str(uuid.uuid4()),
        'name': None,
        'role': None,
        'backstory': None,
        'department': None,
        'level': None,
        'short_term_memory': None,
        'long_term_memory': None,
        'episodic_memory': None
    }
    
    # Extract name
    name_match = re.search(r'\*\*Name\*\*:\s*`([^`]+)`', content)
    if name_match:
        agent_info['name'] = name_match.group(1)
    else:
        # Fallback to filename
        base_name = os.path.basename(file_path).replace('.md', '').replace('_', ' ')
        agent_info['name'] = ''.join(word.capitalize() for word in base_name.split())
    
    # Extract role
    role_match = re.search(r'\*\*Role\*\*:\s*([^\n]+)', content)
    if role_match:
        agent_info['role'] = role_match.group(1).strip()
    elif '## Role & Purpose' in content:
        role_section = content.split('## Role & Purpose')[1].split('##')[0].strip()
        lines = [line.strip() for line in role_section.split('\n') if line.strip()]
        agent_info['role'] = lines[0] if lines else 'Agent'
    else:
        agent_info['role'] = f"{agent_info['name']} Agent"
    
    # Extract department and level based on path
    if 'core' in file_path:
        agent_info['department'] = 'Core'
        agent_info['level'] = 'Director'
    elif 'marketing' in file_path:
        agent_info['department'] = 'Marketing'
        agent_info['level'] = 'Task'
    elif 'operational' in file_path:
        agent_info['department'] = 'Operational'
        agent_info['level'] = 'Task'
    
    # Extract responsibilities/specializations for backstory
    backstory_parts = []
    
    if '## Core Responsibilities' in content:
        resp_section = content.split('## Core Responsibilities')[1].split('##')[0].strip()
        resp_lines = [line.strip('- ').strip() for line in resp_section.split('\n') if line.strip().startswith('-')][:3]
        if resp_lines:
            backstory_parts.append(f"Core responsibilities include: {', '.join(resp_lines)}")
    
    if '## Specializations:' in content:
        spec_section = content.split('## Specializations:')[1].split('##')[0].strip()
        spec_lines = [line.strip('- ').strip() for line in spec_section.split('\n') if line.strip().startswith('-')][:3]
        if spec_lines:
            backstory_parts.append(f"Specializes in: {', '.join(spec_lines)}")
    
    if backstory_parts:
        agent_info['backstory'] = ' '.join(backstory_parts)
    else:
        agent_info['backstory'] = f"The {agent_info['name']} serves as {agent_info['role']} in the VividWalls multi-agent system."
    
    # Set memory fields based on agent type
    if agent_info['level'] == 'Director':
        agent_info['short_term_memory'] = f"Current strategic priorities, active campaigns, recent performance metrics, and immediate decisions for {agent_info['department']} operations."
        agent_info['long_term_memory'] = f"Historical {agent_info['department'].lower()} performance data, established best practices, successful strategies, and organizational knowledge."
        agent_info['episodic_memory'] = f"Key {agent_info['department'].lower()} milestones, past campaign outcomes, critical decisions, and lessons learned from successes and failures."
    else:
        agent_info['short_term_memory'] = f"Current task queue, active processing requests, recent outputs, and immediate context for {agent_info['name']} operations."
        agent_info['long_term_memory'] = f"Task execution patterns, optimization strategies, domain-specific knowledge, and performance benchmarks for {agent_info['name']}."
        agent_info['episodic_memory'] = f"Notable task completions, edge cases handled, performance improvements, and collaborative experiences with other agents."
    
    return agent_info

def generate_sql_inserts(agents):
    """Generate SQL insert statements for agents"""
    sql_statements = []
    
    # Generate agents table inserts
    sql_statements.append("-- Insert agents into agents table")
    for agent_data in agents:
        agent = agent_data['agent']
        sql = f"""
INSERT INTO agents (id, name, role, backstory, short_term_memory, long_term_memory, episodic_memory)
VALUES (
    '{agent['id']}',
    '{agent['name'].replace("'", "''")}',
    '{agent['role'].replace("'", "''")}',
    '{agent['backstory'].replace("'", "''")}',
    '{agent['short_term_memory'].replace("'", "''")}',
    '{agent['long_term_memory'].replace("'", "''")}',
    '{agent['episodic_memory'].replace("'", "''")}'
);"""
        sql_statements.append(sql)
    
    # Add sample BDI beliefs, desires, and intentions
    sql_statements.append("\n-- Insert BDI components")
    for agent_data in agents:
        agent = agent_data['agent']
        metadata = agent_data['metadata']
        
        # Beliefs
        if metadata['level'] == 'Director':
            beliefs = [
                f"The {metadata['department']} department's current state is accurately known",
                "Data-driven decisions lead to better outcomes",
                "Collaboration between agents improves system performance"
            ]
        else:
            beliefs = [
                "My current task queue reflects priority order",
                "Quality outputs require proper validation",
                "Efficient execution benefits the entire system"
            ]
        
        for belief in beliefs:
            sql = f"""
INSERT INTO agent_beliefs (agent_id, belief)
VALUES ('{agent['id']}', '{belief.replace("'", "''")}');"""
            sql_statements.append(sql)
    
    # Add heuristic imperatives
    sql_statements.append("\n-- Insert heuristic imperatives")
    imperatives = [
        "Reduce suffering in the universe",
        "Increase prosperity in the universe",
        "Increase understanding in the universe"
    ]
    
    for agent_data in agents:
        agent = agent_data['agent']
        for imp in imperatives:
            sql = f"""
INSERT INTO agent_heuristic_imperatives (agent_id, imperative)
VALUES ('{agent['id']}', '{imp}');"""
            sql_statements.append(sql)
    
    return sql_statements

def main():
    prompts_dir = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/prompts'
    
    # Find all .md files
    prompt_files = glob.glob(f"{prompts_dir}/**/*.md", recursive=True)
    
    print(f"Found {len(prompt_files)} prompt files")
    
    agents_data = []
    
    for file_path in prompt_files:
        try:
            with open(file_path, 'r') as f:
                content = f.read()
            
            agent_info = extract_agent_info(file_path, content)
            
            print(f"\nProcessing: {os.path.basename(file_path)}")
            print(f"  Name: {agent_info['name']}")
            print(f"  Role: {agent_info['role'][:50]}...")
            print(f"  Department: {agent_info['department']}")
            
            agents_data.append({
                'file': file_path,
                'agent': agent_info,
                'metadata': {
                    'department': agent_info['department'],
                    'level': agent_info['level']
                }
            })
            
        except Exception as e:
            print(f"Error processing {file_path}: {str(e)}")
    
    # Generate SQL
    sql_statements = generate_sql_inserts(agents_data)
    
    # Save SQL file
    with open('scripts/insert_agents.sql', 'w') as f:
        f.write("-- SQL statements to insert agents from prompt files\n")
        f.write("-- Generated on: " + datetime.now().isoformat() + "\n\n")
        f.write('\n'.join(sql_statements))
    
    # Save JSON for reference
    with open('scripts/agents_extracted.json', 'w') as f:
        json.dump(agents_data, f, indent=2)
    
    print(f"\n\nSummary:")
    print(f"Total agents processed: {len(agents_data)}")
    
    # Group by department
    by_dept = {}
    for agent in agents_data:
        dept = agent['metadata']['department']
        if dept not in by_dept:
            by_dept[dept] = []
        by_dept[dept].append(agent['agent']['name'])
    
    for dept, names in by_dept.items():
        print(f"\n{dept} Department ({len(names)} agents):")
        for name in sorted(names):
            print(f"  - {name}")
    
    print("\n\nFiles created:")
    print("  - scripts/insert_agents.sql (SQL insert statements)")
    print("  - scripts/agents_extracted.json (JSON data)")

if __name__ == "__main__":
    main()