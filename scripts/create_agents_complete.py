#!/usr/bin/env python3
"""
Complete script to create all agents in Supabase with full configuration
"""

import json
import os
from datetime import datetime

# Load all agent configurations
def load_all_agents():
    agents = []
    agent_files = [f for f in os.listdir('scripts/agents') if f.startswith('config_')]
    
    for filename in agent_files:
        with open(f'scripts/agents/{filename}', 'r') as f:
            agents.append(json.load(f))
    
    return agents

# Generate comprehensive SQL for all tables
def generate_complete_sql():
    agents = load_all_agents()
    
    sql_statements = [
        "-- Complete Multi-Agent System Population",
        f"-- Generated on: {datetime.now().isoformat()}",
        "-- This script populates all agent-related tables",
        "",
        "-- First, ensure the schema exists",
        "-- Run create_mas_schema_clean.py if tables don't exist",
        "",
        "BEGIN;",
        "",
        "-- Clear existing data (optional - comment out if appending)",
        "DELETE FROM agent_voice_config;",
        "DELETE FROM agent_mcp_tools;",
        "DELETE FROM agent_tasks;",
        "DELETE FROM agent_skills;",
        "DELETE FROM agent_workflows;",
        "DELETE FROM agent_llm_config;",
        "DELETE FROM agent_rules;",
        "DELETE FROM agent_instructions;",
        "DELETE FROM agent_objectives;",
        "DELETE FROM agent_goals;",
        "DELETE FROM agent_personalities;",
        "DELETE FROM agent_domain_knowledge;",
        "DELETE FROM agent_heuristic_imperatives;",
        "DELETE FROM agent_intentions;",
        "DELETE FROM agent_desires;",
        "DELETE FROM agent_beliefs;",
        "DELETE FROM agents;",
        "",
        "-- Insert Agents",
    ]
    
    # Sort agents by department and level for organized insertion
    core_directors = [a for a in agents if 'Director' in a['agent']['name'] and 'Core' in a['agent']['backstory']]
    marketing_agents = [a for a in agents if 'Marketing' in a['agent']['backstory'] or 'Campaign' in a['agent']['name']]
    operational_agents = [a for a in agents if a not in core_directors and a not in marketing_agents]
    
    all_sorted_agents = core_directors + marketing_agents + operational_agents
    
    # Insert agents
    for agent_config in all_sorted_agents:
        agent = agent_config['agent']
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
    
    # Insert BDI components
    sql_statements.append("\n-- Insert BDI Components")
    for agent_config in all_sorted_agents:
        agent_id = agent_config['agent']['id']
        bdi = agent_config['bdi']
        
        # Beliefs
        for belief in bdi['beliefs']:
            belief_escaped = belief.replace("'", "''")
            sql = f"INSERT INTO agent_beliefs (agent_id, belief) VALUES ('{agent_id}', '{belief_escaped}');"
            sql_statements.append(sql)
        
        # Desires
        for desire in bdi['desires']:
            desire_escaped = desire.replace("'", "''")
            sql = f"INSERT INTO agent_desires (agent_id, desire) VALUES ('{agent_id}', '{desire_escaped}');"
            sql_statements.append(sql)
        
        # Intentions
        for intention in bdi['intentions']:
            intention_escaped = intention.replace("'", "''")
            sql = f"INSERT INTO agent_intentions (agent_id, intention) VALUES ('{agent_id}', '{intention_escaped}');"
            sql_statements.append(sql)
    
    # Insert heuristic imperatives
    sql_statements.append("\n-- Insert Heuristic Imperatives")
    for agent_config in all_sorted_agents:
        agent_id = agent_config['agent']['id']
        for imperative in agent_config['heuristic_imperatives']:
            sql = f"INSERT INTO agent_heuristic_imperatives (agent_id, imperative) VALUES ('{agent_id}', '{imperative}');"
            sql_statements.append(sql)
    
    # Insert personalities
    sql_statements.append("\n-- Insert Personalities")
    for agent_config in all_sorted_agents:
        agent_id = agent_config['agent']['id']
        p = agent_config['personality']
        sql = f"""
INSERT INTO agent_personalities (agent_id, openness, conscientiousness, extraversion, agreeableness, neuroticism)
VALUES ('{agent_id}', '{p['openness']}', '{p['conscientiousness']}', '{p['extraversion']}', '{p['agreeableness']}', '{p['neuroticism']}');"""
        sql_statements.append(sql)
    
    # Insert domain knowledge
    sql_statements.append("\n-- Insert Domain Knowledge")
    for agent_config in all_sorted_agents:
        agent_id = agent_config['agent']['id']
        agent_name = agent_config['agent']['name']
        
        sql = f"""
INSERT INTO agent_domain_knowledge (agent_id, vector_database, knowledge_graph, relational_database)
VALUES (
    '{agent_id}',
    '{agent_name}VectorDB',
    '{agent_name}KnowledgeGraph',
    '{agent_name}RelationalDB'
);"""
        sql_statements.append(sql)
    
    # Insert goals
    sql_statements.append("\n-- Insert Goals")
    for agent_config in all_sorted_agents:
        agent_id = agent_config['agent']['id']
        
        # Create department-specific goals
        if 'Director' in agent_config['agent']['name']:
            goals = [
                "Optimize departmental performance and efficiency",
                "Achieve quarterly KPIs and business objectives",
                "Foster innovation and continuous improvement"
            ]
        else:
            goals = [
                "Complete assigned tasks with high quality",
                "Optimize task execution time and resource usage",
                "Contribute to departmental success metrics"
            ]
        
        for goal in goals:
            sql = f"INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('{agent_id}', '{goal}', 'high');"
            sql_statements.append(sql)
    
    # Insert LLM configurations
    sql_statements.append("\n-- Insert LLM Configurations")
    for agent_config in all_sorted_agents:
        agent_id = agent_config['agent']['id']
        agent_name = agent_config['agent']['name']
        agent_role = agent_config['agent']['role']
        
        sql = f"""
INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '{agent_id}',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are {agent_name}, responsible for {agent_role.replace("'", "''")}',
    'Act as {agent_name} - be strategic, data-driven, and focused on your departmental objectives.',
    '{{"top_p": 0.9, "frequency_penalty": 0.2}}'::jsonb
);"""
        sql_statements.append(sql)
    
    # Insert voice configurations
    sql_statements.append("\n-- Insert Voice Configurations")
    for agent_config in all_sorted_agents:
        agent_id = agent_config['agent']['id']
        
        if 'Director' in agent_config['agent']['name']:
            voice_style = "Confident and authoritative"
            voice_tone = "Professional, strategic, and decisive"
        else:
            voice_style = "Clear and efficient"
            voice_tone = "Professional, focused, and helpful"
        
        sql = f"""
INSERT INTO agent_voice_config (
    agent_id, style, tone, pace, provider, 
    description, voice_settings
)
VALUES (
    '{agent_id}',
    '{voice_style}',
    '{voice_tone}',
    'Moderate',
    'Hume EVI',
    'Voice configuration optimized for {agent_config['agent']['role'].replace("'", "''")}',
    '{{"emotion": "confident", "prosody": "balanced"}}'::jsonb
);"""
        sql_statements.append(sql)
    
    sql_statements.append("\nCOMMIT;")
    
    return '\n'.join(sql_statements)

def main():
    print("Generating complete SQL for Multi-Agent System...")
    
    # Generate SQL
    sql = generate_complete_sql()
    
    # Save to file
    with open('scripts/populate_mas_complete.sql', 'w') as f:
        f.write(sql)
    
    print("\nSQL file created: scripts/populate_mas_complete.sql")
    print("\nTo execute in Supabase:")
    print("1. Open Supabase SQL Editor")
    print("2. Copy and paste the contents of populate_mas_complete.sql")
    print("3. Execute the query")
    
    # Also create a summary
    agents = load_all_agents()
    print(f"\nTotal agents to be created: {len(agents)}")
    
    # Group summary
    directors = [a for a in agents if 'Director' in a['agent']['name']]
    tasks = [a for a in agents if 'Task' in a['agent']['name']]
    
    print(f"  - Director Agents: {len(directors)}")
    print(f"  - Task Agents: {len(tasks)}")

if __name__ == "__main__":
    main()