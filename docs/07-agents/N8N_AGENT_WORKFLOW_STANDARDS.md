# n8n AI Agent Workflow Standards Guide

## Overview

This document establishes the standard format and best practices for all n8n AI Agent workflows in the VividWalls Multi-Agent System, based on the exemplary Social Media Director Agent workflow.

## Required Components

### 1. Workflow Structure

Every n8n AI Agent workflow MUST include:

```
1. Trigger Nodes (Multiple Entry Points)
   - Execute Workflow Trigger (for agent-to-agent communication)
   - Chat Trigger (for interactive testing)
   - Webhook Trigger (for external integrations)

2. Core AI Components
   - OpenAI Chat Model (with proper temperature settings)
   - Chat Memory Manager (PostgreSQL integration)
   - System Message with full agent prompt

3. Tool Integration Nodes
   - Agent-specific tool workflows
   - MCP server integrations
   - External API connections

4. Response Management
   - Structured output formatting
   - Error handling
   - Webhook responses

5. Documentation (Sticky Notes)
   - Comprehensive annotations throughout
```

### 2. Sticky Note Documentation Standards

Every workflow MUST include the following sticky notes:

#### A. Memory Integration Note
```markdown
## Memory
**PostgreSQL Chat Memory Integration**

### Session Management:
- Session Key: `[agent_name]_` + timestamp
- Conversation Context: [Describe what context is maintained]
- Cross-session Learning: [List persistent learnings]

### Memory Features:
- **[Memory Type 1]**: [Description]
- **[Memory Type 2]**: [Description]
- **[Memory Type 3]**: [Description]
```

#### B. Input Variables Note
```markdown
## Input Variables
**Session and Context Management**

### Required Variables:
- `$json.chatId`: Unique chat session identifier
- `$json.session_id`: [Agent] session ID
- `$now.toMillis()`: Timestamp for session management

### Optional Context:
- `$json.[variable_name]`: [Description]
- `$json.[variable_name]`: [Description]

### Default Session Key:
`[agent_name]_` + current timestamp for unique identification
```

#### C. Tool Integration Notes (One per Tool)
```markdown
## [Tool Name] Agent Tool
**Workflow Integration: [WorkflowId or MCP Server Name]**

### AI Parameter Extraction:
- `parameter_name`: "={{ $fromAI('parameter_name', 'description with examples') }}"
- `parameter_name`: "={{ $fromAI('parameter_name', 'description with examples') }}"

### Capabilities:
- [Capability 1 with specific details]
- [Capability 2 with specific details]
- [Capability 3 with specific details]

### Performance Targets:
- **[Metric 1]**: [Target value]
- **[Metric 2]**: [Target value]
- **[Metric 3]**: [Target value]
```

#### D. Workflow Overview Note
```markdown
## [Agent Name] Workflow
**Role: [Agent Role Description]**

### Key Responsibilities:
1. [Responsibility 1]
2. [Responsibility 2]
3. [Responsibility 3]

### Integration Points:
- Reports to: [Director Agent]
- Collaborates with: [Other Agents]
- External Systems: [MCP Servers]

### Success Metrics:
- [KPI 1]: [Target]
- [KPI 2]: [Target]
```

#### E. Decision Logic Note
```markdown
## Decision Framework
**Strategic Decision Rules**

### Routing Logic:
- IF [condition] THEN [route to tool/agent]
- IF [condition] THEN [route to tool/agent]

### Priority Rules:
1. [Priority 1 condition and action]
2. [Priority 2 condition and action]

### Escalation Triggers:
- [Condition requiring escalation]
- [Condition requiring human intervention]
```

### 3. Tool Integration Pattern

All tool integrations MUST follow this pattern:

