#!/usr/bin/env python3
"""
Domain Authority Sources for VividWalls MAS Agents.
Based on the comprehensive instructions.md, this file contains authoritative sources
for building domain-specific knowledge graphs and vector databases.
"""

# Domain-specific authoritative sources based on instructions.md
DOMAIN_AUTHORITY_SOURCES = {
    # Marketing Domain
    "marketing_director": {
        "sources": [
            "https://blog.hubspot.com/marketing",
            "https://contentmarketinginstitute.com/",
            "https://moz.com/blog",
            "https://www.semrush.com/blog/",
            "https://www.ama.org/marketing-dictionary/"  # AMA Dictionary for ontology
        ],
        "ontology_sources": [
            "https://www.ama.org/marketing-dictionary/",
            "https://schema.org/MarketingStrategy"
        ]
    },
    "content_strategy": {
        "sources": [
            "https://contentmarketinginstitute.com/",
            "https://copyblogger.com/",
            "https://www.semrush.com/blog/"
        ],
        "queries": ["content strategy frameworks", "content calendar optimization", "content ROI metrics"]
    },
    "campaign_management": {
        "sources": [
            "https://www.adespresso.com/blog/",
            "https://www.wordstream.com/blog",
            "https://unbounce.com/blog/",
            "https://support.google.com/google-ads"
        ]
    },
    "creative_execution": {
        "sources": [
            "https://www.behance.net/",
            "https://dribbble.com/",
            "https://www.awwwards.com/"
        ]
    },
    "email_marketing": {
        "sources": [
            "https://mailchimp.com/resources/",
            "https://litmus.com/blog/",
            "https://www.campaignmonitor.com/resources/"
        ]
    },
    "sms_marketing": {
        "sources": [
            "https://www.twilio.com/blog",
            "https://simpletexting.com/blog/",
            "https://www.tatango.com/blog/"
        ]
    },
    "keyword_research": {
        "sources": [
            "https://ahrefs.com/blog/",
            "https://www.semrush.com/blog/",
            "https://moz.com/blog"
        ]
    },
    "copy_writing": {
        "sources": [
            "https://copyblogger.com/",
            "https://procopywriters.co.uk/",
            "https://www.grammarly.com/blog/"
        ]
    },
    
    # Sales Domain
    "sales_director": {
        "sources": [
            "https://hbr.org/topic/sales",
            "https://www.mckinsey.com/capabilities/growth-marketing-and-sales",
            "https://www.salesforce.com/resources/",
            "https://www.saleshacker.com/"
        ],
        "ontology_sources": [
            "https://www.salesmanagement.org/",
            "https://www.naics.com/search/"  # Industry classifications
        ]
    },
    "hospitality_sales": {
        "sources": [
            "https://www.hotelnewsresource.com/",
            "https://www.hospitalitynet.org/",
            "https://skift.com/"
        ]
    },
    "corporate_sales": {
        "sources": [
            "https://hbr.org/",
            "https://www.mckinsey.com/",
            "https://www.salesforce.com/blog/"
        ]
    },
    "healthcare_sales": {
        "sources": [
            "https://www.fiercehealthcare.com/",
            "https://medcitynews.com/",
            "https://www.beckershospitalreview.com/"
        ]
    },
    "retail_sales": {
        "sources": [
            "https://nrf.com/",
            "https://www.retaildive.com/",
            "https://retailwire.com/"
        ]
    },
    "real_estate_sales": {
        "sources": [
            "https://www.zillow.com/research/",
            "https://www.realtor.com/research/",
            "https://www.inman.com/"
        ]
    },
    "interior_designer_sales": {
        "sources": [
            "https://www.architecturaldigest.com/",
            "https://www.dezeen.com/",
            "https://www.houzz.com/"
        ]
    },
    "art_collector_sales": {
        "sources": [
            "https://www.artsy.net/",
            "https://news.artnet.com/",
            "https://www.sothebys.com/"
        ]
    },
    
    # Social Media Domain
    "social_media_director": {
        "sources": [
            "https://www.socialmediaexaminer.com/",
            "https://sproutsocial.com/insights/",
            "https://blog.hootsuite.com/"
        ],
        "ontology_sources": [
            "https://www.w3.org/wiki/SocialMediaOntology"
        ]
    },
    "instagram_agent": {
        "sources": [
            "https://business.instagram.com/blog",
            "https://later.com/blog/",
            "https://www.socialmediaexaminer.com/category/instagram-marketing/"
        ]
    },
    "facebook_agent": {
        "sources": [
            "https://www.facebook.com/business/news",
            "https://www.socialbakers.com/blog/",
            "https://buffer.com/library/"
        ]
    },
    "pinterest_agent": {
        "sources": [
            "https://business.pinterest.com/",
            "https://www.tailwindapp.com/blog",
            "https://sproutsocial.com/insights/pinterest-marketing/"
        ]
    },
    
    # Analytics Domain
    "analytics_director": {
        "sources": [
            "https://support.google.com/analytics",
            "https://mixpanel.com/blog/",
            "https://amplitude.com/blog",
            "https://towardsdatascience.com/",
            "https://www.kdnuggets.com/"
        ],
        "ontology_sources": [
            "https://www.dama.org/",  # DAMA Dictionary
            "https://schema.org/DataCatalog"
        ]
    },
    "performance_analytics": {
        "sources": [
            "https://support.google.com/analytics",
            "https://mixpanel.com/blog/",
            "https://amplitude.com/blog"
        ]
    },
    "revenue_analytics": {
        "sources": [
            "https://www.investopedia.com/",
            "https://quickbooks.intuit.com/resources/",
            "https://stripe.com/blog"
        ]
    },
    
    # Operations Domain
    "operations_director": {
        "sources": [
            "https://www.supplychaindigital.com/",
            "https://www.scmr.com/",
            "https://www.gartner.com/en/supply-chain",
            "https://www.apics.org/"  # APICS Dictionary
        ],
        "ontology_sources": [
            "https://www.apics.org/apics-for-business/products-and-services/apics-dictionary",
            "https://www.apics.org/docs/default-source/scc-non-research/apicsscc_scor_quick_reference_guide.pdf"  # SCOR Model
        ]
    },
    "inventory_management": {
        "sources": [
            "https://www.netsuite.com/portal/resource/articles/inventory-management/",
            "https://www.supplychaindigital.com/"
        ]
    },
    "shopify_integration": {
        "sources": [
            "https://shopify.dev/docs/",
            "https://community.shopify.com/",
            "https://zapier.com/blog/shopify-integrations/"
        ]
    },
    
    # Customer Experience Domain
    "customer_experience_director": {
        "sources": [
            "https://www.zendesk.com/blog/",
            "https://www.qualtrics.com/blog/",
            "https://www.cxpa.org/"  # CXPA Glossary
        ],
        "ontology_sources": [
            "https://www.cxpa.org/HigherLogic/System/DownloadDocumentFile.ashx?DocumentFileKey=5b5b5b5b"
        ]
    },
    "customer_support": {
        "sources": [
            "https://www.zendesk.com/blog/",
            "https://freshdesk.com/customer-support/",
            "https://www.helpscout.com/blog/"
        ]
    },
    "customer_sentiment": {
        "sources": [
            "https://www.trustpilot.com/",
            "https://www.g2.com/",
            "https://www.capterra.com/"
        ]
    },
    
    # Product Domain
    "product_director": {
        "sources": [
            "https://www.productplan.com/learn/",
            "https://www.mindtheproduct.com/",
            "https://www.romanpichler.com/blog/",
            "https://schema.org/Product",
            "https://www.productontology.org/"
        ],
        "ontology_sources": [
            "https://schema.org/Product",
            "https://www.productontology.org/"
        ]
    },
    "market_research": {
        "sources": [
            "https://www.statista.com/",
            "https://www.nielsen.com/insights/",
            "https://www.pewresearch.org/"
        ]
    },
    "art_trend_intelligence": {
        "sources": [
            "https://www.artsy.net/articles",
            "https://news.artnet.com/",
            "https://www.trendhunter.com/art"
        ]
    },
    
    # Finance Domain
    "finance_director": {
        "sources": [
            "https://www.investopedia.com/",
            "https://www.cfo.com/",
            "https://hbr.org/topic/finance",
            "https://quickbooks.intuit.com/resources/"
        ],
        "ontology_sources": [
            "https://spec.edmcouncil.org/fibo/",  # FIBO
            "https://www.investopedia.com/dictionary/"
        ]
    },
    "budget_management": {
        "sources": [
            "https://www.nerdwallet.com/",
            "https://mint.intuit.com/blog/",
            "https://www.investopedia.com/"
        ]
    },
    "roi_analysis": {
        "sources": [
            "https://hbr.org/",
            "https://www.investopedia.com/",
            "https://quickbooks.intuit.com/resources/"
        ]
    },
    
    # Technology Domain
    "technology_director": {
        "sources": [
            "https://www.infoworld.com/",
            "https://techcrunch.com/category/enterprise/",
            "https://www.cio.com/",
            "https://aws.amazon.com/architecture/",
            "https://cloud.google.com/docs"
        ],
        "ontology_sources": [
            "https://schema.org/SoftwareApplication",
            "https://www.axelos.com/glossaries-of-terms"  # ITIL Glossary
        ]
    },
    "system_monitoring": {
        "sources": [
            "https://www.datadoghq.com/blog/",
            "https://newrelic.com/blog",
            "https://www.splunk.com/en_us/blog.html"
        ]
    },
    "automation_development": {
        "sources": [
            "https://docs.n8n.io/",
            "https://www.uipath.com/resources",
            "https://www.automationanywhere.com/resources"
        ]
    },
    "performance_optimization": {
        "sources": [
            "https://web.dev/",
            "https://developers.google.com/web/fundamentals/performance",
            "https://aws.amazon.com/blogs/architecture/",
            "https://blog.cloudflare.com/"
        ]
    }
}

