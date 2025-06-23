#!/usr/bin/env python3
import json
import subprocess

def main():
    # Read agent data
    with open('/root/vivid_mas/mcp_conversion/agents.json', 'r') as f:
        agents = json.load(f)[:10]  # Get first 10 agents
    
    # Truncate tables
    subprocess.run([
        'docker', 'exec', '-i', 'supabase-db', 
        'psql', '-U', 'postgres', '-d', 'postgres', 
        '-c', 'TRUNCATE agents CASCADE;'
    ])
    
    # Insert agents
    for agent in agents:
        # Prepare SQL with proper JSON escaping
        sql = f"""
        INSERT INTO agents (id, name, role, type, capabilities, config, short_term_memory, long_term_memory, communication_preferences, episodic_memory, procedural_memory, semantic_memory) 
        VALUES (
            '{agent['id']}',
            '{agent['name'].replace("'", "''")}',
            '{agent.get('role', '').replace("'", "''")}',
            '{agent.get('type', 'task')}',
            '[]'::jsonb,
            '{{}}'::jsonb,
            '[]'::jsonb,
            '[]'::jsonb,
            '{{}}'::jsonb,
            '[]'::jsonb,
            '[]'::jsonb,
            '[]'::jsonb
        );
        """
        
        result = subprocess.run([
            'docker', 'exec', '-i', 'supabase-db',
            'psql', '-U', 'postgres', '-d', 'postgres',
            '-c', sql
        ], capture_output=True, text=True)
        
        if result.returncode != 0:
            print(f"Error inserting {agent['name']}: {result.stderr}")
        else:
            print(f"Inserted {agent['name']}")
    
    # Insert some beliefs
    beliefs = [
        ("e18f66d5-ef52-4a6e-aea6-7e693148552b", "Data-driven marketing yields the best ROI"),
        ("f7e4b9c1-6d3a-4e8f-9b2a-8c5d3e4f9a1b", "Data quality determines insight accuracy"),
    ]
    
    for agent_id, belief in beliefs:
        sql = f"INSERT INTO agent_beliefs (agent_id, belief) VALUES ('{agent_id}', '{belief}') ON CONFLICT DO NOTHING;"
        subprocess.run([
            'docker', 'exec', '-i', 'supabase-db',
            'psql', '-U', 'postgres', '-d', 'postgres',
            '-c', sql
        ])
    
    # Insert some goals
    goals = [
        ("e18f66d5-ef52-4a6e-aea6-7e693148552b", "Increase brand awareness", 9),
        ("f7e4b9c1-6d3a-4e8f-9b2a-8c5d3e4f9a1b", "Implement analytics dashboard", 9),
    ]
    
    for agent_id, goal, priority in goals:
        sql = f"INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('{agent_id}', '{goal}', {priority}) ON CONFLICT DO NOTHING;"
        subprocess.run([
            'docker', 'exec', '-i', 'supabase-db',
            'psql', '-U', 'postgres', '-d', 'postgres',
            '-c', sql
        ])
    
    # Insert LLM configs
    configs = [
        ("e18f66d5-ef52-4a6e-aea6-7e693148552b", "gpt-4", 0.7, 2000),
        ("f7e4b9c1-6d3a-4e8f-9b2a-8c5d3e4f9a1b", "gpt-4", 0.3, 2000),
    ]
    
    for agent_id, model, temp, tokens in configs:
        sql = f"INSERT INTO agent_llm_config (agent_id, model, temperature, max_tokens) VALUES ('{agent_id}', '{model}', {temp}, {tokens}) ON CONFLICT (agent_id) DO UPDATE SET model = EXCLUDED.model;"
        subprocess.run([
            'docker', 'exec', '-i', 'supabase-db',
            'psql', '-U', 'postgres', '-d', 'postgres',
            '-c', sql
        ])
    
    # Verify
    result = subprocess.run([
        'docker', 'exec', '-i', 'supabase-db',
        'psql', '-U', 'postgres', '-d', 'postgres',
        '-c', 'SELECT COUNT(*) FROM agents;'
    ], capture_output=True, text=True)
    
    print("\n===== VERIFICATION =====")
    print(result.stdout)
    
    result = subprocess.run([
        'docker', 'exec', '-i', 'supabase-db',
        'psql', '-U', 'postgres', '-d', 'postgres',
        '-c', 'SELECT id, name, role FROM agents ORDER BY type, name;'
    ], capture_output=True, text=True)
    
    print(result.stdout)

if __name__ == "__main__":
    main()