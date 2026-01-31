# Geographic Income Data Integration Guide

## Overview
This guide documents how VividWalls marketing agents can leverage US county-level household income data for targeted marketing campaigns, market analysis, and strategic planning.

## Data Available

### Core Dataset
- **Coverage**: 3,142 US counties
- **Primary Metric**: Median household income
- **Rankings**: National percentile rankings (1-3,142)
- **Enrichments**: Market tiers, art affinity scores, pricing recommendations

### Key Tables and Views
1. **geographic_income_data**: Main income data table
2. **top_art_markets**: Pre-filtered view of high-potential markets
3. **regional_market_analysis**: Aggregated regional statistics
4. **geographic_targeting_rules**: Campaign targeting templates

## Access Methods for Marketing Agents

### 1. Via Marketing Research Agent
The Marketing Research Agent has direct access to query income data:

```javascript
// In n8n workflow or agent prompt
{
  "action": "query_income_data",
  "parameters": {
    "states": ["California", "New York", "Texas"],
    "min_income": 80000,
    "market_tier": "premium",
    "top_n": 20
  }
}
```

### 2. Direct Database Functions

#### Get Market Intelligence
```sql
SELECT * FROM get_market_intelligence(
    p_states := ARRAY['California', 'Texas'],
    p_min_income := 75000,
    p_top_n := 50
);
```

Returns:
- County name and state
- Median income and rank
- Market tier classification
- Art affinity score (0-10)
- Market potential score (0-10)
- Recommended products
- Messaging themes

#### Get Regional Summary
```sql
SELECT * FROM get_regional_market_summary('West');
```

Returns:
- Regional statistics
- Average income levels
- Premium market counts
- Total addressable market size

### 3. Pre-built Views

#### Top Art Markets
```sql
SELECT * FROM top_art_markets 
WHERE market_tier = 'premium'
ORDER BY median_household_income DESC
LIMIT 20;
```

## Marketing Use Cases

### 1. Campaign Targeting

#### Premium Market Campaign
```yaml
Target: Counties with $100K+ median income
States: CA, VA, NJ, MD, MA
Products: Limited editions, large canvas
Messaging: "Investment-quality art for discerning collectors"
Channels: Instagram, Pinterest, Email
Budget allocation: 60% of total
```

#### Mid-Tier Growth Campaign
```yaml
Target: Counties with $70K-$100K income
Focus: Growing metro areas
Products: Popular collections, medium prints
Messaging: "Transform your space with gallery-quality art"
Channels: Facebook, Instagram, Google Ads
Budget allocation: 30% of total
```

### 2. Geographic Expansion Planning

Identify untapped high-value markets:
```sql
-- Find premium markets where we have low penetration
WITH current_customers AS (
    SELECT DISTINCT county, state 
    FROM customers 
    WHERE total_spent > 500
)
SELECT 
    gid.county_name,
    gid.state_name,
    gid.median_household_income,
    gid.market_potential_score
FROM geographic_income_data gid
WHERE gid.market_tier = 'premium'
    AND NOT EXISTS (
        SELECT 1 FROM current_customers cc
        WHERE cc.county = gid.county_name 
        AND cc.state = gid.state_name
    )
ORDER BY gid.market_potential_score DESC
LIMIT 20;
```

### 3. Pricing Strategy by Geography

```sql
-- Get pricing recommendations by region
SELECT 
    us.region,
    gid.market_tier,
    gid.recommended_price_tier,
    COUNT(*) as county_count,
    AVG(gid.median_household_income) as avg_income
FROM geographic_income_data gid
JOIN us_states us ON gid.state_id = us.id
GROUP BY us.region, gid.market_tier, gid.recommended_price_tier
ORDER BY us.region, avg_income DESC;
```

### 4. Content Personalization

Match content themes to income levels:
- **$120K+**: Emphasize exclusivity, investment value, artist stories
- **$80K-$120K**: Focus on quality, transformation, lifestyle enhancement  
- **$60K-$80K**: Highlight value, versatility, easy updates
- **Under $60K**: Lead with affordability, payment plans, special offers

## Integration with Other MCP Servers

### Shopify Integration
```javascript
// Combine income data with Shopify customer data
const enrichCustomerData = async (customerId) => {
    const customer = await shopifyMCP.getCustomer(customerId);
    const incomeData = await getIncomeByZipCode(customer.zip);
    
    return {
        ...customer,
        county_income: incomeData.median_income,
        market_tier: incomeData.market_tier,
        recommended_products: incomeData.product_recommendations
    };
};
```

