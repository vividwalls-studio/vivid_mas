#!/usr/bin/env python3
import json
import subprocess
import sys

# Database credentials
DB_HOST = "supabase-db"
DB_NAME = "postgres"
DB_USER = "postgres"
DB_PASS = "myqP9lSMLobnuIfkUpXQzZg07"

def execute_sql(sql):
    """Execute SQL using docker exec and psql"""
    cmd = [
        "docker", "exec", "-i", "supabase-db",
        "psql", "-U", DB_USER, "-d", DB_NAME,
        "-c", sql
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error: {result.stderr}")
        return False
    return True

def insert_agents():
    """Insert agents from JSON file"""
    print("Loading agents from JSON...")
    
    with open('mcp_conversion/agents.json', 'r') as f:
        agents = json.load(f)
    
    print(f"Found {len(agents)} agents to insert")
    
    # Clear existing data
    print("Clearing existing agent data...")
    execute_sql("DELETE FROM agent_voice_config;")
    execute_sql("DELETE FROM agent_llm_config;")
    execute_sql("DELETE FROM agent_goals;")
    execute_sql("DELETE FROM agent_personalities;")
    execute_sql("DELETE FROM agent_domain_knowledge;")
    execute_sql("DELETE FROM agent_heuristic_imperatives;")
    execute_sql("DELETE FROM agent_intentions;")
    execute_sql("DELETE FROM agent_desires;")
    execute_sql("DELETE FROM agent_beliefs;")
    execute_sql("DELETE FROM agents;")
    
    # Insert agents
    success_count = 0
    for i, agent in enumerate(agents):
        agent_id = agent['id']
        name = agent['name'].replace("'", "''")
        role = agent.get('role', '').replace("'", "''")
        backstory = agent.get('backstory', '').replace("'", "''")
        agent_type = agent.get('type', 'task')
        
        sql = f"""
        INSERT INTO agents (
            id, name, role, backstory, type, 
            capabilities, config,
            short_term_memory, long_term_memory, communication_preferences,
            episodic_memory, procedural_memory, semantic_memory
        ) VALUES (
            '{agent_id}', '{name}', '{role}', '{backstory}', '{agent_type}',
            '[]'::jsonb, '{{}}'::jsonb,
            '[]'::jsonb, '[]'::jsonb, '[]'::jsonb,
            '[]'::jsonb, '[]'::jsonb, '[]'::jsonb
        ) ON CONFLICT (id) DO UPDATE SET
            name = EXCLUDED.name,
            role = EXCLUDED.role,
            backstory = EXCLUDED.backstory;
        """
        
        if execute_sql(sql):
            success_count += 1
            print(f"✓ Inserted agent {i+1}/{len(agents)}: {name}")
        else:
            print(f"✗ Failed to insert agent: {name}")
    
    print(f"\nSuccessfully inserted {success_count}/{len(agents)} agents")
    
    # Verify
    execute_sql("SELECT COUNT(*) FROM agents;")
    execute_sql("SELECT id, name, role FROM agents LIMIT 5;")

def insert_related_data():
    """Insert related data from JSON files"""
    tables = [
        ('agent_beliefs', 'agent_beliefs.json'),
        ('agent_desires', 'agent_desires.json'),
        ('agent_goals', 'agent_goals.json'),
        ('agent_llm_config', 'agent_llm_config.json'),
        ('agent_personalities', 'agent_personalities.json'),
        ('agent_voice_config', 'agent_voice_config.json')
    ]
    
    for table_name, file_name in tables:
        try:
            print(f"\nInserting {table_name}...")
            with open(f'mcp_conversion/{file_name}', 'r') as f:
                data = json.load(f)
            
            success_count = 0
            for item in data:
                # Build SQL based on table structure
                if table_name == 'agent_beliefs':
                    sql = f"""
                    INSERT INTO {table_name} (agent_id, belief)
                    VALUES ('{item['agent_id']}', '{item['belief'].replace("'", "''")}')
                    ON CONFLICT DO NOTHING;
                    """
                elif table_name == 'agent_desires':
                    sql = f"""
                    INSERT INTO {table_name} (agent_id, desire)
                    VALUES ('{item['agent_id']}', '{item['desire'].replace("'", "''")}')
                    ON CONFLICT DO NOTHING;
                    """
                elif table_name == 'agent_goals':
                    sql = f"""
                    INSERT INTO {table_name} (agent_id, goal, priority)
                    VALUES ('{item['agent_id']}', '{item['goal'].replace("'", "''")}', {item.get('priority', 5)})
                    ON CONFLICT DO NOTHING;
                    """
                elif table_name == 'agent_llm_config':
                    sql = f"""
                    INSERT INTO {table_name} (agent_id, provider, model, temperature, max_tokens)
                    VALUES ('{item['agent_id']}', '{item.get('provider', 'openai')}', 
                            '{item.get('model', 'gpt-4')}', {item.get('temperature', 0.7)}, 
                            {item.get('max_tokens', 2000)})
                    ON CONFLICT (agent_id) DO UPDATE SET
                        provider = EXCLUDED.provider,
                        model = EXCLUDED.model;
                    """
                elif table_name == 'agent_personalities':
                    sql = f"""
                    INSERT INTO {table_name} (agent_id, trait)
                    VALUES ('{item['agent_id']}', '{item['trait'].replace("'", "''")}')
                    ON CONFLICT DO NOTHING;
                    """
                elif table_name == 'agent_voice_config':
                    sql = f"""
                    INSERT INTO {table_name} (agent_id, style, tone)
                    VALUES ('{item['agent_id']}', '{item.get('style', '').replace("'", "''")}', 
                            '{item.get('tone', '').replace("'", "''")}')
                    ON CONFLICT (agent_id) DO UPDATE SET
                        style = EXCLUDED.style,
                        tone = EXCLUDED.tone;
                    """
                
                if execute_sql(sql):
                    success_count += 1
            
            print(f"✓ Inserted {success_count}/{len(data)} records into {table_name}")
            
        except Exception as e:
            print(f"✗ Error with {table_name}: {e}")

if __name__ == "__main__":
    print("=== JSON to Database Insertion ===")
    insert_agents()
    insert_related_data()
    
    print("\n=== Final Summary ===")
    execute_sql("""
    SELECT 
        'agents' as table_name, COUNT(*) as count FROM agents
    UNION ALL SELECT 'agent_beliefs', COUNT(*) FROM agent_beliefs
    UNION ALL SELECT 'agent_desires', COUNT(*) FROM agent_desires
    UNION ALL SELECT 'agent_goals', COUNT(*) FROM agent_goals
    UNION ALL SELECT 'agent_llm_config', COUNT(*) FROM agent_llm_config
    ORDER BY table_name;
    """)