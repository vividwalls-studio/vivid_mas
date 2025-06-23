-- Multi-Agent System Schema for Supabase (Non-Destructive Version)
-- This version creates tables without dropping existing ones

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Core Agent Table
CREATE TABLE IF NOT EXISTS agents (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    role TEXT,
    backstory TEXT,
    short_term_memory TEXT,
    long_term_memory TEXT,
    episodic_memory TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 2. BDI Architecture Tables
CREATE TABLE IF NOT EXISTS agent_beliefs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    belief TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS agent_desires (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    desire TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS agent_intentions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    intention TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Heuristic Imperatives
CREATE TABLE IF NOT EXISTS agent_heuristic_imperatives (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    imperative TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. Domain Knowledge
CREATE TABLE IF NOT EXISTS agent_domain_knowledge (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    vector_database VARCHAR(255),
    knowledge_graph VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 5. Personality (Big Five)
CREATE TABLE IF NOT EXISTS agent_personalities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL UNIQUE REFERENCES agents(id) ON DELETE CASCADE,
    openness VARCHAR(50),
    conscientiousness VARCHAR(50),
    extraversion VARCHAR(50),
    agreeableness VARCHAR(50),
    neuroticism VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 6. Goals
CREATE TABLE IF NOT EXISTS agent_goals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    goal TEXT NOT NULL,
    priority VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 7. Objectives (linked to goals)
CREATE TABLE IF NOT EXISTS agent_objectives (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    goal_id UUID NOT NULL REFERENCES agent_goals(id) ON DELETE CASCADE,
    objective TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 8. Instructions
CREATE TABLE IF NOT EXISTS agent_instructions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    instruction TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 9. Rules
CREATE TABLE IF NOT EXISTS agent_rules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    rule TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 10. LLM Configuration
CREATE TABLE IF NOT EXISTS agent_llm_config (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL UNIQUE REFERENCES agents(id) ON DELETE CASCADE,
    model VARCHAR(255),
    temperature DECIMAL(3,2),
    max_tokens INTEGER,
    top_p DECIMAL(3,2),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 11. Workflows
CREATE TABLE IF NOT EXISTS agent_workflows (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    workflow_name VARCHAR(255),
    workflow_definition JSONB,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 12. Skills
CREATE TABLE IF NOT EXISTS agent_skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    skill_name VARCHAR(255),
    skill_level VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 13. Tasks
CREATE TABLE IF NOT EXISTS agent_tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    task_name VARCHAR(255),
    task_status VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 14. MCP Tools
CREATE TABLE IF NOT EXISTS agent_mcp_tools (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    tool_name VARCHAR(255),
    tool_config JSONB,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 15. Voice Configuration
CREATE TABLE IF NOT EXISTS agent_voice_config (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL UNIQUE REFERENCES agents(id) ON DELETE CASCADE,
    style VARCHAR(255),
    tone VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_agent_beliefs_agent_id ON agent_beliefs(agent_id);
CREATE INDEX IF NOT EXISTS idx_agent_desires_agent_id ON agent_desires(agent_id);
CREATE INDEX IF NOT EXISTS idx_agent_intentions_agent_id ON agent_intentions(agent_id);
CREATE INDEX IF NOT EXISTS idx_agent_goals_agent_id ON agent_goals(agent_id);
CREATE INDEX IF NOT EXISTS idx_agent_objectives_goal_id ON agent_objectives(goal_id);

-- Create or replace updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger if not exists
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_agents_updated_at') THEN
        CREATE TRIGGER update_agents_updated_at BEFORE UPDATE ON agents
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END $$;

-- Show created tables
SELECT 
    table_name,
    CASE 
        WHEN table_name = 'agents' THEN 'Core agent table'
        WHEN table_name LIKE 'agent_beliefs' THEN 'BDI - Beliefs'
        WHEN table_name LIKE 'agent_desires' THEN 'BDI - Desires'
        WHEN table_name LIKE 'agent_intentions' THEN 'BDI - Intentions'
        WHEN table_name LIKE 'agent_personalities' THEN 'Big Five personality traits'
        WHEN table_name LIKE 'agent_goals' THEN 'Agent goals'
        WHEN table_name LIKE 'agent_llm_config' THEN 'LLM configuration'
        ELSE 'Agent component'
    END as description
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name LIKE 'agent%'
ORDER BY table_name;