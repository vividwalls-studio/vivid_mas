#!/usr/bin/env python3
"""
Complete workflow update for Business Manager Agent
"""

import json

# Read the new system prompt with marketing objectives
with open('business_manager_system_prompt.txt', 'r') as f:
    new_system_prompt = f.read()

# Complete workflow based on the provided JSON
workflow_update = {
    "workflowId": "RXS9ROWlTQTBLBtG",
    "name": "Business Manager Agent",
    "active": True,
    "nodes": [
        # All existing nodes from the workflow
        {
            "parameters": {
                "content": "## Linear MCP Tools - Business Manager\n**Project Management & Task Orchestration**\n\n### AI Parameter Extraction:\n- `issue_title`: \"={{ $fromAI('issue_title', 'task or issue title') }}\"\n- `issue_description`: \"={{ $fromAI('issue_description', 'detailed task description') }}\"\n- `priority`: \"={{ $fromAI('priority', 'task priority 0-4') }}\"\n- `assignee`: \"={{ $fromAI('assignee', 'team member to assign') }}\"\n- `team_id`: \"={{ $fromAI('team_id', 'target team for task') }}\"\n- `project_id`: \"={{ $fromAI('project_id', 'associated project') }}\"\n- `labels`: \"={{ $fromAI('labels', 'task labels array') }}\"\n\n### Key Tools:\n\n#### create_issue\n- **Use Case**: Create strategic tasks for department heads\n- **Invocation**: `Create task for Marketing Director to launch Q4 campaign`\n- **Expected Output**: New issue with ID, URL, and assigned team\n- **Tool Type**: `executeTool` with `toolName: create_issue`\n\n#### update_issue\n- **Use Case**: Update task status, priority, or assignments\n- **Invocation**: `Update issue ABC-123 status to in progress`\n- **Input**: Issue ID/key, status, priority, assignee changes\n- **Output**: Updated issue confirmation\n\n#### search_issues\n- **Use Case**: Find tasks by priority, assignee, or status\n- **Invocation**: `Find all high priority marketing tasks`\n- **Input**: Query string, filters (priority, status, team)\n- **Output**: Array of matching issues\n\n#### get_projects\n- **Use Case**: List all active business initiatives\n- **Invocation**: `Show all Q4 projects`\n- **Output**: Project list with status and progress\n\n#### create_project_update\n- **Use Case**: Document project milestones and blockers\n- **Invocation**: `Create weekly update for e-commerce expansion`\n- **Input**: Project ID, update content, health status\n- **Output**: Update confirmation with timestamp",
                "height": 1040,
                "width": 1340,
                "color": 7
            },
            "type": "n8n-nodes-base.stickyNote",
            "position": [8280, -260],
            "typeVersion": 1,
            "id": "1a6013a1-d1a2-4158-8d44-8e08aa9a91ea",
            "name": "Linear MCP Details"
        },
        {
            "parameters": {"inputSource": "passthrough"},
            "id": "a8f32978-3f1e-44d7-84cf-2436c172a1c0",
            "typeVersion": 1.1,
            "name": "When Executed by Another Workflow",
            "type": "n8n-nodes-base.executeWorkflowTrigger",
            "position": [4320, -2460]
        },
        {
            "parameters": {"options": {}},
            "type": "@n8n/n8n-nodes-langchain.chatTrigger",
            "typeVersion": 1.1,
            "position": [4320, -1220],
            "id": "7d156c16-463d-4611-8e56-ce5afa81eb1d",
            "name": "When chat message received"
        },
        {
            "parameters": {
                "rules": {
                    "values": [
                        {
                            "conditions": {
                                "options": {
                                    "caseSensitive": True,
                                    "leftValue": "",
                                    "typeValidation": "strict",
                                    "version": 1
                                },
                                "conditions": [
                                    {
                                        "leftValue": "",
                                        "rightValue": "",
                                        "operator": {"type": "string", "operation": "equals"},
                                        "id": "ccef36be-af1d-4fd0-bc50-992aa3c33455"
                                    }
                                ],
                                "combinator": "and"
                            }
                        }
                    ]
                },
                "options": {}
            },
            "type": "n8n-nodes-base.switch",
            "typeVersion": 3,
            "position": [4800, -1360],
            "id": "8031cdcf-09ca-4773-adcf-049cfd8b4abb",
            "name": "Route by Trigger Type"
        },
        # Director Tool nodes
        {
            "parameters": {
                "description": "Access Social Media Director for platform coordination",
                "workflowId": {
                    "__rl": True,
                    "value": "M1wo3A6fxYsnUCHq",
                    "mode": "list",
                    "cachedResultName": "Social Media Director Agent"
                },
                "workflowInputs": {
                    "mappingMode": "defineBelow",
                    "value": {
                        "task_type": "={{ $fromAI('task_type', 'campaign_coordination, performance_review, budget_allocation') }}",
                        "platforms": "={{ $fromAI('platforms', 'facebook, instagram, pinterest') }}",
                        "budget": "={{ $fromAI('budget', 'allocation details') }}",
                        "timeline": "={{ $fromAI('timeline', 'execution schedule') }}",
                        "performance_targets": "={{ $fromAI('performance_targets', 'ROAS, engagement goals') }}"
                    }
                }
            },
            "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
            "typeVersion": 2.2,
            "position": [4820, -100],
            "id": "3bc9a37d-bbcc-4e29-bbee-2666f7a8e59d",
            "name": "Social Media Director Tool"
        },
        {
            "parameters": {
                "description": "Access Analytics Director for performance insights",
                "workflowId": {
                    "__rl": True,
                    "value": "nIOJwbu7mRzNElCT",
                    "mode": "list",
                    "cachedResultName": "Analytics Director Agent"
                },
                "workflowInputs": {
                    "mappingMode": "defineBelow",
                    "value": {
                        "analysis_type": "={{ $fromAI('analysis_type', 'cross_channel, roi_analysis, customer_journey') }}",
                        "date_range": "={{ $fromAI('date_range', 'today, yesterday, last_week, custom') }}",
                        "metrics": "={{ $fromAI('metrics', 'revenue, roas, cac, ltv') }}",
                        "segments": "={{ $fromAI('segments', 'customer segments to analyze') }}"
                    }
                }
            },
            "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
            "typeVersion": 2.2,
            "position": [7240, -100],
            "id": "b2ded2f5-88cf-4334-8543-215438a1c31d",
            "name": "Analytics Director Tool"
        },
        {
            "parameters": {
                "description": "Manage customer experience initiatives",
                "workflowId": {
                    "__rl": True,
                    "value": "aHxcDdy6xwdCPPgy",
                    "mode": "list",
                    "cachedResultName": "Customer Experience Director Agent"
                },
                "workflowInputs": {
                    "mappingMode": "defineBelow",
                    "value": {
                        "action": "={{ $fromAI('action', 'sentiment_analysis, support_review, experience_optimization') }}",
                        "channel": "={{ $fromAI('channel', 'email, chat, phone, social') }}",
                        "metrics": "={{ $fromAI('metrics', 'satisfaction, nps, resolution_time') }}",
                        "issues": "={{ $fromAI('issues', 'customer pain points') }}"
                    }
                }
            },
            "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
            "typeVersion": 2.2,
            "position": [6040, -100],
            "id": "d3e382a0-8c56-4381-b937-95538e2e4fa3",
            "name": "Customer Experience Director Tool"
        },
        {
            "parameters": {
                "description": "Coordinate with Product Director for product strategy",
                "workflowId": {
                    "__rl": True,
                    "value": "quGb12qEsIrB9WLT",
                    "mode": "list",
                    "cachedResultName": "Product Director Agent"
                },
                "workflowInputs": {
                    "mappingMode": "defineBelow",
                    "value": {
                        "request": "={{ $fromAI('request', 'product_performance, new_launch, inventory_strategy') }}",
                        "products": "={{ $fromAI('products', 'product IDs or categories') }}",
                        "market_data": "={{ $fromAI('market_data', 'trends and insights') }}",
                        "timeline": "={{ $fromAI('timeline', 'launch or update schedule') }}"
                    }
                }
            },
            "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
            "typeVersion": 2.2,
            "position": [5680, -100],
            "id": "e1cff3d9-d538-402f-9d7e-0da0fb3ce1f5",
            "name": "Product Director Tool"
        },
        {
            "parameters": {
                "description": "Coordinate with Creative Director for visual assets",
                "workflowId": {
                    "__rl": True,
                    "value": "htRNfLaOSGtfnPAU",
                    "mode": "list",
                    "cachedResultName": "Creative Director Agent"
                },
                "workflowInputs": {
                    "mappingMode": "defineBelow",
                    "value": {
                        "request_type": "={{ $fromAI('request_type', 'select_images, create_campaign_visuals, brand_review') }}",
                        "topic": "={{ $fromAI('topic', 'campaign theme or product focus') }}",
                        "style": "={{ $fromAI('style', 'visual style preferences') }}",
                        "color": "={{ $fromAI('color', 'brand colors or palette') }}",
                        "theme": "={{ $fromAI('theme', 'creative theme or mood') }}",
                        "quantity": "={{ $fromAI('quantity', 'number of assets needed') }}"
                    }
                }
            },
            "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
            "typeVersion": 2.2,
            "position": [5200, -100],
            "id": "5b29c691-db1d-42a5-8f7c-b9539fd267b4",
            "name": "Creative Director Tool"
        },
        {
            "parameters": {
                "description": "Coordinate with Marketing Director for strategic alignment",
                "workflowId": {
                    "__rl": True,
                    "value": "FmyORnR3mSnCoXMq",
                    "mode": "list",
                    "cachedResultName": "Marketing Director Agent"
                },
                "workflowInputs": {
                    "mappingMode": "defineBelow",
                    "value": {
                        "task_type": "={{ $fromAI('task_type', 'the type of task for the marketing director, e.g., strategy_review, campaign_approval, performance_report') }}",
                        "objectives": "={{ $fromAI('objectives', 'the objectives for the marketing director') }}",
                        "budget": "={{ $fromAI('budget', 'the budget for the marketing director') }}",
                        "timeline": "={{ $fromAI('timeline', 'the timeline for the marketing director') }}",
                        "context": "={{ $fromAI('context', 'any additional context for the marketing director') }}"
                    }
                }
            },
            "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
            "typeVersion": 2.2,
            "position": [4420, -100],
            "id": "7c54d833-3abd-42e5-8f72-94d8d8820e49",
            "name": "Marketing Director Tool1"
        },
        {
            "parameters": {
                "description": "Manage financial operations and budgets",
                "workflowId": {
                    "__rl": True,
                    "value": "yuygwTz8dIm9FSFu",
                    "mode": "list",
                    "cachedResultName": "Finance Director Agent"
                },
                "workflowInputs": {
                    "mappingMode": "defineBelow",
                    "value": {
                        "operation": "={{ $fromAI('operation', 'budget_review, allocation, forecast, expense_report') }}",
                        "department": "={{ $fromAI('department', 'marketing, operations, technology') }}",
                        "amount": "={{ $fromAI('amount', 'budget amount') }}",
                        "period": "={{ $fromAI('period', 'daily, weekly, monthly, quarterly') }}"
                    }
                }
            },
            "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
            "typeVersion": 2.2,
            "position": [6880, -100],
            "id": "8afdc302-e326-4dd0-92e3-d20bc50dd301",
            "name": "Finance Director Tool1"
        },
        {
            "parameters": {
                "description": "Coordinate operations and fulfillment",
                "workflowId": {
                    "__rl": True,
                    "value": "R8x8qOARDh0Ax6RK",
                    "mode": "list",
                    "cachedResultName": "Operations Director Agent"
                },
                "workflowInputs": {
                    "mappingMode": "defineBelow",
                    "value": {
                        "task": "={{ $fromAI('task', 'inventory_check, fulfillment_status, logistics_update') }}",
                        "priority": "={{ $fromAI('priority', 'urgent, high, normal, low') }}",
                        "products": "={{ $fromAI('products', 'product IDs or categories') }}",
                        "requirements": "={{ $fromAI('requirements', 'specific operational needs') }}"
                    }
                }
            },
            "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
            "typeVersion": 2.2,
            "position": [7960, -100],
            "id": "aa467c5b-0272-450d-beba-098eda96a1c2",
            "name": "Operations Director Tool1"
        },
        {
            "parameters": {
                "description": "Access Technology Director for system management",
                "workflowId": {
                    "__rl": True,
                    "value": "RhuS0opWbJ31EmN2",
                    "mode": "list",
                    "cachedResultName": "Technology Director Agent"
                },
                "workflowInputs": {
                    "mappingMode": "defineBelow",
                    "value": {
                        "request_type": "={{ $fromAI('request_type', 'system_status, integration_check, automation_setup') }}",
                        "systems": "={{ $fromAI('systems', 'shopify, n8n, mcp_servers') }}",
                        "priority": "={{ $fromAI('priority', 'critical, high, normal') }}",
                        "technical_details": "={{ $fromAI('technical_details', 'specific requirements') }}"
                    }
                }
            },
            "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
            "typeVersion": 2.2,
            "position": [7600, -100],
            "id": "94fb6cf0-3f52-426f-8c6d-6f366caa87d3",
            "name": "Technology Director Tool1"
        },
        {
            "parameters": {
                "workflowId": {
                    "__rl": True,
                    "value": "6DbMolJ2fTLRQdft",
                    "mode": "list",
                    "cachedResultName": "Sales Agent"
                },
                "workflowInputs": {
                    "mappingMode": "defineBelow",
                    "value": {},
                    "matchingColumns": [],
                    "schema": [],
                    "attemptToConvertTypes": False,
                    "convertFieldsToString": False
                }
            },
            "type": "@n8n/n8n-nodes-langchain.toolWorkflow",
            "typeVersion": 2.2,
            "position": [6420, -100],
            "id": "8abe3bc4-06ae-414d-9ed3-077cec5331e4",
            "name": "Sales Director Agent"
        },
        # Sticky Notes for documentation (keeping first few as example)
        {
            "parameters": {
                "content": "## Memory Systems\n\n### Supabase Chat Memory\n- Session-based conversation tracking\n- Contextual awareness across interactions\n- Agent learning and adaptation\n\n### Supabase Integration\n- Vector embeddings for semantic search\n- Historical decision tracking\n- Performance pattern recognition\n\nBoth memory systems work together to provide the Business Manager Agent with comprehensive context for decision-making.",
                "height": 680,
                "width": 420
            },
            "type": "n8n-nodes-base.stickyNote",
            "typeVersion": 1,
            "position": [2180, -200],
            "id": "076a3f3c-39f2-4520-9c82-f8501ef1bec4",
            "name": "Sticky Note11"
        },
        # Models and Memory
        {
            "parameters": {
                "model": {
                    "__rl": True,
                    "mode": "list",
                    "value": "gpt-4o"
                },
                "options": {"temperature": 0.7}
            },
            "type": "@n8n/n8n-nodes-langchain.lmChatOpenAi",
            "typeVersion": 1.2,
            "position": [1800, -80],
            "id": "9490bfce-1f76-4d7e-bba8-21901d2fc199",
            "name": "OpenAI Chat Model1",
            "credentials": {
                "openAiApi": {
                    "id": "nMbluFwHsrVvkQBJ",
                    "name": "OpenAi account"
                }
            }
        },
        {
            "parameters": {"tableName": "agent_chat_memory"},
            "type": "@n8n/n8n-nodes-langchain.memoryPostgresChat",
            "typeVersion": 1.3,
            "position": [2740, -100],
            "id": "18ea30a6-ed5b-4825-aacd-87a751b73c5d",
            "name": "Agent Memory",
            "credentials": {
                "postgres": {
                    "id": "c76ccdf5-568d-4ef2-a0c2-00c7423d775f",
                    "name": "Supabase DB"
                }
            }
        },
        {
            "parameters": {"options": {}},
            "type": "@n8n/n8n-nodes-langchain.lmChatOllama",
            "typeVersion": 1,
            "position": [1800, 280],
            "id": "8ae43f9c-8e4a-4f62-be6d-b0cc881ee501",
            "name": "Local Ollama Model",
            "credentials": {
                "ollamaApi": {
                    "id": "gMmdSJ7Ie4jj3U8D",
                    "name": "Ollama account"
                }
            }
        },
        # Triggers
        {
            "parameters": {
                "rule": {
                    "interval": [
                        {"triggerAtHour": 8},
                        {"triggerAtHour": 13},
                        {"triggerAtHour": 17}
                    ]
                }
            },
            "type": "n8n-nodes-base.scheduleTrigger",
            "typeVersion": 1.2,
            "position": [4320, -920],
            "id": "ff91b0f4-5b69-43e0-b9f5-671d5e19b387",
            "name": "Schedule Trigger - Morning Review"
        },
        {
            "parameters": {
                "updates": ["message"],
                "additionalFields": {}
            },
            "type": "n8n-nodes-base.telegramTrigger",
            "typeVersion": 1.2,
            "position": [4320, -1460],
            "id": "3174d903-a5c3-4675-bca7-005cd1146723",
            "name": "Telegram Trigger",
            "credentials": {
                "telegramApi": {
                    "id": "telegram_bot",
                    "name": "Telegram Bot"
                }
            }
        },
        {
            "parameters": {
                "path": "business-manager-webhook",
                "responseMode": "responseNode",
                "options": {"allowedOrigins": "*"}
            },
            "type": "n8n-nodes-base.webhook",
            "typeVersion": 2,
            "position": [4320, -1960],
            "id": "06141aaf-a265-4d86-9372-cff364071a33",
            "name": "Business Manager Webhook1"
        },
        # Communication nodes
        {
            "parameters": {
                "chatId": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Chat_ID', ``, 'string') }}",
                "text": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Text', ``, 'string') }}",
                "additionalFields": {}
            },
            "type": "n8n-nodes-base.telegramTool",
            "typeVersion": 1.2,
            "position": [3960, -100],
            "id": "6f530127-7609-46d4-8807-6bce6887bbd4",
            "name": "Telegram",
            "credentials": {
                "telegramApi": {
                    "id": "telegram_bot",
                    "name": "Telegram Bot"
                }
            }
        },
        {
            "parameters": {
                "chatId": "=",
                "text": "={{ $fromAI('approval') }}",
                "additionalFields": {}
            },
            "type": "n8n-nodes-base.telegram",
            "typeVersion": 1.2,
            "position": [7820, -1600],
            "id": "27bdaa79-392f-4a10-9250-2ee867208339",
            "name": "Telegram1",
            "credentials": {
                "telegramApi": {
                    "id": "telegram_bot",
                    "name": "Telegram Bot"
                }
            }
        },
        # Logic nodes
        {
            "parameters": {
                "conditions": {
                    "options": {
                        "caseSensitive": True,
                        "leftValue": "",
                        "typeValidation": "strict",
                        "version": 2
                    },
                    "conditions": [
                        {
                            "id": "36e8486d-c497-421f-8a55-a1bfe9efff9f",
                            "leftValue": True,
                            "rightValue": "",
                            "operator": {
                                "type": "boolean",
                                "operation": "true",
                                "singleValue": True
                            }
                        },
                        {
                            "id": "f28ed8b7-0d3a-453c-b13d-e6f80581e8ee",
                            "leftValue": False,
                            "rightValue": "",
                            "operator": {
                                "type": "boolean",
                                "operation": "false",
                                "singleValue": True
                            }
                        }
                    ],
                    "combinator": "or"
                },
                "options": {}
            },
            "type": "n8n-nodes-base.if",
            "typeVersion": 2.2,
            "position": [6980, -1380],
            "id": "7b31999c-6216-49d0-ad41-78086e2fc2a0",
            "name": "Is Approval Required"
        },
        {
            "parameters": {"options": {}},
            "type": "n8n-nodes-base.respondToWebhook",
            "typeVersion": 1.4,
            "position": [7820, -720],
            "id": "47152d5d-049e-495a-a107-a2b3cdb77980",
            "name": "Respond to Webhook1"
        },
        # THE MAIN BUSINESS MANAGER AGENT NODE - WITH UPDATED SYSTEM PROMPT
        {
            "parameters": {
                "promptType": "define",
                "text": "={{$input }}",
                "options": {
                    "systemMessage": new_system_prompt
                }
            },
            "type": "@n8n/n8n-nodes-langchain.agent",
            "typeVersion": 2,
            "position": [5740, -1380],
            "id": "3e4955a3-4b0a-4ef5-a853-425d3bae3629",
            "name": "Business Manager Agent"
        },
        # NEW MCP NODES
        {
            "parameters": {
                "operation": "executeTool",
                "toolName": "get_prompt",
                "toolParameters": "={{ {\n  \"prompt_name\": $fromAI(\"prompt_name\", \"business-manager-system, strategic-planning, director-coordination, performance-monitoring, resource-allocation, executive-reporting, crisis-management, dynamic-rules-engine\")\n} }}"
            },
            "type": "n8n-nodes-mcp.mcpClientTool",
            "typeVersion": 1,
            "position": [5940, -1200],
            "id": "bm-prompts-mcp-001",
            "name": "Business Manager Prompts MCP",
            "credentials": {
                "mcpClientApi": {
                    "id": "1sL2egXbdslY8cew",
                    "name": "WordPress MCP Client (STDIO) account"
                }
            }
        },
        {
            "parameters": {
                "operation": "executeTool",
                "toolName": "get_resource",
                "toolParameters": "={{ {\n  \"resource_uri\": $fromAI(\"resource_uri\", \"business-manager://strategy/okr-framework, business-manager://kpis/executive-dashboard, business-manager://frameworks/delegation-matrix, business-manager://crisis/incident-response, business-manager://planning/strategic-planning-framework, business-manager://performance/balanced-scorecard\")\n} }}"
            },
            "type": "n8n-nodes-mcp.mcpClientTool",
            "typeVersion": 1,
            "position": [6140, -1200],
            "id": "bm-resources-mcp-001",
            "name": "Business Manager Resources MCP",
            "credentials": {
                "mcpClientApi": {
                    "id": "1sL2egXbdslY8cew",
                    "name": "WordPress MCP Client (STDIO) account"
                }
            }
        }
    ],
    "connections": {
        "When Executed by Another Workflow": {
            "main": [[{"node": "Route by Trigger Type", "type": "main", "index": 0}]]
        },
        "When chat message received": {
            "main": [[{"node": "Route by Trigger Type", "type": "main", "index": 0}]]
        },
        "Route by Trigger Type": {
            "main": [[{"node": "Business Manager Agent", "type": "main", "index": 0}]]
        },
        "Social Media Director Tool": {
            "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
        },
        "Analytics Director Tool": {
            "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
        },
        "Customer Experience Director Tool": {
            "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
        },
        "Product Director Tool": {
            "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
        },
        "Creative Director Tool": {
            "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
        },
        "OpenAI Chat Model1": {
            "ai_languageModel": [[{"node": "Business Manager Agent", "type": "ai_languageModel", "index": 0}]]
        },
        "Agent Memory": {
            "ai_memory": [[]]
        },
        "Schedule Trigger - Morning Review": {
            "main": [[{"node": "Business Manager Agent", "type": "main", "index": 0}]]
        },
        "Sales Director Agent": {
            "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
        },
        "Telegram": {
            "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
        },
        "Is Approval Required": {
            "main": [
                [{"node": "Telegram1", "type": "main", "index": 0}],
                [{"node": "Respond to Webhook1", "type": "main", "index": 0}]
            ]
        },
        "Business Manager Webhook1": {
            "main": [[{"node": "Route by Trigger Type", "type": "main", "index": 0}]]
        },
        "Marketing Director Tool1": {
            "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
        },
        "Finance Director Tool1": {
            "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
        },
        "Operations Director Tool1": {
            "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
        },
        "Technology Director Tool1": {
            "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
        },
        "Business Manager Agent": {
            "main": [[{"node": "Is Approval Required", "type": "main", "index": 0}]]
        },
        "Telegram Trigger": {
            "main": [[{"node": "Route by Trigger Type", "type": "main", "index": 0}]]
        },
        # NEW CONNECTIONS FOR MCP NODES
        "Business Manager Prompts MCP": {
            "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
        },
        "Business Manager Resources MCP": {
            "ai_tool": [[{"node": "Business Manager Agent", "type": "ai_tool", "index": 0}]]
        }
    },
    "tags": ["Orchestrator", "Agent", "Multi-Agent System", "VividWalls"]
}

# Save complete workflow
with open('complete_workflow_update.json', 'w') as f:
    json.dump(workflow_update, f, indent=2)

print("✅ Created complete workflow update")
print("📁 Output: complete_workflow_update.json")
print(f"📊 Total nodes: {len(workflow_update['nodes'])}")
print(f"📊 Updated Business Manager Agent system prompt")
print(f"📊 Added Business Manager Prompts MCP node")
print(f"📊 Added Business Manager Resources MCP node")