# N8N Workflow Update Issues Report

## Issue Summary

The workflow update errors (400 Bad Request and 404 Not Found) are caused by:

1. **Non-VividWalls workflows** in the system that shouldn't be there
2. **Missing node types** that these external workflows depend on
3. **API authentication issues** preventing proper updates

## Workflows to Remove (16 found)

### Deal Flow / External Demo Workflows
These are from external courses/demos and not part of VividWalls:

| ID | Name | Status | Action |
|---|---|---|---|
| tbrFhIocxzdfEuBW | Deal Flow workflow-V3 | Inactive | DELETE |
| FJ1cEUK0I1lrgMX6 | Deal Flow Proposal Validation | Inactive | DELETE |
| FJu2j4mr7x4sdFp5 | PR_Deal Flow V3 | Inactive | DELETE |
| yZfcrA4chGjz53ng | PE Deal Flow Workflow - v5 | Inactive | DELETE |
| lSdAKCUXewB84pQt | Deal Flow | **Active** | DELETE |
| xwaVNol5THcApXqt | Pitch Book Submission Workflow + Frontend | Inactive | DELETE |
| W6QBb4oaWU1EfX5r | Equity Deal Workflow | Inactive | DELETE |
| KEDF1kScIwyR32fa | Create Social Media Written Content | Inactive | DELETE |
| ASBartlfdxlUu4O4 | 🔌 PE Deal Intake | Inactive | DELETE |

### Test/Debug Workflows
| ID | Name | Status | Action |
|---|---|---|---|
| PZpcpyNcZHahhfNK | Test Workflow from MCP | Inactive | DELETE |
| vzy0cvRkKnAX1MXg | Test Workflow 1753738817921 | Inactive | DELETE |
| 6UsilzH74OPQWfmp | Debug Test Workflow | Inactive | DELETE |
| kgZbCJ5WKSlkfbXq | Test Workflow from MCP | Inactive | DELETE |
| CQjirR85ZISxLNdC | Test Workflow from MCP | Inactive | DELETE |
| dxaNvbdKZp4cTNJf | Workflow to Delete 1753738824899 | Inactive | DELETE |

### Generic "My workflow" Entries
| ID | Name | Status | Action |
|---|---|---|---|
| d903UyxB1v9a4V74 | My workflow | Inactive | DELETE |
| VD37qZFUBJMqX2Rb | My workflow 6 | Inactive | DELETE |
| gbMYHfI4EPyLfQ84 | My workflow 3 | Inactive | DELETE |
| JuMjZjYExceR9s9q | My workflow 2 | Inactive | DELETE |
| jQRZGhRNSsZ5f3QA | My workflow 5 | Inactive | DELETE |
| qXWzbMurQUXeZAjw | My workflow 4 | **Active** | DELETE |

## Problematic Node Types

The Finance Director Agent (ID: 0lMVtjudeZTbYKmz) and other workflows are trying to use:
- `@n8n/n8n-nodes-langchain.vectorStoreAirtableSearch` - **Not installed**
- `@n8n/n8n-nodes-langchain.mcpToolKit` - **Not installed**

These are causing the webhook removal errors you're seeing in the logs.

## Immediate Actions Required

### 1. Delete Non-VividWalls Workflows
```bash
# Run on droplet
docker exec postgres psql -U postgres -d postgres -c "
DELETE FROM workflow_entity 
WHERE name LIKE '%Deal Flow%' 
   OR name LIKE '%DesignThru%' 
   OR name LIKE '%Test Workflow%' 
   OR name LIKE '%Debug%'
   OR name LIKE '%My workflow%'
   OR name LIKE '%Pitch Book%'
   OR name LIKE '%Equity Deal%'
   OR name = 'Workflow to Delete 1753738824899';
"
```

### 2. Fix Finance Director Workflow
The Finance Director Agent is trying to use Airtable vector store which isn't part of your stack. It should use:
- Supabase vector store (you have this)
- Qdrant vector store (you have this)
- Standard n8n AI nodes

### 3. Clean Up Database
After deleting workflows:
```bash
# Vacuum the database to reclaim space
docker exec postgres psql -U postgres -d postgres -c "VACUUM FULL workflow_entity;"
```

## API Key Issue

The current API key mismatch is preventing updates. The n8n container has a different encryption key than what's expected:
- Container starts with: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI3M...`
- .env file has: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MjE0ZmE5OS1iYzM2LTQwNWUtYjU2Zi01MWI1MDk3N2IxZGIi...`

This needs to be synchronized.

## Summary

**Total Workflows: 84**
- **VividWalls Workflows: ~62** (legitimate)
- **Non-VividWalls to Remove: 22** (external demos, tests, generic)

After cleanup, you should have only VividWalls-specific workflows, which will eliminate:
- The 404 errors (workflows that don't belong)
- The node type errors (Airtable dependencies)
- The webhook removal errors

The 400 Bad Request errors for legitimate workflows can then be fixed by:
1. Ensuring proper API authentication
2. Removing read-only fields from update payloads
3. Installing any missing legitimate node packages