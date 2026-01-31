_Supabase vector store retrieval:

  Director-Level Collections

  marketing_director_vectors
  analytics_director_vectors
  finance_director_vectors
  operations_director_vectors
  customer_experience_director_vectors
  product_director_vectors
  technology_director_vectors
  sales_director_vectors
  social_media_director_vectors

  Specialized Agent Collections

  Marketing Domain

  content_strategy_vectors
  campaign_management_vectors
  creative_execution_vectors
  email_marketing_vectors
  sms_marketing_vectors
  keyword_research_vectors
  copy_writing_vectors

  Sales Domain

  hospitality_sales_vectors
  corporate_sales_vectors
  healthcare_sales_vectors
  retail_sales_vectors
  real_estate_sales_vectors
  homeowner_sales_vectors
  renter_sales_vectors
  interior_designer_sales_vectors
  art_collector_sales_vectors
  gift_buyer_sales_vectors
  millennial_genz_sales_vectors
  global_customer_sales_vectors

  Social Media Domain

  instagram_agent_vectors
  facebook_agent_vectors
  pinterest_agent_vectors

  Analytics Domain

  performance_analytics_vectors
  data_insights_vectors
  campaign_analytics_vectors
  revenue_analytics_vectors

  Operations Domain

  inventory_management_vectors
  fulfillment_analytics_vectors
  supply_chain_vectors
  shopify_integration_vectors

  Customer Experience Domain

  customer_support_vectors
  satisfaction_monitoring_vectors
  customer_sentiment_vectors
  customer_lifecycle_vectors

  Product Domain

  product_strategy_vectors
  market_research_vectors
  product_content_vectors
  art_trend_intelligence_vectors

  Finance Domain

  budget_management_vectors
  roi_analysis_vectors
  financial_calculation_vectors
  budget_intelligence_vectors

  Technology Domain

  system_monitoring_vectors
  integration_management_vectors
  automation_development_vectors
  performance_optimization_vectors

  Cross-Functional Collections

  vividwalls_business_knowledge
  vividwalls_product_catalog
  vividwalls_customer_insights
  vividwalls_market_intelligence

  Each collection should store embeddings with metadata including:
  - agent_id: The agent that created/owns the data
  - content_type: Type of content (policy, procedure, knowledge, etc.)
  - domain: The business domain
  - timestamp: When the embedding was created
  - source: Where the data came from

  To implement these in n8n's Supabase Vector Store node, you would configure
  the collection name based on which agent is accessing the data, ensuring
  proper domain separation and knowledge isolation.