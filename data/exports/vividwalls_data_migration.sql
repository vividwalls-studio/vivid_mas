-- VividWalls Data Migration Script
-- Migrates data from consolidated format to normalized structure
-- Generated at: 2025-06-17T11:54:59.974951

-- Start transaction
BEGIN;

-- Clear existing data (careful in production!)
TRUNCATE categories, collections, products, product_images, product_variants, 
         sizes, print_types, locations, inventory_levels, qa_entries, 
         qa_categories, content_embeddings CASCADE;


-- Insert collections
INSERT INTO collections (id, name, slug, is_active) 
VALUES ('eb8961e6-d43c-4962-8472-6602d96e6aaf', 'Intersecting Perspectives', 'intersecting-perspectives', true);
INSERT INTO collections (id, name, slug, is_active) 
VALUES ('89a9ed3a-a6eb-4abb-a69c-e6d07bfc2dcb', 'Chromatic Echoes', 'chromatic-echoes', true);
INSERT INTO collections (id, name, slug, is_active) 
VALUES ('041bbb17-d7a1-4e6b-9be1-0b680c56096e', 'Space Form', 'space-form', true);
INSERT INTO collections (id, name, slug, is_active) 
VALUES ('b3a65f16-4405-4d2c-8bf5-74ea4d328a5d', 'Intersecting Spaces', 'intersecting-spaces', true);
INSERT INTO collections (id, name, slug, is_active) 
VALUES ('2c71e66d-96fb-4775-9256-f1427e7de746', 'Shape Emergence', 'shape-emergence', true);
INSERT INTO collections (id, name, slug, is_active) 
VALUES ('afdd4df5-a788-416a-a39b-940ff50c21d2', 'Geometric Symmetry', 'geometric-symmetry', true);
INSERT INTO collections (id, name, slug, is_active) 
VALUES ('2baf353b-2933-4817-8050-f33735ede775', 'Vivid Layers', 'vivid-layers', true);
INSERT INTO collections (id, name, slug, is_active) 
VALUES ('51e253ef-6d6f-4ec0-bf91-7a87d251ac5e', 'Geometric Intersect', 'geometric-intersect', true);

-- Insert sizes
INSERT INTO sizes (id, name, width_inches, height_inches) 
VALUES ('6619147d-d05d-47e6-921c-0ef267dc0b4f', '24x36', 24, 36);
INSERT INTO sizes (id, name, width_inches, height_inches) 
VALUES ('48cc61d0-de1b-4006-a738-81a96c6ea0f9', '36x48', 36, 48);
INSERT INTO sizes (id, name, width_inches, height_inches) 
VALUES ('e76a397a-7832-4438-9754-2b91a8c3f50e', '53x72', 53, 72);

-- Insert print types
INSERT INTO print_types (id, name) 
VALUES ('6991bc95-aafb-4b40-a511-caf2992a3f30', 'Gallery Wrapped Stretched Canvas');
INSERT INTO print_types (id, name) 
VALUES ('189ea524-bde2-42b4-ba1b-0671a2cd7a65', 'Canvas Roll');

-- Insert locations
INSERT INTO locations (id, name, code, type) 
VALUES ('409ef3c4-c237-44cd-923e-97c5b40f5015', '170 Avenue F', '170-AVENUE', 'warehouse');
INSERT INTO locations (id, name, code, type) 
VALUES ('d9517d87-3982-487d-933f-fd1afdc73b81', 'Printful', 'PRINTFUL', 'dropship');

