# Marketing Director Resource Server

This MCP **resource** server exposes the **Marketing Director** agent’s tasks and domain knowledge from a Supabase database.

## Overview

- **Resource name**: `marketing-director`
- **Function**: Reads `task_list` and `knowledge_json` for a given agent ID
- **Port**: Default `3003` (override via `PORT`)

## Prerequisites

- Node.js >= 14
- npm (bundled with Node.js)
- A Supabase project with table `agent_domain_knowledge`:
  - Columns: `agent_id` (text), `task_list` (jsonb), `knowledge_json` (jsonb)
- Environment variables configured (see below)

## Installation

```bash
cd services/mcp-servers/marketing-director-resource
npm install
```

## Configuration

Copy the example `.env.example` to `.env` and fill in your credentials:

```text
SUPABASE_URL=your-supabase-url
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
PORT=3003    # optional
```

## Project Structure

```
marketing-director-resource/
├── .env.example       # template for environment variables
├── package.json       # npm metadata & scripts
├── tsconfig.json      # TypeScript compiler config
└── src/
    ├── index.ts       # server bootstrap
    ├── resource.ts    # MCP ResourceDefinition
    └── global.d.ts    # type declarations
```

## Scripts

- `npm run build` – Compiles TypeScript into `dist/`
- `npm start`       – Runs compiled server (`dist/index.js`)
- `npm test`        – Validates resource export shape

## Usage

### Start the server

```bash
npm run build
npm start
```

### Invoke the resource

```bash
curl -X POST http://localhost:3003/read \
  -H 'Content-Type: application/json' \
  -d '{
    "resource": "marketing-director",
    "parameters": { "agentId": "<agent-id>" }
  }'
```

## Testing

```bash
npm test
```

## License

MIT © VividWalls Studio, Inc.
