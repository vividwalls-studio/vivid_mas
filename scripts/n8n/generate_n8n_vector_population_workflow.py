#!/usr/bin/env python3
"""
Generate n8n workflow for populating agent vector database.
This creates a workflow that can be imported into n8n for automated vector population.
"""

import json
from datetime import datetime

def generate_n8n_workflow():
    """Generate n8n workflow for vector database population."""
    
    workflow = {
        "name": "Populate Agent Vector Database",
        "nodes": [
            {
                "parameters": {
                    "content": "## Agent Vector Database Population Workflow\n\nThis workflow:\n1. Reads agent domain knowledge from JSON file\n2. Generates embeddings using OpenAI\n3. Stores in Supabase vector database\n4. Uses proper authentication for self-hosted Supabase",
                    "height": 200,
                    "width": 400,
                    "color": 7
                },
                "type": "n8n-nodes-base.stickyNote",
                "position": [100, 100],
                "id": "note-overview",
                "name": "Workflow Overview"
            },
            {
                "parameters": {
                    "path": "populate-vectors",
                    "options": {
                        "respondWith": "json",
                        "jsonBody": {
                            "schema": {
                                "type": "object",
                                "properties": {
                                    "action": {
                                        "type": "string",
                                        "enum": ["start", "status"]
                                    }
                                }
                            }
                        }
                    }
                },
                "type": "n8n-nodes-base.webhook",
                "typeVersion": 2,
                "position": [300, 300],
                "id": "webhook-trigger",
                "name": "Manual Trigger"
            },
            {
                "parameters": {
                    "url": "={{ $env.SUPABASE_URL }}/storage/v1/object/public/agent-knowledge/agent_domain_knowledge.json",
                    "options": {
                        "headers": {
                            "header": [
                                {
                                    "name": "Authorization",
                                    "value": "Basic {{ Buffer.from('supabase:this_password_is_insecure_and_should_be_updated').toString('base64') }}"
                                }
                            ]
                        }
                    }
                },
                "type": "n8n-nodes-base.httpRequest",
                "typeVersion": 4,
                "position": [500, 300],
                "id": "read-knowledge",
                "name": "Read Agent Knowledge"
            },
            {
                "parameters": {
                    "functionCode": """// Parse and prepare agent knowledge for processing
const agentKnowledge = $input.first().json;
const processedItems = [];

// Iterate through each agent
for (const [agentName, agentData] of Object.entries(agentKnowledge)) {
    const collectionName = `${agentName}_vectors`;
    
    // Process each knowledge item
    for (const item of agentData.knowledge) {
        processedItems.push({
            agent_id: agentData.agent_id,
            collection: collectionName,
            content: item.content,
            metadata: {
                agent_id: agentData.agent_id,
                domain: agentData.domain,
                content_type: item.content_type,
                collection: collectionName,
                created_at: new Date().toISOString()
            }
        });
    }
}

// Return items for batching
return processedItems.map(item => ({ json: item }));"""
                },
                "type": "n8n-nodes-base.function",
                "typeVersion": 1.1,
                "position": [700, 300],
                "id": "prepare-data",
                "name": "Prepare Knowledge Items"
            },
            {
                "parameters": {
                    "batchSize": 5,
                    "options": {}
                },
                "type": "n8n-nodes-base.splitInBatches",
                "typeVersion": 3,
                "position": [900, 300],
                "id": "batch-items",
                "name": "Batch Items"
            },
            {
                "parameters": {
                    "method": "POST",
                    "url": "https://api.openai.com/v1/embeddings",
                    "authentication": "genericCredentialType",
                    "genericAuthType": "httpHeaderAuth",
                    "sendBody": True,
                    "specifyBody": "json",
                    "jsonBody": "={{ JSON.stringify({ model: 'text-embedding-3-small', input: $json.content }) }}",
                    "options": {}
                },
                "type": "n8n-nodes-base.httpRequest",
                "typeVersion": 4,
                "position": [1100, 300],
                "id": "generate-embedding",
                "name": "Generate Embedding",
                "credentials": {
                    "httpHeaderAuth": {
                        "id": "openai-api",
                        "name": "OpenAI API"
                    }
                }
            },
            {
                "parameters": {
                    "functionCode": """// Combine original data with embedding
const originalData = $node['Batch Items'].json;
const embeddingResponse = $input.first().json;

// Extract embedding from OpenAI response
const embedding = embeddingResponse.data[0].embedding;

// Create complete record
const record = {
    ...originalData,
    embedding: embedding
};

return { json: record };"""
                },
                "type": "n8n-nodes-base.function",
                "typeVersion": 1.1,
                "position": [1300, 300],
                "id": "combine-data",
                "name": "Combine with Embedding"
            },
            {
                "parameters": {
                    "method": "POST",
                    "url": "={{ $env.SUPABASE_URL }}/rest/v1/agent_embeddings",
                    "authentication": "genericCredentialType",
                    "genericAuthType": "httpHeaderAuth",
                    "sendBody": True,
                    "specifyBody": "json",
                    "jsonBody": "={{ JSON.stringify($json) }}",
                    "options": {
                        "headers": {
                            "header": [
                                {
                                    "name": "apikey",
                                    "value": "={{ $env.SUPABASE_SERVICE_KEY }}"
                                },
                                {
                                    "name": "Content-Type",
                                    "value": "application/json"
                                },
                                {
                                    "name": "Prefer",
                                    "value": "return=representation"
                                }
                            ]
                        }
                    }
                },
                "type": "n8n-nodes-base.httpRequest",
                "typeVersion": 4,
                "position": [1500, 300],
                "id": "insert-vector",
                "name": "Insert to Supabase"
            },
            {
                "parameters": {
                    "values": {
                        "number": [
                            {
                                "name": "delay",
                                "value": 500
                            }
                        ]
                    },
                    "options": {}
                },
                "type": "n8n-nodes-base.set",
                "typeVersion": 3.4,
                "position": [1700, 300],
                "id": "rate-limit",
                "name": "Rate Limit Delay"
            },
            {
                "parameters": {
                    "amount": "={{ $json.delay }}",
                    "unit": "milliseconds"
                },
                "type": "n8n-nodes-base.wait",
                "typeVersion": 1.1,
                "position": [1900, 300],
                "id": "wait",
                "name": "Wait"
            },
            {
                "parameters": {
                    "functionCode": """// Aggregate results
const allItems = $items();
const successful = allItems.filter(item => item.json.id).length;
const failed = allItems.length - successful;

return {
    json: {
        status: 'completed',
        timestamp: new Date().toISOString(),
        results: {
            total_processed: allItems.length,
            successful: successful,
            failed: failed
        },
        message: `Successfully populated ${successful} vector embeddings`
    }
};"""
                },
                "type": "n8n-nodes-base.function",
                "typeVersion": 1.1,
                "position": [1100, 500],
                "id": "aggregate-results",
                "name": "Aggregate Results"
            },
            {
                "parameters": {
                    "options": {}
                },
                "type": "n8n-nodes-base.respondToWebhook",
                "typeVersion": 1.2,
                "position": [1300, 500],
                "id": "respond",
                "name": "Return Status"
            }
        ],
        "connections": {
            "Manual Trigger": {
                "main": [[{"node": "Read Agent Knowledge", "type": "main", "index": 0}]]
            },
            "Read Agent Knowledge": {
                "main": [[{"node": "Prepare Knowledge Items", "type": "main", "index": 0}]]
            },
            "Prepare Knowledge Items": {
                "main": [[{"node": "Batch Items", "type": "main", "index": 0}]]
            },
            "Batch Items": {
                "main": [[{"node": "Generate Embedding", "type": "main", "index": 0}]]
            },
            "Generate Embedding": {
                "main": [[{"node": "Combine with Embedding", "type": "main", "index": 0}]]
            },
            "Combine with Embedding": {
                "main": [[{"node": "Insert to Supabase", "type": "main", "index": 0}]]
            },
            "Insert to Supabase": {
                "main": [[{"node": "Rate Limit Delay", "type": "main", "index": 0}]]
            },
            "Rate Limit Delay": {
                "main": [[{"node": "Wait", "type": "main", "index": 0}]]
            },
            "Wait": {
                "main": [[{"node": "Batch Items", "type": "main", "index": 0}]]
            },
            "Batch Items": {
                "main": [
                    [{"node": "Generate Embedding", "type": "main", "index": 0}],
                    [{"node": "Aggregate Results", "type": "main", "index": 0}]
                ]
            },
            "Aggregate Results": {
                "main": [[{"node": "Return Status", "type": "main", "index": 0}]]
            }
        },
        "settings": {
            "executionOrder": "v1"
        }
    }
    
    # Create alternative workflow using Supabase node
    supabase_workflow = {
        "name": "Populate Vectors with Supabase Node",
        "nodes": [
            {
                "parameters": {
                    "filePath": "/data/agent_domain_knowledge.json"
                },
                "type": "n8n-nodes-base.readFile",
                "typeVersion": 1,
                "position": [300, 300],
                "id": "read-file",
                "name": "Read Knowledge File"
            },
            {
                "parameters": {
                    "functionCode": """// Convert file data to JSON
const fileData = $input.first().binary.data;
const jsonString = Buffer.from(fileData, 'base64').toString('utf-8');
const agentKnowledge = JSON.parse(jsonString);

// Process knowledge items
const items = [];
for (const [agentName, agentData] of Object.entries(agentKnowledge)) {
    for (const item of agentData.knowledge) {
        items.push({
            json: {
                agent_id: agentData.agent_id,
                collection: `${agentName}_vectors`,
                content: item.content,
                metadata: {
                    agent_id: agentData.agent_id,
                    domain: agentData.domain,
                    content_type: item.content_type,
                    created_at: new Date().toISOString()
                }
            }
        });
    }
}

return items;"""
                },
                "type": "n8n-nodes-base.function",
                "typeVersion": 1.1,
                "position": [500, 300],
                "id": "process-file",
                "name": "Process Knowledge"
            },
            {
                "parameters": {
                    "operation": "create",
                    "model": {
                        "__rl": True,
                        "value": "text-embedding-3-small",
                        "mode": "list"
                    },
                    "input": "={{ $json.content }}"
                },
                "type": "@n8n/n8n-nodes-langchain.openAiEmbedding",
                "typeVersion": 1,
                "position": [700, 300],
                "id": "openai-embedding",
                "name": "Generate Embeddings",
                "credentials": {
                    "openAiApi": {
                        "id": "openai-credentials",
                        "name": "OpenAI"
                    }
                }
            },
            {
                "parameters": {
                    "operation": "insert",
                    "tableName": {
                        "__rl": True,
                        "value": "agent_embeddings",
                        "mode": "list"
                    },
                    "dataMode": "autoMapInputData",
                    "options": {}
                },
                "type": "@n8n/n8n-nodes-langchain.supabase",
                "typeVersion": 1,
                "position": [900, 300],
                "id": "supabase-insert",
                "name": "Insert to Supabase",
                "credentials": {
                    "supabaseApi": {
                        "id": "supabase-credentials",
                        "name": "Supabase"
                    }
                }
            }
        ],
        "connections": {
            "Read Knowledge File": {
                "main": [[{"node": "Process Knowledge", "type": "main", "index": 0}]]
            },
            "Process Knowledge": {
                "main": [[{"node": "Generate Embeddings", "type": "main", "index": 0}]]
            },
            "Generate Embeddings": {
                "main": [[{"node": "Insert to Supabase", "type": "main", "index": 0}]]
            }
        }
    }
    
    return workflow, supabase_workflow

