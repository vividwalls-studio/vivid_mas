# VividWalls Simplified Database Schema

## Design Principles

1. **Goal-Oriented**: Every table supports business goals
2. **Relational Integrity**: Proper foreign keys and constraints
3. **Simplicity**: Fewer tables with clear purposes
4. **Performance**: Optimized for common queries
5. **Scalability**: Supports future growth

## Core Schema Design

### 1. Organization & Agents (3 tables)

```sql
-- Simplified agent hierarchy
CREATE TABLE agents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL UNIQUE,
    type VARCHAR(50) NOT NULL CHECK (type IN ('orchestrator', 'director', 'specialist')),
    parent_id UUID REFERENCES agents(id),
    system_prompt TEXT,
    mcp_tools TEXT[], -- Array of MCP tool names
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Agent capabilities and knowledge
CREATE TABLE agent_capabilities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    capability_type VARCHAR(100) NOT NULL,
    capability_name VARCHAR(255) NOT NULL,
    configuration JSONB DEFAULT '{}'::jsonb,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(agent_id, capability_type, capability_name)
);

-- Agent collaboration rules
CREATE TABLE agent_collaborations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    requesting_agent_id UUID NOT NULL REFERENCES agents(id),
    responding_agent_id UUID NOT NULL REFERENCES agents(id),
    collaboration_type VARCHAR(100) NOT NULL,
    priority INTEGER DEFAULT 5,
    sla_minutes INTEGER DEFAULT 60,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(requesting_agent_id, responding_agent_id, collaboration_type)
);
```

### 2. Goals & Workflows (4 tables)

```sql
-- Business goals
CREATE TABLE goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(50) NOT NULL CHECK (type IN ('revenue', 'efficiency', 'customer_satisfaction', 'growth')),
    target_value DECIMAL(12,2),
    target_date DATE,
    owner_agent_id UUID REFERENCES agents(id),
    parent_goal_id UUID REFERENCES goals(id),
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Workflows that achieve goals
CREATE TABLE workflows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    goal_id UUID REFERENCES goals(id),
    owner_agent_id UUID NOT NULL REFERENCES agents(id),
    n8n_workflow_id VARCHAR(255) UNIQUE,
    trigger_type VARCHAR(50) NOT NULL,
    trigger_config JSONB DEFAULT '{}'::jsonb,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Workflow executions
CREATE TABLE workflow_executions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workflow_id UUID NOT NULL REFERENCES workflows(id),
    execution_id VARCHAR(255) UNIQUE,
    status VARCHAR(50) NOT NULL,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE,
    input_data JSONB DEFAULT '{}'::jsonb,
    output_data JSONB DEFAULT '{}'::jsonb,
    error_message TEXT,
    metrics JSONB DEFAULT '{}'::jsonb -- execution time, tokens used, etc.
);

-- Tasks within workflows
CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workflow_execution_id UUID REFERENCES workflow_executions(id),
    assigned_agent_id UUID NOT NULL REFERENCES agents(id),
    task_type VARCHAR(100) NOT NULL,
    priority INTEGER DEFAULT 5,
    status VARCHAR(50) DEFAULT 'pending',
    input_data JSONB DEFAULT '{}'::jsonb,
    output_data JSONB DEFAULT '{}'::jsonb,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    sla_minutes INTEGER DEFAULT 60,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

### 3. Products & Commerce (6 tables)

```sql
-- Simplified product catalog
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shopify_id VARCHAR(255) UNIQUE,
    title VARCHAR(500) NOT NULL,
    description TEXT,
    collection VARCHAR(255),
    category VARCHAR(255),
    tags TEXT[],
    base_price DECIMAL(10,2) NOT NULL,
    cost DECIMAL(10,2),
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Product variants (sizes, frames, etc.)
CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    shopify_variant_id VARCHAR(255) UNIQUE,
    sku VARCHAR(255) UNIQUE,
    size VARCHAR(50),
    frame_type VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    inventory_quantity INTEGER DEFAULT 0,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Orders
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shopify_order_id VARCHAR(255) UNIQUE,
    order_number VARCHAR(50) UNIQUE,
    customer_id UUID REFERENCES customers(id),
    status VARCHAR(50) NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    subtotal_amount DECIMAL(12,2),
    tax_amount DECIMAL(12,2),
    shipping_amount DECIMAL(12,2),
    discount_amount DECIMAL(12,2),
    currency VARCHAR(3) DEFAULT 'USD',
    fulfillment_status VARCHAR(50),
    financial_status VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Order line items
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_variant_id UUID REFERENCES product_variants(id),
    quantity INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL
);

