-- Marketing Agents Workflow Updates for n8n PostgreSQL Database
-- Execute these SQL statements on the droplet to add the three marketing agent workflows

-- First, check if workflows already exist and delete if necessary
DELETE FROM workflow_entity WHERE id IN ('campaign-manager-001', 'copy-writer-001', 'copy-editor-001');

-- Insert Campaign Manager Agent workflow
INSERT INTO workflow_entity (
    id, 
    name, 
    active, 
    nodes, 
    connections, 
    settings, 
    "staticData", 
    "triggerCount", 
    "createdAt", 
    "updatedAt", 
    "versionId",
    tags,
    "pinData"
) VALUES (
    'campaign-manager-001',
    'Campaign Manager Agent',
    true,
    '[
        {
            "parameters": {
                "workflowInputs": {
                    "values": [
                        {"name": "campaign_type"},
                        {"name": "target_audience"},
                        {"name": "budget_allocation"},
                        {"name": "campaign_goals"},
                        {"name": "timeline"}
                    ]
                }
            },
            "id": "e26fc4f1-3321-41d1-a25a-206a961a4fd6",
            "typeVersion": 1.1,
            "name": "When Executed by Another Workflow",
            "type": "n8n-nodes-base.executeWorkflowTrigger",
            "position": [1456, 704]
        },
        {
            "parameters": {
                "model": {
                    "__rl": true,
                    "mode": "list",
                    "value": "gpt-4o"
                },
                "options": {"temperature": 0.7}
            },
            "type": "@n8n/n8n-nodes-langchain.lmChatOpenAi",
            "typeVersion": 1.2,
            "position": [1104, 1376],
            "id": "0c8cfde8-104c-4a86-8963-aff0cdbaf74a",
            "name": "OpenAI Chat Model",
            "credentials": {
                "openAiApi": {
                    "id": "ktM70nRxsXMA9jQA",
                    "name": "OpenAi account"
                }
            }
        },
        {
            "parameters": {"options": {}},
            "type": "@n8n/n8n-nodes-langchain.chatTrigger",
            "typeVersion": 1.1,
            "position": [1472, 160],
            "id": "37fe44af-7fad-45fe-86da-1ac026d1ac2a",
            "name": "When chat message received",
            "webhookId": "campaign-manager-chat"
        },
        {
            "parameters": {"options": {}},
            "type": "n8n-nodes-base.respondToWebhook",
            "typeVersion": 1.2,
            "position": [3344, 912],
            "id": "9738b7d3-9966-46d5-8982-d2e88ee51f88",
            "name": "Respond to Webhook"
        },
        {
            "parameters": {
                "sessionKey": "={{ $json.chatId || $json.session_id || ''campaign_manager_'' + $now.toMillis() }}"
            },
            "type": "@n8n/n8n-nodes-langchain.memoryPostgresChat",
            "typeVersion": 1.3,
            "position": [1264, 1376],
            "id": "3df5d820-ccc8-45ba-98ab-ccbb2dbae33e",
            "name": "Postgres Chat Memory",
            "credentials": {
                "postgres": {
                    "id": "A84NDuNHTbqn50Xe",
                    "name": "Postgres account"
                }
            }
        },
        {
            "parameters": {
                "path": "campaign-manager-webhook",
                "responseMode": "responseNode",
                "options": {"allowedOrigins": "*"}
            },
            "id": "b75910f1-3399-40c2-819c-6e0e78954f0f",
            "name": "Campaign Manager Webhook",
            "type": "n8n-nodes-base.webhook",
            "typeVersion": 2,
            "position": [1456, 464],
            "webhookId": "campaign-manager-webhook"
        },
        {
            "parameters": {
                "promptType": "define",
                "text": "Follow your instructions",
                "options": {
                    "systemMessage": "# Campaign Manager Agent System Prompt\\n\\n## Role & Purpose\\n\\nYou are the Campaign Manager Agent, a specialized marketing coordinator in the VividWalls Multi-Agent System. You orchestrate comprehensive marketing campaigns across all channels, ensuring optimal budget allocation, timing, and creative execution."
                }
            },
            "type": "@n8n/n8n-nodes-langchain.agent",
            "typeVersion": 1.9,
            "position": [2432, 912],
            "id": "62a8d8ef-f1a4-4538-a8fb-90f15a60bda2",
            "name": "Campaign Manager Agent"
        },
        {
            "parameters": {
                "endpointUrl": "http://vividwalls-marketing-campaign-prompts:8140/stream",
                "serverTransport": "httpStreamable"
            },
            "type": "@n8n/n8n-nodes-langchain.mcpClientTool",
            "typeVersion": 1.1,
            "position": [1456, 1376],
            "id": "5b7df5f3-dcd6-4b77-b36f-afee02997e3d",
            "name": "Marketing Campaign Prompts MCP"
        },
        {
            "parameters": {
                "endpointUrl": "http://vividwalls-marketing-campaign-resource:8141/stream",
                "serverTransport": "httpStreamable"
            },
            "type": "@n8n/n8n-nodes-langchain.mcpClientTool",
            "typeVersion": 1.1,
            "position": [1656, 1376],
            "id": "4899ecb5-f6cb-4135-8f5e-3ba14ac1a4d1",
            "name": "Marketing Campaign Resource MCP"
        },
        {
            "parameters": {
                "endpointUrl": "http://vividwalls-shopify:8000/stream",
                "serverTransport": "httpStreamable"
            },
            "type": "@n8n/n8n-nodes-langchain.mcpClientTool",
            "typeVersion": 1.1,
            "position": [1856, 1376],
            "id": "15b7a4b1-bd91-4c14-a29c-791dcb8a38b4",
            "name": "Shopify MCP"
        },
        {
            "parameters": {
                "endpointUrl": "http://vividwalls-linear:8020/stream",
                "serverTransport": "httpStreamable"
            },
            "type": "@n8n/n8n-nodes-langchain.mcpClientTool",
            "typeVersion": 1.1,
            "position": [2056, 1376],
            "id": "1d80bf54-841d-4ce9-9ed3-2d9c608f8bf0",
            "name": "Linear MCP"
        }
    ]'::jsonb,
    '{
        "When Executed by Another Workflow": {
            "main": [[{"node": "Campaign Manager Agent", "type": "main", "index": 0}]]
        },
        "OpenAI Chat Model": {
            "ai_languageModel": [[{"node": "Campaign Manager Agent", "type": "ai_languageModel", "index": 0}]]
        },
        "When chat message received": {
            "main": [[{"node": "Campaign Manager Agent", "type": "main", "index": 0}]]
        },
        "Postgres Chat Memory": {
            "ai_memory": [[{"node": "Campaign Manager Agent", "type": "ai_memory", "index": 0}]]
        },
        "Campaign Manager Webhook": {
            "main": [[{"node": "Campaign Manager Agent", "type": "main", "index": 0}]]
        },
        "Campaign Manager Agent": {
            "main": [[{"node": "Respond to Webhook", "type": "main", "index": 0}]]
        },
        "Marketing Campaign Prompts MCP": {
            "ai_tool": [[{"node": "Campaign Manager Agent", "type": "ai_tool", "index": 0}]]
        },
        "Marketing Campaign Resource MCP": {
            "ai_tool": [[{"node": "Campaign Manager Agent", "type": "ai_tool", "index": 0}]]
        },
        "Shopify MCP": {
            "ai_tool": [[{"node": "Campaign Manager Agent", "type": "ai_tool", "index": 0}]]
        },
        "Linear MCP": {
            "ai_tool": [[{"node": "Campaign Manager Agent", "type": "ai_tool", "index": 0}]]
        }
    }'::jsonb,
    '{"executionOrder": "v1"}'::jsonb,
    null,
    0,
    NOW(),
    NOW(),
    'campaign-manager-v1',
    '[{"id": "marketing-agent", "name": "marketing"}, {"id": "campaign-management", "name": "campaign"}]'::jsonb,
    '{}'::jsonb
);

