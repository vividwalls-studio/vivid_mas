#!/bin/bash

# VividMAS Digital Ocean Deployment Script
# This script sets up the entire AI automation platform on a Digital Ocean droplet

set -e  # Exit on any error

echo "🚀 Starting VividMAS deployment on Digital Ocean..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root for security reasons"
   exit 1
fi

# Get the domain from user input
echo ""
print_status "Please enter your domain name (e.g., yourdomain.com):"
read -r DOMAIN_NAME

if [[ -z "$DOMAIN_NAME" ]]; then
    print_error "Domain name is required"
    exit 1
fi

# Get email for Let's Encrypt
echo ""
print_status "Please enter your email for Let's Encrypt SSL certificates:"
read -r LETSENCRYPT_EMAIL

if [[ -z "$LETSENCRYPT_EMAIL" ]]; then
    print_error "Email is required for SSL certificates"
    exit 1
fi

# Update system
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required packages
print_status "Installing required packages..."
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    python3 \
    python3-pip \
    ufw \
    htop \
    nano \
    unzip

# Install Docker
print_status "Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add current user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose (standalone)
print_status "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Configure firewall
print_status "Configuring firewall..."
sudo ufw enable
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8000/tcp    # Supabase Studio
sudo ufw allow 3000/tcp    # Open WebUI
sudo ufw allow 5678/tcp    # n8n
sudo ufw allow 3001/tcp    # Flowise
sudo ufw allow 3002/tcp    # Langfuse
sudo ufw allow 8080/tcp    # SearXNG
sudo ufw allow 11434/tcp   # Ollama
sudo ufw reload

# Clone the repository if not already present
if [[ ! -d "vivid_mas" ]]; then
    print_status "Cloning VividMAS repository..."
    git clone https://github.com/vividwalls-studio/vivid_mas.git
fi

cd vivid_mas

# Generate secure passwords and keys
print_status "Generating secure configuration..."

# Generate random passwords
POSTGRES_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
N8N_ENCRYPTION_KEY=$(openssl rand -base64 32)
N8N_JWT_SECRET=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 32)
CLICKHOUSE_PASSWORD=$(openssl rand -base64 32)
MINIO_ROOT_PASSWORD=$(openssl rand -base64 32)
LANGFUSE_SALT=$(openssl rand -base64 32)
NEXTAUTH_SECRET=$(openssl rand -base64 32)
ENCRYPTION_KEY=$(openssl rand -hex 32)
DASHBOARD_PASSWORD=$(openssl rand -base64 16)

# Create production .env file
print_status "Creating production environment configuration..."
cat > .env << EOF
# VividMAS Production Configuration
# Generated on $(date)

############
# N8N Configuration
############
N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
N8N_USER_MANAGEMENT_JWT_SECRET=${N8N_JWT_SECRET}

############
# Supabase Secrets
############
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
JWT_SECRET=${JWT_SECRET}
ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ey AgCiAgICAicm9sZSI6ICJhbm9uIiwKICAgICJpc3MiOiAic3VwYWJhc2UtZGVtbyIsCiAgICAiaWF0IjogMTY0MTc2OTIwMCwKICAgICJleHAiOiAxNzk5NTM1NjAwCn0.dc_X5iR_VP_qT0zsiyj_I_OZ2T9FtRU2BBNWN8Bu4GE
SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ey AgCiAgICAicm9sZSI6ICJzZXJ2aWNlX3JvbGUiLAogICAgImlzcyI6ICJzdXBhYmFzZS1kZW1vIiwKICAgICJpYXQiOiAxNjQxNzY5MjAwLAogICAgImV4cCI6IDE3OTk1MzU2MDAKfQ.DaYlNEoUrrEn2Ig7tqibS-PHK5vgusbocoX36XVt4Q
DASHBOARD_USERNAME=admin
DASHBOARD_PASSWORD=${DASHBOARD_PASSWORD}
POOLER_TENANT_ID=1000

############
# Langfuse credentials
############
CLICKHOUSE_PASSWORD=${CLICKHOUSE_PASSWORD}
MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD}
LANGFUSE_SALT=${LANGFUSE_SALT}
NEXTAUTH_SECRET=${NEXTAUTH_SECRET}
ENCRYPTION_KEY=${ENCRYPTION_KEY}

############
# Caddy Config - Production Domains
############
N8N_HOSTNAME=n8n.${DOMAIN_NAME}
WEBUI_HOSTNAME=ui.${DOMAIN_NAME}
FLOWISE_HOSTNAME=flowise.${DOMAIN_NAME}
SUPABASE_HOSTNAME=supabase.${DOMAIN_NAME}
LANGFUSE_HOSTNAME=langfuse.${DOMAIN_NAME}
OLLAMA_HOSTNAME=ollama.${DOMAIN_NAME}
SEARXNG_HOSTNAME=search.${DOMAIN_NAME}
LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}

