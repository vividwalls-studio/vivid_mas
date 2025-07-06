# Postiz MCP Server

A Model Context Protocol (MCP) server that provides tools for interacting with the Postiz social media scheduling platform API.

## Overview

This MCP server enables AI agents and coding assistants to manage social media posts through Postiz, supporting multiple integrations, scheduled posts, and media uploads. It implements the complete Postiz Public API v1.

## Features

- 📝 Create, update, and delete posts across multiple social media platforms
- 📅 Schedule posts for future publication
- 🏷️ Manage post tags and categories
- 📸 Upload and attach media files
- 🔗 Manage social media integrations
- 🔍 Query posts with advanced filtering options

## Available Tools

### 1. `get_postiz_integrations`
Get all connected social media integrations.

**Parameters:** None

**Returns:** List of integration objects with ID, name, platform identifier, and status.

### 2. `get_postiz_posts`
Retrieve posts with optional filtering by time period.

**Parameters:**
- `display` (optional): Filter type - 'day', 'week', or 'month'
- `day` (optional): Day of week (0-6) - required if display is 'day'
- `week` (optional): Week number (1-52) - required if display is 'week' or 'day'
- `month` (optional): Month (1-12) - required if display is 'month' or 'week'
- `year` (optional): Year (2022+) - required when using any filters

**Returns:** Object containing posts array with post details, publish dates, and integration info.

### 3. `create_postiz_post`
Create or update posts across multiple integrations with full control.

**Parameters:**
- `type`: Post type - 'draft', 'schedule', or 'now'
- `date`: ISO format date string
- `content`: The post content
- `integrationIds`: Array of integration IDs to post to
- `postId` (optional): ID for updating existing post
- `groupId` (optional): Group ID to link posts together
- `shortLink` (optional): Whether to use short links
- `interval` (optional): Interval between posts in minutes
- `tags` (optional): Array of tag objects with value and label
- `media` (optional): Array of media objects with id and path
- `settings` (optional): Platform-specific settings object

**Returns:** Array of created post IDs with their integration mappings.

### 4. `create_simple_postiz_post`
Simplified tool for creating a single post to one integration.

**Parameters:**
- `content`: The post content
- `integrationId`: Single integration ID
- `type` (optional): Post type - defaults to 'now'
- `date` (optional): ISO format date - required if type is 'schedule'
- `postId` (optional): ID for updating existing post
- `mediaUrls` (optional): Array of media URLs to attach

**Returns:** Created post ID and integration mapping.

### 5. `delete_postiz_post`
Delete a specific post by ID.

**Parameters:**
- `postId`: The ID of the post to delete

**Returns:** Deleted post ID confirmation.

### 6. `upload_postiz_file`
Upload a file to Postiz for use in posts.

**Parameters:**
- `fileContent`: Base64 encoded file content
- `fileName`: Name of the file
- `mimeType`: MIME type (e.g., 'image/jpeg')

**Returns:** File upload details including ID and URL.

## Installation

### Prerequisites

- Node.js 16.x or higher
- npm or yarn
- Postiz account with API access

### Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd postiz-mcp-server
```

2. Install dependencies:
```bash
npm install
```

3. Build the TypeScript code:
```bash
npm run build
```

4. Set up your Postiz API key:
   - Log in to your Postiz dashboard
   - Navigate to Settings → API Keys
   - Create or copy your API key

## Configuration

### Environment Variables

Create a `.env` file or set these environment variables:

```env
POSTIZ_API_KEY=your-postiz-api-key-here
```

### MCP Client Configuration

#### For Claude Desktop

Add to your Claude Desktop configuration:

```json
{
  "mcpServers": {
    "postiz": {
      "command": "node",
      "args": ["path/to/postiz-mcp-server/dist/index.js"],
      "env": {
        "POSTIZ_API_KEY": "your-postiz-api-key"
      }
    }
  }
}
```

#### For n8n

Add to your n8n MCP configuration:

```json
{
  "mcpServers": {
    "postiz-mcp": {
      "command": "node",
      "args": ["dist/index.js"],
      "cwd": "/path/to/postiz-mcp-server",
      "env": {
        "POSTIZ_API_KEY": "your-postiz-api-key"
      }
    }
  }
}
```

#### For Postiz Native SSE Endpoint

If your Postiz instance provides a native MCP SSE endpoint:

```json
{
  "mcpServers": {
    "postiz": {
      "transport": "sse",
      "url": "https://your-postiz-instance.com/api/mcp/your-token/sse"
    }
  }
}
```

## Usage Examples

### Get All Integrations
```javascript
// Tool: get_postiz_integrations
// No parameters needed
```

### Create a Simple Post
```javascript
// Tool: create_simple_postiz_post
{
  "content": "Check out our latest blog post!",
  "integrationId": "int_123456",
  "type": "now"
}
```

### Schedule Multiple Posts
```javascript
// Tool: create_postiz_post
{
  "type": "schedule",
  "date": "2025-01-15T10:00:00Z",
  "content": "Exciting announcement coming soon!",
  "integrationIds": ["int_123456", "int_789012"],
  "tags": [
    {"value": "announcement", "label": "Announcement"},
    {"value": "product", "label": "Product"}
  ]
}
```

### Get This Week's Posts
```javascript
// Tool: get_postiz_posts
{
  "display": "week",
  "week": 2,
  "year": 2025
}
```

## API Limits

- Rate limit: 30 requests per hour
- Supported platforms vary based on your Postiz plan
- Media upload size limits apply

## Development

### Running Tests
```bash
npm test
```

### Development Mode
```bash
npm run dev
```

### Linting
```bash
npm run lint
```

### Type Checking
```bash
npm run typecheck
```

## Platform-Specific Settings

When creating posts, you can include platform-specific settings:

### Dev.to
- `title`: Post title (required)
- `main_image`: Main image object
- `canonical`: Canonical URL
- `organization`: Organization name
- `tags`: Array of up to 4 tags

### Medium
- `title`: Post title (required)
- `subtitle`: Post subtitle (required)
- `canonical`: Canonical URL
- `publication`: Publication name
- `tags`: Array of up to 4 tags

### Hashnode
- `title`: Post title (required)
- `subtitle`: Post subtitle
- `main_image`: Main image object
- `canonical`: Canonical URL
- `publication`: Publication slug (required)
- `tags`: Array of tags (minimum 1 required)

## Troubleshooting

### Invalid API Key Error
- Ensure your API key is correctly set in the environment
- Check that the API key has not expired
- Verify you're using the correct Postiz instance URL

### Rate Limiting
- The API allows 30 requests per hour
- Implement request queuing for high-volume operations
- Consider caching integration lists

### Connection Issues
- Verify your Postiz instance is accessible
- Check firewall settings
- Ensure SSL certificates are valid

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

- Postiz Documentation: https://docs.postiz.com
- API Reference: https://docs.postiz.com/public-api
- Issues: Please file issues on the GitHub repository

## Changelog

### v0.1.0
- Initial release
- Full implementation of Postiz Public API v1
- Support for all major social media platforms
- Comprehensive post management tools
- Media upload capabilities