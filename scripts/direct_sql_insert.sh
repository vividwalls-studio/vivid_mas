#!/bin/bash
cd /root/vivid_mas

# Insert agents
docker exec -i supabase-db psql -U postgres -d postgres << 'EOF'
TRUNCATE agents CASCADE;

INSERT INTO agents (id, name, role, type, capabilities, config) VALUES
('e18f66d5-ef52-4a6e-aea6-7e693148552b', 'Marketing Director Agent', 'Strategic Marketing Leader', 'director', '[]', '{}'),
('f7e4b9c1-6d3a-4e8f-9b2a-8c5d3e4f9a1b', 'Analytics Director Agent', 'Data Analytics Leader', 'director', '[]', '{}'),
('a9b8c7d6-5e4f-3a2b-1c9d-8e7f6a5b4c3d', 'Customer Experience Director', 'CX Strategy Leader', 'director', '[]', '{}'),
('b8d7e6f5-4c3a-2b1a-9c8d-7e6f5a4b3c2d', 'Product Director Agent', 'Product Strategy Leader', 'director', '[]', '{}'),
('c9e8f7g6-5d4b-3c2a-ad9e-8f7g6b5c4d3e', 'Finance Director Agent', 'Financial Strategy Leader', 'director', '[]', '{}'),
('d0f9g8h7-6e5c-4d3b-be0f-9g8h7c6d5e4f', 'Operations Director Agent', 'Operations Leader', 'director', '[]', '{}'),
('e1g0h9i8-7f6d-5e4c-cf1g-0h9i8d7e6f5g', 'Technology Director Agent', 'Technology Leader', 'director', '[]', '{}'),
('a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'Creative Content Task Agent', 'Content Creation Specialist', 'task', '[]', '{}'),
('b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e', 'Campaign Analytics Task Agent', 'Campaign Analysis Specialist', 'task', '[]', '{}'),
('c3d4e5f6-a7b8-9c0d-1e2f-3a4b5c6d7e8f', 'Audience Intelligence Task Agent', 'Audience Analysis Specialist', 'task', '[]', '{}');

SELECT COUNT(*) FROM agents;
EOF

# Insert beliefs
docker exec -i supabase-db psql -U postgres -d postgres << 'EOF'
INSERT INTO agent_beliefs (agent_id, belief) VALUES
('e18f66d5-ef52-4a6e-aea6-7e693148552b', 'Data-driven marketing yields the best ROI'),
('e18f66d5-ef52-4a6e-aea6-7e693148552b', 'Customer experience is the key differentiator'),
('f7e4b9c1-6d3a-4e8f-9b2a-8c5d3e4f9a1b', 'Data quality determines insight accuracy'),
('a9b8c7d6-5e4f-3a2b-1c9d-8e7f6a5b4c3d', 'Customer satisfaction drives business growth');
EOF

# Insert goals
docker exec -i supabase-db psql -U postgres -d postgres << 'EOF'
INSERT INTO agent_goals (agent_id, goal, priority) VALUES
('e18f66d5-ef52-4a6e-aea6-7e693148552b', 'Increase brand awareness by 30%', 9),
('e18f66d5-ef52-4a6e-aea6-7e693148552b', 'Improve customer acquisition cost', 8),
('f7e4b9c1-6d3a-4e8f-9b2a-8c5d3e4f9a1b', 'Implement real-time analytics dashboard', 9),
('a9b8c7d6-5e4f-3a2b-1c9d-8e7f6a5b4c3d', 'Improve NPS score by 20 points', 9);
EOF

# Insert LLM config
docker exec -i supabase-db psql -U postgres -d postgres << 'EOF'
INSERT INTO agent_llm_config (agent_id, model, temperature, max_tokens) VALUES
('e18f66d5-ef52-4a6e-aea6-7e693148552b', 'gpt-4', 0.7, 2000),
('f7e4b9c1-6d3a-4e8f-9b2a-8c5d3e4f9a1b', 'gpt-4', 0.3, 2000),
('a9b8c7d6-5e4f-3a2b-1c9d-8e7f6a5b4c3d', 'gpt-4', 0.8, 2000)
ON CONFLICT (agent_id) DO UPDATE SET model = EXCLUDED.model;
EOF

# Verify
echo "===== VERIFICATION ====="
docker exec -i supabase-db psql -U postgres -d postgres -c "SELECT COUNT(*) as agents_count FROM agents;"
docker exec -i supabase-db psql -U postgres -d postgres -c "SELECT id, name, role, type FROM agents ORDER BY type, name;"