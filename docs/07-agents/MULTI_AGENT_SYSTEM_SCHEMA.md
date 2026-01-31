# Multi-Agent System Database Schema Documentation

## Overview

This document describes the comprehensive database schema for a multi-agent system implemented in Supabase. The schema supports agents with BDI (Belief-Desire-Intention) architecture, memory systems, personality traits, goals, skills, and integration with MCP (Model Context Protocol) tools.

## Database Tables

### 1. Core Agent Tables

#### agents
The main table storing agent information.
- `id` (UUID): Primary key
- `name` (VARCHAR 255): Unique agent name
- `role` (TEXT): Agent's role/position
- `backstory` (TEXT): Agent's background story
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp

### 2. BDI Architecture Tables

#### agent_beliefs
Stores agent's beliefs about the world.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents
- `belief_type` (VARCHAR 100): Type of belief
- `belief_content` (JSONB): Structured belief data
- `confidence` (DECIMAL 0-1): Confidence level
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp

#### agent_desires
Stores agent's desires and wants.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents
- `desire_type` (VARCHAR 100): Type of desire
- `desire_content` (JSONB): Structured desire data
- `priority` (INTEGER 1-10): Priority level
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp

#### agent_intentions
Stores agent's intentions and planned actions.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents
- `intention_type` (VARCHAR 100): Type of intention
- `intention_content` (JSONB): Structured intention data
- `status` (VARCHAR 50): Status (pending/active/completed/failed)
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp

### 3. Heuristic Imperatives

#### heuristic_imperatives
Ethical guidelines for agent behavior.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents
- `imperative_type` (VARCHAR 50): Type (reduce_suffering/increase_prosperity/increase_understanding)
- `description` (TEXT): Imperative description
- `weight` (DECIMAL 0-1): Importance weight
- `created_at` (TIMESTAMP): Creation timestamp

### 4. Memory System Tables

#### short_term_memory
Temporary, context-specific memories.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents
- `memory_content` (JSONB): Memory data
- `context` (TEXT): Memory context
- `importance` (DECIMAL 0-1): Importance level
- `created_at` (TIMESTAMP): Creation timestamp
- `expires_at` (TIMESTAMP): Expiration time

#### long_term_memory
Persistent knowledge and learned information.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents
- `memory_content` (JSONB): Memory data
- `memory_type` (VARCHAR 50): Type (semantic/procedural/declarative)
- `tags` (TEXT[]): Array of tags
- `importance` (DECIMAL 0-1): Importance level
- `retrieval_count` (INTEGER): Access count
- `last_accessed` (TIMESTAMP): Last access time
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp

#### episodic_memory
Specific event memories.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents
- `episode_content` (JSONB): Episode data
- `episode_timestamp` (TIMESTAMP): When event occurred
- `location` (TEXT): Where event occurred
- `participants` (TEXT[]): Who was involved
- `emotions` (JSONB): Emotional state
- `importance` (DECIMAL 0-1): Importance level
- `created_at` (TIMESTAMP): Creation timestamp

### 5. Knowledge Management

#### domain_knowledge
References to external knowledge sources.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents
- `knowledge_type` (VARCHAR 50): Type (vector_db/knowledge_graph/relational_db)
- `source_name` (VARCHAR 255): Knowledge source name
- `connection_config` (JSONB): Connection configuration
- `metadata` (JSONB): Additional metadata
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp

### 6. Personality

#### agent_personalities
Big Five personality traits.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents (unique)
- `openness` (DECIMAL 0-1): Openness to experience
- `conscientiousness` (DECIMAL 0-1): Conscientiousness level
- `extraversion` (DECIMAL 0-1): Extraversion level
- `agreeableness` (DECIMAL 0-1): Agreeableness level
- `neuroticism` (DECIMAL 0-1): Neuroticism level
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp

### 7. Goals and Objectives

