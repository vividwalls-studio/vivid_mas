# VividWalls MAS DNS and SSL/HTTPS Setup Guide

## Overview

This guide provides comprehensive instructions for setting up DNS and SSL/HTTPS for the VividWalls MAS project, specifically for the frontend application at `https://app.vividwalls.blog`.

## Architecture

```
Internet
    ↓
CloudFlare DNS / DigitalOcean DNS
    ↓
DigitalOcean Droplet (157.230.13.13)
    ↓
Caddy (Reverse Proxy with Auto SSL)
    ├── app.vividwalls.blog → vivid-frontend:3000
    ├── api.vividwalls.blog → api-gateway:3000
    ├── n8n.vividwalls.blog → n8n:5678
    ├── supabase.vividwalls.blog → supabase-kong:8000
    └── [other services...]
```

## Prerequisites

- DigitalOcean account with API token
- Domain: vividwalls.blog
- SSH access to droplet (157.230.13.13)
- doctl CLI installed and configured

## 1. DNS Configuration

### 1.1 Create DNS A Record

```bash
# Using doctl CLI
doctl compute domain records create vividwalls.blog \
  --record-type A \
  --record-name app \
  --record-data 157.230.13.13 \
  --record-ttl 300
```

### 1.2 Verify DNS Propagation

```bash
# Check DNS resolution
dig app.vividwalls.blog
nslookup app.vividwalls.blog

# Test from multiple DNS servers
dig @8.8.8.8 app.vividwalls.blog
dig @1.1.1.1 app.vividwalls.blog
```

## 2. Caddy Configuration

### 2.1 Main Caddyfile Structure

Location: `/root/vivid_mas/Caddyfile`

```caddyfile
{
    # Global options
    email admin@vividwalls.blog
    
    # Admin API for management
    admin localhost:2019
    
    # Global logging
    log {
        level INFO
        output file /var/log/caddy/access.log {
            roll_size 10mb
            roll_keep 5
            roll_keep_for 720h
        }
        format json
    }
}

# Import all site configurations
import /etc/caddy/sites-enabled/*.caddy
```

### 2.2 Frontend Site Configuration

Location: `/root/vivid_mas/caddy/sites-enabled/app.caddy`

Key features:
- Automatic SSL certificate provisioning via Let's Encrypt
- Security headers (HSTS, CSP, XSS protection)
- Compression (gzip, zstd)
- Static asset caching
- WebSocket support
- Health checks

## 3. SSL/HTTPS Features

### 3.1 Automatic Certificate Management

Caddy automatically:
- Obtains SSL certificates from Let's Encrypt
- Renews certificates before expiration
- Redirects HTTP to HTTPS
- Configures OCSP stapling
- Implements modern TLS settings

### 3.2 Security Headers

```
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Content-Security-Policy: [comprehensive policy]
Permissions-Policy: camera=(), microphone=(), geolocation=()
```

### 3.3 TLS Configuration

Caddy defaults:
- TLS 1.2 and 1.3 only
- Modern cipher suites
- Forward secrecy
- OCSP stapling

## 4. Docker Integration

### 4.1 Frontend Service

```yaml
vivid-frontend:
  image: vividwalls/mas-frontend:latest
  container_name: vivid-frontend
  ports:
    - "3003:3000"
  environment:
    - NODE_ENV=production
    - NEXT_PUBLIC_N8N_URL=https://n8n.vividwalls.blog
    - NEXT_PUBLIC_SUPABASE_URL=https://supabase.vividwalls.blog
  networks:
    - vivid_mas
  restart: unless-stopped
```

### 4.2 Network Configuration

All services must be on the `vivid_mas` network:

```yaml
networks:
  vivid_mas:
    external: true
```

## 5. Deployment Process

### 5.1 Quick Setup

Run the automated setup script:

```bash
chmod +x scripts/setup_app_dns_ssl.sh
./scripts/setup_app_dns_ssl.sh
```

