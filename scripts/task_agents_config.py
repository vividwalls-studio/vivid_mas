#!/usr/bin/env python3
"""
Task-specific agent configurations with domain authorities for VividWalls MAS
"""

TASK_AGENTS_CONFIG = {
    "task_agents": [
        # Marketing Task Agents (3)
        {
            "id": "46d67126-b4e1-40f3-8a73-ae7beaf28ff4",
            "name": "AudienceIntelligenceTaskAgent",
            "role": "Audience Intelligence Agent",
            "reports_to": "56f395dc-48ee-421e-996f-53f5f35fa470",  # Marketing Director
            "domains": [
                {"url": "https://www.socialmediaexaminer.com/", "name": "Social Media Examiner", "topics": ["audience insights", "social targeting"]},
                {"url": "https://neilpatel.com/blog/", "name": "Neil Patel", "topics": ["audience segmentation", "customer profiling"]},
                {"url": "https://blog.hubspot.com/marketing", "name": "HubSpot Marketing", "topics": ["buyer personas", "audience analysis"]}
            ]
        },
        {
            "id": "6d1fb6a0-5a58-47c6-8768-aff935e16f39",
            "name": "CampaignAnalyticsTaskAgent", 
            "role": "Campaign Analytics Agent",
            "reports_to": "56f395dc-48ee-421e-996f-53f5f35fa470",  # Marketing Director
            "domains": [
                {"url": "https://www.kaushik.net/avinash/", "name": "Occam's Razor", "topics": ["campaign metrics", "analytics"]},
                {"url": "https://conversionxl.com/blog/", "name": "ConversionXL", "topics": ["conversion optimization", "A/B testing"]},
                {"url": "https://www.analyticsmania.com/", "name": "Analytics Mania", "topics": ["campaign tracking", "attribution"]}
            ]
        },
        {
            "id": "5d08e634-cf7d-4f82-a2a9-63d9c64aa9b9",
            "name": "CreativeContentTaskAgent",
            "role": "Creative Content Agent",
            "reports_to": "56f395dc-48ee-421e-996f-53f5f35fa470",  # Marketing Director
            "domains": [
                {"url": "https://copyblogger.com/", "name": "Copyblogger", "topics": ["copywriting", "content creation"]},
                {"url": "https://www.copyhackers.com/", "name": "Copy Hackers", "topics": ["ad copy", "conversion copy"]},
                {"url": "https://unbounce.com/blog/", "name": "Unbounce", "topics": ["landing pages", "creative optimization"]}
            ]
        },
        
        # Analytics Task Agents (5)
        {
            "id": "9adc64aa-b2e1-492b-91b6-8290a6eff2e9",
            "name": "BudgetIntelligenceTaskAgent",
            "role": "Budget Intelligence Agent",
            "reports_to": "9adc64aa-b2e1-492b-91b6-8290a6eff2e9",  # Analytics Director
            "domains": [
                {"url": "https://www.profitwell.com/customer-acquisition-cost", "name": "ProfitWell", "topics": ["budget optimization", "CAC analysis"]},
                {"url": "https://www.klipfolio.com/resources", "name": "Klipfolio", "topics": ["budget metrics", "financial KPIs"]},
                {"url": "https://baremetrics.com/blog", "name": "Baremetrics", "topics": ["SaaS metrics", "budget planning"]}
            ]
        },
        {
            "id": "6da3910e-a5ce-47c8-96e2-9699fe153c1f",
            "name": "CustomerLifecycleTaskAgent",
            "role": "Customer Lifecycle Agent",
            "reports_to": "9adc64aa-b2e1-492b-91b6-8290a6eff2e9",  # Analytics Director
            "domains": [
                {"url": "https://amplitude.com/blog", "name": "Amplitude", "topics": ["customer lifecycle", "retention analytics"]},
                {"url": "https://www.reforge.com/blog", "name": "Reforge", "topics": ["growth metrics", "LTV optimization"]},
                {"url": "https://www.chaotic-flow.com/", "name": "Chaotic Flow", "topics": ["subscription metrics", "churn analysis"]}
            ]
        },
        {
            "id": "e18f66d5-ef52-4a6e-aea6-7e693148552b",
            "name": "PredictiveModelingTaskAgent",
            "role": "Predictive Modeling Agent",
            "reports_to": "9adc64aa-b2e1-492b-91b6-8290a6eff2e9",  # Analytics Director
            "domains": [
                {"url": "https://machinelearningmastery.com/", "name": "Machine Learning Mastery", "topics": ["predictive models", "forecasting"]},
                {"url": "https://www.datasciencecentral.com/", "name": "Data Science Central", "topics": ["ML algorithms", "predictive analytics"]},
                {"url": "https://www.analyticsvidhya.com/blog/", "name": "Analytics Vidhya", "topics": ["data modeling", "predictions"]}
            ]
        },
        {
            "id": "4c5c5bc1-040d-4921-bab3-5403fe26c3e0",
            "name": "RevenueAnalyticsTaskAgent",
            "role": "Revenue Analytics Agent",
            "reports_to": "9adc64aa-b2e1-492b-91b6-8290a6eff2e9",  # Analytics Director
            "domains": [
                {"url": "https://www.saasmetrics.co/", "name": "SaaS Metrics", "topics": ["revenue analytics", "MRR/ARR"]},
                {"url": "https://chartmogul.com/blog/", "name": "ChartMogul", "topics": ["revenue recognition", "growth metrics"]},
                {"url": "https://www.geckoboard.com/blog/", "name": "Geckoboard", "topics": ["revenue dashboards", "KPI tracking"]}
            ]
        },
        {
            "id": "0588b12e-6f01-4d7d-895d-63d3910e8270",
            "name": "StatisticalAnalysisTaskAgent",
            "role": "Statistical Analysis Agent",
            "reports_to": "9adc64aa-b2e1-492b-91b6-8290a6eff2e9",  # Analytics Director
            "domains": [
                {"url": "https://www.evanmiller.org/", "name": "Evan Miller", "topics": ["A/B testing statistics", "statistical significance"]},
                {"url": "https://stats.stackexchange.com/", "name": "Cross Validated", "topics": ["statistical methods", "data analysis"]},
                {"url": "https://www.optimizely.com/optimization-glossary/", "name": "Optimizely", "topics": ["experimentation", "statistics"]}
            ]
        },
        
        # Product Task Agents (3)
        {
            "id": "ab88bcd7-33ab-4544-b6e8-916b23508a74",
            "name": "ArtTrendIntelligenceTaskAgent",
            "role": "Art Trend Intelligence Agent",
            "reports_to": "05188674-63af-476a-b05a-ef374b64979f",  # Product Director
            "domains": [
                {"url": "https://www.artnet.com/", "name": "Artnet", "topics": ["art trends", "market analysis"]},
                {"url": "https://www.artnews.com/", "name": "ARTnews", "topics": ["contemporary art", "trend reports"]},
                {"url": "https://www.designboom.com/", "name": "Designboom", "topics": ["design trends", "visual arts"]}
            ]
        },
        {
            "id": "4f93b651-6a2f-440a-a81a-43a3d8083cbe",
            "name": "ProductContentTaskAgent",
            "role": "Product Content Agent",
            "reports_to": "05188674-63af-476a-b05a-ef374b64979f",  # Product Director
            "domains": [
                {"url": "https://www.salsify.com/blog", "name": "Salsify", "topics": ["product content", "PIM best practices"]},
                {"url": "https://www.bigcommerce.com/ecommerce-answers/", "name": "BigCommerce", "topics": ["product descriptions", "SEO"]},
                {"url": "https://www.shopify.com/blog", "name": "Shopify Blog", "topics": ["product pages", "content optimization"]}
            ]
        },
        {
            "id": "6525191e-7652-415c-a5f2-5ff7a9fe5f22",
            "name": "ProductPerformanceTaskAgent",
            "role": "Product Performance Agent",
            "reports_to": "05188674-63af-476a-b05a-ef374b64979f",  # Product Director
            "domains": [
                {"url": "https://www.productboard.com/blog/", "name": "Productboard", "topics": ["product analytics", "performance metrics"]},
                {"url": "https://www.pendo.io/pendo-blog/", "name": "Pendo", "topics": ["product usage", "feature adoption"]},
                {"url": "https://www.mixpanel.com/blog/", "name": "Mixpanel", "topics": ["product metrics", "user behavior"]}
            ]
        },
        
        # Customer Task Agents (2)
        {
            "id": "e2f91aef-8ebf-4431-8d3b-21bf89e41b7d",
            "name": "CustomerSentimentTaskAgent",
            "role": "Customer Sentiment Agent",
            "reports_to": "167bbc92-05c0-4285-91fa-55d8f726011e",  # Customer Experience Director
            "domains": [
                {"url": "https://www.lexalytics.com/lexablog", "name": "Lexalytics", "topics": ["sentiment analysis", "text analytics"]},
                {"url": "https://monkeylearn.com/blog/", "name": "MonkeyLearn", "topics": ["NLP", "customer feedback analysis"]},
                {"url": "https://www.brandwatch.com/blog/", "name": "Brandwatch", "topics": ["social sentiment", "brand monitoring"]}
            ]
        },
        {
            "id": "46240834-f320-42cd-8156-f2fa7ea7c990",
            "name": "ResponseGenerationTaskAgent",
            "role": "Response Generation Agent",
            "reports_to": "167bbc92-05c0-4285-91fa-55d8f726011e",  # Customer Experience Director
            "domains": [
                {"url": "https://www.groovehq.com/blog", "name": "Groove", "topics": ["customer service templates", "response strategies"]},
                {"url": "https://www.intercom.com/blog/", "name": "Intercom", "topics": ["customer messaging", "support automation"]},
                {"url": "https://www.kayako.com/blog/", "name": "Kayako", "topics": ["help desk", "response optimization"]}
            ]
        },
        
        # Operations Task Agents (4)
        {
            "id": "5dd31779-8c6d-452c-aa15-32569c758883",
            "name": "FulfillmentAnalyticsTaskAgent",
            "role": "Fulfillment Analytics Agent",
            "reports_to": "4f2bdcc2-4e53-41c7-88f0-c4456bb4ef33",  # Operations Director
            "domains": [
                {"url": "https://www.shipbob.com/blog/", "name": "ShipBob", "topics": ["fulfillment metrics", "3PL insights"]},
                {"url": "https://www.easypost.com/blog", "name": "EasyPost", "topics": ["shipping analytics", "carrier optimization"]},
                {"url": "https://www.freightos.com/freight-resources/", "name": "Freightos", "topics": ["logistics analytics", "shipping costs"]}
            ]
        },
        {
            "id": "aeaa8ad0-53a2-489c-93ad-d31d350c078b",
            "name": "InventoryOptimizationTaskAgent",
            "role": "Inventory Optimization Agent",
            "reports_to": "4f2bdcc2-4e53-41c7-88f0-c4456bb4ef33",  # Operations Director
            "domains": [
                {"url": "https://www.inventoryops.com/", "name": "Inventory Ops", "topics": ["inventory management", "optimization strategies"]},
                {"url": "https://www.tradegecko.com/blog", "name": "TradeGecko", "topics": ["inventory control", "demand planning"]},
                {"url": "https://www.skubana.com/blog", "name": "Skubana", "topics": ["multichannel inventory", "stock optimization"]}
            ]
        },
        {
            "id": "ab7bb3bc-8f4f-4df8-8d7f-7e9ac133c3a2",
            "name": "SupplyChainIntelligenceTaskAgent",
            "role": "Supply Chain Intelligence Agent",
            "reports_to": "4f2bdcc2-4e53-41c7-88f0-c4456bb4ef33",  # Operations Director
            "domains": [
                {"url": "https://www.scmworld.com/", "name": "SCM World", "topics": ["supply chain trends", "best practices"]},
                {"url": "https://www.supplychainquarterly.com/", "name": "Supply Chain Quarterly", "topics": ["SCM strategies", "risk management"]},
                {"url": "https://www.inboundlogistics.com/", "name": "Inbound Logistics", "topics": ["supplier management", "logistics"]}
            ]
        },
        {
            "id": "7af343c8-02e5-4de8-b169-326ce1ef9c60",
            "name": "DataExtractionTaskAgent",
            "role": "Data Extraction Agent",
            "reports_to": "4f2bdcc2-4e53-41c7-88f0-c4456bb4ef33",  # Operations Director
            "domains": [
                {"url": "https://www.import.io/blog/", "name": "Import.io", "topics": ["web scraping", "data extraction"]},
                {"url": "https://blog.apify.com/", "name": "Apify", "topics": ["automation", "data collection"]},
                {"url": "https://www.parsehub.com/blog/", "name": "ParseHub", "topics": ["data parsing", "API integration"]}
            ]
        },
        
        # Technology Task Agents (4)
        {
            "id": "0d5e0a14-d703-4fd4-898e-996e4a52e294",
            "name": "AutomationDevelopmentTaskAgent",
            "role": "Automation Development Agent",
            "reports_to": "7de0448a-70ae-4e25-864a-04f71bf84c81",  # Technology Director
            "domains": [
                {"url": "https://n8n.io/blog/", "name": "n8n Blog", "topics": ["workflow automation", "n8n tutorials"]},
                {"url": "https://zapier.com/blog/", "name": "Zapier", "topics": ["automation patterns", "integration recipes"]},
                {"url": "https://www.make.com/en/blog", "name": "Make", "topics": ["automation workflows", "no-code solutions"]}
            ]
        },
        {
            "id": "0ed609c8-efe7-46af-9fc7-9938abc35b3e",
            "name": "PerformanceOptimizationTaskAgent",
            "role": "Performance Optimization Agent",
            "reports_to": "7de0448a-70ae-4e25-864a-04f71bf84c81",  # Technology Director
            "domains": [
                {"url": "https://web.dev/blog/", "name": "web.dev", "topics": ["web performance", "optimization techniques"]},
                {"url": "https://www.webpagetest.org/forums/", "name": "WebPageTest", "topics": ["performance testing", "metrics"]},
                {"url": "https://csswizardry.com/", "name": "CSS Wizardry", "topics": ["frontend performance", "optimization"]}
            ]
        },
        {
            "id": "117d5975-929f-4cd5-98aa-74d779e9f664",
            "name": "SystemIntegrationTaskAgent",
            "role": "System Integration Agent",
            "reports_to": "7de0448a-70ae-4e25-864a-04f71bf84c81",  # Technology Director
            "domains": [
                {"url": "https://www.mulesoft.com/resources/", "name": "MuleSoft", "topics": ["API integration", "system connectivity"]},
                {"url": "https://www.tibco.com/blog", "name": "TIBCO", "topics": ["integration patterns", "middleware"]},
                {"url": "https://tray.io/blog/", "name": "Tray.io", "topics": ["iPaaS", "integration automation"]}
            ]
        },
        {
            "id": "f53551f4-d825-40f0-bd3c-68686ec5e2ff",
            "name": "ReportGenerationTaskAgent",
            "role": "Report Generation Agent",
            "reports_to": "7de0448a-70ae-4e25-864a-04f71bf84c81",  # Technology Director
            "domains": [
                {"url": "https://www.tableau.com/learn", "name": "Tableau", "topics": ["data visualization", "dashboards"]},
                {"url": "https://powerbi.microsoft.com/en-us/blog/", "name": "Power BI", "topics": ["reporting tools", "BI solutions"]},
                {"url": "https://www.sisense.com/blog/", "name": "Sisense", "topics": ["analytics reporting", "data storytelling"]}
            ]
        },
        
        # Finance Task Agents (2)
        {
            "id": "5798712f-c4b4-4ac8-a9b0-1a278eebf894",
            "name": "FinancialCalculationTaskAgent",
            "role": "Financial Calculation Agent",
            "reports_to": "db124b5f-cdc5-44d5-b74a-aea83081df64",  # Finance Director
            "domains": [
                {"url": "https://www.wallstreetmojo.com/", "name": "WallStreetMojo", "topics": ["financial modeling", "calculations"]},
                {"url": "https://corporatefinanceinstitute.com/resources/", "name": "CFI", "topics": ["financial analysis", "valuation"]},
                {"url": "https://www.investopedia.com/", "name": "Investopedia", "topics": ["financial formulas", "metrics"]}
            ]
        }
    ]
}