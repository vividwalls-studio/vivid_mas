#!/usr/bin/env python3
"""
Create Missing Agents Implementation Script
This script creates all missing agent configurations following established patterns
"""

import json
import uuid
from pathlib import Path
import shutil
from datetime import datetime

# Base paths
BASE_PATH = Path("/Volumes/SeagatePortableDrive/Projects/vivid_mas")
MCP_DATA_PATH = BASE_PATH / "services/mcp-servers/mcp_data"
MCP_AGENTS_PATH = BASE_PATH / "services/mcp-servers/agents"
AGENTS_CONFIG_PATH = BASE_PATH / "services/agents"

def load_json(file_path):
    """Load JSON file"""
    with open(file_path, 'r') as f:
        return json.load(f)

def save_json(data, file_path):
    """Save JSON file with proper formatting"""
    with open(file_path, 'w') as f:
        json.dump(data, f, indent=2)

def create_backup(file_path):
    """Create backup of existing file"""
    if file_path.exists():
        backup_path = file_path.with_suffix(f'.backup.{datetime.now().strftime("%Y%m%d_%H%M%S")}.json')
        shutil.copy2(file_path, backup_path)
        print(f"✅ Created backup: {backup_path.name}")
        return backup_path
    return None

def create_agent_domain_knowledge(agent_id, agent_name):
    """Create domain knowledge configuration for agent"""
    return {
        "agent_id": agent_id,
        "vector_database": f"{agent_name}VectorDB",
        "knowledge_graph": f"{agent_name}KnowledgeGraph",
        "relational_database": f"{agent_name}RelationalDB"
    }

def create_mcp_prompt_server(agent_name, agent_role, specializations):
    """Create MCP prompt server package.json and TypeScript files"""
    folder_name = agent_name.replace('Agent', '').lower()
    folder_name = '-'.join([folder_name[i:i+4] for i in range(0, len(folder_name), 4)])
    prompt_path = MCP_AGENTS_PATH / f"{folder_name}-prompts"
    
    # Create directory
    prompt_path.mkdir(parents=True, exist_ok=True)
    
    # Create package.json
    package_json = {
        "name": f"{folder_name}-prompts",
        "version": "1.0.0",
        "description": f"MCP Prompt Server for {agent_name}",
        "type": "module",
        "main": "dist/index.js",
        "scripts": {
            "build": "tsc",
            "dev": "tsx src/index.ts",
            "test": "jest"
        },
        "dependencies": {
            "@modelcontextprotocol/sdk": "^1.4.1",
            "zod": "^3.24.1"
        },
        "devDependencies": {
            "@types/node": "^20.0.0",
            "typescript": "^5.0.0",
            "tsx": "^4.0.0",
            "jest": "^29.0.0"
        }
    }
    save_json(package_json, prompt_path / "package.json")
    
    # Create TypeScript config
    tsconfig = {
        "compilerOptions": {
            "target": "ES2022",
            "module": "Node16",
            "moduleResolution": "Node16",
            "outDir": "./dist",
            "rootDir": "./src",
            "strict": True,
            "esModuleInterop": True,
            "skipLibCheck": True,
            "forceConsistentCasingInFileNames": True
        },
        "include": ["src/**/*"],
        "exclude": ["node_modules", "dist"]
    }
    save_json(tsconfig, prompt_path / "tsconfig.json")
    
    # Create src directory
    src_path = prompt_path / "src"
    src_path.mkdir(exist_ok=True)
    
    # Create index.ts
    index_ts = f'''import {{ McpServer }} from "@modelcontextprotocol/sdk/server/mcp.js";
import {{ StdioServerTransport }} from "@modelcontextprotocol/sdk/server/stdio.js";
import {{ z }} from "zod";

const server = new McpServer({{
  name: "{folder_name}-prompts",
  version: "1.0.0"
}});

// System prompt for {agent_name}
server.prompt(
  "system",
  "System prompt for {agent_name}",
  async () => {{
    return {{
      messages: [{{
        role: "system",
        content: `You are the {agent_name}, specializing in {agent_role}.
        
Your key responsibilities include:
{chr(10).join(f"- {spec}" for spec in specializations)}

Approach each task with expertise in your domain, collaborating with other agents as needed.`
      }}]
    }};
  }}
);

// Task execution prompt
server.prompt(
  "execute-task",
  "Execute a specific task for {agent_name}",
  {{
    task: z.string().describe("The task to execute"),
    context: z.string().optional().describe("Additional context")
  }},
  async ({{ task, context }}) => {{
    return {{
      messages: [{{
        role: "user",
        content: `Execute the following task: ${{task}}${{context ? `\\n\\nContext: ${{context}}` : ""}}`
      }}]
    }};
  }}
);

// Initialize and run server
async function main() {{
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.log("{agent_name} Prompt Server running on stdio");
}}

main().catch(console.error);
'''
    
    with open(src_path / "index.ts", 'w') as f:
        f.write(index_ts)
    
    print(f"✅ Created MCP prompt server: {prompt_path}")
    return prompt_path