# Cross-functional collections
CROSS_FUNCTIONAL_SOURCES = {
    "vividwalls_business_knowledge": {
        "sources": [
            "Company website",
            "About Us pages",
            "Press releases",
            "Annual reports"
        ],
        "internal": True
    },
    "vividwalls_product_catalog": {
        "sources": [
            "Product pages",
            "E-commerce listings",
            "Product catalogs",
            "https://schema.org/Product"
        ],
        "internal": True
    },
    "vividwalls_customer_insights": {
        "sources": [
            "Customer reviews",
            "NPS surveys",
            "Support tickets",
            "Feedback forms"
        ],
        "internal": True
    },
    "vividwalls_market_intelligence": {
        "sources": [
            "https://www.statista.com/",
            "Industry reports",
            "Competitor analysis",
            "Market research firms"
        ]
    }
}

# Ontology-specific sources for building domain taxonomies
ONTOLOGY_RESOURCES = {
    "upper_level": [
        "https://schema.org/",
        "https://www.w3.org/TR/owl2-overview/",
        "http://www.adampease.org/OP/"  # SUMO
    ],
    "domain_specific": {
        "marketing": "https://www.ama.org/marketing-dictionary/",
        "finance": "https://spec.edmcouncil.org/fibo/",
        "product": "https://www.productontology.org/",
        "social": "https://www.w3.org/wiki/SocialMediaOntology"
    },
    "general": [
        "https://www.wikidata.org/",
        "https://en.wikipedia.org/wiki/Portal:Contents"
    ]
}

