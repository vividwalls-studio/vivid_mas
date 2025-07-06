import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import { PostizApiClient } from './postiz-client.js';

const POSTIZ_API_KEY = process.env.POSTIZ_API_KEY || '8895d94a-8d76-4d69-a212-23f248a7f78d';

export function createServer(): McpServer {
  const server = new McpServer({
    name: "postiz-mcp-server",
    version: "0.1.0",
  });

  const postizClient = new PostizApiClient(POSTIZ_API_KEY);

  // Tool to get all integrations
  server.tool(
    "get_postiz_integrations",
    "Get all added integrations from Postiz.",
    {},
    async () => {
      const integrations = await postizClient.getIntegrations();
      return {
        content: [
          {
            type: "text",
            text: JSON.stringify(integrations, null, 2),
          },
        ],
      };
    },
  );

  // Tool to get posts with optional filters
  server.tool(
    "get_postiz_posts",
    "Retrieve posts from Postiz with optional filtering by display, day, week, month, or year.",
    {
      display: z.enum(['day', 'week', 'month']).optional().describe("Filter by display type (day, week, or month)"),
      day: z.number().min(0).max(6).optional().describe("Day of week (0-6) - required if display is 'day'"),
      week: z.number().min(1).max(52).optional().describe("Week number (1-52) - required if display is 'week' or 'day'"),
      month: z.number().min(1).max(12).optional().describe("Month (1-12) - required if display is 'month' or 'week'"),
      year: z.number().min(2022).optional().describe("Year (2022+) - always required when using filters"),
    },
    async (filters) => {
      const posts = await postizClient.getPosts(filters);
      return {
        content: [
          {
            type: "text",
            text: JSON.stringify(posts, null, 2),
          },
        ],
      };
    },
  );

  // Tool to create or update posts
  server.tool(
    "create_postiz_post",
    "Create or update posts across multiple integrations in Postiz.",
    {
      type: z.enum(['draft', 'schedule', 'now']).describe("Type of post creation"),
      date: z.string().describe("Date for the post (ISO format)"),
      content: z.string().describe("The content of the post"),
      integrationIds: z.array(z.string()).describe("Array of integration IDs to post to"),
      postId: z.string().optional().describe("Post ID if updating an existing post"),
      groupId: z.string().optional().describe("Group ID to link posts together"),
      shortLink: z.boolean().optional().describe("Whether to use short links"),
      interval: z.number().optional().describe("Interval between posts in minutes"),
      tags: z.array(z.object({
        value: z.string(),
        label: z.string()
      })).optional().describe("Tags for the post"),
      media: z.array(z.object({
        id: z.string(),
        path: z.string()
      })).optional().describe("Media attachments"),
      settings: z.object({}).passthrough().optional().describe("Platform-specific settings"),
    },
    async ({ type, date, content, integrationIds, postId, groupId, shortLink, interval, tags, media, settings }) => {
      // Build the posts array for each integration
      const posts = integrationIds.map(integrationId => ({
        integration: { id: integrationId },
        value: [{
          content,
          id: postId,
          image: media
        }],
        group: groupId,
        settings: settings || {}
      }));

      const postData = {
        type,
        date,
        order: '',
        shortLink: shortLink ?? true,
        inter: interval ?? 0,
        tags: tags || [],
        posts
      };

      const result = await postizClient.createPost(postData);
      return {
        content: [
          {
            type: "text",
            text: JSON.stringify(result, null, 2),
          },
        ],
      };
    },
  );

  // Tool to create a simple post (single integration)
  server.tool(
    "create_simple_postiz_post",
    "Create a simple post to a single integration in Postiz.",
    {
      content: z.string().describe("The content of the post"),
      integrationId: z.string().describe("Integration ID to post to"),
      type: z.enum(['draft', 'schedule', 'now']).default('now').describe("Type of post creation (default: now)"),
      date: z.string().optional().describe("Date for the post (ISO format) - required if type is 'schedule'"),
      postId: z.string().optional().describe("Post ID if updating an existing post"),
      mediaUrls: z.array(z.string()).optional().describe("Array of media URLs to attach"),
    },
    async ({ content, integrationId, type, date, postId, mediaUrls }) => {
      // For 'now' type, use current date
      const postDate = date || new Date().toISOString();
      
      // Convert media URLs to media objects
      const media = mediaUrls?.map((url, index) => ({
        id: `media-${index}`,
        path: url
      }));

      const postData = {
        type,
        date: postDate,
        order: '',
        shortLink: true,
        inter: 0,
        tags: [],
        posts: [{
          integration: { id: integrationId },
          value: [{
            content,
            id: postId,
            image: media
          }],
          settings: {}
        }]
      };

      const result = await postizClient.createPost(postData);
      return {
        content: [
          {
            type: "text",
            text: JSON.stringify(result, null, 2),
          },
        ],
      };
    },
  );

  // Tool to delete a post
  server.tool(
    "delete_postiz_post",
    "Delete a specific post from Postiz.",
    {
      postId: z.string().describe("The ID of the post to delete"),
    },
    async ({ postId }) => {
      const result = await postizClient.deletePost(postId);
      return {
        content: [
          {
            type: "text",
            text: JSON.stringify(result, null, 2),
          },
        ],
      };
    },
  );

  // Tool to upload a file (Note: This would need base64 or file path support)
  server.tool(
    "upload_postiz_file",
    "Upload a file to Postiz (requires base64 encoded file content).",
    {
      fileContent: z.string().describe("Base64 encoded file content"),
      fileName: z.string().describe("Name of the file"),
      mimeType: z.string().describe("MIME type of the file (e.g., image/jpeg)"),
    },
    async ({ fileContent, fileName, mimeType }) => {
      const fileBuffer = Buffer.from(fileContent, 'base64');
      const result = await postizClient.uploadFile(fileBuffer, fileName, mimeType);
      return {
        content: [
          {
            type: "text",
            text: JSON.stringify(result, null, 2),
          },
        ],
      };
    },
  );

  return server;
}
