#!/usr/bin/env python3
"""
Populate Supabase agents table from existing prompt files
"""

import os
import re
from datetime import datetime
from supabase import create_client, Client
from dotenv import load_dotenv
import glob

# Load environment variables
load_dotenv()

# Initialize Supabase client
SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_KEY')

if not SUPABASE_URL or not SUPABASE_KEY:
    print("Error: SUPABASE_URL and SUPABASE_KEY must be set in environment variables")
    exit(1)

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def extract_agent_info(file_path, content):
    """Extract agent information from markdown file"""
    agent_info = {
        'name': None,
        'role': None,
        'backstory': None,
        'department': None,
        'level': None
    }
    
    # Extract name
    name_match = re.search(r'\*\*Name\*\*:\s*`([^`]+)`', content)
    if name_match:
        agent_info['name'] = name_match.group(1)
    else:
        # Fallback to filename
        agent_info['name'] = os.path.basename(file_path).replace('.md', '').replace('_', ' ').title()
    
    # Extract role
    role_match = re.search(r'\*\*Role\*\*:\s*([^\n]+)', content)
    if role_match:
        agent_info['role'] = role_match.group(1).strip()
    elif '## Role & Purpose' in content:
        role_section = content.split('## Role & Purpose')[1].split('##')[0].strip()
        agent_info['role'] = role_section.split('\n')[0] if role_section else 'Agent'
    
    # Extract department based on path
    if 'core' in file_path:
        agent_info['department'] = 'Core'
        agent_info['level'] = 'Director'
    elif 'marketing' in file_path:
        agent_info['department'] = 'Marketing'
        agent_info['level'] = 'Task'
    elif 'operational' in file_path:
        agent_info['department'] = 'Operational'
        agent_info['level'] = 'Task'
    
    # Generate backstory based on content
    if '## Core Responsibilities' in content:
        resp_section = content.split('## Core Responsibilities')[1].split('##')[0].strip()
        agent_info['backstory'] = f"Specialized agent responsible for: {resp_section[:200]}..."
    elif '## Specializations:' in content:
        spec_section = content.split('## Specializations:')[1].split('##')[0].strip()
        agent_info['backstory'] = f"Task agent specializing in: {spec_section[:200]}..."
    else:
        agent_info['backstory'] = f"{agent_info['name']} - {agent_info['role']}"
    
    return agent_info

def create_agents_from_prompts():
    """Read all prompt files and create agent entries"""
    prompts_dir = '/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/n8n/agents/prompts'
    
    # Find all .md files
    prompt_files = glob.glob(f"{prompts_dir}/**/*.md", recursive=True)
    
    print(f"Found {len(prompt_files)} prompt files")
    
    agents_created = []
    
    for file_path in prompt_files:
        try:
            with open(file_path, 'r') as f:
                content = f.read()
            
            agent_info = extract_agent_info(file_path, content)
            
            # Create agent entry
            agent_data = {
                'name': agent_info['name'],
                'role': agent_info['role'] or 'Agent',
                'backstory': agent_info['backstory'],
                'short_term_memory': f"Current tasks and immediate context for {agent_info['name']}",
                'long_term_memory': f"Historical data and learned patterns for {agent_info['name']}",
                'episodic_memory': f"Past experiences and specific events for {agent_info['name']}"
            }
            
            print(f"\nCreating agent: {agent_info['name']}")
            print(f"  Role: {agent_info['role']}")
            print(f"  Department: {agent_info['department']}")
            print(f"  Level: {agent_info['level']}")
            
            agents_created.append({
                'file': file_path,
                'agent': agent_data,
                'metadata': {
                    'department': agent_info['department'],
                    'level': agent_info['level']
                }
            })
            
        except Exception as e:
            print(f"Error processing {file_path}: {str(e)}")
    
    return agents_created

def main():
    print("Starting agent population from prompts...\n")
    
    # Create agents from prompts
    agents = create_agents_from_prompts()
    
    print(f"\n\nSummary:")
    print(f"Total agents found: {len(agents)}")
    
    # Group by department
    by_dept = {}
    for agent in agents:
        dept = agent['metadata']['department']
        if dept not in by_dept:
            by_dept[dept] = []
        by_dept[dept].append(agent['agent']['name'])
    
    for dept, names in by_dept.items():
        print(f"\n{dept} Department ({len(names)} agents):")
        for name in names:
            print(f"  - {name}")
    
    # Save to JSON for manual review/insertion
    import json
    with open('scripts/agents_to_insert.json', 'w') as f:
        json.dump(agents, f, indent=2)
    
    print("\n\nAgent data saved to scripts/agents_to_insert.json")
    print("Review the file and use the insert script to add to Supabase")

if __name__ == "__main__":
    main()