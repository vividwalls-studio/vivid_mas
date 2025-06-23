-- VividWalls Example Queries for Normalized Schema
-- These queries demonstrate the power of the relational structure

-- ============================================
-- PRODUCT QUERIES
-- ============================================

-- 1. Get complete product details with all variants and pricing
WITH product_details AS (
    SELECT 
        p.id,
        p.handle,
        p.title,
        p.description,
        c.name as collection,
        cat.name as category,
        p.tags,
        p.status,
        COUNT(DISTINCT v.id) as variant_count,
        MIN(v.price) as price_from,
        MAX(v.price) as price_to,
        COUNT(DISTINCT pi.id) as image_count
    FROM products p
    LEFT JOIN collections c ON p.collection_id = c.id
    LEFT JOIN categories cat ON p.category_id = cat.id
    LEFT JOIN product_variants v ON p.id = v.product_id AND v.is_active = true
    LEFT JOIN product_images pi ON p.id = pi.product_id
    WHERE p.status = 'active'
    GROUP BY p.id, c.name, cat.name
)
SELECT * FROM product_details
ORDER BY collection, title;

-- 2. Find products available in specific size with stock
SELECT DISTINCT
    p.title,
    c.name as collection,
    v.price,
    SUM(il.available) as total_available,
    array_agg(DISTINCT l.name) as available_locations
FROM products p
JOIN product_variants v ON p.id = v.product_id
JOIN sizes s ON v.size_id = s.id
JOIN inventory_levels il ON v.id = il.variant_id
JOIN locations l ON il.location_id = l.id
LEFT JOIN collections c ON p.collection_id = c.id
WHERE s.name = '53x72'
  AND il.available > 0
  AND p.status = 'active'
GROUP BY p.id, p.title, c.name, v.price
ORDER BY total_available DESC;

-- 3. Products with pricing tiers
SELECT 
    p.title,
    json_object_agg(
        s.name || ' - ' || pt.name,
        json_build_object(
            'sku', v.sku,
            'price', v.price,
            'compare_at', v.compare_at_price,
            'discount_pct', 
            CASE 
                WHEN v.compare_at_price > 0 
                THEN ROUND(((v.compare_at_price - v.price) / v.compare_at_price * 100)::numeric, 0)
                ELSE 0 
            END
        )
    ) as pricing_matrix
FROM products p
JOIN product_variants v ON p.id = v.product_id
JOIN sizes s ON v.size_id = s.id
JOIN print_types pt ON v.print_type_id = pt.id
WHERE p.status = 'active' AND v.is_active = true
GROUP BY p.id, p.title;

-- ============================================
-- INVENTORY QUERIES
-- ============================================

-- 4. Inventory value by location
SELECT 
    l.name as location,
    l.type as location_type,
    COUNT(DISTINCT v.id) as unique_skus,
    SUM(il.on_hand) as total_units,
    SUM(il.on_hand * v.price) as inventory_value,
    SUM(il.available) as available_units,
    SUM(il.available * v.price) as available_value
FROM locations l
JOIN inventory_levels il ON l.id = il.location_id
JOIN product_variants v ON il.variant_id = v.id
WHERE il.on_hand > 0
GROUP BY l.id, l.name, l.type
ORDER BY inventory_value DESC;

-- 5. Products needing restock by location
SELECT 
    l.name as location,
    p.title as product,
    s.name as size,
    pt.name as print_type,
    v.sku,
    il.available,
    il.on_hand,
    il.incoming,
    CASE 
        WHEN il.available = 0 THEN 'OUT OF STOCK'
        WHEN il.available < 5 THEN 'CRITICAL'
        WHEN il.available < 10 THEN 'LOW'
        ELSE 'OK'
    END as stock_status
FROM inventory_levels il
JOIN product_variants v ON il.variant_id = v.id
JOIN products p ON v.product_id = p.id
JOIN sizes s ON v.size_id = s.id
JOIN print_types pt ON v.print_type_id = pt.id
JOIN locations l ON il.location_id = l.id
WHERE il.available < 10
  AND p.status = 'active'
  AND v.is_active = true
ORDER BY il.available, p.title, s.display_order;

-- 6. Inventory movement analysis (last 30 days)
WITH movement_summary AS (
    SELECT 
        v.product_id,
        im.location_id,
        im.movement_type,
        SUM(CASE WHEN im.quantity > 0 THEN im.quantity ELSE 0 END) as units_in,
        SUM(CASE WHEN im.quantity < 0 THEN ABS(im.quantity) ELSE 0 END) as units_out,
        COUNT(*) as transaction_count
    FROM inventory_movements im
    JOIN product_variants v ON im.variant_id = v.id
    WHERE im.created_at >= NOW() - INTERVAL '30 days'
    GROUP BY v.product_id, im.location_id, im.movement_type
)
SELECT 
    p.title,
    l.name as location,
    ms.movement_type,
    ms.units_in,
    ms.units_out,
    ms.units_in - ms.units_out as net_change,
    ms.transaction_count
