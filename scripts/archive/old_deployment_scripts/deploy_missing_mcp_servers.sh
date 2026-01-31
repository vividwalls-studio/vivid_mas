#!/bin/bash
set -e

# Configuration
DROPLET_IP="157.230.13.13"
SSH_KEY="~/.ssh/digitalocean"
SSH_KEY_EXPANDED="${HOME}/.ssh/digitalocean"
LOCAL_MCP_PATH="/Volumes/SeagatePortableDrive/Projects/vivid_mas/services/mcp-servers"
REMOTE_MCP_PATH="/opt/mcp-servers"

echo "🚀 MCP Servers Deployment Script for DigitalOcean Droplet"
echo "========================================================="
echo "Target: root@${DROPLET_IP}"
echo "Remote path: ${REMOTE_MCP_PATH}"
echo ""

# File to store existing servers
EXISTING_SERVERS_FILE="/tmp/existing_mcp_servers.txt"

# Function to check existing servers
check_existing_servers() {
    echo "📋 Checking existing MCP servers on droplet..."
    
    # Get list of existing servers
    ssh -i "$SSH_KEY_EXPANDED" root@$DROPLET_IP "find $REMOTE_MCP_PATH -name 'package.json' -type f 2>/dev/null | grep -v node_modules | sed 's|$REMOTE_MCP_PATH/||' | sed 's|/package.json||' | sort" > "$EXISTING_SERVERS_FILE"
    
    # Display existing servers
    while IFS= read -r server; do
        if [[ -n "$server" ]]; then
            echo "   ✓ Found: $server"
        fi
    done < "$EXISTING_SERVERS_FILE"
    
    echo ""
}

# Function to check if server exists
server_exists() {
    local server_name=$1
    grep -q "^${server_name}$" "$EXISTING_SERVERS_FILE" 2>/dev/null
}

# Function to deploy a single MCP server
deploy_mcp_server() {
    local server_path=$1
    local server_name=$(basename "$server_path")
    local category=$2
    
    # Skip if already exists
    if server_exists "$server_name"; then
        echo "   ⏭️  Skipping $server_name - already exists on droplet"
        return
    fi
    
    # Skip category-based naming if exists
    if [[ -n "$category" ]] && server_exists "$category/$server_name"; then
        echo "   ⏭️  Skipping $server_name - already exists as $category/$server_name"
        return
    fi
    
    # Skip if it's not a directory or doesn't have package.json
    if [[ ! -d "$server_path" ]] || [[ ! -f "$server_path/package.json" ]]; then
        return
    fi
    
    # Skip node_modules and .venv directories
    if [[ "$server_name" == "node_modules" ]] || [[ "$server_name" == ".venv" ]]; then
        return
    fi
    
    echo "   📦 Deploying: $server_name"
    
    # Create remote directory
    local remote_path="$REMOTE_MCP_PATH/$server_name"
    if [[ -n "$category" ]]; then
        remote_path="$REMOTE_MCP_PATH/$category/$server_name"
    fi
    
    ssh -i "$SSH_KEY_EXPANDED" root@$DROPLET_IP "mkdir -p $remote_path"
    
    # Sync files (excluding node_modules and other unnecessary files)
    rsync -avz --progress \
        -e "ssh -i $SSH_KEY_EXPANDED" \
        --exclude='node_modules' \
        --exclude='.git' \
        --exclude='*.log' \
        --exclude='.env' \
        --exclude='dist' \
        --exclude='build' \
        --exclude='.venv' \
        --exclude='__pycache__' \
        --exclude='*.pyc' \
        "$server_path/" \
        root@$DROPLET_IP:$remote_path/
    
    echo "   ✅ Deployed $server_name"
    echo ""
}

# Check what's already deployed
check_existing_servers

# Count servers to deploy
echo "📊 Analyzing MCP servers to deploy..."
SERVERS_TO_DEPLOY=0

# Check each category
for category in core agents analytics sales research; do
    if [[ -d "$LOCAL_MCP_PATH/$category" ]]; then
        for server in "$LOCAL_MCP_PATH/$category"/*; do
            if [[ -d "$server" ]] && [[ -f "$server/package.json" ]]; then
                server_name=$(basename "$server")
                if ! server_exists "$server_name" && ! server_exists "$category/$server_name"; then
                    ((SERVERS_TO_DEPLOY++))
                fi
            fi
        done
    fi
done

# Check root level servers
for server in "$LOCAL_MCP_PATH"/*; do
    if [[ -d "$server" ]] && [[ ! "$server" =~ ^.*/(core|agents|analytics|sales|research)$ ]]; then
        server_name=$(basename "$server")
        if [[ "$server_name" != "node_modules" ]] && [[ "$server_name" != ".venv" ]] && [[ -f "$server/package.json" ]]; then
            if ! server_exists "$server_name"; then
                ((SERVERS_TO_DEPLOY++))
            fi
        fi
    fi
done

echo "Found $SERVERS_TO_DEPLOY new MCP servers to deploy"
echo ""