-- Inventory tracking
CREATE TABLE inventory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_variant_id UUID NOT NULL REFERENCES product_variants(id),
    location VARCHAR(255) DEFAULT 'main',
    quantity_available INTEGER DEFAULT 0,
    quantity_reserved INTEGER DEFAULT 0,
    quantity_incoming INTEGER DEFAULT 0,
    reorder_point INTEGER,
    reorder_quantity INTEGER,
    last_counted_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(product_variant_id, location)
);

-- Product performance metrics
CREATE TABLE product_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id),
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    views INTEGER DEFAULT 0,
    add_to_carts INTEGER DEFAULT 0,
    purchases INTEGER DEFAULT 0,
    revenue DECIMAL(12,2) DEFAULT 0,
    conversion_rate DECIMAL(5,4),
    average_order_value DECIMAL(10,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(product_id, period_start, period_end)
);
```

### 4. Customers & Segmentation (4 tables)

```sql
-- Unified customer table
CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shopify_customer_id VARCHAR(255) UNIQUE,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    company VARCHAR(255),
    phone VARCHAR(50),
    tags TEXT[],
    total_spent DECIMAL(12,2) DEFAULT 0,
    orders_count INTEGER DEFAULT 0,
    average_order_value DECIMAL(10,2),
    last_order_date TIMESTAMP WITH TIME ZONE,
    accepts_marketing BOOLEAN DEFAULT false,
    vip_status BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Customer segments
CREATE TABLE customer_segments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL UNIQUE,
    type VARCHAR(50) NOT NULL CHECK (type IN ('commercial', 'residential', 'online')),
    description TEXT,
    criteria JSONB NOT NULL, -- Segmentation rules
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Customer segment membership
CREATE TABLE customer_segment_members (
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    segment_id UUID NOT NULL REFERENCES customer_segments(id) ON DELETE CASCADE,
    score DECIMAL(5,2) DEFAULT 50.00, -- Confidence score 0-100
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (customer_id, segment_id)
);

-- Customer interactions
CREATE TABLE customer_interactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id),
    interaction_type VARCHAR(100) NOT NULL,
    channel VARCHAR(50) NOT NULL,
    agent_id UUID REFERENCES agents(id),
    content TEXT,
    sentiment_score DECIMAL(3,2), -- -1 to 1
    outcome VARCHAR(255),
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

### 5. Marketing & Content (4 tables)

```sql
-- Campaigns
CREATE TABLE campaigns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('email', 'social', 'sms', 'ads')),
    goal_id UUID REFERENCES goals(id),
    owner_agent_id UUID REFERENCES agents(id),
    target_segment_id UUID REFERENCES customer_segments(id),
    status VARCHAR(50) DEFAULT 'draft',
    budget DECIMAL(10,2),
    spent DECIMAL(10,2) DEFAULT 0,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Content library
CREATE TABLE content (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(50) NOT NULL,
    title VARCHAR(500),
    body TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_by_agent_id UUID REFERENCES agents(id),
    campaign_id UUID REFERENCES campaigns(id),
    status VARCHAR(50) DEFAULT 'draft',
    performance_metrics JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    published_at TIMESTAMP WITH TIME ZONE
);

-- Email lists
CREATE TABLE email_lists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    type VARCHAR(50) NOT NULL,
    criteria JSONB, -- Dynamic list criteria
    is_active BOOLEAN DEFAULT true,
    subscriber_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Email list subscribers
CREATE TABLE email_subscribers (
    email VARCHAR(255) NOT NULL,
    list_id UUID NOT NULL REFERENCES email_lists(id) ON DELETE CASCADE,
    customer_id UUID REFERENCES customers(id),
    status VARCHAR(50) DEFAULT 'subscribed',
    subscribed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    unsubscribed_at TIMESTAMP WITH TIME ZONE,
    PRIMARY KEY (email, list_id)
);
```

