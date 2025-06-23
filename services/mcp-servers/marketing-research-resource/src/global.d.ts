declare module '@supabase/supabase-js' {
  export function createClient(url: string, key: string): any;
}

declare module '@modelcontextprotocol/sdk/server/mcp.js' {
  import { ZodRawShape } from 'zod';
  export class McpServer {
    constructor(options: { name: string; version: string });
    tool(
      name: string,
      description: string,
      paramsSchema: ZodRawShape,
      handler: (args: any, extra: any) => Promise<{ content: { type: string; text: string }[] }>
    ): any;
  }
}