if [[ $SERVERS_TO_DEPLOY -eq 0 ]]; then
    echo "✅ All MCP servers are already deployed!"
    exit 0
fi

# Deploy missing servers
echo "🚀 Deploying missing MCP servers..."
echo "==================================="

# Deploy core MCP servers
if [[ -d "$LOCAL_MCP_PATH/core" ]]; then
    echo "📦 Deploying CORE MCP servers..."
    for server in "$LOCAL_MCP_PATH/core"/*; do
        if [[ -d "$server" ]]; then
            deploy_mcp_server "$server" ""
        fi
    done
fi

# Deploy agents MCP servers
if [[ -d "$LOCAL_MCP_PATH/agents" ]]; then
    echo "📦 Deploying AGENTS MCP servers..."
    for server in "$LOCAL_MCP_PATH/agents"/*; do
        if [[ -d "$server" ]]; then
            deploy_mcp_server "$server" ""
        fi
    done
fi

# Deploy analytics MCP servers
if [[ -d "$LOCAL_MCP_PATH/analytics" ]]; then
    echo "📦 Deploying ANALYTICS MCP servers..."
    for server in "$LOCAL_MCP_PATH/analytics"/*; do
        if [[ -d "$server" ]]; then
            deploy_mcp_server "$server" ""
        fi
    done
fi

# Deploy sales MCP servers
if [[ -d "$LOCAL_MCP_PATH/sales" ]]; then
    echo "📦 Deploying SALES MCP servers..."
    for server in "$LOCAL_MCP_PATH/sales"/*; do
        if [[ -d "$server" ]]; then
            deploy_mcp_server "$server" ""
        fi
    done
fi

# Deploy research MCP servers
if [[ -d "$LOCAL_MCP_PATH/research" ]]; then
    echo "📦 Deploying RESEARCH MCP servers..."
    for server in "$LOCAL_MCP_PATH/research"/*; do
        if [[ -d "$server" ]]; then
            deploy_mcp_server "$server" ""
        fi
    done
fi

# Deploy other MCP servers
echo "📦 Deploying OTHER MCP servers..."
for server in "$LOCAL_MCP_PATH"/*; do
    if [[ -d "$server" ]] && [[ ! "$server" =~ ^.*/(core|agents|analytics|sales|research)$ ]]; then
        server_name=$(basename "$server")
        if [[ "$server_name" != "node_modules" ]] && [[ "$server_name" != ".venv" ]]; then
            deploy_mcp_server "$server" ""
        fi
    fi
done

# Create or update installation script on remote
echo "📝 Creating remote installation script..."
cat << 'REMOTE_SCRIPT' > /tmp/install_new_mcp_servers.sh
#!/bin/bash
set -e

cd /opt/mcp-servers

echo "🔧 Installing dependencies for new MCP servers..."
echo ""

# Function to install dependencies for a single server
install_server() {
    local server_dir=$1
    local server_name=$(basename "$server_dir")
    
    if [[ -f "$server_dir/package.json" ]]; then
        # Check if node_modules exists and is recent
        if [[ -d "$server_dir/node_modules" ]] && [[ -f "$server_dir/package-lock.json" ]]; then
            echo "   ℹ️  $server_name already has dependencies installed"
            return
        fi
        
        echo "   📦 Installing dependencies for: $server_name"
        cd "$server_dir"
        
        # Install npm dependencies
        npm install --production
        
        # Build TypeScript if tsconfig.json exists
        if [[ -f "tsconfig.json" ]]; then
            echo "   🔨 Building TypeScript..."
            npm run build || echo "   ⚠️  No build script found"
        fi
        
        echo "   ✅ Installed $server_name"
        echo ""
    fi
}

# Install dependencies for all servers without node_modules
for server in */; do
    if [[ -d "$server" ]] && [[ ! -d "$server/node_modules" ]]; then
        install_server "$server"
    fi
done

echo "✅ All new MCP server dependencies installed!"
REMOTE_SCRIPT

# Copy and execute installation script
scp -i "$SSH_KEY_EXPANDED" /tmp/install_new_mcp_servers.sh root@$DROPLET_IP:/opt/mcp-servers/
ssh -i "$SSH_KEY_EXPANDED" root@$DROPLET_IP "chmod +x /opt/mcp-servers/install_new_mcp_servers.sh"

echo ""
echo "🎯 Deployment complete!"
echo "======================"
echo ""
echo "To install dependencies for the new servers, run:"
echo "  ssh -i ~/.ssh/digitalocean root@$DROPLET_IP"
echo "  cd /opt/mcp-servers && ./install_new_mcp_servers.sh"
echo ""

# List all deployed servers
echo "📋 Current MCP servers on droplet:"
ssh -i "$SSH_KEY_EXPANDED" root@$DROPLET_IP "find $REMOTE_MCP_PATH -name 'package.json' -type f | grep -v node_modules | sort | sed 's|/opt/mcp-servers/||' | sed 's|/package.json||'"