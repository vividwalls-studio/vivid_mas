-- Initialize test database with required extensions

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "vector";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Set up test user permissions
GRANT ALL PRIVILEGES ON DATABASE vivid_mas_test TO postgres;

-- Create test schema for test framework
CREATE SCHEMA IF NOT EXISTS test_mas;
GRANT ALL ON SCHEMA test_mas TO postgres;