# RAG configuration recommendations per domain
RAG_CONFIGURATIONS = {
    "ontology_building": {
        "USE_CONTEXTUAL_EMBEDDINGS": "true",
        "USE_HYBRID_SEARCH": "true",
        "USE_AGENTIC_RAG": "false",
        "USE_RERANKING": "true"
    },
    "code_extraction": {
        "USE_CONTEXTUAL_EMBEDDINGS": "true",
        "USE_HYBRID_SEARCH": "false",
        "USE_AGENTIC_RAG": "true",
        "USE_RERANKING": "true"
    },
    "general_knowledge": {
        "USE_CONTEXTUAL_EMBEDDINGS": "true",
        "USE_HYBRID_SEARCH": "true",
        "USE_AGENTIC_RAG": "false",
        "USE_RERANKING": "false"
    }
}

def get_sources_for_agent(agent_id: str) -> dict:
    """Get all relevant sources for a specific agent."""
    sources = {
        "primary": [],
        "ontology": [],
        "cross_functional": []
    }
    
    # Get primary sources
    if agent_id in DOMAIN_AUTHORITY_SOURCES:
        agent_config = DOMAIN_AUTHORITY_SOURCES[agent_id]
        sources["primary"] = agent_config.get("sources", [])
        sources["ontology"] = agent_config.get("ontology_sources", [])
    
    # Add relevant cross-functional sources
    for cf_name, cf_config in CROSS_FUNCTIONAL_SOURCES.items():
        if not cf_config.get("internal", False):
            sources["cross_functional"].extend(cf_config.get("sources", []))
    
    return sources

def get_rag_config_for_task(task_type: str) -> dict:
    """Get RAG configuration for specific task type."""
    return RAG_CONFIGURATIONS.get(task_type, RAG_CONFIGURATIONS["general_knowledge"])

if __name__ == "__main__":
    # Example usage
    print("Domain Authority Sources for VividWalls MAS")
    print("="*50)
    
    # Show sources for marketing director
    marketing_sources = get_sources_for_agent("marketing_director")
    print("\nMarketing Director Sources:")
    print(f"  Primary: {len(marketing_sources['primary'])} sources")
    print(f"  Ontology: {len(marketing_sources['ontology'])} sources")
    print(f"  Cross-functional: {len(marketing_sources['cross_functional'])} sources")
    
    # Show RAG configurations
    print("\nRAG Configurations:")
    for task, config in RAG_CONFIGURATIONS.items():
        print(f"\n{task}:")
        for key, value in config.items():
            print(f"  {key}={value}")