```javascript
// For Sub-Agent Workflows
{
  "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
  "parameters": {
    "description": "[Clear description of what this tool does]",
    "workflowId": {
      "__rl": true,
      "value": "[WorkflowId]",
      "mode": "list",
      "cachedResultName": "[Human-readable name]"
    },
    "workflowInputs": {
      "mappingMode": "defineBelow",
      "value": {
        "parameter": "={{ $fromAI('parameter', 'description') }}"
      }
    }
  }
}

// For MCP Server Tools
{
  "type": "n8n-nodes-mcp.mcpClientTool",
  "parameters": {
    "operation": "executeTool",
    "toolName": "={{ $fromAI('tool', 'selected tool to execute') }}",
    "toolParameters": "={{ $fromAI('Tool_Parameters', '', 'json') }}"
  },
  "credentials": {
    "mcpClientApi": {
      "id": "[MCPClientId]",
      "name": "[MCP Server Name] account"
    }
  }
}
```

### 4. System Message Configuration

Every agent MUST have a properly configured system message including:

```markdown
1. Role & Purpose section
2. Core Responsibilities
3. Key Performance Indicators
4. Available MCP Tools (with exact tool names)
5. Decision Framework
6. Input Requirements (JSON schema)
7. Output Format specifications
```

### 5. Error Handling Requirements

All workflows MUST include:

1. **Try-Catch Blocks** around tool executions
2. **Fallback Paths** when tools are unavailable
3. **Error Notification** to parent agents
4. **Graceful Degradation** for missing MCP servers

### 6. Naming Conventions

Strict naming standards:

- **Workflow Name**: `[Agent Name] Agent`
- **Node Names**: Descriptive action names (e.g., "Pinterest Agent Tool", not "Tool1")
- **Session Keys**: `[agent_name_lowercase]_` + timestamp
- **Webhook Paths**: `[agent-name-kebab-case]-webhook`

### 7. Position and Layout Standards

Maintain visual clarity:

1. **Entry Points** (Triggers): Top of workflow (Y: -80 to 300)
2. **Memory/AI Components**: Left side (X: -1280 to -420)
3. **Tool Integrations**: Center (X: 0 to 2000)
4. **Response Nodes**: Right side (X: 2500+)
5. **Sticky Notes**: Positioned near related components

### 8. Color Coding for Sticky Notes

Use consistent colors:
- **Color 5 (Blue)**: Input/Output documentation
- **Color 6 (Purple)**: Integration specifications
- **Color 7 (Yellow)**: Memory and state management
- **Color 1 (Red)**: Critical warnings or limitations
- **Color 3 (Green)**: Success metrics and KPIs

## Implementation Checklist

For each new agent workflow:

- [ ] Create all three trigger types (workflow, chat, webhook)
- [ ] Configure OpenAI Chat Model with appropriate temperature
- [ ] Set up PostgreSQL Chat Memory with proper session management
- [ ] Add comprehensive system message from agent prompt
- [ ] Integrate all required tool workflows with proper parameter extraction
- [ ] Add all required sticky notes with complete documentation
- [ ] Implement error handling for each tool integration
- [ ] Test all three entry points
- [ ] Verify parameter extraction with $fromAI() functions
- [ ] Ensure proper response formatting
- [ ] Document any MCP server dependencies
- [ ] Add workflow to agent registry

## Migration Guide

For existing workflows that need updating:

1. **Audit Current State**: Compare against this standard
2. **Add Missing Components**: Prioritize triggers and memory
3. **Document with Sticky Notes**: Add all required annotations
4. **Update Tool Integrations**: Use proper $fromAI() patterns
5. **Test Thoroughly**: Verify all paths work correctly
6. **Update Agent Registry**: Ensure workflow ID is correct

## Quality Assurance

Before deploying any agent workflow:

1. **Peer Review**: Another developer must review against standards
2. **Integration Testing**: Test with parent and child agents
3. **Performance Testing**: Verify response times < 5 seconds
4. **Documentation Review**: Ensure all sticky notes are complete
5. **Security Audit**: Check for exposed credentials or sensitive data

## Example Reference

The Social Media Director Agent workflow serves as the gold standard implementation. All new workflows should match or exceed its level of:

- Documentation completeness
- Integration sophistication
- Error handling robustness
- Visual organization
- Parameter extraction patterns

---

*Last Updated: [Current Date]*
*Standard Version: 1.0*
*Based on: Social Media Director Agent Workflow*