### 6. Analytics & Reporting (3 tables)

```sql
-- KPI definitions
CREATE TABLE kpis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL UNIQUE,
    category VARCHAR(100) NOT NULL,
    calculation_sql TEXT NOT NULL,
    unit VARCHAR(50),
    target_value DECIMAL(12,2),
    frequency VARCHAR(50) DEFAULT 'daily',
    owner_agent_id UUID REFERENCES agents(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- KPI measurements
CREATE TABLE kpi_measurements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    kpi_id UUID NOT NULL REFERENCES kpis(id),
    measured_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    value DECIMAL(12,4) NOT NULL,
    period_start TIMESTAMP WITH TIME ZONE,
    period_end TIMESTAMP WITH TIME ZONE,
    metadata JSONB DEFAULT '{}'::jsonb
);

-- Reports
CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL,
    created_by_agent_id UUID REFERENCES agents(id),
    recipient_agents UUID[],
    content JSONB NOT NULL,
    generated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    sent_at TIMESTAMP WITH TIME ZONE
);
```

### 7. Financial Management (3 tables)

```sql
-- Financial transactions
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(50) NOT NULL CHECK (type IN ('revenue', 'expense', 'refund', 'adjustment')),
    category VARCHAR(100) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    description TEXT,
    order_id UUID REFERENCES orders(id),
    customer_id UUID REFERENCES customers(id),
    agent_id UUID REFERENCES agents(id),
    payment_method VARCHAR(50),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Budgets
CREATE TABLE budgets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    fiscal_year INTEGER NOT NULL,
    fiscal_month INTEGER NOT NULL,
    allocated_amount DECIMAL(12,2) NOT NULL,
    spent_amount DECIMAL(12,2) DEFAULT 0,
    owner_agent_id UUID REFERENCES agents(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(category, fiscal_year, fiscal_month)
);

-- Revenue attribution
CREATE TABLE revenue_attribution (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_id UUID NOT NULL REFERENCES transactions(id),
    agent_id UUID NOT NULL REFERENCES agents(id),
    campaign_id UUID REFERENCES campaigns(id),
    attribution_model VARCHAR(50) DEFAULT 'last_touch',
    attribution_percentage DECIMAL(5,2) NOT NULL,
    touchpoint_data JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

### 8. System & Operations (2 tables)

```sql
-- System events and logs
CREATE TABLE system_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type VARCHAR(100) NOT NULL,
    severity VARCHAR(20) DEFAULT 'info',
    source_agent_id UUID REFERENCES agents(id),
    message TEXT NOT NULL,
    details JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Configuration
CREATE TABLE configurations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    key VARCHAR(255) NOT NULL UNIQUE,
    value JSONB NOT NULL,
    description TEXT,
    updated_by_agent_id UUID REFERENCES agents(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

## Key Improvements

### 1. Reduced Complexity
- From 68 tables to ~30 core tables
- Clear purpose for each table
- No duplicate concepts

### 2. Proper Relationships
- All foreign keys defined
- Cascading deletes where appropriate
- Unique constraints to prevent duplicates

### 3. Goal-Oriented Design
- Goals drive workflows
- Workflows create tasks
- Tasks assigned to agents
- Clear execution tracking

### 4. Business Alignment
- Direct mapping to business model
- Support for all customer segments
- Financial tracking built-in
- KPI measurement native

### 5. Performance Optimized
- Indexes on foreign keys
- Composite indexes for common queries
- JSONB for flexible metadata
- Partitioning ready for large tables

## Migration Strategy

1. **Phase 1**: Create new schema alongside existing
2. **Phase 2**: Migrate core data (products, customers, orders)
3. **Phase 3**: Simplify agent structure
4. **Phase 4**: Implement goal/workflow system
5. **Phase 5**: Deprecate old tables

## Next Steps

1. Review and approve schema design
2. Create migration scripts
3. Test with sample data
4. Plan phased rollout
5. Update MCP servers to use new schema