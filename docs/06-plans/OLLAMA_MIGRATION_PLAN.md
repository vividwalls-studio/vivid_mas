# Ollama Models Migration Plan

## Overview

This plan outlines the steps to migrate Ollama and its models to a dedicated AI/LLM droplet, freeing up resources on the main application server.

## Current Status

### Main Droplet (157.230.13.13)
- Running multiple services: n8n, Supabase, Medusa, etc.
- Disk space: 81% used (after cleanup)
- Ollama models location: Docker volume `ollama_storage`

## Migration Plan

### Phase 1: Create New AI Droplet

1. **Droplet Specifications**
   - Name: `vividwalls-ai-llm`
   - Size: Minimum 8GB RAM, 160GB SSD (or larger based on model requirements)
   - Region: Same as main droplet (NYC3)
   - OS: Ubuntu 22.04
   - Enable: Private networking, monitoring

2. **Initial Setup**
   ```bash
   # Create droplet via DigitalOcean CLI
   doctl compute droplet create vividwalls-ai-llm \
     --size s-4vcpu-8gb \
     --image ubuntu-22-04-x64 \
     --region nyc3 \
     --ssh-keys <your-ssh-key-id> \
     --enable-private-networking \
     --enable-monitoring
   ```

### Phase 2: Configure AI Droplet

1. **Install Docker**
   ```bash
   # SSH to new droplet
   ssh root@<new-droplet-ip>
   
   # Install Docker
   curl -fsSL https://get.docker.com -o get-docker.sh
   sh get-docker.sh
   
   # Install docker-compose
   apt-get update
   apt-get install -y docker-compose-plugin
   ```

2. **Set up Ollama**
   ```bash
   # Create docker-compose.yml
   cat > docker-compose.yml << 'EOF'
   version: '3.8'
   
   services:
     ollama:
       image: ollama/ollama:latest
       container_name: ollama
       ports:
         - "11434:11434"
       volumes:
         - ollama_storage:/root/.ollama
       environment:
         - OLLAMA_ORIGINS=*
       restart: unless-stopped
       deploy:
         resources:
           reservations:
             devices:
               - driver: nvidia
                 count: all
                 capabilities: [gpu]
   
   volumes:
     ollama_storage:
   EOF
   ```

3. **Configure Firewall**
   ```bash
   # Allow Ollama port from main droplet only
   ufw allow from 157.230.13.13 to any port 11434
   ufw enable
   ```

### Phase 3: Transfer Models

1. **Export models from main droplet**
   ```bash
   # On main droplet
   docker exec ollama ollama list  # List all models
   
   # Create backup of models
   docker run --rm -v ollama_storage:/data -v $(pwd):/backup \
     alpine tar czf /backup/ollama_models.tar.gz -C /data .
   ```

2. **Transfer to new droplet**
   ```bash
   # Transfer backup file
   scp ollama_models.tar.gz root@<new-droplet-ip>:/root/
   
   # On new droplet, restore models
   docker run --rm -v ollama_storage:/data -v /root:/backup \
     alpine tar xzf /backup/ollama_models.tar.gz -C /data
   ```

### Phase 4: Update Configuration

1. **Update main droplet services**
   ```bash
   # Update .env file
   echo "OLLAMA_HOST=http://<new-droplet-private-ip>:11434" >> /root/vivid_mas/.env
   
   # Update docker-compose.yml to remove ollama service
   # Update any services that depend on ollama to use external host
   ```

2. **Update Open WebUI configuration**
   ```yaml
   open-webui:
     environment:
       - OLLAMA_BASE_URL=http://<new-droplet-private-ip>:11434
   ```

3. **Update n8n workflows**
   - Update any Ollama nodes to use new endpoint
   - Test all AI-dependent workflows

### Phase 5: Cleanup

1. **Remove Ollama from main droplet**
   ```bash
   # Stop and remove container
   docker stop ollama
   docker rm ollama
   
   # Remove volume (after verifying new droplet works)
   docker volume rm ollama_storage
   ```

2. **Verify space reclaimed**
   ```bash
   df -h
   docker system prune -a --volumes
   ```

## Network Architecture

```
Internet
    |
    ├── Main Droplet (157.230.13.13)
    │   ├── n8n
    │   ├── Supabase
    │   ├── Medusa
    │   └── Open WebUI → (connects to AI Droplet)
    │
    └── AI Droplet (new IP)
        └── Ollama (port 11434)
            ├── llama2
            ├── mistral
            └── other models
```

## Benefits

1. **Resource Isolation**: AI workloads won't impact main services
2. **Scalability**: Can upgrade AI droplet independently
3. **Cost Optimization**: Can use GPU droplets if needed
4. **Maintenance**: Easier to manage and monitor AI services

## Security Considerations

1. **Private Networking**: Use DigitalOcean private IPs
2. **Firewall Rules**: Restrict Ollama access to main droplet only
3. **No Public Access**: Ollama should not be exposed to internet
4. **API Keys**: If needed, implement authentication

## Monitoring

1. **Resource Usage**: Monitor CPU, RAM, disk on AI droplet
2. **Model Performance**: Track inference times
3. **Network Latency**: Monitor connection between droplets

## Rollback Plan

If issues arise:
1. Update configurations to point back to localhost
2. Restart Ollama on main droplet
3. Restore from backup if needed

## Cost Estimate

- Basic droplet (s-4vcpu-8gb): ~$48/month
- With GPU (gpu-h100x1-80gb): ~$3,696/month
- Recommendation: Start with CPU droplet, upgrade if needed

## Next Steps

1. Review and approve plan
2. Create new droplet
3. Schedule migration during low-usage period
4. Execute migration
5. Monitor for 24-48 hours
6. Complete cleanup