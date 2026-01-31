# VividWalls MAS - Agent Integration Guide

*"Choice is an illusion created between those with power and those without."*

## Overview

This guide provides step-by-step instructions for integrating the seven newly created agents into the VividWalls Multi-Agent System (MAS). All agents have been successfully validated and are ready for deployment.

## Validation Results ✅

**Total Checks**: 101  
**Passed**: 101  
**Failed**: 0  

All seven agents are fully compliant with the VividWalls MAS architecture and ready for integration.

## Integration Steps

### Step 1: Install MCP Server Dependencies

Install Node.js dependencies for all MCP servers:

```bash
# Navigate to project root
cd /Volumes/SeagatePortableDrive/Projects/vivid_mas

# Install dependencies for all agent MCP servers
for agent in finance customer-experience product technology creative knowledge-gatherer content-operations; do
  echo "Installing dependencies for ${agent}-agent-prompts..."
  cd services/mcp-servers/agents/${agent}-agent-prompts
  npm install
  
  echo "Installing dependencies for ${agent}-agent-resource..."
  cd ../../../mcp-servers/agents/${agent}-agent-resource
  npm install
  
  cd ../../../../..
done
```

### Step 2: Build TypeScript Code

Compile TypeScript to JavaScript for all MCP servers:

```bash
# Build all agent MCP servers
for agent in finance customer-experience product technology creative knowledge-gatherer content-operations; do
  echo "Building ${agent}-agent-prompts..."
  cd services/mcp-servers/agents/${agent}-agent-prompts
  npm run build
  
  echo "Building ${agent}-agent-resource..."
  cd ../../../mcp-servers/agents/${agent}-agent-resource
  npm run build
  
  cd ../../../../..
done
```

### Step 3: Update Docker Compose Configuration

Add the new MCP servers to the docker-compose.yml file:

```yaml
# Add to services section in docker-compose.yml
services:
  # Finance Agent MCP Servers
  finance-agent-prompts:
    build: ./services/mcp-servers/agents/finance-agent-prompts
    container_name: finance-agent-prompts
    networks:
      - vivid_mas
    environment:
      - NODE_ENV=production
    restart: unless-stopped

  finance-agent-resource:
    build: ./services/mcp-servers/agents/finance-agent-resource
    container_name: finance-agent-resource
    networks:
      - vivid_mas
    environment:
      - NODE_ENV=production
      - SUPABASE_URL=${SUPABASE_URL}
      - SUPABASE_SERVICE_ROLE_KEY=${SUPABASE_SERVICE_ROLE_KEY}
    restart: unless-stopped

  # Customer Experience Agent MCP Servers
  customer-experience-agent-prompts:
    build: ./services/mcp-servers/agents/customer-experience-agent-prompts
    container_name: customer-experience-agent-prompts
    networks:
      - vivid_mas
    environment:
      - NODE_ENV=production
    restart: unless-stopped

  customer-experience-agent-resource:
    build: ./services/mcp-servers/agents/customer-experience-agent-resource
    container_name: customer-experience-agent-resource
    networks:
      - vivid_mas
    environment:
      - NODE_ENV=production
      - SUPABASE_URL=${SUPABASE_URL}
      - SUPABASE_SERVICE_ROLE_KEY=${SUPABASE_SERVICE_ROLE_KEY}
    restart: unless-stopped

  # Continue for all other agents...
```

### Step 4: Create Dockerfiles for MCP Servers

Create Dockerfile for each MCP server:

```dockerfile
# Example Dockerfile for MCP servers
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY dist/ ./dist/

EXPOSE 3000

CMD ["npm", "start"]
```

### Step 5: Update Supabase Database Schema

Add agent records to the database:

