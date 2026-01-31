#!/bin/bash

# Build All MCP Servers Script
# This script installs dependencies and builds TypeScript for all MCP servers

echo "🚀 Building All MCP Servers"
echo "=========================================="

# Base path
MCP_AGENTS_PATH="/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers/agents"

# Track statistics
TOTAL_SERVERS=0
BUILT_SERVERS=0
FAILED_SERVERS=0
FAILED_LIST=""

# Function to build a server
build_server() {
    local server_path=$1
    local server_name=$(basename "$server_path")
    
    echo ""
    echo "📦 Processing: $server_name"
    echo "-----------------------------------"
    
    cd "$server_path"
    
    # Check if package.json exists
    if [ ! -f "package.json" ]; then
        echo "⚠️  No package.json found, skipping..."
        return 1
    fi
    
    # Install dependencies
    echo "  📥 Installing dependencies..."
    if npm install --silent > /dev/null 2>&1; then
        echo "  ✅ Dependencies installed"
    else
        echo "  ❌ Failed to install dependencies"
        return 1
    fi
    
    # Check if TypeScript files exist
    if [ -d "src" ] && [ -f "tsconfig.json" ]; then
        echo "  🔨 Building TypeScript..."
        if npm run build > /dev/null 2>&1; then
            echo "  ✅ TypeScript built successfully"
            return 0
        else
            echo "  ❌ Failed to build TypeScript"
            return 1
        fi
    else
        echo "  ℹ️  No TypeScript to build"
        return 0
    fi
}

# Get all MCP server directories
echo "🔍 Finding all MCP server directories..."
echo ""

# Process prompt servers
echo "📝 Building Prompt Servers:"
echo "-----------------------------------"
for dir in "$MCP_AGENTS_PATH"/*-prompts; do
    if [ -d "$dir" ]; then
        TOTAL_SERVERS=$((TOTAL_SERVERS + 1))
        if build_server "$dir"; then
            BUILT_SERVERS=$((BUILT_SERVERS + 1))
        else
            FAILED_SERVERS=$((FAILED_SERVERS + 1))
            FAILED_LIST="$FAILED_LIST\n  - $(basename "$dir")"
        fi
    fi
done

# Process resource servers
echo ""
echo "📊 Building Resource Servers:"
echo "-----------------------------------"
for dir in "$MCP_AGENTS_PATH"/*-resource; do
    if [ -d "$dir" ]; then
        TOTAL_SERVERS=$((TOTAL_SERVERS + 1))
        if build_server "$dir"; then
            BUILT_SERVERS=$((BUILT_SERVERS + 1))
        else
            FAILED_SERVERS=$((FAILED_SERVERS + 1))
            FAILED_LIST="$FAILED_LIST\n  - $(basename "$dir")"
        fi
    fi
done

# Final report
echo ""
echo "=========================================="
echo "✅ BUILD COMPLETE"
echo "=========================================="
echo ""
echo "📊 Summary:"
echo "  • Total servers processed: $TOTAL_SERVERS"
echo "  • Successfully built: $BUILT_SERVERS"
echo "  • Failed: $FAILED_SERVERS"

if [ $FAILED_SERVERS -gt 0 ]; then
    echo ""
    echo "❌ Failed servers:"
    echo -e "$FAILED_LIST"
fi

echo ""
echo "🎯 Next Steps:"
echo "  1. Create n8n workflows for each agent"
echo "  2. Configure agent communication matrix"
echo "  3. Test inter-agent communications"
echo "  4. Deploy to production"

exit 0