def create_mcp_resource_server(agent_name, agent_role):
    """Create MCP resource server for agent"""
    folder_name = agent_name.replace('Agent', '').lower()
    folder_name = '-'.join([folder_name[i:i+4] for i in range(0, len(folder_name), 4)])
    resource_path = MCP_AGENTS_PATH / f"{folder_name}-resource"
    
    # Create directory
    resource_path.mkdir(parents=True, exist_ok=True)
    
    # Create package.json
    package_json = {
        "name": f"{folder_name}-resource",
        "version": "1.0.0",
        "description": f"MCP Resource Server for {agent_name}",
        "type": "module",
        "main": "dist/index.js",
        "scripts": {
            "build": "tsc",
            "dev": "tsx src/index.ts",
            "test": "jest"
        },
        "dependencies": {
            "@modelcontextprotocol/sdk": "^1.4.1",
            "zod": "^3.24.1"
        },
        "devDependencies": {
            "@types/node": "^20.0.0",
            "typescript": "^5.0.0",
            "tsx": "^4.0.0",
            "jest": "^29.0.0"
        }
    }
    save_json(package_json, resource_path / "package.json")
    
    # Create TypeScript config (same as prompt server)
    tsconfig = {
        "compilerOptions": {
            "target": "ES2022",
            "module": "Node16",
            "moduleResolution": "Node16",
            "outDir": "./dist",
            "rootDir": "./src",
            "strict": True,
            "esModuleInterop": True,
            "skipLibCheck": True,
            "forceConsistentCasingInFileNames": True
        },
        "include": ["src/**/*"],
        "exclude": ["node_modules", "dist"]
    }
    save_json(tsconfig, resource_path / "tsconfig.json")
    
    # Create src directory
    src_path = resource_path / "src"
    src_path.mkdir(exist_ok=True)
    
    # Create index.ts for resource server
    index_ts = f'''import {{ McpServer }} from "@modelcontextprotocol/sdk/server/mcp.js";
import {{ StdioServerTransport }} from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new McpServer({{
  name: "{folder_name}-resource",
  version: "1.0.0"
}});

// Knowledge base resource
server.resource(
  "knowledge-base",
  "Access {agent_name} knowledge base",
  async () => {{
    return {{
      mimeType: "application/json",
      content: JSON.stringify({{
        agent: "{agent_name}",
        role: "{agent_role}",
        knowledge: {{
          // Domain-specific knowledge would be loaded here
          guidelines: [],
          bestPractices: [],
          resources: []
        }}
      }})
    }};
  }}
);

// Performance metrics resource
server.resource(
  "metrics",
  "Access {agent_name} performance metrics",
  async () => {{
    return {{
      mimeType: "application/json",
      content: JSON.stringify({{
        agent: "{agent_name}",
        metrics: {{
          tasksCompleted: 0,
          successRate: 0,
          averageResponseTime: 0
        }}
      }})
    }};
  }}
);

// Initialize and run server
async function main() {{
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.log("{agent_name} Resource Server running on stdio");
}}

main().catch(console.error);
'''
    
    with open(src_path / "index.ts", 'w') as f:
        f.write(index_ts)
    
    print(f"✅ Created MCP resource server: {resource_path}")
    return resource_path