-- Insert Copy Writer Agent workflow
INSERT INTO workflow_entity (
    id, 
    name, 
    active, 
    nodes, 
    connections, 
    settings, 
    "staticData", 
    "triggerCount", 
    "createdAt", 
    "updatedAt", 
    "versionId",
    tags,
    "pinData"
) VALUES (
    'copy-writer-001',
    'Copy Writer Agent',
    true,
    '[
        {
            "parameters": {
                "workflowInputs": {
                    "values": [
                        {"name": "content_type"},
                        {"name": "target_audience"},
                        {"name": "brand_voice"},
                        {"name": "call_to_action"},
                        {"name": "platform_requirements"}
                    ]
                }
            },
            "id": "f26fc4f1-3321-41d1-a25a-206a961a4fd7",
            "typeVersion": 1.1,
            "name": "When Executed by Another Workflow",
            "type": "n8n-nodes-base.executeWorkflowTrigger",
            "position": [1456, 704]
        },
        {
            "parameters": {
                "model": {
                    "__rl": true,
                    "mode": "list",
                    "value": "gpt-4o"
                },
                "options": {"temperature": 0.8}
            },
            "type": "@n8n/n8n-nodes-langchain.lmChatOpenAi",
            "typeVersion": 1.2,
            "position": [1104, 1376],
            "id": "1c8cfde8-104c-4a86-8963-aff0cdbaf74b",
            "name": "OpenAI Chat Model",
            "credentials": {
                "openAiApi": {
                    "id": "ktM70nRxsXMA9jQA",
                    "name": "OpenAi account"
                }
            }
        },
        {
            "parameters": {"options": {}},
            "type": "@n8n/n8n-nodes-langchain.chatTrigger",
            "typeVersion": 1.1,
            "position": [1472, 160],
            "id": "38fe44af-7fad-45fe-86da-1ac026d1ac2b",
            "name": "When chat message received",
            "webhookId": "copy-writer-chat"
        },
        {
            "parameters": {"options": {}},
            "type": "n8n-nodes-base.respondToWebhook",
            "typeVersion": 1.2,
            "position": [3344, 912],
            "id": "9738b7d3-9966-46d5-8982-d2e88ee51f89",
            "name": "Respond to Webhook"
        },
        {
            "parameters": {
                "sessionKey": "={{ $json.chatId || $json.session_id || ''copy_writer_'' + $now.toMillis() }}"
            },
            "type": "@n8n/n8n-nodes-langchain.memoryPostgresChat",
            "typeVersion": 1.3,
            "position": [1264, 1376],
            "id": "4df5d820-ccc8-45ba-98ab-ccbb2dbae33f",
            "name": "Postgres Chat Memory",
            "credentials": {
                "postgres": {
                    "id": "A84NDuNHTbqn50Xe",
                    "name": "Postgres account"
                }
            }
        },
        {
            "parameters": {
                "path": "copy-writer-webhook",
                "responseMode": "responseNode",
                "options": {"allowedOrigins": "*"}
            },
            "id": "c75910f1-3399-40c2-819c-6e0e78954f10",
            "name": "Copy Writer Webhook",
            "type": "n8n-nodes-base.webhook",
            "typeVersion": 2,
            "position": [1456, 464],
            "webhookId": "copy-writer-webhook"
        },
        {
            "parameters": {
                "promptType": "define",
                "text": "Follow your instructions",
                "options": {
                    "systemMessage": "# Copy Writer Agent System Prompt\\n\\n## Role & Purpose\\n\\nYou are the Copy Writer Agent, a specialized content creation expert in the VividWalls Multi-Agent System. You craft compelling, conversion-focused copy across all marketing channels while maintaining brand voice consistency and platform-specific optimization."
                }
            },
            "type": "@n8n/n8n-nodes-langchain.agent",
            "typeVersion": 1.9,
            "position": [2432, 912],
            "id": "63a8d8ef-f1a4-4538-a8fb-90f15a60bda3",
            "name": "Copy Writer Agent"
        },
        {
            "parameters": {
                "endpointUrl": "http://vividwalls-copy-writer-prompts:8142/stream",
                "serverTransport": "httpStreamable"
            },
            "type": "@n8n/n8n-nodes-langchain.mcpClientTool",
            "typeVersion": 1.1,
            "position": [1456, 1376],
            "id": "6b7df5f3-dcd6-4b77-b36f-afee02997e3e",
            "name": "Copy Writer Prompts MCP"
        },
        {
            "parameters": {
                "endpointUrl": "http://vividwalls-copy-writer-resource:8143/stream",
                "serverTransport": "httpStreamable"
            },
            "type": "@n8n/n8n-nodes-langchain.mcpClientTool",
            "typeVersion": 1.1,
            "position": [1656, 1376],
            "id": "5899ecb5-f6cb-4135-8f5e-3ba14ac1a4d2",
            "name": "Copy Writer Resource MCP"
        },
        {
            "parameters": {
                "endpointUrl": "http://vividwalls-shopify:8000/stream",
                "serverTransport": "httpStreamable"
            },
            "type": "@n8n/n8n-nodes-langchain.mcpClientTool",
            "typeVersion": 1.1,
            "position": [1856, 1376],
            "id": "16b7a4b1-bd91-4c14-a29c-791dcb8a38b5",
            "name": "Shopify MCP"
        },
        {
            "parameters": {
                "endpointUrl": "http://vividwalls-sendgrid:8030/stream",
                "serverTransport": "httpStreamable"
            },
            "type": "@n8n/n8n-nodes-langchain.mcpClientTool",
            "typeVersion": 1.1,
            "position": [2056, 1376],
            "id": "2d80bf54-841d-4ce9-9ed3-2d9c608f8bf1",
            "name": "SendGrid MCP"
        }
    ]'::jsonb,
    '{
        "When Executed by Another Workflow": {
            "main": [[{"node": "Copy Writer Agent", "type": "main", "index": 0}]]
        },
        "OpenAI Chat Model": {
            "ai_languageModel": [[{"node": "Copy Writer Agent", "type": "ai_languageModel", "index": 0}]]
        },
        "When chat message received": {
            "main": [[{"node": "Copy Writer Agent", "type": "main", "index": 0}]]
        },
        "Postgres Chat Memory": {
            "ai_memory": [[{"node": "Copy Writer Agent", "type": "ai_memory", "index": 0}]]
        },
        "Copy Writer Webhook": {
            "main": [[{"node": "Copy Writer Agent", "type": "main", "index": 0}]]
        },
        "Copy Writer Agent": {
            "main": [[{"node": "Respond to Webhook", "type": "main", "index": 0}]]
        },
        "Copy Writer Prompts MCP": {
            "ai_tool": [[{"node": "Copy Writer Agent", "type": "ai_tool", "index": 0}]]
        },
        "Copy Writer Resource MCP": {
            "ai_tool": [[{"node": "Copy Writer Agent", "type": "ai_tool", "index": 0}]]
        },
        "Shopify MCP": {
            "ai_tool": [[{"node": "Copy Writer Agent", "type": "ai_tool", "index": 0}]]
        },
        "SendGrid MCP": {
            "ai_tool": [[{"node": "Copy Writer Agent", "type": "ai_tool", "index": 0}]]
        }
    }'::jsonb,
    '{"executionOrder": "v1"}'::jsonb,
    null,
    0,
    NOW(),
    NOW(),
    'copy-writer-v1',
    '[{"id": "marketing-agent", "name": "marketing"}, {"id": "content-creation", "name": "copy"}]'::jsonb,
    '{}'::jsonb
);