-- Insert Q&A categories
INSERT INTO qa_categories (id, name, slug) 
VALUES ('cbcf5338-0da5-4bca-98a6-a965116a6133', 'Payment & Pricing', 'payment-pricing');
INSERT INTO qa_categories (id, name, slug) 
VALUES ('4ecfe55f-4a9f-4875-9325-3a282435b7cb', 'About Us', 'about-us');
INSERT INTO qa_categories (id, name, slug) 
VALUES ('3c4ecea1-3ac3-42b2-b8d5-bc02d18e2c7b', 'Customer Support', 'customer-support');
INSERT INTO qa_categories (id, name, slug) 
VALUES ('08cc7416-ad35-40d6-aefb-b260bc3f3527', 'Shipping & Delivery', 'shipping-delivery');
INSERT INTO qa_categories (id, name, slug) 
VALUES ('2798312f-1f32-4721-acff-7f46414c72ab', 'Returns & Exchanges', 'returns-exchanges');
INSERT INTO qa_categories (id, name, slug) 
VALUES ('1ab825bb-049b-47b6-adec-00c021dbe49f', 'Policies & Terms', 'policies-terms');
INSERT INTO qa_categories (id, name, slug) 
VALUES ('27d9233b-30f2-49ba-a5e3-f880de610ac0', 'Product Customization', 'product-customization');
INSERT INTO qa_categories (id, name, slug) 
VALUES ('2b7f4664-2286-42a4-a98f-84bf1107d631', 'Product Information', 'product-information');
INSERT INTO qa_categories (id, name, slug) 
VALUES ('125c76b5-f0c4-4444-afae-6c5efe3f36c7', 'Art & Collections', 'art-collections');

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('652353f2-1763-4484-aa39-202eb795478b', 'intersecting-perspectives-no3', 'Intersecting Perspectives No3', 'Intersecting Perspectives No3from the Geometric Intersect collection showcases a sophisticated geometric abstract composition featuring intersecting lines and perspective shifts that create a complex visual narrative. This artwork demonstrates how linear elements can intersect to generate new spatial relationships and dimensional illusions that challenge conventional perspective. The carefully orchestrated intersections create points of convergence and divergence that guide the viewer''s eye through a maze of geometric relationships, each offering a different viewpoint on the same fundamental structure. The interplay between foreground and background elements generates depth and movement, while the strategic use of color helps differentiate between various perspective planes.', 'eb8961e6-d43c-4962-8472-6602d96e6aaf', 
        'VividWalls', 'Artwork',
        '{"Intersecting Perspectives"}', 'active', 
        'Intersecting Perspectives No3 24x36 Gallery Wrapped Canvas', 
        'Intersecting Perspectives No3from the Geometric Intersect collection showcases a sophisticated geometric abstract composition featuring intersecting lines and perspective shifts that create a complex visual narrative. This artwork demonstrates how linear elements can intersect to generate new spatial relationships and dimensional illusions that challenge conventional perspective. The carefully orchestrated intersections create points of convergence and divergence that guide the viewer''s eye through a maze of geometric relationships, each offering a different viewpoint on the same fundamental structure. The interplay between foreground and background elements generates depth and movement, while the strategic use of color helps differentiate between various perspective planes.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('12ed9068-3d6a-4d48-b5c7-48682729df35', '652353f2-1763-4484-aa39-202eb795478b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vividwalls.co_perspective_collection_intersecting_perspectives_no8_artwork.png?v=1737726080', 'intersecting-perspectives-no3 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('21647a2c-766b-461d-8dfa-1733242ffa3e', '652353f2-1763-4484-aa39-202eb795478b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid-geometric_intersection-no9b-remix.png?v=1736218984', 'intersecting-perspectives-no3 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('6d3a269d-5624-4edd-b12d-412e0fa1ba72', '652353f2-1763-4484-aa39-202eb795478b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vividwalls.co_perspective_collection_intersecting_perspectives_no8_artwork_47047437-37ab-44a1-bd59-2af0a72c49c1.png?v=1749128536', 'intersecting-perspectives-no3 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('be38a321-b47c-4756-8f75-f40d2a004cb6', '652353f2-1763-4484-aa39-202eb795478b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vividwalls.co_perspective_collection_intersecting_perspectives_no8_artwork_7be83b42-d6e5-4a3f-8c90-093ea4c2117d.png?v=1749141668', 'intersecting-perspectives-no3 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e4c6d00d-428d-4133-ab33-34446f181b63', '652353f2-1763-4484-aa39-202eb795478b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vividwalls.co_perspective_collection_intersecting_perspectives_no8_artwork_7be83b42-d6e5-4a3f-8c90-093ea4c2117d.png?v=1749141669', 'intersecting-perspectives-no3 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e8a31a6a-d8c4-4b94-aa96-61808e8299da', '652353f2-1763-4484-aa39-202eb795478b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vividwalls.co_perspective_collection_intersecting_perspectives_no8_artwork_7be83b42-d6e5-4a3f-8c90-093ea4c2117d.png?v=1749141670', 'intersecting-perspectives-no3 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 1);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('ca1606ed-e541-4041-a7b9-24f3de930d98', '652353f2-1763-4484-aa39-202eb795478b', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'INTERSECTING-PERSPECTIVES-NO3-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('d3c414d6-5444-4150-9841-cef724aab0d0', '652353f2-1763-4484-aa39-202eb795478b', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'INTERSECTING-PERSPECTIVES-NO3-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('00642556-90b1-45b1-9665-3186d397181e', '652353f2-1763-4484-aa39-202eb795478b', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'INTERSECTING-PERSPECTIVES-NO3-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('5639962e-05e3-4fc8-939d-fb8aadf984e8', '652353f2-1763-4484-aa39-202eb795478b', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'INTERSECTING-PERSPECTIVES-NO3-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('bf77a461-d07c-4e8d-b24e-d91488480201', '652353f2-1763-4484-aa39-202eb795478b', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'INTERSECTING-PERSPECTIVES-NO3-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('eefb18d2-b75e-4664-8356-d057611eec6e', '652353f2-1763-4484-aa39-202eb795478b', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'INTERSECTING-PERSPECTIVES-NO3-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('63facc48-ad76-48ab-9c6f-93be3ada14fc', 'intersecting-perspectives-no2', 'Intersecting Perspectives No2', 'Intersecting Perspectives No2from the Geometric Intersect collection presents a bold geometric composition featuring dynamic intersecting forms that create compelling visual dialogues between different dimensional perspectives. This artwork explores the fascinating interplay that occurs when geometric shapes meet, overlap, and influence each other''s visual presence. The intersecting elements generate new forms and negative spaces that weren''t present in the individual components, demonstrating how geometric interaction can create emergent complexity. The composition employs strategic color placement and angular relationships to guide the viewer''s eye through multiple visual pathways, each offering a different perspective on the same geometric relationships.', 'eb8961e6-d43c-4962-8472-6602d96e6aaf', 
        'VividWalls', 'Artwork',
        '{"Intersecting Perspectives"}', 'draft', 
        'Intersecting Perspectives No2 24x36 Gallery Wrapped Canvas', 
        'Intersecting Perspectives No2from the Geometric Intersect collection presents a bold geometric composition featuring dynamic intersecting forms that create compelling visual dialogues between different dimensional perspectives. This artwork explores the fascinating interplay that occurs when geometric shapes meet, overlap, and influence each other''s visual presence. The intersecting elements generate new forms and negative spaces that weren''t present in the individual components, demonstrating how geometric interaction can create emergent complexity. The composition employs strategic color placement and angular relationships to guide the viewer''s eye through multiple visual pathways, each offering a different perspective on the same geometric relationships.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0d15567c-74e7-4b51-bc2e-b66abcf719ca', '63facc48-ad76-48ab-9c6f-93be3ada14fc', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid-geometric_intersection-no9b-remix-4.png?v=1736218988', 'intersecting-perspectives-no2 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('f6b7710a-1584-4cad-aa2d-0915feb63269', '63facc48-ad76-48ab-9c6f-93be3ada14fc', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid-geometric_intersection-no9b-remix-4_cab94ec3-20b5-40df-a1dd-ccb0bee354e9.png?v=1749128533', 'intersecting-perspectives-no2 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b80b0b5d-3911-49bc-a121-3d105866b3b5', '63facc48-ad76-48ab-9c6f-93be3ada14fc', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid-geometric_intersection-no9b-remix-4_2b98eff5-4f06-471c-a479-7fe4b48db87e.png?v=1749141667', 'intersecting-perspectives-no2 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('8a20095f-d0a9-46f5-a761-7ba1ab7f82dc', '63facc48-ad76-48ab-9c6f-93be3ada14fc', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid-geometric_intersection-no9b-remix-4_2b98eff5-4f06-471c-a479-7fe4b48db87e.png?v=1749141668', 'intersecting-perspectives-no2 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('cbe8ce59-37a3-4290-90c0-551e37fff560', '63facc48-ad76-48ab-9c6f-93be3ada14fc', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid-geometric_intersection-no9b-remix-4_2b98eff5-4f06-471c-a479-7fe4b48db87e.png?v=1749141669', 'intersecting-perspectives-no2 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b0c16b3b-23a2-4e33-b518-826300edadb6', '63facc48-ad76-48ab-9c6f-93be3ada14fc', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid-geometric_intersection-no9b-remix-4_2b98eff5-4f06-471c-a479-7fe4b48db87e.png?v=1749141670', 'intersecting-perspectives-no2 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 1);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('c819dac9-a970-4fdb-9cdb-33861cc6f1bb', '63facc48-ad76-48ab-9c6f-93be3ada14fc', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'INTERSECTING-PERSPECTIVES-NO2-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('57efbbde-b5c3-4d12-b35a-ec31227c9c28', '63facc48-ad76-48ab-9c6f-93be3ada14fc', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'INTERSECTING-PERSPECTIVES-NO2-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('9922515a-8769-4403-a4e3-158078604ca4', '63facc48-ad76-48ab-9c6f-93be3ada14fc', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'INTERSECTING-PERSPECTIVES-NO2-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('72a58167-c58f-4280-bbab-8adbbd6f210e', '63facc48-ad76-48ab-9c6f-93be3ada14fc', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'INTERSECTING-PERSPECTIVES-NO2-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b977178f-2352-43f7-9615-ad8a24368322', '63facc48-ad76-48ab-9c6f-93be3ada14fc', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'INTERSECTING-PERSPECTIVES-NO2-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('25a29c3e-a8bb-405a-b86c-c12f9401418b', '63facc48-ad76-48ab-9c6f-93be3ada14fc', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'INTERSECTING-PERSPECTIVES-NO2-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('ecb2f734-684e-49b9-8667-3b9f46f2f60b', 'untiled-n011', 'Intersecting Perspectives No1', 'Intersecting Perspectives No.1 from the Resonating Structure collection is a compelling display of the artist''s ability to invoke depth through minimalistic design. This piece strikes a commanding presence, its bold monochromatic shapes creating a stark interplay of contrast and negative space. Here, the artist employs a palette of black, white, and greys to sculpt the illusion of volume and space. The composition is both geometrically rigorous and intriguingly imprecise, suggesting a fluidity of movement within its rigid bounds. The texture applied throughout the piece gives it a tactile quality, as if the shapes are carved out of the canvas itself. Intersecting Perspectives No.1 is a masterful exercise in restraint and intentionality, where the artist uses the absence of color to emphasize form and shadow, inviting the viewer to fill the voids with personal interpretation. The artwork is a meditation on the essence of form and the space it occupies, both physically and metaphorically.', 'eb8961e6-d43c-4962-8472-6602d96e6aaf', 
        'VividWalls', 'Artwork',
        '{"Intersecting Perspectives"}', 'active', 
        'Intersecting Perspectives No1 24x36 Gallery Wrapped Canvas', 
        'Intersecting Perspectives No.1 from the Resonating Structure collection is a compelling display of the artist''s ability to invoke depth through minimalistic design. This piece strikes a commanding presence, its bold monochromatic shapes creating a stark interplay of contrast and negative space. Here, the artist employs a palette of black, white, and greys to sculpt the illusion of volume and space. The composition is both geometrically rigorous and intriguingly imprecise, suggesting a fluidity of movement within its rigid bounds. The texture applied throughout the piece gives it a tactile quality, as if the shapes are carved out of the canvas itself. Intersecting Perspectives No.1 is a masterful exercise in restraint and intentionality, where the artist uses the absence of color to emphasize form and shadow, inviting the viewer to fill the voids with personal interpretation. The artwork is a meditation on the essence of form and the space it occupies, both physically and metaphorically.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('aa4fcae8-5a9c-4ff2-a041-dc3b4676c54c', 'ecb2f734-684e-49b9-8667-3b9f46f2f60b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vividwalls.co_perspective_collection_intersecting_perspectives_no8_artwork.png?v=1737726080', 'untiled-n011 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('88d7fba5-f6c8-4880-978a-8e2f63d20d08', 'ecb2f734-684e-49b9-8667-3b9f46f2f60b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid-geometric_intersection-no9b-remix.png?v=1736218984', 'untiled-n011 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('6a05b3e1-8ab3-4ccb-be8b-7dc9e8e3c9b2', 'ecb2f734-684e-49b9-8667-3b9f46f2f60b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vividwalls.co_perspective_collection_intersecting_perspectives_no8_artwork_bb305879-9e80-49b5-81ec-40f588445be6.png?v=1749128529', 'untiled-n011 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('19fac03c-2041-4e82-bfb2-753178a8b11d', 'ecb2f734-684e-49b9-8667-3b9f46f2f60b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vividwalls.co_perspective_collection_intersecting_perspectives_no8_artwork_147a35a3-dfee-40ac-8c36-4ad64a9a8b9e.png?v=1749141665', 'untiled-n011 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('89ee58e8-0cde-42d7-b343-01b8e1555ae5', 'ecb2f734-684e-49b9-8667-3b9f46f2f60b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vividwalls.co_perspective_collection_intersecting_perspectives_no8_artwork_147a35a3-dfee-40ac-8c36-4ad64a9a8b9e.png?v=1749141666', 'untiled-n011 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('ae7dfdc7-6c1d-4666-8736-aa58730e22e5', 'ecb2f734-684e-49b9-8667-3b9f46f2f60b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vividwalls.co_perspective_collection_intersecting_perspectives_no8_artwork_147a35a3-dfee-40ac-8c36-4ad64a9a8b9e.png?v=1749141667', 'untiled-n011 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 1);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('093370ea-e4d8-4eff-aed1-4ec9caba4af1', 'ecb2f734-684e-49b9-8667-3b9f46f2f60b', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'UNTILED-N011-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('6ad8ecb9-759d-4da7-a4d1-25d9ca04ff9b', 'ecb2f734-684e-49b9-8667-3b9f46f2f60b', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'UNTILED-N011-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('19e3ea28-6f5d-4dc0-b95e-e712226d7a23', 'ecb2f734-684e-49b9-8667-3b9f46f2f60b', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'UNTILED-N011-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('6fb06048-e976-4007-a491-8ae983ad2509', 'ecb2f734-684e-49b9-8667-3b9f46f2f60b', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'UNTILED-N011-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b5cb9dbd-d648-4d2c-b256-b403ab01d2c7', 'ecb2f734-684e-49b9-8667-3b9f46f2f60b', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'UNTILED-N011-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('0f3a07a3-8cae-4ddb-a8e2-2358668bfb12', 'ecb2f734-684e-49b9-8667-3b9f46f2f60b', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'UNTILED-N011-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('2d2b30b4-2c12-4109-8c99-7227252cac20', 'deep-echoes', 'Deep Echoes', 'Deep Echoes from the Chromatic Echoes collection showcases a vibrant geometric composition that evokes the shimmering facets of a gemstone. The piece is characterized by layers of overlapping shapes in varying shades of deep blues, creating a visual depth that suggests a multifaceted surface. The central alignment and mirroring of shapes give the artwork a balanced and harmonious aesthetic, reminiscent of the symmetry found in natural crystals.', '89a9ed3a-a6eb-4abb-a69c-e6d07bfc2dcb', 
        'VividWalls', 'Artwork',
        '{"Chromatic Echoes"}', 'active', 
        'Deep Echoes 53x72 Gallery Wrapped Canvas', 
        'Deep Echoes from the Chromatic Echoes collection showcases a vibrant geometric composition that evokes the shimmering facets of a gemstone. The piece is characterized by layers of overlapping shapes in varying shades of deep blues, creating a visual depth that suggests a multifaceted surface. The central alignment and mirroring of shapes give the artwork a balanced and harmonious aesthetic, reminiscent of the symmetry found in natural crystals.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('42efa591-5bfa-4942-8659-dab2bffde163', '2d2b30b4-2c12-4109-8c99-7227252cac20', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_deep_no1_black_frame_53x72_9eef57ca-4dce-4ed9-853d-0097eaebab0a.png?v=1713722113', 'deep-echoes Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('de0d1c7a-dac3-4521-8a80-afc53bc2b29b', '2d2b30b4-2c12-4109-8c99-7227252cac20', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_deep_no1_no_frame_53x72_db98bf74-d666-4c20-9c9c-fa6b0a04baaf.png?v=1713722113', 'deep-echoes Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('f9e91b09-516b-451a-a31d-cd13f53b68e4', '2d2b30b4-2c12-4109-8c99-7227252cac20', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_deep_no1_white_frame_53x72_bfa08f74-e7b6-4918-8c87-9bd450dcf770.png?v=1713722113', 'deep-echoes Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('9632e2bf-5934-4073-ab1c-ae3fd459c7c6', '2d2b30b4-2c12-4109-8c99-7227252cac20', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_deep_no1_canvas_white_frame_36x48_77e0a0b9-2f42-419f-b61f-55891f8e1777.png?v=1713722113', 'deep-echoes Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('64d8ed80-90cc-4f08-bfb7-33e41b55aa04', '2d2b30b4-2c12-4109-8c99-7227252cac20', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_deep_no1_canvas_black_frame_36x48_2054e543-c660-41e8-a8a0-a7c91272e953.png?v=1713722113', 'deep-echoes Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('734f4496-bdcf-49f4-9a67-6e4eecb55b4a', '2d2b30b4-2c12-4109-8c99-7227252cac20', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_deep_no1_canvas_no_frame_36x48_7c27050e-b0b1-4f72-8bd7-8d98ed4389b3.png?v=1713722113', 'deep-echoes Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('846facbd-dd8f-486d-8a3c-9422f3904da2', '2d2b30b4-2c12-4109-8c99-7227252cac20', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'DEEP-ECHOES-GALLERY-WRAPPED-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b21adce0-90fc-4c6a-a8e0-d31592784d1c', '2d2b30b4-2c12-4109-8c99-7227252cac20', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'DEEP-ECHOES-GALLERY-WRAPPED-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('dda8f0fd-c3ef-4a58-90b6-87251e19cbe8', '2d2b30b4-2c12-4109-8c99-7227252cac20', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'DEEP-ECHOES-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('9a2a49bc-7aac-4671-a657-750e1be6e157', '2d2b30b4-2c12-4109-8c99-7227252cac20', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'DEEP-ECHOES-GALLERY-WRAPPED-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('598a69c6-e504-4b6f-aa2d-dacb6cccc0c4', '2d2b30b4-2c12-4109-8c99-7227252cac20', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'DEEP-ECHOES-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('e534a8b1-5a75-4a1c-8a29-6bc7bf4225e4', '2d2b30b4-2c12-4109-8c99-7227252cac20', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'DEEP-ECHOES-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('d7f27d5e-2c73-4c77-9c1e-1932628663e0', 'space-form-no4', 'Space & Form no4', 'Space &amp; Form no4 from the Resonating Structure collection presents an abstract geometric artwork that explores the fundamental concepts of space and form through sophisticated digital composition. This piece investigates how geometric elements can define, occupy, and transform space while simultaneously being shaped by their spatial context. The artwork demonstrates the dynamic relationship between positive and negative space, showing how form can emerge from emptiness and how emptiness can define form. Through careful manipulation of scale, positioning, and color relationships, the composition creates a sense of dimensional depth that transcends the flat digital medium. Each geometric element serves both as an individual form and as a contributor to the larger spatial narrative, creating a complex dialogue between parts and whole that invites contemplation of how we perceive and understand three-dimensional relationships in a two-dimensional space.', '041bbb17-d7a1-4e6b-9be1-0b680c56096e', 
        'VividWalls', 'Artwork',
        '{"Space Form"}', 'active', 
        'Space & Form no4 53x72 Gallery Wrapped Canvas', 
        'Space &amp; Form no4 from the Resonating Structure collection presents an abstract geometric artwork that explores the fundamental concepts of space and form through sophisticated digital composition. This piece investigates how geometric elements can define, occupy, and transform space while simultaneously being shaped by their spatial context. The artwork demonstrates the dynamic relationship between positive and negative space, showing how form can emerge from emptiness and how emptiness can define form. Through careful manipulation of scale, positioning, and color relationships, the composition creates a sense of dimensional depth that transcends the flat digital medium. Each geometric element serves both as an individual form and as a contributor to the larger spatial narrative, creating a complex dialogue between parts and whole that invites contemplation of how we perceive and understand three-dimensional relationships in a two-dimensional space.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('37ff1b22-f349-4c2a-a3bf-ffae0910fa8c', 'd7f27d5e-2c73-4c77-9c1e-1932628663e0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no5_black_frame_53x72_a52e3b13-f19f-4e58-a276-dc5a137fcdd0.png?v=1713722349', 'space-form-no4 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('da5d0efe-ef64-4f7b-9fb3-2493b68b3723', 'd7f27d5e-2c73-4c77-9c1e-1932628663e0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no5_no_frame_53x72_c9199580-9bf3-4e3c-8236-c0a022a80023.png?v=1713722349', 'space-form-no4 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('3b9eeec1-3de8-4e36-9744-8d7611c3abea', 'd7f27d5e-2c73-4c77-9c1e-1932628663e0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no5_white_frame_53x72_2bf0790a-e6f3-43b7-8efb-1d781ac12d34.png?v=1713722349', 'space-form-no4 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('6e8967f8-3fe2-400e-ae30-8e37586dfc41', 'd7f27d5e-2c73-4c77-9c1e-1932628663e0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no5_white_frame_36x48_8efaa11d-d091-445f-9c4e-30a720705498.png?v=1713722350', 'space-form-no4 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b5dad323-2fd8-46a8-85c4-5104470c7f17', 'd7f27d5e-2c73-4c77-9c1e-1932628663e0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no3_black_frame_36x48_3b06933c-fa1a-4a12-a0b8-31538d7419ad.png?v=1713722350', 'space-form-no4 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('c798a53f-f782-4c96-8862-7185cff8c9f3', 'd7f27d5e-2c73-4c77-9c1e-1932628663e0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no5_no_frame_36x48_4de377ac-81ab-44c6-92e1-fc9732383fa2.png?v=1713722350', 'space-form-no4 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('41622bd5-3c6f-4069-8cbd-2267e2167b05', 'd7f27d5e-2c73-4c77-9c1e-1932628663e0', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'SPACE-FORM-NO4-GALLERY-WRAPPED-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('812d2db9-34df-4bb6-a781-a69e0b7832e1', 'd7f27d5e-2c73-4c77-9c1e-1932628663e0', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'SPACE-FORM-NO4-GALLERY-WRAPPED-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('880e3bb9-f9e0-496d-81f4-27338cdbe6ff', 'd7f27d5e-2c73-4c77-9c1e-1932628663e0', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'SPACE-FORM-NO4-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4373dcba-a695-4255-b93c-676f2c73d1c2', 'd7f27d5e-2c73-4c77-9c1e-1932628663e0', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'SPACE-FORM-NO4-GALLERY-WRAPPED-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('9a2ff303-768d-4fcf-82f0-969530fdaebb', 'd7f27d5e-2c73-4c77-9c1e-1932628663e0', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'SPACE-FORM-NO4-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('a23fa06c-74d1-49e4-b543-7f8174c37462', 'd7f27d5e-2c73-4c77-9c1e-1932628663e0', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'SPACE-FORM-NO4-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('c819c0e2-03ff-4c44-9c59-ecd4ca4fe4e2', 'vista-echoes', 'Vista Echoes', 'Vista Echoes from the Chromatic Echoes collection presents an evocative play of shapes and colors that echo the depth and vastness of a panoramic view. Deep blues and purples form the foundation of the piece, suggesting the mysteries of the twilight sky or the depths of the ocean. Intersecting geometric forms in contrasting hues of pink and lighter blue create an illusion of light refracting through a prism, offering a sense of dimensionality and complexity.', '89a9ed3a-a6eb-4abb-a69c-e6d07bfc2dcb', 
        'VividWalls', 'Artwork',
        '{"Chromatic Echoes"}', 'draft', 
        'Vista Echoes 24x36 Gallery Wrapped Canvas', 
        'Vista Echoes from the Chromatic Echoes collection presents an evocative play of shapes and colors that echo the depth and vastness of a panoramic view. Deep blues and purples form the foundation of the piece, suggesting the mysteries of the twilight sky or the depths of the ocean. Intersecting geometric forms in contrasting hues of pink and lighter blue create an illusion of light refracting through a prism, offering a sense of dimensionality and complexity.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('df165657-65ae-4de7-9595-250aa92cf2c3', 'c819c0e2-03ff-4c44-9c59-ecd4ca4fe4e2', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_emerald_no1_canvas_black_frame_53x72_bb2293db-b647-40c6-992d-9c531efb6d00.png?v=1713064047', 'vista-echoes Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('ef40af91-a474-4ca7-adc8-69e514a56b46', 'c819c0e2-03ff-4c44-9c59-ecd4ca4fe4e2', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_emerald_no1_canvas_white_frame_53x72_dba83b50-3ef0-47b3-a4bd-32cfaf5ab323.png?v=1713064047', 'vista-echoes Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('ea4aa756-af62-43eb-9bc3-e2764acddeb2', 'c819c0e2-03ff-4c44-9c59-ecd4ca4fe4e2', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_emerald_no1_canvas_no_frame_53x72_95cdfa3d-a86d-4d72-a90a-5f6a605525ff.png?v=1713064048', 'vista-echoes Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('2db158fc-ce19-4280-8911-0470a2888eb2', 'c819c0e2-03ff-4c44-9c59-ecd4ca4fe4e2', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_emerald_no1_canvas_no_frame_36x48_0be81b24-d26b-4263-8fbd-c1aaf6623e7b.png?v=1713064048', 'vista-echoes Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('bab5c9b9-1fd4-41ac-83b7-9b56bb494bc9', 'c819c0e2-03ff-4c44-9c59-ecd4ca4fe4e2', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_emerald_no1_canvas_white_frame_36x48_ef0b1bb9-861d-4427-83d0-813fb526679c.png?v=1713064048', 'vista-echoes Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e1f485f2-0750-4d99-ba99-3d9d84b97075', 'c819c0e2-03ff-4c44-9c59-ecd4ca4fe4e2', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/ChromaticEchos_emerald_no1_canvas_black_frame_36x48_c1817d3f-aead-4592-8f0e-157a0e098973.png?v=1713064048', 'vista-echoes Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('d4be3597-f629-4009-8625-f791e257a8cc', 'c819c0e2-03ff-4c44-9c59-ecd4ca4fe4e2', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VISTA-ECHOES-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('536be4af-6d82-402f-8021-a354642e5d86', 'c819c0e2-03ff-4c44-9c59-ecd4ca4fe4e2', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VISTA-ECHOES-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('bd9142ca-0fef-45a5-8c6c-f59787b1188a', 'c819c0e2-03ff-4c44-9c59-ecd4ca4fe4e2', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VISTA-ECHOES-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('3178324f-9ab7-47e0-bbe4-01d49c4a9139', 'c819c0e2-03ff-4c44-9c59-ecd4ca4fe4e2', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VISTA-ECHOES-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('7dacd448-3519-45d4-844f-e5ce9993b3e6', 'c819c0e2-03ff-4c44-9c59-ecd4ca4fe4e2', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VISTA-ECHOES-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('769f3f0a-1fd1-4c9e-b0ef-ced7ca2a8b56', 'c819c0e2-03ff-4c44-9c59-ecd4ca4fe4e2', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VISTA-ECHOES-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('3cff05c4-5438-4f24-afcd-999ddab9200d', 'noir-echoes', 'Noir Echoes', 'Noir Echoesfrom the Chromatic Echoes collection by the artist is a visually striking digital tapestry that weaves together depth, contrast, and geometric symmetry. This piece delves into the monochromatic spectrum, masterfully playing with shades from the darkest black to the brightest white to create a symphonic visual experience. The art gives a nod to the op art movement, with its potential to evoke movement through static imagery. Staring at the artwork, one might feel the pulsating patterns and shifting planes, as the gradients of gray add a gentle rhythm to the starkness of the black and white. ''Chromatic Echoes Noir'' is a modern exploration of the enduring power of grayscale, utilizing digital means to create a timeless aesthetic. It stands as a bold statement on the power of simplicity and the intricate beauty that can be found within a restricted color palette.', '89a9ed3a-a6eb-4abb-a69c-e6d07bfc2dcb', 
        'VividWalls', 'Artwork',
        '{"Chromatic Echoes"}', 'active', 
        'Noir Echoes 53x72 Gallery Wrapped Canvas', 
        'Noir Echoesfrom the Chromatic Echoes collection by the artist is a visually striking digital tapestry that weaves together depth, contrast, and geometric symmetry. This piece delves into the monochromatic spectrum, masterfully playing with shades from the darkest black to the brightest white to create a symphonic visual experience. The art gives a nod to the op art movement, with its potential to evoke movement through static imagery. Staring at the artwork, one might feel the pulsating patterns and shifting planes, as the gradients of gray add a gentle rhythm to the starkness of the black and white. ''Chromatic Echoes Noir'' is a modern exploration of the enduring power of grayscale, utilizing digital means to create a timeless aesthetic. It stands as a bold statement on the power of simplicity and the intricate beauty that can be found within a restricted color palette.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0e1ca002-2ca6-43b9-bbc1-effa317813fb', '3cff05c4-5438-4f24-afcd-999ddab9200d', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_noir_canvas_black_frame_53x72_07b275fb-5cbe-4ef9-a4a4-c1ad49340830.png?v=1713722143', 'noir-echoes Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('09f2efbf-2762-4df1-8727-a90842e36032', '3cff05c4-5438-4f24-afcd-999ddab9200d', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_noir_canvas_no_frame_53x72_f79cb208-f01f-46fe-9704-8d99cafd8ca4.png?v=1713722143', 'noir-echoes Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b8d13823-5136-48cc-8e5d-a612d1d91f04', '3cff05c4-5438-4f24-afcd-999ddab9200d', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_noir_canvas_white_frame_53x72_d0b5e06a-0b06-4116-86a4-6b0077f4186c.png?v=1713722143', 'noir-echoes Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('4f7530e7-3668-40a3-aef7-f2d6d573e8cc', '3cff05c4-5438-4f24-afcd-999ddab9200d', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_noir_canvas_white_frame_36x48_bd4b310d-ea26-4c03-8661-8d5feab8461f.png?v=1713722143', 'noir-echoes Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('d9a63e00-fc70-4438-8d55-7d298a082d16', '3cff05c4-5438-4f24-afcd-999ddab9200d', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_noir_canvas_black_frame_36x48_9e896ea0-fc49-4015-98d1-56b79aa8d12a.png?v=1713722143', 'noir-echoes Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('01c47f21-61eb-457f-b914-9d4b0e426e9b', '3cff05c4-5438-4f24-afcd-999ddab9200d', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_noir_canvas_no_frame_36x48_92d20465-041f-4f28-82eb-1f2466c2f90d.png?v=1713722143', 'noir-echoes Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('17ff450d-9d4f-4a20-9c84-115f4b1b3a9e', '3cff05c4-5438-4f24-afcd-999ddab9200d', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-ECHOES-GALLERY-WRAPPED-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('6d45fdb6-cead-43b9-ad1b-0ad34ce39ed9', '3cff05c4-5438-4f24-afcd-999ddab9200d', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-ECHOES-GALLERY-WRAPPED-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('52640205-c32a-4aa3-a81c-a87fc98b43cc', '3cff05c4-5438-4f24-afcd-999ddab9200d', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-ECHOES-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('627d74a2-bced-4211-9402-6750190e11b7', '3cff05c4-5438-4f24-afcd-999ddab9200d', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-ECHOES-GALLERY-WRAPPED-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('d0819c85-3104-4973-903f-4d3e3f6ebec8', '3cff05c4-5438-4f24-afcd-999ddab9200d', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-ECHOES-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('e4b978e6-41e9-4475-9dee-790bfa86d8cb', '3cff05c4-5438-4f24-afcd-999ddab9200d', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-ECHOES-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('d1e7d34c-9a86-4ab3-9de3-a34f07a52afe', 'emerald-echoes', 'Emerald Echoes', 'Emerald Echoesfrom the Chromatic Echoes collection captures the lush vibrancy of emerald gemstones through geometric abstraction. This piece features rich, verdant green tones that cascade through layered polygonal forms, creating a visual symphony reminiscent of light filtering through precious stones. The interplay of various green shades—from deep forest to bright lime—generates a sense of natural energy and growth. The geometric structures overlap and intersect, forming crystalline patterns that suggest both organic growth and precise architectural design. Each faceted surface reflects different intensities of green, creating depth and movement that draws the viewer into its emerald embrace. The composition balances bold geometric precision with the fluid, organic essence of nature''s most treasured green gem.', '89a9ed3a-a6eb-4abb-a69c-e6d07bfc2dcb', 
        'VividWalls', 'Artwork',
        '{"Chromatic Echoes"}', 'active', 
        'Emerald Echoes 53x72 Gallery Wrapped Canvas', 
        'Emerald Echoesfrom the Chromatic Echoes collection captures the lush vibrancy of emerald gemstones through geometric abstraction. This piece features rich, verdant green tones that cascade through layered polygonal forms, creating a visual symphony reminiscent of light filtering through precious stones. The interplay of various green shades—from deep forest to bright lime—generates a sense of natural energy and growth. The geometric structures overlap and intersect, forming crystalline patterns that suggest both organic growth and precise architectural design. Each faceted surface reflects different intensities of green, creating depth and movement that draws the viewer into its emerald embrace. The composition balances bold geometric precision with the fluid, organic essence of nature''s most treasured green gem.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('35b5e7f2-02b9-4f5a-a920-c32b7a5d8f08', 'd1e7d34c-9a86-4ab3-9de3-a34f07a52afe', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_emerald_no1_canvas_black_frame_53x72_bafdaa39-33d2-4dcc-8e71-b7849723b420.png?v=1713722085', 'emerald-echoes Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('97e31243-4a87-4d22-9f15-3b5dd4c945d4', 'd1e7d34c-9a86-4ab3-9de3-a34f07a52afe', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_emerald_no1_canvas_no_frame_53x72_33b9293d-2648-437d-830e-323cb6170dcb.png?v=1713722085', 'emerald-echoes Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0fb198cd-38ff-46d7-9256-9d25c7172b7f', 'd1e7d34c-9a86-4ab3-9de3-a34f07a52afe', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_emerald_no1_canvas_white_frame_53x72_63a01a84-1e36-42c7-853d-e7a3c6873145.png?v=1713722085', 'emerald-echoes Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b789b289-824c-45df-ab36-9d8241a01fb4', 'd1e7d34c-9a86-4ab3-9de3-a34f07a52afe', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_emerald_no1_canvas_white_frame_36x48_46d3a721-3bc4-40f8-8bba-7c5e356754cb.png?v=1713722085', 'emerald-echoes Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('226b4b2c-2b97-4c5d-b6b7-5d889f747475', 'd1e7d34c-9a86-4ab3-9de3-a34f07a52afe', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_emerald_no1_canvas_no_frame_36x48_d75ca18a-15a7-4504-aa07-f67b2f49dc38.png?v=1713722085', 'emerald-echoes Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('039661cf-494a-432c-8f82-ce6990d7735e', 'd1e7d34c-9a86-4ab3-9de3-a34f07a52afe', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/ChromaticEchos_emerald_no1_canvas_black_frame_36x48_d1d45c1f-700f-434d-85ec-02d6fa935a18.png?v=1713722085', 'emerald-echoes Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('f9e60d15-1d6d-40bd-bced-5387ecfe44fb', 'd1e7d34c-9a86-4ab3-9de3-a34f07a52afe', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EMERALD-ECHOES-GALLERY-WRAPPED-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('ba6eabb7-ff65-46a2-9910-8c9156300126', 'd1e7d34c-9a86-4ab3-9de3-a34f07a52afe', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EMERALD-ECHOES-GALLERY-WRAPPED-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4491c71d-b0e0-46b3-94ba-7b116c0c3cbb', 'd1e7d34c-9a86-4ab3-9de3-a34f07a52afe', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EMERALD-ECHOES-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('9705d0c9-6604-4e77-937f-bf8d56d52165', 'd1e7d34c-9a86-4ab3-9de3-a34f07a52afe', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EMERALD-ECHOES-GALLERY-WRAPPED-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('69cfc602-b971-4a68-a929-5ba69c894375', 'd1e7d34c-9a86-4ab3-9de3-a34f07a52afe', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EMERALD-ECHOES-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('8b5d5893-937f-467f-9a11-e19fd3ceb77d', 'd1e7d34c-9a86-4ab3-9de3-a34f07a52afe', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EMERALD-ECHOES-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('fe6219c8-b28b-4f9c-8841-8a1ca78d0e93', 'earth-echoes', 'Earth Echoes', 'Earth from the Geometric Symmetry collection features a symmetrical design, with a color palette that evokes the richness of the earth. The artwork weaves together a tapestry of red, blue, and golden hues, intersected by sharp geometric shapes and a central column that could symbolize the spine of traditional Japanese attire. The intricate overlay of textures and the gradient of colors create a sense of depth and sophistication.', '89a9ed3a-a6eb-4abb-a69c-e6d07bfc2dcb', 
        'VividWalls', 'Artwork',
        '{"Chromatic Echoes"}', 'draft', 
        'Earth Echoes 24x36 Gallery Wrapped Canvas', 
        'Earth from the Geometric Symmetry collection features a symmetrical design, with a color palette that evokes the richness of the earth. The artwork weaves together a tapestry of red, blue, and golden hues, intersected by sharp geometric shapes and a central column that could symbolize the spine of traditional Japanese attire. The intricate overlay of textures and the gradient of colors create a sense of depth and sophistication.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('fccbe5d3-78c1-4687-8e64-f7f2cffdd333', 'fe6219c8-b28b-4f9c-8841-8a1ca78d0e93', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_earthy_no1_black_frame_53x72_4266564f-a1a2-4934-bdad-ca503c5141e4.png?v=1713722054', 'earth-echoes Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('11f111ff-22b2-4872-b9e9-91a66620e243', 'fe6219c8-b28b-4f9c-8841-8a1ca78d0e93', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_earthy_no1_white_frame_53x72_619bd69a-a3bf-42f7-9a7e-cc647cfe1229.png?v=1713722054', 'earth-echoes Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('8ff77f9c-208c-4249-87f2-fa8c654140bf', 'fe6219c8-b28b-4f9c-8841-8a1ca78d0e93', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_earthy_no1_no_frame_53x72_e6c29da4-8eb4-470b-8c56-1f87363bc141.png?v=1713722055', 'earth-echoes Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('457080ba-05c2-463a-9425-3fa38545643c', 'fe6219c8-b28b-4f9c-8841-8a1ca78d0e93', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_earthy_no1_canvas_black_frame_36x48_41416693-b92d-462f-a29c-6768491b2a71.png?v=1713722055', 'earth-echoes Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('1b5d3f99-575a-4765-b5d5-9a2caf5eea85', 'fe6219c8-b28b-4f9c-8841-8a1ca78d0e93', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_earthy_no1_canvas_white_frame_36x48_1278c745-c3db-4d6a-80fb-72c1c5a790ea.png?v=1713722055', 'earth-echoes Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('6285596d-dbe2-442c-8fbc-e013b7448cb1', 'fe6219c8-b28b-4f9c-8841-8a1ca78d0e93', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/chromatic_echos_earthy_no1_canvas_no_frame_36x48_f24923fd-aeba-4a73-b30d-df5c283b9f3e.png?v=1713722055', 'earth-echoes Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('745f5a38-1039-46f6-8ce5-f0866bad9479', 'fe6219c8-b28b-4f9c-8841-8a1ca78d0e93', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EARTH-ECHOES-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('0205c01d-fe97-49d2-9c49-d31ed0c5746f', 'fe6219c8-b28b-4f9c-8841-8a1ca78d0e93', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EARTH-ECHOES-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('81eac34b-942d-4a8e-b2f0-2ffc046ce091', 'fe6219c8-b28b-4f9c-8841-8a1ca78d0e93', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EARTH-ECHOES-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('167e5300-241c-41f1-9264-4f12114c4559', 'fe6219c8-b28b-4f9c-8841-8a1ca78d0e93', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EARTH-ECHOES-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('448f5f8b-2b22-46df-b932-256e18bbce35', 'fe6219c8-b28b-4f9c-8841-8a1ca78d0e93', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EARTH-ECHOES-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('992a7b1b-b1d3-4cc5-8e02-c637645bdf0c', 'fe6219c8-b28b-4f9c-8841-8a1ca78d0e93', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EARTH-ECHOES-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('679ddf03-c0d3-43ed-8076-e475256b507f', 'space-form-no3', 'Space & Form no3', '<p>Space &amp; Form no3 from the Resonating Structure collection presents a compelling geometric exploration of texture and space that demonstrates the sophisticated interplay between two-dimensional design and three-dimensional illusion. This artwork masterfully employs geometric forms to create spatial depth and textural richness that challenges the viewer''s perception of flat digital surfaces. The composition features carefully orchestrated arrangements of shapes that seem to float, intersect, and layer in impossible configurations, creating a sense of architectural impossibility. The textural elements add tactile quality to the digital medium, while the spatial relationships generate a dynamic tension that keeps the eye engaged. Each geometric element contributes to an overall sense of structured chaos, where order and complexity coexist in perfect balance.</p>', '041bbb17-d7a1-4e6b-9be1-0b680c56096e', 
        'VividWalls', 'Artwork',
        '{"Space Form"}', 'active', 
        'Space & Form no3 24x36 Gallery Wrapped Canvas', 
        '<p>Space &amp; Form no3 from the Resonating Structure collection presents a compelling geometric exploration of texture and space that demonstrates the sophisticated interplay between two-dimensional design and three-dimensional illusion. This artwork masterfully employs geometric forms to create spatial depth and textural richness that challenges the viewer''s perception of flat digital surfaces. The composition features carefully orchestrated arrangements of shapes that seem to float, intersect, and layer in impossible configurations, creating a sense of architectural impossibility. The textural elements add tactile quality to the digital medium, while the spatial relationships generate a dynamic tension that keeps the eye engaged. Each geometric element contributes to an overall sense of structured chaos, where order and complexity coexist in perfect balance.</p>');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('c6a2ee90-3e2d-4696-8901-9534634b2623', '679ddf03-c0d3-43ed-8076-e475256b507f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no3_black_frame_53x72_3c0621e9-98df-4fa7-a62b-40c6a5f8c9d2.png?v=1713722322', 'space-form-no3 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e9f4a4d9-f448-4417-b884-8830d65ee4e0', '679ddf03-c0d3-43ed-8076-e475256b507f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no3_white_frame_53x72_63e211aa-d2ee-4795-a1ae-7d6c86e9ba0c.png?v=1713722322', 'space-form-no3 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('f15f0c44-b96e-4c98-be72-a6fa14b40f11', '679ddf03-c0d3-43ed-8076-e475256b507f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no3_no_frame_53x72_2634a332-4911-4c58-ae15-ff334098a862.png?v=1713722322', 'space-form-no3 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('3324a6c3-e22f-412b-b22f-9ecf0cdd7bbd', '679ddf03-c0d3-43ed-8076-e475256b507f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no3_black_frame_36x48_65e01ac3-7317-4614-9edb-9d78eeb47b13.png?v=1713722322', 'space-form-no3 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('11bdd1a4-5d10-45ee-b2bd-35c33c79d2f7', '679ddf03-c0d3-43ed-8076-e475256b507f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no3_white_frame_36x48_d8039894-998c-4ee9-884b-1860f677cf3b.png?v=1713722322', 'space-form-no3 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('90350215-7f24-4bc0-a02c-2462966e132b', '679ddf03-c0d3-43ed-8076-e475256b507f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no3_no_frame_36x48_f2d19a2b-1e56-4869-9629-57e21bbe0719.png?v=1713722322', 'space-form-no3 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('01fcf884-e4b0-45eb-bfc1-c89b4a9a4278', '679ddf03-c0d3-43ed-8076-e475256b507f', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'SPACE-FORM-NO3-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('d53fb0ab-deae-41e3-905f-db5b7677efd6', '679ddf03-c0d3-43ed-8076-e475256b507f', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'SPACE-FORM-NO3-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('d7fbd1a7-871c-4cc9-a974-6ae8e9ed6e21', '679ddf03-c0d3-43ed-8076-e475256b507f', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'SPACE-FORM-NO3-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4f33c3e3-2d63-4725-b54a-8f417049c389', '679ddf03-c0d3-43ed-8076-e475256b507f', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'SPACE-FORM-NO3-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('0701eece-53c8-4871-9236-22fa94e4ae93', '679ddf03-c0d3-43ed-8076-e475256b507f', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'SPACE-FORM-NO3-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('e97b2d64-78ab-435a-9d86-8c08aec37f8c', '679ddf03-c0d3-43ed-8076-e475256b507f', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'SPACE-FORM-NO3-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('d3b91aa4-32ae-4d75-b5d4-8b5308f16e7e', 'space-form-no2', 'Space & Form no2', 'Space &amp; Form No.2 from the Resonating Structure collection is a compelling display of the artist''s ability to invoke depth through minimalistic design. This piece strikes a commanding presence, its bold monochromatic shapes creating a stark interplay of contrast and negative space. Here, the artist employs a palette of black, white, and greys to sculpt the illusion of volume and space. The composition is both geometrically rigorous and intriguingly imprecise, suggesting a fluidity of movement within its rigid bounds. The texture applied throughout the piece gives it a tactile quality, as if the shapes are carved out of the canvas itself. ''Space &amp; Form No.2'' is a masterful exercise in restraint and intentionality, where the artist uses the absence of color to emphasize form and shadow, inviting the viewer to fill the voids with personal interpretation. The artwork is a meditation on the essence of form and the space it occupies, both physically and metaphorically.', '041bbb17-d7a1-4e6b-9be1-0b680c56096e', 
        'VividWalls', 'Artwork',
        '{"Space Form"}', 'active', 
        'Space & Form no2 24x36 Gallery Wrapped Canvas', 
        'Space &amp; Form No.2 from the Resonating Structure collection is a compelling display of the artist''s ability to invoke depth through minimalistic design. This piece strikes a commanding presence, its bold monochromatic shapes creating a stark interplay of contrast and negative space. Here, the artist employs a palette of black, white, and greys to sculpt the illusion of volume and space. The composition is both geometrically rigorous and intriguingly imprecise, suggesting a fluidity of movement within its rigid bounds. The texture applied throughout the piece gives it a tactile quality, as if the shapes are carved out of the canvas itself. ''Space &amp; Form No.2'' is a masterful exercise in restraint and intentionality, where the artist uses the absence of color to emphasize form and shadow, inviting the viewer to fill the voids with personal interpretation. The artwork is a meditation on the essence of form and the space it occupies, both physically and metaphorically.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('31de9916-b882-429e-af2a-2c20fc9097bb', 'd3b91aa4-32ae-4d75-b5d4-8b5308f16e7e', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_noir_no1_black_frame_53x72_55315629-4452-46ab-9f69-5a86e0f2166f.png?v=1713722289', 'space-form-no2 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('4b2cb4f4-a66e-487b-a0b7-da9a52c768ab', 'd3b91aa4-32ae-4d75-b5d4-8b5308f16e7e', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_noir_no1_white_frame_53x72_300abbf2-7a63-4749-80ec-db3c375dc871.png?v=1713722289', 'space-form-no2 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('eae2e280-fc31-4cc2-9ac7-7cd975d169fb', 'd3b91aa4-32ae-4d75-b5d4-8b5308f16e7e', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_noir_no1_no_frame_36x48-2_829e3d3e-31b2-49d8-af88-b696c83571bf.png?v=1713722289', 'space-form-no2 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0cebaa6f-55a4-43c4-b3bc-8d69fc3986fc', 'd3b91aa4-32ae-4d75-b5d4-8b5308f16e7e', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_noir_no1_white_frame_36x48_06bdcd9d-ebb1-4cfb-a1d1-f37d05666eac.png?v=1713722289', 'space-form-no2 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('7aed0cd0-761a-4473-b5b0-8f9ac5779660', 'd3b91aa4-32ae-4d75-b5d4-8b5308f16e7e', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no1_white_frame_36x48_48729a01-5384-41fb-83fc-65bc4af57803.png?v=1713722289', 'space-form-no2 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('a53421a3-d689-4d92-befd-6ba2a9a8a199', 'd3b91aa4-32ae-4d75-b5d4-8b5308f16e7e', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_noir_no1_no_frame_36x48_c1b10d7c-84b0-4b35-a82d-395ce0db48fe.png?v=1713722289', 'space-form-no2 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('55164ee0-127b-47c2-b841-84ee7dc09eb5', 'd3b91aa4-32ae-4d75-b5d4-8b5308f16e7e', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'SPACE-FORM-NO2-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('1967aeb4-4a99-4bd2-81b3-bd2825350914', 'd3b91aa4-32ae-4d75-b5d4-8b5308f16e7e', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'SPACE-FORM-NO2-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b1d0a7bd-cccf-4747-96c0-1250774a7a73', 'd3b91aa4-32ae-4d75-b5d4-8b5308f16e7e', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'SPACE-FORM-NO2-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('c68137cc-92a1-4a34-b183-202c7b0d040e', 'd3b91aa4-32ae-4d75-b5d4-8b5308f16e7e', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'SPACE-FORM-NO2-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('3bbcc031-ba4f-4128-9dda-e86f0b816171', 'd3b91aa4-32ae-4d75-b5d4-8b5308f16e7e', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'SPACE-FORM-NO2-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('144d2b37-97ba-4bfa-a7a2-521b29387d94', 'd3b91aa4-32ae-4d75-b5d4-8b5308f16e7e', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'SPACE-FORM-NO2-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('f1e65397-cfdd-4fd3-888a-6057edbc48da', 'space-form-no1', 'Space & Form no1', '<p>Space &amp; Form No.1 from the Resonating Structure collection is a compelling narrative of texture and depth realized through the medium of digital art. Here, the artist presents a symphony of forms that resonate with the raw energy of natural elements, suffused with an aura of mystery and contemplation. The canvas is a patchwork of darkness and light, with jagged geometries cutting through a tapestry of organic textures. Each shape interacts with its neighbor, forming a cohesive yet complex visual field. The layering technique employed creates an illusion of three-dimensional space, pulling the observer into a seemingly infinite recess. With ''Space &amp; Form No.1,'' the artist plays with the viewer''s perception, using contrasting hues and saturation to evoke an emotional response. This piece is a testament to the artist''s ability to manipulate digital tools to imitate the imperfections and richness of the physical world, bridging the gap between the virtual and the real.</p>', '041bbb17-d7a1-4e6b-9be1-0b680c56096e', 
        'VividWalls', 'Artwork',
        '{"Space Form"}', 'active', 
        'Space & Form no1 24x36 Gallery Wrapped Canvas', 
        '<p>Space &amp; Form No.1 from the Resonating Structure collection is a compelling narrative of texture and depth realized through the medium of digital art. Here, the artist presents a symphony of forms that resonate with the raw energy of natural elements, suffused with an aura of mystery and contemplation. The canvas is a patchwork of darkness and light, with jagged geometries cutting through a tapestry of organic textures. Each shape interacts with its neighbor, forming a cohesive yet complex visual field. The layering technique employed creates an illusion of three-dimensional space, pulling the observer into a seemingly infinite recess. With ''Space &amp; Form No.1,'' the artist plays with the viewer''s perception, using contrasting hues and saturation to evoke an emotional response. This piece is a testament to the artist''s ability to manipulate digital tools to imitate the imperfections and richness of the physical world, bridging the gap between the virtual and the real.</p>');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('18a83184-c7d2-4664-8d99-6c94b23b0098', 'f1e65397-cfdd-4fd3-888a-6057edbc48da', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no1_black_frame_53x72_0938d567-3505-459d-b2ab-5803a1ec4dce.png?v=1713722259', 'space-form-no1 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('39989d59-94b9-4833-8ce9-c79fae01ef4d', 'f1e65397-cfdd-4fd3-888a-6057edbc48da', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no1_white_frame_53x72_c26d2332-dd60-44b4-8fed-85863c9d387c.png?v=1713722259', 'space-form-no1 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('abee33da-eaef-4340-9f66-58f84acdc039', 'f1e65397-cfdd-4fd3-888a-6057edbc48da', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no1_no_frame_53x72_77d9e98f-089a-4f0c-b4ba-6ea5662eb7b5.png?v=1713722259', 'space-form-no1 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('5d15aab9-7f20-47b2-94e7-b9260f09b320', 'f1e65397-cfdd-4fd3-888a-6057edbc48da', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no1_black_frame_36x48_bea9929e-9d49-4913-b655-3e877196d250.png?v=1713722259', 'space-form-no1 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('3e7f45a7-23be-41ae-a322-02f7c9a4f6bb', 'f1e65397-cfdd-4fd3-888a-6057edbc48da', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no1_white_frame_36x48_74442f27-640d-4bcf-a266-562d47893073.png?v=1713722259', 'space-form-no1 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('8b24fda5-cf1a-4990-98d3-3232883294e0', 'f1e65397-cfdd-4fd3-888a-6057edbc48da', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/space_shape_no1_no_frame_36x48_bf78e3a1-8cdc-4e92-a0d1-a39842bd6383.png?v=1713722259', 'space-form-no1 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('d2bf0b0d-15e0-416d-b11b-51b8ec87fc08', 'f1e65397-cfdd-4fd3-888a-6057edbc48da', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'SPACE-FORM-NO1-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('c06998c7-dcf9-4b0f-a2ed-98c50b7f807b', 'f1e65397-cfdd-4fd3-888a-6057edbc48da', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'SPACE-FORM-NO1-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('efba0cea-4a3b-4b2d-9411-6ab682bce6e2', 'f1e65397-cfdd-4fd3-888a-6057edbc48da', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'SPACE-FORM-NO1-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('30314265-0381-4c32-930c-ac631d43cd3d', 'f1e65397-cfdd-4fd3-888a-6057edbc48da', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'SPACE-FORM-NO1-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('7b8089ca-2a78-4557-a5d3-6ad1dde85052', 'f1e65397-cfdd-4fd3-888a-6057edbc48da', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'SPACE-FORM-NO1-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('d777eebe-f695-4fb0-8554-391226db6cd5', 'f1e65397-cfdd-4fd3-888a-6057edbc48da', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'SPACE-FORM-NO1-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('3e3e288a-e7df-41c7-ae28-8041c7254c90', 'noir-structures', 'Noir Structures', 'Noir Structuresfrom the Intersecting Spaces collection is a powerful exploration of monochrome geometry that encapsulates the essence of minimalist art. The artist harnesses the stark contrast of black and white to create a composition that is both arresting and enigmatic. The artwork presents a series of angular forms that layer and intersect with a deliberate asymmetry, evoking a sense of depth and perspective. This visual depth is further enhanced by the subtle gradients of gray that soften the rigid boundaries between light and shadow, giving the piece a pulsating, living quality. Textural elements within ''Noir Structures'' suggest a tactile dimension, with each shade of gray and every line offering a sensory experience. The artist''s choice of a restricted palette highlights the complexity that can be achieved within a limited spectrum, inviting the viewer to delve into the nuances of form and tonality.', 'b3a65f16-4405-4d2c-8bf5-74ea4d328a5d', 
        'VividWalls', 'Artwork',
        '{"Intersecting Spaces"}', 'draft', 
        'Noir Structures 24x36 Gallery Wrapped Canvas', 
        'Noir Structuresfrom the Intersecting Spaces collection is a powerful exploration of monochrome geometry that encapsulates the essence of minimalist art. The artist harnesses the stark contrast of black and white to create a composition that is both arresting and enigmatic. The artwork presents a series of angular forms that layer and intersect with a deliberate asymmetry, evoking a sense of depth and perspective. This visual depth is further enhanced by the subtle gradients of gray that soften the rigid boundaries between light and shadow, giving the piece a pulsating, living quality. Textural elements within ''Noir Structures'' suggest a tactile dimension, with each shade of gray and every line offering a sensory experience. The artist''s choice of a restricted palette highlights the complexity that can be achieved within a limited spectrum, inviting the viewer to delve into the nuances of form and tonality.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e54b73e5-543f-4269-a7e6-d625e5f45b3c', '3e3e288a-e7df-41c7-ae28-8041c7254c90', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_noir_no3_black_frame_53x72_470bebfc-b43c-48e9-80c9-83b322934c09.png?v=1713722172', 'noir-structures Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('de4119c1-470c-4118-868a-df79d0db5207', '3e3e288a-e7df-41c7-ae28-8041c7254c90', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_noir_no3_white_frame_53x72_a0b63107-7268-4ac4-84ae-610a0a264411.png?v=1713722172', 'noir-structures Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('7eb255e0-6ccd-49a3-a55b-608133414415', '3e3e288a-e7df-41c7-ae28-8041c7254c90', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_noir_no3_no_frame_53x72_d2bd0675-7772-47a3-8e0f-82f80b41d9d9.png?v=1713722172', 'noir-structures Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('aa279348-19f6-416a-b990-f907dcd86fab', '3e3e288a-e7df-41c7-ae28-8041c7254c90', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_noir_no3_black_frame_48x36-1_e7bd85b4-95bd-4a22-a56c-3d0e23651e8c.png?v=1713722172', 'noir-structures Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('edd3947f-dc2a-4888-b779-009439bc54b5', '3e3e288a-e7df-41c7-ae28-8041c7254c90', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_noir_no3_black_frame_48x36_dd6c8765-6d80-4089-a199-d9ee1c64e5f7.png?v=1713722172', 'noir-structures Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('6604df20-04ce-4837-972f-ce712ef45d15', '3e3e288a-e7df-41c7-ae28-8041c7254c90', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_noir_no3_no_frame_48x36_4524fbfb-d27a-4a60-836b-dbd800b929e0.png?v=1713722172', 'noir-structures Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('5fcbcbd1-75e0-44dc-8940-bfd6efc184d4', '3e3e288a-e7df-41c7-ae28-8041c7254c90', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-STRUCTURES-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('f467b61b-8a2f-4104-8a47-5cfa36bdc372', '3e3e288a-e7df-41c7-ae28-8041c7254c90', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-STRUCTURES-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('806e30f5-4fd2-4392-99b2-c6c69f4af80e', '3e3e288a-e7df-41c7-ae28-8041c7254c90', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-STRUCTURES-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('6e149285-ebbe-4aef-879f-2db3a0f691b0', '3e3e288a-e7df-41c7-ae28-8041c7254c90', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-STRUCTURES-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('cb94e9ef-99f7-4458-a0c4-3376bb6c54b8', '3e3e288a-e7df-41c7-ae28-8041c7254c90', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-STRUCTURES-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('97c1cbba-1f07-4ad5-af44-f83a1729c349', '3e3e288a-e7df-41c7-ae28-8041c7254c90', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-STRUCTURES-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('4d53b818-aabb-46f7-9c9f-3d02d4570723', 'teal-earth', 'Teal Earth', 'Teal Earth from the Intersecting Spaces collection is a captivating embodiment of digital art''s transformative power. The artwork is a striking mosaic of geometric precision, where the artist skillfully harnesses the allure of teal and earthen tones to craft a visual narrative that is both grounded and ethereal. Sharp angles and bold lines converge, creating a labyrinth of form that is both chaotic and meticulously ordered. The central dark form appears to pulsate, surrounded by a constellation of shapes that seem to dance in and out of the canvas. Textures reminiscent of woven fabric give life to the two-dimensional surface, suggesting a tactile sensation that beckons to be explored. Through ''Teal Earth,'' the artist explores the juxtaposition of color and shape, inviting the viewer to consider the interconnectedness of natural and digital realms. The piece stands as a celebration of geometric diversity, an ode to the synthetic and the organic coalescing in a tapestry of form.', 'b3a65f16-4405-4d2c-8bf5-74ea4d328a5d', 
        'VividWalls', 'Artwork',
        '{"Intersecting Spaces"}', 'draft', 
        'Teal Earth 24x36 Gallery Wrapped Canvas', 
        'Teal Earth from the Intersecting Spaces collection is a captivating embodiment of digital art''s transformative power. The artwork is a striking mosaic of geometric precision, where the artist skillfully harnesses the allure of teal and earthen tones to craft a visual narrative that is both grounded and ethereal. Sharp angles and bold lines converge, creating a labyrinth of form that is both chaotic and meticulously ordered. The central dark form appears to pulsate, surrounded by a constellation of shapes that seem to dance in and out of the canvas. Textures reminiscent of woven fabric give life to the two-dimensional surface, suggesting a tactile sensation that beckons to be explored. Through ''Teal Earth,'' the artist explores the juxtaposition of color and shape, inviting the viewer to consider the interconnectedness of natural and digital realms. The piece stands as a celebration of geometric diversity, an ode to the synthetic and the organic coalescing in a tapestry of form.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('7e9e85fa-1e65-4287-aa15-58ac7e3e4f57', '4d53b818-aabb-46f7-9c9f-3d02d4570723', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_teal_earth_no3_black_frame_72x53_ab818af5-0f69-4958-9ee1-938bf7190ae8.png?v=1713721483', 'teal-earth Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('5da6361a-598c-45ac-961a-96c25119cd86', '4d53b818-aabb-46f7-9c9f-3d02d4570723', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_teal_earth_no3_white_frame_72x53_14903501-b4f5-4fae-b736-10d4b638706e.png?v=1713721483', 'teal-earth Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e0360818-264a-42b6-9189-634f8e79a5ed', '4d53b818-aabb-46f7-9c9f-3d02d4570723', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_teal_earth_no3_no_frame_72x53_a516efef-59bf-4c57-908a-aea73300db4e.png?v=1713721483', 'teal-earth Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('f9749d3a-d9c4-4a48-a413-6067f3bec15c', '4d53b818-aabb-46f7-9c9f-3d02d4570723', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_teal_earth_no3_black_frame_48x36_865451bb-707c-4ee5-a77c-6265853e859e.png?v=1713721483', 'teal-earth Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('c8f7aca6-564a-4177-b2e5-35ad1a1bb481', '4d53b818-aabb-46f7-9c9f-3d02d4570723', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_teal_earth_no3_white_frame_48x36_456bd5b6-8a5f-4b3d-9116-918822e81289.png?v=1713721483', 'teal-earth Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('52bc39ba-f5bc-44e8-9b67-11182fb87e40', '4d53b818-aabb-46f7-9c9f-3d02d4570723', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_teal_earth_no3_no_frame_48x36_9dfe4e29-ca97-435a-a1be-10ed62d2dedf.png?v=1713721483', 'teal-earth Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('3834c4ef-481f-4971-a635-bd32416d657f', '4d53b818-aabb-46f7-9c9f-3d02d4570723', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'TEAL-EARTH-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('64d51341-4e79-4b58-aa63-667110b52e3e', '4d53b818-aabb-46f7-9c9f-3d02d4570723', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'TEAL-EARTH-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('f7c171a2-c11c-492e-a66d-fc762b19fcb9', '4d53b818-aabb-46f7-9c9f-3d02d4570723', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'TEAL-EARTH-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('1874da0f-48a9-4d0c-b376-55f442d239af', '4d53b818-aabb-46f7-9c9f-3d02d4570723', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'TEAL-EARTH-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('c4b12fdf-f5a4-4ac5-bfb8-914da0fae676', '4d53b818-aabb-46f7-9c9f-3d02d4570723', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'TEAL-EARTH-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('277edd64-29bc-4daf-8f3d-149c96eebc15', '4d53b818-aabb-46f7-9c9f-3d02d4570723', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'TEAL-EARTH-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('165455a4-fdce-4e4f-aa47-0bb23dfc45c5', 'primary-hue', 'Primary Hue', 'Primary Hue from the Intersecting Spaces collection is a testament to the power of geometric abstraction in the digital age. It invites viewers to navigate a complex array of symmetrical, interlocking shapes that create a sense of ordered dynamism. Through mirrored elements, the artist constructs a visual commentary on the dual nature of perception and reality. Textured nuances within the vibrant blocks of color give life to the two-dimensional plane, with a central form in deep black providing a stark contrast to the surrounding hues. The artist weaves primary colors with a sophisticated blend of secondary and tertiary tones, establishing a visual symphony that pulses with energy from its core. ''Primary'' resonates with the spirit of digital creation, celebrating the meticulous choreography of shapes and colors that culminate in a provocative and thought-provoking experience. This piece captures the essence of a contemplative journey through the lens of abstract geometry.', 'b3a65f16-4405-4d2c-8bf5-74ea4d328a5d', 
        'VividWalls', 'Artwork',
        '{"Intersecting Spaces"}', 'draft', 
        'Primary Hue 24x36 Gallery Wrapped Canvas', 
        'Primary Hue from the Intersecting Spaces collection is a testament to the power of geometric abstraction in the digital age. It invites viewers to navigate a complex array of symmetrical, interlocking shapes that create a sense of ordered dynamism. Through mirrored elements, the artist constructs a visual commentary on the dual nature of perception and reality. Textured nuances within the vibrant blocks of color give life to the two-dimensional plane, with a central form in deep black providing a stark contrast to the surrounding hues. The artist weaves primary colors with a sophisticated blend of secondary and tertiary tones, establishing a visual symphony that pulses with energy from its core. ''Primary'' resonates with the spirit of digital creation, celebrating the meticulous choreography of shapes and colors that culminate in a provocative and thought-provoking experience. This piece captures the essence of a contemplative journey through the lens of abstract geometry.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0b810a8c-8c58-4639-b0fd-6b5ca186b04d', '165455a4-fdce-4e4f-aa47-0bb23dfc45c5', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_primary_no3_black_frame_72x53_bca3c523-b055-4865-b62a-174acf0b417e.png?v=1713721454', 'primary-hue Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('df90762e-3b65-4d85-83ae-6927b768292e', '165455a4-fdce-4e4f-aa47-0bb23dfc45c5', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_primary_no3_white_frame_72x53_792aa253-8717-4f68-ac1a-826c2dcf9d79.png?v=1713721454', 'primary-hue Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('d7ef4dd1-e829-49d1-9e15-c40a260161f6', '165455a4-fdce-4e4f-aa47-0bb23dfc45c5', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_primary_no3_no_frame_72x53_1b42fefc-5c68-4fd0-ac48-8a18c84cc22c.png?v=1713721454', 'primary-hue Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('9a898f74-5b0f-4f5d-ba24-787a4336396e', '165455a4-fdce-4e4f-aa47-0bb23dfc45c5', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_primary_no3_black_frame_48x36_e5040f88-d898-46b2-9a31-e4397265cf88.png?v=1713721454', 'primary-hue Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b2625f7a-d2db-4d35-968e-896dc73d3a88', '165455a4-fdce-4e4f-aa47-0bb23dfc45c5', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_primary_no3_white_frame_48x36_661614fa-0188-48dc-8ec7-3127393805d1.png?v=1713721454', 'primary-hue Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('52dc3d37-58db-4b18-bfb0-3b80ab19b254', '165455a4-fdce-4e4f-aa47-0bb23dfc45c5', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/intersecting_spaces_primary_no3_no_frame_48x36_b0e536d8-f449-4d39-9c3c-5f8d8a0fab86.png?v=1713721454', 'primary-hue Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('7a3befef-9b84-4748-8c65-788acdf16e6b', '165455a4-fdce-4e4f-aa47-0bb23dfc45c5', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PRIMARY-HUE-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('619f19c0-ea83-4701-9cfd-6949e220eaf0', '165455a4-fdce-4e4f-aa47-0bb23dfc45c5', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PRIMARY-HUE-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('77222a78-e1ed-4c65-98f5-d2e2738c269a', '165455a4-fdce-4e4f-aa47-0bb23dfc45c5', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PRIMARY-HUE-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('16b5b220-fd0f-41a5-a0f9-bc6385619821', '165455a4-fdce-4e4f-aa47-0bb23dfc45c5', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PRIMARY-HUE-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('6aaa030f-0681-4cbf-ae70-972ae3a5ce8c', '165455a4-fdce-4e4f-aa47-0bb23dfc45c5', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PRIMARY-HUE-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('242fa1be-d1ef-45a9-9f1f-3207c6e06580', '165455a4-fdce-4e4f-aa47-0bb23dfc45c5', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PRIMARY-HUE-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('e0617b3c-5c1c-462b-872d-d36854473a2f', 'textured-noir-no1', 'Textured Noir no1', 'Textured Noir no1 from the Resonating Structure collection presents a fractal-inspired textured artwork rendered in sophisticated monochrome tones that explore the infinite complexity hidden within seemingly simple black and white compositions. This piece demonstrates how mathematical patterns can generate organic-feeling textures that seem to pulse and breathe with digital life. The fractal elements create intricate surface variations that suggest everything from crystalline formations to cellular structures, while the monochromatic palette ensures that texture and form remain the primary focus. The artwork achieves a remarkable balance between mechanical precision and organic flow, creating patterns that feel both systematically generated and naturally evolved. Each textural element contributes to a larger rhythmic structure that draws the viewer into contemplation of the infinite complexity that can emerge from simple mathematical rules.', '2c71e66d-96fb-4775-9256-f1427e7de746', 
        'VividWalls', 'Artwork',
        '{"Shape Emergence"}', 'active', 
        'Textured Noir no1 24x36 Gallery Wrapped Canvas', 
        'Textured Noir no1 from the Resonating Structure collection presents a fractal-inspired textured artwork rendered in sophisticated monochrome tones that explore the infinite complexity hidden within seemingly simple black and white compositions. This piece demonstrates how mathematical patterns can generate organic-feeling textures that seem to pulse and breathe with digital life. The fractal elements create intricate surface variations that suggest everything from crystalline formations to cellular structures, while the monochromatic palette ensures that texture and form remain the primary focus. The artwork achieves a remarkable balance between mechanical precision and organic flow, creating patterns that feel both systematically generated and naturally evolved. Each textural element contributes to a larger rhythmic structure that draws the viewer into contemplation of the infinite complexity that can emerge from simple mathematical rules.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('fe5601ce-e6fe-49dd-913d-9befb2401410', 'e0617b3c-5c1c-462b-872d-d36854473a2f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_noir-no1_black_frame_53x72_eadebb1d-df0d-48dd-ad27-24ccee44aa2a.png?v=1712929370', 'textured-noir-no1 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('93743a6d-6726-4dbc-aef8-9a0bf34c741b', 'e0617b3c-5c1c-462b-872d-d36854473a2f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_noir-no1_white_frame_53x72_9a6eca89-a1ac-4d95-8cf1-16e9ee237255.png?v=1712929370', 'textured-noir-no1 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('56b66068-e2b2-4678-90bb-049167afc12b', 'e0617b3c-5c1c-462b-872d-d36854473a2f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_noir-no1_no_frame_53x72_a96d7168-10bd-4d5a-ac05-a0f4e950913a.png?v=1712929370', 'textured-noir-no1 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e788aa3c-13a5-4e74-9d05-97e8bbe66e8c', 'e0617b3c-5c1c-462b-872d-d36854473a2f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_noir-no1_black_frame_36x48_c968c435-6351-48c0-b87f-52719825c3ad.png?v=1712929370', 'textured-noir-no1 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('c864af09-b709-4f2e-b111-94fc23f6cee4', 'e0617b3c-5c1c-462b-872d-d36854473a2f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_noir-no1_white_frame_36x48_b8f36e78-1efb-4b7e-8af5-2b4720ffd9f2.png?v=1712929370', 'textured-noir-no1 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('fb6f26ec-0bbf-4e6e-8495-85f29e4fd682', 'e0617b3c-5c1c-462b-872d-d36854473a2f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_noir-no1_no_frame_36x48_6d7eb675-fe5f-47cf-b091-a3ec503b5313.png?v=1712929370', 'textured-noir-no1 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('f7cfa84d-de11-4fbd-bc3c-29f6a8578eb2', 'e0617b3c-5c1c-462b-872d-d36854473a2f', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'TEXTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('e680ddb0-95ad-4093-af81-98159404826c', 'e0617b3c-5c1c-462b-872d-d36854473a2f', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'TEXTURED-NOIR-NO1-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('a8a49d8a-37cf-431d-b08a-f464a71c18e7', 'e0617b3c-5c1c-462b-872d-d36854473a2f', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'TEXTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('606560b4-cae7-45d9-b2f5-cdab15759efe', 'e0617b3c-5c1c-462b-872d-d36854473a2f', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'TEXTURED-NOIR-NO1-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('96993b7e-1006-4824-92c9-68f238d749d4', 'e0617b3c-5c1c-462b-872d-d36854473a2f', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'TEXTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b1646c04-ec85-4c63-af13-678898148a33', 'e0617b3c-5c1c-462b-872d-d36854473a2f', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'TEXTURED-NOIR-NO1-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('da0e4161-d804-4d27-b34b-b5d31d4dae86', 'textured-royal-no1', 'Textured Royal no1', 'Textured Royal no1 from the Resonating Structure collection presents a royal-toned fractal geometric composition featuring sophisticated textured patterns that elevate digital art to the realm of tactile luxury. This artwork combines the mathematical precision of fractal geometry with rich, regal color palettes that evoke the opulence of royal tapestries and precious metalwork. The textured elements create depth and visual interest that transforms the flat digital surface into something that appears almost three-dimensional, inviting the viewer to imagine running their fingers across its intricate patterns. Deep purples, rich golds, and royal blues blend seamlessly through fractal iterations, creating a sense of infinite complexity that speaks to both mathematical beauty and aesthetic sophistication. Each textural layer contributes to an overall composition that feels both digitally precise and luxuriously organic.', '2c71e66d-96fb-4775-9256-f1427e7de746', 
        'VividWalls', 'Artwork',
        '{"Shape Emergence"}', 'active', 
        'Textured Royal no1 24x36 Gallery Wrapped Canvas', 
        'Textured Royal no1 from the Resonating Structure collection presents a royal-toned fractal geometric composition featuring sophisticated textured patterns that elevate digital art to the realm of tactile luxury. This artwork combines the mathematical precision of fractal geometry with rich, regal color palettes that evoke the opulence of royal tapestries and precious metalwork. The textured elements create depth and visual interest that transforms the flat digital surface into something that appears almost three-dimensional, inviting the viewer to imagine running their fingers across its intricate patterns. Deep purples, rich golds, and royal blues blend seamlessly through fractal iterations, creating a sense of infinite complexity that speaks to both mathematical beauty and aesthetic sophistication. Each textural layer contributes to an overall composition that feels both digitally precise and luxuriously organic.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('8b845f25-dea3-4a23-b79b-af58cb3b3bc3', 'da0e4161-d804-4d27-b34b-b5d31d4dae86', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_rolyal_no1_black_frame_53x72_66acc781-0a42-4709-a0d8-6e8b30d07a01.png?v=1712929355', 'textured-royal-no1 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('f07baaf3-8703-49c6-bcdf-4c27ec86e56f', 'da0e4161-d804-4d27-b34b-b5d31d4dae86', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_rolyal_no1_white_frame_53x72_07953433-ad68-442c-b71a-e83f728edd0d.png?v=1712929355', 'textured-royal-no1 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b07c5e6b-6bc5-49a0-997b-cfe488f51c3f', 'da0e4161-d804-4d27-b34b-b5d31d4dae86', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_rolyal_no1_no_frame_53x72-1_141c7187-03a8-4c20-9d31-646b3488e71d.png?v=1712929355', 'textured-royal-no1 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('6a2e10f8-3d57-4de2-a359-9dbe829ecaa6', 'da0e4161-d804-4d27-b34b-b5d31d4dae86', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_rolyal_no1_black_frame_36x48_6a0cfba2-7bc2-46f6-b56a-e3e659b4b0a7.png?v=1712929355', 'textured-royal-no1 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0bf9f29a-5845-4f00-8664-6bfd406ee419', 'da0e4161-d804-4d27-b34b-b5d31d4dae86', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_rolyal_no1_white_frame_36x48_9a644532-0aa8-4a37-a2bb-1684160faad0.png?v=1712929355', 'textured-royal-no1 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('87eebc36-ed62-400e-ab16-a731bc4376ba', 'da0e4161-d804-4d27-b34b-b5d31d4dae86', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_rolyal_no1_no_frame_36x48_70444853-ec2e-4d5f-87a9-eabe74ef74a2.png?v=1712929355', 'textured-royal-no1 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('5450fc9e-ab87-4c56-9a0f-e8dde9c77e2e', 'da0e4161-d804-4d27-b34b-b5d31d4dae86', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'TEXTURED-ROYAL-NO1-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('1f31cbe2-eb2c-4828-a8dc-25d066891778', 'da0e4161-d804-4d27-b34b-b5d31d4dae86', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'TEXTURED-ROYAL-NO1-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('ac7e0ec3-b3ff-4305-a4f3-4ddd63c1180b', 'da0e4161-d804-4d27-b34b-b5d31d4dae86', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'TEXTURED-ROYAL-NO1-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('f6967f25-f986-4e15-86e8-88ba8988e547', 'da0e4161-d804-4d27-b34b-b5d31d4dae86', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'TEXTURED-ROYAL-NO1-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('f0464907-1b89-4d50-9dda-fd4c8a9055a1', 'da0e4161-d804-4d27-b34b-b5d31d4dae86', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'TEXTURED-ROYAL-NO1-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('641a1f94-62fd-40ae-b0e0-aed458d8297d', 'da0e4161-d804-4d27-b34b-b5d31d4dae86', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'TEXTURED-ROYAL-NO1-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('8438a1ef-d45a-4f54-b8c2-85c1e08740f0', 'noir-shade', 'Noir Shade', 'Noir Shadebythe artistfrom the Shape Emergence collection. The artwork is a visually stimulating composition that belongs to the "Shape Emergence" collection by the artist. The medium is ink pigment printed on canvas, a method known for its durability and vibrant color output, ensuring that the intricate details and color transitions are beautifully rendered and preserved. The piece is predominantly characterized by its bold geometric shapes and stark contrasts. At first glance, it evokes the aesthetics of architectural design, with its structured lines and forms suggesting the meticulous blueprints of urban planning. The interplay of black and white forms creates a striking monochromatic palette, which is simultaneously timeless and modern. Shades of gray gradient serve as a bridge between the extremes of black and white, softening the transitions and adding depth to the image.', '2c71e66d-96fb-4775-9256-f1427e7de746', 
        'VividWalls', 'Artwork',
        '{"Shape Emergence"}', 'active', 
        'Noir Shade 24x36 Gallery Wrapped Canvas', 
        'Noir Shadebythe artistfrom the Shape Emergence collection. The artwork is a visually stimulating composition that belongs to the "Shape Emergence" collection by the artist. The medium is ink pigment printed on canvas, a method known for its durability and vibrant color output, ensuring that the intricate details and color transitions are beautifully rendered and preserved. The piece is predominantly characterized by its bold geometric shapes and stark contrasts. At first glance, it evokes the aesthetics of architectural design, with its structured lines and forms suggesting the meticulous blueprints of urban planning. The interplay of black and white forms creates a striking monochromatic palette, which is simultaneously timeless and modern. Shades of gray gradient serve as a bridge between the extremes of black and white, softening the transitions and adding depth to the image.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('a07abeb2-736f-4847-813c-3984208136d4', '8438a1ef-d45a-4f54-b8c2-85c1e08740f0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_noir-no1_black_frame_53x72_54f634b2-de4a-4218-bb29-4d88c76c0dc3.png?v=1713722228', 'noir-shade Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('cd3b3fe8-697d-4cc2-86b9-250990e510d6', '8438a1ef-d45a-4f54-b8c2-85c1e08740f0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_noir-no1_white_frame_53x72_1c258558-4c4a-4d71-b397-1862345caaa9.png?v=1713722228', 'noir-shade Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('1a061edd-cd21-4b0f-afcb-2ce3177e4a62', '8438a1ef-d45a-4f54-b8c2-85c1e08740f0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_noir-no1_no_frame_53x72_4eaf8348-a4ed-43d3-ac2b-42e66fd719a7.png?v=1713722228', 'noir-shade Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e71f1475-1182-45c2-a456-809077cb8b36', '8438a1ef-d45a-4f54-b8c2-85c1e08740f0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_noir-no1_black_frame_36x48_1c29229b-12a7-415d-9750-6c8779ab06de.png?v=1713722228', 'noir-shade Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('361d56da-afbd-4e5f-844c-4021227c1c77', '8438a1ef-d45a-4f54-b8c2-85c1e08740f0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_noir-no1_white_frame_36x48_b4f3bbcd-1de2-4b6a-80de-8d0e9d8a72ae.png?v=1713722228', 'noir-shade Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('26b2c50b-790f-4c4c-ace9-c0d437f86e98', '8438a1ef-d45a-4f54-b8c2-85c1e08740f0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_noir-no1_no_frame_36x48_a0070d6c-a40a-4633-ac10-fa97993a0bf0.png?v=1713722228', 'noir-shade Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('faa7c2ab-1e3c-4c31-8e39-880b162d4d14', '8438a1ef-d45a-4f54-b8c2-85c1e08740f0', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-SHADE-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('f753230a-e40f-4ed8-b9b9-87ff0f064f6b', '8438a1ef-d45a-4f54-b8c2-85c1e08740f0', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-SHADE-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('a5344312-0d8d-4226-b5f7-1b907122f2f0', '8438a1ef-d45a-4f54-b8c2-85c1e08740f0', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-SHADE-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('84d00710-5b3c-433e-bdec-422b48d93723', '8438a1ef-d45a-4f54-b8c2-85c1e08740f0', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-SHADE-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('d1b3c95b-951d-4faf-be71-92b7d80d73ff', '8438a1ef-d45a-4f54-b8c2-85c1e08740f0', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-SHADE-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('42243f39-65b9-43b5-9cdd-53baeeb5d7ed', '8438a1ef-d45a-4f54-b8c2-85c1e08740f0', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-SHADE-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('3d4be22d-522f-4f67-a8af-3ce03109b8af', 'royal-shade', 'Royal Shade', 'Royal Shadefrom the Shape Emergence collection by the artist presents a complex interplay of geometry and texture. The artwork is a vibrant tapestry of digital precision, where saturated blues dominate the palette, contrasted with hints of crimson and calming cyan. The composition is meticulously constructed with a variety of shapes that command attention; sharp angles intersect with soft curves, creating a rhythmic balance that is both dynamic and harmonious. The texture within each shape is reminiscent of a rough canvas, adding depth and a tactile dimension that encourages closer inspection. This texture, coupled with the stark color blocks, crafts an illusion of light and shadow, endowing the piece with a three-dimensional quality. The lone, bold triangle of crimson acts as a visual anchor, drawing the eye and providing a focal point amidst the coolness of the blues.', '2c71e66d-96fb-4775-9256-f1427e7de746', 
        'VividWalls', 'Artwork',
        '{"Shape Emergence"}', 'active', 
        'Royal Shade 24x36 Gallery Wrapped Canvas', 
        'Royal Shadefrom the Shape Emergence collection by the artist presents a complex interplay of geometry and texture. The artwork is a vibrant tapestry of digital precision, where saturated blues dominate the palette, contrasted with hints of crimson and calming cyan. The composition is meticulously constructed with a variety of shapes that command attention; sharp angles intersect with soft curves, creating a rhythmic balance that is both dynamic and harmonious. The texture within each shape is reminiscent of a rough canvas, adding depth and a tactile dimension that encourages closer inspection. This texture, coupled with the stark color blocks, crafts an illusion of light and shadow, endowing the piece with a three-dimensional quality. The lone, bold triangle of crimson acts as a visual anchor, drawing the eye and providing a focal point amidst the coolness of the blues.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e7ac3580-f99e-4196-b50b-12c9d9406b39', '3d4be22d-522f-4f67-a8af-3ce03109b8af', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_rolyal_no1_black_frame_53x72_b83ec3af-8ed8-47a2-a968-761885f15c4f.png?v=1713722201', 'royal-shade Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('476772b1-a88f-439b-8136-995eaca05ef0', '3d4be22d-522f-4f67-a8af-3ce03109b8af', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_rolyal_no1_white_frame_53x72_63b00297-7fba-4651-b42e-0baae8a03afd.png?v=1713722201', 'royal-shade Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('da63b0ee-1072-4c8c-a4e4-4f89d707f56c', '3d4be22d-522f-4f67-a8af-3ce03109b8af', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_rolyal_no1_no_frame_53x72_3ce09f9f-1e04-4711-a506-0c496aba34d1.png?v=1713722201', 'royal-shade Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b474b599-605b-4a8f-a1b8-97b4e22d8d4a', '3d4be22d-522f-4f67-a8af-3ce03109b8af', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_rolyal_no1_black_frame_36x48_4662ef08-0256-4744-8b09-ed9743dc7d29.png?v=1713722201', 'royal-shade Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('53722f7c-499a-472f-9499-b9efd769d07e', '3d4be22d-522f-4f67-a8af-3ce03109b8af', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_rolyal_no1_white_frame_36x48_bce7e345-efe8-4f60-b2f1-69fcd0251d14.png?v=1713722201', 'royal-shade Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('7270100d-0fed-40d9-be7c-69adc978acae', '3d4be22d-522f-4f67-a8af-3ce03109b8af', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_rolyal_no1_no_frame_36x48_132c1c1e-c2f7-4cfd-b894-68773d7aa974.png?v=1713722201', 'royal-shade Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('0f9dba1d-2750-44a6-8cf4-4f05ff30d400', '3d4be22d-522f-4f67-a8af-3ce03109b8af', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'ROYAL-SHADE-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('27191a27-dde6-4017-8182-54b7a00a27b9', '3d4be22d-522f-4f67-a8af-3ce03109b8af', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'ROYAL-SHADE-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('0c2b4e17-2559-45ba-b145-827550a32ebc', '3d4be22d-522f-4f67-a8af-3ce03109b8af', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'ROYAL-SHADE-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('58d40be3-e8c7-4cc8-a73f-4de361d5c903', '3d4be22d-522f-4f67-a8af-3ce03109b8af', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'ROYAL-SHADE-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('680066df-3e48-468c-87b9-7b2215968555', '3d4be22d-522f-4f67-a8af-3ce03109b8af', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'ROYAL-SHADE-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('e4a3590c-d7de-40d4-ad0f-2748bd89b227', '3d4be22d-522f-4f67-a8af-3ce03109b8af', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'ROYAL-SHADE-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('353d9773-d2a7-44c8-90dc-69bdfef80abb', 'crimson-shade', 'Crimson Shade', 'Crimson Shadebythe artistfrom the Shape Emergence collection manifests a dramatic interplay of geometric shapes in rich crimson tones, contrasted with touches of deep blues and purples, segmented by sharp lines and creating a pattern reminiscent of a complex kaleidoscope. The artwork, printed with high-quality ink pigment on durable cotton canvas, exudes a robust intensity and depth that captivates and engages the viewer. The collection is a striking visual narrative composed of geometric forms and a bold color palette. This ink pigment print on cotton canvas features a dynamic arrangement of shapes that merge and diverge to create a sense of movement and depth. The artwork is dominated by shades of crimson, ranging from deep maroon to bright red, which are contrasted with hints of purple, navy, and white. This contrast not only accentuates the individual forms but also highlights the overall symmetry and balance within the piece.', '2c71e66d-96fb-4775-9256-f1427e7de746', 
        'VividWalls', 'Artwork',
        '{"Shape Emergence"}', 'active', 
        'Crimson Shade 24x36 Gallery Wrapped Canvas', 
        'Crimson Shadebythe artistfrom the Shape Emergence collection manifests a dramatic interplay of geometric shapes in rich crimson tones, contrasted with touches of deep blues and purples, segmented by sharp lines and creating a pattern reminiscent of a complex kaleidoscope. The artwork, printed with high-quality ink pigment on durable cotton canvas, exudes a robust intensity and depth that captivates and engages the viewer. The collection is a striking visual narrative composed of geometric forms and a bold color palette. This ink pigment print on cotton canvas features a dynamic arrangement of shapes that merge and diverge to create a sense of movement and depth. The artwork is dominated by shades of crimson, ranging from deep maroon to bright red, which are contrasted with hints of purple, navy, and white. This contrast not only accentuates the individual forms but also highlights the overall symmetry and balance within the piece.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('dedb643d-569d-416f-8ec0-17ebb33f8732', '353d9773-d2a7-44c8-90dc-69bdfef80abb', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_spectrum_red_no1_black_frame_53x72_31d9b7c2-bea6-4bef-8180-685ebf29d46a.png?v=1713721368', 'crimson-shade Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('69762862-e5b8-4c66-8c9a-47cc9cbd1255', '353d9773-d2a7-44c8-90dc-69bdfef80abb', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_spectrum_red_no1-white-frame-53x72_6d09a0df-e274-4298-89ff-cc58baee7ab7.png?v=1713721369', 'crimson-shade Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('87ddadc1-06f3-4127-b5d6-fc16b2234738', '353d9773-d2a7-44c8-90dc-69bdfef80abb', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_spetrum_red_no1_no_frame_53x72_53f61c56-c76b-486c-b6cc-b23258873da8.png?v=1713721369', 'crimson-shade Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('31ae3ab3-f982-4b7b-a633-130520e6520d', '353d9773-d2a7-44c8-90dc-69bdfef80abb', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_spectrum_red_no1_black_frame_36x48_a5ba7b04-0437-4523-bd01-4b89ab56a5f5.png?v=1713721369', 'crimson-shade Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('592d63ba-b711-4db0-a744-dad63eecc92f', '353d9773-d2a7-44c8-90dc-69bdfef80abb', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_spectrum_red_no1-white-frame-36x48_666ca05b-6484-41e9-b000-2edf449905ac.png?v=1713721369', 'crimson-shade Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('68730393-3d3b-4bba-9397-c284e9cc54cd', '353d9773-d2a7-44c8-90dc-69bdfef80abb', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/textured_spectrum_red_no1_no_frame_36x48_a4e91481-b793-4af9-9972-ff727f2a8259.png?v=1713721369', 'crimson-shade Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('feb91ffa-f7aa-4ed5-bb4c-b9aa5eba6625', '353d9773-d2a7-44c8-90dc-69bdfef80abb', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'CRIMSON-SHADE-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('83d58f3b-361c-49f2-ac5c-d2e1ed0a3fda', '353d9773-d2a7-44c8-90dc-69bdfef80abb', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'CRIMSON-SHADE-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4ac6655a-8f4d-4e3a-b56d-ab544bc3e1ec', '353d9773-d2a7-44c8-90dc-69bdfef80abb', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'CRIMSON-SHADE-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('c28705aa-da62-4008-8739-478c0e21e3b9', '353d9773-d2a7-44c8-90dc-69bdfef80abb', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'CRIMSON-SHADE-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('11a716d7-7248-4cc7-b432-e5680d93ca11', '353d9773-d2a7-44c8-90dc-69bdfef80abb', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'CRIMSON-SHADE-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('03f24660-3946-44ad-84c4-e8cdd638c3ef', '353d9773-d2a7-44c8-90dc-69bdfef80abb', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'CRIMSON-SHADE-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('b62ca463-1093-4857-afa0-69d2da1ba9b2', 'rusty-shade', 'Rusty Shade', 'Rusty Shadefrom the Shape Emergence collection presents an earthy rust-toned geometric composition that captures the weathered beauty and organic complexity of oxidized metal surfaces. This artwork explores the aesthetic tension between industrial decay and natural patination, creating a visual narrative that celebrates the transformative power of time and environmental forces. The rust-colored palette ranges from deep burgundy to burnt orange, with subtle variations that suggest the gradual oxidation process that creates these distinctive hues. The geometric forms emerge from this textural background like archaeological artifacts, their angular precision contrasting beautifully with the organic randomness of the rust patterns. This juxtaposition creates a compelling dialogue between human-made structures and natural processes, resulting in a composition that feels both ancient and contemporary.', '2c71e66d-96fb-4775-9256-f1427e7de746', 
        'VividWalls', 'Artwork',
        '{"Shape Emergence"}', 'draft', 
        'Rusty Shade 24x36 Gallery Wrapped Canvas', 
        'Rusty Shadefrom the Shape Emergence collection presents an earthy rust-toned geometric composition that captures the weathered beauty and organic complexity of oxidized metal surfaces. This artwork explores the aesthetic tension between industrial decay and natural patination, creating a visual narrative that celebrates the transformative power of time and environmental forces. The rust-colored palette ranges from deep burgundy to burnt orange, with subtle variations that suggest the gradual oxidation process that creates these distinctive hues. The geometric forms emerge from this textural background like archaeological artifacts, their angular precision contrasting beautifully with the organic randomness of the rust patterns. This juxtaposition creates a compelling dialogue between human-made structures and natural processes, resulting in a composition that feels both ancient and contemporary.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('cf3fa413-8589-4e2a-8d44-ba95d1654cf7', 'b62ca463-1093-4857-afa0-69d2da1ba9b2', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_shade_no1_black_frame_53x72_841eafb9-e062-4a0d-83ca-692b52553844.png?v=1713721343', 'rusty-shade Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('a91ce53e-3a2b-445b-83d6-7a1995c5f7c3', 'b62ca463-1093-4857-afa0-69d2da1ba9b2', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_shade_no1__white_frame_53x72_3e4cd90a-4190-4b1c-aa5e-9405e9f60260.png?v=1713721343', 'rusty-shade Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('28cb3005-c05e-41d4-8d45-c2c6e8d17648', 'b62ca463-1093-4857-afa0-69d2da1ba9b2', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_shade_no1__no_frame_53x72_2a00315f-45d1-44f4-9168-9383d727d56b.png?v=1713721343', 'rusty-shade Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('8375efbf-fd7b-429f-a40e-3096a95e2e52', 'b62ca463-1093-4857-afa0-69d2da1ba9b2', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/rusty_shade_no1_black_frame_36x48_35c733e8-107b-4c40-8106-f1c4637ecd7f.png?v=1713721343', 'rusty-shade Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('abf9774e-8c90-408b-b0d9-f6de88c25753', 'b62ca463-1093-4857-afa0-69d2da1ba9b2', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/rusty_shade_no1_white_frame_36x48_a4b5af06-bdf0-4b5a-93c8-74876e5e8ed6.png?v=1713721343', 'rusty-shade Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('05687e83-1991-4805-a0cb-779bc3c9d91d', 'b62ca463-1093-4857-afa0-69d2da1ba9b2', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/rusty_shade_no1_no_frame_36x48_4c1b8554-b15d-4eb7-8d83-45154a734cfc.png?v=1713721343', 'rusty-shade Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('8ed9a922-4412-458a-8b91-944e3de675c7', 'b62ca463-1093-4857-afa0-69d2da1ba9b2', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'RUSTY-SHADE-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('056b86a8-d1e7-485c-a219-5197293d1dc4', 'b62ca463-1093-4857-afa0-69d2da1ba9b2', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'RUSTY-SHADE-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b71b9c86-aac5-4718-9838-cb5254c8f918', 'b62ca463-1093-4857-afa0-69d2da1ba9b2', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'RUSTY-SHADE-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('13c9ccf7-b77d-48ba-ac95-b5103e1175ca', 'b62ca463-1093-4857-afa0-69d2da1ba9b2', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'RUSTY-SHADE-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('04a5914b-01bf-4152-ada8-1aa24661e03f', 'b62ca463-1093-4857-afa0-69d2da1ba9b2', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'RUSTY-SHADE-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('79c33d7f-7311-409b-90a4-5a25d22c944e', 'b62ca463-1093-4857-afa0-69d2da1ba9b2', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'RUSTY-SHADE-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('ee67afd3-27da-4670-a81f-b7cbddc99c5b', 'earthy-shade', 'Earthy Shade', 'Earthy Shadefrom the Shape Emergence collection presents a complex earth-toned geometric abstraction that captures the rich, grounded essence of natural landscapes through sophisticated digital interpretation. This artwork employs a sophisticated palette of browns, ochres, and warm tans to create depth and dimensional complexity that evokes the layered stratification of geological formations. The geometric forms emerge and recede in subtle interplay, creating shadows and highlights that suggest the natural erosion patterns found in canyon walls and sedimentary rocks. Each element contributes to an overall composition that feels both mathematically precise and organically inspired, demonstrating how digital art can capture the timeless beauty of Earth''s natural processes through contemporary geometric abstraction.', '2c71e66d-96fb-4775-9256-f1427e7de746', 
        'VividWalls', 'Artwork',
        '{"Shape Emergence"}', 'draft', 
        'Earthy Shade 24x36 Gallery Wrapped Canvas', 
        'Earthy Shadefrom the Shape Emergence collection presents a complex earth-toned geometric abstraction that captures the rich, grounded essence of natural landscapes through sophisticated digital interpretation. This artwork employs a sophisticated palette of browns, ochres, and warm tans to create depth and dimensional complexity that evokes the layered stratification of geological formations. The geometric forms emerge and recede in subtle interplay, creating shadows and highlights that suggest the natural erosion patterns found in canyon walls and sedimentary rocks. Each element contributes to an overall composition that feels both mathematically precise and organically inspired, demonstrating how digital art can capture the timeless beauty of Earth''s natural processes through contemporary geometric abstraction.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('3bdd8886-a43c-45a4-af13-56f99ac2d483', 'ee67afd3-27da-4670-a81f-b7cbddc99c5b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_shade_black_frame_53x72_a4560661-a8a0-429c-befb-29aa9fe44fae.png?v=1713721314', 'earthy-shade Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('401a703f-6869-4fae-8c81-e43e5c60200d', 'ee67afd3-27da-4670-a81f-b7cbddc99c5b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_shade_no1__white_frame_53x72_0777ae90-91e2-4e37-8a70-afaccade8ed3.png?v=1713721314', 'earthy-shade Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('c3a276c9-2dca-4282-9d45-b9adbc633dba', 'ee67afd3-27da-4670-a81f-b7cbddc99c5b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_shade_no2_no_frame_53x72_c99f63e4-cc87-4f96-a11a-4f32e7df9cf9.png?v=1713721314', 'earthy-shade Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('cc2c9ed9-c602-4585-9fef-76ca1e8b5fb3', 'ee67afd3-27da-4670-a81f-b7cbddc99c5b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_shade_no2_black_frame_36x48_e08cb7ff-4e1c-4891-af2a-104e2682a50e.png?v=1713721314', 'earthy-shade Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('abd9826c-af28-4406-8a91-19c0f0add8d5', 'ee67afd3-27da-4670-a81f-b7cbddc99c5b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_shade_no2_white_frame_36x48_24b994f9-00af-48e5-a00f-642672e8b0e3.png?v=1713721314', 'earthy-shade Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('04b528c2-ccf6-4b26-932f-0eb17bb688d2', 'ee67afd3-27da-4670-a81f-b7cbddc99c5b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_shade_no2_no_frame_36x48_9c100a68-0050-4f2f-85fc-2720c1d15967.png?v=1713721314', 'earthy-shade Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4aebe0b1-b204-4e82-a60a-8929c42df21a', 'ee67afd3-27da-4670-a81f-b7cbddc99c5b', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EARTHY-SHADE-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('74a7077f-00ba-42f8-a14b-4a8112e42a96', 'ee67afd3-27da-4670-a81f-b7cbddc99c5b', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EARTHY-SHADE-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('2bc9e79e-5db4-4fde-b842-ce9e4a4da856', 'ee67afd3-27da-4670-a81f-b7cbddc99c5b', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EARTHY-SHADE-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('a4714021-4d90-4c63-98d0-6a6e339f7af0', 'ee67afd3-27da-4670-a81f-b7cbddc99c5b', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EARTHY-SHADE-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('802a3901-b94b-4faf-91db-329ac8875110', 'ee67afd3-27da-4670-a81f-b7cbddc99c5b', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EARTHY-SHADE-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b45e5961-6fd4-419d-9c99-9c7870ac372f', 'ee67afd3-27da-4670-a81f-b7cbddc99c5b', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EARTHY-SHADE-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('79140f20-5529-4609-98c7-be0cda1ad2ee', 'emerald-shade', 'Emerald Shade', 'Emerald Shadefrom the Shape Emergence collection features a complex overlay of geometric shapes creating a sense of depth and movement. The predominant shades of emerald and teal are interspersed with accents of deep blue, creating an impression of a multidimensional, woven fabric. The textured background contributes to the tactile illusion, enhancing the visual intricacy of the piece.', '2c71e66d-96fb-4775-9256-f1427e7de746', 
        'VividWalls', 'Artwork',
        '{"Shape Emergence"}', 'draft', 
        'Emerald Shade 24x36 Gallery Wrapped Canvas', 
        'Emerald Shadefrom the Shape Emergence collection features a complex overlay of geometric shapes creating a sense of depth and movement. The predominant shades of emerald and teal are interspersed with accents of deep blue, creating an impression of a multidimensional, woven fabric. The textured background contributes to the tactile illusion, enhancing the visual intricacy of the piece.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('ff2252fa-ebd0-449a-ba3a-3d84177c41ac', '79140f20-5529-4609-98c7-be0cda1ad2ee', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/emeral_shade_no2_black_frame_53x72_8eff71df-04fc-48b5-bfe3-93297fbcb5c3.png?v=1713721286', 'emerald-shade Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('98282e54-3eaa-4b64-b1b3-5d4e9dc6144f', '79140f20-5529-4609-98c7-be0cda1ad2ee', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/emeral_shade_no2_white_frame_53x72_66ef5ec3-4482-4812-b889-c5d99f8a1687.png?v=1713721286', 'emerald-shade Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('05199efd-4ad1-441e-b5d2-fce18aaff2a1', '79140f20-5529-4609-98c7-be0cda1ad2ee', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/emeral_shade_no2_no_frame_53x72_8ea63a54-688b-4154-b7fe-a488ef6e8ee8.png?v=1713721286', 'emerald-shade Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('82143d85-c3b5-4ec8-8a02-855c262131ff', '79140f20-5529-4609-98c7-be0cda1ad2ee', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/emeral_shade_no2_black_frame_36x48_f1fa979c-3060-4f30-8d07-5afec608f143.png?v=1713721286', 'emerald-shade Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('37cfa7c0-dc26-40d8-ada2-9c93a7f9ca2f', '79140f20-5529-4609-98c7-be0cda1ad2ee', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/emeral_shade_no2_white_frame_36x48_5f900604-88ed-428a-b25e-8577e7c6f637.png?v=1713721286', 'emerald-shade Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('3e3e34c3-5e15-4685-be9a-4f4c115e8615', '79140f20-5529-4609-98c7-be0cda1ad2ee', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/emeral_shade_no2_no_frame_36x48_d6d756b4-48aa-4270-8fab-dc6c05e0991a.png?v=1713721286', 'emerald-shade Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('7aa46f37-70a0-446f-a10b-d50ad0041ebd', '79140f20-5529-4609-98c7-be0cda1ad2ee', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EMERALD-SHADE-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('5275235b-7c90-4a95-b801-179ae24042e2', '79140f20-5529-4609-98c7-be0cda1ad2ee', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EMERALD-SHADE-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('19e2201f-e1c1-4497-ae82-fbb30bffd2cc', '79140f20-5529-4609-98c7-be0cda1ad2ee', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EMERALD-SHADE-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('1b3e35ff-5ee1-486a-a119-ba734d65045c', '79140f20-5529-4609-98c7-be0cda1ad2ee', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EMERALD-SHADE-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('82315edd-b0d5-45e1-804a-220a8b77e979', '79140f20-5529-4609-98c7-be0cda1ad2ee', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EMERALD-SHADE-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('2dbc3208-cda8-4716-b2a6-bff3f9367f0a', '79140f20-5529-4609-98c7-be0cda1ad2ee', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EMERALD-SHADE-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('b3e141d6-5e9c-4865-a110-53679ba2641d', 'purple-shade', 'Purple Shade', 'Purple Shadefrom the Shape Emergence collection features a complex interplay of geometric shapes and vibrant colors creating an illusion of three-dimensional space on a two-dimensional surface. The artwork is composed of various hues of purples and blues, juxtaposed with stark blacks and touches of contrasting colors, which appear to be both merging into and emerging from one another. The texture gives the impression of a woven fabric, adding a tactile dimension to the visual experience.', '2c71e66d-96fb-4775-9256-f1427e7de746', 
        'VividWalls', 'Artwork',
        '{"Shape Emergence"}', 'draft', 
        'Purple Shade 24x36 Gallery Wrapped Canvas', 
        'Purple Shadefrom the Shape Emergence collection features a complex interplay of geometric shapes and vibrant colors creating an illusion of three-dimensional space on a two-dimensional surface. The artwork is composed of various hues of purples and blues, juxtaposed with stark blacks and touches of contrasting colors, which appear to be both merging into and emerging from one another. The texture gives the impression of a woven fabric, adding a tactile dimension to the visual experience.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0558d136-6094-4fb3-a0b4-8cce6e49a59a', 'b3e141d6-5e9c-4865-a110-53679ba2641d', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/shade_purple_no1_canvas_black_frame_53x72_b3ee597a-30fb-46c1-b7e0-f17b15beb23a.png?v=1713721258', 'purple-shade Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('7b222618-422e-4b52-8278-add270dd8c6e', 'b3e141d6-5e9c-4865-a110-53679ba2641d', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/shade_purple_no1_canvas_white_frame_53x72_62df984e-6a0c-4a40-bfc0-eb59028f0e54.png?v=1713721258', 'purple-shade Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('39844221-3185-4a9c-a7dc-894c82167e46', 'b3e141d6-5e9c-4865-a110-53679ba2641d', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/shade_purple_no1_canvas_no_frame_53x72_1f0a3c13-292f-431e-affd-0a240a4179a1.png?v=1713721258', 'purple-shade Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('bb1fe2fc-c6d3-4fd4-8ba4-8eb7e020c364', 'b3e141d6-5e9c-4865-a110-53679ba2641d', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/shade_purple_no1_canvas_black_frame_36x48_a947e651-fe56-4d02-86d7-8c5ee4f62db7.png?v=1713721258', 'purple-shade Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('f41cdf0c-c2d6-44a0-a5aa-d8a0ab99e76f', 'b3e141d6-5e9c-4865-a110-53679ba2641d', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/shade_purple_no1_canvas_white_frame_36x48_5c698cae-d0b8-40b1-978a-aefa58aa54fe.png?v=1713721258', 'purple-shade Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('474172c7-524a-4b6e-9716-a1d3cedb54b9', 'b3e141d6-5e9c-4865-a110-53679ba2641d', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/shade_purple_no1_canvas_no_frame_36x48_31583630-8b41-493c-b790-c1d79b2e79bd.png?v=1713721258', 'purple-shade Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('c3a261c9-fd58-45db-bf26-3bde05a72c57', 'b3e141d6-5e9c-4865-a110-53679ba2641d', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PURPLE-SHADE-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('738ef450-8e3c-45ee-abfc-22a2d9d64372', 'b3e141d6-5e9c-4865-a110-53679ba2641d', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PURPLE-SHADE-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('50c6fd2d-106b-440a-90ac-86bb47918d30', 'b3e141d6-5e9c-4865-a110-53679ba2641d', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PURPLE-SHADE-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('7e5260a5-702a-49b6-a1f1-6de69678752c', 'b3e141d6-5e9c-4865-a110-53679ba2641d', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PURPLE-SHADE-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('bcd9072d-c4a2-401c-90df-24966ccff046', 'b3e141d6-5e9c-4865-a110-53679ba2641d', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PURPLE-SHADE-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('208b69c2-b540-4bfd-909b-21f1bb12d388', 'b3e141d6-5e9c-4865-a110-53679ba2641d', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PURPLE-SHADE-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('e3a9a6b4-7c4f-4df8-a6de-0dc3f0dc7eec', 'festive-patterns-no3', 'Festive Patterns no3', 'Festive Patterns no3 from the Shape Emergence collection is a dazzling array of color and movement. This piece features intricate geometric shapes in bright yellows, bold greens, and deep purples, creating an exuberant, celebration-like atmosphere. The overlapping and interlocking patterns generate a festive energy that seems to dance across the canvas. The complexity of the design, combined with the vivid color palette, makes this artwork a vibrant centerpiece for any contemporary space.', '2c71e66d-96fb-4775-9256-f1427e7de746', 
        'VividWalls', 'Artwork',
        '{"Shape Emergence"}', 'draft', 
        'Festive Patterns no3 24x36 Gallery Wrapped Canvas', 
        'Festive Patterns no3 from the Shape Emergence collection is a dazzling array of color and movement. This piece features intricate geometric shapes in bright yellows, bold greens, and deep purples, creating an exuberant, celebration-like atmosphere. The overlapping and interlocking patterns generate a festive energy that seems to dance across the canvas. The complexity of the design, combined with the vivid color palette, makes this artwork a vibrant centerpiece for any contemporary space.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('998aa39e-fb88-43c1-b1df-3fbcefb7eb5a', 'e3a9a6b4-7c4f-4df8-a6de-0dc3f0dc7eec', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no3_canvas_black_frame_53x72_de175a8d-5dfa-4498-baeb-967b7098a8eb.png?v=1713721232', 'festive-patterns-no3 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('3f8b715d-8243-453d-920d-03014a99dd96', 'e3a9a6b4-7c4f-4df8-a6de-0dc3f0dc7eec', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no3_canvas_white_frame_53x72_dcc87c10-e0e6-4ac4-b98c-73ebc773de8e.png?v=1713721232', 'festive-patterns-no3 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('67d8edc6-b025-4cce-9705-a300b4e6ce7a', 'e3a9a6b4-7c4f-4df8-a6de-0dc3f0dc7eec', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no3_canvas_no_frame_53x72_69fa9885-9d33-4dbc-9de5-76f874fc9bd9.png?v=1713721232', 'festive-patterns-no3 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('a8048396-bba5-410f-9e49-bec2112ca17d', 'e3a9a6b4-7c4f-4df8-a6de-0dc3f0dc7eec', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no3_canvas_black_frame_36x48_730860ed-1402-4b77-a1df-9ab34481bea5.png?v=1713721232', 'festive-patterns-no3 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('c2968888-796a-4715-b32e-1829a71a9bab', 'e3a9a6b4-7c4f-4df8-a6de-0dc3f0dc7eec', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no3_canvas_white_frame_36x48_5a57c560-75eb-44d8-9e34-b33f6c30fc70.png?v=1713721232', 'festive-patterns-no3 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('43cdcaac-641c-474a-8d0d-3abef30b6697', 'e3a9a6b4-7c4f-4df8-a6de-0dc3f0dc7eec', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no3_canvas_no_frame_36x48_6eb0a7c7-2b0c-4cd0-b87f-e819a42ffc0a.png?v=1713721232', 'festive-patterns-no3 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('bcfbd7d5-52f6-49af-a79a-21aa6ef0916d', 'e3a9a6b4-7c4f-4df8-a6de-0dc3f0dc7eec', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FESTIVE-PATTERNS-NO3-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('a8e83c8f-f312-4bd2-ae6f-7aa58489a6c7', 'e3a9a6b4-7c4f-4df8-a6de-0dc3f0dc7eec', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FESTIVE-PATTERNS-NO3-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('df2ed008-e8cd-4c97-b3e4-8fc4e6d7e764', 'e3a9a6b4-7c4f-4df8-a6de-0dc3f0dc7eec', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FESTIVE-PATTERNS-NO3-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('e60ccf72-0a46-46b8-a1fd-b56592a56028', 'e3a9a6b4-7c4f-4df8-a6de-0dc3f0dc7eec', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FESTIVE-PATTERNS-NO3-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('42f854a2-ed5f-48dd-a9ba-db8da76525cc', 'e3a9a6b4-7c4f-4df8-a6de-0dc3f0dc7eec', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FESTIVE-PATTERNS-NO3-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('9c385aa9-1e4a-4005-ad18-42737b817bad', 'e3a9a6b4-7c4f-4df8-a6de-0dc3f0dc7eec', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FESTIVE-PATTERNS-NO3-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('03edf132-58e4-4e93-8530-a538baf4a2a7', 'festive-patterns-no1', 'Festive Patterns no1', 'Festive Patterns no1 from the Shape Emergence collection showcases a dynamic interplay of geometric shapes and colors. The composition is a vivid tapestry of overlapping forms, predominantly in shades of deep blue, rich purples, and vibrant reds, creating a sense of layered depth. White spaces peek through, offering a stark contrast that accentuates the overall boldness of the artwork. The canvas texture adds an organic touch to the sharp geometric lines, highlighting the intricate digital craftsmanship.', '2c71e66d-96fb-4775-9256-f1427e7de746', 
        'VividWalls', 'Artwork',
        '{"Shape Emergence"}', 'draft', 
        'Festive Patterns no1 24x36 Gallery Wrapped Canvas', 
        'Festive Patterns no1 from the Shape Emergence collection showcases a dynamic interplay of geometric shapes and colors. The composition is a vivid tapestry of overlapping forms, predominantly in shades of deep blue, rich purples, and vibrant reds, creating a sense of layered depth. White spaces peek through, offering a stark contrast that accentuates the overall boldness of the artwork. The canvas texture adds an organic touch to the sharp geometric lines, highlighting the intricate digital craftsmanship.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('010e2663-1abf-4428-972b-dfb853b8323d', '03edf132-58e4-4e93-8530-a538baf4a2a7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no1_canvas_black_frame_53x72_64c37ff0-2698-4a38-b9bd-ffc947aabfb2.png?v=1713721202', 'festive-patterns-no1 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('c8c473d7-bd6a-4aa8-9d41-76beb6be69e6', '03edf132-58e4-4e93-8530-a538baf4a2a7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no1_canvas_white_frame_53x72_18151492-04c3-4b7c-885c-fae634337541.png?v=1713721202', 'festive-patterns-no1 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('305e8269-156b-4980-a2a6-54921b806856', '03edf132-58e4-4e93-8530-a538baf4a2a7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no1_canvas_no_frame_53x72_8aea4ecc-d247-4aa8-9929-e6131c98426c.png?v=1713721203', 'festive-patterns-no1 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('06ff6ff0-002c-4d46-a8c9-5455af14922e', '03edf132-58e4-4e93-8530-a538baf4a2a7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no1_canvas_white_frame_36x48_7ad597ba-86a6-4be5-8bd4-39fa54a04de7.png?v=1713721203', 'festive-patterns-no1 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('2aec19a5-6826-45b4-b2ea-2835866d2df3', '03edf132-58e4-4e93-8530-a538baf4a2a7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no1_canvas_black_frame_36x24_7953f151-d889-4018-b15d-7ca9d5b5ef62.png?v=1713721203', 'festive-patterns-no1 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e11547e0-44aa-46a9-bf58-bb35b52255ca', '03edf132-58e4-4e93-8530-a538baf4a2a7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no1_canvas_black_frame_24x36_419ac9a8-d276-4fd7-9a40-bc7b4432a998.png?v=1713721203', 'festive-patterns-no1 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('9017b099-84f0-4b7d-bb07-c731a9149362', '03edf132-58e4-4e93-8530-a538baf4a2a7', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FESTIVE-PATTERNS-NO1-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('3b53f76f-19fc-48b9-988e-8bad7a6139f3', '03edf132-58e4-4e93-8530-a538baf4a2a7', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FESTIVE-PATTERNS-NO1-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('5318fdaf-7a01-4d4d-af70-2f1687f9d79f', '03edf132-58e4-4e93-8530-a538baf4a2a7', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FESTIVE-PATTERNS-NO1-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('1f5e420e-b54a-4190-8e27-387681c89cef', '03edf132-58e4-4e93-8530-a538baf4a2a7', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FESTIVE-PATTERNS-NO1-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('f71083cf-bbc2-428f-894e-305ba225e153', '03edf132-58e4-4e93-8530-a538baf4a2a7', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FESTIVE-PATTERNS-NO1-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4a02c575-4dde-45cb-ab81-a60d0df54886', '03edf132-58e4-4e93-8530-a538baf4a2a7', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FESTIVE-PATTERNS-NO1-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('26eefab3-9325-47e9-ad86-d09ed3e84316', 'festive-patterns-no2', 'Festive Patterns no2', '"Festive Patterns no2" stands as a masterful exploration of geometric abstraction within the acclaimed Shape Emergence collection. This museum-quality limited edition piece orchestrates a sophisticated interplay of deep emerald greens and vibrant crimson reds, punctuated by strategic touches of electric blue and pristine white. The artist demonstrates exceptional command over compositional dynamics, creating a multilayered visual experience where geometric forms appear to float and intersect with architectural precision. The work''s distinctive canvas-like texture adds a compelling tactile dimension to its digital origins, while masterfully executed transparency effects allow shapes to merge and separate in a rhythmic dance across the picture plane. Drawing influence from both Constructivist principles and contemporary digital art movements, the piece achieves a remarkable balance between mathematical order and organic fluidity.', '2c71e66d-96fb-4775-9256-f1427e7de746', 
        'VividWalls', 'Artwork',
        '{"Shape Emergence"}', 'draft', 
        'Festive Patterns no2 24x36 Gallery Wrapped Canvas', 
        '');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('1e992d72-41c0-4cb4-b0c6-792013979125', '26eefab3-9325-47e9-ad86-d09ed3e84316', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no2_canvas_black_frame_53x72_fa5453d8-5d5e-4930-bc19-eaf86a242ab4.png?v=1713721179', 'festive-patterns-no2 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('7130125b-9146-4b03-a6d5-4cdd851830d9', '26eefab3-9325-47e9-ad86-d09ed3e84316', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no2_canvas_white_frame_53x72_76c075cc-cb59-4960-b37e-5c5f4e79a6a1.png?v=1713721179', 'festive-patterns-no2 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0fb5e2a1-62c7-4a46-9e26-5dfd8a8173bf', '26eefab3-9325-47e9-ad86-d09ed3e84316', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no2_canvas_no_frame_53x72_881b8078-faa4-4735-b654-9029c957f05d.png?v=1713721179', 'festive-patterns-no2 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('3d5379f9-7f90-4f83-8860-e05333521273', '26eefab3-9325-47e9-ad86-d09ed3e84316', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no2_canvas_black_frame_36x48_8ec49999-0dcc-48c6-b73a-9521e3f62daf.png?v=1713721179', 'festive-patterns-no2 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('677244ed-fe6e-4c71-b761-a4a56646a513', '26eefab3-9325-47e9-ad86-d09ed3e84316', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no2_canvas_white_frame_36x48_429275e4-89f8-4347-995d-71a20e90687c.png?v=1713721179', 'festive-patterns-no2 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('7e4e8947-91a5-4c3d-8ab0-f8b17b1bbccc', '26eefab3-9325-47e9-ad86-d09ed3e84316', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/festive_pattern_no2_canvas_no_frame_36x48_1f8f8c7f-87b2-4515-98b5-6f50d971543b.png?v=1713721179', 'festive-patterns-no2 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('073f8d57-6aae-4c5b-bcf9-b81a51a13678', '26eefab3-9325-47e9-ad86-d09ed3e84316', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FESTIVE-PATTERNS-NO2-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('eaeb6a74-4fee-4dbc-bc9a-30e970b65f24', '26eefab3-9325-47e9-ad86-d09ed3e84316', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FESTIVE-PATTERNS-NO2-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('2caf1f10-c02d-4ad9-8e7e-1569adef29d7', '26eefab3-9325-47e9-ad86-d09ed3e84316', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FESTIVE-PATTERNS-NO2-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('76a323aa-3143-48d7-acdb-bdeade239683', '26eefab3-9325-47e9-ad86-d09ed3e84316', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FESTIVE-PATTERNS-NO2-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('3ef19d7d-c85f-4037-b95e-e6628abecf5b', '26eefab3-9325-47e9-ad86-d09ed3e84316', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FESTIVE-PATTERNS-NO2-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('a4fed486-7d9f-4f93-b2a9-e8248ff30c96', '26eefab3-9325-47e9-ad86-d09ed3e84316', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FESTIVE-PATTERNS-NO2-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('65513c07-ea60-40b6-adc8-1fe0369cf574', 'earthy-kimono', 'Earthy Kimono', 'Earthy Kimonofrom the Geometric Symmetry collection captures the essence of traditional Japanese attire with a contemporary twist. The artwork is a rich tapestry of warm earth tones, intersected by bold geometric shapes that mimic the folds and creases of a kimono. The layered textures and color gradients add depth and intrigue, creating a piece that is both grounded in nature and vibrant in its execution.', 'afdd4df5-a788-416a-a39b-940ff50c21d2', 
        'VividWalls', 'Artwork',
        '{"Geometric Symmetry"}', 'active', 
        'Earthy Kimono 24x36 Gallery Wrapped Canvas', 
        'Earthy Kimonofrom the Geometric Symmetry collection captures the essence of traditional Japanese attire with a contemporary twist. The artwork is a rich tapestry of warm earth tones, intersected by bold geometric shapes that mimic the folds and creases of a kimono. The layered textures and color gradients add depth and intrigue, creating a piece that is both grounded in nature and vibrant in its execution.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('ba422e9d-be8b-461e-9076-56ba9d1d2c8d', '65513c07-ea60-40b6-adc8-1fe0369cf574', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_kimono_no4_black_frame_53x72_d11f4d12-b239-4cda-967f-e4ad1f24c370.png?v=1713721967', 'earthy-kimono Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('a1b28feb-3b29-48c8-a89b-14fc4e16bb56', '65513c07-ea60-40b6-adc8-1fe0369cf574', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_kimono_no4_white_frame_53x72_f35a1a4e-0f0f-41bc-bc76-27ffe648dc19.png?v=1713721967', 'earthy-kimono Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('cab89a71-4e3c-4686-a415-7d5ab65aacc1', '65513c07-ea60-40b6-adc8-1fe0369cf574', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_kimono_no4_no_frame_53x72_503a3266-fc24-4e64-9748-435d7778a606.png?v=1713721967', 'earthy-kimono Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('ccbc75f3-4836-4da4-a05e-90088ce4b9f1', '65513c07-ea60-40b6-adc8-1fe0369cf574', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_kimono_no4_black_frame_36x48_1ced941f-b83d-42e3-a782-d23913cff6d2.png?v=1713721967', 'earthy-kimono Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('2535c234-08a4-41fc-aa56-01bf36c795d8', '65513c07-ea60-40b6-adc8-1fe0369cf574', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_kimono_no4_white_frame_36x48_e03e57fe-c981-4b28-9ce5-14ebe1b6de94.png?v=1713721967', 'earthy-kimono Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('cd9eac72-1b29-43d1-96bb-c39bb970003c', '65513c07-ea60-40b6-adc8-1fe0369cf574', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_kimono_no4_no_frame_36x48-1_ac299e7e-35b8-41ae-aa71-6eb3b5b584b8.png?v=1713721967', 'earthy-kimono Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('34e75eb0-ef05-434b-81fe-b272a09093b5', '65513c07-ea60-40b6-adc8-1fe0369cf574', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EARTHY-KIMONO-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('527baf04-682e-49c3-ba84-6d4edaa97564', '65513c07-ea60-40b6-adc8-1fe0369cf574', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EARTHY-KIMONO-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('cce97cc8-9865-471e-9dd5-21cad637793a', '65513c07-ea60-40b6-adc8-1fe0369cf574', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EARTHY-KIMONO-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('64ba29e8-de0e-4152-a5d1-041084ec17ee', '65513c07-ea60-40b6-adc8-1fe0369cf574', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EARTHY-KIMONO-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('045353ce-5e32-44f2-8e62-1bd46d1bcc7e', '65513c07-ea60-40b6-adc8-1fe0369cf574', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EARTHY-KIMONO-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('8d98df0a-4075-4e38-afff-bf451ad163fd', '65513c07-ea60-40b6-adc8-1fe0369cf574', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EARTHY-KIMONO-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('907b4117-dc6c-47ad-9a2a-137838bd6742', 'dark-kimono', 'Dark Kimono', '"Dark Kimono" stands as a masterful convergence of traditional Japanese aesthetics and contemporary geometric abstraction, rendered with exceptional precision in the artist''s signature digital medium. This limited edition piece from the acclaimed Geometric Symmetry collection commands attention through its sophisticated interplay of royal blue, vibrant red, and pristine white against a profound black void. The composition''s vertical arrangement of precise geometric forms creates a compelling modernist interpretation of ceremonial dress, where traditional textile folds are reimagined through a distinctly minimalist lens. The artist''s meticulous attention to spatial relationships and color harmony achieves a delicate balance between cultural reverence and contemporary design language. A subtle granular texture imbues the surface with an almost ethereal quality, suggesting the luxurious shimmer of silk while maintaining its contemporary character.', 'afdd4df5-a788-416a-a39b-940ff50c21d2', 
        'VividWalls', 'Artwork',
        '{"Geometric Symmetry"}', 'active', 
        'Dark Kimono 24x36 Gallery Wrapped Canvas', 
        '"Dark Kimono" stands as a masterful convergence of traditional Japanese aesthetics and contemporary geometric abstraction, rendered with exceptional precision in the artist''s signature digital medium. This limited edition piece from the acclaimed Geometric Symmetry collection commands attention through its sophisticated interplay of royal blue, vibrant red, and pristine white against a profound black void. The composition''s vertical arrangement of precise geometric forms creates a compelling modernist interpretation of ceremonial dress, where traditional textile folds are reimagined through a distinctly minimalist lens. The artist''s meticulous attention to spatial relationships and color harmony achieves a delicate balance between cultural reverence and contemporary design language. A subtle granular texture imbues the surface with an almost ethereal quality, suggesting the luxurious shimmer of silk while maintaining its contemporary character.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('19bfc561-da12-44c8-bf60-c662fd71f320', '907b4117-dc6c-47ad-9a2a-137838bd6742', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/dark_kimono_no3_canvas_black_frame_53x72_7c74fa24-b8a2-45e0-ba9f-d594694e4533.png?v=1713721938', 'dark-kimono Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('14c71d8e-e604-40d0-b847-4df9c4e714ff', '907b4117-dc6c-47ad-9a2a-137838bd6742', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/dark_kimono_no3_canvas_white_frame_53x72_2de7fd76-dcd7-4f40-b27f-25c760edb25d.png?v=1713721938', 'dark-kimono Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('67caf811-acd6-428e-b39a-aba92e319d98', '907b4117-dc6c-47ad-9a2a-137838bd6742', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/dark_kimono_no3_canvas_no_frame_53x72_9d270d7d-44e1-4f0a-8fc9-02eb1077ae26.png?v=1713721938', 'dark-kimono Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e706b07d-de79-4f1c-a6e3-cf6c0a881590', '907b4117-dc6c-47ad-9a2a-137838bd6742', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/dark_kimono_no3_canvas_black_frame_36x48_b63b14db-3749-45c3-bebf-6a00ceaae8b4.png?v=1713721938', 'dark-kimono Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('7f408704-dd44-4f89-b478-c1bb7e550cf6', '907b4117-dc6c-47ad-9a2a-137838bd6742', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/dark_kimono_no3_canvas_white_frame_36x48_fd35cd03-0962-4568-a13b-c2a30c1516e2.png?v=1713721939', 'dark-kimono Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('184c5444-9351-4460-bfce-61429fba2992', '907b4117-dc6c-47ad-9a2a-137838bd6742', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/dark_kimono_no3_canvas_no_frame_36x48_d868c3f6-c2fe-4410-9d9b-bbfb5fa9d488.png?v=1713721939', 'dark-kimono Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('bd1c5a7f-dd20-449f-8537-693ab1b1a441', '907b4117-dc6c-47ad-9a2a-137838bd6742', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'DARK-KIMONO-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('a991bc8b-94ed-4f85-9f3b-430205e7a585', '907b4117-dc6c-47ad-9a2a-137838bd6742', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'DARK-KIMONO-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('03a85063-518d-44af-992c-e257f4c2f5b4', '907b4117-dc6c-47ad-9a2a-137838bd6742', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'DARK-KIMONO-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('3567c3d3-8f1a-4432-b6d3-666f13f4b3cd', '907b4117-dc6c-47ad-9a2a-137838bd6742', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'DARK-KIMONO-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('9917f58c-afec-4fc3-87e1-bef6cb9f4691', '907b4117-dc6c-47ad-9a2a-137838bd6742', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'DARK-KIMONO-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('6445e37a-2c1d-4f4f-ac8b-fb6da29d887d', '907b4117-dc6c-47ad-9a2a-137838bd6742', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'DARK-KIMONO-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('4f707cc1-5952-435c-afcd-2ef50d87e464', 'teal-kimono', 'Teal Kimono', 'Teal Kimonofrom the Geometric Symmetry collection showcases an intricate pattern of geometric shapes in a serene teal color scheme, interspersed with accents of rich magenta and deep blues. This composition features a harmonious symmetry that mirrors the traditional aesthetic of a kimono, while the cool teal evokes a sense of calm and balance. The abstract design encapsulates a modern reinterpretation of classic textile patterns, with a touch of digital artistry, perfect for contemporary decor.', 'afdd4df5-a788-416a-a39b-940ff50c21d2', 
        'VividWalls', 'Artwork',
        '{"Geometric Symmetry"}', 'active', 
        'Teal Kimono 24x36 Gallery Wrapped Canvas', 
        'Teal Kimonofrom the Geometric Symmetry collection showcases an intricate pattern of geometric shapes in a serene teal color scheme, interspersed with accents of rich magenta and deep blues. This composition features a harmonious symmetry that mirrors the traditional aesthetic of a kimono, while the cool teal evokes a sense of calm and balance. The abstract design encapsulates a modern reinterpretation of classic textile patterns, with a touch of digital artistry, perfect for contemporary decor.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('16a73e71-eb0f-4d29-ae7a-8a1302783523', '4f707cc1-5952-435c-afcd-2ef50d87e464', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/teal_kimono_no3_blac_frame_53x72_7ecd63d7-c7e5-46a3-a555-05fa344044bd.png?v=1713721910', 'teal-kimono Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('dbcc264e-b3f0-430d-adde-3fb11eb641be', '4f707cc1-5952-435c-afcd-2ef50d87e464', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/teal_kimono_no3_white_frame_53x72_f983235f-1cb4-45aa-bd2a-97de93766141.png?v=1713721910', 'teal-kimono Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b6a009ca-e248-4f41-8d2f-d0ae837a3cde', '4f707cc1-5952-435c-afcd-2ef50d87e464', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/teal_kimono_no3_no_frame_53x72_64a25cfd-56d4-4feb-aff2-7b1d8b722c5e.png?v=1713721910', 'teal-kimono Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('a994751e-8bd1-4a1b-8dd4-cc99bbfc9622', '4f707cc1-5952-435c-afcd-2ef50d87e464', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/teal_kimono_no3_black_frame_36x48_d3b555e3-a2f2-4596-bfcf-f6de23f8261b.png?v=1713721910', 'teal-kimono Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('23690e25-df32-47b3-85ad-a945613910f7', '4f707cc1-5952-435c-afcd-2ef50d87e464', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/teal_kimono_no3_white_frame_36x48_5dba6477-11ad-4be7-be09-4485324df222.png?v=1713721910', 'teal-kimono Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('eb0cc1e0-9eda-4054-b3e4-0a738ac986f7', '4f707cc1-5952-435c-afcd-2ef50d87e464', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/teal_kimono_no3_no_frame_36x48_2a43b685-7ee5-4790-b801-247a448f5446.png?v=1713721910', 'teal-kimono Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('631bb841-5cb8-48a1-8a00-ed6a27f0df81', '4f707cc1-5952-435c-afcd-2ef50d87e464', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'TEAL-KIMONO-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('a23ab803-dad9-44c4-9650-8ca2f4d7178b', '4f707cc1-5952-435c-afcd-2ef50d87e464', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'TEAL-KIMONO-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('79306816-8eeb-49bb-8854-e5b5f8ad0815', '4f707cc1-5952-435c-afcd-2ef50d87e464', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'TEAL-KIMONO-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('eb66dd31-9edd-4990-b332-106fd438dfc6', '4f707cc1-5952-435c-afcd-2ef50d87e464', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'TEAL-KIMONO-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('bfdb1680-afef-4548-ba37-73fb1f1d4c5a', '4f707cc1-5952-435c-afcd-2ef50d87e464', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'TEAL-KIMONO-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('3e77102a-38cb-4579-a5e9-e6a024d31a9b', '4f707cc1-5952-435c-afcd-2ef50d87e464', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'TEAL-KIMONO-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('611ff194-a914-42d8-8814-0ed4c424dd9b', 'red-kimono', 'Red Kimono', 'Red Kimonofrom the Geometric Intersect collection presents a striking red geometric assembly that beautifully merges traditional kimono aesthetics with contemporary geometric design principles. This artwork captures the flowing grace and structural elegance of traditional Japanese garments while reimagining them through a modern geometric lens. The rich red palette evokes the ceremonial significance and cultural depth of traditional kimonos, while the geometric patterns create a bridge between ancient textile traditions and contemporary digital art. Each geometric element flows seamlessly into the next, creating a rhythm that mirrors the natural drape and movement of fabric, yet maintains the precision and clarity that characterizes modern geometric art.', 'afdd4df5-a788-416a-a39b-940ff50c21d2', 
        'VividWalls', 'Artwork',
        '{"Geometric Symmetry"}', 'active', 
        'Red Kimono 24x36 Gallery Wrapped Canvas', 
        'Red Kimonofrom the Geometric Intersect collection presents a striking red geometric assembly that beautifully merges traditional kimono aesthetics with contemporary geometric design principles. This artwork captures the flowing grace and structural elegance of traditional Japanese garments while reimagining them through a modern geometric lens. The rich red palette evokes the ceremonial significance and cultural depth of traditional kimonos, while the geometric patterns create a bridge between ancient textile traditions and contemporary digital art. Each geometric element flows seamlessly into the next, creating a rhythm that mirrors the natural drape and movement of fabric, yet maintains the precision and clarity that characterizes modern geometric art.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('31384e06-31af-4aab-a705-9a56ea2d132e', '611ff194-a914-42d8-8814-0ed4c424dd9b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/red_kimono_no1_canvas_black_frame_53x72_edc27fc9-c91c-490a-b0b3-2021cd1e8a63.png?v=1713721879', 'red-kimono Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('8eb80c4e-3392-4320-8c37-3e61f534db16', '611ff194-a914-42d8-8814-0ed4c424dd9b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/red_kimono_no1_canvas_white_frame_53x72_4b81bf08-2e8e-4c45-83d8-f746e1cdba80.png?v=1713721879', 'red-kimono Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('629bc381-cc25-4b8b-a080-d5f9a74c985d', '611ff194-a914-42d8-8814-0ed4c424dd9b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/red_kimono_no1_canvas_no_frame_53x72_c03a3e63-54c4-41b2-86ba-1a92356de9dd.png?v=1713721879', 'red-kimono Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('5d0875b3-d39b-472a-a4e0-d57ad97cb523', '611ff194-a914-42d8-8814-0ed4c424dd9b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/red_kimono_no1_canvas_black_frame_36x48_d46758fe-f1bc-4659-a40a-f28de60c7b0d.png?v=1713721879', 'red-kimono Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('83278b29-49b9-41eb-8d51-63d9a2f454c4', '611ff194-a914-42d8-8814-0ed4c424dd9b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/red_kimono_no1_canvas_white_frame_36x48_4cbda106-f6ee-415a-a3b7-1f0f4fd0d820.png?v=1713721879', 'red-kimono Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('a34ebe4c-61e8-413c-bc53-87ab5836b89b', '611ff194-a914-42d8-8814-0ed4c424dd9b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/red_kimono_no1_canvas_no_frame_36x48_ef24a92e-52db-4bb7-b1be-b02948777098.png?v=1713721879', 'red-kimono Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('7cce0a71-4f16-4cf9-85a3-d16800cd3f9f', '611ff194-a914-42d8-8814-0ed4c424dd9b', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'RED-KIMONO-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('f9d40b16-d402-4c43-950f-11021680f00c', '611ff194-a914-42d8-8814-0ed4c424dd9b', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'RED-KIMONO-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('711dbde0-10f8-4a64-84ea-6f383567c542', '611ff194-a914-42d8-8814-0ed4c424dd9b', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'RED-KIMONO-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('533f5af1-70bf-47dc-83ef-8499b9b378af', '611ff194-a914-42d8-8814-0ed4c424dd9b', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'RED-KIMONO-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4d860e28-d0f6-439e-89a7-4e7f39177e21', '611ff194-a914-42d8-8814-0ed4c424dd9b', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'RED-KIMONO-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('6bdcab86-9e9f-47c1-9eb1-7ab7212fadef', '611ff194-a914-42d8-8814-0ed4c424dd9b', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'RED-KIMONO-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('db974457-944e-4587-bc9c-8423e12b4d55', 'royal-kimono', 'Royal Kimono', 'Royal Kimonofrom the Geometric Symmetry collection presents a commanding interplay of geometric forms bathed in a dominant blue palette, intertwined with accents of vibrant pink. The artwork is composed of layered parallelograms and triangles, converging to create a mirror-like symmetry that is evocative of the elegance and stature of a kimono. This piece marries the tranquility of cool blues with the energy of pink, offering a visual experience that is both balanced and dynamic. "Royal Kimono" exemplifies the beauty of symmetry in abstract design, portraying a modern interpretation of traditional garment folds in a geometric abstraction.', 'afdd4df5-a788-416a-a39b-940ff50c21d2', 
        'VividWalls', 'Artwork',
        '{"Geometric Symmetry"}', 'active', 
        'Royal Kimono 24x36 Gallery Wrapped Canvas', 
        'Royal Kimonofrom the Geometric Symmetry collection presents a commanding interplay of geometric forms bathed in a dominant blue palette, intertwined with accents of vibrant pink. The artwork is composed of layered parallelograms and triangles, converging to create a mirror-like symmetry that is evocative of the elegance and stature of a kimono. This piece marries the tranquility of cool blues with the energy of pink, offering a visual experience that is both balanced and dynamic. "Royal Kimono" exemplifies the beauty of symmetry in abstract design, portraying a modern interpretation of traditional garment folds in a geometric abstraction.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b5e5b83b-8826-4824-904c-51064d050fa8', 'db974457-944e-4587-bc9c-8423e12b4d55', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/royal-kimono-no1_canvas_black_frame_53x72_17fc1dfa-205f-4dd9-bb04-50e55d630a07.png?v=1713721794', 'royal-kimono Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b2445698-d2fa-4770-a4d8-d99b693af840', 'db974457-944e-4587-bc9c-8423e12b4d55', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/royal-kimono-no1_canvas_white_frame_53x72_c22c5558-c773-4d1e-bdb2-4ac5525d56ff.png?v=1713721794', 'royal-kimono Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('050131da-c4d2-4cfe-80f6-8c599b6541a5', 'db974457-944e-4587-bc9c-8423e12b4d55', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/royal-kimono-no1_canvas_no_frame_53x72_ba742bdf-85dc-4f53-b312-125c4b7fa57a.png?v=1713721794', 'royal-kimono Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('10d4464f-bcf5-421d-87c7-e1b906195ea5', 'db974457-944e-4587-bc9c-8423e12b4d55', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Royal-Kimono-no1_canvas_black_frame_36x48_5d3f58dd-641a-438a-b5dd-92d78223db1b.png?v=1713721794', 'royal-kimono Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('8322c159-f0e6-4830-b19a-5fe00d7c8ae4', 'db974457-944e-4587-bc9c-8423e12b4d55', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Royal-Kimono-no1_canvas_no_frame_36x48_e85ed945-badc-4c88-8549-080f1db23035.png?v=1713721794', 'royal-kimono Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('6065d968-d016-4d50-ab0d-34d2b5fd99e8', 'db974457-944e-4587-bc9c-8423e12b4d55', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Royal-Kimono-no1_canvas_black_frame_24x36_c13819ea-ccd9-453d-a274-5212325d7f9d.png?v=1713721794', 'royal-kimono Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('2fac18a5-8ce5-48bf-b72e-52c2fbaa063a', 'db974457-944e-4587-bc9c-8423e12b4d55', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'ROYAL-KIMONO-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('a0c29e73-2765-4a07-9ab6-a529d09ed70c', 'db974457-944e-4587-bc9c-8423e12b4d55', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'ROYAL-KIMONO-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('e694dedb-ce49-412a-bcce-1485ed058498', 'db974457-944e-4587-bc9c-8423e12b4d55', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'ROYAL-KIMONO-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b9a6aefe-c3a6-4a9a-86a4-b1e35724fdc7', 'db974457-944e-4587-bc9c-8423e12b4d55', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'ROYAL-KIMONO-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('77ae0430-8650-45c6-9fda-c136097c912b', 'db974457-944e-4587-bc9c-8423e12b4d55', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'ROYAL-KIMONO-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b96ec391-517e-40b7-90e0-4bf802c0ff80', 'db974457-944e-4587-bc9c-8423e12b4d55', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'ROYAL-KIMONO-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('150d9691-d739-4ede-a4dc-26f950cf1d09', 'monochrome-kimono', 'Monochrome Kimono', '"Monochrome Kimono" stands as a masterful exploration of geometric abstraction, where stark contrasts and precise architectural forms coalesce into a contemporary interpretation of traditional Japanese aesthetics. The artist''s sophisticated manipulation of positive and negative space centers on a commanding hexagonal motif, from which radiating trapezoids and planes suggest the elegant folds of a kimono rendered in modernist vocabulary. This museum-quality limited edition piece demonstrates exceptional technical precision through its nuanced grayscale transitions and distinctive textural qualities, achieving a remarkable balance between Constructivist rigidity and Eastern fluidity. The work''s careful consideration of form and void, executed through contemporary production techniques on premium substrate, creates a compelling dialogue between traditional craftsmanship and modern artistic expression.', 'afdd4df5-a788-416a-a39b-940ff50c21d2', 
        'VividWalls', 'Artwork',
        '{"Geometric Symmetry"}', 'active', 
        'Monochrome Kimono 24x36 Gallery Wrapped Canvas', 
        '"Monochrome Kimono" stands as a masterful exploration of geometric abstraction, where stark contrasts and precise architectural forms coalesce into a contemporary interpretation of traditional Japanese aesthetics. The artist''s sophisticated manipulation of positive and negative space centers on a commanding hexagonal motif, from which radiating trapezoids and planes suggest the elegant folds of a kimono rendered in modernist vocabulary. This museum-quality limited edition piece demonstrates exceptional technical precision through its nuanced grayscale transitions and distinctive textural qualities, achieving a remarkable balance between Constructivist rigidity and Eastern fluidity. The work''s careful consideration of form and void, executed through contemporary production techniques on premium substrate, creates a compelling dialogue between traditional craftsmanship and modern artistic expression.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('4ba89189-84c4-48f5-948e-57f32e7965f7', '150d9691-d739-4ede-a4dc-26f950cf1d09', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/monochrome_kimono_no1_black_frame_53x72_8fe9d3b9-a91a-4bb5-bc4a-30124633ece2.png?v=1713721770', 'monochrome-kimono Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('3c0d2fe2-560b-4b5f-b46b-19da95d2fe0e', '150d9691-d739-4ede-a4dc-26f950cf1d09', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/monochrome_kimono_no1_white_frame_53x72_9646551a-346f-42b0-b06c-414b294c080b.png?v=1713721770', 'monochrome-kimono Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('90b600c1-7847-4676-8806-2dacb04a81cf', '150d9691-d739-4ede-a4dc-26f950cf1d09', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/monochrome_kimono_no1_no_frame_53x72_1486f146-cd80-4290-afe1-aac5810cd7a8.png?v=1713721770', 'monochrome-kimono Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('81a370a8-ddcc-4d74-81f3-80a44b9a2c25', '150d9691-d739-4ede-a4dc-26f950cf1d09', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/monochrome_kimono_no1_black_frame_36x48_02fc822b-ba16-40f8-ba3b-da1b1910f192.png?v=1713721770', 'monochrome-kimono Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('2e2c627f-b548-4af1-b954-14d6ae42832f', '150d9691-d739-4ede-a4dc-26f950cf1d09', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/monochrome_kimono_no1_white_frame_36x48_91853813-1428-4611-86d2-adf55201e9d2.png?v=1713721770', 'monochrome-kimono Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('ffaad2f2-1fd1-4dd9-ab61-28d998f3dc1c', '150d9691-d739-4ede-a4dc-26f950cf1d09', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/monochrome_kimono_no1_no_frame_36x48_f21b8f04-bcfb-4465-ae8e-a443bd5f06f9.png?v=1713721770', 'monochrome-kimono Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('78631658-6a34-4a61-ad3c-0da9367fb80b', '150d9691-d739-4ede-a4dc-26f950cf1d09', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'MONOCHROME-KIMONO-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b5d1417d-d0a0-4961-b9e2-f31352353ddf', '150d9691-d739-4ede-a4dc-26f950cf1d09', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'MONOCHROME-KIMONO-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('d616f8e4-45bc-4790-a13a-1ccb0a461780', '150d9691-d739-4ede-a4dc-26f950cf1d09', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'MONOCHROME-KIMONO-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('c63b59c3-f159-42d1-806f-272d1ec5f7b4', '150d9691-d739-4ede-a4dc-26f950cf1d09', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'MONOCHROME-KIMONO-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('cc89d264-b1f3-4744-ad13-da6d415f8b5c', '150d9691-d739-4ede-a4dc-26f950cf1d09', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'MONOCHROME-KIMONO-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('3d5e4f84-31d6-46df-80dc-e4053c60de5e', '150d9691-d739-4ede-a4dc-26f950cf1d09', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'MONOCHROME-KIMONO-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('33d65440-bbd2-4899-beec-e35146117102', 'noir-weave', 'Noir Weave', '"Noir Weave," a distinguished limited edition piece from the Vivid Layers collection, masterfully orchestrates a sophisticated interplay of geometric abstraction and textural depth. The artist''s virtuosic command of the grayscale spectrum manifests in a complex architectural composition where intersecting planes of light and shadow create a mesmerizing sense of dimensional movement. Translucent layers overlap with precise angular forms, evoking both the mathematical rigor of Constructivism and the emotional resonance of Abstract Expressionism. The work''s distinctive woven surface texture introduces an organic quality that beautifully counterpoints its geometric precision, while the careful manipulation of transparency and opacity generates a compelling visual narrative that unfolds across multiple spatial planes.', '2baf353b-2933-4817-8050-f33735ede775', 
        'VividWalls', 'Artwork',
        '{"Vivid Layers"}', 'active', 
        'Noir Weave 24x36 Gallery Wrapped Canvas', 
        '"Noir Weave," a distinguished limited edition piece from the Vivid Layers collection, masterfully orchestrates a sophisticated interplay of geometric abstraction and textural depth. The artist''s virtuosic command of the grayscale spectrum manifests in a complex architectural composition where intersecting planes of light and shadow create a mesmerizing sense of dimensional movement. Translucent layers overlap with precise angular forms, evoking both the mathematical rigor of Constructivism and the emotional resonance of Abstract Expressionism. The work''s distinctive woven surface texture introduces an organic quality that beautifully counterpoints its geometric precision, while the careful manipulation of transparency and opacity generates a compelling visual narrative that unfolds across multiple spatial planes.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('3b636aea-d0f9-4dc9-b87f-fe42097a242a', '33d65440-bbd2-4899-beec-e35146117102', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/noir_weave_black_frame-53x72_c07bc23d-9867-4e22-b60d-60e24ddc2cfe.png?v=1713721020', 'noir-weave Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e15f222d-ce35-49aa-9355-0bd202cc9e15', '33d65440-bbd2-4899-beec-e35146117102', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/noir_weave_white_frame-53x72_2b17ee76-36f6-4db9-9f06-873f64fe7ca8.png?v=1713721020', 'noir-weave Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0bddae01-8065-4301-bb59-d3d2d086df9b', '33d65440-bbd2-4899-beec-e35146117102', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/noir_weave_no_frame-53x72_029aa2a7-e42b-4034-be97-d1894d9300b1.png?v=1713721020', 'noir-weave Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('4a2f16f3-b5a1-4a80-912b-f63456f8933e', '33d65440-bbd2-4899-beec-e35146117102', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/noir_weave_black_frame-36x48_ecdc1b08-f0ec-40db-ae59-0acb08e5e5df.png?v=1713721020', 'noir-weave Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('bd801e62-b3d4-47ba-be2b-8e90b5593aea', '33d65440-bbd2-4899-beec-e35146117102', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/noir_weave_white_frame-36x48_3781e645-82d2-411a-b7f7-46a6316fbecf.png?v=1713721020', 'noir-weave Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('46f5c17b-c879-476e-b7e7-e03d173cdc6a', '33d65440-bbd2-4899-beec-e35146117102', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/noir_weave_no_frame-36x48_e59e16d4-7683-4675-a716-c0eceea2aeb6.png?v=1713721020', 'noir-weave Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('80056f69-38b8-43ef-8486-2d27cd2e5f86', '33d65440-bbd2-4899-beec-e35146117102', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-WEAVE-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('177ca8d7-3cd8-45aa-bb40-990b72ebbbc5', '33d65440-bbd2-4899-beec-e35146117102', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-WEAVE-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('7befc3d8-7730-4054-b20d-c6fc4baa23a2', '33d65440-bbd2-4899-beec-e35146117102', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-WEAVE-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('15656cc4-3cbc-4541-9398-9545f71b3a25', '33d65440-bbd2-4899-beec-e35146117102', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-WEAVE-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('a40c7c3d-e028-4d93-a3e3-207cbd41511c', '33d65440-bbd2-4899-beec-e35146117102', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-WEAVE-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('67b7ddce-1a60-4a20-8d41-ff8b5c7ce25a', '33d65440-bbd2-4899-beec-e35146117102', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-WEAVE-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('42f52010-2b60-4702-9177-8f56db9b62a0', 'structured-noir-no2', 'Structured Noir no2', 'From the acclaimed Geometric Intersect collection, "Structured Noir no2" stands as a masterful exploration of contemporary geometric abstraction, where architectural precision meets artistic sophistication. This museum-quality limited edition piece orchestrates a compelling dialogue between intersecting angular forms, rendered in a refined palette of deep blacks, pristine whites, and meticulously calibrated grey gradients. The artist''s virtuosic command of spatial relationships manifests in overlapping planes that suggest three-dimensional depth, while subtle textural elements evoke the tactile qualities of fine art papers, softening the stark geometrical composition. Drawing inspiration from Constructivist and Bauhaus principles, the work achieves a remarkable balance between mathematical precision and organic sensibility, particularly evident in the strategic placement of a commanding vertical white element that anchors the dynamic diagonal flow.', NULL, 
        'VividWalls', 'Artwork',
        '{"Structured"}', 'active', 
        'Structured Noir no2 24x36 Gallery Wrapped Canvas', 
        'From the acclaimed Geometric Intersect collection, "Structured Noir no2" stands as a masterful exploration of contemporary geometric abstraction, where architectural precision meets artistic sophistication. This museum-quality limited edition piece orchestrates a compelling dialogue between intersecting angular forms, rendered in a refined palette of deep blacks, pristine whites, and meticulously calibrated grey gradients. The artist''s virtuosic command of spatial relationships manifests in overlapping planes that suggest three-dimensional depth, while subtle textural elements evoke the tactile qualities of fine art papers, softening the stark geometrical composition. Drawing inspiration from Constructivist and Bauhaus principles, the work achieves a remarkable balance between mathematical precision and organic sensibility, particularly evident in the strategic placement of a commanding vertical white element that anchors the dynamic diagonal flow.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('77daac7c-8dbb-4e3d-b6b1-b9024ab4d341', '42f52010-2b60-4702-9177-8f56db9b62a0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/structured_noir_no2_black_frame-53x72_739f3dc9-e81d-4458-a6c7-b9567abb222f.png?v=1713721527', 'structured-noir-no2 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('d7b82306-4fd6-4d6f-98c6-26a8b310f5f3', '42f52010-2b60-4702-9177-8f56db9b62a0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/structured_noir_no2_white_frame-53x72_cb63c1a6-cf7f-4609-8df2-df4c4d720ee6.png?v=1713721527', 'structured-noir-no2 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e72b2d6b-5ade-4a28-b041-d0280bd9c7f4', '42f52010-2b60-4702-9177-8f56db9b62a0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/structured_noir_no2_no_frame-53x72_1a6baa16-65d8-472c-b3af-15daa59eba6d.png?v=1713721528', 'structured-noir-no2 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('9e069484-7c95-4c97-8cd3-703f531b8804', '42f52010-2b60-4702-9177-8f56db9b62a0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/structured_noir_no1_black_frame-36x48_7522c0f2-1b12-4e95-a8a9-0e842e72f822.png?v=1713721528', 'structured-noir-no2 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('898ce99b-5bd3-4dda-88a8-0e96b6d61e68', '42f52010-2b60-4702-9177-8f56db9b62a0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/structured_noir_no1_white_frame-36x48_a86510d5-fc32-4489-adf3-c472de580bb2.png?v=1713721528', 'structured-noir-no2 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('c89794b7-5319-4ab0-a4da-77cf4cbfb20a', '42f52010-2b60-4702-9177-8f56db9b62a0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/structured_noir_no1_no_frame-36x48_8c1f50f6-737e-465e-9a81-3210751a8583.png?v=1713721528', 'structured-noir-no2 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b6e57020-b38b-4017-821b-db8d9e1c498e', '42f52010-2b60-4702-9177-8f56db9b62a0', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'STRUCTURED-NOIR-NO2-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('cebf985a-9aff-4010-a7d2-847195fb322d', '42f52010-2b60-4702-9177-8f56db9b62a0', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'STRUCTURED-NOIR-NO2-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('66a1d6d1-4f3a-49f5-8ba6-f8c736aa1744', '42f52010-2b60-4702-9177-8f56db9b62a0', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'STRUCTURED-NOIR-NO2-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('e7e34a61-aec8-41b5-8025-bf5aafd6bfdb', '42f52010-2b60-4702-9177-8f56db9b62a0', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'STRUCTURED-NOIR-NO2-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('fa27dd3c-ae62-4bee-a8ae-35b23e77351d', '42f52010-2b60-4702-9177-8f56db9b62a0', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'STRUCTURED-NOIR-NO2-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('6de22e57-b372-411b-bdc3-1ff92591bfad', '42f52010-2b60-4702-9177-8f56db9b62a0', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'STRUCTURED-NOIR-NO2-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('38ef5b11-1c57-4486-9b91-fa009954a337', 'structured-noir-no1', 'Structured Noir no1', '"Structured Noir no1," a distinguished piece from the Geometric Intersect collection, masterfully exemplifies the sophisticated intersection of Constructivist principles and contemporary minimalist aesthetics. The artist''s virtuosic command of monochromatic expression manifests in a composition where precisely calibrated geometric forms create a compelling interplay of light and shadow. Through masterful layering techniques, intersecting angular elements simultaneously recede and project, establishing a dynamic spatial dialogue within the picture plane. The work''s architectural sensibility is enhanced by a subtle textural quality that adds tactile sophistication to the stark contrast between pure whites and deep blacks. This museum-quality limited edition piece demonstrates exceptional technical precision while maintaining an intellectual rigor that speaks to collectors of contemporary geometric abstraction.', '51e253ef-6d6f-4ec0-bf91-7a87d251ac5e', 
        'VividWalls', 'Artwork',
        '{"Geometric Intersect"}', 'active', 
        'Structured Noir no1 24x36 Gallery Wrapped Canvas', 
        '"Structured Noir no1," a distinguished piece from the Geometric Intersect collection, masterfully exemplifies the sophisticated intersection of Constructivist principles and contemporary minimalist aesthetics. The artist''s virtuosic command of monochromatic expression manifests in a composition where precisely calibrated geometric forms create a compelling interplay of light and shadow. Through masterful layering techniques, intersecting angular elements simultaneously recede and project, establishing a dynamic spatial dialogue within the picture plane. The work''s architectural sensibility is enhanced by a subtle textural quality that adds tactile sophistication to the stark contrast between pure whites and deep blacks. This museum-quality limited edition piece demonstrates exceptional technical precision while maintaining an intellectual rigor that speaks to collectors of contemporary geometric abstraction.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('8ea8c537-2e92-48c3-a08f-aee159822c51', '38ef5b11-1c57-4486-9b91-fa009954a337', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/structured_noir_no1_black_frame-53x72_ea2b2969-d34e-4f85-a774-906c892a55ec.png?v=1713721507', 'structured-noir-no1 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0e06f3b1-4a25-4774-ab4a-4bdcfffc099e', '38ef5b11-1c57-4486-9b91-fa009954a337', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/structured_noir_no1_white_frame-53x72_79529ff6-477d-4c5c-aaee-884860f819cd.png?v=1713721507', 'structured-noir-no1 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('41d5b2aa-8876-4838-b34e-e5af4dda3242', '38ef5b11-1c57-4486-9b91-fa009954a337', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/structured_noir_no1_no_frame-53x72_7a549413-9f09-42c8-ba90-679f78fdcd7f.png?v=1713721507', 'structured-noir-no1 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('bc2f0701-9490-42d3-9655-6ea28b60a0b7', '38ef5b11-1c57-4486-9b91-fa009954a337', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/structured_noir_no1_black_frame-36x48_a1c22cf8-cadb-4c34-a51b-7af9f9997ba7.png?v=1713721507', 'structured-noir-no1 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('86dbce70-f442-431b-96f0-e455b493cc10', '38ef5b11-1c57-4486-9b91-fa009954a337', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/structured_noir_no1_white_frame-36x48_f8d34bfb-b8e4-485b-a9c3-69481acfcea3.png?v=1713721507', 'structured-noir-no1 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('46b24c9f-40b3-4bca-bb17-082212ac95a0', '38ef5b11-1c57-4486-9b91-fa009954a337', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/structured_noir_no1_no_frame-36x48_8a2044eb-55bc-436c-8b3c-1c552d5c353e.png?v=1713721507', 'structured-noir-no1 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('8bffeb57-1637-48d6-ae07-ecdd8e204fc3', '38ef5b11-1c57-4486-9b91-fa009954a337', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'STRUCTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('99b59e66-8308-4196-a535-0fb8df6332cf', '38ef5b11-1c57-4486-9b91-fa009954a337', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'STRUCTURED-NOIR-NO1-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('40059d13-ddc1-4927-b150-edd0ca52443b', '38ef5b11-1c57-4486-9b91-fa009954a337', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'STRUCTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('05402726-7a99-4061-90f6-85d06dbe65ef', '38ef5b11-1c57-4486-9b91-fa009954a337', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'STRUCTURED-NOIR-NO1-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('74675b2d-0980-4099-bba9-525908f0a565', '38ef5b11-1c57-4486-9b91-fa009954a337', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'STRUCTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('c4927781-f811-42b9-9d3d-eb755d5e7fa3', '38ef5b11-1c57-4486-9b91-fa009954a337', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'STRUCTURED-NOIR-NO1-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('82dfc8e2-f097-4812-9dcd-1c75867e821e', 'prismatic-warmth', 'Prismatic Warmth', '"Prismatic Warmth," a distinguished piece from the Geometric Intersect collection, masterfully synthesizes contemporary geometric abstraction with the warmth of traditional textile artistry. The artist''s sophisticated manipulation of overlapping transparent forms creates a mesmerizing interplay of deep navy blues, burnt oranges, and rich burgundies against pristine white spaces. This museum-quality limited edition work demonstrates exceptional technical precision in its crystalline structures while maintaining an organic sensibility through its subtle textile-like surface texture. The composition''s dynamic diagonal movement guides viewers through a carefully orchestrated visual journey, where angular forms intersect to create unexpected chromatic harmonies and dimensional depths. Drawing influence from both Constructivist principles and digital art aesthetics, the piece achieves a remarkable balance between mathematical precision and emotional resonance.', '51e253ef-6d6f-4ec0-bf91-7a87d251ac5e', 
        'VividWalls', 'Artwork',
        '{"Geometric Intersect"}', 'active', 
        'Prismatic Warmth 24x36 Gallery Wrapped Canvas', 
        '"Prismatic Warmth," a distinguished piece from the Geometric Intersect collection, masterfully synthesizes contemporary geometric abstraction with the warmth of traditional textile artistry. The artist''s sophisticated manipulation of overlapping transparent forms creates a mesmerizing interplay of deep navy blues, burnt oranges, and rich burgundies against pristine white spaces. This museum-quality limited edition work demonstrates exceptional technical precision in its crystalline structures while maintaining an organic sensibility through its subtle textile-like surface texture. The composition''s dynamic diagonal movement guides viewers through a carefully orchestrated visual journey, where angular forms intersect to create unexpected chromatic harmonies and dimensional depths. Drawing influence from both Constructivist principles and digital art aesthetics, the piece achieves a remarkable balance between mathematical precision and emotional resonance.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('84220966-8e2e-46c2-82e6-34a30400b3ef', '82dfc8e2-f097-4812-9dcd-1c75867e821e', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/prismatic_warmth_no1_black_frame-53x72_1e381d95-05bb-4288-8451-565ba92f8298.png?v=1713721152', 'prismatic-warmth Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('f671758d-9ec7-4dfc-a7e3-8ada98aca5f3', '82dfc8e2-f097-4812-9dcd-1c75867e821e', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/prismatic_warmth_no1_white_frame-53x72_dcb3f5f2-72e7-46db-beff-fae84ece83ee.png?v=1713721152', 'prismatic-warmth Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('029e1a4f-254a-453b-b154-af9d34da7e0b', '82dfc8e2-f097-4812-9dcd-1c75867e821e', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/prismatic_warmth_no1_no_frame-53x72_d9713d6b-2088-4b00-8610-72b2489addf4.png?v=1713721152', 'prismatic-warmth Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('aa18e4c1-0f0d-4594-aa37-c3fc1ead2b24', '82dfc8e2-f097-4812-9dcd-1c75867e821e', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/prismatic_warmth_no1_black_frame-36x48_26ed2a64-7fc7-42cb-a941-6cd0a654742b.png?v=1713721152', 'prismatic-warmth Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b8e3c099-9c1b-4f27-a3be-2074c9fa0661', '82dfc8e2-f097-4812-9dcd-1c75867e821e', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/prismatic_warmth_no1_white_frame-36x48_7bafea33-9503-449d-8cf7-36c1dbf3c687.png?v=1713721152', 'prismatic-warmth Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e752840e-d55b-44ad-b294-0f31c741a18b', '82dfc8e2-f097-4812-9dcd-1c75867e821e', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/prismatic_warmth_no1_no_frame-36x48_149ca0f6-7b52-4aee-b622-77154246fd43.png?v=1713721152', 'prismatic-warmth Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('2aea188f-f03f-46e9-9b3a-9e7c8c5c9bfb', '82dfc8e2-f097-4812-9dcd-1c75867e821e', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PRISMATIC-WARMTH-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('455d372a-4d68-49db-be82-431a53df1e82', '82dfc8e2-f097-4812-9dcd-1c75867e821e', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PRISMATIC-WARMTH-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('9d69b5ff-d156-4b09-950f-bfeb80e6e518', '82dfc8e2-f097-4812-9dcd-1c75867e821e', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PRISMATIC-WARMTH-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('40136757-f408-4a44-a769-d62c7d457a21', '82dfc8e2-f097-4812-9dcd-1c75867e821e', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PRISMATIC-WARMTH-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4936c5d0-53f0-4efa-bedd-0499b94fe30e', '82dfc8e2-f097-4812-9dcd-1c75867e821e', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PRISMATIC-WARMTH-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('dd472f74-bd31-4d7a-8b95-6c7d81142bf0', '82dfc8e2-f097-4812-9dcd-1c75867e821e', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PRISMATIC-WARMTH-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('a687e861-e538-4d51-b39d-446e7f39cdf6', 'crystalline-blue', 'Crystalline Blue', '"Crystalline Blue," a distinguished piece from the Geometric Intersect collection, masterfully synthesizes architectural precision with crystalline fluidity in this museum-quality limited edition. The artist''s sophisticated manipulation of overlapping geometric forms creates a compelling spatial dialogue, where deep cobalt blues intersect with carefully calibrated accents of amber, emerald, and magenta against pristine white negative space. This interplay of transparency and opacity, enhanced by a subtle canvas-like texture, evokes both the austere elegance of Constructivism and the harmonious balance of De Stijl, while maintaining a distinctly contemporary aesthetic. The composition''s dynamic arrangement of angular forms and parallelograms generates an immersive three-dimensional effect, with each intersection revealing new chromatic relationships reminiscent of fine mineral formations or modernist urban landscapes.', '51e253ef-6d6f-4ec0-bf91-7a87d251ac5e', 
        'VividWalls', 'Artwork',
        '{"Geometric Intersect"}', 'draft', 
        'Crystalline Blue 24x36 Gallery Wrapped Canvas', 
        '"Crystalline Blue," a distinguished piece from the Geometric Intersect collection, masterfully synthesizes architectural precision with crystalline fluidity in this museum-quality limited edition. The artist''s sophisticated manipulation of overlapping geometric forms creates a compelling spatial dialogue, where deep cobalt blues intersect with carefully calibrated accents of amber, emerald, and magenta against pristine white negative space. This interplay of transparency and opacity, enhanced by a subtle canvas-like texture, evokes both the austere elegance of Constructivism and the harmonious balance of De Stijl, while maintaining a distinctly contemporary aesthetic. The composition''s dynamic arrangement of angular forms and parallelograms generates an immersive three-dimensional effect, with each intersection revealing new chromatic relationships reminiscent of fine mineral formations or modernist urban landscapes.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('bbf345c4-79d5-4271-bc2a-062082b243fd', 'a687e861-e538-4d51-b39d-446e7f39cdf6', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/crystalline_blue_no1_black_frame-53x72_e175cffc-67dc-4230-af6f-fe5921269398.png?v=1713721125', 'crystalline-blue Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('76558bef-9779-426b-9945-3979af269d53', 'a687e861-e538-4d51-b39d-446e7f39cdf6', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/crystalline_blue_no1_white_frame-53x72_d8c04b5f-c742-423a-b23f-e4c33ad1e976.png?v=1713721125', 'crystalline-blue Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0e122ec8-a24c-4aba-ab8f-bbfe9bb3c77c', 'a687e861-e538-4d51-b39d-446e7f39cdf6', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/crystalline_blue_no1_no_frame-53x72_567c8ed7-322c-4910-8946-68d36a53b36b.png?v=1713721125', 'crystalline-blue Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('d2944a9d-a504-479e-b837-d4cee30e7c0e', 'a687e861-e538-4d51-b39d-446e7f39cdf6', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/crystalline_blue_no1_black_frame-36x48_4701862c-62cf-4720-a89c-74f259ffb58b.png?v=1713721125', 'crystalline-blue Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('7b252498-e8d3-47ed-b07e-123546c26c8d', 'a687e861-e538-4d51-b39d-446e7f39cdf6', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/crystalline_blue_no1_white_frame-36x48_b208be37-2c42-4d0b-b877-cf31a081c1c0.png?v=1713721125', 'crystalline-blue Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('c08bec24-90c2-421a-be6c-ed7fc008491b', 'a687e861-e538-4d51-b39d-446e7f39cdf6', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/crystalline_blue_no1_no_frame-36x48_d0db16ee-88ef-48a9-b877-a898d9d4c8d0.png?v=1713721125', 'crystalline-blue Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('1ae80e4a-b877-4ef3-9f58-bcb01a989edc', 'a687e861-e538-4d51-b39d-446e7f39cdf6', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'CRYSTALLINE-BLUE-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('6b797de1-79a2-4038-afb8-c4e2e991cbca', 'a687e861-e538-4d51-b39d-446e7f39cdf6', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'CRYSTALLINE-BLUE-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('9c7492be-c9c4-47ff-98e2-99a304072245', 'a687e861-e538-4d51-b39d-446e7f39cdf6', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'CRYSTALLINE-BLUE-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('77c45652-4188-44c8-bcbf-761b912c13d2', 'a687e861-e538-4d51-b39d-446e7f39cdf6', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'CRYSTALLINE-BLUE-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('09ecb91e-d185-4812-990d-898f093a2e7f', 'a687e861-e538-4d51-b39d-446e7f39cdf6', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'CRYSTALLINE-BLUE-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('51089463-1606-496c-b411-550ddd95a4be', 'a687e861-e538-4d51-b39d-446e7f39cdf6', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'CRYSTALLINE-BLUE-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('9ba4b267-63a0-4ac8-9dce-88b56bc13053', 'verdant-layers', 'Structured Emerald No3', '"Verdant Layers" stands as a masterful exploration of geometric abstraction, where translucent planes of green—ranging from vibrant lime to profound forest hues—intersect with pristine white forms to create a sophisticated dimensional dialogue. This limited edition piece from the acclaimed Vivid Layers collection demonstrates exceptional technical precision in its digital execution, enhanced by a carefully crafted textural overlay that lends a tactile warmth to its geometric precision. The artist''s virtuosic handling of transparency and overlap creates complex chromatic interactions, while a singular azure accent line introduces a subtle counterpoint to the verdant palette. Drawing from constructivist principles while embracing contemporary digital possibilities, the work achieves a remarkable synthesis between organic and architectural elements.', NULL, 
        'VividWalls', 'Artwork',
        '{"Structured"}', 'active', 
        'Structured Emerald No3 24x36 Gallery Wrapped Canvas', 
        '"Verdant Layers" stands as a masterful exploration of geometric abstraction, where translucent planes of green—ranging from vibrant lime to profound forest hues—intersect with pristine white forms to create a sophisticated dimensional dialogue. This limited edition piece from the acclaimed Vivid Layers collection demonstrates exceptional technical precision in its digital execution, enhanced by a carefully crafted textural overlay that lends a tactile warmth to its geometric precision. The artist''s virtuosic handling of transparency and overlap creates complex chromatic interactions, while a singular azure accent line introduces a subtle counterpoint to the verdant palette. Drawing from constructivist principles while embracing contemporary digital possibilities, the work achieves a remarkable synthesis between organic and architectural elements.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('38f37780-4c46-4c61-82f8-151971f2df12', '9ba4b267-63a0-4ac8-9dce-88b56bc13053', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/verdant_layers_no1_white_frame_53x72_f3d10b9c-5210-442e-8ee8-4fd749f2e0dd.png?v=1748638230', 'verdant-layers Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('67c7b632-072a-4012-81b1-86fb5e9a518a', '9ba4b267-63a0-4ac8-9dce-88b56bc13053', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/verdant_layers_no1_black_frame-24x36_dde544a3-2a50-4653-bdbc-e42721cc14c8.png?v=1748638230', 'verdant-layers Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('945bf983-1fc7-4da2-9870-aeea82567804', '9ba4b267-63a0-4ac8-9dce-88b56bc13053', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/verdant_layers_no1_no_frame-36x48_f73e4891-b38f-4a5b-b6f8-8465e199b1e4.png?v=1748638230', 'verdant-layers Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('c3f296ac-0639-4bd8-b938-058995ee55f7', '9ba4b267-63a0-4ac8-9dce-88b56bc13053', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/verdant_layers_no1_black_frame-53x72_d7e0ec18-ea52-4736-959f-6c4c642e1464.png?v=1748638230', 'verdant-layers Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0049b255-af62-4b50-a45d-a1cb7ce706cd', '9ba4b267-63a0-4ac8-9dce-88b56bc13053', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/verdant_layers_no1_no_frame_53x72_59d1adc8-3812-43b6-823b-4810f61cb4f8.png?v=1748637239', 'verdant-layers Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('00a42ea4-3a83-4af1-9179-2fdc9b9535c1', '9ba4b267-63a0-4ac8-9dce-88b56bc13053', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/verdant_layers_no1_black_frame-36x48_8aaa84a9-c5e6-4cd0-8512-cd46a3683429.png?v=1748637239', 'verdant-layers Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('716eeed9-401f-4da6-8f63-a303d164a47f', '9ba4b267-63a0-4ac8-9dce-88b56bc13053', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VERDANT-LAYERS-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('ea215e06-80a2-429b-b670-ebe444f61be1', '9ba4b267-63a0-4ac8-9dce-88b56bc13053', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VERDANT-LAYERS-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4cf51d6b-7a2c-41d8-8fad-da3d11ea6ea1', '9ba4b267-63a0-4ac8-9dce-88b56bc13053', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VERDANT-LAYERS-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('3f4b76a2-5cb9-4109-add4-e6b85770b4cf', '9ba4b267-63a0-4ac8-9dce-88b56bc13053', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VERDANT-LAYERS-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('5234b640-85f7-42a8-9ab5-7ee4f248e742', '9ba4b267-63a0-4ac8-9dce-88b56bc13053', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VERDANT-LAYERS-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('239835bc-f64e-47d1-8165-f9aa4d44ad90', '9ba4b267-63a0-4ac8-9dce-88b56bc13053', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VERDANT-LAYERS-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('c2160c31-bd90-44df-a053-85505aeefaca', 'parallelogram-illusion-no1', 'Parallelogram Illusion no1', 'From the celebrated Geometric Intersect collection, "Parallelogram Illusion no1" stands as a masterful exploration of perceptual art through sophisticated geometric abstraction. The artist orchestrates a mesmerizing interplay of transparent parallelograms and triangular forms, creating a dynamic composition that seems to pulse with dimensional energy. Deep purples and vibrant magentas cascade into rich burgundies, while strategic touches of forest green and amber provide counterpoint to the composition''s rhythmic flow. The work''s technical virtuosity is evident in its precise manipulation of overlapping transparencies, creating secondary chromatic harmonies that recall Josef Albers'' influential studies in color theory. Printed on museum-grade textured medium, the piece marries digital precision with organic materiality, achieving a contemporary aesthetic that remains warmly inviting.', '51e253ef-6d6f-4ec0-bf91-7a87d251ac5e', 
        'VividWalls', 'Artwork',
        '{"Geometric Intersect"}', 'active', 
        'Parallelogram Illusion no1 24x36 Gallery Wrapped Canvas', 
        'From the celebrated Geometric Intersect collection, "Parallelogram Illusion no1" stands as a masterful exploration of perceptual art through sophisticated geometric abstraction. The artist orchestrates a mesmerizing interplay of transparent parallelograms and triangular forms, creating a dynamic composition that seems to pulse with dimensional energy. Deep purples and vibrant magentas cascade into rich burgundies, while strategic touches of forest green and amber provide counterpoint to the composition''s rhythmic flow. The work''s technical virtuosity is evident in its precise manipulation of overlapping transparencies, creating secondary chromatic harmonies that recall Josef Albers'' influential studies in color theory. Printed on museum-grade textured medium, the piece marries digital precision with organic materiality, achieving a contemporary aesthetic that remains warmly inviting.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('ea5a81e3-1e82-43a5-8ad6-d51e7f629f7c', 'c2160c31-bd90-44df-a053-85505aeefaca', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/parallelogram_illusion_no1_black_frame-53x72_12507293-f954-404b-8543-3c46bc5a1cfe.png?v=1713721072', 'parallelogram-illusion-no1 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('73bd5c31-e969-4d05-aa54-d4706fd92ead', 'c2160c31-bd90-44df-a053-85505aeefaca', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/parallelogram_illusion_no1_white_frame-53x72_e3360573-c112-420f-9c79-42ee27e83dc8.png?v=1713721072', 'parallelogram-illusion-no1 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('af5d4254-4cc5-48db-9398-ba1cd9034fde', 'c2160c31-bd90-44df-a053-85505aeefaca', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/parallelogram_illusion_no1_no_frame-53x72_8d6bd394-456d-4a97-b54b-3a0796f821d8.png?v=1713721072', 'parallelogram-illusion-no1 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('d6bfb05a-91d1-418c-8fa9-9474a4df2bcb', 'c2160c31-bd90-44df-a053-85505aeefaca', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/parallelogram_illusion_no1_black_frame-36x48_88a7b478-7d97-4830-838b-b6a70090037a.png?v=1713721072', 'parallelogram-illusion-no1 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('50675da7-8fb5-4f7e-877e-20868e0be9d4', 'c2160c31-bd90-44df-a053-85505aeefaca', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/parallelogram_illusion_no1_white_frame-36x48_efe29d6c-0f18-4f6f-9f0b-b16e57eb9348.png?v=1713721072', 'parallelogram-illusion-no1 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('9c775e2a-39e1-4393-b32d-73fe7e6a33a3', 'c2160c31-bd90-44df-a053-85505aeefaca', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/parallelogram_illusion_no1_no_frame-36x48_8df2c4e9-a1df-469f-86bb-fd8f2b9a9a25.png?v=1713721072', 'parallelogram-illusion-no1 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b99842dd-b1ec-4d24-b611-7c4dbc2a2247', 'c2160c31-bd90-44df-a053-85505aeefaca', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PARALLELOGRAM-ILLUSION-NO1-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('132d1f34-6c5d-4c65-9e78-91457255a2a9', 'c2160c31-bd90-44df-a053-85505aeefaca', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PARALLELOGRAM-ILLUSION-NO1-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('395e78db-9fbf-4a00-95c2-09e7b655b020', 'c2160c31-bd90-44df-a053-85505aeefaca', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PARALLELOGRAM-ILLUSION-NO1-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('95914357-700c-41bd-9896-a52c72a3f882', 'c2160c31-bd90-44df-a053-85505aeefaca', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PARALLELOGRAM-ILLUSION-NO1-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4abd0169-42e3-4768-b762-bb3b417364d6', 'c2160c31-bd90-44df-a053-85505aeefaca', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PARALLELOGRAM-ILLUSION-NO1-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('a454830a-ea97-44cb-9466-31783f061b82', 'c2160c31-bd90-44df-a053-85505aeefaca', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PARALLELOGRAM-ILLUSION-NO1-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('6c7444d4-809d-470e-be0b-bd1bf928237a', 'parallelogram-illusion-no2', 'Parallelogram Illusion no2', 'In this striking limited edition work from the Geometric Symmetry collection, the artist masterfully orchestrates a sophisticated interplay of translucent parallelograms and triangular forms, creating a contemporary meditation on perception and mathematical precision. The composition''s deep emerald greens, vibrant magentas, and rich blues cascade through the picture plane with calculated elegance, while subtle peach tones provide harmonic counterpoint against pristine white negative spaces. Through masterful manipulation of transparency and overlay effects, the work achieves remarkable dimensional depth while maintaining modernist restraint. The artist''s technical virtuosity is evident in the precise color transitions and crystalline edge work, hallmarks of museum-quality geometric abstraction.', '51e253ef-6d6f-4ec0-bf91-7a87d251ac5e', 
        'VividWalls', 'Artwork',
        '{"Geometric Intersect"}', 'active', 
        'Parallelogram Illusion no2 24x36 Gallery Wrapped Canvas', 
        'In this striking limited edition work from the Geometric Symmetry collection, the artist masterfully orchestrates a sophisticated interplay of translucent parallelograms and triangular forms, creating a contemporary meditation on perception and mathematical precision. The composition''s deep emerald greens, vibrant magentas, and rich blues cascade through the picture plane with calculated elegance, while subtle peach tones provide harmonic counterpoint against pristine white negative spaces. Through masterful manipulation of transparency and overlay effects, the work achieves remarkable dimensional depth while maintaining modernist restraint. The artist''s technical virtuosity is evident in the precise color transitions and crystalline edge work, hallmarks of museum-quality geometric abstraction.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0484f5c7-cfde-49f5-b0a2-3b13effff306', '6c7444d4-809d-470e-be0b-bd1bf928237a', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/parallelogram_illusion_no2_black_frame-53x72_b36dea81-0c65-4258-a305-1e259d198652.png?v=1713721046', 'parallelogram-illusion-no2 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('7edb2d6a-2021-4378-a75d-7ee61db9001f', '6c7444d4-809d-470e-be0b-bd1bf928237a', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/parallelogram_illusion_no2_white_frame-53x72_9807d233-148b-40eb-a946-a29e8f9d7679.png?v=1713721046', 'parallelogram-illusion-no2  24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('c1188e88-c2b4-4ec8-bfd6-7a2795fc31ce', '6c7444d4-809d-470e-be0b-bd1bf928237a', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/parallelogram_illusion_no2_no_frame-53x72_c5dd045e-11cc-466d-908c-fd6f7d074229.png?v=1713721046', 'parallelogram-illusion-no2  36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b7278aa2-6e1a-472b-98bd-839314e113a0', '6c7444d4-809d-470e-be0b-bd1bf928237a', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/parallelogram_illusion_no2_black_frame-36x48_8ee73906-46a2-4aa5-8664-2d0bdfaf4e3e.png?v=1713721046', 'parallelogram-illusion-no2  36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('79b86269-4e94-4caa-b28b-35cf262fdc01', '6c7444d4-809d-470e-be0b-bd1bf928237a', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/parallelogram_illusion_no2_white_frame-36x48_c25a277d-f80c-4c4e-a1e7-f7e04d278dad.png?v=1713721046', 'parallelogram-illusion-no2  53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('17a57afd-e2e0-472e-8045-9e416ed16adc', '6c7444d4-809d-470e-be0b-bd1bf928237a', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/parallelogram_illusion_no2_no_frame-36x48_83acebf9-40c9-46d7-bc23-fad24614943d.png?v=1713721046', 'parallelogram-illusion-no2  53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('c4519659-3538-4b23-995e-a167b5cb2cc5', '6c7444d4-809d-470e-be0b-bd1bf928237a', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PARALLELOGRAM-ILLUSION-NO2-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('8398eda1-a954-478d-b54f-f7f92e3f1793', '6c7444d4-809d-470e-be0b-bd1bf928237a', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PARALLELOGRAM-ILLUSION-NO2-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('f02b87fa-ea14-46db-9190-f53e07d5a357', '6c7444d4-809d-470e-be0b-bd1bf928237a', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PARALLELOGRAM-ILLUSION-NO2-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('dc8fa15d-72f1-439d-b4fa-782a9b537b95', '6c7444d4-809d-470e-be0b-bd1bf928237a', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PARALLELOGRAM-ILLUSION-NO2-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b3a04626-9a3b-4d8c-b859-d07ed5509bb8', '6c7444d4-809d-470e-be0b-bd1bf928237a', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PARALLELOGRAM-ILLUSION-NO2-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('847acaa4-bed9-4143-ba3f-54b793836a16', '6c7444d4-809d-470e-be0b-bd1bf928237a', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PARALLELOGRAM-ILLUSION-NO2-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('8f2b88db-ad1f-4dee-bccb-b6a16a4a9650', 'earthy-weave', 'Earthy Weave', 'Earthy Weavefrom the Vivid Layerscollection is a harmonious blend of nature-inspired tones and geometric precision. This piece artfully combines the organic palette of earthy browns, forest greens, and deep blues with the structured clarity of geometric shapes. The overlapping and intertwining of the shapes create a sense of woven fabric, meticulously crafted from the natural colors of the earth. The play of light and shadow within the colors adds a dynamic quality, suggesting depth and movement, making "Earthy Weave" a sophisticated visual experience that encapsulates both the randomness and the order found in nature.', '2baf353b-2933-4817-8050-f33735ede775', 
        'VividWalls', 'Artwork',
        '{"Vivid Layers"}', 'active', 
        'Earthy Weave 24x36 Gallery Wrapped Canvas', 
        'Earthy Weavefrom the Vivid Layerscollection is a harmonious blend of nature-inspired tones and geometric precision. This piece artfully combines the organic palette of earthy browns, forest greens, and deep blues with the structured clarity of geometric shapes. The overlapping and intertwining of the shapes create a sense of woven fabric, meticulously crafted from the natural colors of the earth. The play of light and shadow within the colors adds a dynamic quality, suggesting depth and movement, making "Earthy Weave" a sophisticated visual experience that encapsulates both the randomness and the order found in nature.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('273764db-836e-4424-b6b1-c1a7c96b68a1', '8f2b88db-ad1f-4dee-bccb-b6a16a4a9650', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_weave_no3_black_frame-53x72_41f4ea02-8ad9-4bba-b1f1-f0721bd9f73e.png?v=1713720992', 'earthy-weave Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0603e686-5dab-4ead-a0ec-251902279a2c', '8f2b88db-ad1f-4dee-bccb-b6a16a4a9650', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_weave_no3_white_frame-53x72_28764ec4-e703-4b27-a00d-6dce62e2ca71.png?v=1713720992', 'earthy-weave Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('21ad84ef-720b-4b8b-9bd7-f582518e27ac', '8f2b88db-ad1f-4dee-bccb-b6a16a4a9650', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_weave_no3_no_frame-53x72_a3b3c0fd-64ec-4b09-985d-504c940645c1.png?v=1713720992', 'earthy-weave Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('9ec05ea9-e051-4d88-b7b2-8d93b72f2d1a', '8f2b88db-ad1f-4dee-bccb-b6a16a4a9650', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_weave_no3_black_frame-36x48_f6394df7-a23e-4140-b5ca-d71d74736fb2.png?v=1713720993', 'earthy-weave Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('3402b22c-7a8f-47e7-8524-318e5c49bdab', '8f2b88db-ad1f-4dee-bccb-b6a16a4a9650', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_weave_no3_white_frame-36x48_c1789a42-3602-4f75-b371-554c2c5f8cf0.png?v=1713720993', 'earthy-weave Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('444008c9-6234-4e3f-a74c-c1c876ea15d6', '8f2b88db-ad1f-4dee-bccb-b6a16a4a9650', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/earthy_weave_no3_black_frame-24x36_aa799a12-0ee0-4f2a-a6ec-8178401e42d3.png?v=1713720993', 'earthy-weave Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('15f9fd01-6a4d-4729-bb13-11381c510ea0', '8f2b88db-ad1f-4dee-bccb-b6a16a4a9650', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EARTHY-WEAVE-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('45cfa358-9b4c-48ec-aff2-f212120a32f1', '8f2b88db-ad1f-4dee-bccb-b6a16a4a9650', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EARTHY-WEAVE-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('32715f6d-8058-48a9-831e-71ddfa995b93', '8f2b88db-ad1f-4dee-bccb-b6a16a4a9650', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EARTHY-WEAVE-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('03c76140-1281-441e-a36d-6db8aebcad3c', '8f2b88db-ad1f-4dee-bccb-b6a16a4a9650', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EARTHY-WEAVE-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('0dd5a23c-5314-4574-bc73-28ef6e728591', '8f2b88db-ad1f-4dee-bccb-b6a16a4a9650', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'EARTHY-WEAVE-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('cf3ced0c-037b-43a0-9afb-df5cc38b1c6f', '8f2b88db-ad1f-4dee-bccb-b6a16a4a9650', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'EARTHY-WEAVE-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('3403a72a-d28e-4810-8e80-9ab44d4e514b', 'olive-weave', 'Olive Weave', '"Olive Weave," a distinguished piece from the Vivid Layers collection, masterfully orchestrates geometric abstraction through an sophisticated interplay of translucent planes and carefully calibrated color harmonies. The artist''s command of spatial dynamics manifests in overlapping parallelograms and angular forms, creating a compelling dimensional depth that both challenges and rewards sustained contemplation. The refined palette of olive greens, slate grays, and deep purples, accented with cool teals, demonstrates an exceptional sensitivity to color relationships, while the strategic incorporation of negative space lends the composition its sophisticated breathing room. This museum-quality limited edition achieves a remarkable synthesis between digital precision and organic texture, with the canvas substrate introducing a tactile quality that enriches the geometric abstraction.', '2baf353b-2933-4817-8050-f33735ede775', 
        'VividWalls', 'Artwork',
        '{"Vivid Layers"}', 'active', 
        'Olive Weave 24x36 Gallery Wrapped Canvas', 
        '"Olive Weave," a distinguished piece from the Vivid Layers collection, masterfully orchestrates geometric abstraction through an sophisticated interplay of translucent planes and carefully calibrated color harmonies. The artist''s command of spatial dynamics manifests in overlapping parallelograms and angular forms, creating a compelling dimensional depth that both challenges and rewards sustained contemplation. The refined palette of olive greens, slate grays, and deep purples, accented with cool teals, demonstrates an exceptional sensitivity to color relationships, while the strategic incorporation of negative space lends the composition its sophisticated breathing room. This museum-quality limited edition achieves a remarkable synthesis between digital precision and organic texture, with the canvas substrate introducing a tactile quality that enriches the geometric abstraction.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('a86ff376-0610-4668-b7f1-80ee781e5ef9', '3403a72a-d28e-4810-8e80-9ab44d4e514b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid-geometric_intersection-no14-BlkFrame-48x72_f1871f0f-b59c-4866-bfb0-f3ac79f9736e.png?v=1713720965', 'olive-weave Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('489965ad-3357-4e9d-8085-efa9a602753f', '3403a72a-d28e-4810-8e80-9ab44d4e514b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid-geometric_intersection-no14-WhtFrame-48x72_56eaa432-c686-44b5-be13-69442178935c.png?v=1713720965', 'olive-weave Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('1983895f-1bc7-45b0-918e-6f967a48bf15', '3403a72a-d28e-4810-8e80-9ab44d4e514b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid-geometric_intersection-no14-NOFrame-48x72_6e241c60-6d55-45ab-9b0b-b5f542f5a206.png?v=1713720965', 'olive-weave Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('23745c72-0a7c-485c-8131-de6f006d9b18', '3403a72a-d28e-4810-8e80-9ab44d4e514b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/olive_weave_no2_black_frame-36x48_f74d00ef-456b-480a-bb2d-651556021be7.png?v=1713720965', 'olive-weave Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('cadaead1-964a-413a-861f-c7b9315fa2ea', '3403a72a-d28e-4810-8e80-9ab44d4e514b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/olive_weave_no2_white_frame-36x48_477332f3-c3bc-4f2b-adf6-feb9f044d6e5.png?v=1713720965', 'olive-weave Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('7c228ec4-78aa-43fa-a433-4070906414ab', '3403a72a-d28e-4810-8e80-9ab44d4e514b', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/olive_weave_no2_no_frame-36x48_c51abdc4-a578-445f-856c-0ff52d5d6ebe.png?v=1713720965', 'olive-weave Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('5f963eda-f616-4485-8870-ae53121b8e5d', '3403a72a-d28e-4810-8e80-9ab44d4e514b', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'OLIVE-WEAVE-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('3b7f1b5f-6572-4f66-9f7c-2ddc70838c2d', '3403a72a-d28e-4810-8e80-9ab44d4e514b', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'OLIVE-WEAVE-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('663c4b6d-75a0-44e2-b34a-96941492c407', '3403a72a-d28e-4810-8e80-9ab44d4e514b', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'OLIVE-WEAVE-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('a393fc78-6df9-48af-9124-b156958c4dd8', '3403a72a-d28e-4810-8e80-9ab44d4e514b', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'OLIVE-WEAVE-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4dda584f-1e4c-48c6-a863-1c3263a93f7c', '3403a72a-d28e-4810-8e80-9ab44d4e514b', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'OLIVE-WEAVE-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('ade3b2e1-4f07-41f9-95dd-b97986cb7caa', '3403a72a-d28e-4810-8e80-9ab44d4e514b', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'OLIVE-WEAVE-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('f0f902e8-4001-498b-aae8-9a71879c1125', 'pink-weave', 'Pink Weave', 'From the distinguished Vivid Layers collection, "Pink Weave" stands as a masterful exploration of geometric abstraction, where precision meets ethereal transparency. The artist''s sophisticated manipulation of overlapping rectangular and parallelogram forms creates a compelling vertical rhythm, while the carefully calibrated palette—featuring deep burgundies, vibrant pinks, and forest greens—generates remarkable spatial depth through intentional color interactions. The composition''s architectural precision is softened by the subtle textural qualities of the substrate, lending a tactile dimension that enriches the viewing experience. Drawing inspiration from both Constructivist principles and Color Field painting, this contemporary limited edition piece demonstrates exceptional technical refinement in its perfect color gradients and precise geometric intersections.', '2baf353b-2933-4817-8050-f33735ede775', 
        'VividWalls', 'Artwork',
        '{"Vivid Layers"}', 'active', 
        'Pink Weave 24x36 Gallery Wrapped Canvas', 
        'From the distinguished Vivid Layers collection, "Pink Weave" stands as a masterful exploration of geometric abstraction, where precision meets ethereal transparency. The artist''s sophisticated manipulation of overlapping rectangular and parallelogram forms creates a compelling vertical rhythm, while the carefully calibrated palette—featuring deep burgundies, vibrant pinks, and forest greens—generates remarkable spatial depth through intentional color interactions. The composition''s architectural precision is softened by the subtle textural qualities of the substrate, lending a tactile dimension that enriches the viewing experience. Drawing inspiration from both Constructivist principles and Color Field painting, this contemporary limited edition piece demonstrates exceptional technical refinement in its perfect color gradients and precise geometric intersections.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('51f62238-9fbe-4236-bdb6-728452f8ac20', 'f0f902e8-4001-498b-aae8-9a71879c1125', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid-geometric_intersection-no8-BlkFrame-48x72_2fd71d10-3b30-4a03-863f-a274567af639.png?v=1713720939', 'pink-weave Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('317a560e-144d-4f55-a820-4e25e8d4479e', 'f0f902e8-4001-498b-aae8-9a71879c1125', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid-geometric_intersection-no8-WhtFrame-48x72_5f99b4e8-a212-4b9b-adeb-77be27dcd63e.png?v=1713720939', 'pink-weave Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('d831d2ed-4d6e-47bf-b7f2-576c5a7f10b9', 'f0f902e8-4001-498b-aae8-9a71879c1125', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid-geometric_intersection-no8-NoFrame-48x72_65f645fa-bd7c-4b15-8d97-d379eb46f2c3.png?v=1713720939', 'pink-weave Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b7508925-01a8-44b9-9858-f38f09a4e3fb', 'f0f902e8-4001-498b-aae8-9a71879c1125', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/pink_weave_no1_black_frame-36x48_8bacc043-25cb-4f71-99f8-0fcc0c54c7e1.png?v=1713720939', 'pink-weave Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('ebdfce4b-ddfc-4131-9888-5c91f1a6bc6a', 'f0f902e8-4001-498b-aae8-9a71879c1125', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/pink_weave_no1_white_frame-36x48_160e4794-b03e-43a5-b1ff-08f87f7577ae.png?v=1713720939', 'pink-weave Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0e4c7e1d-b118-467a-8263-114f54526c50', 'f0f902e8-4001-498b-aae8-9a71879c1125', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/pink_weave_no1_no_frame-36x48_d008e822-4eca-4810-a7e1-437685224508.png?v=1713720939', 'pink-weave Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4b38b05f-4349-43be-bf81-4a84a0e0998a', 'f0f902e8-4001-498b-aae8-9a71879c1125', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PINK-WEAVE-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('42d38d40-37d3-466c-a1b1-c31500f9019b', 'f0f902e8-4001-498b-aae8-9a71879c1125', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PINK-WEAVE-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('6185c500-0981-4075-b7d2-26472962b08a', 'f0f902e8-4001-498b-aae8-9a71879c1125', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PINK-WEAVE-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('addbb5e0-88c8-4938-bac5-985fe8314685', 'f0f902e8-4001-498b-aae8-9a71879c1125', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PINK-WEAVE-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('42ff18f9-3c24-49b8-b842-9be3a49c0484', 'f0f902e8-4001-498b-aae8-9a71879c1125', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'PINK-WEAVE-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b9b5ed87-18f5-48e4-bfd3-ebbaca21939d', 'f0f902e8-4001-498b-aae8-9a71879c1125', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'PINK-WEAVE-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('af18e87f-fbe7-4742-97ec-c2c2db9792fc', 'vivid-mosaic-no1', 'Vivid Mosaic no1', 'In this striking limited edition piece from the Mosaic collection, geometric abstraction reaches new heights through a masterful interplay of transparent polygonal forms. The composition''s sophisticated architecture reveals itself through overlapping crystalline shapes that cascade diagonally across a richly textured canvas, creating an entrancing dimensional space that beckons closer inspection. Deep purples and burgundies dominate the palette, while strategic accents of pink and golden yellow provide ethereal counterpoints, demonstrating exceptional control over opacity and chromatic harmony. The artist''s technical virtuosity is evident in the precise execution of transparency effects, where intersecting forms generate complex color interactions and spatial relationships that pay homage to Constructivist principles while embracing contemporary digital innovation.', NULL, 
        'VividWalls', 'Artwork',
        '{"Mosaic"}', 'active', 
        'Vivid Mosaic no1 24x36 Gallery Wrapped Canvas', 
        'In this striking limited edition piece from the Mosaic collection, geometric abstraction reaches new heights through a masterful interplay of transparent polygonal forms. The composition''s sophisticated architecture reveals itself through overlapping crystalline shapes that cascade diagonally across a richly textured canvas, creating an entrancing dimensional space that beckons closer inspection. Deep purples and burgundies dominate the palette, while strategic accents of pink and golden yellow provide ethereal counterpoints, demonstrating exceptional control over opacity and chromatic harmony. The artist''s technical virtuosity is evident in the precise execution of transparency effects, where intersecting forms generate complex color interactions and spatial relationships that pay homage to Constructivist principles while embracing contemporary digital innovation.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('ea0d9e36-d557-4a90-b387-67554a8a85ab', 'af18e87f-fbe7-4742-97ec-c2c2db9792fc', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no1_canvas-black_frame_48x72_989f0af1-7bb9-4037-a0b6-6092ee7c598a.png?v=1713721743', 'vivid-mosaic-no1 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('561f9fb3-ddaa-4f3a-88ac-2153e5597990', 'af18e87f-fbe7-4742-97ec-c2c2db9792fc', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no1_canvas-white_frame_48x72_d022fd66-615c-4a40-bc5d-ee97a15fc798.png?v=1713721743', 'vivid-mosaic-no1 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0c02a98d-7402-4f9d-934f-312d00a3dfd5', 'af18e87f-fbe7-4742-97ec-c2c2db9792fc', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no1_canvas-no_frame_48x72_3fb9f9fe-1be1-4b3a-9fcb-2fc9d934b364.png?v=1713721743', 'vivid-mosaic-no1 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b16e7354-4db7-4159-bf67-6aa5d0e198fd', 'af18e87f-fbe7-4742-97ec-c2c2db9792fc', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no1-black_frame_36x48_d6a2441f-c422-4d5b-89ac-58e306a366be.png?v=1713721743', 'vivid-mosaic-no1 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('63ecbc19-b520-4609-8753-e9929fd37ac1', 'af18e87f-fbe7-4742-97ec-c2c2db9792fc', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no1-white_frame_36x48_755aa7aa-e256-4e09-b006-ef00481cc513.png?v=1713721743', 'vivid-mosaic-no1 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('3118287b-fd72-4e19-8b6e-2d1604201399', 'af18e87f-fbe7-4742-97ec-c2c2db9792fc', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no1-no_frame_36x48_61881bb8-3143-4885-b1ed-21aba9b99924.png?v=1713721743', 'vivid-mosaic-no1 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('52927e74-2eb8-4d65-bb71-6eebcc56c827', 'af18e87f-fbe7-4742-97ec-c2c2db9792fc', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('52af1a43-2292-49f4-90f5-dc531c1dfe4a', 'af18e87f-fbe7-4742-97ec-c2c2db9792fc', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO1-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('3a2a5d57-4764-4c51-b4ab-92c360421d5c', 'af18e87f-fbe7-4742-97ec-c2c2db9792fc', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('09959e63-f1fd-4794-b65d-5556b53609b2', 'af18e87f-fbe7-4742-97ec-c2c2db9792fc', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO1-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('64f10ba5-77a9-4195-9554-693449c82769', 'af18e87f-fbe7-4742-97ec-c2c2db9792fc', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('70035149-b1cd-49cb-b4be-634aa68f8cea', 'af18e87f-fbe7-4742-97ec-c2c2db9792fc', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO1-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('b5f10418-881b-4884-bdd0-ecc3651c6691', 'vivid-mosaic-no2', 'Vivid Mosaic no2', 'In this striking limited edition from the Mosaic collection, geometric abstraction achieves new heights through masterful digital articulation and chromatic sophistication. The composition orchestrates a mesmerizing interplay of translucent forms, where deep navy, turquoise, and royal blue harmonize with strategic bursts of magenta and forest green. The artist''s revolutionary approach to spatial dynamics manifests in precisely layered triangular and rectangular elements, creating an architectural depth that draws viewers into its dimensional complexities. A subtle canvas texture underlies the digital precision, lending tactile warmth to the piece''s contemporary aesthetic. The work''s constructivist influences merge seamlessly with modern digital techniques, while maintaining the organic quality that distinguishes truly exceptional abstract art. Where transparent shapes intersect, new colors emerge in a sophisticated dialogue between form and chromatic interaction.', NULL, 
        'VividWalls', 'Artwork',
        '{"Mosaic"}', 'active', 
        'Vivid Mosaic no2 24x36 Gallery Wrapped Canvas', 
        'In this striking limited edition from the Mosaic collection, geometric abstraction achieves new heights through masterful digital articulation and chromatic sophistication. The composition orchestrates a mesmerizing interplay of translucent forms, where deep navy, turquoise, and royal blue harmonize with strategic bursts of magenta and forest green. The artist''s revolutionary approach to spatial dynamics manifests in precisely layered triangular and rectangular elements, creating an architectural depth that draws viewers into its dimensional complexities. A subtle canvas texture underlies the digital precision, lending tactile warmth to the piece''s contemporary aesthetic. The work''s constructivist influences merge seamlessly with modern digital techniques, while maintaining the organic quality that distinguishes truly exceptional abstract art. Where transparent shapes intersect, new colors emerge in a sophisticated dialogue between form and chromatic interaction.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('951a0c7a-5dad-45ff-a1dd-430fd70b8ae2', 'b5f10418-881b-4884-bdd0-ecc3651c6691', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/ColorEmergance-_002-1000x1000_03ed66b6-6597-4f24-87a1-8bd682dadcc6.png?v=1713721718', 'vivid-mosaic-no2 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('5f5d6490-5d95-4d39-a855-3f4cc8cf3064', 'b5f10418-881b-4884-bdd0-ecc3651c6691', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no2_canvas-white_frame_48x72_af3bde2a-c41a-4986-8f1f-7e8b3334b95c.png?v=1713721718', 'vivid-mosaic-no2 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('a199c347-3123-4ce3-bf7d-da9dd6d7d89c', 'b5f10418-881b-4884-bdd0-ecc3651c6691', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no2_canvas-noframe_48x72_603b49ee-796c-4102-bb4d-fa023302833e.png?v=1713721718', 'vivid-mosaic-no2 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('fc4fcce2-d874-42f5-8d78-428373fb2450', 'b5f10418-881b-4884-bdd0-ecc3651c6691', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no5_canvas-black_frame_36x48_74571e47-2ba0-4352-8a5c-38f97bf9ef6e.png?v=1713721718', 'vivid-mosaic-no2 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('05ed01f3-c763-455c-988b-0c0b599a1436', 'b5f10418-881b-4884-bdd0-ecc3651c6691', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no5_canvas-white_frame_36x48_4dfbd529-0594-4545-9f84-52258a650230.png?v=1713721718', 'vivid-mosaic-no2 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('bff217c5-34a8-4c00-a6e7-9863e4d865a4', 'b5f10418-881b-4884-bdd0-ecc3651c6691', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no5_canvas-No_frame_36x48_77aa4b92-a642-481c-a689-71df63de4388.png?v=1713721718', 'vivid-mosaic-no2 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('7b43c3fd-f2c5-4c9a-aabd-d8b6f86cf0ef', 'b5f10418-881b-4884-bdd0-ecc3651c6691', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('78d2b343-af36-404c-9cd0-fcf80e6f12d9', 'b5f10418-881b-4884-bdd0-ecc3651c6691', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO2-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('22c1570f-e7f5-4f10-9990-8fcf6c3b965e', 'b5f10418-881b-4884-bdd0-ecc3651c6691', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('53e884c4-e18c-48d2-8df4-7295e37b69cd', 'b5f10418-881b-4884-bdd0-ecc3651c6691', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO2-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('3df703b7-a78a-416c-aa94-e9ab44b7c1cb', 'b5f10418-881b-4884-bdd0-ecc3651c6691', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('40ad25a8-fca2-472b-b3b0-1d116114866f', 'b5f10418-881b-4884-bdd0-ecc3651c6691', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO2-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('80b17c6b-de3e-4298-ba92-ec065419ee85', 'vivid-mosaic-no3', 'Vivid Mosaic no3', 'Vivid Mosaic No.3from the Mosaiccollection by the artist is a striking piece that showcases the vivid interplay of color and form. The artist creates a sense of dynamic movement through the overlapping geometric shapes, which seem to advance and recede, playing with the viewer''s perception of space. The rich, saturated blues, purples, and reds create a visual vibrato that is at once bold and harmonious. These colors are softened by the textured backdrop that mimics the granularity of a traditional mosaic, lending an organic feel to the digital medium. ''Vivid Mosaic No.3'' is a testament to the artist''s skill in fusing traditional mosaic aesthetics with contemporary digital techniques. The result is a captivating digital canvas that resonates with energy, complexity, and a modern sensibility.', NULL, 
        'VividWalls', 'Artwork',
        '{"Mosaic"}', 'active', 
        'Vivid Mosaic no3 24x36 Gallery Wrapped Canvas', 
        'Vivid Mosaic No.3from the Mosaiccollection by the artist is a striking piece that showcases the vivid interplay of color and form. The artist creates a sense of dynamic movement through the overlapping geometric shapes, which seem to advance and recede, playing with the viewer''s perception of space. The rich, saturated blues, purples, and reds create a visual vibrato that is at once bold and harmonious. These colors are softened by the textured backdrop that mimics the granularity of a traditional mosaic, lending an organic feel to the digital medium. ''Vivid Mosaic No.3'' is a testament to the artist''s skill in fusing traditional mosaic aesthetics with contemporary digital techniques. The result is a captivating digital canvas that resonates with energy, complexity, and a modern sensibility.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('1bdaa234-faa2-4ca0-9beb-9753fd082803', '80b17c6b-de3e-4298-ba92-ec065419ee85', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no3_canvas_black_frame_53x72_bfd8a4cb-6fe1-40a7-a36f-d3fba2c8a0e1.png?v=1713721697', 'vivid-mosaic-no3 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('84d16405-c1c9-4a22-b544-bfc9072b3940', '80b17c6b-de3e-4298-ba92-ec065419ee85', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no3_canvas_white_frame_53x72_e0bf231e-19cc-4ac5-bff2-ca6eafdb37d4.png?v=1713721697', 'vivid-mosaic-no3 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('9b4f3ce7-86d3-4e5e-be3e-4d0028a1a5a8', '80b17c6b-de3e-4298-ba92-ec065419ee85', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no3_canvas_no_frame_53x72_d3440792-d972-4643-85f9-54c968425ad6.png?v=1713721697', 'vivid-mosaic-no3 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('522f5092-dba0-4026-866e-6d82ad3bb221', '80b17c6b-de3e-4298-ba92-ec065419ee85', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no3_canvas-black_frame_36x48_1759caa5-e301-4ec2-95a8-3271c4fa20aa.png?v=1713721697', 'vivid-mosaic-no3 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('61fbe99d-362f-428f-bb24-5030c43e8073', '80b17c6b-de3e-4298-ba92-ec065419ee85', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no3_canvas-white_frame_36x48_46b7a3c2-127f-4d4b-895e-d4bf97c5ed8f.png?v=1713721697', 'vivid-mosaic-no3 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e4ba6825-0174-4c00-9d2b-13f958d436b7', '80b17c6b-de3e-4298-ba92-ec065419ee85', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no3_canvas-no_frame_36x48_bf0e4174-96dc-49c8-af42-f358bc1d13ef.png?v=1713721697', 'vivid-mosaic-no3 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('7a8cde99-17c7-4d18-8f7c-b085890ddad4', '80b17c6b-de3e-4298-ba92-ec065419ee85', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('e24cc90b-e938-453e-bc46-946e988ba862', '80b17c6b-de3e-4298-ba92-ec065419ee85', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO3-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('aca5dd99-9c3f-4a95-ab0d-71fd66288d70', '80b17c6b-de3e-4298-ba92-ec065419ee85', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('11ecf2b5-9be1-4c91-816f-0361bde1107a', '80b17c6b-de3e-4298-ba92-ec065419ee85', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO3-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b7e38013-6de0-48da-aa8f-e23d866c1938', '80b17c6b-de3e-4298-ba92-ec065419ee85', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('8f163e5d-75f4-4e9b-912a-3a6aded4b011', '80b17c6b-de3e-4298-ba92-ec065419ee85', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO3-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('d8e33aa3-d771-4485-a73f-598bbe51ffb7', 'vivid-mosaic-no4', 'Vivid Mosaic no4', 'In this stunning addition to the Mosaic collection, geometric abstraction reaches new heights of sophistication through masterfully layered translucent forms. The composition presents a crystalline architecture of intersecting planes, where deep navy blues and vibrant turquoise harmonize with olive greens and delicate pink accents, creating an intricate dance of color and light. The artist''s command of digital techniques yields museum-quality precision, with each element perfectly positioned to suggest three-dimensional depth while maintaining the work''s contemporary minimalist aesthetic. The textured background provides a tactile counterpoint to the crisp geometric overlays, while sophisticated transparency effects evoke the luminosity of stained glass. Drawing inspiration from both Constructivism and Digital Minimalism, this limited edition piece demonstrates remarkable technical virtuosity in its execution.', NULL, 
        'VividWalls', 'Artwork',
        '{"Mosaic"}', 'active', 
        'Vivid Mosaic no4 53x72 Gallery Wrapped Canvas', 
        'In this stunning addition to the Mosaic collection, geometric abstraction reaches new heights of sophistication through masterfully layered translucent forms. The composition presents a crystalline architecture of intersecting planes, where deep navy blues and vibrant turquoise harmonize with olive greens and delicate pink accents, creating an intricate dance of color and light. The artist''s command of digital techniques yields museum-quality precision, with each element perfectly positioned to suggest three-dimensional depth while maintaining the work''s contemporary minimalist aesthetic. The textured background provides a tactile counterpoint to the crisp geometric overlays, while sophisticated transparency effects evoke the luminosity of stained glass. Drawing inspiration from both Constructivism and Digital Minimalism, this limited edition piece demonstrates remarkable technical virtuosity in its execution.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('6b406b47-eb8e-40a6-82d1-70e0b9ac6860', 'd8e33aa3-d771-4485-a73f-598bbe51ffb7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no4_canvas-black_frame_48x72_3631ecb2-d10b-4fd5-b12f-731abeeac2f9.png?v=1713721667', 'vivid-mosaic-no4 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('d2dfd908-eae8-4cc0-b97b-048b73221cf5', 'd8e33aa3-d771-4485-a73f-598bbe51ffb7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no4_canvas-no_frame_48x72_f21e4433-2ea1-479f-99d3-39379475d7d9.png?v=1713721667', 'vivid-mosaic-no4 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('906c2c88-c8ce-4156-8645-613a325be0e6', 'd8e33aa3-d771-4485-a73f-598bbe51ffb7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no4_canvas-white_frame_48x72_ddaefc61-1983-4ecf-bf44-1f514192dfa4.png?v=1713721667', 'vivid-mosaic-no4 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('63fe07e7-17eb-424e-bcae-24bfaf0e1167', 'd8e33aa3-d771-4485-a73f-598bbe51ffb7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no4_canvas-white_frame_36x48_e02e6de4-aa70-4008-8916-6c84c8a5a2f4.png?v=1713721667', 'vivid-mosaic-no4 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('17d0e06d-6ffd-47b7-9f97-15c1fffe3f7c', 'd8e33aa3-d771-4485-a73f-598bbe51ffb7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no4_canvas-black_frame_36x48_9744919c-4b7c-48b3-ab68-37fe7b4c2e6e.png?v=1713721667', 'vivid-mosaic-no4 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('9c3cd7d1-c27c-4301-9854-f87449eb987f', 'd8e33aa3-d771-4485-a73f-598bbe51ffb7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no4_canvas-no_frame_36x48_73fbfbcb-24d3-491d-8ec7-b70efaadf483.png?v=1713721667', 'vivid-mosaic-no4 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('2d771c92-7330-45b2-810b-afc0b9747100', 'd8e33aa3-d771-4485-a73f-598bbe51ffb7', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO4-GALLERY-WRAPPED-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('7ab157ac-74bc-47a9-8cde-5d3ae9f9faf3', 'd8e33aa3-d771-4485-a73f-598bbe51ffb7', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO4-GALLERY-WRAPPED-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('c7e7aebd-da94-4a7d-a7dd-b9405a548619', 'd8e33aa3-d771-4485-a73f-598bbe51ffb7', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO4-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('7505a52e-40be-4baa-8b34-3e3ac982d7bb', 'd8e33aa3-d771-4485-a73f-598bbe51ffb7', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO4-GALLERY-WRAPPED-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('909f8b6a-1ce6-4562-9741-4a114e088a00', 'd8e33aa3-d771-4485-a73f-598bbe51ffb7', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO4-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('502825fd-2611-4ef6-8bf3-bf9c99c862c8', 'd8e33aa3-d771-4485-a73f-598bbe51ffb7', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO4-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('cc34461b-90b5-4344-82e4-527862319718', 'vivid-mosaic-no7', 'Vivid Mosaic no7', 'Vivid Mosaic no7from the Mosaiccollection is an abstract artwork full of vitality and color. It displays a complex overlay of geometric shapes in a diverse color palette, including deep blues, rich browns, and vibrant splashes of pink, teal, and yellow. The shapes seem to interlock and layer over each other, giving the piece a textured and multidimensional appearance. This artwork brings together the structured order of geometric forms with the free-spirited essence of vivid colors, making it an eye-catching addition to any space.', NULL, 
        'VividWalls', 'Artwork',
        '{"Mosaic"}', 'active', 
        'Vivid Mosaic no7 24x36 Gallery Wrapped Canvas', 
        'Vivid Mosaic no7from the Mosaiccollection is an abstract artwork full of vitality and color. It displays a complex overlay of geometric shapes in a diverse color palette, including deep blues, rich browns, and vibrant splashes of pink, teal, and yellow. The shapes seem to interlock and layer over each other, giving the piece a textured and multidimensional appearance. This artwork brings together the structured order of geometric forms with the free-spirited essence of vivid colors, making it an eye-catching addition to any space.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('22cca1c6-2f9c-41b8-9094-1f49557650fa', 'cc34461b-90b5-4344-82e4-527862319718', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Vivid_Mosaic_no0_Black_frame_53x72_4a734b72-fb7c-4cf5-b079-bc4b7fc1d286.png?v=1713721642', 'vivid-mosaic-no7 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('9d7e7937-0e43-481d-a0ec-5283ebe6f5ad', 'cc34461b-90b5-4344-82e4-527862319718', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Vivid_Mosaic_no0_white_frame_53x72_6dcbe6d9-a0bc-4320-96b7-ce59d5bd986c.png?v=1713721642', 'vivid-mosaic-no7 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('45872904-53b2-4b5b-8ee9-e01748d20724', 'cc34461b-90b5-4344-82e4-527862319718', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Vivid_Mosaic_no0_No_Frame_53x72_5d574ee9-1dfe-4eca-9118-9a51ce9a3be5.png?v=1713721642', 'vivid-mosaic-no7 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('31ba375d-82c7-40ae-bd58-1cddac93e680', 'cc34461b-90b5-4344-82e4-527862319718', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Vivid_Mosaic_no0_Black_Frame_36x48_aa033fe8-15cd-41be-b4fa-9079fa7481f8.png?v=1713721642', 'vivid-mosaic-no7 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e0f31523-260f-49cd-8d35-a6c89458969d', 'cc34461b-90b5-4344-82e4-527862319718', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Vivid_Mosaic_no0_white_frame_36x48_10a4e48e-4530-48d3-a5ba-eb4fa73273ca.png?v=1713721642', 'vivid-mosaic-no7 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e23eb9c7-d228-4218-aea7-ff970263a432', 'cc34461b-90b5-4344-82e4-527862319718', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Vivid_Mosaic_no0_No_frame_36x48_67566827-80fc-4d08-be47-123fb09219e0.png?v=1713721642', 'vivid-mosaic-no7 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('ffba6bb2-e1be-4c81-84ea-37d4f3f6863e', 'cc34461b-90b5-4344-82e4-527862319718', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO7-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('95e87197-2195-4f96-a321-718b42bbc1f9', 'cc34461b-90b5-4344-82e4-527862319718', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO7-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('f7e45481-5e83-475a-ad99-09dd82099339', 'cc34461b-90b5-4344-82e4-527862319718', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO7-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('d5f12397-7c14-4cf7-970d-2cf677b08a19', 'cc34461b-90b5-4344-82e4-527862319718', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO7-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('fc866a14-5110-41b8-b7ba-ea022b14a611', 'cc34461b-90b5-4344-82e4-527862319718', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO7-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('155b805c-b566-4026-ad02-a45fcdd467bb', 'cc34461b-90b5-4344-82e4-527862319718', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO7-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('2e2a0ee4-64e2-4f49-920e-2ef9679a3eaf', 'noir-mosaic-no1', 'Noir Mosaic no1', '"Noir Mosaic no1" stands as a masterful exploration of geometric abstraction, where precision meets contemplative sophistication in a limited edition release. The artist''s commanding use of monochromatic values creates a profound visual dialogue between intersecting angular forms, rendered with exceptional technical precision against a subtly textured ground. Overlapping rectangular and triangular elements generate an architectural depth through masterful manipulation of opacity and transparency, while the careful gradation from deep noir to translucent gray tones establishes a mysterious, almost cinematic atmosphere. The composition''s constructivist influences merge seamlessly with contemporary minimalist sensibilities, creating a piece that commands attention through its calculated visual tension and refined aesthetic restraint.', NULL, 
        'VividWalls', 'Artwork',
        '{"Mosaic"}', 'active', 
        'Noir Mosaic no1 24x36 Gallery Wrapped Canvas', 
        '"Noir Mosaic no1" stands as a masterful exploration of geometric abstraction, where precision meets contemplative sophistication in a limited edition release. The artist''s commanding use of monochromatic values creates a profound visual dialogue between intersecting angular forms, rendered with exceptional technical precision against a subtly textured ground. Overlapping rectangular and triangular elements generate an architectural depth through masterful manipulation of opacity and transparency, while the careful gradation from deep noir to translucent gray tones establishes a mysterious, almost cinematic atmosphere. The composition''s constructivist influences merge seamlessly with contemporary minimalist sensibilities, creating a piece that commands attention through its calculated visual tension and refined aesthetic restraint.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('f89a9ee4-d4f0-43a2-9975-45ebbff5c662', '2e2a0ee4-64e2-4f49-920e-2ef9679a3eaf', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/noir_mosaic-no1-black_frame_53x72_347eb073-51e8-4580-9512-baf9bc34e7d8.png?v=1713721613', 'noir-mosaic-no1 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('5ccf8284-c047-4a60-bce0-0cc062b18b36', '2e2a0ee4-64e2-4f49-920e-2ef9679a3eaf', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/noir_mosaic-no1-white_frame_53x72_166a58ac-d7bf-43d2-a0af-dafeb2620f48.png?v=1713721613', 'noir-mosaic-no1 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('165d01b2-9e34-461c-968c-7733054c1b65', '2e2a0ee4-64e2-4f49-920e-2ef9679a3eaf', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/noir_mosaic-no1-no_frame_53x72_6a14b85a-6097-4a53-b637-a6248ca015d9.png?v=1713721613', 'noir-mosaic-no1 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('6a5a70b6-597c-48dc-b360-a84f0ad14f02', '2e2a0ee4-64e2-4f49-920e-2ef9679a3eaf', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Noir_Mosaic-no1-Black_Frame_36x48_a9033ff4-02a3-4adc-ac23-3e893336307d.png?v=1713721613', 'noir-mosaic-no1 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0af8d15f-bce5-4600-8213-bd57335910e6', '2e2a0ee4-64e2-4f49-920e-2ef9679a3eaf', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Noir_Mosaic-no1-White_Frame_36x48_191da637-0af2-49b8-934b-cc59e60cdcf6.png?v=1713721613', 'noir-mosaic-no1 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('37031806-3ebb-4e6f-9920-b4afd20af75f', '2e2a0ee4-64e2-4f49-920e-2ef9679a3eaf', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Noir_Mosaic-no1-No_Frame_36x48_6bb04b5d-f77a-4664-8be6-7e0297cbe4da.png?v=1713721613', 'noir-mosaic-no1 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('54d9de36-2c54-49d1-bf23-d8976ec9bac5', '2e2a0ee4-64e2-4f49-920e-2ef9679a3eaf', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('53e2f3a8-c8fb-4fbf-9825-73c907adeac6', '2e2a0ee4-64e2-4f49-920e-2ef9679a3eaf', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-MOSAIC-NO1-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('08d8b273-9bd0-4097-99db-013159a76811', '2e2a0ee4-64e2-4f49-920e-2ef9679a3eaf', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('d696229f-3d0a-4fac-89f3-d793b0b89c06', '2e2a0ee4-64e2-4f49-920e-2ef9679a3eaf', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-MOSAIC-NO1-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('887ec2d0-9ca4-4659-9eb7-d145a2832a8d', '2e2a0ee4-64e2-4f49-920e-2ef9679a3eaf', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('324090a2-1ee0-4a7a-899c-4c173aa373ef', '2e2a0ee4-64e2-4f49-920e-2ef9679a3eaf', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-MOSAIC-NO1-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('6015bbd3-f792-42ca-b852-62ae3d466ead', 'noir-mosaic-no2', 'Noir Mosaic no2', '"Noir Mosaic no2" stands as a masterful exploration of geometric abstraction, where precision meets artistic intuition in a sophisticated monochromatic composition. The artist''s virtuosic manipulation of intersecting triangular and rectangular forms creates a compelling dimensional narrative, with bold black shapes emerging from and receding into a carefully calibrated gray field. This museum-quality limited edition piece demonstrates remarkable technical sophistication in its digital execution, enhanced by a subtle textural overlay that introduces an organic quality to the otherwise crisp geometric forms. The composition achieves a delicate equilibrium between mathematical precision and dynamic energy, evoking architectural monumentality while maintaining contemporary graphic sensibilities. Drawing influence from both constructivist and minimalist traditions, the work transforms the classical mosaic concept into a thoroughly modern expression.', NULL, 
        'VividWalls', 'Artwork',
        '{"Mosaic"}', 'active', 
        'Noir Mosaic no2 24x36 Gallery Wrapped Canvas', 
        '"Noir Mosaic no2" stands as a masterful exploration of geometric abstraction, where precision meets artistic intuition in a sophisticated monochromatic composition. The artist''s virtuosic manipulation of intersecting triangular and rectangular forms creates a compelling dimensional narrative, with bold black shapes emerging from and receding into a carefully calibrated gray field. This museum-quality limited edition piece demonstrates remarkable technical sophistication in its digital execution, enhanced by a subtle textural overlay that introduces an organic quality to the otherwise crisp geometric forms. The composition achieves a delicate equilibrium between mathematical precision and dynamic energy, evoking architectural monumentality while maintaining contemporary graphic sensibilities. Drawing influence from both constructivist and minimalist traditions, the work transforms the classical mosaic concept into a thoroughly modern expression.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('a7a00733-c3e2-4509-8255-8e0b6a8bfaf6', '6015bbd3-f792-42ca-b852-62ae3d466ead', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/noir_mosaic-no2-black_frame_53x72_d0b3069e-9374-494a-a421-35047964bc50.png?v=1713721585', 'noir-mosaic-no2 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('93218abe-7483-4ffd-8d58-24268fad3fb9', '6015bbd3-f792-42ca-b852-62ae3d466ead', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/noir_mosaic-no2-white_frame_53x72_f66b4877-ab58-4fbf-bf82-80feaaeb2d4f.png?v=1713721585', 'noir-mosaic-no2 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('dc82d0a9-2d4c-4b33-9dc4-d13afc3db413', '6015bbd3-f792-42ca-b852-62ae3d466ead', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/noir_mosaic-no2-no_frame_53x72_cb9d7c79-66e3-4ee7-b60f-2c0b8d2fd6b7.png?v=1713721585', 'noir-mosaic-no2 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('1bffceac-3537-413d-be88-a3c1659e538c', '6015bbd3-f792-42ca-b852-62ae3d466ead', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Noir_Mosaic-no2-Black_Frame_36x48_84374dac-a33f-4398-9aff-4ef7586297ac.png?v=1713721585', 'noir-mosaic-no2 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('901c3517-2aa2-4af5-83e7-8fcd8e3ddd76', '6015bbd3-f792-42ca-b852-62ae3d466ead', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Noir_Mosaic-no2-White_Frame_36x48_b278cbe8-9033-4e2b-bb1d-6890984f24b7.png?v=1713721585', 'noir-mosaic-no2 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('38da8d77-1916-4350-9efe-ed14e7fffb34', '6015bbd3-f792-42ca-b852-62ae3d466ead', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Noir_Mosaic-no2-No_Frame_36x48_7c9aa9b0-b474-4db2-9c87-edbfc7b7492e.png?v=1713721585', 'noir-mosaic-no2 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('2b112dfd-fb75-46b0-bcdf-9991817f5f27', '6015bbd3-f792-42ca-b852-62ae3d466ead', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('5ea4e8bf-9342-4f65-9e9e-2bb1e02e3d30', '6015bbd3-f792-42ca-b852-62ae3d466ead', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-MOSAIC-NO2-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('38860c17-a3c0-4506-a575-36ecf5ea582b', '6015bbd3-f792-42ca-b852-62ae3d466ead', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('44ad6c4d-4ff4-415a-a4aa-ab2352d94186', '6015bbd3-f792-42ca-b852-62ae3d466ead', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-MOSAIC-NO2-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4b7c4e3a-d7fd-44b1-9726-ed6abea6f260', '6015bbd3-f792-42ca-b852-62ae3d466ead', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('e978d4de-0328-45ad-8012-31f8ae08c382', '6015bbd3-f792-42ca-b852-62ae3d466ead', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-MOSAIC-NO2-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('3acc436a-48fb-483e-b811-b8509b650820', 'noir-mosaic-no3', 'Noir Mosaic no3', '"Noir Mosaic no3" stands as a masterful exploration of contemporary geometric abstraction, where precision meets artistic sophistication in a carefully orchestrated composition of overlapping forms. The artist''s virtuosic manipulation of transparency and opacity creates a compelling dialogue between light and shadow, with rectangular and triangular elements arranged in an asymmetrical yet perfectly balanced configuration. This museum-quality limited edition piece demonstrates exceptional technical control, presenting a digital homage to classical mosaic traditions while firmly establishing itself in the contemporary art landscape. The monochromatic palette, ranging from stark black to subtle gradients of gray, achieves a remarkable depth through layered geometries that suggest both architectural space and pure abstract form.', NULL, 
        'VividWalls', 'Artwork',
        '{"Mosaic"}', 'active', 
        'Noir Mosaic no3 24x36 Gallery Wrapped Canvas', 
        '"Noir Mosaic no3" stands as a masterful exploration of contemporary geometric abstraction, where precision meets artistic sophistication in a carefully orchestrated composition of overlapping forms. The artist''s virtuosic manipulation of transparency and opacity creates a compelling dialogue between light and shadow, with rectangular and triangular elements arranged in an asymmetrical yet perfectly balanced configuration. This museum-quality limited edition piece demonstrates exceptional technical control, presenting a digital homage to classical mosaic traditions while firmly establishing itself in the contemporary art landscape. The monochromatic palette, ranging from stark black to subtle gradients of gray, achieves a remarkable depth through layered geometries that suggest both architectural space and pure abstract form.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('65e5930c-dd76-4146-af63-78f682c59a65', '3acc436a-48fb-483e-b811-b8509b650820', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Noir_Mosaic-no3-Black_Frame_53x72_b7eb934d-a49a-41b8-b0d4-8205459dd412.png?v=1713721555', 'noir-mosaic-no3 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e4ea4fd1-aa50-429c-99ef-f5d80ad96912', '3acc436a-48fb-483e-b811-b8509b650820', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Noir_Mosaic-no3-White_Frame_53x72_78ba6df2-2f04-4bcd-85db-ae1b1bec5f54.png?v=1713721555', 'noir-mosaic-no3 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('4b17c590-2276-4941-8699-1ec6eeadbcea', '3acc436a-48fb-483e-b811-b8509b650820', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Noir_Mosaic-no3-No_Frame_53x72_935edac9-47d2-43a3-8cfb-fdfbda9d21cb.png?v=1713721555', 'noir-mosaic-no3 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('65f2188b-45cf-468e-a1b5-ab03ae563972', '3acc436a-48fb-483e-b811-b8509b650820', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Noir_Mosaic-no3-Black_Frame_36x48_8850dfdc-f5f4-4f11-9e0d-ee7c9220abf8.png?v=1713721555', 'noir-mosaic-no3 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('a5bf9da0-9ba1-4f8a-a0cd-100697ae95d0', '3acc436a-48fb-483e-b811-b8509b650820', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Noir_Mosaic-no3-White_Frame_36x48_e7502c6b-1965-4dfe-aebb-990fd21045ff.png?v=1713721555', 'noir-mosaic-no3 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('a905d37e-07c3-42bf-a140-648c688d59d5', '3acc436a-48fb-483e-b811-b8509b650820', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Noir_Mosaic-no3-No_Frame_36x48_12b85b7b-3b50-47d5-aea1-fe1b1fb551c3.png?v=1713721555', 'noir-mosaic-no3 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('cc200ec5-a3b6-40d3-8723-2b541abea2c9', '3acc436a-48fb-483e-b811-b8509b650820', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('9914d520-5f4d-4fc3-9fdf-7d655e167850', '3acc436a-48fb-483e-b811-b8509b650820', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-MOSAIC-NO3-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('355d69bb-a96a-4caa-9003-2e7af4ecba2d', '3acc436a-48fb-483e-b811-b8509b650820', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('8c04b7f2-c0b2-4ca2-acd5-3c6bc2019d52', '3acc436a-48fb-483e-b811-b8509b650820', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-MOSAIC-NO3-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('ba177f7a-8338-417e-89c7-b6d1f6992b55', '3acc436a-48fb-483e-b811-b8509b650820', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'NOIR-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('23be8102-ebed-4092-a90f-65642288973f', '3acc436a-48fb-483e-b811-b8509b650820', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'NOIR-MOSAIC-NO3-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('879bd754-704d-4e9f-b59d-c6d0f85e3ddb', 'vivid-mosaic-no6', 'Vivid Mosaic No6', '"Vivid Mosaic No6" stands as a masterful exploration of contemporary geometric abstraction, where crystalline forms intersect in a sophisticated dance of transparency and light. The artist''s command of digital medium elevates traditional mosaic concepts into the realm of high contemporary art, creating a museum-quality piece that demands contemplation. The composition''s dramatic interplay of deep navy blues and forest greens transitions expertly into ethereal turquoise, violet, and amber tones, while overlapping translucent planes generate an extraordinary depth that transcends the two-dimensional surface. This limited edition work from the acclaimed Mosaic collection demonstrates remarkable technical precision, with angular elements weighted strategically to create dynamic visual movement across the canvas. The subtle integration of organic texture beneath the geometric precision speaks to the artist''s sophisticated understanding of material dialogue in digital art.', NULL, 
        'VividWalls', 'Artwork',
        '{"Mosaic"}', 'active', 
        'Vivid Mosaic No6 24x36 Gallery Wrapped Canvas', 
        '"Vivid Mosaic No6" stands as a masterful exploration of contemporary geometric abstraction, where crystalline forms intersect in a sophisticated dance of transparency and light. The artist''s command of digital medium elevates traditional mosaic concepts into the realm of high contemporary art, creating a museum-quality piece that demands contemplation. The composition''s dramatic interplay of deep navy blues and forest greens transitions expertly into ethereal turquoise, violet, and amber tones, while overlapping translucent planes generate an extraordinary depth that transcends the two-dimensional surface. This limited edition work from the acclaimed Mosaic collection demonstrates remarkable technical precision, with angular elements weighted strategically to create dynamic visual movement across the canvas. The subtle integration of organic texture beneath the geometric precision speaks to the artist''s sophisticated understanding of material dialogue in digital art.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('4abdea9b-89cc-4567-befe-a6269e011c33', '879bd754-704d-4e9f-b59d-c6d0f85e3ddb', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no6_canvas-black_frame_53x72_49401923-0720-4ce2-866e-1f22351682dd.png?v=1713721422', 'vivid-mosaic-no6 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('fc6bd653-b3e2-416f-8706-83a1b7c9846b', '879bd754-704d-4e9f-b59d-c6d0f85e3ddb', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no6_canvas-white_frame_48x72_897ac785-a0e8-474d-a679-abe097ff482e.png?v=1713721422', 'vivid-mosaic-no6 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('34805bda-1695-4e8a-9ad9-37d2137f1f60', '879bd754-704d-4e9f-b59d-c6d0f85e3ddb', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no6_canvas-no_frame_52x72_7e3f2050-11a2-40a8-83ed-b5842898af31.png?v=1713721422', 'vivid-mosaic-no6 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('a59f45b9-cff1-4170-9a95-08a0fddea7a5', '879bd754-704d-4e9f-b59d-c6d0f85e3ddb', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no6_canvas_black_frame_36x48_1a7a8b37-e667-420c-bdeb-fb0db987891b.png?v=1713721422', 'vivid-mosaic-no6 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('c4acfba8-cf6c-4f08-8f42-26b0d6132b8d', '879bd754-704d-4e9f-b59d-c6d0f85e3ddb', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no6_canvas-no_frame_36x48_8756d78a-0190-460a-b5fa-131b5ed859e4.png?v=1713721423', 'vivid-mosaic-no6 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('c60fa52f-b892-45c4-902c-73d76d0eb88d', '879bd754-704d-4e9f-b59d-c6d0f85e3ddb', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no6_canvas_white_frame_36x48_073eda17-61ff-415f-b8e8-7307572d2762.png?v=1713721423', 'vivid-mosaic-no6 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('7683a17f-ff7a-4397-a4c7-c589896f6aef', '879bd754-704d-4e9f-b59d-c6d0f85e3ddb', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO6-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('f8ce344a-27ca-42e0-98ca-cd95996f84fb', '879bd754-704d-4e9f-b59d-c6d0f85e3ddb', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO6-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('fd75ab8c-64b0-4cbd-9f9b-ea67a77397e4', '879bd754-704d-4e9f-b59d-c6d0f85e3ddb', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO6-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('06f16cb4-7ab9-4f23-92ec-387a233d6522', '879bd754-704d-4e9f-b59d-c6d0f85e3ddb', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO6-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b2b19ef8-4d2a-4d4b-8ead-b56271908dae', '879bd754-704d-4e9f-b59d-c6d0f85e3ddb', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO6-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('70875218-c59e-43a7-a98b-74648e400fa3', '879bd754-704d-4e9f-b59d-c6d0f85e3ddb', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO6-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('5d572ade-a433-4231-87fe-630b2bbb0935', 'vivid-mosaic-no5', 'Vivid Mosaic no5', 'In "Vivid Mosaic no5," the artist masterfully orchestrates a sophisticated interplay of geometric abstraction and chromatic harmony, creating a contemporary digital masterpiece that commands attention. This limited edition work presents a mesmerizing composition where crystalline forms cascade through space with architectural precision, while maintaining an organic fluidity through masterful manipulation of transparency and depth. The piece''s distinguished palette centers on a spectrum of blues—from midnight to cerulean—punctuated by strategic accents of pink, mint green, and burgundy, creating a rich visual tapestry that epitomizes the intersection of Digital Minimalism and Constructivist influence. The artist''s command of digital mosaic techniques allows for an unprecedented level of precision in the tessellated segments, while maintaining the emotional resonance of traditional abstract expressionism.', NULL, 
        'VividWalls', 'Artwork',
        '{"Mosaic"}', 'active', 
        'Vivid Mosaic no5 24x36 Gallery Wrapped Canvas', 
        'In "Vivid Mosaic no5," the artist masterfully orchestrates a sophisticated interplay of geometric abstraction and chromatic harmony, creating a contemporary digital masterpiece that commands attention. This limited edition work presents a mesmerizing composition where crystalline forms cascade through space with architectural precision, while maintaining an organic fluidity through masterful manipulation of transparency and depth. The piece''s distinguished palette centers on a spectrum of blues—from midnight to cerulean—punctuated by strategic accents of pink, mint green, and burgundy, creating a rich visual tapestry that epitomizes the intersection of Digital Minimalism and Constructivist influence. The artist''s command of digital mosaic techniques allows for an unprecedented level of precision in the tessellated segments, while maintaining the emotional resonance of traditional abstract expressionism.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('38b76d35-5ec8-4a8a-a24a-4e1731d5d06b', '5d572ade-a433-4231-87fe-630b2bbb0935', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no5_canvas-black_frame_48x72_f9b8e986-d103-40f2-8f4d-dbb2a6c77120.png?v=1713721395', 'vivid-mosaic-no5 Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('e320feb3-f697-4fa7-bafe-46901b51c55a', '5d572ade-a433-4231-87fe-630b2bbb0935', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no5_canvas-white_frame_48x72_261edd07-71d9-4170-8ee8-fab2459dac36.png?v=1713721395', 'vivid-mosaic-no5 Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('aefb6bd8-2a43-42c7-a3a5-efa36c916672', '5d572ade-a433-4231-87fe-630b2bbb0935', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no5_canvas-no_frame_48x72_c772e90c-ef4b-4ccc-9888-db9f3048b929.png?v=1713721395', 'vivid-mosaic-no5 Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('ca9818f8-2078-474f-9f15-14f908e300c5', '5d572ade-a433-4231-87fe-630b2bbb0935', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no5_canvas-black_frame_36x48_760d26f0-bee7-4b16-9166-ca79a192ecd6.png?v=1713721395', 'vivid-mosaic-no5 Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('641cccff-5b2a-4a1a-a1c9-7874eb1106ba', '5d572ade-a433-4231-87fe-630b2bbb0935', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no5_canvas-white_frame_36x48_cbf7cca3-293d-4960-ab7d-b631d5834532.png?v=1713721395', 'vivid-mosaic-no5 Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('3c8a1f8a-9f42-4222-8bcf-d6c5cd883c75', '5d572ade-a433-4231-87fe-630b2bbb0935', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/vivid_mosaic_no5_canvas-No_frame_36x48_63248be7-3b51-4a68-aed0-d8ff4f13e2a5.png?v=1713721395', 'vivid-mosaic-no5 Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('53240849-3f9e-4b5a-b28e-b5dbfc8d5dd7', '5d572ade-a433-4231-87fe-630b2bbb0935', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO5-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('85b0f8f5-12d7-4a53-bc72-f53fb3af3b84', '5d572ade-a433-4231-87fe-630b2bbb0935', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO5-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('8e1b4302-4cfb-47b4-b940-39429548cdc3', '5d572ade-a433-4231-87fe-630b2bbb0935', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO5-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('12d8c478-859a-4e45-98f1-38df987bb3d2', '5d572ade-a433-4231-87fe-630b2bbb0935', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO5-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('83d1339c-23a1-40b7-85b8-ac315d9f3017', '5d572ade-a433-4231-87fe-630b2bbb0935', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'VIVID-MOSAIC-NO5-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('899c60cf-e888-43c7-bf1d-a4c222e15803', '5d572ade-a433-4231-87fe-630b2bbb0935', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'VIVID-MOSAIC-NO5-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('f76d6d6d-611a-4622-8e34-fa4a899c9ad3', 'fractal-color-dark-double', 'Fractal Color Dark Double', 'Fractal Color Dark Doublefrom the Fractalcollection features symmetric fractal art that cascades in a mesmerizing display of blues, oranges, and reds. The design creates the illusion of depth, with layers that seem to spiral into infinity. Each pattern mirrors and complements the other, forming a balanced composition that draws the eye deeper into its geometric complexity. The artwork''s rich color palette transitions from deep, moody blues to vibrant oranges and reds, creating a dynamic visual experience that captures the mathematical beauty inherent in fractal geometry.', NULL, 
        'VividWalls', 'Artwork',
        '{"Fractal"}', 'active', 
        'Fractal Color Dark Double 24x36 Gallery Wrapped Canvas', 
        'Fractal Color Dark Doublefrom the Fractalcollection features symmetric fractal art that cascades in a mesmerizing display of blues, oranges, and reds. The design creates the illusion of depth, with layers that seem to spiral into infinity. Each pattern mirrors and complements the other, forming a balanced composition that draws the eye deeper into its geometric complexity. The artwork''s rich color palette transitions from deep, moody blues to vibrant oranges and reds, creating a dynamic visual experience that captures the mathematical beauty inherent in fractal geometry.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('eb8448ee-7223-4694-89ee-02c0cd5760a1', 'f76d6d6d-611a-4622-8e34-fa4a899c9ad3', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/fractal_dark_no1_black_frame_72x53_4549fa1d-a421-4027-9c7c-6e2e2590a8b3.png?v=1713722017', 'fractal-color-dark-double Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('94d8beb1-a596-4a35-a288-423f77303360', 'f76d6d6d-611a-4622-8e34-fa4a899c9ad3', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/fractal_dark_no1_white_frame_72x53_dca9eed8-3e08-43c0-bb5a-fd01cd2facab.png?v=1713722017', 'fractal-color-dark-double Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('8ddaa5c9-c83d-426d-bd29-19a8e32edbc3', 'f76d6d6d-611a-4622-8e34-fa4a899c9ad3', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor_001_DoubleDark_NoFrame-72x53_db02af03-40d7-4952-9b18-085b1ca02c3f.png?v=1713722017', 'fractal-color-dark-double Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('187b46a4-6e30-4374-8494-13773c2f9819', 'f76d6d6d-611a-4622-8e34-fa4a899c9ad3', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor_001_DoubleDark_Black_Frame-48x36_addf28b6-1128-46fd-ba84-38613264c44a.png?v=1713722017', 'fractal-color-dark-double Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('a3156177-0052-4125-88a1-da72094345b7', 'f76d6d6d-611a-4622-8e34-fa4a899c9ad3', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor_001_DoubleDark_No_Frame-48x36_f71c0aa2-f734-41e0-8d4f-c3376d32aebe.png?v=1713722017', 'fractal-color-dark-double Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('be6d3a0a-bec8-4a5f-82c1-0c591f9d039e', 'f76d6d6d-611a-4622-8e34-fa4a899c9ad3', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor_001_DoubleDark_White_Frame-48x36_90070074-7cd6-4344-8b9d-60b90a8c58b2.png?v=1713722017', 'fractal-color-dark-double Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('ca1d8dd7-38a8-48df-9f2c-7b0d7b35ab8e', 'f76d6d6d-611a-4622-8e34-fa4a899c9ad3', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-COLOR-DARK-DOUBLE-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('0a1fd966-2e91-4916-8fec-b810a6101521', 'f76d6d6d-611a-4622-8e34-fa4a899c9ad3', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-COLOR-DARK-DOUBLE-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4e4e6e08-f3a7-43c8-b01d-1ccfd93e8610', 'f76d6d6d-611a-4622-8e34-fa4a899c9ad3', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-COLOR-DARK-DOUBLE-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('0d41e6bf-2d3f-4cca-8f78-ff6a0a0baf79', 'f76d6d6d-611a-4622-8e34-fa4a899c9ad3', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-COLOR-DARK-DOUBLE-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4973884a-ef72-4537-baaa-21f6c71457af', 'f76d6d6d-611a-4622-8e34-fa4a899c9ad3', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-COLOR-DARK-DOUBLE-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('87e4eab9-e9de-4056-8e9f-7ab6bc401099', 'f76d6d6d-611a-4622-8e34-fa4a899c9ad3', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-COLOR-DARK-DOUBLE-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('4e3a41be-5411-4fd6-ae63-af693fc9f7c7', 'fractal-color-red', 'Fractal Color Red', '"Fractal Color Red" stands as a masterful exploration of digital abstraction, where mathematical precision meets artistic passion in a stunning contemporary composition. The artist''s sophisticated manipulation of geometric forms creates a mesmerizing interplay of crimson, burgundy, and scarlet hues, punctuated by strategic accents of deep blue and vibrant orange. This museum-quality limited edition piece demonstrates remarkable technical virtuosity in its execution, with precisely rendered fractal patterns that cascade through multiple dimensional planes, creating an infinite dialogue between form and space. The work''s digital genesis is elegantly tempered by a subtle canvas-like texture, bridging the gap between traditional and contemporary artistic mediums. Drawing influence from both Constructivism and Digital Abstractionism, the composition achieves a delicate balance between mathematical order and emotional intensity.', NULL, 
        'VividWalls', 'Artwork',
        '{"Fractal"}', 'active', 
        'Fractal Color Red 24x36 Gallery Wrapped Canvas', 
        '"Fractal Color Red" stands as a masterful exploration of digital abstraction, where mathematical precision meets artistic passion in a stunning contemporary composition. The artist''s sophisticated manipulation of geometric forms creates a mesmerizing interplay of crimson, burgundy, and scarlet hues, punctuated by strategic accents of deep blue and vibrant orange. This museum-quality limited edition piece demonstrates remarkable technical virtuosity in its execution, with precisely rendered fractal patterns that cascade through multiple dimensional planes, creating an infinite dialogue between form and space. The work''s digital genesis is elegantly tempered by a subtle canvas-like texture, bridging the gap between traditional and contemporary artistic mediums. Drawing influence from both Constructivism and Digital Abstractionism, the composition achieves a delicate balance between mathematical order and emotional intensity.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('1862b36c-0d87-4d1f-9e14-1ba7c3768c8f', '4e3a41be-5411-4fd6-ae63-af693fc9f7c7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor_Red_001_BlackFrame-53x72_8dcb1c9b-10af-4141-b8b0-60896f11ca8a.png?v=1713721992', 'fractal-color-red Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('ca0d2593-ea32-4412-8a23-a12ba5137d26', '4e3a41be-5411-4fd6-ae63-af693fc9f7c7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor_Red_001_WhiteFrame-48x72_983ef655-36f9-4b2a-b957-d2af3f1a7589.png?v=1713721992', 'fractal-color-red Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('d38f0ba2-4c1e-4337-bb63-ac2a1b7de4d8', '4e3a41be-5411-4fd6-ae63-af693fc9f7c7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor_Red_001_NoFrame-36x48_107d8acc-c2aa-4b4a-93a9-8c34366c6a70.png?v=1713721992', 'fractal-color-red Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('02a3c3ea-da4a-4be2-a1f9-b458542ec42b', '4e3a41be-5411-4fd6-ae63-af693fc9f7c7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor_Red_no1_Black_Frame-36x48_94d73c1e-a8df-43b0-b7ea-dcb6cce1b4f5.png?v=1713721992', 'fractal-color-red Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('bdf52576-635c-48ac-9ea5-3765d42f1ec7', '4e3a41be-5411-4fd6-ae63-af693fc9f7c7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor_Red_001_White_Frame-36x48_257a3b2c-d036-41c5-a8f2-32c9f7f4454a.png?v=1713721992', 'fractal-color-red Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('c1bd9249-e26c-4094-93dc-84ef0cf01519', '4e3a41be-5411-4fd6-ae63-af693fc9f7c7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor_Red_no1_No_Frame-36x48_307ab4b9-ffb1-45f7-b752-56a4ea25cc0b.png?v=1713721992', 'fractal-color-red Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('89104baf-c667-46a9-8fb2-b7f39cddcf63', '4e3a41be-5411-4fd6-ae63-af693fc9f7c7', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-COLOR-RED-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('ee2c5ae5-d6fd-43c2-b2a6-27f4fa86a7ac', '4e3a41be-5411-4fd6-ae63-af693fc9f7c7', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-COLOR-RED-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('fb77e732-0679-4385-8840-314171ba2f4d', '4e3a41be-5411-4fd6-ae63-af693fc9f7c7', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-COLOR-RED-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('0d79b5d3-aedd-47c7-8a01-cc221ae1fcc5', '4e3a41be-5411-4fd6-ae63-af693fc9f7c7', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-COLOR-RED-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('d6dfd51f-9803-47a7-a3d2-12892ec4dbc0', '4e3a41be-5411-4fd6-ae63-af693fc9f7c7', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-COLOR-RED-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('8a4b9f63-b4e6-4308-9e23-949f23158113', '4e3a41be-5411-4fd6-ae63-af693fc9f7c7', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-COLOR-RED-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('c334e06d-29e7-49f3-8487-a2c2ce95d6d0', 'fractal-color-light', 'Fractal Color Light', '"Fractal Color Light" stands as a masterful exploration of geometric abstraction, where precision meets chromatic virtuosity in a compelling contemporary composition. The artist''s sophisticated manipulation of intersecting triangular and quadrilateral forms creates a mesmerizing interplay of depth and dimension, while the carefully curated palette—ranging from deep navy to luminous yellows and striking magentas—demonstrates an exceptional understanding of color theory and spatial dynamics. This museum-quality limited edition piece seamlessly bridges the aesthetic principles of constructivism with contemporary digital artistry, achieving a remarkable balance between mathematical precision and expressive freedom. The work''s multilayered composition reveals new intricacies with each viewing, as transparent forms overlap and interact in a dance of geometric harmony.', NULL, 
        'VividWalls', 'Artwork',
        '{"Fractal"}', 'draft', 
        'Fractal Color Light 24x36 Gallery Wrapped Canvas', 
        '"Fractal Color Light" stands as a masterful exploration of geometric abstraction, where precision meets chromatic virtuosity in a compelling contemporary composition. The artist''s sophisticated manipulation of intersecting triangular and quadrilateral forms creates a mesmerizing interplay of depth and dimension, while the carefully curated palette—ranging from deep navy to luminous yellows and striking magentas—demonstrates an exceptional understanding of color theory and spatial dynamics. This museum-quality limited edition piece seamlessly bridges the aesthetic principles of constructivism with contemporary digital artistry, achieving a remarkable balance between mathematical precision and expressive freedom. The work''s multilayered composition reveals new intricacies with each viewing, as transparent forms overlap and interact in a dance of geometric harmony.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('1c37e719-8b0d-4a2f-a87f-4d4837116565', 'c334e06d-29e7-49f3-8487-a2c2ce95d6d0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor-Light-003_BlackFrame-48x72_48ac7ec1-642d-42fb-a9e3-9381feb68bfe.png?v=1713721848', 'fractal-color-light Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('4a8a7d5a-e58f-48a1-96e7-8ebff73f83d8', 'c334e06d-29e7-49f3-8487-a2c2ce95d6d0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor-Light-003_WhiteFrame-48x72_de9b6883-c1b3-47a8-bcd9-24ac83d706b7.png?v=1713721848', 'fractal-color-light Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('9aae0c56-b6a5-4969-b63d-7a952aa52fa2', 'c334e06d-29e7-49f3-8487-a2c2ce95d6d0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor-003_NoFrame-36x48_ba7a187f-b88b-41d5-b00f-bc9ed69ed887.png?v=1713721848', 'fractal-color-light Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('1ebd3cda-272c-4258-b861-d6bf102b2634', 'c334e06d-29e7-49f3-8487-a2c2ce95d6d0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor-Light_no3_Black_Frame-36x48_beee6bf3-5d58-4955-984c-c61ce4e0e13f.png?v=1713721848', 'fractal-color-light Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('c12430ad-a7c5-4059-8ff7-4531d3eb6034', 'c334e06d-29e7-49f3-8487-a2c2ce95d6d0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor-Light_no3_White_Frame-36x48_67b157ca-312e-4724-b986-75560e7655b6.png?v=1713721848', 'fractal-color-light Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('35e779b7-aab6-4a42-b2e2-1c308c12379c', 'c334e06d-29e7-49f3-8487-a2c2ce95d6d0', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor-Light_no3_No_Frame-36x48_43deef4a-f2de-44ea-b0ed-1a1b5f0b6a46.png?v=1713721848', 'fractal-color-light Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('b2e1f022-d097-41d8-86ec-5988b48be8ac', 'c334e06d-29e7-49f3-8487-a2c2ce95d6d0', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-COLOR-LIGHT-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('87a05985-c602-4183-b095-f3a1060f249c', 'c334e06d-29e7-49f3-8487-a2c2ce95d6d0', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-COLOR-LIGHT-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('bc3ffb7a-b278-4c8f-9e7e-6aee69aafa35', 'c334e06d-29e7-49f3-8487-a2c2ce95d6d0', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-COLOR-LIGHT-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('2fe9e769-38d4-40d8-add4-9e8e57669467', 'c334e06d-29e7-49f3-8487-a2c2ce95d6d0', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-COLOR-LIGHT-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('5be62738-d88c-41db-95fa-d42d43dda6cd', 'c334e06d-29e7-49f3-8487-a2c2ce95d6d0', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-COLOR-LIGHT-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('4314d938-67d1-45de-84f0-6155ffbfb3fb', 'c334e06d-29e7-49f3-8487-a2c2ce95d6d0', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-COLOR-LIGHT-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('ed72fb23-2553-4659-adfd-113c065f075c', 'fractal-color-dark', 'Fractal Color Dark', 'Fractal Color Darkfrom the Fractalcollection presents a rich tapestry of geometric complexity. Dark, shadowy backgrounds are juxtaposed with vivid bursts of color, including electric blues, greens, and fiery oranges, all interlocking in a fractal pattern that draws the eye inward. The artwork''s dark base enhances the intensity of the bright colors, creating a sense of depth and intrigue. This piece captures the essence of fractal art with its repeating patterns, exploring the intersection of darkness and color, order and chaos.', NULL, 
        'VividWalls', 'Artwork',
        '{"Fractal"}', 'active', 
        'Fractal Color Dark 24x36 Gallery Wrapped Canvas', 
        'Fractal Color Darkfrom the Fractalcollection presents a rich tapestry of geometric complexity. Dark, shadowy backgrounds are juxtaposed with vivid bursts of color, including electric blues, greens, and fiery oranges, all interlocking in a fractal pattern that draws the eye inward. The artwork''s dark base enhances the intensity of the bright colors, creating a sense of depth and intrigue. This piece captures the essence of fractal art with its repeating patterns, exploring the intersection of darkness and color, order and chaos.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('2b8b624a-1fde-4a18-abde-726b28b33334', 'ed72fb23-2553-4659-adfd-113c065f075c', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/fractal_dark_no1_black_frame-53x72_adb28661-d3d2-4fa4-a109-28a225f641d7.png?v=1713721823', 'fractal-color-dark Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('8d719a1c-b82b-4d3e-a4b7-7bc2c4efbb02', 'ed72fb23-2553-4659-adfd-113c065f075c', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/fractal_dark_no1_white_frame-53x72_31cc060d-d98b-4c8e-ae9a-6cff5146a3ff.png?v=1713721823', 'fractal-color-dark Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('b54d3e8f-954e-4b56-8272-2f0dd531ff4f', 'ed72fb23-2553-4659-adfd-113c065f075c', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/fractal_dark_no1_no_frame-53x72_b194db89-0485-4f85-89c2-b5823d97f963.png?v=1713721823', 'fractal-color-dark Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('25d326fe-7b9e-4284-9e5e-8c3183f1e520', 'ed72fb23-2553-4659-adfd-113c065f075c', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor_no1_Dark_Black_Frame-36x48_e0cbc84c-0bbe-44ec-a97e-60d4c9e6fcb2.png?v=1713721823', 'fractal-color-dark Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('04f3f506-e03e-456e-9c93-dc6811826bc5', 'ed72fb23-2553-4659-adfd-113c065f075c', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor_no1_Dark_White_Frame-36x48_fbdc7b76-d541-45ad-a4ff-a0d83dd830c8.png?v=1713721823', 'fractal-color-dark Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('203f7890-5ce6-4958-b6ea-7a61e919b7d3', 'ed72fb23-2553-4659-adfd-113c065f075c', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalColor_no1_Dark_No_Frame-36x48_6495daaa-781b-4720-abfd-e22b84e07200.png?v=1713721823', 'fractal-color-dark Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('131b848b-3f23-46a4-b272-efbf17dd15b3', 'ed72fb23-2553-4659-adfd-113c065f075c', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-COLOR-DARK-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('e8188de1-6b2c-4e8e-b716-063304d9fce5', 'ed72fb23-2553-4659-adfd-113c065f075c', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-COLOR-DARK-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('26ebfac7-4059-4cc1-a9ae-632914562e8b', 'ed72fb23-2553-4659-adfd-113c065f075c', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-COLOR-DARK-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('756508d9-9b9d-4365-a57f-3ea1f0b1d870', 'ed72fb23-2553-4659-adfd-113c065f075c', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-COLOR-DARK-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('721ac7d9-ba67-4b3b-9bbe-83d87317f872', 'ed72fb23-2553-4659-adfd-113c065f075c', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-COLOR-DARK-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('3008ccc5-460c-4cb9-81e5-5ddf12f63bbe', 'ed72fb23-2553-4659-adfd-113c065f075c', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-COLOR-DARK-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('9386864e-de53-4710-a865-3f74818a859f', 'fractal-noir', 'Fractal Noir', '"Fractal Noir" stands as a masterful exploration of geometric abstraction, where precision meets artistic sophistication in a compelling monochromatic dialogue. The artist''s meticulous composition orchestrates a complex interplay of angular forms—triangles, rectangles, and trapezoids—layered with remarkable depth through varying degrees of black, white, and nuanced grayscale tonalities. A subtle digital grain texture imbues the piece with contemporary resonance while maintaining its refined aesthetic character. The work demonstrates exceptional technical virtuosity in its manipulation of positive and negative space, as crystalline white geometries slice through darker planes to create a mesmerizing dimensional effect. This limited edition piece draws inspiration from both constructivist principles and modern digital aesthetics, positioning itself at the intersection of classical abstraction and contemporary design.', NULL, 
        'VividWalls', 'Artwork',
        '{"Fractal"}', 'active', 
        'Fractal Noir 24x36 Gallery Wrapped Canvas', 
        '"Fractal Noir" stands as a masterful exploration of geometric abstraction, where precision meets artistic sophistication in a compelling monochromatic dialogue. The artist''s meticulous composition orchestrates a complex interplay of angular forms—triangles, rectangles, and trapezoids—layered with remarkable depth through varying degrees of black, white, and nuanced grayscale tonalities. A subtle digital grain texture imbues the piece with contemporary resonance while maintaining its refined aesthetic character. The work demonstrates exceptional technical virtuosity in its manipulation of positive and negative space, as crystalline white geometries slice through darker planes to create a mesmerizing dimensional effect. This limited edition piece draws inspiration from both constructivist principles and modern digital aesthetics, positioning itself at the intersection of classical abstraction and contemporary design.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('d98baa2d-3a65-476d-ab23-d05808b1cdc2', '9386864e-de53-4710-a865-3f74818a859f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalBW-001_BlkFrame-48x72_6d8932bd-062a-4ab7-a1b6-66a278d78c6c.png?v=1713720912', 'fractal-noir Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('9e7483ca-5a1f-422d-b3ec-118f999f66ef', '9386864e-de53-4710-a865-3f74818a859f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalBW-001_WhtFrame-48x72_ecb2c98e-7429-44cc-986b-09abc1da88ea.png?v=1713720912', 'fractal-noir Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('a5277abd-f495-418a-a562-6edcc83a99a6', '9386864e-de53-4710-a865-3f74818a859f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/FractalBW-001_NoFrame-48x72_3baf40ac-3516-434d-adb6-dee4ecd8ed48.png?v=1713720912', 'fractal-noir Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('2de478bf-722e-4544-94bd-bc7a43a1629b', '9386864e-de53-4710-a865-3f74818a859f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Fractal-Chrome_no1_Black_Frame-36x48_036b44c9-779d-4537-9698-5bd9045ec312.png?v=1713720912', 'fractal-noir Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('38c17ffd-b0a2-4c52-955b-4d195ef78319', '9386864e-de53-4710-a865-3f74818a859f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Fractal-Chrome_no1_White_Frame-36x48_e7f98aaa-c57b-4eff-a7af-3063e9c7a21e.png?v=1713720912', 'fractal-noir Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('1247396f-e6dd-471e-862b-792fa0132d5a', '9386864e-de53-4710-a865-3f74818a859f', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Fractal-Chrome_no1_No_Frame-36x48_22bb6f7b-5f1c-4634-a1d9-88a54826acca.png?v=1713720912', 'fractal-noir Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('657f8fac-0ab8-49e4-9936-2ba5283f23b4', '9386864e-de53-4710-a865-3f74818a859f', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-NOIR-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('22a368f1-0907-4769-b5da-c526d9d94f26', '9386864e-de53-4710-a865-3f74818a859f', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-NOIR-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('85d3c471-d902-4c0b-9b77-1d18e9376f0f', '9386864e-de53-4710-a865-3f74818a859f', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-NOIR-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('2b539086-3400-47f7-94de-802c199879c0', '9386864e-de53-4710-a865-3f74818a859f', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-NOIR-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('e9715e0c-c09e-4bd8-9de1-1e679e35f46c', '9386864e-de53-4710-a865-3f74818a859f', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-NOIR-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('154e9549-be80-49fc-b1b6-e86c2bda5e30', '9386864e-de53-4710-a865-3f74818a859f', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-NOIR-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('a3bde9b8-7be3-4877-9cb2-b0060c69d9be', 'fractal-noir-double', 'Fractal Noir Double', '"Fractal Noir Double" stands as a masterful synthesis of mathematical precision and aesthetic sophistication within contemporary geometric abstraction. This museum-quality limited edition work presents a compelling interplay of stark monochromatic forms, where crystalline triangular structures intersect with architectural precision across a meticulously balanced composition. The artist''s masterful manipulation of digital techniques creates a distinctive noir atmosphere through granular textures that evoke vintage photography, while maintaining the mathematical purity inherent in fractal art. The bilateral symmetry serves as an organizational foundation from which geometric forms radiate with calculated grace, creating a dynamic tension between positive and negative space. Translucent layers overlap to generate subtle gradients and unexpected intersections, rewarding sustained contemplation with their intricate complexity.', NULL, 
        'VividWalls', 'Artwork',
        '{"Fractal"}', 'active', 
        'Fractal Noir Double 24x36 Gallery Wrapped Canvas', 
        '"Fractal Noir Double" stands as a masterful synthesis of mathematical precision and aesthetic sophistication within contemporary geometric abstraction. This museum-quality limited edition work presents a compelling interplay of stark monochromatic forms, where crystalline triangular structures intersect with architectural precision across a meticulously balanced composition. The artist''s masterful manipulation of digital techniques creates a distinctive noir atmosphere through granular textures that evoke vintage photography, while maintaining the mathematical purity inherent in fractal art. The bilateral symmetry serves as an organizational foundation from which geometric forms radiate with calculated grace, creating a dynamic tension between positive and negative space. Translucent layers overlap to generate subtle gradients and unexpected intersections, rewarding sustained contemplation with their intricate complexity.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('fecc113f-0c97-469b-bda1-6097db4ea617', 'a3bde9b8-7be3-4877-9cb2-b0060c69d9be', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Fractal_Noir_Black-Frame-72x48_a1e3dee9-20f5-43c8-8ae3-79fd51b00604.png?v=1713720889', 'fractal-noir-double Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('08e2d807-da25-4e3e-b83f-087740eb3e06', 'a3bde9b8-7be3-4877-9cb2-b0060c69d9be', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Fractal_Noir_White-Frame-72x48_317e6f5e-b983-4fe8-bdf2-1b0b94b55b17.png?v=1713720889', 'fractal-noir-double Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('2ca21605-f637-4cc4-be73-42d99be291d1', 'a3bde9b8-7be3-4877-9cb2-b0060c69d9be', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Fractal_Noir_No-Frame-72x48_c84e7b6e-f406-4a13-acbf-4f7e50bb3462.png?v=1713720889', 'fractal-noir-double Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('cc9d7496-aa69-4413-af07-37ec7da38c7c', 'a3bde9b8-7be3-4877-9cb2-b0060c69d9be', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Fractal_Noir_Black-Frame-48x36_5ddaf883-89aa-4ece-a36b-910004f29c19.png?v=1713720889', 'fractal-noir-double Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('7ec67627-2b2d-4508-b3c0-62a14652e8cb', 'a3bde9b8-7be3-4877-9cb2-b0060c69d9be', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Fractal_Noir_No-Frame-48x36_799f401f-3251-49fd-a7f8-9baf689c937a.png?v=1713720889', 'fractal-noir-double Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('9cfeb600-a457-4abd-9369-53e945e242b4', 'a3bde9b8-7be3-4877-9cb2-b0060c69d9be', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Fractal_Noir_Black-Frame-36x24_b113afe8-1418-4961-acc7-475635908fae.png?v=1713720889', 'fractal-noir-double Posters, Prints, & Visual Artwork 53x72 Canvas Roll', 6);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('529d82ae-bccb-46ce-bdad-d769c0503718', 'a3bde9b8-7be3-4877-9cb2-b0060c69d9be', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-NOIR-DOUBLE-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('6be5ad27-a2b3-4ef8-a1b5-90a1aa402a82', 'a3bde9b8-7be3-4877-9cb2-b0060c69d9be', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-NOIR-DOUBLE-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('72b7ebdc-86e3-4fc6-bab5-707c9d82ea10', 'a3bde9b8-7be3-4877-9cb2-b0060c69d9be', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-NOIR-DOUBLE-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('ff235e19-b683-403c-8121-82e9b7cfce9a', 'a3bde9b8-7be3-4877-9cb2-b0060c69d9be', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-NOIR-DOUBLE-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('0fa4a6f8-2e94-459f-855e-175cf27311b5', 'a3bde9b8-7be3-4877-9cb2-b0060c69d9be', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-NOIR-DOUBLE-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('51e513b8-6cb0-4289-b4ee-3a33454bc7e0', 'a3bde9b8-7be3-4877-9cb2-b0060c69d9be', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-NOIR-DOUBLE-CANVAS-ROLL-53X72', 413.39, NULL, 0.0);

INSERT INTO products (id, handle, title, description, collection_id, vendor, 
                     product_type, tags, status, seo_title, seo_description)
VALUES ('7d499927-db1d-4312-a6a5-f631d2e3c7d7', 'fractal-double-red', 'Fractal Double Red', '"Fractal Double Red" stands as a masterful exploration of geometric abstraction, where precision meets emotional resonance in a stunning limited edition release. The artist''s sophisticated manipulation of deep reds, electric oranges, and royal blues creates a symmetrical symphony that radiates from a powerful central focal point. Through masterful digital techniques, the work achieves a remarkable balance between mathematical precision and artistic intuition, with semi-transparent layers creating rich interactions between primary and secondary hues. The composition''s architectural framework, built upon intersecting triangular and rectangular forms, generates a mesmerizing sense of depth and movement that draws viewers into its complex geometric landscape. This museum-quality piece exemplifies the evolution of contemporary abstract art, bridging classical constructivist principles with cutting-edge digital aesthetics.', NULL, 
        'VividWalls', 'Artwork',
        '{"Fractal"}', 'active', 
        'Abstract Art, Wall Art, Ready-To-Hang, Collection Fractal Fractal Double Red 72x53, Black Frame Artwork', 
        '"Fractal Double Red" stands as a masterful exploration of geometric abstraction, where precision meets emotional resonance in a stunning limited edition release. The artist''s sophisticated manipulation of deep reds, electric oranges, and royal blues creates a symmetrical symphony that radiates from a powerful central focal point. Through masterful digital techniques, the work achieves a remarkable balance between mathematical precision and artistic intuition, with semi-transparent layers creating rich interactions between primary and secondary hues. The composition''s architectural framework, built upon intersecting triangular and rectangular forms, generates a mesmerizing sense of depth and movement that draws viewers into its complex geometric landscape. This museum-quality piece exemplifies the evolution of contemporary abstract art, bridging classical constructivist principles with cutting-edge digital aesthetics.');

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('1fa21f13-8d60-432b-86c8-1f023e591b34', '7d499927-db1d-4312-a6a5-f631d2e3c7d7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Fractal-Red-002_BlkFrame-72x53_f1c4d256-de8f-489b-b801-f91783670e33.png?v=1713720866', 'fractal-double-red Posters, Prints, & Visual Artwork 24x36 Gallery Wrapped Stretched Canvas', 1);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('f22df961-7b0c-41ab-8e0d-c3bf00142309', '7d499927-db1d-4312-a6a5-f631d2e3c7d7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Fractal-Red-002_WhtFrame-72x53_6d4fed8e-d4c0-4126-9822-c635112ca4ef.png?v=1713720866', 'fractal-double-red Posters, Prints, & Visual Artwork 24x36 Canvas Roll', 2);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('48c4b77f-558c-4cd2-9f41-356aaf091d9b', '7d499927-db1d-4312-a6a5-f631d2e3c7d7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Fractal-Red-002_NoFrame-72x53_230e986f-34dc-4172-9261-4ab1d85be775.png?v=1713720866', 'fractal-double-red Posters, Prints, & Visual Artwork 36x48 Gallery Wrapped Stretched Canvas', 3);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('ca6f5d51-ab37-4abb-90dd-95c1616fb669', '7d499927-db1d-4312-a6a5-f631d2e3c7d7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Fractal-Red-no2_Black-Frame-48x36_89c62ace-2af7-4966-811c-0e9aae57fac4.png?v=1713720866', 'fractal-double-red Posters, Prints, & Visual Artwork 36x48 Canvas Roll', 4);

INSERT INTO product_images (id, product_id, src, alt_text, position)
VALUES ('0bc4383f-4af1-431c-b15c-1738f1b3ddb5', '7d499927-db1d-4312-a6a5-f631d2e3c7d7', 'https://cdn.shopify.com/s/files/1/0785/1504/4639/files/Fractal-Red-no2_White-Frame-48x36_9fbf05db-070f-43b7-88be-74a043acd7ae.png?v=1713720866', 'fractal-double-red Posters, Prints, & Visual Artwork 53x72 Gallery Wrapped Stretched Canvas', 5);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('a284c440-48c6-490c-9b51-19eb505756d6', '7d499927-db1d-4312-a6a5-f631d2e3c7d7', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-DOUBLE-RED-GALLERY-WRAPPED-CANVAS-24X36', 204.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('95d494b8-1910-4e84-93b8-7df3f1c9ea59', '7d499927-db1d-4312-a6a5-f631d2e3c7d7', '6619147d-d05d-47e6-921c-0ef267dc0b4f', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-DOUBLE-RED-CANVAS-ROLL-24X36', 153.0, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('ff6d0159-c093-4dd2-9c11-7b08c475c4a0', '7d499927-db1d-4312-a6a5-f631d2e3c7d7', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-DOUBLE-RED-GALLERY-WRAPPED-CANVAS-36X48', 315.94, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('c1c33fe6-f43c-4761-b2f6-0c5a3994d4c6', '7d499927-db1d-4312-a6a5-f631d2e3c7d7', '48cc61d0-de1b-4006-a738-81a96c6ea0f9', '189ea524-bde2-42b4-ba1b-0671a2cd7a65', 
        'FRACTAL-DOUBLE-RED-CANVAS-ROLL-36X48', 237.18, NULL, 0.0);

INSERT INTO product_variants (id, product_id, size_id, print_type_id, sku, 
                            price, compare_at_price, weight_grams)
VALUES ('2d8593c1-80a5-42b4-8a5c-6d1651f2d97d', '7d499927-db1d-4312-a6a5-f631d2e3c7d7', 'e76a397a-7832-4438-9754-2b91a8c3f50e', '6991bc95-aafb-4b40-a511-caf2992a3f30', 
        'FRACTAL-DOUBLE-RED-GALLERY-WRAPPED-CANVAS-53X72', 550.92, NULL, 0.0);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('ddac49c7-fb44-4d5d-81cc-536d59e6e09e', '125c76b5-f0c4-4444-afae-6c5efe3f36c7', 'What types of abstract art collections are available at Vivid Walls?', 'Vivid Walls offers a diverse range of abstract art collections, including Geometric Intersection, Geometric Symmetry, Chromatic Echoes, Shape Emergence, Fractal Color, Mosaics, Vivid Layers, and Intersecting Spaces.', '{"Abstract art","Collections"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('31892d2e-77a2-487d-b484-2872fb86f8ec', '27d9233b-30f2-49ba-a5e3-f880de610ac0', 'Can I customize the size of an artwork?', 'Yes, we offer customization options for artwork sizes to fit your specific space requirements. Please contact our support team for more details.', '{"Customization","Sizing"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('f6999ee9-a952-4a43-906f-0c5dfa408f5e', NULL, 'What materials are used in your artworks?', 'Our artworks are created using high-quality canvases and premium inks to ensure vibrant colors and longevity.', '{"Materials","Quality"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('ac5cd139-922e-4eb5-95c9-60af9003c62e', '27d9233b-30f2-49ba-a5e3-f880de610ac0', 'Do you offer framing options?', 'Yes, we provide various framing options, including different colors and styles, to complement your chosen artwork.', '{"Framing","Customization"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('5d092d53-8526-44b9-a46d-f3764dae6aca', NULL, 'What is the price range of your artworks?', 'Our artworks start from $400 USD, with prices varying based on size and framing options.', '{"Pricing","Products"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('90140ec6-1ef0-4162-9fc4-182ba6bf3cd2', NULL, 'How can I place an order?', 'You can place an order directly through our website by selecting your desired artwork and following the checkout process.', '{"Ordering","Online purchase"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('4b01cb00-6831-4030-a599-ce4025c83778', 'cbcf5338-0da5-4bca-98a6-a965116a6133', 'What payment methods do you accept?', 'We accept various payment methods, including American Express, Apple Pay, Diners Club, Discover, Meta Pay, Google Pay, Mastercard, PayPal, Shop Pay, Venmo, and Visa.', '{"Payment","Transactions"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('e0f7ed43-e3da-47be-a213-9d5176abfad5', '08cc7416-ad35-40d6-aefb-b260bc3f3527', 'Do you ship internationally?', 'Yes, we offer international shipping to various countries. Shipping costs and delivery times may vary based on location.', '{"Shipping","International"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('93f57fde-cb18-4306-94ae-19a153376d3f', '08cc7416-ad35-40d6-aefb-b260bc3f3527', 'How long does delivery take?', 'Delivery times vary depending on your location and the chosen shipping method. Typically, orders are processed within 5-7 business days.', '{"Shipping","Delivery times"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('0d355faf-9ad1-48b1-8756-a024d5a5a457', '08cc7416-ad35-40d6-aefb-b260bc3f3527', 'Is there a shipping policy I can review?', 'Yes, you can review our detailed shipping policy on our website under the ''Shipping Policy'' section.', '{"Shipping","Policies"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('4dcdb5bc-69d0-4d50-9d03-63948a1c03ba', '08cc7416-ad35-40d6-aefb-b260bc3f3527', 'Can I track my order?', 'Yes, once your order is shipped, you will receive a tracking number via email to monitor your shipment.', '{"Shipping","Order tracking"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('7bd934eb-8c96-4f54-a2b9-1f12ee22536f', '2798312f-1f32-4721-acff-7f46414c72ab', 'What if my artwork arrives damaged?', 'If your artwork arrives damaged, please contact our customer service within 7 days of delivery for assistance with a replacement or refund.', '{"Customer service","Returns"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('95f2e41f-0ad1-43e6-affd-0a36292fdec3', '2798312f-1f32-4721-acff-7f46414c72ab', 'Do you offer returns or exchanges?', 'Yes, we have a return and exchange policy. Please refer to our ''Refund Policy'' on the website for detailed information.', '{"Returns","Exchanges"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('88a476fc-b5e3-41ac-bda6-ddf2e63fd6ec', '27d9233b-30f2-49ba-a5e3-f880de610ac0', 'Can I request a custom artwork?', 'Yes, we accept custom artwork requests. Please reach out to our artist through the ''Contact'' page to discuss your vision.', '{"Customization","Commission"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('062cbe90-bbc6-47b4-963f-c9e44bbbee23', '125c76b5-f0c4-4444-afae-6c5efe3f36c7', 'Who is the artist behind Vivid Walls?', 'Our artworks are created by a talented artist dedicated to producing unique abstract pieces. More information is available on the ''Artist'' page.', '{"Artist","About Us"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('396c9b84-e09a-4f6e-8e8b-417317e493ea', '125c76b5-f0c4-4444-afae-6c5efe3f36c7', 'What is the inspiration behind the artworks?', 'Our pieces are inspired by geometric abstraction, color theory, and emotional expression, blending modern design with timeless artistic principles.', '{"Inspiration","Abstract art"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('3698d011-c070-4336-9f25-48828ec11603', NULL, 'Do you offer bulk pricing for businesses?', 'Yes, we offer special pricing for bulk purchases. Please contact us for wholesale inquiries.', '{"Wholesale","Business"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('8006f04c-d2fe-433f-8831-3ba27117655d', NULL, 'What types of businesses benefit from Vivid Walls art?', 'Our artworks are ideal for offices, restaurants, hotels, and residential spaces looking to enhance their ambiance with high-quality abstract pieces.', '{"Office decor","Hospitality","Home decoration"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('eb156ba3-b685-4a32-9fbc-bd5bc25a1c09', '125c76b5-f0c4-4444-afae-6c5efe3f36c7', 'How do I choose the right artwork for my space?', 'Consider your space’s color palette, lighting, and intended atmosphere. We also offer consultation services to help you select the perfect piece.', '{"Interior design","Art selection"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('2af9c841-eb8a-499e-a4b3-1f8e237f5f65', '27d9233b-30f2-49ba-a5e3-f880de610ac0', 'Can I get a digital preview before purchasing?', 'Yes, we offer digital previews to help visualize how an artwork will look in your space. Contact us for details.', '{"Preview","Customization"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('ae1999ce-c3f6-412e-ae5a-67432f9a7588', NULL, 'Are your artworks limited editions?', 'Yes, many of our pieces are available as limited edition prints, ensuring exclusivity for our customers.', '{"Limited edition","Products"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('9e6af2e2-7d59-414e-9b08-23773b0ff763', NULL, 'What mediums are used in your artworks?', 'Our artist primarily works with acrylics and digital media, producing vibrant and lasting pieces.', '{"Mediums","Materials"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('a7413b91-5296-4dc0-9643-782c50ee982d', '125c76b5-f0c4-4444-afae-6c5efe3f36c7', 'How should I care for my artwork?', 'To maintain your artwork''s quality, avoid direct sunlight, dust it regularly with a soft cloth, and keep it away from moisture.', '{"Artwork care","Maintenance"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('0089a070-4b7e-4348-9358-305978ca3611', NULL, 'Do you collaborate with interior designers?', 'Yes, we welcome collaborations with interior designers to provide art solutions tailored to specific projects.', '{"Collaboration","Interior design"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('68697b67-c27e-4d3e-9d92-de1fe2cfa722', NULL, 'Can I see the artwork in person before purchasing?', 'Currently, we operate exclusively online, but we provide high-resolution images and detailed descriptions to assist your decision.', '{"Online gallery","Viewing"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('7443e395-be8c-4f1e-a61d-604f15e49929', '27d9233b-30f2-49ba-a5e3-f880de610ac0', 'What sizes are available for your artworks?', 'Our artworks come in various sizes, and we also offer custom sizing to fit your specific needs.', '{"Sizing","Customization"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('4c2315bb-63df-4e4e-9027-f30cf7aae805', NULL, 'Do you offer gift cards?', 'Yes, we offer gift cards in various denominations, perfect for gifting art to others.', '{"Gift cards","Products"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('8b6c784a-3464-4469-8b71-0595639d83c3', NULL, 'Is there a newsletter I can subscribe to?', 'Yes, you can subscribe to our newsletter on our website to receive updates on new collections and exclusive offers.', '{"Newsletter","Updates"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('7a680c63-80f0-4329-a05f-f002e77d567f', NULL, 'How can I contact customer support?', 'You can reach our customer support through the ''Contact'' page on our website or by emailing support@vividwalls.co.', '{"Customer support","Contact"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('7dcc9e23-a7d8-4b14-a393-3c301be47a00', NULL, 'Do you offer installation services?', 'While we don''t provide installation services, we include hanging hardware and instructions with each artwork.', '{"Installation","Support"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('284e618e-a60b-43db-a6cf-9bb7f785e758', NULL, 'Are there any ongoing promotions?', 'We periodically offer promotions and discounts. Subscribe to our newsletter or follow us on social media for updates.', '{"Promotions","Discounts"}', true);

INSERT INTO qa_entries (id, category_id, question, answer, tags, is_published)
VALUES ('7c0a609c-522d-4a38-ba33-5aedc9270079', NULL, 'Can I purchase a digital copy of an artwork?', 'Currently, we only offer physical prints and ', '{}', true);

-- Update inventory for SKU: CRIMSON-SHADE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'CRIMSON-SHADE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRIMSON-SHADE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'CRIMSON-SHADE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRIMSON-SHADE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'CRIMSON-SHADE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRIMSON-SHADE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'CRIMSON-SHADE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRIMSON-SHADE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'CRIMSON-SHADE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRIMSON-SHADE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'CRIMSON-SHADE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRIMSON-SHADE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'CRIMSON-SHADE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRIMSON-SHADE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'CRIMSON-SHADE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRIMSON-SHADE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'CRIMSON-SHADE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRIMSON-SHADE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'CRIMSON-SHADE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRIMSON-SHADE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'CRIMSON-SHADE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRIMSON-SHADE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'CRIMSON-SHADE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRYSTALLINE-BLUE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'CRYSTALLINE-BLUE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRYSTALLINE-BLUE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'CRYSTALLINE-BLUE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRYSTALLINE-BLUE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'CRYSTALLINE-BLUE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRYSTALLINE-BLUE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'CRYSTALLINE-BLUE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRYSTALLINE-BLUE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'CRYSTALLINE-BLUE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRYSTALLINE-BLUE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'CRYSTALLINE-BLUE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRYSTALLINE-BLUE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'CRYSTALLINE-BLUE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRYSTALLINE-BLUE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'CRYSTALLINE-BLUE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRYSTALLINE-BLUE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'CRYSTALLINE-BLUE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRYSTALLINE-BLUE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'CRYSTALLINE-BLUE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRYSTALLINE-BLUE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'CRYSTALLINE-BLUE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: CRYSTALLINE-BLUE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'CRYSTALLINE-BLUE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: DARK-KIMONO-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'DARK-KIMONO-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: DARK-KIMONO-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'DARK-KIMONO-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: DARK-KIMONO-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'DARK-KIMONO-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: DARK-KIMONO-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'DARK-KIMONO-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: DARK-KIMONO-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'DARK-KIMONO-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: DARK-KIMONO-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'DARK-KIMONO-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: DARK-KIMONO-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'DARK-KIMONO-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: DARK-KIMONO-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'DARK-KIMONO-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: DARK-KIMONO-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'DARK-KIMONO-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: DARK-KIMONO-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'DARK-KIMONO-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: DARK-KIMONO-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'DARK-KIMONO-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: DARK-KIMONO-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'DARK-KIMONO-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTH-ECHOES-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTH-ECHOES-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTH-ECHOES-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTH-ECHOES-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTH-ECHOES-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTH-ECHOES-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTH-ECHOES-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTH-ECHOES-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTH-ECHOES-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTH-ECHOES-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTH-ECHOES-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTH-ECHOES-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTH-ECHOES-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTH-ECHOES-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTH-ECHOES-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTH-ECHOES-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTH-ECHOES-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTH-ECHOES-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTH-ECHOES-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTH-ECHOES-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTH-ECHOES-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTH-ECHOES-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTH-ECHOES-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTH-ECHOES-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-KIMONO-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-KIMONO-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-KIMONO-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-KIMONO-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-KIMONO-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-KIMONO-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-KIMONO-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-KIMONO-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-KIMONO-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-KIMONO-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-KIMONO-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-KIMONO-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-KIMONO-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-KIMONO-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-KIMONO-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-KIMONO-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-KIMONO-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-KIMONO-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-KIMONO-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-KIMONO-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-KIMONO-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-KIMONO-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-KIMONO-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-KIMONO-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-SHADE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-SHADE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-SHADE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-SHADE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-SHADE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-SHADE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-SHADE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-SHADE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-SHADE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-SHADE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-SHADE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-SHADE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-SHADE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-SHADE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-SHADE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-SHADE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-SHADE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-SHADE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-SHADE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-SHADE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-SHADE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-SHADE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-SHADE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-SHADE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-WEAVE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-WEAVE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-WEAVE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-WEAVE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-WEAVE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-WEAVE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-WEAVE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-WEAVE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-WEAVE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-WEAVE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-WEAVE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-WEAVE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-WEAVE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-WEAVE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-WEAVE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-WEAVE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-WEAVE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-WEAVE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-WEAVE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-WEAVE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-WEAVE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-WEAVE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EARTHY-WEAVE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EARTHY-WEAVE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EMERALD-SHADE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'EMERALD-SHADE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EMERALD-SHADE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EMERALD-SHADE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EMERALD-SHADE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'EMERALD-SHADE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EMERALD-SHADE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EMERALD-SHADE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EMERALD-SHADE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'EMERALD-SHADE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EMERALD-SHADE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EMERALD-SHADE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EMERALD-SHADE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'EMERALD-SHADE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EMERALD-SHADE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EMERALD-SHADE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EMERALD-SHADE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'EMERALD-SHADE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EMERALD-SHADE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EMERALD-SHADE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EMERALD-SHADE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'EMERALD-SHADE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: EMERALD-SHADE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'EMERALD-SHADE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO2-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO2-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO2-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO2-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO2-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO2-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO2-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO2-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO2-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO2-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO2-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO2-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO2-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO2-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO2-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO2-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO2-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO2-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO2-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO2-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO2-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO2-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO2-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO2-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO3-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO3-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO3-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO3-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO3-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO3-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO3-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO3-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO3-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO3-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO3-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO3-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO3-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO3-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO3-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO3-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO3-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO3-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO3-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO3-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO3-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO3-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FESTIVE-PATTERNS-NO3-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FESTIVE-PATTERNS-NO3-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-DOUBLE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-DOUBLE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-DOUBLE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-DOUBLE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-DOUBLE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-DOUBLE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-DOUBLE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-DOUBLE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-DOUBLE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-DOUBLE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-DOUBLE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-DOUBLE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-DOUBLE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-DOUBLE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-DOUBLE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-DOUBLE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-DOUBLE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-DOUBLE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-DOUBLE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-DOUBLE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-DOUBLE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-DOUBLE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-DARK-DOUBLE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-DARK-DOUBLE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-LIGHT-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-LIGHT-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-LIGHT-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-LIGHT-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-LIGHT-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-LIGHT-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-LIGHT-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-LIGHT-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-LIGHT-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-LIGHT-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-LIGHT-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-LIGHT-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-LIGHT-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-LIGHT-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-LIGHT-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-LIGHT-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-LIGHT-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-LIGHT-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-LIGHT-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-LIGHT-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-LIGHT-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-LIGHT-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-LIGHT-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-LIGHT-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-RED-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-RED-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-RED-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-RED-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-RED-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-RED-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-RED-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-RED-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-RED-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-RED-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-RED-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-RED-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-RED-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-RED-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-RED-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-RED-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-RED-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-RED-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-RED-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-RED-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-RED-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-RED-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-COLOR-RED-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-COLOR-RED-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-DOUBLE-RED-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-DOUBLE-RED-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-DOUBLE-RED-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-DOUBLE-RED-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-DOUBLE-RED-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-DOUBLE-RED-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-DOUBLE-RED-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-DOUBLE-RED-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-DOUBLE-RED-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-DOUBLE-RED-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-DOUBLE-RED-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-DOUBLE-RED-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-DOUBLE-RED-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-DOUBLE-RED-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-DOUBLE-RED-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-DOUBLE-RED-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-DOUBLE-RED-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-DOUBLE-RED-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-DOUBLE-RED-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-DOUBLE-RED-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-DOUBLE-RED-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-DOUBLE-RED-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-DOUBLE-RED-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-DOUBLE-RED-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-DOUBLE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-DOUBLE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-DOUBLE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-DOUBLE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-DOUBLE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-DOUBLE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-DOUBLE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-DOUBLE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-DOUBLE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-DOUBLE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-DOUBLE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-DOUBLE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-DOUBLE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-DOUBLE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-DOUBLE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-DOUBLE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-DOUBLE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-DOUBLE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-DOUBLE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-DOUBLE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-DOUBLE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-DOUBLE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: FRACTAL-NOIR-DOUBLE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'FRACTAL-NOIR-DOUBLE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO2-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO2-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO2-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO2-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO2-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO2-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO2-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO2-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO2-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO2-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO2-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO2-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO2-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO2-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO2-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO2-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO2-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO2-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO2-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO2-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO2-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO2-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO2-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO2-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO3-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO3-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO3-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO3-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO3-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO3-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO3-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO3-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO3-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO3-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO3-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO3-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO3-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO3-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO3-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO3-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO3-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO3-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO3-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO3-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO3-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO3-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: INTERSECTING-PERSPECTIVES-NO3-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'INTERSECTING-PERSPECTIVES-NO3-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: MONOCHROME-KIMONO-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'MONOCHROME-KIMONO-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: MONOCHROME-KIMONO-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'MONOCHROME-KIMONO-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: MONOCHROME-KIMONO-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'MONOCHROME-KIMONO-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: MONOCHROME-KIMONO-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'MONOCHROME-KIMONO-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: MONOCHROME-KIMONO-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'MONOCHROME-KIMONO-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: MONOCHROME-KIMONO-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'MONOCHROME-KIMONO-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: MONOCHROME-KIMONO-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'MONOCHROME-KIMONO-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: MONOCHROME-KIMONO-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'MONOCHROME-KIMONO-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: MONOCHROME-KIMONO-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'MONOCHROME-KIMONO-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: MONOCHROME-KIMONO-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'MONOCHROME-KIMONO-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: MONOCHROME-KIMONO-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'MONOCHROME-KIMONO-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: MONOCHROME-KIMONO-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'MONOCHROME-KIMONO-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO2-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO2-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO2-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO2-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO2-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO2-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO2-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO2-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO2-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO2-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO2-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO2-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO3-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO3-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO3-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO3-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO3-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO3-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO3-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO3-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO3-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO3-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO3-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO3-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-SHADE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-SHADE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-SHADE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-SHADE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-SHADE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-SHADE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-SHADE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-SHADE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-SHADE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-SHADE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-SHADE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-SHADE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-SHADE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-SHADE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-SHADE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-SHADE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-SHADE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-SHADE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-SHADE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-SHADE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-SHADE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-SHADE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-SHADE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-SHADE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-STRUCTURES-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-STRUCTURES-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-STRUCTURES-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-STRUCTURES-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-STRUCTURES-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-STRUCTURES-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-STRUCTURES-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-STRUCTURES-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-STRUCTURES-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-STRUCTURES-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-STRUCTURES-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-STRUCTURES-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-STRUCTURES-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-STRUCTURES-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-STRUCTURES-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-STRUCTURES-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-STRUCTURES-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-STRUCTURES-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-STRUCTURES-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-STRUCTURES-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-STRUCTURES-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-STRUCTURES-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-STRUCTURES-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-STRUCTURES-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-WEAVE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-WEAVE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-WEAVE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-WEAVE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-WEAVE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-WEAVE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-WEAVE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-WEAVE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-WEAVE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-WEAVE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-WEAVE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-WEAVE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-WEAVE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-WEAVE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-WEAVE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-WEAVE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-WEAVE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-WEAVE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-WEAVE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-WEAVE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-WEAVE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-WEAVE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: NOIR-WEAVE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'NOIR-WEAVE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: OLIVE-WEAVE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'OLIVE-WEAVE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: OLIVE-WEAVE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'OLIVE-WEAVE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: OLIVE-WEAVE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'OLIVE-WEAVE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: OLIVE-WEAVE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'OLIVE-WEAVE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: OLIVE-WEAVE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'OLIVE-WEAVE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: OLIVE-WEAVE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'OLIVE-WEAVE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: OLIVE-WEAVE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'OLIVE-WEAVE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: OLIVE-WEAVE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'OLIVE-WEAVE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: OLIVE-WEAVE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'OLIVE-WEAVE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: OLIVE-WEAVE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'OLIVE-WEAVE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: OLIVE-WEAVE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'OLIVE-WEAVE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: OLIVE-WEAVE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'OLIVE-WEAVE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO2-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO2-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO2-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO2-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO2-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO2-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO2-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO2-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO2-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO2-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO2-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO2-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO2-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO2-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO2-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO2-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO2-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO2-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO2-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO2-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO2-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO2-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PARALLELOGRAM-ILLUSION-NO2-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PARALLELOGRAM-ILLUSION-NO2-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PINK-WEAVE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'PINK-WEAVE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PINK-WEAVE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PINK-WEAVE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PINK-WEAVE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'PINK-WEAVE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PINK-WEAVE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PINK-WEAVE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PINK-WEAVE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'PINK-WEAVE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PINK-WEAVE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PINK-WEAVE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PINK-WEAVE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'PINK-WEAVE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PINK-WEAVE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PINK-WEAVE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PINK-WEAVE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'PINK-WEAVE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PINK-WEAVE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PINK-WEAVE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PINK-WEAVE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'PINK-WEAVE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PINK-WEAVE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PINK-WEAVE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRIMARY-HUE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'PRIMARY-HUE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRIMARY-HUE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PRIMARY-HUE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRIMARY-HUE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'PRIMARY-HUE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRIMARY-HUE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PRIMARY-HUE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRIMARY-HUE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'PRIMARY-HUE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRIMARY-HUE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PRIMARY-HUE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRIMARY-HUE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'PRIMARY-HUE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRIMARY-HUE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PRIMARY-HUE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRIMARY-HUE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'PRIMARY-HUE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRIMARY-HUE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PRIMARY-HUE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRIMARY-HUE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'PRIMARY-HUE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRIMARY-HUE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PRIMARY-HUE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRISMATIC-WARMTH-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'PRISMATIC-WARMTH-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRISMATIC-WARMTH-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PRISMATIC-WARMTH-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRISMATIC-WARMTH-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'PRISMATIC-WARMTH-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRISMATIC-WARMTH-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PRISMATIC-WARMTH-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRISMATIC-WARMTH-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'PRISMATIC-WARMTH-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRISMATIC-WARMTH-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PRISMATIC-WARMTH-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRISMATIC-WARMTH-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'PRISMATIC-WARMTH-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRISMATIC-WARMTH-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PRISMATIC-WARMTH-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRISMATIC-WARMTH-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'PRISMATIC-WARMTH-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRISMATIC-WARMTH-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PRISMATIC-WARMTH-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRISMATIC-WARMTH-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'PRISMATIC-WARMTH-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PRISMATIC-WARMTH-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PRISMATIC-WARMTH-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PURPLE-SHADE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'PURPLE-SHADE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PURPLE-SHADE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PURPLE-SHADE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PURPLE-SHADE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'PURPLE-SHADE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PURPLE-SHADE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PURPLE-SHADE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PURPLE-SHADE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'PURPLE-SHADE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PURPLE-SHADE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PURPLE-SHADE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PURPLE-SHADE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'PURPLE-SHADE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PURPLE-SHADE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PURPLE-SHADE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PURPLE-SHADE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'PURPLE-SHADE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PURPLE-SHADE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PURPLE-SHADE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PURPLE-SHADE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'PURPLE-SHADE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: PURPLE-SHADE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'PURPLE-SHADE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RED-KIMONO-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'RED-KIMONO-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RED-KIMONO-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'RED-KIMONO-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RED-KIMONO-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'RED-KIMONO-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RED-KIMONO-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'RED-KIMONO-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RED-KIMONO-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'RED-KIMONO-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RED-KIMONO-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'RED-KIMONO-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RED-KIMONO-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'RED-KIMONO-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RED-KIMONO-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'RED-KIMONO-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RED-KIMONO-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'RED-KIMONO-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RED-KIMONO-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'RED-KIMONO-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RED-KIMONO-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'RED-KIMONO-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RED-KIMONO-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'RED-KIMONO-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-KIMONO-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-KIMONO-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-KIMONO-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-KIMONO-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-KIMONO-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-KIMONO-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-KIMONO-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-KIMONO-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-KIMONO-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-KIMONO-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-KIMONO-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-KIMONO-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-KIMONO-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-KIMONO-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-KIMONO-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-KIMONO-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-KIMONO-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-KIMONO-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-KIMONO-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-KIMONO-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-KIMONO-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-KIMONO-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-KIMONO-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-KIMONO-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-SHADE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-SHADE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-SHADE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-SHADE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-SHADE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-SHADE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-SHADE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-SHADE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-SHADE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-SHADE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-SHADE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-SHADE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-SHADE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-SHADE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-SHADE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-SHADE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-SHADE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-SHADE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-SHADE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-SHADE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-SHADE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-SHADE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: ROYAL-SHADE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'ROYAL-SHADE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RUSTY-SHADE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'RUSTY-SHADE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RUSTY-SHADE-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'RUSTY-SHADE-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RUSTY-SHADE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'RUSTY-SHADE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RUSTY-SHADE-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'RUSTY-SHADE-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RUSTY-SHADE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'RUSTY-SHADE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RUSTY-SHADE-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'RUSTY-SHADE-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RUSTY-SHADE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'RUSTY-SHADE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RUSTY-SHADE-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'RUSTY-SHADE-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RUSTY-SHADE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'RUSTY-SHADE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RUSTY-SHADE-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'RUSTY-SHADE-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RUSTY-SHADE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'RUSTY-SHADE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: RUSTY-SHADE-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'RUSTY-SHADE-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO2-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO2-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO2-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO2-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO2-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO2-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO2-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO2-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO2-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO2-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO2-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO2-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO2-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO2-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO2-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO2-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO2-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO2-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO2-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO2-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO2-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO2-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO2-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO2-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO3-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO3-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO3-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO3-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO3-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO3-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO3-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO3-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO3-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO3-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO3-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO3-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO3-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO3-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO3-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO3-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO3-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO3-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO3-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO3-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO3-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO3-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: SPACE-FORM-NO3-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'SPACE-FORM-NO3-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO2-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO2-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO2-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO2-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO2-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO2-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO2-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO2-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO2-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO2-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO2-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO2-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO2-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO2-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO2-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO2-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO2-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO2-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO2-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO2-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO2-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO2-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: STRUCTURED-NOIR-NO2-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'STRUCTURED-NOIR-NO2-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-EARTH-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-EARTH-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-EARTH-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-EARTH-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-EARTH-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-EARTH-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-EARTH-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-EARTH-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-EARTH-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-EARTH-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-EARTH-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-EARTH-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-EARTH-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-EARTH-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-EARTH-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-EARTH-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-EARTH-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-EARTH-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-EARTH-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-EARTH-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-EARTH-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-EARTH-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-EARTH-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-EARTH-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-KIMONO-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-KIMONO-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-KIMONO-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-KIMONO-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-KIMONO-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-KIMONO-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-KIMONO-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-KIMONO-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-KIMONO-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-KIMONO-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-KIMONO-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-KIMONO-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-KIMONO-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-KIMONO-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-KIMONO-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-KIMONO-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-KIMONO-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-KIMONO-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-KIMONO-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-KIMONO-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-KIMONO-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-KIMONO-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEAL-KIMONO-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEAL-KIMONO-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-NOIR-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-NOIR-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-NOIR-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-NOIR-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-NOIR-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-NOIR-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-NOIR-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-NOIR-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-NOIR-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-NOIR-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-NOIR-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-NOIR-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-NOIR-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-ROYAL-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-ROYAL-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-ROYAL-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-ROYAL-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-ROYAL-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-ROYAL-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-ROYAL-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-ROYAL-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-ROYAL-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-ROYAL-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-ROYAL-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-ROYAL-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-ROYAL-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-ROYAL-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-ROYAL-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-ROYAL-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-ROYAL-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-ROYAL-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-ROYAL-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-ROYAL-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-ROYAL-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-ROYAL-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: TEXTURED-ROYAL-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'TEXTURED-ROYAL-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: UNTILED-N011-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'UNTILED-N011-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: UNTILED-N011-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'UNTILED-N011-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: UNTILED-N011-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'UNTILED-N011-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: UNTILED-N011-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'UNTILED-N011-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: UNTILED-N011-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'UNTILED-N011-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: UNTILED-N011-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'UNTILED-N011-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: UNTILED-N011-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'UNTILED-N011-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: UNTILED-N011-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'UNTILED-N011-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: UNTILED-N011-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'UNTILED-N011-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: UNTILED-N011-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'UNTILED-N011-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: UNTILED-N011-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'UNTILED-N011-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: UNTILED-N011-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'UNTILED-N011-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VERDANT-LAYERS-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VERDANT-LAYERS-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VERDANT-LAYERS-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VERDANT-LAYERS-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VERDANT-LAYERS-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VERDANT-LAYERS-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VERDANT-LAYERS-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VERDANT-LAYERS-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VERDANT-LAYERS-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VERDANT-LAYERS-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VERDANT-LAYERS-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VERDANT-LAYERS-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VERDANT-LAYERS-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VERDANT-LAYERS-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VERDANT-LAYERS-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VERDANT-LAYERS-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VERDANT-LAYERS-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VERDANT-LAYERS-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VERDANT-LAYERS-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VERDANT-LAYERS-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VERDANT-LAYERS-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VERDANT-LAYERS-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VERDANT-LAYERS-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VERDANT-LAYERS-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VISTA-ECHOES-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VISTA-ECHOES-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VISTA-ECHOES-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VISTA-ECHOES-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VISTA-ECHOES-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VISTA-ECHOES-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VISTA-ECHOES-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VISTA-ECHOES-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VISTA-ECHOES-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VISTA-ECHOES-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VISTA-ECHOES-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VISTA-ECHOES-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VISTA-ECHOES-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VISTA-ECHOES-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VISTA-ECHOES-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VISTA-ECHOES-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VISTA-ECHOES-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VISTA-ECHOES-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VISTA-ECHOES-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VISTA-ECHOES-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VISTA-ECHOES-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VISTA-ECHOES-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VISTA-ECHOES-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VISTA-ECHOES-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO1-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO1-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO1-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO1-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO1-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO1-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO1-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO2-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO2-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO2-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO2-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO2-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO2-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO2-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO2-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO2-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO2-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO2-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO2-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO2-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO3-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO3-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO3-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO3-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO3-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO3-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO3-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO3-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO3-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO3-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO3-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO3-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO3-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO5-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO5-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO5-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO5-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO5-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO5-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO5-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO5-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO5-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO5-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO5-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO5-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO5-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO5-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO5-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO5-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO5-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO5-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO5-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO5-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO5-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO5-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO5-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO5-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO6-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO6-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO6-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO6-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO6-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO6-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO6-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO6-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO6-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO6-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO6-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO6-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO6-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO6-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO6-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO6-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO6-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO6-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO6-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO6-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO6-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO6-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO6-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO6-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO7-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO7-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO7-CANVAS-ROLL-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO7-CANVAS-ROLL-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO7-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO7-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO7-CANVAS-ROLL-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO7-CANVAS-ROLL-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO7-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO7-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO7-CANVAS-ROLL-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO7-CANVAS-ROLL-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO7-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 150, 150, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO7-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO7-GALLERY-WRAPPED-CANVAS-24X36
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO7-GALLERY-WRAPPED-CANVAS-24X36'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO7-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 105, 105, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO7-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO7-GALLERY-WRAPPED-CANVAS-36X48
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO7-GALLERY-WRAPPED-CANVAS-36X48'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO7-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, '409ef3c4-c237-44cd-923e-97c5b40f5015', 45, 45, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO7-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Update inventory for SKU: VIVID-MOSAIC-NO7-GALLERY-WRAPPED-CANVAS-53X72
INSERT INTO inventory_levels (variant_id, location_id, available, on_hand, incoming, committed)
SELECT v.id, 'd9517d87-3982-487d-933f-fd1afdc73b81', 0, 0, 0, 0
FROM product_variants v
WHERE v.sku = 'VIVID-MOSAIC-NO7-GALLERY-WRAPPED-CANVAS-53X72'
ON CONFLICT (variant_id, location_id) 
DO UPDATE SET 
    available = EXCLUDED.available,
    on_hand = EXCLUDED.on_hand,
    incoming = EXCLUDED.incoming,
    committed = EXCLUDED.committed,
    updated_at = NOW();

-- Commit transaction
COMMIT;