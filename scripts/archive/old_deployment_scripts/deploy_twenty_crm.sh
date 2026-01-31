#!/usr/bin/expect -f

set timeout -1

# SSH into the droplet
spawn ssh -i ~/.ssh/digitalocean root@157.230.13.13

# Handle passphrase
expect "Enter passphrase for key*"
send "freedom\r"

# Wait for prompt
expect "root@*"

# Update system packages
send "apt update && apt upgrade -y\r"
expect "root@*"

# Clone Twenty CRM repository
send "cd /opt && git clone https://github.com/twentyhq/twenty.git\r"
expect "root@*"

# Navigate to twenty-docker directory
send "cd /opt/twenty/packages/twenty-docker\r"
expect "root@*"

# Create .env file from example
send "cp .env.example .env\r"
expect "root@*"

# Generate random strings for secrets
send "POSTGRES_ADMIN_PASSWORD=\$(openssl rand -base64 32)\r"
expect "root@*"
send "echo \"Generated POSTGRES_ADMIN_PASSWORD: \$POSTGRES_ADMIN_PASSWORD\"\r"
expect "root@*"

send "ACCESS_TOKEN_SECRET=\$(openssl rand -base64 32)\r"
expect "root@*"
send "echo \"Generated ACCESS_TOKEN_SECRET: \$ACCESS_TOKEN_SECRET\"\r"
expect "root@*"

send "LOGIN_TOKEN_SECRET=\$(openssl rand -base64 32)\r"
expect "root@*"
send "echo \"Generated LOGIN_TOKEN_SECRET: \$LOGIN_TOKEN_SECRET\"\r"
expect "root@*"

send "REFRESH_TOKEN_SECRET=\$(openssl rand -base64 32)\r"
expect "root@*"
send "echo \"Generated REFRESH_TOKEN_SECRET: \$REFRESH_TOKEN_SECRET\"\r"
expect "root@*"

send "FILE_TOKEN_SECRET=\$(openssl rand -base64 32)\r"
expect "root@*"
send "echo \"Generated FILE_TOKEN_SECRET: \$FILE_TOKEN_SECRET\"\r"
expect "root@*"

# Update .env file with generated secrets
send "sed -i \"s/POSTGRES_ADMIN_PASSWORD=.*/POSTGRES_ADMIN_PASSWORD=\$POSTGRES_ADMIN_PASSWORD/\" .env\r"
expect "root@*"
send "sed -i \"s/ACCESS_TOKEN_SECRET=.*/ACCESS_TOKEN_SECRET=\$ACCESS_TOKEN_SECRET/\" .env\r"
expect "root@*"
send "sed -i \"s/LOGIN_TOKEN_SECRET=.*/LOGIN_TOKEN_SECRET=\$LOGIN_TOKEN_SECRET/\" .env\r"
expect "root@*"
send "sed -i \"s/REFRESH_TOKEN_SECRET=.*/REFRESH_TOKEN_SECRET=\$REFRESH_TOKEN_SECRET/\" .env\r"
expect "root@*"
send "sed -i \"s/FILE_TOKEN_SECRET=.*/FILE_TOKEN_SECRET=\$FILE_TOKEN_SECRET/\" .env\r"
expect "root@*"

# Set server URL
send "sed -i \"s|SERVER_URL=.*|SERVER_URL=https://crm.vividwalls.blog|\" .env\r"
expect "root@*"

# Check if docker-compose file exists
send "ls -la docker-compose.yml\r"
expect "root@*"

# Create Caddyfile for Twenty CRM
send "cat > /opt/twenty-caddyfile << 'EOF'
crm.vividwalls.blog {
    reverse_proxy localhost:3000
    
    header {
        X-Frame-Options SAMEORIGIN
        X-Content-Type-Options nosniff
        X-XSS-Protection \"1; mode=block\"
    }
}
EOF\r"
expect "root@*"

# Start Caddy for Twenty CRM
send "docker run -d --name twenty-caddy -p 80:80 -p 443:443 -v /opt/twenty-caddyfile:/etc/caddy/Caddyfile -v caddy_data:/data -v caddy_config:/config caddy:latest\r"
expect "root@*"

# Start Twenty CRM with docker-compose
send "docker compose up -d\r"
expect "root@*"

# Check running containers
send "docker ps\r"
expect "root@*"

# Check Twenty CRM logs
send "docker compose logs --tail=50\r"
expect "root@*"

# Create DNS record for crm.vividwalls.blog
send "echo 'Please create an A record for crm.vividwalls.blog pointing to 157.230.13.13'\r"
expect "root@*"

# Exit
send "exit\r"
expect eof