#### agent_goals
High-level goals for agents.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents
- `goal_type` (VARCHAR 50): Type (primary/secondary/tertiary)
- `goal_description` (TEXT): Goal description
- `target_date` (TIMESTAMP): Target completion date
- `status` (VARCHAR 50): Status (active/completed/failed/suspended)
- `priority` (INTEGER 1-10): Priority level
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp

#### agent_objectives
Specific objectives under goals.
- `id` (UUID): Primary key
- `goal_id` (UUID): Foreign key to agent_goals
- `objective_description` (TEXT): Objective description
- `measurable_criteria` (JSONB): Success criteria
- `completion_percentage` (DECIMAL 0-100): Progress
- `status` (VARCHAR 50): Status (pending/in_progress/completed/failed)
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp

### 8. Instructions and Rules

#### agent_instructions
Operational instructions for agents.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents
- `instruction_type` (VARCHAR 50): Type (general/task_specific/interaction/safety)
- `instruction_content` (TEXT): Instruction details
- `priority` (INTEGER 1-10): Priority level
- `is_active` (BOOLEAN): Active status
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp

#### agent_rules
Behavioral rules and constraints.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents
- `rule_type` (VARCHAR 50): Type (constraint/permission/obligation/prohibition)
- `rule_content` (TEXT): Rule details
- `rule_conditions` (JSONB): Conditions for rule application
- `enforcement_level` (VARCHAR 50): Level (strict/flexible/advisory)
- `is_active` (BOOLEAN): Active status
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp

### 9. LLM Configuration

#### llm_configurations
Language model settings for agents.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents (unique)
- `model_name` (VARCHAR 255): LLM model name
- `temperature` (DECIMAL 0-2): Temperature setting
- `max_tokens` (INTEGER): Maximum tokens
- `top_p` (DECIMAL 0-1): Top-p sampling
- `frequency_penalty` (DECIMAL -2 to 2): Frequency penalty
- `presence_penalty` (DECIMAL -2 to 2): Presence penalty
- `system_prompt` (TEXT): System prompt
- `additional_config` (JSONB): Additional configuration
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp

### 10. Workflows

#### workflows
Defined workflows for agents.
- `id` (UUID): Primary key
- `name` (VARCHAR 255): Workflow name (unique)
- `description` (TEXT): Workflow description
- `workflow_type` (VARCHAR 50): Workflow type
- `workflow_definition` (JSONB): Workflow structure
- `is_active` (BOOLEAN): Active status
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp

#### agent_workflows
Many-to-many relationship between agents and workflows.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents
- `workflow_id` (UUID): Foreign key to workflows
- `role_in_workflow` (VARCHAR 100): Agent's role
- `permissions` (JSONB): Workflow permissions
- `created_at` (TIMESTAMP): Creation timestamp
- Unique constraint on (agent_id, workflow_id)

### 11. Skills

#### skills
Available skills in the system.
- `id` (UUID): Primary key
- `name` (VARCHAR 255): Skill name (unique)
- `description` (TEXT): Skill description
- `skill_type` (VARCHAR 50): Skill category
- `required_tools` (TEXT[]): Required tools
- `created_at` (TIMESTAMP): Creation timestamp

#### agent_skills
Many-to-many relationship between agents and skills.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents
- `skill_id` (UUID): Foreign key to skills
- `proficiency_level` (DECIMAL 0-1): Skill proficiency
- `last_used` (TIMESTAMP): Last usage time
- `usage_count` (INTEGER): Usage count
- `created_at` (TIMESTAMP): Creation timestamp
- Unique constraint on (agent_id, skill_id)

### 12. Task Management

#### tasks
Tasks assigned to agents.
- `id` (UUID): Primary key
- `name` (VARCHAR 255): Task name
- `description` (TEXT): Task description
- `assigned_agent_id` (UUID): Foreign key to agents
- `delegated_from_agent_id` (UUID): Foreign key to agents
- `parent_task_id` (UUID): Foreign key to tasks (self-reference)
- `task_type` (VARCHAR 50): Task category
- `priority` (INTEGER 1-10): Priority level
- `status` (VARCHAR 50): Status (pending/assigned/in_progress/completed/failed/cancelled)
- `deadline` (TIMESTAMP): Due date
- `result` (JSONB): Task results
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp
- `completed_at` (TIMESTAMP): Completion timestamp

