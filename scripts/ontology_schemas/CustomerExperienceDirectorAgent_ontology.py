"""
CustomerExperienceDirectorAgent Ontology Schema
For VividWalls E-commerce Multi-Agent System

This ontology defines the knowledge structure for the Customer Experience Director,
who serves as the Chief Customer Officer responsible for support and retention.
"""

CUSTOMER_EXPERIENCE_ONTOLOGY = {
    "agent_profile": {
        "id": "00000000-0000-0000-0001-000000000001",
        "name": "Emily Chen",
        "role": "Customer Experience Director",
        "backstory": "Chief Customer Officer responsible for support and retention",
        "goals": [
            "Achieve NPS >70",
            "Reduce churn <5%",
            "Optimize support costs"
        ],
        "domain_focus": "Customer service, retention, and satisfaction"
    },
    
    "core_concepts": {
        "customer_service": {
            "definition": "Activities to ensure customer satisfaction",
            "subconcepts": [
                "Support channels",
                "Response time",
                "First contact resolution",
                "Service level agreements",
                "Ticket management",
                "Omnichannel support"
            ]
        },
        "customer_retention": {
            "definition": "Strategies to keep customers engaged and loyal",
            "subconcepts": [
                "Churn prevention",
                "Loyalty programs",
                "Customer lifetime value",
                "Win-back campaigns",
                "Engagement metrics",
                "Satisfaction drivers"
            ]
        },
        "customer_feedback": {
            "definition": "Collection and analysis of customer opinions",
            "subconcepts": [
                "NPS measurement",
                "CSAT surveys",
                "Customer effort score",
                "Review management",
                "Voice of customer",
                "Feedback loops"
            ]
        },
        "support_technology": {
            "definition": "Tools and systems for customer support",
            "subconcepts": [
                "Help desk software",
                "Live chat systems",
                "Knowledge bases",
                "CRM integration",
                "AI chatbots",
                "Self-service portals"
            ]
        }
    },
    
    "key_metrics": {
        "nps": {
            "name": "Net Promoter Score",
            "target": ">70",
            "calculation": "% Promoters - % Detractors",
            "frequency": "Monthly"
        },
        "csat": {
            "name": "Customer Satisfaction Score",
            "target": ">90%",
            "calculation": "Satisfied customers / Total responses",
            "frequency": "Per interaction"
        },
        "churn_rate": {
            "name": "Customer Churn Rate",
            "target": "<5%",
            "calculation": "Lost customers / Total customers",
            "frequency": "Monthly"
        },
        "first_contact_resolution": {
            "name": "First Contact Resolution Rate",
            "target": ">80%",
            "calculation": "Resolved on first contact / Total tickets",
            "frequency": "Weekly"
        },
        "average_response_time": {
            "name": "Average Response Time",
            "target": "<2 hours",
            "calculation": "Sum of response times / Number of tickets",
            "frequency": "Daily"
        }
    },
    
    "best_practices": {
        "proactive_support": [
            "Anticipate customer needs",
            "Send preemptive communications",
            "Monitor for potential issues",
            "Provide self-help resources"
        ],
        "personalization": [
            "Tailor interactions to customer history",
            "Use customer preferred channels",
            "Remember previous interactions",
            "Customize recommendations"
        ],
        "continuous_improvement": [
            "Regular training for support team",
            "Analyze ticket trends",
            "Update knowledge base",
            "Implement customer suggestions"
        ],
        "emotional_intelligence": [
            "Empathy in communications",
            "Active listening techniques",
            "De-escalation strategies",
            "Positive language use"
        ]
    },
    
    "integration_points": {
        "with_marketing": [
            "Customer segmentation data",
            "Campaign feedback",
            "Brand promise alignment"
        ],
        "with_product": [
            "Feature requests",
            "Bug reports",
            "User experience feedback"
        ],
        "with_operations": [
            "Fulfillment issues",
            "Quality concerns",
            "Process improvements"
        ],
        "with_technology": [
            "System requirements",
            "Integration needs",
            "Automation opportunities"
        ]
    },
    
    "knowledge_sources": {
        "industry_authorities": [
            "zendesk.com",
            "salesforce.com/customer-service",
            "helpscout.com",
            "intercom.com",
            "freshworks.com",
            "customerexperiencematrix.com",
            "cxnetwork.com",
            "customerthink.com"
        ],
        "research_organizations": [
            "forrester.com",
            "gartner.com",
            "temkingroup.com"
        ],
        "best_practice_resources": [
            "hbr.org/topic/customer-service",
            "mckinsey.com/capabilities/growth-marketing-and-sales",
            "bain.com/insights/topics/customer-strategy-and-marketing"
        ]
    }
}

