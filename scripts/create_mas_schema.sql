-- Multi-Agent System Schema for Supabase
-- This creates all the tables needed for the agent system

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop existing tables if they exist (be careful with this in production!)
DROP TABLE IF EXISTS agent_mcp_tools CASCADE;
DROP TABLE IF EXISTS agent_workflows CASCADE;
DROP TABLE IF EXISTS agent_skills CASCADE;
DROP TABLE IF EXISTS agent_tasks CASCADE;
DROP TABLE IF EXISTS agent_voice_config CASCADE;
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

-- 1. Core Agent Table
CREATE TABLE agents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL UNIQUE,
    role TEXT,
    backstory TEXT,
    short_term_memory TEXT,
    long_term_memory TEXT,
    episodic_memory TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. BDI Architecture Tables
CREATE TABLE agent_beliefs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    belief TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE agent_desires (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    desire TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE agent_intentions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    intention TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Heuristic Imperatives
CREATE TABLE agent_heuristic_imperatives (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    imperative TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Domain Knowledge
CREATE TABLE agent_domain_knowledge (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    vector_database VARCHAR(255),
    knowledge_graph VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. Personality (Big Five)
CREATE TABLE agent_personalities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL UNIQUE REFERENCES agents(id) ON DELETE CASCADE,
    openness VARCHAR(50),
    conscientiousness VARCHAR(50),
    extraversion VARCHAR(50),
    agreeableness VARCHAR(50),
    neuroticism VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Goals
CREATE TABLE agent_goals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    goal TEXT NOT NULL,
    priority VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 7. Objectives (linked to goals)
CREATE TABLE agent_objectives (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    goal_id UUID NOT NULL REFERENCES agent_goals(id) ON DELETE CASCADE,
    objective TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. Instructions
CREATE TABLE agent_instructions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    instruction TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 9. Rules
CREATE TABLE agent_rules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    rule TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 10. LLM Configuration
CREATE TABLE agent_llm_config (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL UNIQUE REFERENCES agents(id) ON DELETE CASCADE,
    model VARCHAR(255),
    temperature DECIMAL(3,2),
    max_tokens INTEGER,
    top_p DECIMAL(3,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 11. Workflows
CREATE TABLE agent_workflows (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    workflow_name VARCHAR(255),
    workflow_definition JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 12. Skills
CREATE TABLE agent_skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    skill_name VARCHAR(255),
    skill_level VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 13. Tasks
CREATE TABLE agent_tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    task_name VARCHAR(255),
    task_status VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 14. MCP Tools
CREATE TABLE agent_mcp_tools (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    tool_name VARCHAR(255),
    tool_config JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 15. Voice Configuration
CREATE TABLE agent_voice_config (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID NOT NULL UNIQUE REFERENCES agents(id) ON DELETE CASCADE,
    style VARCHAR(255),
    tone VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_agent_beliefs_agent_id ON agent_beliefs(agent_id);
CREATE INDEX idx_agent_desires_agent_id ON agent_desires(agent_id);
CREATE INDEX idx_agent_intentions_agent_id ON agent_intentions(agent_id);
CREATE INDEX idx_agent_goals_agent_id ON agent_goals(agent_id);
CREATE INDEX idx_agent_objectives_goal_id ON agent_objectives(goal_id);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add updated_at triggers
CREATE TRIGGER update_agents_updated_at BEFORE UPDATE ON agents
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security (RLS) - Uncomment if needed
-- ALTER TABLE agents ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE agent_beliefs ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE agent_desires ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE agent_intentions ENABLE ROW LEVEL SECURITY;

-- Grant permissions (adjust as needed)
-- GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
-- GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- Success message
DO $$
BEGIN
    RAISE NOTICE 'Multi-Agent System schema created successfully!';
    RAISE NOTICE 'Tables created: 16';
    RAISE NOTICE 'Ready for data insertion';
END $$;