FROM movement_summary ms
JOIN products p ON ms.product_id = p.id
JOIN locations l ON ms.location_id = l.id
ORDER BY p.title, l.name, ms.movement_type;

-- ============================================
-- COLLECTION & CATEGORY ANALYTICS
-- ============================================

-- 7. Collection performance metrics
SELECT 
    c.name as collection,
    COUNT(DISTINCT p.id) as product_count,
    COUNT(DISTINCT v.id) as variant_count,
    AVG(v.price)::numeric(10,2) as avg_price,
    MIN(v.price) as min_price,
    MAX(v.price) as max_price,
    SUM(il.available) as total_stock,
    SUM(il.available * v.price)::numeric(10,2) as stock_value
FROM collections c
LEFT JOIN products p ON p.collection_id = c.id AND p.status = 'active'
LEFT JOIN product_variants v ON v.product_id = p.id AND v.is_active = true
LEFT JOIN inventory_levels il ON il.variant_id = v.id
WHERE c.is_active = true
GROUP BY c.id, c.name, c.display_order
ORDER BY c.display_order;

-- 8. Size popularity across collections
SELECT 
    s.name as size,
    s.width_inches || '" x ' || s.height_inches || '"' as dimensions,
    COUNT(DISTINCT p.id) as products_available,
    COUNT(DISTINCT c.id) as collections_available,
    AVG(v.price)::numeric(10,2) as avg_price,
    SUM(il.available) as total_stock
FROM sizes s
JOIN product_variants v ON s.id = v.size_id
JOIN products p ON v.product_id = p.id
LEFT JOIN collections c ON p.collection_id = c.id
LEFT JOIN inventory_levels il ON v.id = il.variant_id
WHERE p.status = 'active' AND v.is_active = true
GROUP BY s.id, s.name, s.width_inches, s.height_inches, s.display_order
ORDER BY s.display_order;

-- ============================================
-- CUSTOMER SUPPORT QUERIES
-- ============================================

-- 9. Most helpful Q&A by category
SELECT 
    cat.name as category,
    q.question,
    LEFT(q.answer, 100) || '...' as answer_preview,
    q.view_count,
    q.helpful_count,
    CASE 
        WHEN q.view_count > 0 
        THEN ROUND((q.helpful_count::numeric / q.view_count * 100), 1)
        ELSE 0 
    END as helpfulness_rate
FROM qa_entries q
LEFT JOIN qa_categories cat ON q.category_id = cat.id
WHERE q.is_published = true
  AND q.view_count > 10
ORDER BY helpfulness_rate DESC, q.view_count DESC
LIMIT 20;

-- 10. Q&A coverage analysis
SELECT 
    cat.name as category,
    COUNT(q.id) as question_count,
    SUM(q.view_count) as total_views,
    AVG(q.view_count)::numeric(10,1) as avg_views_per_question,
    SUM(q.helpful_count) as total_helpful,
    array_agg(DISTINCT unnest(q.tags)) as all_tags
FROM qa_categories cat
LEFT JOIN qa_entries q ON cat.id = q.category_id AND q.is_published = true
GROUP BY cat.id, cat.name
ORDER BY total_views DESC;

-- ============================================
-- SEARCH & DISCOVERY QUERIES
-- ============================================

-- 11. Product search with filters (example: products under $300 in 36x48)
SELECT 
    p.title,
    c.name as collection,
    v.price,
    v.sku,
    pt.name as print_type,
    il.available,
    pi.src as primary_image
FROM products p
JOIN product_variants v ON p.id = v.product_id
JOIN sizes s ON v.size_id = s.id
JOIN print_types pt ON v.print_type_id = pt.id
LEFT JOIN collections c ON p.collection_id = c.id
LEFT JOIN inventory_levels il ON v.id = il.variant_id
LEFT JOIN product_images pi ON p.id = pi.product_id AND pi.position = 1
WHERE p.status = 'active'
  AND v.is_active = true
  AND s.name = '36x48'
  AND v.price < 300
  AND il.available > 0
ORDER BY v.price;