# Neo4j Cypher queries to create the ontology structure
NEO4J_SETUP_QUERIES = [
    # Create agent node
    """
    CREATE (agent:Agent {
        id: '00000000-0000-0000-0001-000000000001',
        name: 'Emily Chen',
        role: 'Customer Experience Director',
        type: 'Director',
        backstory: 'Chief Customer Officer responsible for support and retention'
    })
    """,
    
    # Create concept nodes and relationships
    """
    MATCH (agent:Agent {id: '00000000-0000-0000-0001-000000000001'})
    CREATE (cs:Concept {name: 'Customer Service', type: 'Core'})
    CREATE (cr:Concept {name: 'Customer Retention', type: 'Core'})
    CREATE (cf:Concept {name: 'Customer Feedback', type: 'Core'})
    CREATE (st:Concept {name: 'Support Technology', type: 'Core'})
    CREATE (agent)-[:MANAGES]->(cs)
    CREATE (agent)-[:MANAGES]->(cr)
    CREATE (agent)-[:MANAGES]->(cf)
    CREATE (agent)-[:MANAGES]->(st)
    """,
    
    # Create metric nodes
    """
    MATCH (agent:Agent {id: '00000000-0000-0000-0001-000000000001'})
    CREATE (nps:Metric {name: 'NPS', target: '>70', type: 'KPI'})
    CREATE (csat:Metric {name: 'CSAT', target: '>90%', type: 'KPI'})
    CREATE (churn:Metric {name: 'Churn Rate', target: '<5%', type: 'KPI'})
    CREATE (fcr:Metric {name: 'First Contact Resolution', target: '>80%', type: 'Operational'})
    CREATE (art:Metric {name: 'Average Response Time', target: '<2 hours', type: 'Operational'})
    CREATE (agent)-[:TRACKS]->(nps)
    CREATE (agent)-[:TRACKS]->(csat)
    CREATE (agent)-[:TRACKS]->(churn)
    CREATE (agent)-[:TRACKS]->(fcr)
    CREATE (agent)-[:TRACKS]->(art)
    """,
    
    # Create integration relationships with other agents
    """
    MATCH (cxAgent:Agent {id: '00000000-0000-0000-0001-000000000001'})
    MATCH (marketingAgent:Agent {id: '00000000-0000-0000-0003-000000000003'})
    MATCH (productAgent:Agent {id: '00000000-0000-0000-0005-000000000005'})
    MATCH (operationsAgent:Agent {id: '00000000-0000-0000-0004-000000000004'})
    MATCH (techAgent:Agent {id: '00000000-0000-0000-0006-000000000006'})
    CREATE (cxAgent)-[:COLLABORATES_WITH {type: 'Customer Segmentation'}]->(marketingAgent)
    CREATE (cxAgent)-[:COLLABORATES_WITH {type: 'Feature Requests'}]->(productAgent)
    CREATE (cxAgent)-[:COLLABORATES_WITH {type: 'Fulfillment Issues'}]->(operationsAgent)
    CREATE (cxAgent)-[:COLLABORATES_WITH {type: 'System Integration'}]->(techAgent)
    """
]