This script:
1. Creates DNS A record
2. Verifies DNS propagation
3. Deploys frontend container
4. Configures Caddy
5. Verifies SSL certificate
6. Tests application availability

### 5.2 Manual Setup

#### Step 1: DNS Record

```bash
# Create A record
doctl compute domain records create vividwalls.blog \
  --record-type A \
  --record-name app \
  --record-data 157.230.13.13 \
  --record-ttl 300
```

#### Step 2: Deploy Frontend

```bash
# SSH to droplet
ssh root@157.230.13.13

# Clone repository
cd /root/vivid_mas
git clone https://github.com/kingler/vividwalls_mas_frontend_v1.git frontend

# Start container
docker-compose -f docker-compose.frontend.yml up -d
```

#### Step 3: Configure Caddy

```bash
# Copy Caddy configuration
cp caddy/sites-enabled/app.caddy /root/vivid_mas/caddy/sites-enabled/

# Reload Caddy
docker exec caddy caddy reload --config /etc/caddy/Caddyfile
```

#### Step 4: Verify SSL

```bash
# Check certificate
curl -I https://app.vividwalls.blog

# View Caddy logs
docker logs caddy --tail 50
```

## 6. Testing and Validation

### 6.1 SSL Certificate Check

```bash
# Check certificate details
openssl s_client -connect app.vividwalls.blog:443 -servername app.vividwalls.blog

# SSL Labs test (after deployment)
# Visit: https://www.ssllabs.com/ssltest/analyze.html?d=app.vividwalls.blog
```

### 6.2 Security Headers Test

```bash
# Check security headers
curl -I https://app.vividwalls.blog | grep -E "Strict-Transport|X-Frame|X-Content|Content-Security"

# Online test
# Visit: https://securityheaders.com/?q=app.vividwalls.blog
```

### 6.3 Application Health Check

```bash
# Test health endpoint
curl https://app.vividwalls.blog/api/health

# Expected response:
# {"status":"ok","timestamp":"2025-08-13T12:00:00.000Z"}
```

## 7. Monitoring and Maintenance

### 7.1 Certificate Monitoring

```bash
# Check certificate expiration
echo | openssl s_client -connect app.vividwalls.blog:443 2>/dev/null | openssl x509 -noout -dates

# Monitor Caddy logs for renewal
docker logs caddy --follow | grep -i "certificate"
```

### 7.2 Service Monitoring

```bash
# Check all services
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Frontend logs
docker logs vivid-frontend --tail 50

# Caddy logs
docker logs caddy --tail 50
```

### 7.3 Automated Monitoring

Create a monitoring script:

```bash
#!/bin/bash
# /root/vivid_mas/scripts/monitor_ssl.sh

DOMAIN="app.vividwalls.blog"
ALERT_EMAIL="admin@vividwalls.blog"

# Check certificate expiration
EXPIRY=$(echo | openssl s_client -connect ${DOMAIN}:443 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2)
EXPIRY_EPOCH=$(date -d "${EXPIRY}" +%s)
NOW_EPOCH=$(date +%s)
DAYS_LEFT=$(( ($EXPIRY_EPOCH - $NOW_EPOCH) / 86400 ))

if [ $DAYS_LEFT -lt 14 ]; then
    echo "WARNING: SSL certificate expires in ${DAYS_LEFT} days" | mail -s "SSL Certificate Warning" ${ALERT_EMAIL}
fi

# Check service availability
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://${DOMAIN})
if [ "$HTTP_CODE" != "200" ]; then
    echo "ERROR: ${DOMAIN} returned HTTP ${HTTP_CODE}" | mail -s "Service Alert" ${ALERT_EMAIL}
fi
```

## 8. Troubleshooting

### 8.1 Common Issues

#### DNS Not Resolving

```bash
# Check DNS records
doctl compute domain records list vividwalls.blog

# Force DNS flush
sudo dscacheutil -flushcache  # macOS
sudo systemd-resolve --flush-caches  # Linux
```

