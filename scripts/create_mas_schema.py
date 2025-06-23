#!/usr/bin/env python3
"""
Create Multi-Agent System Database Schema in Supabase
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

def create_tables():
    """Create all tables for the multi-agent system"""
    
    sql_statements = [
        # Enable UUID extension
        "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";",
        
        # 1. Main agents table
        """
        CREATE TABLE IF NOT EXISTS agents (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            name VARCHAR(255) NOT NULL UNIQUE,
            role TEXT NOT NULL,
            backstory TEXT,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """,
        
        # 2. BDI Architecture Tables
        """
        CREATE TABLE IF NOT EXISTS agent_beliefs (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            belief_type VARCHAR(100) NOT NULL,
            belief_content JSONB NOT NULL,
            confidence DECIMAL(3,2) CHECK (confidence >= 0 AND confidence <= 1),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """,
        
        """
        CREATE TABLE IF NOT EXISTS agent_desires (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            desire_type VARCHAR(100) NOT NULL,
            desire_content JSONB NOT NULL,
            priority INTEGER CHECK (priority >= 1 AND priority <= 10),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """,
        
        """
        CREATE TABLE IF NOT EXISTS agent_intentions (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            intention_type VARCHAR(100) NOT NULL,
            intention_content JSONB NOT NULL,
            status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'completed', 'failed')),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """,
        
        # 3. Heuristic imperatives table
        """
        CREATE TABLE IF NOT EXISTS heuristic_imperatives (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            imperative_type VARCHAR(50) CHECK (imperative_type IN ('reduce_suffering', 'increase_prosperity', 'increase_understanding')),
            description TEXT NOT NULL,
            weight DECIMAL(3,2) CHECK (weight >= 0 AND weight <= 1),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """,
        
        # 4. Memory subsystem tables
        """
        CREATE TABLE IF NOT EXISTS short_term_memory (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            memory_content JSONB NOT NULL,
            context TEXT,
            importance DECIMAL(3,2) CHECK (importance >= 0 AND importance <= 1),
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            expires_at TIMESTAMP WITH TIME ZONE
        );
        """,
        
        """
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
        """,
        
        """
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
        """,
        
        # 5. Domain knowledge tables
        """
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
        """,
        
        # 6. Personality table (Big Five traits)
        """
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
        """,
        
        # 7. Goals and objectives tables
        """
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
        """,
        
        """
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
        """,
        
        # 8. Instructions and rules tables
        """
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
        """,
        
        """
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
        """,
        
        # 9. LLM configuration table
        """
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
        """,
        
        # 10. Workflows table
        """
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
        """,
        
        """
        CREATE TABLE IF NOT EXISTS agent_workflows (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
            workflow_id UUID NOT NULL REFERENCES workflows(id) ON DELETE CASCADE,
            role_in_workflow VARCHAR(100),
            permissions JSONB,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(agent_id, workflow_id)
        );
        """,
        
        # 11. Skills table
        """
        CREATE TABLE IF NOT EXISTS skills (
            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
            name VARCHAR(255) NOT NULL UNIQUE,
            description TEXT,
            skill_type VARCHAR(50),
            required_tools TEXT[],
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        """,
        
        """
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
        """,
        
        # 12. Tasks table with delegation support
        """
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
        """,
        
        # 13. Tools table for MCP server tools
        """
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
        """,
        
        """
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
        """,
        
        # 14. Voice configuration table
        """
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
        """
    ]
    
    # Create indexes
    index_statements = [
        "CREATE INDEX IF NOT EXISTS idx_agent_beliefs_agent_id ON agent_beliefs(agent_id);",
        "CREATE INDEX IF NOT EXISTS idx_agent_desires_agent_id ON agent_desires(agent_id);",
        "CREATE INDEX IF NOT EXISTS idx_agent_intentions_agent_id ON agent_intentions(agent_id);",
        "CREATE INDEX IF NOT EXISTS idx_agent_intentions_status ON agent_intentions(status);",
        "CREATE INDEX IF NOT EXISTS idx_short_term_memory_agent_id ON short_term_memory(agent_id);",
        "CREATE INDEX IF NOT EXISTS idx_short_term_memory_expires ON short_term_memory(expires_at);",
        "CREATE INDEX IF NOT EXISTS idx_long_term_memory_agent_id ON long_term_memory(agent_id);",
        "CREATE INDEX IF NOT EXISTS idx_long_term_memory_tags ON long_term_memory USING GIN(tags);",
        "CREATE INDEX IF NOT EXISTS idx_episodic_memory_agent_id ON episodic_memory(agent_id);",
        "CREATE INDEX IF NOT EXISTS idx_episodic_memory_timestamp ON episodic_memory(episode_timestamp);",
        "CREATE INDEX IF NOT EXISTS idx_agent_goals_agent_id ON agent_goals(agent_id);",
        "CREATE INDEX IF NOT EXISTS idx_agent_goals_status ON agent_goals(status);",
        "CREATE INDEX IF NOT EXISTS idx_agent_objectives_goal_id ON agent_objectives(goal_id);",
        "CREATE INDEX IF NOT EXISTS idx_agent_instructions_agent_id ON agent_instructions(agent_id);",
        "CREATE INDEX IF NOT EXISTS idx_agent_rules_agent_id ON agent_rules(agent_id);",
        "CREATE INDEX IF NOT EXISTS idx_tasks_assigned_agent ON tasks(assigned_agent_id);",
        "CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);",
        "CREATE INDEX IF NOT EXISTS idx_tasks_deadline ON tasks(deadline);"
    ]
    
    # Create update timestamp trigger function
    trigger_function = """
    CREATE OR REPLACE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS $$
    BEGIN
        NEW.updated_at = CURRENT_TIMESTAMP;
        RETURN NEW;
    END;
    $$ language 'plpgsql';
    """
    
    # Create triggers for updating timestamps
    trigger_statements = [
        "DROP TRIGGER IF EXISTS update_agents_updated_at ON agents;",
        "CREATE TRIGGER update_agents_updated_at BEFORE UPDATE ON agents FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();",
        
        "DROP TRIGGER IF EXISTS update_agent_beliefs_updated_at ON agent_beliefs;",
        "CREATE TRIGGER update_agent_beliefs_updated_at BEFORE UPDATE ON agent_beliefs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();",
        
        "DROP TRIGGER IF EXISTS update_agent_desires_updated_at ON agent_desires;",
        "CREATE TRIGGER update_agent_desires_updated_at BEFORE UPDATE ON agent_desires FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();",
        
        "DROP TRIGGER IF EXISTS update_agent_intentions_updated_at ON agent_intentions;",
        "CREATE TRIGGER update_agent_intentions_updated_at BEFORE UPDATE ON agent_intentions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();",
        
        "DROP TRIGGER IF EXISTS update_long_term_memory_updated_at ON long_term_memory;",
        "CREATE TRIGGER update_long_term_memory_updated_at BEFORE UPDATE ON long_term_memory FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();",
        
        "DROP TRIGGER IF EXISTS update_domain_knowledge_updated_at ON domain_knowledge;",
        "CREATE TRIGGER update_domain_knowledge_updated_at BEFORE UPDATE ON domain_knowledge FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();",
        
        "DROP TRIGGER IF EXISTS update_agent_personalities_updated_at ON agent_personalities;",
        "CREATE TRIGGER update_agent_personalities_updated_at BEFORE UPDATE ON agent_personalities FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();",
        
        "DROP TRIGGER IF EXISTS update_agent_goals_updated_at ON agent_goals;",
        "CREATE TRIGGER update_agent_goals_updated_at BEFORE UPDATE ON agent_goals FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();",
        
        "DROP TRIGGER IF EXISTS update_agent_objectives_updated_at ON agent_objectives;",
        "CREATE TRIGGER update_agent_objectives_updated_at BEFORE UPDATE ON agent_objectives FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();",
        
        "DROP TRIGGER IF EXISTS update_agent_instructions_updated_at ON agent_instructions;",
        "CREATE TRIGGER update_agent_instructions_updated_at BEFORE UPDATE ON agent_instructions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();",
        
        "DROP TRIGGER IF EXISTS update_agent_rules_updated_at ON agent_rules;",
        "CREATE TRIGGER update_agent_rules_updated_at BEFORE UPDATE ON agent_rules FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();",
        
        "DROP TRIGGER IF EXISTS update_llm_configurations_updated_at ON llm_configurations;",
        "CREATE TRIGGER update_llm_configurations_updated_at BEFORE UPDATE ON llm_configurations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();",
        
        "DROP TRIGGER IF EXISTS update_workflows_updated_at ON workflows;",
        "CREATE TRIGGER update_workflows_updated_at BEFORE UPDATE ON workflows FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();",
        
        "DROP TRIGGER IF EXISTS update_tasks_updated_at ON tasks;",
        "CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON tasks FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();",
        
        "DROP TRIGGER IF EXISTS update_mcp_tools_updated_at ON mcp_tools;",
        "CREATE TRIGGER update_mcp_tools_updated_at BEFORE UPDATE ON mcp_tools FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();",
        
        "DROP TRIGGER IF EXISTS update_voice_configurations_updated_at ON voice_configurations;",
        "CREATE TRIGGER update_voice_configurations_updated_at BEFORE UPDATE ON voice_configurations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();"
    ]
    
    conn = None
    cur = None
    
    try:
        # Connect to the database
        print("Connecting to Supabase database...")
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        # Execute table creation statements
        print("Creating tables...")
        for i, statement in enumerate(sql_statements, 1):
            try:
                cur.execute(statement)
                print(f"  [{i}/{len(sql_statements)}] Created table")
            except Exception as e:
                print(f"  [{i}/{len(sql_statements)}] Error: {e}")
                conn.rollback()
                continue
        
        # Create indexes
        print("\nCreating indexes...")
        for i, statement in enumerate(index_statements, 1):
            try:
                cur.execute(statement)
                print(f"  [{i}/{len(index_statements)}] Created index")
            except Exception as e:
                print(f"  [{i}/{len(index_statements)}] Error: {e}")
                conn.rollback()
                continue
        
        # Create trigger function
        print("\nCreating trigger function...")
        cur.execute(trigger_function)
        
        # Create triggers
        print("\nCreating triggers...")
        for i, statement in enumerate(trigger_statements, 1):
            try:
                cur.execute(statement)
                print(f"  [{i}/{len(trigger_statements)}] Created trigger")
            except Exception as e:
                print(f"  [{i}/{len(trigger_statements)}] Error: {e}")
                conn.rollback()
                continue
        
        # Commit all changes
        conn.commit()
        print("\nAll tables, indexes, and triggers created successfully!")
        
        # List all created tables
        cur.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_type = 'BASE TABLE'
            ORDER BY table_name;
        """)
        
        tables = cur.fetchall()
        print("\nCreated tables:")
        for table in tables:
            print(f"  - {table[0]}")
        
    except Exception as e:
        print(f"Error connecting to database: {e}")
        if conn:
            conn.rollback()
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

if __name__ == "__main__":
    create_tables()