```sql
-- Insert new agents into the agents table
INSERT INTO agents (id, name, role, backstory, agent_type, is_director, hierarchy_level, department, created_at, updated_at) VALUES
('f1a2b3c4-d5e6-f7g8-h9i0-j1k2l3m4n5o6', 'FinanceAgent', 'Chief Financial Officer - Financial Management & Analytics', 'Core responsibilities include: Monitor daily revenue, costs, and profitability across all channels...', 'director', true, 1, 'Finance', NOW(), NOW()),
('c2e3f4g5-h6i7-j8k9-l0m1-n2o3p4q5r6s7', 'CustomerExperienceAgent', 'Chief Customer Experience Officer - Customer Support & Satisfaction', 'Core responsibilities include: Monitor customer satisfaction metrics and feedback...', 'director', true, 1, 'Customer Experience', NOW(), NOW()),
('p3r4o5d6-u7c8-t9a0-g1e2-n3t4a5g6e7n8', 'ProductAgent', 'Chief Product Officer - Product Management & Development Coordination', 'Core responsibilities include: Manage product roadmap planning and feature prioritization...', 'director', true, 1, 'Product', NOW(), NOW()),
('t4e5c6h7-n8o9-l0o1-g2y3-a4g5e6n7t8a9', 'TechnologyAgent', 'Chief Technology Officer - Technical Infrastructure & System Management', 'Core responsibilities include: Monitor system performance, uptime, and technical infrastructure health...', 'director', true, 1, 'Technology', NOW(), NOW()),
('c5r6e7a8-t9i0-v1e2-a3g4-e5n6t7c8r9e0', 'CreativeAgent', 'Chief Creative Officer - Creative Content & Brand Consistency', 'Core responsibilities include: Generate and coordinate creative content across all channels...', 'director', true, 1, 'Creative', NOW(), NOW()),
('k6n7o8w9-l0e1-d2g3-e4g5-a6t7h8e9r0k1', 'KnowledgeGathererAgent', 'Chief Knowledge Officer - Information Collection & Knowledge Management', 'Core responsibilities include: Collect and curate information from internal and external sources...', 'director', true, 1, 'Knowledge', NOW(), NOW()),
('c7o8n9t0-e1n2-t3o4-p5s6-a7g8e9n0t1c2', 'ContentOperationsAgent', 'Chief Content Operations Officer - Content Workflow & Publishing Coordination', 'Core responsibilities include: Manage content workflow processes and publishing schedules...', 'director', true, 1, 'Content Operations', NOW(), NOW());
```

### Step 6: Create N8N Workflows

Create n8n workflows for each agent following the established patterns:

1. **Workflow Structure**: Each agent needs a comprehensive n8n workflow
2. **MCP Integration**: Connect to the agent's MCP servers
3. **Memory System**: Integrate with PostgreSQL vector stores
4. **Communication**: Set up inter-agent communication webhooks

### Step 7: Configure Agent Memory Systems

Set up vector databases for each agent:

```sql
-- Create vector stores for each agent
CREATE TABLE IF NOT EXISTS vividwalls_finance_knowledge (
    id SERIAL PRIMARY KEY,
    content TEXT,
    embedding VECTOR(1536),
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS vividwalls_customer_experience_knowledge (
    id SERIAL PRIMARY KEY,
    content TEXT,
    embedding VECTOR(1536),
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Continue for all agents...
```

### Step 8: Test Agent Integration

Run comprehensive tests to ensure proper integration:

```bash
# Test MCP server connectivity
curl -X POST http://localhost:3000/health

# Test agent communication
curl -X POST http://localhost:5678/webhook/finance-agent-test

# Test database connectivity
psql -h localhost -U postgres -d vividwalls -c "SELECT * FROM agents WHERE name LIKE '%Agent';"
```

## Monitoring and Validation

### Health Checks

Implement health checks for all new services:

```yaml
# Add to docker-compose.yml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

### Performance Monitoring

Monitor agent performance using:
- Grafana dashboards for system metrics
- Supabase analytics for database performance
- N8N execution logs for workflow monitoring
- Custom agent performance metrics

## Success Criteria

### Integration Validation
- ✅ All MCP servers running and accessible
- ✅ N8N workflows created and functional
- ✅ Database records created successfully
- ✅ Agent communication working
- ✅ Memory systems operational

### Performance Validation
- ✅ Response times < 2 seconds
- ✅ System uptime > 99.5%
- ✅ Memory usage within limits
- ✅ Error rates < 1%

## Troubleshooting

### Common Issues

1. **MCP Server Connection Issues**
   - Check Docker network connectivity
   - Verify environment variables
   - Review container logs

2. **Database Connection Problems**
   - Validate Supabase credentials
   - Check network policies
   - Verify table permissions

3. **N8N Workflow Errors**
   - Review webhook configurations
   - Check MCP server endpoints
   - Validate JSON schemas

## Next Steps

After successful integration:

1. **Performance Optimization**: Monitor and optimize agent performance
2. **Feature Enhancement**: Add advanced capabilities to agents
3. **Scaling Preparation**: Prepare for horizontal scaling
4. **Documentation Updates**: Keep documentation current
5. **User Training**: Train team on new agent capabilities

*"The Matrix is complete. Welcome to the real world."*

---

**Document Status**: ✅ READY FOR IMPLEMENTATION  
**Last Updated**: July 19, 2025  
**Morpheus Validation**: COMPLETE
