-- Chunk 3 of 4
BEGIN;

INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('46240834-f320-42cd-8156-f2fa7ea7c990', 'Optimize task execution time and resource usage', 'high');

INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('46240834-f320-42cd-8156-f2fa7ea7c990', 'Contribute to departmental success metrics', 'high');

INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('4c5c5bc1-040d-4921-bab3-5403fe26c3e0', 'Complete assigned tasks with high quality', 'high');

INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('4c5c5bc1-040d-4921-bab3-5403fe26c3e0', 'Optimize task execution time and resource usage', 'high');

INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('4c5c5bc1-040d-4921-bab3-5403fe26c3e0', 'Contribute to departmental success metrics', 'high');

INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('0588b12e-6f01-4d7d-895d-63d3910e8270', 'Complete assigned tasks with high quality', 'high');

INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('0588b12e-6f01-4d7d-895d-63d3910e8270', 'Optimize task execution time and resource usage', 'high');

INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('0588b12e-6f01-4d7d-895d-63d3910e8270', 'Contribute to departmental success metrics', 'high');

INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('ab7bb3bc-8f4f-4df8-8d7f-7e9ac133c3a2', 'Complete assigned tasks with high quality', 'high');

INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('ab7bb3bc-8f4f-4df8-8d7f-7e9ac133c3a2', 'Optimize task execution time and resource usage', 'high');

INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('ab7bb3bc-8f4f-4df8-8d7f-7e9ac133c3a2', 'Contribute to departmental success metrics', 'high');

INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('117d5975-929f-4cd5-98aa-74d779e9f664', 'Complete assigned tasks with high quality', 'high');

INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('117d5975-929f-4cd5-98aa-74d779e9f664', 'Optimize task execution time and resource usage', 'high');

