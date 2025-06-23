declare module '@modelcontextprotocol/sdk' {
  export function createServer(options: any): Promise<any>;
  export interface ResourceDefinition {
    name: string;
    description?: string;
    read?(context: any): Promise<any>;
    write?(context: any): Promise<any>;
  }
}
