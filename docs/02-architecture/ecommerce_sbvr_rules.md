# VividWalls E-Commerce SBVR Rule Set

This document defines the SBVR (Semantics of Business Vocabulary and Business Rules) rules for the VividWalls e-commerce platform in a format that can be parsed and loaded into the system.

## Product Management Rules

### Art Print Classification

```sbvr
Rule Type: Structural
ID: art-print-classification
Formulation: It is necessary that each art print belongs to exactly one art style category.
Expression: {
  "constraint": "COUNT(product.categories) = 1",
  "message": "Art print must have exactly one style category"
}
Priority: 2
Enforcement: strict
```

### Limited Edition Verification

```sbvr
Rule Type: Structural
ID: limited-edition-verification
Formulation: It is necessary that each limited edition print has a total production run count and a sequential number.
Expression: {
  "condition": "product.is_limited_edition = true",
  "constraint": "product.production_run IS NOT NULL AND product.edition_number IS NOT NULL",
  "message": "Limited edition prints must have production run and edition number"
}
Priority: 2
Enforcement: strict
```

### Print Quality Standards

```sbvr
Rule Type: Operative
ID: print-quality-standards
Formulation: It is obligatory that each art print meets quality standards of color accuracy, paper quality, and print resolution.
Expression: {
  "condition": "product.status = 'production_ready'",
  "constraint": "product.color_accuracy >= 95 AND product.paper_quality = 'premium' AND product.dpi >= 300",
  "message": "Print does not meet quality standards"
}
Priority: 1
Enforcement: strict
```

## Pricing Rules

### Commercial Buyer Minimum Order

```sbvr
Rule Type: Operative
ID: commercial-buyer-minimum-order
Formulation: It is obligatory that each order from a commercial buyer has a total value of at least $1,000.
Expression: {
  "condition": "customer.segment = 'commercial'",
  "constraint": "order.total_value >= 1000",
  "message": "Commercial orders must be at least $1,000"
}
Priority: 1
Enforcement: strict
```

### Quantity Discount

```sbvr
Rule Type: Operative
ID: quantity-discount
Formulation: It is obligatory that orders of 10 or more prints of the same artwork receive a 15% discount.
Expression: {
  "condition": "COUNT(order_items) >= 10 AND COUNT(DISTINCT order_items.artwork_id) = 1",
  "action": "order.discount_percentage = 15",
  "message": "15% bulk discount applied"
}
Priority: 3
Enforcement: advisory
```

### Interior Designer Discount

```sbvr
Rule Type: Operative
ID: interior-designer-discount
Formulation: It is obligatory that verified interior designers receive a 10% professional discount on all orders.
Expression: {
  "condition": "customer.segment = 'interior_designer' AND customer.verified = true",
  "action": "order.discount_percentage = 10",
  "message": "10% interior designer discount applied"
}
Priority: 2
Enforcement: strict
```

### Large Format Surcharge

```sbvr
Rule Type: Operative
ID: large-format-surcharge
Formulation: It is obligatory that prints larger than 36x48 inches include a 20% large format surcharge.
Expression: {
  "condition": "product.width > 36 OR product.height > 48",
  "action": "product.price = product.base_price * 1.2",
  "message": "20% large format surcharge applied"
}
Priority: 3
Enforcement: strict
```

## Customer Service Rules

### Response Time Requirement

```sbvr
Rule Type: Operative
ID: response-time-requirement
Formulation: It is obligatory that each customer inquiry is responded to within 24 business hours.
Expression: {
  "condition": "inquiry.status = 'new'",
  "constraint": "BUSINESS_HOURS_BETWEEN(NOW(), inquiry.created_at) <= 24",
  "message": "Customer inquiry requires response within 24 business hours"
}
Priority: 1
Enforcement: strict
```

### Return Eligibility

```sbvr
Rule Type: Operative
ID: return-eligibility
Formulation: It is obligatory that art prints can be returned within 30 days if they are in original condition.
Expression: {
  "condition": "return_request.days_since_delivery <= 30",
  "constraint": "return_request.item_condition = 'original'",
  "message": "Return eligible if within 30 days and in original condition"
}
Priority: 2
Enforcement: strict
```

### VIP Customer Prioritization

```sbvr
Rule Type: Operative
ID: vip-customer-prioritization
Formulation: It is obligatory that inquiries from customers with lifetime value over $10,000 are prioritized for response.
Expression: {
  "condition": "customer.lifetime_value > 10000",
  "action": "inquiry.priority = 'high'",
  "message": "High-value customer inquiry prioritized"
}
Priority: 2
Enforcement: advisory
```

