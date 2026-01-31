#!/bin/bash

# Deploy Agent Knowledge Retrieval & Reasoning Engine
# This script sets up the complete knowledge retrieval and reasoning system for VividWalls MAS

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="/Volumes/SeagatePortableDrive/Projects/vivid_mas"
MCP_SERVER_PATH="$PROJECT_ROOT/services/mcp-servers/reasoning-engine"
SUPABASE_URL="https://supabase.vividwalls.blog"
NEO4J_URI="bolt://vividwalls-neo4j:7687"

echo -e "${BLUE}🚀 Deploying VividWalls Agent Knowledge Retrieval & Reasoning Engine${NC}"
echo "=================================================="

# Function to print status
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Step 1: Validate prerequisites
echo -e "\n${BLUE}Step 1: Validating Prerequisites${NC}"
echo "-----------------------------------"

# Check if required directories exist
if [ ! -d "$PROJECT_ROOT" ]; then
    print_error "Project root directory not found: $PROJECT_ROOT"
    exit 1
fi

if [ ! -d "$MCP_SERVER_PATH" ]; then
    print_error "MCP server directory not found: $MCP_SERVER_PATH"
    exit 1
fi

print_status "Project directories verified"

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 is required but not installed"
    exit 1
fi

print_status "Python 3 available"

# Check if required files exist
required_files=(
    "$PROJECT_ROOT/sql_chunks/agent_knowledge_domain_setup.sql"
    "$PROJECT_ROOT/services/neo4j/data/reasoning_patterns.cypher"
    "$MCP_SERVER_PATH/reasoning_engine_mcp.py"
    "$MCP_SERVER_PATH/requirements.txt"
)

for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        print_error "Required file not found: $file"
        exit 1
    fi
done

print_status "All required files present"

# Step 2: Install Python dependencies
echo -e "\n${BLUE}Step 2: Installing Python Dependencies${NC}"
echo "---------------------------------------"

cd "$MCP_SERVER_PATH"

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv venv
    print_status "Virtual environment created"
fi

# Activate virtual environment
source venv/bin/activate
print_status "Virtual environment activated"

# Install dependencies
echo "Installing Python dependencies..."
pip install -r requirements.txt
print_status "Dependencies installed"

# Step 3: Deploy database schema
echo -e "\n${BLUE}Step 3: Deploying Database Schema${NC}"
echo "-----------------------------------"

# Check if psql is available for direct database deployment
if command -v psql &> /dev/null; then
    print_warning "Using psql to deploy schema (requires database credentials)"
    echo "You may need to run the SQL manually if credentials are not configured"
    
    # Attempt to deploy schema (may require manual intervention)
    # psql "$SUPABASE_URL" -f "$PROJECT_ROOT/sql_chunks/agent_knowledge_domain_setup.sql" || true
    print_warning "SQL schema file ready for deployment: $PROJECT_ROOT/sql_chunks/agent_knowledge_domain_setup.sql"
else
    print_warning "psql not available. SQL schema must be deployed manually."
    echo "Please run the following SQL file in your Supabase SQL editor:"
    echo "$PROJECT_ROOT/sql_chunks/agent_knowledge_domain_setup.sql"
fi

# Step 4: Deploy Neo4j knowledge patterns
echo -e "\n${BLUE}Step 4: Deploying Neo4j Knowledge Patterns${NC}"
echo "--------------------------------------------"

print_warning "Neo4j Cypher script ready for deployment:"
echo "$PROJECT_ROOT/services/neo4j/data/reasoning_patterns.cypher"
echo ""
echo "Please run this script in your Neo4j browser or using cypher-shell:"
echo "cypher-shell -u neo4j -p vividwalls2024 -f $PROJECT_ROOT/services/neo4j/data/reasoning_patterns.cypher"

# Step 5: Test MCP server
echo -e "\n${BLUE}Step 5: Testing MCP Server${NC}"
echo "----------------------------"

# Test if the MCP server can start
echo "Testing MCP server startup..."
cd "$MCP_SERVER_PATH"

# Set environment variables for testing
export SUPABASE_URL="$SUPABASE_URL"
export SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzQ5NjA0MDkxLCJleHAiOjIwNjQ5NjQwOTF9.I-ofdpcJwdSKKZ5rRN_DSnfp98iBH862UruU6XsNkcI"
export NEO4J_URI="$NEO4J_URI"
export NEO4J_USER="neo4j"
export NEO4J_PASSWORD="vividwalls2024"
export LOG_LEVEL="info"

# Test server by importing it (basic syntax check)
python3 -c "
try:
    import sys
    sys.path.insert(0, '.')
    import reasoning_engine_mcp
    print('✓ MCP server imports successfully')
except Exception as e:
    print(f'✗ MCP server import failed: {e}')
    sys.exit(1)
"

if [ $? -eq 0 ]; then
    print_status "MCP server syntax validation passed"
else
    print_error "MCP server has syntax errors"
    exit 1
fi

# Step 6: Deploy n8n vector store configurations
echo -e "\n${BLUE}Step 6: Deploying n8n Vector Store Configurations${NC}"
echo "---------------------------------------------------"