#### SSL Certificate Issues

```bash
# Check Caddy certificate storage
docker exec caddy ls -la /data/caddy/certificates/

# Force certificate renewal
docker exec caddy caddy renew --force

# Check rate limits
docker logs caddy | grep -i "rate limit"
```

#### Frontend Not Accessible

```bash
# Check container status
docker ps -a | grep vivid-frontend

# Check port binding
netstat -tulpn | grep 3003

# Check firewall
ufw status
```

### 8.2 Emergency Rollback

```bash
# Remove DNS record
doctl compute domain records delete vividwalls.blog [RECORD_ID]

# Stop frontend
docker stop vivid-frontend

# Remove Caddy config
rm /root/vivid_mas/caddy/sites-enabled/app.caddy
docker exec caddy caddy reload --config /etc/caddy/Caddyfile
```

## 9. Security Best Practices

### 9.1 SSL/TLS Configuration

- ✅ TLS 1.2+ only
- ✅ Strong cipher suites
- ✅ HSTS enabled
- ✅ OCSP stapling
- ✅ Forward secrecy

### 9.2 Application Security

- ✅ CSP headers configured
- ✅ XSS protection enabled
- ✅ Clickjacking protection
- ✅ MIME type sniffing disabled
- ✅ Secure cookies (when using HTTPS)

### 9.3 Infrastructure Security

- ✅ Firewall configured (UFW)
- ✅ SSH key authentication only
- ✅ Regular security updates
- ✅ Docker security scanning
- ✅ Network isolation

## 10. Performance Optimization

### 10.1 Caching Strategy

- Static assets: 1 year cache
- API responses: No cache
- HTML pages: Short cache with revalidation

### 10.2 Compression

- Zstd (preferred)
- Gzip (fallback)
- Pre-compressed assets supported

### 10.3 HTTP/2 and HTTP/3

- HTTP/2 enabled by default
- HTTP/3 (QUIC) available with Caddy 2.6+

## 11. Integration with VividWalls MAS

### 11.1 Service Connectivity

Frontend can access:
- n8n workflows: `https://n8n.vividwalls.blog/webhook/*`
- Supabase API: `https://supabase.vividwalls.blog/rest/v1/*`
- WebSocket: `wss://ws.vividwalls.blog`
- API Gateway: `https://api.vividwalls.blog`

### 11.2 Authentication Flow

1. User visits `https://app.vividwalls.blog`
2. Frontend redirects to Supabase Auth
3. Supabase validates and returns JWT
4. Frontend stores JWT securely
5. API calls include JWT in headers

### 11.3 Agent Communication

```javascript
// Frontend → n8n webhook
fetch('https://n8n.vividwalls.blog/webhook/agent-hub', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${jwt}`
  },
  body: JSON.stringify({ action: 'trigger', agent: 'business-manager' })
})
```

## 12. Future Enhancements

### 12.1 Planned Features

- [ ] WebSocket server for real-time updates
- [ ] CDN integration (CloudFlare)
- [ ] Load balancing for multiple frontend instances
- [ ] Blue-green deployments
- [ ] Automated testing pipeline

### 12.2 Scaling Considerations

- Horizontal scaling with Docker Swarm/Kubernetes
- Redis for session management
- PostgreSQL read replicas
- Caching layer (Redis/Memcached)

## Summary

The DNS and SSL/HTTPS setup for VividWalls MAS provides:

✅ **Secure Communication**: All traffic encrypted with TLS 1.2+  
✅ **Automatic Certificates**: Let's Encrypt via Caddy  
✅ **Modern Security**: HSTS, CSP, and security headers  
✅ **High Performance**: HTTP/2, compression, caching  
✅ **Easy Management**: Automated renewal and monitoring  
✅ **Docker Integration**: Seamless container networking  
✅ **Production Ready**: Health checks and monitoring  

Access the application at: **https://app.vividwalls.blog**