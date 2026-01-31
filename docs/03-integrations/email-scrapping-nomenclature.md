# Email Scraping Nomenclature for VividWalls Customer Segments

## Overview
This document defines the dynamic email scraping nomenclature system that adapts to VividWalls' customer segments and geographic income data. The system generates targeted search queries based on customer segment priorities and market income levels.

## Customer Segments Configuration
The system uses the customer segments defined in `/data/customer_segments_config.json`:
- **Individual Art Collectors** (Primary)
- **Interior Designers** (Professional)
- **Commercial Buyers** (Enterprise)
- **VIP Customers** (High-Value)

## Dynamic Query Generation System

### Base Nomenclature Pattern
```
<location_name>+<state>+area+<target_audience_keyword>
```

### Variable Components

1. **Target Audience Keywords** (Dynamic based on customer segment):
   - Interior Designers: `interior+design+company`, `interior+design+firm`, `design+studio`
   - Commercial Buyers: `commercial+property`, `hotel+management`, `corporate+office`
   - Individual Collectors: `luxury+home`, `premium+real+estate`, `upscale+residential`
   - VIP Customers: `luxury+concierge`, `private+collection`, `exclusive+club`

2. **Geographic Prioritization**:
   - Premium Markets (>$100K median income): High priority
   - Mid-tier Markets ($70K-$100K): Medium priority
   - Value Markets (<$70K): Low priority

### Implementation Structure

```json
{
  "query_template": {
    "pattern": "<location>+<state>+area+<segment_keyword>",
    "segments": {
      "interior_designers": [
        "interior+design+company",
        "interior+design+firm",
        "design+studio",
        "design+consultancy"
      ],
      "commercial_buyers": [
        "commercial+property",
        "hotel+management",
        "healthcare+facility",
        "corporate+office",
        "restaurant+group"
      ],
      "individual_collectors": [
        "luxury+home",
        "high+end+residential",
        "premium+real+estate",
        "upscale+home"
      ],
      "vip_customers": [
        "luxury+concierge",
        "private+collection",
        "exclusive+membership",
        "high+end+clientele"
      ]
    }
  }
}
```

### Example Outputs by Segment

#### Interior Designers Focus:
```json
[
  {"query": "loudoun+county+virginia+area+interior+design+company"},
  {"query": "falls+church+virginia+area+interior+design+firm"},
  {"query": "santa+clara+county+california+area+design+studio"}
]
```

#### Commercial Buyers Focus:
```json
[
  {"query": "loudoun+county+virginia+area+commercial+property"},
  {"query": "falls+church+virginia+area+hotel+management"},
  {"query": "santa+clara+county+california+area+corporate+office"}
]
```

#### Individual Collectors Focus:
```json
[
  {"query": "loudoun+county+virginia+area+luxury+home"},
  {"query": "falls+church+virginia+area+premium+real+estate"},
  {"query": "santa+clara+county+california+area+upscale+residential"}
]
```

### Programmatic Usage

```python
import json

# Load customer segments configuration
with open('data/customer_segments_config.json', 'r') as f:
    config = json.load(f)

def generate_queries(locations, target_segment='interior_designers'):
    """Generate search queries for specific customer segment"""
    queries = []
    keywords = config['customer_segments'][target_segment]['search_keywords']['email']
    
    for location in locations:
        for keyword in keywords:
            query = f"{location['county']}+{location['state']}+area+{keyword.replace(' ', '+')}"
            queries.append({"query": query.lower()})
    
    return queries
```

### Integration with Income Data

The system integrates with geographic income data to prioritize high-value markets:

1. **Premium Markets** (>$100K median income):
   - Generate queries for all customer segments
   - Higher frequency of campaign targeting
   - Focus on luxury and high-end keywords

2. **Mid-tier Markets** ($70K-$100K):
   - Focus on interior designers and commercial buyers
   - Standard keyword variations

3. **Value Markets** (<$70K):
   - Limited targeting
   - Focus on commercial and bulk buyers

### Marketing Agent Usage

Marketing agents can dynamically select target audiences:

```javascript
// Example: Marketing Research Agent selecting target segment
const targetSegment = agent.selectOptimalSegment({
  location: "Loudoun County, Virginia",
  income_level: 147111,
  campaign_objective: "premium_art_sales"
});

const queries = generateQueries(locations, targetSegment);
```

## Formatting Guidelines

1. **Lowercase**: All terms must be lowercase
2. **Plus Signs**: Replace all spaces with `+`
3. **Order**: Location → State → "area" → Segment Keywords
4. **JSON Format**: Output as array of objects with "query" property

## Multi-Segment Campaign Example

For comprehensive market coverage, generate queries across all segments:

```json
{
  "campaign": "Q1_2024_Premium_Markets",
  "target_locations": ["Top 20 highest income counties"],
  "segment_allocation": {
    "interior_designers": "40%",
    "commercial_buyers": "30%",
    "individual_collectors": "20%",
    "vip_customers": "10%"
  },
  "total_queries": 400
}
```

This dynamic system ensures marketing efforts align with VividWalls' customer segmentation strategy while leveraging geographic income data for optimal targeting.