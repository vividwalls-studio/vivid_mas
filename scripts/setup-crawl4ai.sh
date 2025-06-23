#!/bin/bash

# Setup Crawl4AI on Digital Ocean droplet

DROPLET_IP="157.230.13.13"
SSH_KEY="/Users/kinglerbercy/.ssh/digitalocean"

echo "Setting up Crawl4AI on Digital Ocean droplet..."
echo "Please enter your SSH key passphrase when prompted."

# SSH into droplet and execute commands
ssh -i $SSH_KEY root@$DROPLET_IP << 'EOF'
echo "=== Checking Docker networks ==="
docker network ls

echo -e "\n=== Checking for vivid_mas network ==="
if docker network ls | grep -q "vivid_mas"; then
    echo "vivid_mas network exists"
    NETWORK_NAME="vivid_mas"
else
    # Check for default compose network
    COMPOSE_NETWORK=$(docker network ls | grep -E "vivid_mas_default|root_default" | awk '{print $2}' | head -1)
    if [ -n "$COMPOSE_NETWORK" ]; then
        echo "Found compose network: $COMPOSE_NETWORK"
        NETWORK_NAME="$COMPOSE_NETWORK"
    else
        echo "No vivid_mas network found, will use default bridge"
        NETWORK_NAME="bridge"
    fi
fi

echo -e "\n=== Pulling Crawl4AI Docker image ==="
docker pull unclecode/crawl4ai:latest

echo -e "\n=== Running Crawl4AI container ==="
docker run -d \
  --name crawl4ai \
  --network $NETWORK_NAME \
  -p 11235:11235 \
  --shm-size=1g \
  --restart unless-stopped \
  unclecode/crawl4ai:latest

echo -e "\n=== Verifying container is running ==="
docker ps | grep crawl4ai

echo -e "\n=== Container network details ==="
docker inspect crawl4ai --format='{{json .NetworkSettings.Networks}}' | jq .

echo -e "\n=== Creating docker-compose file for Crawl4AI ==="
cat > /root/vivid_mas/docker-compose.crawl4ai.yml << 'COMPOSE'
version: '3.8'

services:
  crawl4ai:
    image: unclecode/crawl4ai:latest
    container_name: crawl4ai
    restart: unless-stopped
    ports:
      - "11235:11235"
    shm_size: 1g
    environment:
      - INSTALL_TYPE=default
    volumes:
      - ./shared:/data/shared
COMPOSE

echo -e "\n=== Crawl4AI setup complete ==="
echo "Access points:"
echo "  - Web Playground: http://$DROPLET_IP:11235/playground"
echo "  - API Endpoint: http://$DROPLET_IP:11235/crawl"
echo "  - Health Check: http://$DROPLET_IP:11235/health"
EOF