### Email Marketing Segmentation
```javascript
// Segment email list by geographic income
const segmentByIncome = async () => {
    const segments = {
        premium: { min_income: 100000, list_id: 'premium_list' },
        mid: { min_income: 70000, max_income: 100000, list_id: 'mid_list' },
        value: { max_income: 70000, list_id: 'value_list' }
    };
    
    // Process each segment
    for (const [tier, config] of Object.entries(segments)) {
        const counties = await queryIncomeData(config);
        await emailMCP.updateSegment(config.list_id, counties);
    }
};
```

## Campaign Examples

### 1. "Luxury Coastal Collection" Campaign
**Target**: Top 50 coastal counties by income
**Products**: $800-$2000 limited editions
**Channels**: Instagram + Direct mail
**Messaging**: "Exclusive art for exceptional homes"

### 2. "Urban Professional" Campaign  
**Target**: 25-45 age group in $75K+ metro counties
**Products**: $300-$600 modern abstracts
**Channels**: LinkedIn + Instagram
**Messaging**: "Elevate your workspace"

### 3. "American Heartland" Campaign
**Target**: Midwest counties, $50K-$80K income
**Products**: $100-$300 Americana themes
**Channels**: Facebook + Email
**Messaging**: "Celebrate local beauty"

## Performance Tracking

### Key Metrics by Geographic Segment
1. **Conversion Rate by Income Tier**
   - Premium markets: Target 3-5%
   - Mid-tier markets: Target 2-3%
   - Value markets: Target 1-2%

2. **Average Order Value by County Income**
   - Track correlation between income and AOV
   - Adjust product mix based on performance

3. **Customer Lifetime Value by Geography**
   - Identify highest CLV regions
   - Invest more in high-value geographic segments

### ROI Analysis Query
```sql
SELECT 
    gid.market_tier,
    COUNT(DISTINCT o.order_id) as orders,
    SUM(o.total_amount) as revenue,
    AVG(o.total_amount) as avg_order_value,
    SUM(c.marketing_spend) / SUM(o.total_amount) as roi
FROM orders o
JOIN customers cust ON o.customer_id = cust.id
JOIN geographic_income_data gid 
    ON cust.county = gid.county_name 
    AND cust.state = gid.state_name
JOIN campaigns c ON o.campaign_id = c.id
WHERE o.created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY gid.market_tier;
```

## Best Practices

### 1. Data Privacy
- Never expose individual income data
- Use aggregated statistics only
- Comply with geographic targeting regulations

### 2. Avoid Stereotyping
- Income is one factor among many
- Consider multiple data points
- Test assumptions with real data

### 3. Regular Updates
- Refresh materialized views monthly
- Update income data annually
- Track demographic shifts

### 4. Testing Strategy
- A/B test messaging by income tier
- Validate assumptions with small tests
- Scale what works, stop what doesn't

## Quick Reference

### Income Tiers
- **Premium**: $100K+ (101 counties)
- **Mid**: $70K-$100K (~500 counties)  
- **Value**: Under $70K (~2,500 counties)

### Top 10 Counties by Income
1. Loudoun County, VA - $147,000
2. Falls Church, VA - $146,000
3. Santa Clara County, CA - $130,000
4. San Mateo County, CA - $128,000
5. Fairfax County, VA - $127,000
6. Howard County, MD - $124,000
7. Arlington County, VA - $122,000
8. Marin County, CA - $121,000
9. Douglas County, CO - $121,000
10. Nassau County, NY - $120,000

### Regional Insights
- **Northeast**: Highest concentration of premium markets
- **West**: Largest premium market counties (CA)
- **South**: Fastest growing premium segment (TX, VA)
- **Midwest**: Strong mid-tier opportunities

## Next Steps

1. **Import the data**: Run `python scripts/import_income_data.py`
2. **Test queries**: Try the example queries in this guide
3. **Create segments**: Build your first income-based audience
4. **Launch campaign**: Start with a small geographic test
5. **Measure results**: Track performance by income tier
6. **Scale success**: Expand to similar markets

## Support

For questions about geographic income data:
- Check the `geographic_income_data` table schema
- Review the `top_art_markets` view
- Consult the Marketing Research Agent
- Run test queries in Supabase dashboard