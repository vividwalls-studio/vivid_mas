#!/usr/bin/env python3
"""
Insert sample agent data to test the Multi-Agent System schema
"""

import psycopg2
import json
from datetime import datetime, timedelta

# Database connection configuration
DB_CONFIG = {
    'host': 'localhost',
    'port': 54322,
    'database': 'postgres',
    'user': 'postgres',
    'password': 'postgres'
}

def insert_sample_data():
    """Insert sample agent and related data"""
    
    conn = None
    cur = None
    
    try:
        # Connect to the database
        print("Connecting to database...")
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        # 1. Create a sample agent
        print("\n1. Creating sample agent...")
        cur.execute("""
            INSERT INTO agents (name, role, backstory)
            VALUES (%s, %s, %s)
            RETURNING id;
        """, (
            "ResearchAgent",
            "Senior Research Analyst",
            "An experienced research analyst specializing in market analysis and competitive intelligence. Known for thorough investigation and data-driven insights."
        ))
        agent_id = cur.fetchone()[0]
        print(f"   ✓ Created agent with ID: {agent_id}")
        
        # 2. Add BDI components
        print("\n2. Adding BDI components...")
        
        # Beliefs
        cur.execute("""
            INSERT INTO agent_beliefs (agent_id, belief_type, belief_content, confidence)
            VALUES (%s, %s, %s, %s);
        """, (
            agent_id,
            "market_state",
            json.dumps({
                "current_trends": ["AI adoption", "sustainability"],
                "growth_rate": 15.2,
                "key_players": ["Company A", "Company B", "Company C"]
            }),
            0.85
        ))
        print("   ✓ Added belief")
        
        # Desires
        cur.execute("""
            INSERT INTO agent_desires (agent_id, desire_type, desire_content, priority)
            VALUES (%s, %s, %s, %s);
        """, (
            agent_id,
            "research_goal",
            json.dumps({
                "objective": "Complete comprehensive market analysis",
                "scope": "Global AI market",
                "deliverable": "50-page report"
            }),
            9
        ))
        print("   ✓ Added desire")
        
        # Intentions
        cur.execute("""
            INSERT INTO agent_intentions (agent_id, intention_type, intention_content, status)
            VALUES (%s, %s, %s, %s);
        """, (
            agent_id,
            "immediate_action",
            json.dumps({
                "action": "Gather latest market data",
                "sources": ["industry reports", "news articles", "expert interviews"],
                "timeline": "2 days"
            }),
            'active'
        ))
        print("   ✓ Added intention")
        
        # 3. Add heuristic imperatives
        print("\n3. Adding heuristic imperatives...")
        imperatives = [
            ('reduce_suffering', 'Ensure research recommendations minimize negative market impacts', 0.8),
            ('increase_prosperity', 'Focus on identifying growth opportunities and market efficiencies', 0.9),
            ('increase_understanding', 'Provide clear, actionable insights that enhance market knowledge', 0.95)
        ]
        
        for imp_type, desc, weight in imperatives:
            cur.execute("""
                INSERT INTO heuristic_imperatives (agent_id, imperative_type, description, weight)
                VALUES (%s, %s, %s, %s);
            """, (agent_id, imp_type, desc, weight))
        print("   ✓ Added 3 heuristic imperatives")
        
        # 4. Add memory entries
        print("\n4. Adding memory entries...")
        
        # Short-term memory
        cur.execute("""
            INSERT INTO short_term_memory (agent_id, memory_content, context, importance, expires_at)
            VALUES (%s, %s, %s, %s, %s);
        """, (
            agent_id,
            json.dumps({
                "event": "CEO announcement",
                "company": "TechCorp",
                "details": "New AI product launch next quarter"
            }),
            "Market news",
            0.7,
            datetime.now() + timedelta(hours=24)
        ))
        print("   ✓ Added short-term memory")
        
        # Long-term memory
        cur.execute("""
            INSERT INTO long_term_memory (agent_id, memory_content, memory_type, tags, importance)
            VALUES (%s, %s, %s, %s, %s);
        """, (
            agent_id,
            json.dumps({
                "concept": "Market cycle patterns",
                "pattern": "Tech stocks follow 7-year cycles",
                "evidence": ["Historical data 2000-2023", "Academic studies"]
            }),
            'semantic',
            ['market_analysis', 'patterns', 'tech_sector'],
            0.9
        ))
        print("   ✓ Added long-term memory")
        
        # Episodic memory
        cur.execute("""
            INSERT INTO episodic_memory (agent_id, episode_content, episode_timestamp, location, participants, emotions, importance)
            VALUES (%s, %s, %s, %s, %s, %s, %s);
        """, (
            agent_id,
            json.dumps({
                "event": "Industry conference presentation",
                "topic": "Future of AI in Finance",
                "outcome": "Positive reception, 3 partnership inquiries"
            }),
            datetime.now() - timedelta(days=7),
            "New York Convention Center",
            ['John Smith - CEO FinTech Inc', 'Jane Doe - CTO BankCorp'],
            json.dumps({"primary": "confident", "secondary": "excited"}),
            0.85
        ))
        print("   ✓ Added episodic memory")
        
        # 5. Add personality
        print("\n5. Adding personality (Big Five)...")
        cur.execute("""
            INSERT INTO agent_personalities (agent_id, openness, conscientiousness, extraversion, agreeableness, neuroticism)
            VALUES (%s, %s, %s, %s, %s, %s);
        """, (agent_id, 0.9, 0.95, 0.6, 0.8, 0.3))
        print("   ✓ Added personality traits")
        
        # 6. Add goals and objectives
        print("\n6. Adding goals and objectives...")
        cur.execute("""
            INSERT INTO agent_goals (agent_id, goal_type, goal_description, target_date, priority)
            VALUES (%s, %s, %s, %s, %s)
            RETURNING id;
        """, (
            agent_id,
            'primary',
            'Become the leading AI market analysis expert in the industry',
            datetime.now() + timedelta(days=365),
            10
        ))
        goal_id = cur.fetchone()[0]
        print("   ✓ Added primary goal")
        
        cur.execute("""
            INSERT INTO agent_objectives (goal_id, objective_description, measurable_criteria, completion_percentage)
            VALUES (%s, %s, %s, %s);
        """, (
            goal_id,
            'Publish 10 comprehensive market reports',
            json.dumps({
                "target": 10,
                "current": 3,
                "quality_threshold": "peer-reviewed"
            }),
            30.0
        ))
        print("   ✓ Added objective")
        
        # 7. Add LLM configuration
        print("\n7. Adding LLM configuration...")
        cur.execute("""
            INSERT INTO llm_configurations (agent_id, model_name, temperature, max_tokens, top_p, system_prompt)
            VALUES (%s, %s, %s, %s, %s, %s);
        """, (
            agent_id,
            'gpt-4-turbo',
            0.7,
            4000,
            0.9,
            "You are a senior research analyst with expertise in market analysis and competitive intelligence. Provide data-driven insights and thorough analysis."
        ))
        print("   ✓ Added LLM configuration")
        
        # 8. Create a skill and associate it
        print("\n8. Adding skills...")
        cur.execute("""
            INSERT INTO skills (name, description, skill_type, required_tools)
            VALUES (%s, %s, %s, %s)
            RETURNING id;
        """, (
            "Market Analysis",
            "Comprehensive market research and competitive analysis",
            "research",
            ['web_search', 'data_analysis', 'report_generation']
        ))
        skill_id = cur.fetchone()[0]
        
        cur.execute("""
            INSERT INTO agent_skills (agent_id, skill_id, proficiency_level, usage_count)
            VALUES (%s, %s, %s, %s);
        """, (agent_id, skill_id, 0.95, 150))
        print("   ✓ Added skill and association")
        
        # 9. Create a workflow
        print("\n9. Creating workflow...")
        cur.execute("""
            INSERT INTO workflows (name, description, workflow_type, workflow_definition)
            VALUES (%s, %s, %s, %s)
            RETURNING id;
        """, (
            "Market Research Workflow",
            "Standard workflow for conducting market research",
            "research",
            json.dumps({
                "steps": [
                    {"id": 1, "name": "Define scope", "duration": "1 day"},
                    {"id": 2, "name": "Gather data", "duration": "3 days"},
                    {"id": 3, "name": "Analyze findings", "duration": "2 days"},
                    {"id": 4, "name": "Generate report", "duration": "1 day"}
                ]
            })
        ))
        workflow_id = cur.fetchone()[0]
        
        cur.execute("""
            INSERT INTO agent_workflows (agent_id, workflow_id, role_in_workflow, permissions)
            VALUES (%s, %s, %s, %s);
        """, (
            agent_id,
            workflow_id,
            "Lead Analyst",
            json.dumps({"can_modify": True, "can_delegate": True})
        ))
        print("   ✓ Added workflow and association")
        
        # 10. Create a task
        print("\n10. Creating task...")
        cur.execute("""
            INSERT INTO tasks (name, description, assigned_agent_id, priority, status, deadline)
            VALUES (%s, %s, %s, %s, %s, %s);
        """, (
            "Q1 2024 AI Market Analysis",
            "Comprehensive analysis of AI market trends for Q1 2024",
            agent_id,
            8,
            'in_progress',
            datetime.now() + timedelta(days=14)
        ))
        print("   ✓ Added task")
        
        # 11. Add voice configuration
        print("\n11. Adding voice configuration...")
        cur.execute("""
            INSERT INTO voice_configurations (agent_id, voice_provider, voice_id, language, speech_rate, pitch)
            VALUES (%s, %s, %s, %s, %s, %s);
        """, (
            agent_id,
            'elevenlabs',
            'voice_professional_female_01',
            'en-US',
            1.0,
            1.0
        ))
        print("   ✓ Added voice configuration")
        
        # Commit all changes
        conn.commit()
        print("\n✅ Sample data inserted successfully!")
        
        # Query to verify
        print("\n📊 Verification - Agent Summary:")
        cur.execute("""
            SELECT 
                a.name,
                a.role,
                COUNT(DISTINCT ab.id) as beliefs,
                COUNT(DISTINCT ad.id) as desires,
                COUNT(DISTINCT ai.id) as intentions,
                COUNT(DISTINCT stm.id) as short_term_memories,
                COUNT(DISTINCT ltm.id) as long_term_memories,
                COUNT(DISTINCT em.id) as episodic_memories,
                COUNT(DISTINCT ag.id) as goals,
                COUNT(DISTINCT asks.id) as skills,
                COUNT(DISTINCT t.id) as tasks
            FROM agents a
            LEFT JOIN agent_beliefs ab ON a.id = ab.agent_id
            LEFT JOIN agent_desires ad ON a.id = ad.agent_id
            LEFT JOIN agent_intentions ai ON a.id = ai.agent_id
            LEFT JOIN short_term_memory stm ON a.id = stm.agent_id
            LEFT JOIN long_term_memory ltm ON a.id = ltm.agent_id
            LEFT JOIN episodic_memory em ON a.id = em.agent_id
            LEFT JOIN agent_goals ag ON a.id = ag.agent_id
            LEFT JOIN agent_skills asks ON a.id = asks.agent_id
            LEFT JOIN tasks t ON a.id = t.assigned_agent_id
            WHERE a.id = %s
            GROUP BY a.id, a.name, a.role;
        """, (agent_id,))
        
        result = cur.fetchone()
        if result:
            print(f"\nAgent: {result[0]} ({result[1]})")
            print(f"- Beliefs: {result[2]}")
            print(f"- Desires: {result[3]}")
            print(f"- Intentions: {result[4]}")
            print(f"- Short-term memories: {result[5]}")
            print(f"- Long-term memories: {result[6]}")
            print(f"- Episodic memories: {result[7]}")
            print(f"- Goals: {result[8]}")
            print(f"- Skills: {result[9]}")
            print(f"- Tasks: {result[10]}")
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        if conn:
            conn.rollback()
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

if __name__ == "__main__":
    insert_sample_data()