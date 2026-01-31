-- SQL UPDATE statements for Email Marketing and Newsletter Agents
-- These commands will insert the complete workflow JSON structures into the PostgreSQL database

-- 1. Email Marketing Agent workflow update
UPDATE workflow_entity 
SET 
    workflow = '{
  "name": "VividWalls-EmailMarketing-Agent-Complete",
  "nodes": [
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "email-marketing-webhook",
        "responseMode": "responseNode",
        "options": {}
      },
      "id": "1001",
      "name": "Email Marketing Webhook",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1.1,
      "position": [200, 300],
      "webhookId": "email-marketing-webhook"
    },
    {
      "parameters": {
        "httpMethod": "POST", 
        "path": "email-marketing-chat",
        "responseMode": "responseNode",
        "options": {}
      },
      "id": "1002",
      "name": "Email Marketing Chat",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1.1,
      "position": [200, 500],
      "webhookId": "email-marketing-chat"
    },
    {
      "parameters": {
        "server": "sendgrid-mcp-server",
        "operation": "sendEmail",
        "fields": {
          "to": "={{ $json.body.recipient || $json.body.to }}",
          "subject": "={{ $json.body.subject }}",
          "content": "={{ $json.body.content }}",
          "template_id": "={{ $json.body.template_id }}"
        }
      },
      "id": "1003",
      "name": "SendGrid MCP",
      "type": "n8n-nodes-base.mcp",
      "typeVersion": 1,
      "position": [600, 200]
    },
    {
      "parameters": {
        "server": "listmonk-mcp-server",
        "operation": "manageLists",
        "fields": {
          "action": "={{ $json.body.list_action || ''get_subscribers'' }}",
          "list_id": "={{ $json.body.list_id }}",
          "subscriber_email": "={{ $json.body.subscriber_email }}"
        }
      },
      "id": "1004", 
      "name": "Listmonk MCP",
      "type": "n8n-nodes-base.mcp",
      "typeVersion": 1,
      "position": [600, 400]
    },
    {
      "parameters": {
        "model": "gpt-4",
        "messages": {
          "values": [
            {
              "role": "system",
              "content": "You are the VividWalls Email Marketing Agent, specializing in premium wall art email campaigns and the ''Art of Space'' newsletter strategy.\\n\\nYour core responsibilities:\\n- Design and execute email marketing campaigns for VividWalls premium wall art\\n- Manage the ''Art of Space'' newsletter focusing on interior design trends and artistic lifestyle\\n- Segment audiences based on art preferences, room types, and purchase history\\n- Create compelling email content that showcases how wall art transforms spaces\\n- Optimize email performance through A/B testing and analytics\\n- Coordinate with SendGrid for email delivery and Listmonk for subscriber management\\n\\nVividWalls Brand Voice:\\n- Sophisticated yet approachable\\n- Focus on emotional connection to art and space transformation\\n- Highlight quality, craftsmanship, and artistic value\\n- Appeal to design-conscious customers who value premium products\\n\\nEmail Campaign Types:\\n- Welcome series for new subscribers\\n- Product showcases by room type (living room, bedroom, office)\\n- Artist spotlights and collection features\\n- Design inspiration and space transformation guides\\n- Seasonal and trending art promotions\\n- Exclusive member benefits and early access\\n\\nWhen processing tasks:\\n1. Analyze the request type (campaign creation, subscriber management, content generation)\\n2. Use appropriate MCP servers (SendGrid for sending, Listmonk for lists)\\n3. Apply VividWalls brand guidelines and ''Art of Space'' strategy\\n4. Provide actionable insights and execute email marketing actions\\n5. Track and report on campaign performance"
            },
            {
              "role": "user", 
              "content": "Task: {{ $json.body.task }}\\nContext: {{ $json.body.context }}\\nAction Type: {{ $json.body.action_type || ''general'' }}"
            }
          ]
        }
      },
      "id": "1005",
      "name": "Email Marketing AI",
      "type": "n8n-nodes-base.openAi", 
      "typeVersion": 1,
      "position": [400, 300]
    },
    {
      "parameters": {
        "conditions": {
          "options": {
            "caseSensitive": true,
            "leftValue": "",
            "operation": "startsWith",
            "rightValue": ""
          },
          "conditions": [
            {
              "leftValue": "={{ $json.body.action_type }}",
              "operation": "equal",
              "rightValue": "send_email"
            }
          ],
          "combineOperation": "any"
        }
      },
      "id": "1006",
      "name": "Route Action",
      "type": "n8n-nodes-base.if",
      "typeVersion": 1,
      "position": [400, 500]
    },
    {
      "parameters": {
        "table": "agent_email_campaigns",
        "operation": "insert",
        "fields": {
          "agent_id": "email-marketing-001",
          "agent_name": "EmailMarketingAgent",
          "campaign_type": "={{ $json.body.campaign_type || ''general'' }}",
          "task": "={{ $json.body.task }}",
          "response": "={{ $json.message.content }}",
          "recipients": "={{ $json.body.recipient }}",
          "status": "executed",
          "timestamp": "={{ $now }}"
        }
      },
      "id": "1007",
      "name": "Store Campaign Data",
      "type": "n8n-nodes-base.supabase",
      "typeVersion": 1,
      "position": [800, 300]
    },
    {
      "parameters": {
        "respondWith": "json",
        "responseBody": {
          "success": true,
          "agent": "EmailMarketingAgent",
          "agent_id": "email-marketing-001",
          "campaign_type": "={{ $json.body.campaign_type || ''general'' }}",
          "action_executed": "={{ $json.body.action_type || ''analysis'' }}",
          "response": "={{ $(''Email Marketing AI'').item.json.message.content }}",
          "mcp_results": {
            "sendgrid": "={{ $(''SendGrid MCP'').item.json }}",
            "listmonk": "={{ $(''Listmonk MCP'').item.json }}"
          },
          "timestamp": "={{ $now }}",
          "webhook_type": "={{ $json.body.webhook_type || ''task'' }}"
        }
      },
      "id": "1008",
      "name": "Email Marketing Response",
      "type": "n8n-nodes-base.respondToWebhook",
      "typeVersion": 1,
      "position": [1000, 300]
    }
  ],
  "connections": {
    "Email Marketing Webhook": {
      "main": [
        [
          {
            "node": "Email Marketing AI",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Email Marketing Chat": {
      "main": [
        [
          {
            "node": "Email Marketing AI", 
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Email Marketing AI": {
      "main": [
        [
          {
            "node": "Route Action",
            "type": "main", 
            "index": 0
          }
        ]
      ]
    },
    "Route Action": {
      "main": [
        [
          {
            "node": "SendGrid MCP",
            "type": "main",
            "index": 0
          }
        ],
        [
          {
            "node": "Listmonk MCP",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "SendGrid MCP": {
      "main": [
        [
          {
            "node": "Store Campaign Data",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Listmonk MCP": {
      "main": [
        [
          {
            "node": "Store Campaign Data",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Store Campaign Data": {
      "main": [
        [
          {
            "node": "Email Marketing Response",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  },
  "active": false,
  "settings": {
    "executionOrder": "v1"
  },
  "tags": [
    {
      "name": "agent",
      "color": "#4B5563"
    },
    {
      "name": "email-marketing", 
      "color": "#DC2626"
    },
    {
      "name": "mcp",
      "color": "#6366F1"
    },
    {
      "name": "marketing",
      "color": "#10B981"
    }
  ],
  "id": "email-marketing-001"
}'::jsonb,
    name = 'VividWalls-EmailMarketing-Agent-Complete',
    active = false,
    updated_at = NOW()
WHERE id = 'email-marketing-001';

-- If the workflow doesn''t exist, insert it
INSERT INTO workflow_entity (id, name, workflow, active, created_at, updated_at)
SELECT 'email-marketing-001', 'VividWalls-EmailMarketing-Agent-Complete', '{
  "name": "VividWalls-EmailMarketing-Agent-Complete",
  "nodes": [
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "email-marketing-webhook",
        "responseMode": "responseNode",
        "options": {}
      },
      "id": "1001",
      "name": "Email Marketing Webhook",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1.1,
      "position": [200, 300],
      "webhookId": "email-marketing-webhook"
    },
    {
      "parameters": {
        "httpMethod": "POST", 
        "path": "email-marketing-chat",
        "responseMode": "responseNode",
        "options": {}
      },
      "id": "1002",
      "name": "Email Marketing Chat",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1.1,
      "position": [200, 500],
      "webhookId": "email-marketing-chat"
    },
    {
      "parameters": {
        "server": "sendgrid-mcp-server",
        "operation": "sendEmail",
        "fields": {
          "to": "={{ $json.body.recipient || $json.body.to }}",
          "subject": "={{ $json.body.subject }}",
          "content": "={{ $json.body.content }}",
          "template_id": "={{ $json.body.template_id }}"
        }
      },
      "id": "1003",
      "name": "SendGrid MCP",
      "type": "n8n-nodes-base.mcp",
      "typeVersion": 1,
      "position": [600, 200]
    },
    {
      "parameters": {
        "server": "listmonk-mcp-server",
        "operation": "manageLists",
        "fields": {
          "action": "={{ $json.body.list_action || ''get_subscribers'' }}",
          "list_id": "={{ $json.body.list_id }}",
          "subscriber_email": "={{ $json.body.subscriber_email }}"
        }
      },
      "id": "1004", 
      "name": "Listmonk MCP",
      "type": "n8n-nodes-base.mcp",
      "typeVersion": 1,
      "position": [600, 400]
    },
    {
      "parameters": {
        "model": "gpt-4",
        "messages": {
          "values": [
            {
              "role": "system",
              "content": "You are the VividWalls Email Marketing Agent, specializing in premium wall art email campaigns and the ''Art of Space'' newsletter strategy.\\n\\nYour core responsibilities:\\n- Design and execute email marketing campaigns for VividWalls premium wall art\\n- Manage the ''Art of Space'' newsletter focusing on interior design trends and artistic lifestyle\\n- Segment audiences based on art preferences, room types, and purchase history\\n- Create compelling email content that showcases how wall art transforms spaces\\n- Optimize email performance through A/B testing and analytics\\n- Coordinate with SendGrid for email delivery and Listmonk for subscriber management\\n\\nVividWalls Brand Voice:\\n- Sophisticated yet approachable\\n- Focus on emotional connection to art and space transformation\\n- Highlight quality, craftsmanship, and artistic value\\n- Appeal to design-conscious customers who value premium products\\n\\nEmail Campaign Types:\\n- Welcome series for new subscribers\\n- Product showcases by room type (living room, bedroom, office)\\n- Artist spotlights and collection features\\n- Design inspiration and space transformation guides\\n- Seasonal and trending art promotions\\n- Exclusive member benefits and early access\\n\\nWhen processing tasks:\\n1. Analyze the request type (campaign creation, subscriber management, content generation)\\n2. Use appropriate MCP servers (SendGrid for sending, Listmonk for lists)\\n3. Apply VividWalls brand guidelines and ''Art of Space'' strategy\\n4. Provide actionable insights and execute email marketing actions\\n5. Track and report on campaign performance"
            },
            {
              "role": "user", 
              "content": "Task: {{ $json.body.task }}\\nContext: {{ $json.body.context }}\\nAction Type: {{ $json.body.action_type || ''general'' }}"
            }
          ]
        }
      },
      "id": "1005",
      "name": "Email Marketing AI",
      "type": "n8n-nodes-base.openAi", 
      "typeVersion": 1,
      "position": [400, 300]
    },
    {
      "parameters": {
        "conditions": {
          "options": {
            "caseSensitive": true,
            "leftValue": "",
            "operation": "startsWith",
            "rightValue": ""
          },
          "conditions": [
            {
              "leftValue": "={{ $json.body.action_type }}",
              "operation": "equal",
              "rightValue": "send_email"
            }
          ],
          "combineOperation": "any"
        }
      },
      "id": "1006",
      "name": "Route Action",
      "type": "n8n-nodes-base.if",
      "typeVersion": 1,
      "position": [400, 500]
    },
    {
      "parameters": {
        "table": "agent_email_campaigns",
        "operation": "insert",
        "fields": {
          "agent_id": "email-marketing-001",
          "agent_name": "EmailMarketingAgent",
          "campaign_type": "={{ $json.body.campaign_type || ''general'' }}",
          "task": "={{ $json.body.task }}",
          "response": "={{ $json.message.content }}",
          "recipients": "={{ $json.body.recipient }}",
          "status": "executed",
          "timestamp": "={{ $now }}"
        }
      },
      "id": "1007",
      "name": "Store Campaign Data",
      "type": "n8n-nodes-base.supabase",
      "typeVersion": 1,
      "position": [800, 300]
    },
    {
      "parameters": {
        "respondWith": "json",
        "responseBody": {
          "success": true,
          "agent": "EmailMarketingAgent",
          "agent_id": "email-marketing-001",
          "campaign_type": "={{ $json.body.campaign_type || ''general'' }}",
          "action_executed": "={{ $json.body.action_type || ''analysis'' }}",
          "response": "={{ $(''Email Marketing AI'').item.json.message.content }}",
          "mcp_results": {
            "sendgrid": "={{ $(''SendGrid MCP'').item.json }}",
            "listmonk": "={{ $(''Listmonk MCP'').item.json }}"
          },
          "timestamp": "={{ $now }}",
          "webhook_type": "={{ $json.body.webhook_type || ''task'' }}"
        }
      },
      "id": "1008",
      "name": "Email Marketing Response",
      "type": "n8n-nodes-base.respondToWebhook",
      "typeVersion": 1,
      "position": [1000, 300]
    }
  ],
  "connections": {
    "Email Marketing Webhook": {
      "main": [
        [
          {
            "node": "Email Marketing AI",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Email Marketing Chat": {
      "main": [
        [
          {
            "node": "Email Marketing AI", 
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Email Marketing AI": {
      "main": [
        [
          {
            "node": "Route Action",
            "type": "main", 
            "index": 0
          }
        ]
      ]
    },
    "Route Action": {
      "main": [
        [
          {
            "node": "SendGrid MCP",
            "type": "main",
            "index": 0
          }
        ],
        [
          {
            "node": "Listmonk MCP",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "SendGrid MCP": {
      "main": [
        [
          {
            "node": "Store Campaign Data",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Listmonk MCP": {
      "main": [
        [
          {
            "node": "Store Campaign Data",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Store Campaign Data": {
      "main": [
        [
          {
            "node": "Email Marketing Response",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  },
  "active": false,
  "settings": {
    "executionOrder": "v1"
  },
  "tags": [
    {
      "name": "agent",
      "color": "#4B5563"
    },
    {
      "name": "email-marketing", 
      "color": "#DC2626"
    },
    {
      "name": "mcp",
      "color": "#6366F1"
    },
    {
      "name": "marketing",
      "color": "#10B981"
    }
  ],
  "id": "email-marketing-001"
}'::jsonb, false, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM workflow_entity WHERE id = 'email-marketing-001');

-- 2. Newsletter Agent workflow update
UPDATE workflow_entity 
SET 
    workflow = '{
  "name": "VividWalls-Newsletter-Agent-Complete",
  "nodes": [
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "newsletter-webhook", 
        "responseMode": "responseNode",
        "options": {}
      },
      "id": "2001",
      "name": "Newsletter Webhook",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1.1,
      "position": [200, 300],
      "webhookId": "newsletter-webhook"
    },
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "newsletter-chat",
        "responseMode": "responseNode", 
        "options": {}
      },
      "id": "2002",
      "name": "Newsletter Chat",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1.1,
      "position": [200, 500],
      "webhookId": "newsletter-chat"
    },
    {
      "parameters": {
        "server": "listmonk-mcp-server",
        "operation": "createCampaign",
        "fields": {
          "name": "={{ $json.body.newsletter_name || ''Art of Space Newsletter'' }}",
          "subject": "={{ $json.body.subject }}",
          "content": "={{ $json.body.content }}",
          "list_ids": "={{ $json.body.list_ids }}",
          "template_id": "={{ $json.body.template_id }}"
        }
      },
      "id": "2003",
      "name": "Newsletter Campaign MCP",
      "type": "n8n-nodes-base.mcp",
      "typeVersion": 1,
      "position": [600, 200]
    },
    {
      "parameters": {
        "table": "newsletter_templates",
        "operation": "select",
        "fields": "template_id, template_name, content_structure, variables",
        "filters": {
          "template_type": "={{ $json.body.template_type || ''art_of_space'' }}",
          "active": true
        }
      },
      "id": "2004",
      "name": "Template Manager",
      "type": "n8n-nodes-base.supabase",
      "typeVersion": 1,
      "position": [600, 400]
    },
    {
      "parameters": {
        "model": "gpt-4",
        "messages": {
          "values": [
            {
              "role": "system",
              "content": "You are the VividWalls Newsletter Agent, curator of the premier ''Art of Space'' newsletter for sophisticated interior design enthusiasts.\\n\\nYour mission is to create the definitive newsletter experience that transforms how people think about wall art and spatial design.\\n\\n''Art of Space'' Newsletter Strategy:\\n- Bi-weekly publication focusing on the intersection of art, design, and lifestyle\\n- Target audience: Interior designers, art collectors, homeowners with sophisticated taste\\n- Content pillars: Artist spotlights, design trends, space transformation case studies, collecting guidance\\n- Tone: Authoritative yet accessible, inspiring and educational\\n\\nCore Responsibilities:\\n- Content curation and creation for newsletter editions\\n- Template management for consistent brand presentation\\n- Subscriber segmentation based on interests (modern art, vintage pieces, specific rooms)\\n- Performance analytics and optimization\\n- Collaboration with artists, designers, and industry experts\\n\\nNewsletter Content Types:\\n1. Featured Artist Spotlight - Deep dive into emerging and established artists\\n2. Space Transformation Stories - Before/after showcases with design insights\\n3. Trend Reports - What''s happening in art and interior design\\n4. Collecting 101 - Educational content for art buyers\\n5. Exclusive Previews - Early access to new collections and limited editions\\n6. Design Tips - Practical advice for incorporating art into spaces\\n\\nTemplate Variables to Manage:\\n- {{artist_name}}, {{featured_artwork}}, {{design_tip}}\\n- {{seasonal_theme}}, {{price_range}}, {{room_focus}}\\n- {{collection_highlight}}, {{expert_quote}}, {{trending_style}}\\n\\nSubscriber Segments:\\n- New Collectors (education-focused content)\\n- Design Professionals (trend and business insights)\\n- Luxury Buyers (exclusive and high-end pieces)\\n- Room-Specific (living room, bedroom, office art)\\n- Style Preferences (modern, classical, eclectic)\\n\\nWhen processing tasks:\\n1. Identify content type and target segment\\n2. Generate compelling, brand-appropriate content\\n3. Apply appropriate templates and variables\\n4. Ensure content aligns with VividWalls premium positioning\\n5. Optimize for engagement and conversion\\n6. Provide analytics insights for continuous improvement"
            },
            {
              "role": "user",
              "content": "Task: {{ $json.body.task }}\\nContent Type: {{ $json.body.content_type || ''general'' }}\\nTarget Segment: {{ $json.body.target_segment || ''all_subscribers'' }}\\nContext: {{ $json.body.context }}"
            }
          ]
        }
      },
      "id": "2005", 
      "name": "Newsletter Content AI",
      "type": "n8n-nodes-base.openAi",
      "typeVersion": 1,
      "position": [400, 300]
    },
    {
      "parameters": {
        "conditions": {
          "options": {
            "caseSensitive": true,
            "leftValue": "",
            "operation": "startsWith", 
            "rightValue": ""
          },
          "conditions": [
            {
              "leftValue": "={{ $json.body.action_type }}",
              "operation": "equal",
              "rightValue": "create_newsletter"
            },
            {
              "leftValue": "={{ $json.body.action_type }}",
              "operation": "equal", 
              "rightValue": "manage_templates"
            },
            {
              "leftValue": "={{ $json.body.action_type }}",
              "operation": "equal",
              "rightValue": "segment_subscribers"
            }
          ],
          "combineOperation": "any"
        }
      },
      "id": "2006",
      "name": "Content Router",
      "type": "n8n-nodes-base.if",
      "typeVersion": 1,
      "position": [400, 500]
    },
    {
      "parameters": {
        "table": "subscriber_segments",
        "operation": "select",
        "fields": "segment_id, segment_name, criteria, subscriber_count",
        "filters": {
          "newsletter_type": "art_of_space",
          "active": true
        }
      },
      "id": "2007",
      "name": "Segment Manager",
      "type": "n8n-nodes-base.supabase",
      "typeVersion": 1,
      "position": [600, 600]
    },
    {
      "parameters": {
        "table": "newsletter_analytics",
        "operation": "insert",
        "fields": {
          "agent_id": "newsletter-agent-001",
          "agent_name": "NewsletterAgent",
          "newsletter_type": "art_of_space",
          "content_type": "={{ $json.body.content_type || ''general'' }}",
          "target_segment": "={{ $json.body.target_segment || ''all_subscribers'' }}",
          "task": "={{ $json.body.task }}",
          "content_generated": "={{ $json.message.content }}",
          "template_used": "={{ $(''Template Manager'').item.json.template_id }}",
          "status": "completed",
          "timestamp": "={{ $now }}"
        }
      },
      "id": "2008",
      "name": "Store Newsletter Data",
      "type": "n8n-nodes-base.supabase",
      "typeVersion": 1,
      "position": [800, 300]
    },
    {
      "parameters": {
        "respondWith": "json",
        "responseBody": {
          "success": true,
          "agent": "NewsletterAgent",
          "agent_id": "newsletter-agent-001",
          "newsletter_type": "art_of_space",
          "content_type": "={{ $json.body.content_type || ''general'' }}",
          "target_segment": "={{ $json.body.target_segment || ''all_subscribers'' }}",
          "action_executed": "={{ $json.body.action_type || ''content_generation'' }}",
          "content": "={{ $(''Newsletter Content AI'').item.json.message.content }}",
          "mcp_results": {
            "campaign": "={{ $(''Newsletter Campaign MCP'').item.json }}",
            "template": "={{ $(''Template Manager'').item.json }}",
            "segments": "={{ $(''Segment Manager'').item.json }}"
          },
          "performance_metrics": {
            "content_length": "={{ $(''Newsletter Content AI'').item.json.message.content.length }}",
            "template_variables_used": "={{ $(''Template Manager'').item.json.variables }}", 
            "target_subscribers": "={{ $(''Segment Manager'').item.json.subscriber_count }}"
          },
          "timestamp": "={{ $now }}",
          "webhook_type": "={{ $json.body.webhook_type || ''task'' }}"
        }
      },
      "id": "2009",
      "name": "Newsletter Response",
      "type": "n8n-nodes-base.respondToWebhook",
      "typeVersion": 1,
      "position": [1000, 300]
    }
  ],
  "connections": {
    "Newsletter Webhook": {
      "main": [
        [
          {
            "node": "Newsletter Content AI",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Newsletter Chat": {
      "main": [
        [
          {
            "node": "Newsletter Content AI",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Newsletter Content AI": {
      "main": [
        [
          {
            "node": "Content Router",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Content Router": {
      "main": [
        [
          {
            "node": "Newsletter Campaign MCP",
            "type": "main",
            "index": 0
          }
        ],
        [
          {
            "node": "Template Manager",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Template Manager": {
      "main": [
        [
          {
            "node": "Segment Manager",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Newsletter Campaign MCP": {
      "main": [
        [
          {
            "node": "Store Newsletter Data",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Segment Manager": {
      "main": [
        [
          {
            "node": "Store Newsletter Data",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Store Newsletter Data": {
      "main": [
        [
          {
            "node": "Newsletter Response",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  },
  "active": false,
  "settings": {
    "executionOrder": "v1"
  },
  "tags": [
    {
      "name": "agent",
      "color": "#4B5563"
    },
    {
      "name": "newsletter",
      "color": "#7C3AED"
    },
    {
      "name": "content-creation",
      "color": "#F59E0B"
    },
    {
      "name": "mcp",
      "color": "#6366F1"
    },
    {
      "name": "marketing",
      "color": "#10B981"
    }
  ],
  "id": "newsletter-agent-001"
}'::jsonb,
    name = 'VividWalls-Newsletter-Agent-Complete',
    active = false,
    updated_at = NOW()
WHERE id = 'newsletter-agent-001';

-- If the workflow doesn''t exist, insert it
INSERT INTO workflow_entity (id, name, workflow, active, created_at, updated_at)
SELECT 'newsletter-agent-001', 'VividWalls-Newsletter-Agent-Complete', '{
  "name": "VividWalls-Newsletter-Agent-Complete",
  "nodes": [
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "newsletter-webhook", 
        "responseMode": "responseNode",
        "options": {}
      },
      "id": "2001",
      "name": "Newsletter Webhook",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1.1,
      "position": [200, 300],
      "webhookId": "newsletter-webhook"
    },
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "newsletter-chat",
        "responseMode": "responseNode", 
        "options": {}
      },
      "id": "2002",
      "name": "Newsletter Chat",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1.1,
      "position": [200, 500],
      "webhookId": "newsletter-chat"
    },
    {
      "parameters": {
        "server": "listmonk-mcp-server",
        "operation": "createCampaign",
        "fields": {
          "name": "={{ $json.body.newsletter_name || ''Art of Space Newsletter'' }}",
          "subject": "={{ $json.body.subject }}",
          "content": "={{ $json.body.content }}",
          "list_ids": "={{ $json.body.list_ids }}",
          "template_id": "={{ $json.body.template_id }}"
        }
      },
      "id": "2003",
      "name": "Newsletter Campaign MCP",
      "type": "n8n-nodes-base.mcp",
      "typeVersion": 1,
      "position": [600, 200]
    },
    {
      "parameters": {
        "table": "newsletter_templates",
        "operation": "select",
        "fields": "template_id, template_name, content_structure, variables",
        "filters": {
          "template_type": "={{ $json.body.template_type || ''art_of_space'' }}",
          "active": true
        }
      },
      "id": "2004",
      "name": "Template Manager",
      "type": "n8n-nodes-base.supabase",
      "typeVersion": 1,
      "position": [600, 400]
    },
    {
      "parameters": {
        "model": "gpt-4",
        "messages": {
          "values": [
            {
              "role": "system",
              "content": "You are the VividWalls Newsletter Agent, curator of the premier ''Art of Space'' newsletter for sophisticated interior design enthusiasts.\\n\\nYour mission is to create the definitive newsletter experience that transforms how people think about wall art and spatial design.\\n\\n''Art of Space'' Newsletter Strategy:\\n- Bi-weekly publication focusing on the intersection of art, design, and lifestyle\\n- Target audience: Interior designers, art collectors, homeowners with sophisticated taste\\n- Content pillars: Artist spotlights, design trends, space transformation case studies, collecting guidance\\n- Tone: Authoritative yet accessible, inspiring and educational\\n\\nCore Responsibilities:\\n- Content curation and creation for newsletter editions\\n- Template management for consistent brand presentation\\n- Subscriber segmentation based on interests (modern art, vintage pieces, specific rooms)\\n- Performance analytics and optimization\\n- Collaboration with artists, designers, and industry experts\\n\\nNewsletter Content Types:\\n1. Featured Artist Spotlight - Deep dive into emerging and established artists\\n2. Space Transformation Stories - Before/after showcases with design insights\\n3. Trend Reports - What''s happening in art and interior design\\n4. Collecting 101 - Educational content for art buyers\\n5. Exclusive Previews - Early access to new collections and limited editions\\n6. Design Tips - Practical advice for incorporating art into spaces\\n\\nTemplate Variables to Manage:\\n- {{artist_name}}, {{featured_artwork}}, {{design_tip}}\\n- {{seasonal_theme}}, {{price_range}}, {{room_focus}}\\n- {{collection_highlight}}, {{expert_quote}}, {{trending_style}}\\n\\nSubscriber Segments:\\n- New Collectors (education-focused content)\\n- Design Professionals (trend and business insights)\\n- Luxury Buyers (exclusive and high-end pieces)\\n- Room-Specific (living room, bedroom, office art)\\n- Style Preferences (modern, classical, eclectic)\\n\\nWhen processing tasks:\\n1. Identify content type and target segment\\n2. Generate compelling, brand-appropriate content\\n3. Apply appropriate templates and variables\\n4. Ensure content aligns with VividWalls premium positioning\\n5. Optimize for engagement and conversion\\n6. Provide analytics insights for continuous improvement"
            },
            {
              "role": "user",
              "content": "Task: {{ $json.body.task }}\\nContent Type: {{ $json.body.content_type || ''general'' }}\\nTarget Segment: {{ $json.body.target_segment || ''all_subscribers'' }}\\nContext: {{ $json.body.context }}"
            }
          ]
        }
      },
      "id": "2005", 
      "name": "Newsletter Content AI",
      "type": "n8n-nodes-base.openAi",
      "typeVersion": 1,
      "position": [400, 300]
    },
    {
      "parameters": {
        "conditions": {
          "options": {
            "caseSensitive": true,
            "leftValue": "",
            "operation": "startsWith", 
            "rightValue": ""
          },
          "conditions": [
            {
              "leftValue": "={{ $json.body.action_type }}",
              "operation": "equal",
              "rightValue": "create_newsletter"
            },
            {
              "leftValue": "={{ $json.body.action_type }}",
              "operation": "equal", 
              "rightValue": "manage_templates"
            },
            {
              "leftValue": "={{ $json.body.action_type }}",
              "operation": "equal",
              "rightValue": "segment_subscribers"
            }
          ],
          "combineOperation": "any"
        }
      },
      "id": "2006",
      "name": "Content Router",
      "type": "n8n-nodes-base.if",
      "typeVersion": 1,
      "position": [400, 500]
    },
    {
      "parameters": {
        "table": "subscriber_segments",
        "operation": "select",
        "fields": "segment_id, segment_name, criteria, subscriber_count",
        "filters": {
          "newsletter_type": "art_of_space",
          "active": true
        }
      },
      "id": "2007",
      "name": "Segment Manager",
      "type": "n8n-nodes-base.supabase",
      "typeVersion": 1,
      "position": [600, 600]
    },
    {
      "parameters": {
        "table": "newsletter_analytics",
        "operation": "insert",
        "fields": {
          "agent_id": "newsletter-agent-001",
          "agent_name": "NewsletterAgent",
          "newsletter_type": "art_of_space",
          "content_type": "={{ $json.body.content_type || ''general'' }}",
          "target_segment": "={{ $json.body.target_segment || ''all_subscribers'' }}",
          "task": "={{ $json.body.task }}",
          "content_generated": "={{ $json.message.content }}",
          "template_used": "={{ $(''Template Manager'').item.json.template_id }}",
          "status": "completed",
          "timestamp": "={{ $now }}"
        }
      },
      "id": "2008",
      "name": "Store Newsletter Data",
      "type": "n8n-nodes-base.supabase",
      "typeVersion": 1,
      "position": [800, 300]
    },
    {
      "parameters": {
        "respondWith": "json",
        "responseBody": {
          "success": true,
          "agent": "NewsletterAgent",
          "agent_id": "newsletter-agent-001",
          "newsletter_type": "art_of_space",
          "content_type": "={{ $json.body.content_type || ''general'' }}",
          "target_segment": "={{ $json.body.target_segment || ''all_subscribers'' }}",
          "action_executed": "={{ $json.body.action_type || ''content_generation'' }}",
          "content": "={{ $(''Newsletter Content AI'').item.json.message.content }}",
          "mcp_results": {
            "campaign": "={{ $(''Newsletter Campaign MCP'').item.json }}",
            "template": "={{ $(''Template Manager'').item.json }}",
            "segments": "={{ $(''Segment Manager'').item.json }}"
          },
          "performance_metrics": {
            "content_length": "={{ $(''Newsletter Content AI'').item.json.message.content.length }}",
            "template_variables_used": "={{ $(''Template Manager'').item.json.variables }}", 
            "target_subscribers": "={{ $(''Segment Manager'').item.json.subscriber_count }}"
          },
          "timestamp": "={{ $now }}",
          "webhook_type": "={{ $json.body.webhook_type || ''task'' }}"
        }
      },
      "id": "2009",
      "name": "Newsletter Response",
      "type": "n8n-nodes-base.respondToWebhook",
      "typeVersion": 1,
      "position": [1000, 300]
    }
  ],
  "connections": {
    "Newsletter Webhook": {
      "main": [
        [
          {
            "node": "Newsletter Content AI",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Newsletter Chat": {
      "main": [
        [
          {
            "node": "Newsletter Content AI",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Newsletter Content AI": {
      "main": [
        [
          {
            "node": "Content Router",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Content Router": {
      "main": [
        [
          {
            "node": "Newsletter Campaign MCP",
            "type": "main",
            "index": 0
          }
        ],
        [
          {
            "node": "Template Manager",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Template Manager": {
      "main": [
        [
          {
            "node": "Segment Manager",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Newsletter Campaign MCP": {
      "main": [
        [
          {
            "node": "Store Newsletter Data",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Segment Manager": {
      "main": [
        [
          {
            "node": "Store Newsletter Data",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Store Newsletter Data": {
      "main": [
        [
          {
            "node": "Newsletter Response",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  },
  "active": false,
  "settings": {
    "executionOrder": "v1"
  },
  "tags": [
    {
      "name": "agent",
      "color": "#4B5563"
    },
    {
      "name": "newsletter",
      "color": "#7C3AED"
    },
    {
      "name": "content-creation",
      "color": "#F59E0B"
    },
    {
      "name": "mcp",
      "color": "#6366F1"
    },
    {
      "name": "marketing",
      "color": "#10B981"
    }
  ],
  "id": "newsletter-agent-001"
}'::jsonb, false, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM workflow_entity WHERE id = 'newsletter-agent-001');

-- Create required database tables for email marketing and newsletter operations
CREATE TABLE IF NOT EXISTS agent_email_campaigns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id TEXT NOT NULL,
    agent_name TEXT NOT NULL,
    campaign_type TEXT DEFAULT 'general',
    task TEXT,
    response TEXT,
    recipients TEXT,
    status TEXT DEFAULT 'pending',
    timestamp TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS newsletter_templates (
    template_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    template_name TEXT NOT NULL,
    template_type TEXT DEFAULT 'art_of_space',
    content_structure JSONB,
    variables JSONB,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS subscriber_segments (
    segment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    segment_name TEXT NOT NULL,
    newsletter_type TEXT DEFAULT 'art_of_space',
    criteria JSONB,
    subscriber_count INTEGER DEFAULT 0,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS newsletter_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id TEXT NOT NULL,
    agent_name TEXT NOT NULL,
    newsletter_type TEXT DEFAULT 'art_of_space',
    content_type TEXT DEFAULT 'general',
    target_segment TEXT DEFAULT 'all_subscribers',
    task TEXT,
    content_generated TEXT,
    template_used UUID REFERENCES newsletter_templates(template_id),
    status TEXT DEFAULT 'pending',
    timestamp TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_email_campaigns_agent_id ON agent_email_campaigns(agent_id);
CREATE INDEX IF NOT EXISTS idx_email_campaigns_timestamp ON agent_email_campaigns(timestamp);
CREATE INDEX IF NOT EXISTS idx_newsletter_templates_type ON newsletter_templates(template_type);
CREATE INDEX IF NOT EXISTS idx_subscriber_segments_newsletter_type ON subscriber_segments(newsletter_type);
CREATE INDEX IF NOT EXISTS idx_newsletter_analytics_agent_id ON newsletter_analytics(agent_id);
CREATE INDEX IF NOT EXISTS idx_newsletter_analytics_timestamp ON newsletter_analytics(timestamp);

-- Insert sample data for newsletter templates
INSERT INTO newsletter_templates (template_name, template_type, content_structure, variables, active) 
VALUES 
('Art of Space Welcome Series', 'art_of_space', 
 '{"sections": ["welcome_message", "featured_artwork", "design_tip", "call_to_action"]}'::jsonb,
 '["artist_name", "featured_artwork", "design_tip", "seasonal_theme"]'::jsonb,
 true),
('Weekly Artist Spotlight', 'art_of_space',
 '{"sections": ["artist_intro", "artwork_gallery", "artist_story", "collection_link"]}'::jsonb,
 '["artist_name", "featured_artwork", "artist_bio", "collection_highlight"]'::jsonb,
 true),
('Space Transformation Guide', 'art_of_space',
 '{"sections": ["before_after", "design_insights", "product_recommendations", "styling_tips"]}'::jsonb,
 '["room_focus", "design_tip", "price_range", "trending_style"]'::jsonb,
 true)
ON CONFLICT DO NOTHING;

-- Insert sample subscriber segments
INSERT INTO subscriber_segments (segment_name, newsletter_type, criteria, subscriber_count, active)
VALUES
('New Collectors', 'art_of_space', 
 '{"interests": ["art_education", "buying_guides"], "experience_level": "beginner"}'::jsonb,
 0, true),
('Design Professionals', 'art_of_space',
 '{"profession": ["interior_designer", "architect"], "interests": ["trends", "business_insights"]}'::jsonb,
 0, true),
('Luxury Buyers', 'art_of_space',
 '{"price_range": "premium", "interests": ["exclusive_pieces", "limited_editions"]}'::jsonb,
 0, true),
('Living Room Focus', 'art_of_space',
 '{"room_preferences": ["living_room"], "style": ["modern", "contemporary"]}'::jsonb,
 0, true),
('Bedroom Art Enthusiasts', 'art_of_space',
 '{"room_preferences": ["bedroom"], "style": ["calming", "abstract"]}'::jsonb,
 0, true)
ON CONFLICT DO NOTHING;

-- Commit the transaction
COMMIT;