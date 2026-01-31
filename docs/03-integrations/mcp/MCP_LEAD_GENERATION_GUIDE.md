# MCP Lead Generation Guide for Marketing Agents

## Overview

The email marketing MCP servers now include comprehensive lead generation capabilities that integrate VividWalls' customer segments with geographic income data. This guide explains how to use these features.

## Available MCP Servers

### 1. email-marketing-prompts
**Purpose**: Generate prompts and execute tools for lead generation
**Key Features**:
- Lead generation email campaign prompts
- LinkedIn outreach sequence prompts
- Query generation tools

### 2. email-marketing-resource
**Purpose**: Access customer segments and lead generation data
**Key Features**:
- Customer segment profiles with search keywords
- Email scraping query templates
- LinkedIn query generation logic

## Resources

### Customer Segments Resource
```
@email-marketing-resource:email://segments/customer-segments
```
Access complete customer segmentation data including:
- Demographics and psychographics
- Search keywords for email and LinkedIn
- Needs and preferences

**Filtering Examples**:
```javascript
// Get specific segment
filter: { segmentId: "interior_designers" }

// Get all search keywords
filter: { type: "search_keywords" }
```

### Email Scraping Resource
```
@email-marketing-resource:email://lead-generation/email-scraping
```
Generate location-based email queries with:
- Dynamic segment targeting
- Income-based prioritization
- Keyword variations per segment

### LinkedIn Queries Resource
```
@email-marketing-resource:email://lead-generation/linkedin-queries
```
Generate LinkedIn search queries with:
- Job position targeting
- Industry filtering
- Geographic prioritization

## Tools

### generate-email-queries
Generate email scraping queries for specific locations and segments.

**Parameters**:
- `locations`: Array of {county, state} objects
- `targetSegment`: Customer segment ID
- `limit`: Maximum queries to generate

**Example**:
```json
{
  "tool": "generate-email-queries",
  "inputs": {
    "locations": [
      {"county": "Loudoun County", "state": "Virginia"},
      {"county": "Santa Clara County", "state": "California"}
    ],
    "targetSegment": "interior_designers",
    "limit": 100
  }
}
```

### generate-linkedin-queries
Generate LinkedIn search queries for B2B outreach.

**Parameters**:
- `targetSegment`: Customer segment ID
- `count`: Number of queries
- `geographicFocus`: "premium" or "all"

**Example**:
```json
{
  "tool": "generate-linkedin-queries",
  "inputs": {
    "targetSegment": "commercial_buyers",
    "count": 100,
    "geographicFocus": "premium"
  }
}
```

## Prompts

### lead-generation-email-campaign
Create targeted email campaigns based on customer segments and geography.

**Arguments**:
- `targetSegment`: Customer segment to target
- `geographicTier`: Income tier (premium_markets, mid_tier_markets, value_markets)
- `campaignObjective`: Primary objective
- `incomeData`: Optional income-based targeting data

### linkedin-outreach-sequence
Create LinkedIn message sequences for B2B outreach.

**Arguments**:
- `jobPositions`: Array of positions to target
- `industries`: Target industries
- `messageCount`: Number of messages in sequence
- `valueProposition`: Key value prop

## Customer Segments

### Interior Designers (40% focus)
- **Keywords**: interior design company, design firm, design studio
- **LinkedIn**: Interior Designer, Design Consultant, Commercial Designer
- **Best for**: Premium and mid-tier markets

### Commercial Buyers (30% focus)
- **Keywords**: commercial property, hotel management, healthcare facility
- **LinkedIn**: Procurement Manager, Facilities Manager, Art Director
- **Best for**: All market tiers

### Individual Collectors (20% focus)
- **Keywords**: luxury home, premium real estate, upscale residential
- **LinkedIn**: Art Collector, Luxury Homeowner
- **Best for**: Premium markets only

### VIP Customers (10% focus)
- **Keywords**: luxury concierge, private collection, exclusive membership
- **LinkedIn**: Art Patron, High Net Worth
- **Best for**: Premium markets only

## Geographic Prioritization

### Premium Markets (>$100K median income)
- **Budget Allocation**: 40%
- **Target Segments**: All segments
- **Example Counties**: Loudoun (VA), Santa Clara (CA), Fairfax (VA)

### Mid-Tier Markets ($70K-$100K)
- **Budget Allocation**: 35%
- **Target Segments**: Interior designers, commercial buyers
- **Focus**: Professional and B2B segments

### Value Markets (<$70K)
- **Budget Allocation**: 25%
- **Target Segments**: Commercial buyers only
- **Focus**: Bulk orders and institutional sales

## Workflow Example

```javascript
// 1. Load high-income locations from database
const locations = await db.query('SELECT * FROM geographic_income_data WHERE median_income > 100000');

// 2. Generate email queries for interior designers
const emailQueries = await mcp.tools.generateEmailQueries({
  locations: locations,
  targetSegment: 'interior_designers',
  limit: 200
});

// 3. Generate LinkedIn queries for commercial buyers
const linkedinQueries = await mcp.tools.generateLinkedInQueries({
  targetSegment: 'commercial_buyers',
  count: 100,
  geographicFocus: 'premium'
});

// 4. Create targeted email campaign
const campaign = await mcp.prompts.leadGenerationEmailCampaign({
  targetSegment: 'interior_designers',
  geographicTier: 'premium_markets',
  campaignObjective: 'lead_capture'
});
```

## Best Practices

1. **Segment Alignment**: Always align geographic targeting with segment characteristics
2. **Budget Efficiency**: Focus premium segments on high-income areas
3. **Query Diversity**: Use multiple keywords per segment for broader reach
4. **Integration**: Combine email and LinkedIn for multi-channel campaigns
5. **Testing**: Start with smaller batches to test response rates

## Integration with Other Systems

- **Supabase**: Store generated queries and track campaign performance
- **Shopify**: Sync customer data for segment validation
- **Analytics**: Track conversion rates by segment and geography
- **CRM**: Import leads and track through sales funnel

This comprehensive lead generation system ensures marketing efforts are precisely targeted to the right audiences in the right locations with the right messaging.