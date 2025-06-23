-- Verify Multi-Agent System Schema
-- Run this in Supabase SQL Editor to check if tables were created

-- 1. List all agent-related tables
SELECT 
    table_name,
    (xpath('/row/c/text()', query_to_xml(format('SELECT COUNT(*) AS c FROM %I.%I', table_schema, table_name), FALSE, TRUE, '')))[1]::text::int AS row_count
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name LIKE 'agent%'
ORDER BY table_name;

-- 2. Check table structure for main agents table
SELECT 
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name = 'agents'
ORDER BY ordinal_position;

-- 3. Check foreign key relationships
SELECT
    tc.table_name AS child_table,
    kcu.column_name AS child_column,
    ccu.table_name AS parent_table,
    ccu.column_name AS parent_column
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
AND tc.table_schema = 'public'
AND (tc.table_name LIKE 'agent%' OR ccu.table_name LIKE 'agent%')
ORDER BY tc.table_name;

-- 4. Summary
SELECT 
    'Tables Created' as metric,
    COUNT(*) as value
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name LIKE 'agent%'
UNION ALL
SELECT 
    'Total Columns' as metric,
    COUNT(*) as value
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name LIKE 'agent%'
UNION ALL
SELECT 
    'Foreign Keys' as metric,
    COUNT(*) as value
FROM information_schema.table_constraints
WHERE constraint_type = 'FOREIGN KEY'
AND table_schema = 'public'
AND table_name LIKE 'agent%';