-- 12. Tag-based product discovery
WITH tag_search AS (
    SELECT DISTINCT p.id
    FROM products p,
    unnest(p.tags) as tag
    WHERE p.status = 'active'
    AND tag ILIKE '%geometric%'
)
SELECT 
    p.title,
    p.tags,
    c.name as collection,
    COUNT(DISTINCT v.id) as variants,
    MIN(v.price) as starting_price
FROM products p
JOIN tag_search ts ON p.id = ts.id
LEFT JOIN collections c ON p.collection_id = c.id
LEFT JOIN product_variants v ON p.id = v.product_id AND v.is_active = true
GROUP BY p.id, p.title, p.tags, c.name
ORDER BY p.title;

-- ============================================
-- REPORTING QUERIES
-- ============================================

-- 13. Daily inventory snapshot
SELECT 
    DATE(NOW()) as snapshot_date,
    COUNT(DISTINCT p.id) as active_products,
    COUNT(DISTINCT v.id) as active_variants,
    COUNT(DISTINCT CASE WHEN il.available > 0 THEN v.id END) as in_stock_variants,
    SUM(il.available) as total_available_units,
    SUM(il.on_hand) as total_on_hand_units,
    SUM(il.available * v.price)::numeric(10,2) as available_inventory_value,
    AVG(CASE WHEN il.on_hand > 0 THEN il.available::numeric / il.on_hand * 100 END)::numeric(5,2) as avg_availability_rate
FROM products p
JOIN product_variants v ON p.id = v.product_id
LEFT JOIN inventory_levels il ON v.id = il.variant_id
WHERE p.status = 'active' AND v.is_active = true;

-- 14. Product catalog health check
WITH health_metrics AS (
    SELECT 
        p.id,
        p.title,
        p.status,
        CASE WHEN p.description IS NOT NULL AND LENGTH(p.description) > 50 THEN 1 ELSE 0 END as has_description,
        CASE WHEN p.seo_title IS NOT NULL THEN 1 ELSE 0 END as has_seo_title,
        CASE WHEN p.collection_id IS NOT NULL THEN 1 ELSE 0 END as has_collection,
        CASE WHEN array_length(p.tags, 1) > 0 THEN 1 ELSE 0 END as has_tags,
        COUNT(DISTINCT v.id) as variant_count,
        COUNT(DISTINCT pi.id) as image_count,
        COUNT(DISTINCT il.id) as inventory_locations
    FROM products p
    LEFT JOIN product_variants v ON p.id = v.product_id AND v.is_active = true
    LEFT JOIN product_images pi ON p.id = pi.product_id
    LEFT JOIN inventory_levels il ON v.id = il.variant_id
    GROUP BY p.id
)
SELECT 
    COUNT(*) as total_products,
    SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) as active_products,
    AVG(has_description * 100)::numeric(5,2) as pct_with_description,
    AVG(has_seo_title * 100)::numeric(5,2) as pct_with_seo,
    AVG(has_collection * 100)::numeric(5,2) as pct_with_collection,
    AVG(has_tags * 100)::numeric(5,2) as pct_with_tags,
    AVG(variant_count)::numeric(5,2) as avg_variants_per_product,
    AVG(image_count)::numeric(5,2) as avg_images_per_product,
    AVG(CASE WHEN variant_count > 0 THEN inventory_locations::numeric / variant_count ELSE 0 END)::numeric(5,2) as avg_locations_per_variant
FROM health_metrics;

-- ============================================
-- SEMANTIC SEARCH EXAMPLES
-- ============================================

-- 15. Find similar products (requires embedding)
-- This would use the search_content function with a product's embedding
/*
WITH source_product AS (
    SELECT embedding 
    FROM content_embeddings 
    WHERE content_type = 'product' 
    AND content_id = 'PRODUCT_UUID_HERE'
    LIMIT 1
)
SELECT 
    p.title,
    p.handle,
    s.similarity
FROM search_content(
    (SELECT embedding FROM source_product),
    'product',
    10,
    0.8
) s
JOIN products p ON s.content_id = p.id
WHERE p.status = 'active';
*/

-- 16. Multi-type semantic search
-- Search across products and Q&A for a concept
/*
SELECT 
    content_type,
    CASE 
        WHEN content_type = 'product' THEN p.title
        WHEN content_type = 'qa' THEN q.question
    END as title,
    chunk_text,
    similarity
FROM search_content(
    'QUERY_EMBEDDING_HERE'::vector(1536),
    NULL,  -- Search all types
    20,
    0.7
) s
LEFT JOIN products p ON s.content_type = 'product' AND s.content_id = p.id
LEFT JOIN qa_entries q ON s.content_type = 'qa' AND s.content_id = q.id
ORDER BY similarity DESC;
*/