-- VividWalls Normalized Relational Database Schema
-- Designed for Supabase with proper relationships and pgvector support

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "vector";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- For text search

-- Drop existing tables if needed (careful in production!)
-- DROP SCHEMA IF EXISTS vividwalls CASCADE;
-- CREATE SCHEMA vividwalls;

-- ============================================
-- CORE BUSINESS TABLES
-- ============================================

-- Categories for organizing products
CREATE TABLE IF NOT EXISTS categories (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    parent_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Collections (like "Chromatic Echoes", "Geometric Intersect")
CREATE TABLE IF NOT EXISTS collections (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(200) NOT NULL UNIQUE,
    slug VARCHAR(200) NOT NULL UNIQUE,
    description TEXT,
    theme TEXT,
    is_featured BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Main products table
CREATE TABLE IF NOT EXISTS products (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    handle VARCHAR(255) NOT NULL UNIQUE,
    title VARCHAR(500) NOT NULL,
    description TEXT,
    collection_id UUID REFERENCES collections(id) ON DELETE SET NULL,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    vendor VARCHAR(200) DEFAULT 'VividWalls',
    product_type VARCHAR(100),
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'draft', 'archived')),
    
    -- SEO fields
    seo_title VARCHAR(300),
    seo_description TEXT,
    
    -- Metadata
    tags TEXT[], -- Array of tags
    metadata JSONB DEFAULT '{}',
    
    -- Timestamps
    published_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Product images
CREATE TABLE IF NOT EXISTS product_images (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    src TEXT NOT NULL,
    alt_text TEXT,
    position INTEGER DEFAULT 0,
    is_primary BOOLEAN DEFAULT false,
    width INTEGER,
    height INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Size options
CREATE TABLE IF NOT EXISTS sizes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    width_inches DECIMAL(10,2),
    height_inches DECIMAL(10,2),
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true
);

-- Print types
CREATE TABLE IF NOT EXISTS print_types (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    production_method VARCHAR(100),
    material VARCHAR(200),
    is_active BOOLEAN DEFAULT true
);

-- Product variants (combinations of size and print type)
CREATE TABLE IF NOT EXISTS product_variants (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    size_id UUID NOT NULL REFERENCES sizes(id),
    print_type_id UUID NOT NULL REFERENCES print_types(id),
    sku VARCHAR(255) NOT NULL UNIQUE,
    barcode VARCHAR(255),
    
    -- Pricing
    price DECIMAL(10,2) NOT NULL,
    compare_at_price DECIMAL(10,2),
    cost_per_item DECIMAL(10,2),
    
    -- Physical properties
    weight_grams INTEGER DEFAULT 0,
    requires_shipping BOOLEAN DEFAULT true,
    taxable BOOLEAN DEFAULT true,
    
    -- Status
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Unique constraint to prevent duplicates
    UNIQUE(product_id, size_id, print_type_id)
);

-- ============================================
-- INVENTORY MANAGEMENT
-- ============================================

-- Warehouse/Location management
CREATE TABLE IF NOT EXISTS locations (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(200) NOT NULL UNIQUE,
    code VARCHAR(50) NOT NULL UNIQUE,
    type VARCHAR(50) DEFAULT 'warehouse' CHECK (type IN ('warehouse', 'dropship', 'store', 'other')),
    address TEXT,
    is_active BOOLEAN DEFAULT true,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Current inventory levels
CREATE TABLE IF NOT EXISTS inventory_levels (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    location_id UUID NOT NULL REFERENCES locations(id) ON DELETE CASCADE,
    available INTEGER DEFAULT 0,
    on_hand INTEGER DEFAULT 0,
    incoming INTEGER DEFAULT 0,
    committed INTEGER DEFAULT 0,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Unique constraint
    UNIQUE(variant_id, location_id)
);

-- Inventory movements/transactions
CREATE TABLE IF NOT EXISTS inventory_movements (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    location_id UUID NOT NULL REFERENCES locations(id) ON DELETE CASCADE,
    movement_type VARCHAR(50) NOT NULL CHECK (movement_type IN ('sale', 'return', 'adjustment', 'transfer', 'restock', 'damage')),
    quantity INTEGER NOT NULL, -- Positive for additions, negative for removals
    reference_type VARCHAR(50), -- 'order', 'transfer', 'adjustment', etc.
    reference_id VARCHAR(255), -- ID of related order, transfer, etc.
    notes TEXT,
    created_by UUID, -- Reference to user if you have user management
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- CUSTOMER SUPPORT & KNOWLEDGE BASE
-- ============================================

-- Q&A categories
CREATE TABLE IF NOT EXISTS qa_categories (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(50),
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true
);

-- Questions and Answers
CREATE TABLE IF NOT EXISTS qa_entries (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    category_id UUID REFERENCES qa_categories(id) ON DELETE SET NULL,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    is_featured BOOLEAN DEFAULT false,
    is_published BOOLEAN DEFAULT true,
    view_count INTEGER DEFAULT 0,
    helpful_count INTEGER DEFAULT 0,
    tags TEXT[],
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- VECTOR EMBEDDINGS FOR SEMANTIC SEARCH
-- ============================================

-- Content types that can have embeddings
CREATE TABLE IF NOT EXISTS content_embeddings (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    content_type VARCHAR(50) NOT NULL CHECK (content_type IN ('product', 'qa', 'collection', 'category')),
    content_id UUID NOT NULL,
    chunk_index INTEGER DEFAULT 0,
    chunk_text TEXT NOT NULL,
    embedding vector(1536), -- OpenAI dimension, adjust as needed
    token_count INTEGER,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Index for foreign key lookups
    INDEX idx_content_type_id (content_type, content_id)
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

-- Product indexes
CREATE INDEX idx_products_handle ON products(handle);
CREATE INDEX idx_products_status ON products(status) WHERE status = 'active';
CREATE INDEX idx_products_collection ON products(collection_id);
CREATE INDEX idx_products_tags ON products USING GIN(tags);
CREATE INDEX idx_products_metadata ON products USING GIN(metadata);

-- Variant indexes
CREATE INDEX idx_variants_product ON product_variants(product_id);
CREATE INDEX idx_variants_sku ON product_variants(sku);
CREATE INDEX idx_variants_active ON product_variants(is_active) WHERE is_active = true;

-- Inventory indexes
CREATE INDEX idx_inventory_variant ON inventory_levels(variant_id);
CREATE INDEX idx_inventory_location ON inventory_levels(location_id);
CREATE INDEX idx_inventory_available ON inventory_levels(available) WHERE available > 0;

-- Movement indexes
CREATE INDEX idx_movements_variant ON inventory_movements(variant_id);
CREATE INDEX idx_movements_created ON inventory_movements(created_at DESC);

-- Q&A indexes
CREATE INDEX idx_qa_category ON qa_entries(category_id);
CREATE INDEX idx_qa_published ON qa_entries(is_published) WHERE is_published = true;
CREATE INDEX idx_qa_tags ON qa_entries USING GIN(tags);

-- Vector search index
CREATE INDEX idx_embeddings_vector ON content_embeddings 
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);

-- Full text search indexes
CREATE INDEX idx_products_search ON products USING GIN(to_tsvector('english', 
    COALESCE(title, '') || ' ' || COALESCE(description, '') || ' ' || COALESCE(array_to_string(tags, ' '), '')
));

CREATE INDEX idx_qa_search ON qa_entries USING GIN(to_tsvector('english', 
    COALESCE(question, '') || ' ' || COALESCE(answer, '')
));

-- ============================================
-- VIEWS FOR COMMON QUERIES
-- ============================================

-- Complete product view with variants
CREATE OR REPLACE VIEW product_catalog AS
SELECT 
    p.id,
    p.handle,
    p.title,
    p.description,
    p.status,
    c.name as collection_name,
    cat.name as category_name,
    p.tags,
    COALESCE(
        json_agg(
            json_build_object(
                'variant_id', v.id,
                'sku', v.sku,
                'size', s.name,
                'size_dimensions', s.width_inches || 'x' || s.height_inches,
                'print_type', pt.name,
                'price', v.price,
                'compare_at_price', v.compare_at_price,
                'in_stock', COALESCE(SUM(il.available), 0) > 0
            ) ORDER BY s.display_order, pt.name
        ) FILTER (WHERE v.id IS NOT NULL), 
        '[]'::json
    ) as variants,
    COALESCE(
        json_agg(DISTINCT 
            json_build_object(
                'src', pi.src,
                'alt', pi.alt_text,
                'position', pi.position
            ) ORDER BY json_build_object('position', pi.position)
        ) FILTER (WHERE pi.id IS NOT NULL),
        '[]'::json
    ) as images
FROM products p
LEFT JOIN collections c ON p.collection_id = c.id
LEFT JOIN categories cat ON p.category_id = cat.id
LEFT JOIN product_variants v ON p.id = v.product_id AND v.is_active = true
LEFT JOIN sizes s ON v.size_id = s.id
LEFT JOIN print_types pt ON v.print_type_id = pt.id
LEFT JOIN product_images pi ON p.id = pi.product_id
LEFT JOIN inventory_levels il ON v.id = il.variant_id
GROUP BY p.id, c.name, cat.name;

-- Inventory summary view
CREATE OR REPLACE VIEW inventory_summary AS
SELECT 
    p.title as product_title,
    p.handle,
    s.name as size,
    pt.name as print_type,
    v.sku,
    l.name as location,
    il.available,
    il.on_hand,
    il.incoming,
    il.committed,
    il.updated_at
FROM inventory_levels il
JOIN product_variants v ON il.variant_id = v.id
JOIN products p ON v.product_id = p.id
JOIN sizes s ON v.size_id = s.id
JOIN print_types pt ON v.print_type_id = pt.id
JOIN locations l ON il.location_id = l.id
WHERE p.status = 'active' AND v.is_active = true;

-- Low stock alert view
CREATE OR REPLACE VIEW low_stock_alerts AS
SELECT 
    p.title,
    v.sku,
    s.name as size,
    pt.name as print_type,
    SUM(il.available) as total_available,
    SUM(il.on_hand) as total_on_hand
FROM inventory_levels il
JOIN product_variants v ON il.variant_id = v.id
JOIN products p ON v.product_id = p.id
JOIN sizes s ON v.size_id = s.id
JOIN print_types pt ON v.print_type_id = pt.id
WHERE p.status = 'active' AND v.is_active = true
GROUP BY p.title, v.sku, s.name, pt.name
HAVING SUM(il.available) < 10
ORDER BY SUM(il.available);

-- ============================================
-- FUNCTIONS FOR SEMANTIC SEARCH
-- ============================================

-- Search function with vector similarity
CREATE OR REPLACE FUNCTION search_content(
    query_embedding vector(1536),
    search_type TEXT DEFAULT NULL,
    limit_count INTEGER DEFAULT 10,
    similarity_threshold FLOAT DEFAULT 0.7
)
RETURNS TABLE (
    content_type TEXT,
    content_id UUID,
    title TEXT,
    description TEXT,
    chunk_text TEXT,
    similarity FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    WITH ranked_results AS (
        SELECT 
            ce.content_type,
            ce.content_id,
            ce.chunk_text,
            1 - (ce.embedding <=> query_embedding) AS similarity,
            CASE 
                WHEN ce.content_type = 'product' THEN p.title
                WHEN ce.content_type = 'qa' THEN qa.question
                WHEN ce.content_type = 'collection' THEN c.name
                ELSE NULL
            END AS title,
            CASE 
                WHEN ce.content_type = 'product' THEN p.description
                WHEN ce.content_type = 'qa' THEN qa.answer
                WHEN ce.content_type = 'collection' THEN c.description
                ELSE NULL
            END AS description
        FROM content_embeddings ce
        LEFT JOIN products p ON ce.content_type = 'product' AND ce.content_id = p.id
        LEFT JOIN qa_entries qa ON ce.content_type = 'qa' AND ce.content_id = qa.id
        LEFT JOIN collections c ON ce.content_type = 'collection' AND ce.content_id = c.id
        WHERE (search_type IS NULL OR ce.content_type = search_type)
        AND 1 - (ce.embedding <=> query_embedding) > similarity_threshold
    )
    SELECT 
        content_type,
        content_id,
        title,
        description,
        chunk_text,
        similarity
    FROM ranked_results
    ORDER BY similarity DESC
    LIMIT limit_count;
END;
$$;

-- ============================================
-- TRIGGERS FOR UPDATED_AT
-- ============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_product_variants_updated_at BEFORE UPDATE ON product_variants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_inventory_levels_updated_at BEFORE UPDATE ON inventory_levels
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_qa_entries_updated_at BEFORE UPDATE ON qa_entries
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- ROW LEVEL SECURITY (RLS) for Supabase
-- ============================================

-- Enable RLS on all tables
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_variants ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_levels ENABLE ROW LEVEL SECURITY;
ALTER TABLE locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE qa_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_embeddings ENABLE ROW LEVEL SECURITY;

-- Public read access for product catalog
CREATE POLICY "Public can view active products" ON products
    FOR SELECT USING (status = 'active');

CREATE POLICY "Public can view product images" ON product_images
    FOR SELECT USING (true);

CREATE POLICY "Public can view active variants" ON product_variants
    FOR SELECT USING (is_active = true);

CREATE POLICY "Public can view collections" ON collections
    FOR SELECT USING (is_active = true);

CREATE POLICY "Public can view categories" ON categories
    FOR SELECT USING (is_active = true);

CREATE POLICY "Public can view published Q&A" ON qa_entries
    FOR SELECT USING (is_published = true);

-- Inventory is restricted (only authenticated users or specific roles)
CREATE POLICY "Authenticated can view inventory" ON inventory_levels
    FOR SELECT USING (auth.role() = 'authenticated');

-- ============================================
-- INITIAL DATA SETUP
-- ============================================

-- Insert default locations
INSERT INTO locations (name, code, type) VALUES
    ('170 Avenue F', 'AVE-F', 'warehouse'),
    ('Printful', 'PRINTFUL', 'dropship')
ON CONFLICT (code) DO NOTHING;

-- Insert common sizes
INSERT INTO sizes (name, width_inches, height_inches, display_order) VALUES
    ('24x36', 24, 36, 1),
    ('36x48', 36, 48, 2),
    ('53x72', 53, 72, 3)
ON CONFLICT (name) DO NOTHING;

-- Insert print types
INSERT INTO print_types (name, description) VALUES
    ('Gallery Wrapped Stretched Canvas', 'Premium canvas stretched over wooden frame'),
    ('Canvas Roll', 'Canvas print shipped rolled in tube'),
    ('Gallery Wrapped Canvas', 'Canvas stretched and gallery wrapped')
ON CONFLICT (name) DO NOTHING;

-- Categories
INSERT INTO categories (name, slug) VALUES
    ('Posters, Prints, & Visual Artwork', 'posters-prints-visual-artwork'),
    ('Canvas Art', 'canvas-art'),
    ('Wall Art', 'wall-art')
ON CONFLICT (slug) DO NOTHING;