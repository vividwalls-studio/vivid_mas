#\!/usr/bin/expect -f
# SSH tunnel script for crawl4ai MCP server with passphrase handling

# Get environment variables
set openai_key $env(OPENAI_API_KEY)
set supabase_key $env(SUPABASE_SERVICE_KEY)
set neo4j_pass $env(NEO4J_PASSWORD)

# SSH to server
spawn ssh -i ~/.ssh/digitalocean root@157.230.13.13

expect {
    "Enter passphrase" {
        send "freedom\r"
        expect "root@*"
    }
    timeout { exit 1 }
}

# Navigate to MCP server directory
send "cd /opt/mcp-servers/mcp-crawl4ai-rag\r"
expect "root@*"

# Activate virtual environment
send "source venv/bin/activate\r"
expect "root@*"

# Set environment variables
send "export TRANSPORT=stdio\r"
expect "root@*"
send "export OPENAI_API_KEY='$openai_key'\r"
expect "root@*"
send "export SUPABASE_URL='http://localhost:8000'\r"
expect "root@*"
send "export SUPABASE_SERVICE_KEY='$supabase_key'\r"
expect "root@*"
send "export USE_KNOWLEDGE_GRAPH=true\r"
expect "root@*"
send "export NEO4J_URI='bolt://localhost:7687'\r"
expect "root@*"
send "export NEO4J_USER='neo4j'\r"
expect "root@*"
send "export NEO4J_PASSWORD='$neo4j_pass'\r"
expect "root@*"
send "export CRAWL4AI_API_URL='http://localhost:11235'\r"
expect "root@*"

# Run the MCP server
send "exec python -m src.crawl4ai_mcp\r"

# Keep the connection open
interact
EOF < /dev/null