-- Insert Copy Editor Agent workflow
INSERT INTO workflow_entity (
    id, 
    name, 
    active, 
    nodes, 
    connections, 
    settings, 
    "staticData", 
    "triggerCount", 
    "createdAt", 
    "updatedAt", 
    "versionId",
    tags,
    "pinData"
) VALUES (
    'copy-editor-001',
    'Copy Editor Agent',
    true,
    '[
        {
            "parameters": {
                "workflowInputs": {
                    "values": [
                        {"name": "content_to_edit"},
                        {"name": "content_type"},
                        {"name": "target_platform"},
                        {"name": "brand_guidelines"},
                        {"name": "editing_priority"}
                    ]
                }
            },
            "id": "g26fc4f1-3321-41d1-a25a-206a961a4fd8",
            "typeVersion": 1.1,
            "name": "When Executed by Another Workflow",
            "type": "n8n-nodes-base.executeWorkflowTrigger",
            "position": [1456, 704]
        },
        {
            "parameters": {
                "model": {
                    "__rl": true,
                    "mode": "list",
                    "value": "gpt-4o"
                },
                "options": {"temperature": 0.3}
            },
            "type": "@n8n/n8n-nodes-langchain.lmChatOpenAi",
            "typeVersion": 1.2,
            "position": [1104, 1376],
            "id": "2c8cfde8-104c-4a86-8963-aff0cdbaf74c",
            "name": "OpenAI Chat Model",
            "credentials": {
                "openAiApi": {
                    "id": "ktM70nRxsXMA9jQA",
                    "name": "OpenAi account"
                }
            }
        },
        {
            "parameters": {"options": {}},
            "type": "@n8n/n8n-nodes-langchain.chatTrigger",
            "typeVersion": 1.1,
            "position": [1472, 160],
            "id": "39fe44af-7fad-45fe-86da-1ac026d1ac2c",
            "name": "When chat message received",
            "webhookId": "copy-editor-chat"
        },
        {
            "parameters": {"options": {}},
            "type": "n8n-nodes-base.respondToWebhook",
            "typeVersion": 1.2,
            "position": [3344, 912],
            "id": "9738b7d3-9966-46d5-8982-d2e88ee51f8a",
            "name": "Respond to Webhook"
        },
        {
            "parameters": {
                "sessionKey": "={{ $json.chatId || $json.session_id || ''copy_editor_'' + $now.toMillis() }}"
            },
            "type": "@n8n/n8n-nodes-langchain.memoryPostgresChat",
            "typeVersion": 1.3,
            "position": [1264, 1376],
            "id": "5df5d820-ccc8-45ba-98ab-ccbb2dbae340",
            "name": "Postgres Chat Memory",
            "credentials": {
                "postgres": {
                    "id": "A84NDuNHTbqn50Xe",
                    "name": "Postgres account"
                }
            }
        },
        {
            "parameters": {
                "path": "copy-editor-webhook",
                "responseMode": "responseNode",
                "options": {"allowedOrigins": "*"}
            },
            "id": "d75910f1-3399-40c2-819c-6e0e78954f11",
            "name": "Copy Editor Webhook",
            "type": "n8n-nodes-base.webhook",
            "typeVersion": 2,
            "position": [1456, 464],
            "webhookId": "copy-editor-webhook"
        },
        {
            "parameters": {
                "promptType": "define",
                "text": "Follow your instructions",
                "options": {
                    "systemMessage": "# Copy Editor Agent System Prompt\\n\\n## Role & Purpose\\n\\nYou are the Copy Editor Agent, a specialized content quality assurance expert in the VividWalls Multi-Agent System. You ensure all marketing copy meets the highest standards of clarity, consistency, and conversion optimization while maintaining brand voice integrity across all platforms."
                }
            },
            "type": "@n8n/n8n-nodes-langchain.agent",
            "typeVersion": 1.9,
            "position": [2432, 912],
            "id": "64a8d8ef-f1a4-4538-a8fb-90f15a60bda4",
            "name": "Copy Editor Agent"
        },
        {
            "parameters": {
                "endpointUrl": "http://vividwalls-copy-editor-prompts:8144/stream",
                "serverTransport": "httpStreamable"
            },
            "type": "@n8n/n8n-nodes-langchain.mcpClientTool",
            "typeVersion": 1.1,
            "position": [1456, 1376],
            "id": "7b7df5f3-dcd6-4b77-b36f-afee02997e3f",
            "name": "Copy Editor Prompts MCP"
        },
        {
            "parameters": {
                "endpointUrl": "http://vividwalls-copy-editor-resource:8145/stream",
                "serverTransport": "httpStreamable"
            },
            "type": "@n8n/n8n-nodes-langchain.mcpClientTool",
            "typeVersion": 1.1,
            "position": [1656, 1376],
            "id": "6899ecb5-f6cb-4135-8f5e-3ba14ac1a4d3",
            "name": "Copy Editor Resource MCP"
        },
        {
            "parameters": {
                "endpointUrl": "http://vividwalls-shopify:8000/stream",
                "serverTransport": "httpStreamable"
            },
            "type": "@n8n/n8n-nodes-langchain.mcpClientTool",
            "typeVersion": 1.1,
            "position": [1856, 1376],
            "id": "17b7a4b1-bd91-4c14-a29c-791dcb8a38b6",
            "name": "Shopify MCP"
        },
        {
            "parameters": {
                "endpointUrl": "http://vividwalls-sendgrid:8030/stream",
                "serverTransport": "httpStreamable"
            },
            "type": "@n8n/n8n-nodes-langchain.mcpClientTool",
            "typeVersion": 1.1,
            "position": [2056, 1376],
            "id": "3d80bf54-841d-4ce9-9ed3-2d9c608f8bf2",
            "name": "SendGrid MCP"
        }
    ]'::jsonb,
    '{
        "When Executed by Another Workflow": {
            "main": [[{"node": "Copy Editor Agent", "type": "main", "index": 0}]]
        },
        "OpenAI Chat Model": {
            "ai_languageModel": [[{"node": "Copy Editor Agent", "type": "ai_languageModel", "index": 0}]]
        },
        "When chat message received": {
            "main": [[{"node": "Copy Editor Agent", "type": "main", "index": 0}]]
        },
        "Postgres Chat Memory": {
            "ai_memory": [[{"node": "Copy Editor Agent", "type": "ai_memory", "index": 0}]]
        },
        "Copy Editor Webhook": {
            "main": [[{"node": "Copy Editor Agent", "type": "main", "index": 0}]]
        },
        "Copy Editor Agent": {
            "main": [[{"node": "Respond to Webhook", "type": "main", "index": 0}]]
        },
        "Copy Editor Prompts MCP": {
            "ai_tool": [[{"node": "Copy Editor Agent", "type": "ai_tool", "index": 0}]]
        },
        "Copy Editor Resource MCP": {
            "ai_tool": [[{"node": "Copy Editor Agent", "type": "ai_tool", "index": 0}]]
        },
        "Shopify MCP": {
            "ai_tool": [[{"node": "Copy Editor Agent", "type": "ai_tool", "index": 0}]]
        },
        "SendGrid MCP": {
            "ai_tool": [[{"node": "Copy Editor Agent", "type": "ai_tool", "index": 0}]]
        }
    }'::jsonb,
    '{"executionOrder": "v1"}'::jsonb,
    null,
    0,
    NOW(),
    NOW(),
    'copy-editor-v1',
    '[{"id": "marketing-agent", "name": "marketing"}, {"id": "content-editing", "name": "editing"}]'::jsonb,
    '{}'::jsonb
);

-- Verify the insertions
SELECT id, name, active, "createdAt" FROM workflow_entity 
WHERE id IN ('campaign-manager-001', 'copy-writer-001', 'copy-editor-001');

-- Display workflow count for verification
SELECT COUNT(*) as total_workflows FROM workflow_entity;