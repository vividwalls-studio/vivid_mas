-- Multi-Agent System Schema for Supabase (Safe Version)
-- This version handles common issues and conflicts

-- Start transaction
BEGIN;

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop existing tables in correct order (respecting foreign keys)
DROP TABLE IF EXISTS agent_mcp_tools CASCADE;
DROP TABLE IF EXISTS agent_voice_config CASCADE;
DROP TABLE IF EXISTS agent_tasks CASCADE;
DROP TABLE IF EXISTS agent_skills CASCADE;
DROP TABLE IF EXISTS agent_workflows CASCADE;
DROP TABLE IF EXISTS agent_llm_config CASCADE;
DROP TABLE IF EXISTS agent_rules CASCADE;
DROP TABLE IF EXISTS agent_instructions CASCADE;
DROP TABLE IF EXISTS agent_objectives CASCADE;
DROP TABLE IF EXISTS agent_goals CASCADE;
DROP TABLE IF EXISTS agent_personalities CASCADE;
DROP TABLE IF EXISTS agent_domain_knowledge CASCADE;
DROP TABLE IF EXISTS agent_heuristic_imperatives CASCADE;
DROP TABLE IF EXISTS agent_intentions CASCADE;
DROP TABLE IF EXISTS agent_desires CASCADE;
DROP TABLE IF EXISTS agent_beliefs CASCADE;
DROP TABLE IF EXISTS agents CASCADE;

-- 1. Core Agent Table (with explicit ID type)
CREATE TABLE IF NOT EXISTS agents (
    id UUID PRIMARY KEY,  -- Changed: Removed DEFAULT to accept provided IDs
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
    agent_id UUID NOT NULL,
    belief TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_beliefs_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS agent_desires (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL,
    desire TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_desires_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS agent_intentions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL,
    intention TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_intentions_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(id) ON DELETE CASCADE
);

-- 3. Heuristic Imperatives
CREATE TABLE IF NOT EXISTS agent_heuristic_imperatives (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL,
    imperative TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_imperatives_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(id) ON DELETE CASCADE
);

-- 4. Domain Knowledge
CREATE TABLE IF NOT EXISTS agent_domain_knowledge (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL,
    vector_database VARCHAR(255),
    knowledge_graph VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_knowledge_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(id) ON DELETE CASCADE
);

-- 5. Personality (Big Five)
CREATE TABLE IF NOT EXISTS agent_personalities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL,
    openness VARCHAR(50),
    conscientiousness VARCHAR(50),
    extraversion VARCHAR(50),
    agreeableness VARCHAR(50),
    neuroticism VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_personalities_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(id) ON DELETE CASCADE,
    CONSTRAINT unique_agent_personality UNIQUE (agent_id)
);

-- 6. Goals
CREATE TABLE IF NOT EXISTS agent_goals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL,
    goal TEXT NOT NULL,
    priority VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_goals_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(id) ON DELETE CASCADE
);

-- 7. Objectives (linked to goals)
CREATE TABLE IF NOT EXISTS agent_objectives (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    goal_id UUID NOT NULL,
    objective TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_objectives_goal FOREIGN KEY (goal_id) 
        REFERENCES agent_goals(id) ON DELETE CASCADE
);

-- 8. Instructions
CREATE TABLE IF NOT EXISTS agent_instructions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL,
    instruction TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_instructions_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(id) ON DELETE CASCADE
);

-- 9. Rules
CREATE TABLE IF NOT EXISTS agent_rules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL,
    rule TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rules_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(id) ON DELETE CASCADE
);

-- 10. LLM Configuration
CREATE TABLE IF NOT EXISTS agent_llm_config (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL,
    model VARCHAR(255),
    temperature DECIMAL(3,2),
    max_tokens INTEGER,
    top_p DECIMAL(3,2),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_llm_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(id) ON DELETE CASCADE,
    CONSTRAINT unique_agent_llm UNIQUE (agent_id)
);

-- 11. Workflows
CREATE TABLE IF NOT EXISTS agent_workflows (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL,
    workflow_name VARCHAR(255),
    workflow_definition JSONB,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_workflows_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(id) ON DELETE CASCADE
);

-- 12. Skills
CREATE TABLE IF NOT EXISTS agent_skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL,
    skill_name VARCHAR(255),
    skill_level VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_skills_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(id) ON DELETE CASCADE
);

-- 13. Tasks
CREATE TABLE IF NOT EXISTS agent_tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL,
    task_name VARCHAR(255),
    task_status VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tasks_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(id) ON DELETE CASCADE
);

-- 14. MCP Tools
CREATE TABLE IF NOT EXISTS agent_mcp_tools (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL,
    tool_name VARCHAR(255),
    tool_config JSONB,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mcp_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(id) ON DELETE CASCADE
);

-- 15. Voice Configuration
CREATE TABLE IF NOT EXISTS agent_voice_config (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL,
    style VARCHAR(255),
    tone VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_voice_agent FOREIGN KEY (agent_id) 
        REFERENCES agents(id) ON DELETE CASCADE,
    CONSTRAINT unique_agent_voice UNIQUE (agent_id)
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

-- Drop trigger if exists and recreate
DROP TRIGGER IF EXISTS update_agents_updated_at ON agents;
CREATE TRIGGER update_agents_updated_at BEFORE UPDATE ON agents
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Commit transaction
COMMIT;

-- Verify tables were created
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name LIKE 'agent%'
ORDER BY table_name;