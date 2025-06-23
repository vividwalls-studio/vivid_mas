#!/usr/bin/env python3
"""
Create Multi-Agent System Database Schema in Supabase
This version handles existing tables and creates a clean schema
"""

import psycopg2
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Database connection configuration
DB_CONFIG = {
    'host': 'localhost',
    'port': 54322,  # Supabase database port
    'database': 'postgres',
    'user': 'postgres',
    'password': 'postgres'  # Default Supabase password
}

def create_schema():
    """Create all tables for the multi-agent system"""
    
    conn = None
    cur = None
    
    try:
        # Connect to the database
        print("Connecting to Supabase database...")
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        # First, let's check if the 'workflows' table has a different structure
        cur.execute("""
            SELECT column_name, data_type 
            FROM information_schema.columns 
            WHERE table_name = 'workflows' 
            AND table_schema = 'public'
            ORDER BY ordinal_position;
        """)
        
        existing_workflow_cols = cur.fetchall()
        if existing_workflow_cols:
            print("\nExisting 'workflows' table structure:")
            for col in existing_workflow_cols:
                print(f"  - {col[0]}: {col[1]}")
            
            # Rename existing workflows table to preserve data
            print("\nRenaming existing 'workflows' table to 'workflows_old'...")
            cur.execute("ALTER TABLE IF EXISTS workflows RENAME TO workflows_old;")
            conn.commit()
        
        # Enable UUID extension
        print("\nEnabling UUID extension...")
        cur.execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";")
        
        # Create all tables
        print("\nCreating Multi-Agent System tables...")
        
        # 1. Main agents table
        cur.execute("""
        CREATE TABLE IF NOT EXISTS agents (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            name VARCHAR(255) NOT NULL UNIQUE,
            role TEXT NOT NULL,
            backstory TEXT,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created agents table")
        
        # 2. BDI Architecture Tables
        cur.execute("""
        CREATE TABLE IF NOT EXISTS agent_beliefs (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            belief_type VARCHAR(100) NOT NULL,
            belief_content JSONB NOT NULL,
            confidence DECIMAL(3,2) CHECK (confidence >= 0 AND confidence <= 1),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created agent_beliefs table")
        
        cur.execute("""
        CREATE TABLE IF NOT EXISTS agent_desires (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            desire_type VARCHAR(100) NOT NULL,
            desire_content JSONB NOT NULL,
            priority INTEGER CHECK (priority >= 1 AND priority <= 10),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created agent_desires table")
        
        cur.execute("""
        CREATE TABLE IF NOT EXISTS agent_intentions (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            intention_type VARCHAR(100) NOT NULL,
            intention_content JSONB NOT NULL,
            status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'completed', 'failed')),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created agent_intentions table")
        
        # 3. Heuristic imperatives table
        cur.execute("""
        CREATE TABLE IF NOT EXISTS heuristic_imperatives (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            imperative_type VARCHAR(50) CHECK (imperative_type IN ('reduce_suffering', 'increase_prosperity', 'increase_understanding')),
            description TEXT NOT NULL,
            weight DECIMAL(3,2) CHECK (weight >= 0 AND weight <= 1),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created heuristic_imperatives table")
        
        # 4. Memory subsystem tables
        cur.execute("""
        CREATE TABLE IF NOT EXISTS short_term_memory (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            memory_content JSONB NOT NULL,
            context TEXT,
            importance DECIMAL(3,2) CHECK (importance >= 0 AND importance <= 1),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            expires_at TIMESTAMP WITH TIME ZONE
        );
        """)
        print("  ✓ Created short_term_memory table")
        
        cur.execute("""
        CREATE TABLE IF NOT EXISTS long_term_memory (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            memory_content JSONB NOT NULL,
            memory_type VARCHAR(50) CHECK (memory_type IN ('semantic', 'procedural', 'declarative')),
            tags TEXT[],
            importance DECIMAL(3,2) CHECK (importance >= 0 AND importance <= 1),
            retrieval_count INTEGER DEFAULT 0,
            last_accessed TIMESTAMP WITH TIME ZONE,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created long_term_memory table")
        
        cur.execute("""
        CREATE TABLE IF NOT EXISTS episodic_memory (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            episode_content JSONB NOT NULL,
            episode_timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
            location TEXT,
            participants TEXT[],
            emotions JSONB,
            importance DECIMAL(3,2) CHECK (importance >= 0 AND importance <= 1),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created episodic_memory table")
        
        # 5. Domain knowledge tables
        cur.execute("""
        CREATE TABLE IF NOT EXISTS domain_knowledge (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            knowledge_type VARCHAR(50) CHECK (knowledge_type IN ('vector_db', 'knowledge_graph', 'relational_db')),
            source_name VARCHAR(255) NOT NULL,
            connection_config JSONB,
            metadata JSONB,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created domain_knowledge table")
        
        # 6. Personality table (Big Five traits)
        cur.execute("""
        CREATE TABLE IF NOT EXISTS agent_personalities (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE UNIQUE,
            openness DECIMAL(3,2) CHECK (openness >= 0 AND openness <= 1),
            conscientiousness DECIMAL(3,2) CHECK (conscientiousness >= 0 AND conscientiousness <= 1),
            extraversion DECIMAL(3,2) CHECK (extraversion >= 0 AND extraversion <= 1),
            agreeableness DECIMAL(3,2) CHECK (agreeableness >= 0 AND agreeableness <= 1),
            neuroticism DECIMAL(3,2) CHECK (neuroticism >= 0 AND neuroticism <= 1),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created agent_personalities table")
        
        # 7. Goals and objectives tables
        cur.execute("""
        CREATE TABLE IF NOT EXISTS agent_goals (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            goal_type VARCHAR(50) CHECK (goal_type IN ('primary', 'secondary', 'tertiary')),
            goal_description TEXT NOT NULL,
            target_date TIMESTAMP WITH TIME ZONE,
            status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'completed', 'failed', 'suspended')),
            priority INTEGER CHECK (priority >= 1 AND priority <= 10),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created agent_goals table")
        
        cur.execute("""
        CREATE TABLE IF NOT EXISTS agent_objectives (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            goal_id UUID NOT NULL REFERENCES agent_goals(id) ON DELETE CASCADE,
            objective_description TEXT NOT NULL,
            measurable_criteria JSONB,
            completion_percentage DECIMAL(5,2) DEFAULT 0 CHECK (completion_percentage >= 0 AND completion_percentage <= 100),
            status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed', 'failed')),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created agent_objectives table")
        
        # 8. Instructions and rules tables
        cur.execute("""
        CREATE TABLE IF NOT EXISTS agent_instructions (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            instruction_type VARCHAR(50) CHECK (instruction_type IN ('general', 'task_specific', 'interaction', 'safety')),
            instruction_content TEXT NOT NULL,
            priority INTEGER CHECK (priority >= 1 AND priority <= 10),
            is_active BOOLEAN DEFAULT true,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created agent_instructions table")
        
        cur.execute("""
        CREATE TABLE IF NOT EXISTS agent_rules (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            rule_type VARCHAR(50) CHECK (rule_type IN ('constraint', 'permission', 'obligation', 'prohibition')),
            rule_content TEXT NOT NULL,
            rule_conditions JSONB,
            enforcement_level VARCHAR(50) CHECK (enforcement_level IN ('strict', 'flexible', 'advisory')),
            is_active BOOLEAN DEFAULT true,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created agent_rules table")
        
        # 9. LLM configuration table
        cur.execute("""
        CREATE TABLE IF NOT EXISTS llm_configurations (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE UNIQUE,
            model_name VARCHAR(255) NOT NULL,
            temperature DECIMAL(3,2) CHECK (temperature >= 0 AND temperature <= 2),
            max_tokens INTEGER,
            top_p DECIMAL(3,2) CHECK (top_p >= 0 AND top_p <= 1),
            frequency_penalty DECIMAL(3,2) CHECK (frequency_penalty >= -2 AND frequency_penalty <= 2),
            presence_penalty DECIMAL(3,2) CHECK (presence_penalty >= -2 AND presence_penalty <= 2),
            system_prompt TEXT,
            additional_config JSONB,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created llm_configurations table")
        
        # 10. Workflows table
        cur.execute("""
        CREATE TABLE IF NOT EXISTS workflows (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            name VARCHAR(255) NOT NULL UNIQUE,
            description TEXT,
            workflow_type VARCHAR(50),
            workflow_definition JSONB NOT NULL,
            is_active BOOLEAN DEFAULT true,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created workflows table")
        
        cur.execute("""
        CREATE TABLE IF NOT EXISTS agent_workflows (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            workflow_id UUID NOT NULL REFERENCES workflows(id) ON DELETE CASCADE,
            role_in_workflow VARCHAR(100),
            permissions JSONB,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(agent_id, workflow_id)
        );
        """)
        print("  ✓ Created agent_workflows table")
        
        # 11. Skills table
        cur.execute("""
        CREATE TABLE IF NOT EXISTS skills (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            name VARCHAR(255) NOT NULL UNIQUE,
            description TEXT,
            skill_type VARCHAR(50),
            required_tools TEXT[],
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created skills table")
        
        cur.execute("""
        CREATE TABLE IF NOT EXISTS agent_skills (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            skill_id UUID NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
            proficiency_level DECIMAL(3,2) CHECK (proficiency_level >= 0 AND proficiency_level <= 1),
            last_used TIMESTAMP WITH TIME ZONE,
            usage_count INTEGER DEFAULT 0,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(agent_id, skill_id)
        );
        """)
        print("  ✓ Created agent_skills table")
        
        # 12. Tasks table with delegation support
        cur.execute("""
        CREATE TABLE IF NOT EXISTS tasks (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            name VARCHAR(255) NOT NULL,
            description TEXT,
            assigned_agent_id UUID REFERENCES agents(id) ON DELETE SET NULL,
            delegated_from_agent_id UUID REFERENCES agents(id) ON DELETE SET NULL,
            parent_task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
            task_type VARCHAR(50),
            priority INTEGER CHECK (priority >= 1 AND priority <= 10),
            status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'assigned', 'in_progress', 'completed', 'failed', 'cancelled')),
            deadline TIMESTAMP WITH TIME ZONE,
            result JSONB,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            completed_at TIMESTAMP WITH TIME ZONE
        );
        """)
        print("  ✓ Created tasks table")
        
        # 13. Tools table for MCP server tools
        cur.execute("""
        CREATE TABLE IF NOT EXISTS mcp_tools (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            name VARCHAR(255) NOT NULL UNIQUE,
            description TEXT,
            mcp_server_name VARCHAR(255) NOT NULL,
            tool_schema JSONB NOT NULL,
            required_permissions TEXT[],
            is_active BOOLEAN DEFAULT true,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created mcp_tools table")
        
        cur.execute("""
        CREATE TABLE IF NOT EXISTS agent_tools (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            tool_id UUID NOT NULL REFERENCES mcp_tools(id) ON DELETE CASCADE,
            access_level VARCHAR(50) CHECK (access_level IN ('read', 'write', 'execute', 'admin')),
            usage_count INTEGER DEFAULT 0,
            last_used TIMESTAMP WITH TIME ZONE,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(agent_id, tool_id)
        );
        """)
        print("  ✓ Created agent_tools table")
        
        # 14. Voice configuration table
        cur.execute("""
        CREATE TABLE IF NOT EXISTS voice_configurations (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE UNIQUE,
            voice_provider VARCHAR(50) CHECK (voice_provider IN ('elevenlabs', 'openai', 'google', 'amazon', 'azure')),
            voice_id VARCHAR(255),
            voice_settings JSONB,
            language VARCHAR(10) DEFAULT 'en-US',
            speech_rate DECIMAL(3,2) CHECK (speech_rate >= 0.5 AND speech_rate <= 2.0),
            pitch DECIMAL(3,2) CHECK (pitch >= 0.5 AND pitch <= 2.0),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """)
        print("  ✓ Created voice_configurations table")
        
        # Create indexes
        print("\nCreating indexes...")
        indexes = [
            ("idx_agent_beliefs_agent_id", "agent_beliefs(agent_id)"),
            ("idx_agent_desires_agent_id", "agent_desires(agent_id)"),
            ("idx_agent_intentions_agent_id", "agent_intentions(agent_id)"),
            ("idx_agent_intentions_status", "agent_intentions(status)"),
            ("idx_short_term_memory_agent_id", "short_term_memory(agent_id)"),
            ("idx_short_term_memory_expires", "short_term_memory(expires_at)"),
            ("idx_long_term_memory_agent_id", "long_term_memory(agent_id)"),
            ("idx_long_term_memory_tags", "long_term_memory USING GIN(tags)"),
            ("idx_episodic_memory_agent_id", "episodic_memory(agent_id)"),
            ("idx_episodic_memory_timestamp", "episodic_memory(episode_timestamp)"),
            ("idx_agent_goals_agent_id", "agent_goals(agent_id)"),
            ("idx_agent_goals_status", "agent_goals(status)"),
            ("idx_agent_objectives_goal_id", "agent_objectives(goal_id)"),
            ("idx_agent_instructions_agent_id", "agent_instructions(agent_id)"),
            ("idx_agent_rules_agent_id", "agent_rules(agent_id)"),
            ("idx_tasks_assigned_agent", "tasks(assigned_agent_id)"),
            ("idx_tasks_status", "tasks(status)"),
            ("idx_tasks_deadline", "tasks(deadline)")
        ]
        
        for idx_name, idx_def in indexes:
            cur.execute(f"CREATE INDEX IF NOT EXISTS {idx_name} ON {idx_def};")
        print("  ✓ Created all indexes")
        
        # Create trigger function
        print("\nCreating trigger function...")
        cur.execute("""
        CREATE OR REPLACE FUNCTION update_updated_at_column()
        RETURNS TRIGGER AS $$
        BEGIN
            NEW.updated_at = CURRENT_TIMESTAMP;
            RETURN NEW;
        END;
        $$ language 'plpgsql';
        """)
        print("  ✓ Created update_updated_at_column function")
        
        # Create triggers
        print("\nCreating triggers...")
        trigger_tables = [
            'agents', 'agent_beliefs', 'agent_desires', 'agent_intentions',
            'long_term_memory', 'domain_knowledge', 'agent_personalities',
            'agent_goals', 'agent_objectives', 'agent_instructions', 'agent_rules',
            'llm_configurations', 'workflows', 'tasks', 'mcp_tools', 'voice_configurations'
        ]
        
        for table in trigger_tables:
            trigger_name = f"update_{table}_updated_at"
            cur.execute(f"DROP TRIGGER IF EXISTS {trigger_name} ON {table};")
            cur.execute(f"""
                CREATE TRIGGER {trigger_name} 
                BEFORE UPDATE ON {table}
                FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
            """)
        print("  ✓ Created all triggers")
        
        # Commit all changes
        conn.commit()
        
        # List all created MAS tables
        print("\n✅ Multi-Agent System schema created successfully!")
        print("\nCreated tables:")
        cur.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_type = 'BASE TABLE'
            AND (
                table_name LIKE 'agent_%' 
                OR table_name IN ('agents', 'workflows', 'skills', 'tasks', 'mcp_tools', 
                                  'voice_configurations', 'heuristic_imperatives', 
                                  'short_term_memory', 'long_term_memory', 'episodic_memory', 
                                  'domain_knowledge', 'llm_configurations')
            )
            ORDER BY table_name;
        """)
        
        tables = cur.fetchall()
        for table in tables:
            print(f"  - {table[0]}")
        
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
    create_schema()