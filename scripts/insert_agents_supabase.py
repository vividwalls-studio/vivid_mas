#!/usr/bin/env python3
"""
Insert agents into Supabase using the extracted data
"""

import json
import os

def load_agents_data():
    """Load the extracted agents data"""
    with open('scripts/agents_extracted.json', 'r') as f:
        return json.load(f)

def create_agent_entries():
    """Create agent entries in Supabase"""
    agents_data = load_agents_data()
    
    print(f"Loading {len(agents_data)} agents...\n")
    
    # Group by department for organized insertion
    by_dept = {}
    for agent_data in agents_data:
        dept = agent_data['metadata']['department']
        if dept not in by_dept:
            by_dept[dept] = []
        by_dept[dept].append(agent_data)
    
    # Process each department
    for dept, agents in by_dept.items():
        print(f"\n{dept} Department ({len(agents)} agents):")
        print("=" * 50)
        
        for agent_data in agents:
            agent = agent_data['agent']
            
            print(f"\nAgent: {agent['name']}")
            print(f"Role: {agent['role'][:60]}...")
            print(f"ID: {agent['id']}")
            
            # Create the agent entry structure
            agent_entry = {
                'id': agent['id'],
                'name': agent['name'],
                'role': agent['role'],
                'backstory': agent['backstory'],
                'short_term_memory': agent['short_term_memory'],
                'long_term_memory': agent['long_term_memory'],
                'episodic_memory': agent['episodic_memory']
            }
            
            # Add BDI components
            if agent_data['metadata']['level'] == 'Director':
                beliefs = [
                    f"The {dept} department's current state is accurately known",
                    "Data-driven decisions lead to better outcomes",
                    "Collaboration between agents improves system performance"
                ]
                desires = [
                    f"Optimize {dept.lower()} operations for maximum efficiency",
                    "Achieve departmental KPIs and objectives",
                    "Foster innovation and continuous improvement"
                ]
                intentions = [
                    f"Monitor and guide {dept.lower()} task agents",
                    "Report insights to the Business Manager Agent",
                    "Continuously refine departmental strategies"
                ]
            else:
                beliefs = [
                    "My current task queue reflects priority order",
                    "Quality outputs require proper validation",
                    "Efficient execution benefits the entire system"
                ]
                desires = [
                    "Complete assigned tasks with high quality",
                    "Optimize task execution time",
                    "Contribute to departmental goals"
                ]
                intentions = [
                    "Process tasks in priority order",
                    "Validate outputs before submission",
                    "Learn from task patterns for improvement"
                ]
            
            # Add personality traits
            if agent_data['metadata']['level'] == 'Director':
                personality = {
                    'openness': 'High',
                    'conscientiousness': 'High',
                    'extraversion': 'High',
                    'agreeableness': 'Moderate',
                    'neuroticism': 'Low'
                }
            else:
                personality = {
                    'openness': 'Moderate',
                    'conscientiousness': 'High',
                    'extraversion': 'Low',
                    'agreeableness': 'High',
                    'neuroticism': 'Low'
                }
            
            # Store complete agent configuration
            agent_config = {
                'agent': agent_entry,
                'bdi': {
                    'beliefs': beliefs,
                    'desires': desires,
                    'intentions': intentions
                },
                'personality': personality,
                'heuristic_imperatives': [
                    "Reduce suffering in the universe",
                    "Increase prosperity in the universe",
                    "Increase understanding in the universe"
                ]
            }
            
            # Save individual agent config
            filename = f"scripts/agents/config_{agent['name'].lower().replace(' ', '_')}.json"
            os.makedirs('scripts/agents', exist_ok=True)
            with open(filename, 'w') as f:
                json.dump(agent_config, f, indent=2)
    
    print("\n\nAgent configurations saved to scripts/agents/")
    print("Use these JSON files to insert agents into Supabase")

if __name__ == "__main__":
    create_agent_entries()