INSERT INTO agent_goals (agent_id, goal, priority) VALUES ('117d5975-929f-4cd5-98aa-74d779e9f664', 'Contribute to departmental success metrics', 'high');

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '167bbc92-05c0-4285-91fa-55d8f726011e',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are CustomerExperienceDirectorAgent, responsible for Chief Customer Officer - Support & Retention',
    'Act as CustomerExperienceDirectorAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    'db124b5f-cdc5-44d5-b74a-aea83081df64',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are FinanceDirectorAgent, responsible for Chief Financial Officer - Financial Management & Analysis',
    'Act as FinanceDirectorAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '56f395dc-48ee-421e-996f-53f5f35fa470',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are MarketingDirectorAgent, responsible for Chief Marketing Officer - Customer Acquisition & Brand Growth',
    'Act as MarketingDirectorAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '4f2bdcc2-4e53-41c7-88f0-c4456bb4ef33',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are OperationsDirectorAgent, responsible for Chief Operations Officer - Fulfillment & Supply Chain',
    'Act as OperationsDirectorAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '05188674-63af-476a-b05a-ef374b64979f',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are ProductDirectorAgent, responsible for Chief Product Officer - Catalog & Art Curation',
    'Act as ProductDirectorAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '7de0448a-70ae-4e25-864a-04f71bf84c81',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are TechnologyDirectorAgent, responsible for Chief Technology Officer - Systems & Automation',
    'Act as TechnologyDirectorAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '9adc64aa-b2e1-492b-91b6-8290a6eff2e9',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are BudgetIntelligenceTaskAgent, responsible for BudgetIntelligenceTaskAgent Agent',
    'Act as BudgetIntelligenceTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '6d1fb6a0-5a58-47c6-8768-aff935e16f39',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are CampaignAnalyticsTaskAgent, responsible for CampaignAnalyticsTaskAgent Agent',
    'Act as CampaignAnalyticsTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '5d6b38c8-b5b6-4354-a312-9ab5a858c7a1',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are AgentCommunicationMatrix, responsible for AgentCommunicationMatrix Agent',
    'Act as AgentCommunicationMatrix - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    'ab88bcd7-33ab-4544-b6e8-916b23508a74',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are ArtTrendIntelligenceTaskAgent, responsible for ArtTrendIntelligenceTaskAgent Agent',
    'Act as ArtTrendIntelligenceTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '46d67126-b4e1-40f3-8a73-ae7beaf28ff4',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are AudienceIntelligenceTaskAgent, responsible for AudienceIntelligenceTaskAgent Agent',
    'Act as AudienceIntelligenceTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '0d5e0a14-d703-4fd4-898e-996e4a52e294',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are AutomationDevelopmentTaskAgent, responsible for AutomationDevelopmentTaskAgent Agent',
    'Act as AutomationDevelopmentTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '5d08e634-cf7d-4f82-a2a9-63d9c64aa9b9',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are CreativeContentTaskAgent, responsible for CreativeContentTaskAgent Agent',
    'Act as CreativeContentTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '6da3910e-a5ce-47c8-96e2-9699fe153c1f',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are CustomerLifecycleTaskAgent, responsible for CustomerLifecycleTaskAgent Agent',
    'Act as CustomerLifecycleTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    'e2f91aef-8ebf-4431-8d3b-21bf89e41b7d',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are CustomerSentimentTaskAgent, responsible for CustomerSentimentTaskAgent Agent',
    'Act as CustomerSentimentTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '7af343c8-02e5-4de8-b169-326ce1ef9c60',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are DataExtractionTaskAgent, responsible for DataExtractionTaskAgent Agent',
    'Act as DataExtractionTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '5798712f-c4b4-4ac8-a9b0-1a278eebf894',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are FinancialCalculationTaskAgent, responsible for FinancialCalculationTaskAgent Agent',
    'Act as FinancialCalculationTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '5dd31779-8c6d-452c-aa15-32569c758883',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are FulfillmentAnalyticsTaskAgent, responsible for FulfillmentAnalyticsTaskAgent Agent',
    'Act as FulfillmentAnalyticsTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    'aeaa8ad0-53a2-489c-93ad-d31d350c078b',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are InventoryOptimizationTaskAgent, responsible for InventoryOptimizationTaskAgent Agent',
    'Act as InventoryOptimizationTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '0ed609c8-efe7-46af-9fc7-9938abc35b3e',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are PerformanceOptimizationTaskAgent, responsible for PerformanceOptimizationTaskAgent Agent',
    'Act as PerformanceOptimizationTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    'e18f66d5-ef52-4a6e-aea6-7e693148552b',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are PredictiveModelingTaskAgent, responsible for PredictiveModelingTaskAgent Agent',
    'Act as PredictiveModelingTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '4f93b651-6a2f-440a-a81a-43a3d8083cbe',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are ProductContentTaskAgent, responsible for ProductContentTaskAgent Agent',
    'Act as ProductContentTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '6525191e-7652-415c-a5f2-5ff7a9fe5f22',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are ProductPerformanceTaskAgent, responsible for ProductPerformanceTaskAgent Agent',
    'Act as ProductPerformanceTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    'f53551f4-d825-40f0-bd3c-68686ec5e2ff',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are ReportGenerationTaskAgent, responsible for ReportGenerationTaskAgent Agent',
    'Act as ReportGenerationTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '46240834-f320-42cd-8156-f2fa7ea7c990',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are ResponseGenerationTaskAgent, responsible for ResponseGenerationTaskAgent Agent',
    'Act as ResponseGenerationTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '4c5c5bc1-040d-4921-bab3-5403fe26c3e0',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are RevenueAnalyticsTaskAgent, responsible for RevenueAnalyticsTaskAgent Agent',
    'Act as RevenueAnalyticsTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '0588b12e-6f01-4d7d-895d-63d3910e8270',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are StatisticalAnalysisTaskAgent, responsible for StatisticalAnalysisTaskAgent Agent',
    'Act as StatisticalAnalysisTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    'ab7bb3bc-8f4f-4df8-8d7f-7e9ac133c3a2',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are SupplyChainIntelligenceTaskAgent, responsible for SupplyChainIntelligenceTaskAgent Agent',
    'Act as SupplyChainIntelligenceTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_llm_config (
    agent_id, model, temperature, max_tokens, 
    role_prompt, system_message, additional_params
)
VALUES (
    '117d5975-929f-4cd5-98aa-74d779e9f664',
    'openai/gpt-4-0613',
    0.7,
    2000,
    'You are SystemIntegrationTaskAgent, responsible for SystemIntegrationTaskAgent Agent',
    'Act as SystemIntegrationTaskAgent - be strategic, data-driven, and focused on your departmental objectives.',
    '{"top_p": 0.9, "frequency_penalty": 0.2}'::jsonb
);