def main():
    """Generate n8n workflows."""
    print("Generating n8n workflows for vector population...")
    
    workflow, supabase_workflow = generate_n8n_workflow()
    
    # Save workflows
    with open("/Volumes/SeagatePortableDrive/Projects/vivid_mas/scripts/vector_population_workflow.json", 'w') as f:
        json.dump(workflow, f, indent=2)
    
    with open("/Volumes/SeagatePortableDrive/Projects/vivid_mas/scripts/vector_population_supabase_node.json", 'w') as f:
        json.dump(supabase_workflow, f, indent=2)
    
    print("✓ Generated workflows:")
    print("  - vector_population_workflow.json (using HTTP requests)")
    print("  - vector_population_supabase_node.json (using Supabase node)")
    
    print("\nTo use these workflows:")
    print("1. Upload agent_domain_knowledge.json to Supabase storage or n8n data folder")
    print("2. Import workflow JSON into n8n")
    print("3. Configure credentials:")
    print("   - OpenAI API key for embeddings")
    print("   - Supabase credentials (URL, service key)")
    print("4. Run the workflow to populate vectors")
    
    print("\nEnvironment variables needed in n8n:")
    print("  - SUPABASE_URL: http://157.230.13.13:8000")
    print("  - SUPABASE_SERVICE_KEY: eyJhbGci...")

if __name__ == "__main__":
    main()