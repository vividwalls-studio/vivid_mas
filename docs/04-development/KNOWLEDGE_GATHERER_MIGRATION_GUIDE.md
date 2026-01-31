# Knowledge Gatherer Migration Guide

## Overview

This guide explains how to migrate existing knowledge gatherer workflows to use the unified template, reducing maintenance burden and ensuring consistency.

## Current State

### Active Knowledge Gatherers (4)
1. `marketing_knowledge_gatherer_agent.json` - domains/marketing/
2. `customer_experience_knowledge_gatherer_agent.json` - utilities/
3. `finance_analytics_knowledge_gatherer_agent.json` - utilities/
4. `operations_knowledge_gatherer_agent.json` - utilities/

### Archived Knowledge Gatherers (5)
1. `facebook_marketing_knowledge_gatherer_agent.json` - duplicates/
2. `instagram_marketing_knowledge_gatherer_agent.json` - duplicates/
3. `pinterest_marketing_knowledge_gatherer_agent.json` - duplicates/
4. `copywriting_knowledge_gatherer_agent.json` - needs_fixing/
5. `technology_automation_knowledge_gatherer_agent.json` - needs_fixing/

## Migration Strategy

### Phase 1: Template Validation
1. Import `knowledge_gatherer_template.json` into n8n
2. Test with sample configuration
3. Verify all components work correctly

### Phase 2: Migrate Active Gatherers
For each active knowledge gatherer:

1. **Export current data**
   - Note any custom extraction logic
   - Document unique source URLs
   - Save scheduling preferences

2. **Create domain instance**
   - Copy template workflow in n8n
   - Apply domain-specific configuration from `knowledge_gatherer_configs.json`
   - Add any custom logic to the "Extract Domain Knowledge" node

3. **Test migration**
   - Run workflow manually
   - Verify data extraction quality
   - Check Supabase storage

4. **Replace original**
   - Deactivate old workflow
   - Activate new template-based workflow
   - Archive original JSON file

### Phase 3: Fix and Migrate Broken Gatherers
1. **Copywriting Knowledge Gatherer**
   - Fix JSON syntax errors (escaped quotes issue)
   - Extract custom logic for copy formulas
   - Integrate into template with copywriting config

2. **Technology Automation Knowledge Gatherer**
   - Fix JSON syntax errors
   - Extract automation-specific patterns
   - Integrate into template with technology config

### Phase 4: Consolidate Platform-Specific Gatherers
The Facebook, Instagram, and Pinterest gatherers can be consolidated into a single social media knowledge gatherer using the template with rotating source URLs.

## Implementation Steps

### Step 1: Create Base Template Instances
```bash
# In n8n UI:
1. Import knowledge_gatherer_template.json
2. Duplicate for each domain needed
3. Configure using knowledge_gatherer_configs.json values
```

### Step 2: Customize Domain Logic
For each domain, update the "Extract Domain Knowledge" code node with specific patterns:

```javascript
// Example for Marketing domain
const marketingPatterns = {
  keywords: ['campaign', 'audience', 'conversion', 'engagement', 'ROI'],
  extraction_rules: [
    { pattern: /campaign.*results/gi, category: 'campaign_performance' },
    { pattern: /audience.*targeting/gi, category: 'audience_insights' }
  ]
};
```

### Step 3: Configure Sources
Update the "Configure Parameters" node with domain-specific sources:

```javascript
const domainSources = {
  marketing: [
    'https://blog.hubspot.com/marketing',
    'https://contentmarketinginstitute.com/'
  ],
  operations: [
    'https://www.mckinsey.com/capabilities/operations/our-insights'
  ]
};
```

## Benefits of Migration

1. **Reduced Maintenance**: 1 template vs 9+ individual workflows
2. **Consistency**: All gatherers follow same pattern
3. **Easier Updates**: Change template once, affects all domains
4. **Better Testing**: Single template to validate
5. **Configuration Management**: Centralized in configs file

## Post-Migration Cleanup

1. Archive all original knowledge gatherer JSON files
2. Update documentation to reference template
3. Create monitoring dashboard for all gatherers
4. Document any domain-specific customizations

## Template Extension

To add new domains:
1. Add configuration to `knowledge_gatherer_configs.json`
2. Create new instance from template
3. Apply configuration
4. Test and activate

## Maintenance Schedule

- Monthly: Review source URLs for relevance
- Quarterly: Update extraction patterns
- Annually: Evaluate new domains to add