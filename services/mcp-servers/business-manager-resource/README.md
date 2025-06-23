# Business Manager Resource Server

This MCP **resource** server exposes the **Business Manager** agent’s tasks and domain knowledge from a Supabase database.

## Overview

- **Resource name**: `business-manager`
- **Function**: Reads `task_list` and `knowledge_json` for a given agent ID
- **Port**: Default `3001` (override via `PORT`)

## Prerequisites

- Node.js >= 14
- npm (bundled with Node.js)
- A Supabase project with table `agent_domain_knowledge`:
  - Columns: `agent_id` (text), `task_list` (jsonb), `knowledge_json` (jsonb)
- Environment variables configured (see below)

## Installation

```bash
cd services/mcp-servers/business-manager-resource
npm install
```

## Configuration

Copy the example `.env.example` to `.env` and fill in your credentials:

```text
SUPABASE_URL=your-supabase-url
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
PORT=3001    # optional
```

## Project Structure

```
business-manager-resource/
├── .env.example       # template for environment variables
├── package.json       # npm metadata & scripts
├── tsconfig.json      # TypeScript compiler config
└── src/
    ├── index.ts       # server bootstrap
    └── resource.ts    # MCP ResourceDefinition
```

## Scripts

- `npm run build` – Compiles TypeScript into `dist/`
- `npm start`       – Runs compiled server (`dist/index.js`)

## Usage

### Start the server

```bash
npm run build
npm start
```

### Invoke the resource

Use a simple HTTP POST to the `/read` endpoint:

```bash
curl -X POST http://localhost:3001/read \
  -H 'Content-Type: application/json' \
  -d '{
    "resource": "business-manager",
    "parameters": { "agentId": "<your-agent-id>" }
}'
```

**Response** (JSON):
```json
{
  "tasks": [ /* array of task identifiers */ ],
  "knowledge": { /* domain knowledge object */ }
}
```

## Testing

After starting the server, ensure it responds:

```bash
# Example test
curl -X POST http://localhost:3001/read \
  -H 'Content-Type: application/json' \
  -d '{"resource":"business-manager","parameters":{"agentId":"testAgent"}}'
```

If your `.env` is correct, you should receive a JSON object with `tasks` and `knowledge`.

## License

MIT © VividWalls Studio, Inc.
