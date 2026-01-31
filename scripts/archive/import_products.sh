#!/bin/bash

# Import product data into Supabase

echo "Creating collections..."
docker exec -i supabase-db psql -U postgres -d vividwalls << 'EOF'
-- Insert collections
INSERT INTO collections (name, slug, description) VALUES
('Chromatic Echoes', 'chromatic-echoes', 'The Chromatic Echoes collection'),
('Geometric Intersect', 'geometric-intersect', 'The Geometric Intersect collection'),
('Shape Emergence', 'shape-emergence', 'The Shape Emergence collection'),
('Space & Form', 'space-form', 'The Space & Form collection'),
('Vivid Layers', 'vivid-layers', 'The Vivid Layers collection'),
('Noir Collection', 'noir-collection', 'The Noir Collection'),
('Vista Collection', 'vista-collection', 'The Vista Collection')
ON CONFLICT (name) DO NOTHING;

-- Insert standard sizes
INSERT INTO sizes (name, width_inches, height_inches, display_order) VALUES
('8x10', 8, 10, 1),
('11x14', 11, 14, 2),
('16x20', 16, 20, 3),
('20x24', 20, 24, 4),
('24x30', 24, 30, 5),
('24x36', 24, 36, 6),
('30x40', 30, 40, 7),
('36x48', 36, 48, 8),
('40x60', 40, 60, 9),
('48x72', 48, 72, 10)
ON CONFLICT (name) DO NOTHING;

-- Insert print types
INSERT INTO print_types (name, description, material) VALUES
('Canvas', 'Gallery-wrapped canvas print', 'Premium canvas with archival inks'),
('Limited Edition Canvas', 'Signed and numbered limited edition canvas', 'Museum-quality canvas with certificate of authenticity'),
('Paper Print', 'Premium paper print', 'Archival paper with matte finish'),
('Metal Print', 'Aluminum metal print', 'HD metal with glossy finish')
ON CONFLICT (name) DO NOTHING;

-- Insert sample products
INSERT INTO products (handle, title, description, vendor, product_type, status) VALUES
('chromatic-echoes-deep', 'Chromatic Echoes - Deep', 'A stunning abstract piece featuring deep blues and greens with chromatic transitions.', 'VividWalls', 'Wall Art', 'active'),
('geometric-intersect-01', 'Geometric Intersect #01', 'Bold geometric shapes intersecting in perfect harmony, creating visual depth and movement.', 'VividWalls', 'Wall Art', 'active'),
('space-form-no-1', 'Space & Form No.1', 'Minimalist exploration of negative space and form in monochromatic tones.', 'VividWalls', 'Wall Art', 'active'),
('noir-weave-003', 'Noir Weave 003', 'Intricate black and white patterns woven together in a sophisticated design.', 'VividWalls', 'Wall Art', 'active'),
('vivid-mosaic-001', 'Vivid Mosaic 001', 'Colorful mosaic-inspired artwork with vibrant tiles and dynamic composition.', 'VividWalls', 'Wall Art', 'active')
ON CONFLICT (handle) DO UPDATE
SET title = EXCLUDED.title,
    description = EXCLUDED.description,
    updated_at = NOW();

-- Create some sample variants
INSERT INTO product_variants (product_id, size_id, print_type_id, sku, price)
SELECT 
    p.id,
    s.id,
    pt.id,
    p.handle || '-' || s.name || '-' || LOWER(REPLACE(pt.name, ' ', '-')),
    CASE 
        WHEN s.name = '8x10' THEN 149.00
        WHEN s.name = '11x14' THEN 199.00
        WHEN s.name = '16x20' THEN 299.00
        WHEN s.name = '24x36' THEN 499.00
        WHEN s.name = '36x48' THEN 799.00
        WHEN s.name = '48x72' THEN 1299.00
        ELSE 399.00
    END
FROM products p
CROSS JOIN sizes s
CROSS JOIN print_types pt
WHERE pt.name IN ('Canvas', 'Limited Edition Canvas')
AND s.name IN ('16x20', '24x36', '36x48')
ON CONFLICT (product_id, size_id, print_type_id) DO UPDATE
SET price = EXCLUDED.price,
    updated_at = NOW();

-- Add some images
INSERT INTO product_images (product_id, src, alt_text, is_primary)
SELECT 
    id,
    'https://example.com/images/' || handle || '.jpg',
    title,
    true
FROM products
ON CONFLICT DO NOTHING;

EOF

echo "Products imported successfully!"