## Inventory Management Rules

### Low Inventory Alert

```sbvr
Rule Type: Operative
ID: low-inventory-alert
Formulation: It is obligatory that when available inventory of any print falls below 10% of its production run, the supplier agent is notified.
Expression: {
  "condition": "product.available_inventory < (product.production_run * 0.1)",
  "action": "NOTIFY('supplier_agent', 'low_inventory', product.id)",
  "message": "Low inventory alert needed"
}
Priority: 2
Enforcement: strict
```

### Out of Stock Handling

```sbvr
Rule Type: Operative
ID: out-of-stock-handling
Formulation: It is obligatory that when a print is out of stock, it is marked as 'backorder' if restockable or 'discontinued' if not.
Expression: {
  "condition": "product.inventory = 0",
  "action": "product.status = product.restockable ? 'backorder' : 'discontinued'",
  "message": "Updated out of stock product status"
}
Priority: 2
Enforcement: strict
```

### Limited Edition Sellout

```sbvr
Rule Type: Operative
ID: limited-edition-sellout
Formulation: It is obligatory that when a limited edition print is sold out, it is permanently marked as 'sold out' and cannot be restocked.
Expression: {
  "condition": "product.is_limited_edition = true AND product.inventory = 0",
  "action": "product.status = 'sold_out' AND product.restockable = false",
  "message": "Limited edition marked as permanently sold out"
}
Priority: 1
Enforcement: strict
```

## Shipping Rules

### Fragile Item Packaging

```sbvr
Rule Type: Operative
ID: fragile-item-packaging
Formulation: It is obligatory that orders containing framed prints are packed with double-layer protection and marked as fragile.
Expression: {
  "condition": "EXISTS(order_items WHERE item.is_framed = true)",
  "action": "order.packaging_type = 'double_protection' AND order.is_fragile = true",
  "message": "Framed print requires special packaging"
}
Priority: 2
Enforcement: strict
```

### International Shipping Documentation

```sbvr
Rule Type: Operative
ID: international-shipping-documentation
Formulation: It is obligatory that international shipments include a commercial invoice and customs declaration form.
Expression: {
  "condition": "order.shipping_address.country != 'United States'",
  "constraint": "order.has_commercial_invoice = true AND order.has_customs_declaration = true",
  "message": "International shipment requires proper documentation"
}
Priority: 1
Enforcement: strict
```

### Free Shipping Threshold

```sbvr
Rule Type: Operative
ID: free-shipping-threshold
Formulation: It is obligatory that domestic orders over $250 receive free standard shipping.
Expression: {
  "condition": "order.total_value >= 250 AND order.shipping_address.country = 'United States'",
  "action": "order.shipping_cost = 0",
  "message": "Free shipping applied to order over $250"
}
Priority: 3
Enforcement: strict
```

## Agent Application Rules

### Sales Agent Art Knowledge

```sbvr
Rule Type: Structural
ID: sales-agent-art-knowledge
Formulation: It is necessary that each sales agent has knowledge of all art styles and print options.
Expression: {
  "constraint": "COUNT(agent.known_concepts WHERE concept.domain = 'art_style') = COUNT(ALL art_styles) AND COUNT(agent.known_concepts WHERE concept.domain = 'print_option') = COUNT(ALL print_options)",
  "message": "Sales agent missing knowledge of art styles or print options"
}
Priority: 2
Enforcement: strict
```

### Customer Agent Personalization

```sbvr
Rule Type: Operative
ID: customer-agent-personalization
Formulation: It is obligatory that customer agents personalize recommendations based on customer segment and previous purchases.
Expression: {
  "condition": "interaction.type = 'recommendation'",
  "constraint": "recommendation.factors CONTAINS 'customer_segment' AND recommendation.factors CONTAINS 'purchase_history'",
  "message": "Recommendations must be personalized to customer"
}
Priority: 2
Enforcement: advisory
```

### Inventory Agent Forecasting

```sbvr
Rule Type: Operative
ID: inventory-agent-forecasting
Formulation: It is obligatory that inventory agents forecast demand for each product category monthly.
Expression: {
  "condition": "DATEDIFF('day', agent.last_forecast_date, CURRENT_DATE) > 30",
  "action": "SCHEDULE_TASK('demand_forecast', { agent_id: agent.id })",
  "message": "Monthly demand forecast required"
}
Priority: 3
Enforcement: advisory
```
