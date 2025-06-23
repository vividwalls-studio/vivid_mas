# Final Steps for Digital Ocean Supabase Data Insertion

## Problem Summary
- The existing database schema is different from the SQL files
- PostgREST API endpoint is not accessible (404 error)
- Direct SQL insertion fails due to schema mismatch

## Solution: Update Schema First, Then Insert

### Step 1: SSH into the droplet
```bash
ssh -i ~/.ssh/digitalocean root@157.230.13.13
# Enter passphrase: freedom
```

### Step 2: Navigate to project
```bash
cd /root/vivid_mas
```

### Step 3: Fix the schema
Create a schema update file:
```bash
cat > /tmp/fix_schema.sql << 'EOF'
-- Update schema to match the insertion SQL files
ALTER TABLE agents 
ADD COLUMN IF NOT EXISTS role VARCHAR(255),
ADD COLUMN IF NOT EXISTS backstory TEXT,
ADD COLUMN IF NOT EXISTS short_term_memory JSONB DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS long_term_memory JSONB DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS communication_preferences JSONB DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS avatar_url TEXT;

ALTER TABLE agent_voice_config
ADD COLUMN IF NOT EXISTS pace VARCHAR(255),
ADD COLUMN IF NOT EXISTS provider VARCHAR(255),
ADD COLUMN IF NOT EXISTS special_instructions TEXT;
EOF
```

Apply the schema updates:
```bash
docker exec -i supabase-db psql -U postgres -d postgres < /tmp/fix_schema.sql
```

### Step 4: Run SQL insertion
```bash
# Execute all SQL chunks
for i in {1..4}; do 
    echo "Executing chunk_00${i}.sql..."
    docker exec -i supabase-db psql -U postgres -d postgres < sql_chunks/chunk_00${i}.sql
done
```

### Step 5: Verify the insertion
```bash
# Check agent count
docker exec -i supabase-db psql -U postgres -d postgres -c "SELECT COUNT(*) FROM agents;"

# View sample agents
docker exec -i supabase-db psql -U postgres -d postgres -c "SELECT id, name, role FROM agents LIMIT 5;"

# Run full verification
docker exec -i supabase-db psql -U postgres -d postgres < scripts/verify_schema.sql
```

### Alternative: Use Python Script (if schema is fixed)
If you prefer the Python approach after fixing the schema:
```bash
# Install packages with system flag
pip3 install --break-system-packages requests psycopg2-binary

# Set environment variables
export SUPABASE_URL="https://supabase.vividwalls.blog"
export SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzQ5NjA0MDkxLCJleHAiOjIwNjQ5NjQwOTF9.I-ofdpcJwdSKKZ5rRN_DSnfp98iBH862UruU6XsNkcI"

# Run the script (modify it to auto-accept or use echo)
echo "y" | python3 scripts/postgrest_http_insert.py
```

### Alternative: Direct Database Connection
Since PostgREST is not working, you can also insert directly via database connection:
```bash
# Connect directly to the database
docker exec -it supabase-db psql -U postgres -d postgres

# Then manually run the SQL from each chunk file
```

## Notes
- The main issue is that the database schema doesn't match the SQL files
- PostgREST API is not accessible at the expected endpoint
- Once the schema is updated, the SQL insertion should work
- The ANON key is already known from the .env file

## Exit
```bash
exit
```