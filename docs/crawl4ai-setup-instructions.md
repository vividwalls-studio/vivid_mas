# Crawl4AI Setup Instructions for Digital Ocean Droplet

## Manual SSH Setup

1. SSH into your Digital Ocean droplet:
```bash
ssh -i /Users/kinglerbercy/.ssh/digitalocean root@157.230.13.13
```

When prompted for passphrase, enter: `freedom`

## Step 1: Check Docker Networks

Once connected, check the existing Docker networks:
```bash
docker network ls
```

Look for a network named `vivid_mas` or `vivid_mas_default` or `root_default`.

## Step 2: Pull Crawl4AI Docker Image

```bash
docker pull unclecode/crawl4ai:latest
```

## Step 3: Run Crawl4AI Container

If you found a `vivid_mas` network:
```bash
docker run -d \
  --name crawl4ai \
  --network vivid_mas \
  -p 11235:11235 \
  --shm-size=1g \
  --restart unless-stopped \
  unclecode/crawl4ai:latest
```

If you found `vivid_mas_default` or `root_default`:
```bash
docker run -d \
  --name crawl4ai \
  --network vivid_mas_default \
  -p 11235:11235 \
  --shm-size=1g \
  --restart unless-stopped \
  unclecode/crawl4ai:latest
```

## Step 4: Verify Installation

Check if the container is running:
```bash
docker ps | grep crawl4ai
```

Check the container logs:
```bash
docker logs crawl4ai
```

Test the health endpoint:
```bash
curl http://localhost:11235/health
```

## Step 5: Update Files on Droplet

1. Copy the updated docker-compose.yml:
```bash
cd /root/vivid_mas
# Copy the updated docker-compose.yml from your local machine
```

2. Create the .llm.env file:
```bash
nano /root/vivid_mas/.llm.env
```

Add your LLM API keys if needed:
```
# OpenAI
# OPENAI_API_KEY=your-openai-api-key

# Anthropic Claude
# ANTHROPIC_API_KEY=your-anthropic-api-key
```

3. Update the Caddyfile to include Crawl4AI reverse proxy.

## Step 6: Using Docker Compose (Alternative)

If you prefer to use docker-compose:

1. Stop the standalone container:
```bash
docker stop crawl4ai
docker rm crawl4ai
```

2. Run with docker-compose:
```bash
cd /root/vivid_mas
docker-compose up -d crawl4ai
```

## Access Points

After successful setup, Crawl4AI will be available at:

- **Web Playground**: http://157.230.13.13:11235/playground
- **API Endpoint**: http://157.230.13.13:11235/crawl
- **Health Check**: http://157.230.13.13:11235/health
- **Via Caddy Proxy**: http://157.230.13.13:8008 (if configured)

## Troubleshooting

1. If container fails to start, check logs:
```bash
docker logs crawl4ai
```

2. If network issues occur, inspect the container's network settings:
```bash
docker inspect crawl4ai --format='{{json .NetworkSettings.Networks}}' | jq .
```

3. To restart the container:
```bash
docker restart crawl4ai
```

## API Usage Example

Once running, you can test the API:
```bash
curl -X POST http://localhost:11235/crawl \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'
```