INSERT INTO agent_voice_config (
    agent_id, style, tone, pace, provider, 
    description, voice_settings
)
VALUES (
    '167bbc92-05c0-4285-91fa-55d8f726011e',
    'Confident and authoritative',
    'Professional, strategic, and decisive',
    'Moderate',
    'Hume EVI',
    'Voice configuration optimized for Chief Customer Officer - Support & Retention',
    '{"emotion": "confident", "prosody": "balanced"}'::jsonb
);

INSERT INTO agent_voice_config (
    agent_id, style, tone, pace, provider, 
    description, voice_settings
)
VALUES (
    'db124b5f-cdc5-44d5-b74a-aea83081df64',
    'Confident and authoritative',
    'Professional, strategic, and decisive',
    'Moderate',
    'Hume EVI',
    'Voice configuration optimized for Chief Financial Officer - Financial Management & Analysis',
    '{"emotion": "confident", "prosody": "balanced"}'::jsonb
);

INSERT INTO agent_voice_config (
    agent_id, style, tone, pace, provider, 
    description, voice_settings
)
VALUES (
    '56f395dc-48ee-421e-996f-53f5f35fa470',
    'Confident and authoritative',
    'Professional, strategic, and decisive',
    'Moderate',
    'Hume EVI',
    'Voice configuration optimized for Chief Marketing Officer - Customer Acquisition & Brand Growth',
    '{"emotion": "confident", "prosody": "balanced"}'::jsonb
);

INSERT INTO agent_voice_config (
    agent_id, style, tone, pace, provider, 
    description, voice_settings
)
VALUES (
    '4f2bdcc2-4e53-41c7-88f0-c4456bb4ef33',
    'Confident and authoritative',
    'Professional, strategic, and decisive',
    'Moderate',
    'Hume EVI',
    'Voice configuration optimized for Chief Operations Officer - Fulfillment & Supply Chain',
    '{"emotion": "confident", "prosody": "balanced"}'::jsonb
);

INSERT INTO agent_voice_config (
    agent_id, style, tone, pace, provider, 
    description, voice_settings
)
VALUES (
    '05188674-63af-476a-b05a-ef374b64979f',
    'Confident and authoritative',
    'Professional, strategic, and decisive',
    'Moderate',
    'Hume EVI',
    'Voice configuration optimized for Chief Product Officer - Catalog & Art Curation',
    '{"emotion": "confident", "prosody": "balanced"}'::jsonb
);

INSERT INTO agent_voice_config (
    agent_id, style, tone, pace, provider, 
    description, voice_settings
)
VALUES (
    '7de0448a-70ae-4e25-864a-04f71bf84c81',
    'Confident and authoritative',
    'Professional, strategic, and decisive',
    'Moderate',
    'Hume EVI',
    'Voice configuration optimized for Chief Technology Officer - Systems & Automation',
    '{"emotion": "confident", "prosody": "balanced"}'::jsonb
);

INSERT INTO agent_voice_config (
    agent_id, style, tone, pace, provider, 
    description, voice_settings
)
VALUES (
    '9adc64aa-b2e1-492b-91b6-8290a6eff2e9',
    'Clear and efficient',
    'Professional, focused, and helpful',
    'Moderate',
    'Hume EVI',
    'Voice configuration optimized for BudgetIntelligenceTaskAgent Agent',
    '{"emotion": "confident", "prosody": "balanced"}'::jsonb
);

INSERT INTO agent_voice_config (
    agent_id, style, tone, pace, provider, 
    description, voice_settings
)
VALUES (
    '6d1fb6a0-5a58-47c6-8768-aff935e16f39',
    'Clear and efficient',
    'Professional, focused, and helpful',
    'Moderate',
    'Hume EVI',
    'Voice configuration optimized for CampaignAnalyticsTaskAgent Agent',
    '{"emotion": "confident", "prosody": "balanced"}'::jsonb
);

COMMIT;