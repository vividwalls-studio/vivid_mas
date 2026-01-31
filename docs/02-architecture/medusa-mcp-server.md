# Medusa MCP Server

This document describes the Medusa MCP (Model Context Protocol) server, which acts as a bridge between the Medusa e-commerce platform and the VividMAS n8n workflows.

## Overview

The Medusa MCP server is a Node.js application that exposes a set of tools for managing and interacting with the Medusa API. These tools can be called from n8n workflows to automate various e-commerce tasks, such as order management, financial analytics, and product synchronization.

## Features

The MCP server provides a comprehensive set of tools, including:

-   **Order Management**: `list-orders`, `get-order`
-   **Financial Analytics**: `get-sales-analytics`, `get-revenue-report`
-   **Product & Inventory**: `sync-products-with-shopify`, `get-inventory-levels`
-   **Customer Management**: `list-customers`, `get-customer-analytics`
-   **Discount & Pricing**: `list-discounts`, `create-discount`
-   **Tax & Compliance**: `get-tax-report`

## Configuration

The server is configured using environment variables. The most important variables are:

-   `MEDUSA_BASE_URL`: The base URL of the Medusa API.
-   `MEDUSA_API_TOKEN`: The API token for authenticating with the Medusa API.

In the production environment, these variables are set in the main `.env` file and passed to the `medusa-mcp-server` Docker container.

## Integration with n8n

The Medusa MCP server is integrated with n8n by defining it as an MCP server in the n8n configuration. This allows n8n workflows to call the tools exposed by the server.

```json
{
  "mcp": {
    "servers": {
      "medusa": {
        "command": "node",
        "args": ["/opt/mcp-servers/medusa-mcp-server/build/index.js"],
        "env": {
          "MEDUSA_BASE_URL": "http://medusa:9000",
          "MEDUSA_API_TOKEN": "your-api-token"
        }
      }
    }
  }
}
```

## Role in the VividMAS Architecture

The Medusa MCP server is a key component of the VividMAS architecture, enabling seamless integration between the e-commerce platform and the various agent workflows. It allows agents such as the **Business Manager**, **Finance Director**, and **Sales Director** to perform their functions by interacting with the Medusa API in a standardized and secure way.

For more information on the Medusa application itself, see the [Medusa Integration documentation](docs/03-integrations/medusa.md).
