declare module '@modelcontextprotocol/sdk' {
  export function createServer(options: any): Promise<any>;
  export interface PromptDefinition {
    name: string;
    description?: string;
    template: string;
  }
}