def main():
    """Main execution function"""
    print("🚀 Creating Missing Agents Implementation")
    print("=" * 60)
    
    # Load existing configurations
    agents_file = MCP_DATA_PATH / "agents.json"
    domain_knowledge_file = MCP_DATA_PATH / "agent_domain_knowledge.json"
    missing_agents_file = MCP_DATA_PATH / "missing_agents_implementation.json"
    
    # Create backups
    print("\n📦 Creating backups...")
    create_backup(agents_file)
    create_backup(domain_knowledge_file)
    
    # Load data
    agents = load_json(agents_file)
    domain_knowledge = load_json(domain_knowledge_file)
    missing_agents = load_json(missing_agents_file)
    
    # Track new agents
    new_agents = []
    new_domain_knowledge = []
    
    # Process Sales Director and Sales Agents
    print("\n💼 Creating Sales Director and Agents...")
    
    # Add Sales Director
    sales_director = missing_agents['sales_director_agent']
    if not any(a['name'] == sales_director['name'] for a in agents):
        agents.append(sales_director)
        new_agents.append(sales_director['name'])
        
        # Add domain knowledge
        dk = create_agent_domain_knowledge(sales_director['id'], sales_director['name'])
        domain_knowledge.append(dk)
        new_domain_knowledge.append(sales_director['name'])
        
        # Create MCP servers
        create_mcp_prompt_server(
            sales_director['name'],
            sales_director['role'],
            ["Sales strategy development", "Revenue optimization", "Team management", "Partnership development"]
        )
        create_mcp_resource_server(sales_director['name'], sales_director['role'])
    
    # Add Sales Agents
    for agent in missing_agents['sales_agents']:
        if not any(a['name'] == agent['name'] for a in agents):
            agents.append(agent)
            new_agents.append(agent['name'])
            
            # Add domain knowledge
            dk = create_agent_domain_knowledge(agent['id'], agent['name'])
            domain_knowledge.append(dk)
            new_domain_knowledge.append(agent['name'])
            
            # Extract specializations from backstory
            specializations = [s.strip() for s in agent['backstory'].split(':')[1].split(',')]
            
            # Create MCP servers
            create_mcp_prompt_server(agent['name'], agent['role'], specializations)
            create_mcp_resource_server(agent['name'], agent['role'])
    
    # Process Social Media Agents
    print("\n📱 Creating Social Media Agents...")
    for agent in missing_agents['social_media_agents']:
        if not any(a['name'] == agent['name'] for a in agents):
            agents.append(agent)
            new_agents.append(agent['name'])
            
            # Add domain knowledge
            dk = create_agent_domain_knowledge(agent['id'], agent['name'])
            domain_knowledge.append(dk)
            new_domain_knowledge.append(agent['name'])
            
            # Extract specializations
            specializations = [s.strip() for s in agent['backstory'].split(':')[1].split(',')]
            
            # Create MCP servers
            create_mcp_prompt_server(agent['name'], agent['role'], specializations)
            create_mcp_resource_server(agent['name'], agent['role'])
    
    # Process Marketing Agents
    print("\n📣 Creating Marketing Agents...")
    for agent in missing_agents['marketing_agents']:
        if not any(a['name'] == agent['name'] for a in agents):
            agents.append(agent)
            new_agents.append(agent['name'])
            
            # Add domain knowledge
            dk = create_agent_domain_knowledge(agent['id'], agent['name'])
            domain_knowledge.append(dk)
            new_domain_knowledge.append(agent['name'])
            
            # Extract specializations
            specializations = [s.strip() for s in agent['backstory'].split(':')[1].split(',')]
            
            # Create MCP servers
            create_mcp_prompt_server(agent['name'], agent['role'], specializations)
            create_mcp_resource_server(agent['name'], agent['role'])
    
    # Save updated configurations
    print("\n💾 Saving updated configurations...")
    save_json(agents, agents_file)
    save_json(domain_knowledge, domain_knowledge_file)
    
    # Generate summary report
    print("\n" + "=" * 60)
    print("✅ AGENT CREATION COMPLETE")
    print("=" * 60)
    print(f"\n📊 Summary:")
    print(f"  • New agents created: {len(new_agents)}")
    print(f"  • Total agents now: {len(agents)}")
    print(f"  • Domain knowledge entries: {len(domain_knowledge)}")
    
    if new_agents:
        print(f"\n🆕 New Agents Added:")
        for agent in new_agents:
            print(f"  ✓ {agent}")
    
    print(f"\n📁 Files Updated:")
    print(f"  • {agents_file}")
    print(f"  • {domain_knowledge_file}")
    print(f"  • Created {len(new_agents) * 2} MCP server directories")
    
    print("\n🎯 Next Steps:")
    print("  1. Run 'npm install' in each new MCP server directory")
    print("  2. Build TypeScript files with 'npm run build'")
    print("  3. Create n8n workflows for each new agent")
    print("  4. Update agent communication matrix")
    print("  5. Test agent integrations")

if __name__ == "__main__":
    main()