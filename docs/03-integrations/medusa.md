# Medusa E-commerce Platform Integration

This document outlines the integration of the Medusa e-commerce platform within the VividMAS ecosystem.

## Overview

Medusa is an open-source headless commerce platform that provides a flexible and scalable solution for managing products, orders, customers, and more. It is integrated into the VividMAS platform to handle all e-commerce functionalities.

## Key Features

- **Headless Architecture**: Decoupled storefront and backend, allowing for flexible frontend development.
- **Extensible**: Customizable through plugins and extensions.
- **Scalable**: Built to handle high-volume traffic and large product catalogs.
- **Admin Interface**: A user-friendly admin panel for managing the store.

## Deployment

The Medusa application is deployed as a Docker container on the main DigitalOcean droplet. The deployment process is automated via the `./scripts/deploy_medusa_to_droplet.sh` script, which handles:

-   Directory and user creation
-   Docker and Caddy configuration
-   Database setup and seeding
-   Container startup and migrations

### DNS Configuration

The Medusa service is accessible via the following subdomains:

-   **Admin Panel**: `https://medusa.vividwalls.blog/app`
-   **Store API**: `https://medusa.vividwalls.blog/store`
-   **Admin API**: `https://medusa.vividwalls.blog/admin`

These are configured via A records pointing to the droplet's IP address and managed by Caddy for SSL termination.

### Environment Configuration

The core configuration for the Medusa service is managed through environment variables located in `/root/vivid_mas/.env` on the droplet. Key variables include:

```bash
MEDUSA_HOSTNAME=medusa.vividwalls.blog
MEDUSA_DB_PASSWORD=<generated>
MEDUSA_JWT_SECRET=<generated>
MEDUSA_COOKIE_SECRET=<generated>
MEDUSA_ADMIN_EMAIL=admin@vividwalls.com
MEDUSA_ADMIN_PASSWORD=<generated>
```

The `medusa-config.ts` file defines the application's configuration, including database connections, CORS settings, and JWT secrets.

```typescript
import { loadEnv, defineConfig } from '@medusajs/framework/utils'

loadEnv(process.env.NODE_ENV || 'development', process.cwd())

module.exports = defineConfig({
  projectConfig: {
    databaseUrl: process.env.DATABASE_URL,
    http: {
      storeCors: process.env.STORE_CORS || "http://localhost:8000,https://shop.vividwalls.com",
      adminCors: process.env.ADMIN_CORS || "http://localhost:9000,https://medusa.vividwalls.blog",
      authCors: process.env.AUTH_CORS || "http://localhost:9000,https://medusa.vividwalls.blog",
      jwtSecret: process.env.JWT_SECRET || "supersecret",
      cookieSecret: process.env.COOKIE_SECRET || "supersecret",
    },
    redisUrl: process.env.REDIS_URL,
    workerMode: process.env.WORKER_MODE as "shared" | "worker" | "server",
  },
  admin: {
    disable: process.env.DISABLE_MEDUSA_ADMIN === "true",
  },
})
```

## Integration with MCP Server

The Medusa application is controlled and monitored by the **Medusa MCP Server**. This server exposes a set of tools that can be called by n8n workflows to automate various e-commerce tasks. See the [Medusa MCP Server documentation](docs/02-architecture/medusa-mcp-server.md) for more details.
