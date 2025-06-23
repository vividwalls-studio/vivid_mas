#!/usr/bin/env python3
import subprocess

def main():
    # Add beliefs for actual agent IDs
    beliefs = [
        ("56f395dc-48ee-421e-996f-53f5f35fa470", "Data-driven marketing yields the best ROI"),  # MarketingDirectorAgent
        ("56f395dc-48ee-421e-996f-53f5f35fa470", "Customer experience is the key differentiator"),
        ("56f395dc-48ee-421e-996f-53f5f35fa470", "Brand consistency builds trust"),
        ("b8f700f4-b69a-428f-8948-e3a08bfc4899", "Data quality determines insight accuracy"),  # AnalyticsDirectorAgent
        ("b8f700f4-b69a-428f-8948-e3a08bfc4899", "Real-time analytics enable agile decisions"),
        ("167bbc92-05c0-4285-91fa-55d8f726011e", "Customer satisfaction drives business growth"),  # CustomerExperienceDirectorAgent
        ("05188674-63af-476a-b05a-ef374b64979f", "Product innovation requires customer feedback"),  # ProductDirectorAgent
        ("db124b5f-cdc5-44d5-b74a-aea83081df64", "Financial discipline ensures sustainability"),  # FinanceDirectorAgent
        ("4f2bdcc2-4e53-41c7-88f0-c4456bb4ef33", "Efficient operations create competitive advantage"),  # OperationsDirectorAgent
        ("7de0448a-70ae-4e25-864a-04f71bf84c81", "Technology enables business transformation"),  # TechnologyDirectorAgent
    ]
    
    print("Adding beliefs...")
    for agent_id, belief in beliefs:
        sql = f"INSERT INTO agent_beliefs (agent_id, belief) VALUES ('{agent_id}', '{belief}') ON CONFLICT DO NOTHING;"
        result = subprocess.run([
            'docker', 'exec', '-i', 'supabase-db',
            'psql', '-U', 'postgres', '-d', 'postgres',
            '-c', sql
        ], capture_output=True, text=True)
        if result.returncode == 0:
            print(f"✓ Added belief for agent {agent_id[:8]}...")
        else:
            print(f"✗ Error: {result.stderr.strip()}")
    
    # Add goals
    goals = [
        ("56f395dc-48ee-421e-996f-53f5f35fa470", "Increase brand awareness by 30%", 9),
        ("56f395dc-48ee-421e-996f-53f5f35fa470", "Improve customer acquisition cost", 8),
        ("56f395dc-48ee-421e-996f-53f5f35fa470", "Launch omnichannel marketing strategy", 7),
        ("b8f700f4-b69a-428f-8948-e3a08bfc4899", "Implement real-time analytics dashboard", 9),
        ("b8f700f4-b69a-428f-8948-e3a08bfc4899", "Reduce data processing time by 50%", 8),
        ("167bbc92-05c0-4285-91fa-55d8f726011e", "Improve NPS score by 20 points", 9),
        ("05188674-63af-476a-b05a-ef374b64979f", "Launch 3 new product lines", 8),
        ("db124b5f-cdc5-44d5-b74a-aea83081df64", "Optimize marketing spend ROI", 9),
        ("4f2bdcc2-4e53-41c7-88f0-c4456bb4ef33", "Reduce shipping times by 25%", 8),
        ("7de0448a-70ae-4e25-864a-04f71bf84c81", "Implement AI-driven personalization", 9),
    ]
    
    print("\nAdding goals...")
    for agent_id, goal, priority in goals:
        sql = f"INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('{agent_id}', '{goal}', {priority}) ON CONFLICT DO NOTHING;"
        result = subprocess.run([
            'docker', 'exec', '-i', 'supabase-db',
            'psql', '-U', 'postgres', '-d', 'postgres',
            '-c', sql
        ], capture_output=True, text=True)
        if result.returncode == 0:
            print(f"✓ Added goal for agent {agent_id[:8]}...")
        else:
            print(f"✗ Error: {result.stderr.strip()}")
    
    # Add LLM configs
    configs = [
        ("56f395dc-48ee-421e-996f-53f5f35fa470", "gpt-4", 0.7, 2000),  # Marketing - creative
        ("b8f700f4-b69a-428f-8948-e3a08bfc4899", "gpt-4", 0.3, 2000),  # Analytics - precise
        ("167bbc92-05c0-4285-91fa-55d8f726011e", "gpt-4", 0.8, 2000),  # Customer - empathetic
        ("05188674-63af-476a-b05a-ef374b64979f", "gpt-4", 0.5, 2000),  # Product - balanced
        ("db124b5f-cdc5-44d5-b74a-aea83081df64", "gpt-4", 0.2, 2000),  # Finance - analytical
        ("4f2bdcc2-4e53-41c7-88f0-c4456bb4ef33", "gpt-4", 0.4, 2000),  # Operations - practical
        ("7de0448a-70ae-4e25-864a-04f71bf84c81", "gpt-4", 0.3, 2000),  # Technology - technical
    ]
    
    print("\nAdding LLM configs...")
    for agent_id, model, temp, tokens in configs:
        sql = f"INSERT INTO agent_llm_config (agent_id, model, temperature, max_tokens) VALUES ('{agent_id}', '{model}', {temp}, {tokens}) ON CONFLICT (agent_id) DO UPDATE SET model = EXCLUDED.model, temperature = EXCLUDED.temperature;"
        result = subprocess.run([
            'docker', 'exec', '-i', 'supabase-db',
            'psql', '-U', 'postgres', '-d', 'postgres',
            '-c', sql
        ], capture_output=True, text=True)
        if result.returncode == 0:
            print(f"✓ Added LLM config for agent {agent_id[:8]}...")
        else:
            print(f"✗ Error: {result.stderr.strip()}")
    
    # Final verification
    print("\n===== FINAL VERIFICATION =====")
    
    # Count records in each table
    tables = ['agents', 'agent_beliefs', 'agent_goals', 'agent_llm_config']
    for table in tables:
        result = subprocess.run([
            'docker', 'exec', '-i', 'supabase-db',
            'psql', '-U', 'postgres', '-d', 'postgres',
            '-c', f'SELECT COUNT(*) FROM {table};'
        ], capture_output=True, text=True)
        count = result.stdout.strip().split('\n')[2].strip()
        print(f"{table}: {count} records")
    
    # Show sample data
    print("\nSample agent with full data:")
    result = subprocess.run([
        'docker', 'exec', '-i', 'supabase-db',
        'psql', '-U', 'postgres', '-d', 'postgres',
        '-c', """
        SELECT 
            a.name,
            a.role,
            array_agg(DISTINCT b.belief) as beliefs,
            array_agg(DISTINCT g.goal || ' (P' || g.priority || ')') as goals,
            l.model,
            l.temperature
        FROM agents a
        LEFT JOIN agent_beliefs b ON a.id = b.agent_id
        LEFT JOIN agent_goals g ON a.id = g.agent_id
        LEFT JOIN agent_llm_config l ON a.id = l.agent_id
        WHERE a.name = 'MarketingDirectorAgent'
        GROUP BY a.name, a.role, l.model, l.temperature;
        """
    ], capture_output=True, text=True)
    
    print(result.stdout)

if __name__ == "__main__":
    main()