############
# Flowise Configuration
############
FLOWISE_USERNAME=admin
FLOWISE_PASSWORD=${DASHBOARD_PASSWORD}

############
# Optional - Additional Supabase config
############
POSTGRES_HOST=localhost
POSTGRES_DB=postgres
POSTGRES_PORT=5432
STUDIO_PORT=54323
INBUCKET_PORT=54324
INBUCKET_SMTP_PORT=54325
ANON_KEY_ID=anon
SERVICE_ROLE_KEY_ID=service_role

# Additional security settings
SITE_URL=https://supabase.${DOMAIN_NAME}
API_EXTERNAL_URL=https://supabase.${DOMAIN_NAME}
GOTRUE_SITE_URL=https://supabase.${DOMAIN_NAME}
GOTRUE_URI_ALLOW_LIST=https://supabase.${DOMAIN_NAME}

EOF

print_success "Environment configuration created!"

# Save credentials to a secure file
print_status "Saving credentials to secure file..."
cat > credentials.txt << EOF
VividMAS Deployment Credentials
Generated on $(date)
Domain: ${DOMAIN_NAME}

=== IMPORTANT: Save these credentials securely ===

Supabase Dashboard: https://supabase.${DOMAIN_NAME}
  Username: admin
  Password: ${DASHBOARD_PASSWORD}

Flowise: https://flowise.${DOMAIN_NAME}
  Username: admin
  Password: ${DASHBOARD_PASSWORD}

n8n: https://n8n.${DOMAIN_NAME}
  (Setup required on first visit)

Open WebUI: https://ui.${DOMAIN_NAME}
  (Setup required on first visit)

Langfuse: https://langfuse.${DOMAIN_NAME}
  (Setup required on first visit)

Search: https://search.${DOMAIN_NAME}
  (No authentication required)

=== Database Connection ===
PostgreSQL:
  Host: localhost (or the droplet IP)
  Port: 5433
  Database: postgres
  Username: postgres
  Password: ${POSTGRES_PASSWORD}

=== Internal Passwords (for troubleshooting) ===
Postgres Password: ${POSTGRES_PASSWORD}
N8N Encryption Key: ${N8N_ENCRYPTION_KEY}
Langfuse Salt: ${LANGFUSE_SALT}
EOF

chmod 600 credentials.txt

print_success "Credentials saved to credentials.txt (readable only by you)"

# Create systemd service for auto-startup
print_status "Creating systemd service for auto-startup..."
sudo tee /etc/systemd/system/vividmas.service > /dev/null << EOF
[Unit]
Description=VividMAS AI Automation Platform
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/$(whoami)/vivid_mas
ExecStart=/usr/local/bin/docker-compose up -d --profile cpu
ExecStop=/usr/local/bin/docker-compose down
TimeoutStartSec=300
User=$(whoami)
Group=docker

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable vividmas.service

print_status "Starting services (this may take 10-15 minutes for first-time setup)..."
print_warning "The system will download and configure all AI models and services..."

# Start the services
newgrp docker << END
python3 start_services.py --profile cpu
END

print_success "🎉 VividMAS has been deployed successfully!"

echo ""
echo "============================================"
echo "          DEPLOYMENT COMPLETE!"
echo "============================================"
echo ""
print_success "Your VividMAS platform is now running!"
echo ""
echo "🌐 Access your services at:"
echo "  • n8n (Workflow automation): https://n8n.${DOMAIN_NAME}"
echo "  • Open WebUI (AI Chat): https://ui.${DOMAIN_NAME}"
echo "  • Flowise (AI Builder): https://flowise.${DOMAIN_NAME}"
echo "  • Supabase (Database): https://supabase.${DOMAIN_NAME}"
echo "  • Langfuse (Observability): https://langfuse.${DOMAIN_NAME}"
echo "  • Search Engine: https://search.${DOMAIN_NAME}"
echo ""
print_warning "📋 IMPORTANT:"
echo "  1. Set up DNS A records for all subdomains pointing to this server"
echo "  2. Check credentials.txt for login details"
echo "  3. Complete initial setup for each service"
echo "  4. SSL certificates will be automatically generated"
echo ""
print_status "🔧 Management commands:"
echo "  • Check status: sudo systemctl status vividmas"
echo "  • Stop services: sudo systemctl stop vividmas"
echo "  • Start services: sudo systemctl start vividmas"
echo "  • View logs: docker-compose logs -f"
echo ""
print_success "Deployment script completed successfully!" 