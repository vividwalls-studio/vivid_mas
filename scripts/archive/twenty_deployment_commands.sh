#!/bin/bash
# Commands to deploy Twenty CRM on DigitalOcean

# 1. Clone Twenty CRM
cd /opt
git clone https://github.com/twentyhq/twenty.git

# 2. Navigate to docker directory
cd /opt/twenty/packages/twenty-docker

# 3. Create .env file
cp .env.example .env

# 4. Generate secrets
POSTGRES_ADMIN_PASSWORD=$(openssl rand -base64 32)
ACCESS_TOKEN_SECRET=$(openssl rand -base64 32)
LOGIN_TOKEN_SECRET=$(openssl rand -base64 32)
REFRESH_TOKEN_SECRET=$(openssl rand -base64 32)
FILE_TOKEN_SECRET=$(openssl rand -base64 32)

# 5. Update .env with secrets
sed -i "s/POSTGRES_ADMIN_PASSWORD=.*/POSTGRES_ADMIN_PASSWORD=$POSTGRES_ADMIN_PASSWORD/" .env
sed -i "s/ACCESS_TOKEN_SECRET=.*/ACCESS_TOKEN_SECRET=$ACCESS_TOKEN_SECRET/" .env
sed -i "s/LOGIN_TOKEN_SECRET=.*/LOGIN_TOKEN_SECRET=$LOGIN_TOKEN_SECRET/" .env
sed -i "s/REFRESH_TOKEN_SECRET=.*/REFRESH_TOKEN_SECRET=$REFRESH_TOKEN_SECRET/" .env
sed -i "s/FILE_TOKEN_SECRET=.*/FILE_TOKEN_SECRET=$FILE_TOKEN_SECRET/" .env
sed -i "s|SERVER_URL=.*|SERVER_URL=https://crm.vividwalls.blog|" .env

# 6. Update existing Caddyfile to include Twenty CRM
cd /home/vivid/vivid_mas
cp Caddyfile Caddyfile.backup
echo "" >> Caddyfile
echo "# Twenty CRM" >> Caddyfile
echo "crm.vividwalls.blog {" >> Caddyfile
echo "    reverse_proxy localhost:3000" >> Caddyfile
echo "    header {" >> Caddyfile
echo "        X-Frame-Options SAMEORIGIN" >> Caddyfile
echo "        X-Content-Type-Options nosniff" >> Caddyfile
echo "        X-XSS-Protection \"1; mode=block\"" >> Caddyfile
echo "    }" >> Caddyfile
echo "}" >> Caddyfile

# 7. Restart Caddy
docker restart caddy

# 8. Start Twenty CRM
cd /opt/twenty/packages/twenty-docker
docker compose up -d

# 9. Check status
docker ps | grep twenty

# 10. Show logs
docker compose logs --tail=20