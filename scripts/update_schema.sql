-- Update schema to match the insertion SQL files

-- Update agents table
ALTER TABLE agents 
ADD COLUMN IF NOT EXISTS role VARCHAR(255),
ADD COLUMN IF NOT EXISTS backstory TEXT,
ADD COLUMN IF NOT EXISTS short_term_memory JSONB DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS long_term_memory JSONB DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS communication_preferences JSONB DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS avatar_url TEXT;

-- Update agent_voice_config table
ALTER TABLE agent_voice_config
ADD COLUMN IF NOT EXISTS pace VARCHAR(255),
ADD COLUMN IF NOT EXISTS provider VARCHAR(255),
ADD COLUMN IF NOT EXISTS special_instructions TEXT;