### 13. MCP Tools Integration

#### mcp_tools
Available MCP server tools.
- `id` (UUID): Primary key
- `name` (VARCHAR 255): Tool name (unique)
- `description` (TEXT): Tool description
- `mcp_server_name` (VARCHAR 255): MCP server name
- `tool_schema` (JSONB): Tool schema definition
- `required_permissions` (TEXT[]): Required permissions
- `is_active` (BOOLEAN): Active status
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp

#### agent_tools
Agent access to MCP tools.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents
- `tool_id` (UUID): Foreign key to mcp_tools
- `access_level` (VARCHAR 50): Access level (read/write/execute/admin)
- `usage_count` (INTEGER): Usage count
- `last_used` (TIMESTAMP): Last usage time
- `created_at` (TIMESTAMP): Creation timestamp
- Unique constraint on (agent_id, tool_id)

### 14. Voice Configuration

#### voice_configurations
Voice settings for agents.
- `id` (UUID): Primary key
- `agent_id` (UUID): Foreign key to agents (unique)
- `voice_provider` (VARCHAR 50): Provider (elevenlabs/openai/google/amazon/azure)
- `voice_id` (VARCHAR 255): Voice identifier
- `voice_settings` (JSONB): Provider-specific settings
- `language` (VARCHAR 10): Language code
- `speech_rate` (DECIMAL 0.5-2.0): Speech rate
- `pitch` (DECIMAL 0.5-2.0): Voice pitch
- `created_at` (TIMESTAMP): Creation timestamp
- `updated_at` (TIMESTAMP): Last update timestamp

## Indexes

The schema includes indexes on:
- All foreign key relationships
- Status fields for filtering
- Timestamp fields for temporal queries
- Array fields using GIN indexes

## Triggers

All tables with `updated_at` columns have triggers that automatically update the timestamp on row modifications.

## Usage Examples

### Creating a New Agent
```sql
INSERT INTO agents (name, role, backstory)
VALUES ('DataAnalyst', 'Senior Data Analyst', 'Expert in statistical analysis...');
```

### Adding Agent Beliefs
```sql
INSERT INTO agent_beliefs (agent_id, belief_type, belief_content, confidence)
VALUES (
    'agent-uuid-here',
    'market_conditions',
    '{"market": "bullish", "sectors": ["tech", "healthcare"]}',
    0.85
);
```

### Querying Agent with Full Profile
```sql
SELECT 
    a.*,
    ap.openness,
    ap.conscientiousness,
    lc.model_name,
    COUNT(DISTINCT asks.skill_id) as skill_count
FROM agents a
LEFT JOIN agent_personalities ap ON a.id = ap.agent_id
LEFT JOIN llm_configurations lc ON a.id = lc.agent_id
LEFT JOIN agent_skills asks ON a.id = asks.agent_id
WHERE a.name = 'ResearchAgent'
GROUP BY a.id, ap.openness, ap.conscientiousness, lc.model_name;
```

## Best Practices

1. **Use UUIDs**: All primary keys use UUIDs for distributed system compatibility
2. **JSONB for Flexibility**: Complex data structures stored as JSONB for flexibility
3. **Constraints**: Appropriate constraints ensure data integrity
4. **Indexes**: Strategic indexes for common query patterns
5. **Audit Trail**: Created/updated timestamps for auditing

## Migration and Maintenance

The schema includes:
- Scripts for initial setup (`create_mas_schema_clean.py`)
- Sample data insertion (`insert_sample_agent.py`)
- Support for schema evolution through migrations

## Security Considerations

1. Use Row Level Security (RLS) in Supabase for multi-tenant scenarios
2. Implement proper authentication for agent operations
3. Encrypt sensitive data in JSONB fields
4. Regular backups of agent memory and state