vector_config_dir="$PROJECT_ROOT/services/n8n-vector-store-configs/agents"

if [ -d "$vector_config_dir" ]; then
    config_count=$(ls -1 "$vector_config_dir"/*.json 2>/dev/null | wc -l)
    print_status "Found $config_count agent vector store configurations"
    
    echo "Vector store configurations ready for n8n import:"
    ls -la "$vector_config_dir"/*.json 2>/dev/null || echo "No JSON configurations found"
else
    print_warning "Vector store configuration directory not found: $vector_config_dir"
fi

# Step 7: Create startup script
echo -e "\n${BLUE}Step 7: Creating Startup Script${NC}"
echo "---------------------------------"

startup_script="$MCP_SERVER_PATH/start_reasoning_engine.sh"

cat > "$startup_script" << 'EOF'
#!/bin/bash
# Reasoning Engine MCP Server Startup Script

# Navigate to server directory
cd "$(dirname "$0")"

# Activate virtual environment
source venv/bin/activate

# Set environment variables (customize as needed)
export SUPABASE_URL="${SUPABASE_URL:-https://supabase.vividwalls.blog}"
export SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzQ5NjA0MDkxLCJleHAiOjIwNjQ5NjQwOTF9.I-ofdpcJwdSKKZ5rRN_DSnfp98iBH862UruU6XsNkcI}"
export NEO4J_URI="${NEO4J_URI:-bolt://vividwalls-neo4j:7687}"
export NEO4J_USER="${NEO4J_USER:-neo4j}"
export NEO4J_PASSWORD="${NEO4J_PASSWORD:-vividwalls2024}"
export NEO4J_DATABASE="${NEO4J_DATABASE:-neo4j}"
export LOG_LEVEL="${LOG_LEVEL:-info}"

# Start the MCP server
echo "Starting Agent Reasoning Engine MCP Server..."
python3 reasoning_engine_mcp.py
EOF

chmod +x "$startup_script"
print_status "Startup script created: $startup_script"

# Step 8: Generate deployment summary
echo -e "\n${BLUE}Step 8: Deployment Summary${NC}"
echo "============================="

cat << EOF

${GREEN}🎉 Agent Knowledge Retrieval & Reasoning Engine Deployment Complete!${NC}

📁 Files Created/Updated:
   - MCP Server: $MCP_SERVER_PATH/reasoning_engine_mcp.py
   - Dependencies: $MCP_SERVER_PATH/requirements.txt
   - SQL Schema: $PROJECT_ROOT/sql_chunks/agent_knowledge_domain_setup.sql
   - Neo4j Patterns: $PROJECT_ROOT/services/neo4j/data/reasoning_patterns.cypher
   - MCP Config: $PROJECT_ROOT/configs/mcp/reasoning-engine-mcp-config.json
   - Startup Script: $startup_script

🔧 Manual Steps Required:

   1. Deploy SQL Schema:
      - Open Supabase SQL Editor
      - Run: $PROJECT_ROOT/sql_chunks/agent_knowledge_domain_setup.sql

   2. Deploy Neo4j Knowledge Patterns:
      - Open Neo4j Browser (http://localhost:7474)
      - Run: $PROJECT_ROOT/services/neo4j/data/reasoning_patterns.cypher

   3. Configure n8n MCP Client:
      - Import configuration from: $PROJECT_ROOT/configs/mcp/reasoning-engine-mcp-config.json
      - Test MCP connection in n8n workflows

   4. Import n8n Vector Store Configurations:
      - Import agent-specific vector node configs from: $vector_config_dir

🚀 To Start the Reasoning Engine:
   $startup_script

📊 Available Reasoning Methods:
   - Deductive Reasoning (rule-based)
   - Inductive Reasoning (pattern discovery)
   - Case-Based Reasoning (similarity matching)
   - Strategic Reasoning (goal optimization)
   - Analytical Reasoning (data analysis)
   - Holistic Reasoning (multi-method integration)
   - Creative Reasoning (innovative solutions)
   - Empathetic Reasoning (emotional understanding)

🎯 Agent Domain Mappings:
   - Business Manager: all_domains, business_strategy
   - Marketing Director: marketing, content, branding
   - Sales Director: sales, customer_segments, pricing
   - Analytics Director: analytics, metrics, forecasting
   - Operations Director: operations, inventory, logistics
   - Product Director: products, art_styles, collections
   - Customer Experience Director: customer_service, support, satisfaction
   - Finance Director: finance, accounting, budgeting
   - Technology Director: technology, systems, automation
   - Social Media Director: social_media, engagement, content

📚 Documentation:
   - Deployment Guide: $PROJECT_ROOT/docs/04-development/agent-knowledge-retrieval-deployment-guide.md

${YELLOW}Next Steps:${NC}
1. Complete manual deployment steps above
2. Test reasoning engine with sample queries
3. Monitor performance and adjust domain filters as needed
4. Train agents on new reasoning capabilities

EOF

print_status "Deployment script completed successfully!"

exit 0 