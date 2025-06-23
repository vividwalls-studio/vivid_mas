-- Test queries for VividWalls knowledge base

-- Check data was loaded
SELECT metric, value FROM vividwalls_stats;

-- Sample some records
SELECT id, source_type, title, LEFT(content, 100) as content_preview
FROM vividwalls_knowledge
LIMIT 10;

-- Check embeddings
SELECT 
    k.title,
    e.chunk_index,
    LEFT(e.chunk_text, 100) as chunk_preview,
    e.token_count
FROM vividwalls_embeddings e
JOIN vividwalls_knowledge k ON k.id = e.knowledge_id
LIMIT 10;

-- To perform actual searches, you'll need to:
-- 1. Generate an embedding for your query using the same model
-- 2. Use the search_vividwalls function

-- Example structure (replace with real embedding):
-- SELECT * FROM search_vividwalls(
--     '[0.1, 0.2, ...]'::vector(384),
--     10,  -- number of results
--     'qa' -- optional source type filter
-- );

-- Search Q&A only
-- SELECT * FROM search_vividwalls('[...]'::vector(384), 10, 'qa');

-- Search products only
-- SELECT * FROM search_vividwalls('[...]'::vector(384), 10, 'product');
