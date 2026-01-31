#!/bin/bash

# Deploy Approval System to DigitalOcean Droplet
# This script copies all approval system components to the frontend_v1 directory on the droplet

DROPLET_IP="157.230.13.13"
SSH_KEY="~/.ssh/digitalocean"
REMOTE_DIR="/root/vivid_mas/frontend_v1"
LOCAL_BASE="/Volumes/SeagatePortableDrive/Projects/vivid_mas/frontend-integration"

echo "🚀 Deploying Approval System to DigitalOcean Droplet"
echo "=================================================="

# Create necessary directories on droplet
echo "📁 Creating directory structure..."
ssh -i $SSH_KEY root@$DROPLET_IP "cd $REMOTE_DIR && mkdir -p \
  lib/types \
  lib/services \
  lib/hooks \
  components/approvals \
  components/dashboard \
  components/ui \
  app/api/approvals/pending \
  app/api/approvals/approve \
  app/api/approvals/reject"

# Copy type definitions
echo "📝 Copying type definitions..."
scp -i $SSH_KEY $LOCAL_BASE/lib/types/approval.types.ts root@$DROPLET_IP:$REMOTE_DIR/lib/types/

# Copy services
echo "🔧 Copying services..."
scp -i $SSH_KEY $LOCAL_BASE/lib/services/approval.service.ts root@$DROPLET_IP:$REMOTE_DIR/lib/services/

# Copy hooks
echo "🪝 Copying hooks..."
scp -i $SSH_KEY $LOCAL_BASE/lib/hooks/useApprovals.ts root@$DROPLET_IP:$REMOTE_DIR/lib/hooks/

# Copy approval components
echo "🎨 Copying approval components..."
scp -i $SSH_KEY $LOCAL_BASE/components/approvals/ApprovalCard.tsx root@$DROPLET_IP:$REMOTE_DIR/components/approvals/
scp -i $SSH_KEY $LOCAL_BASE/components/approvals/ApprovalQueue.tsx root@$DROPLET_IP:$REMOTE_DIR/components/approvals/
scp -i $SSH_KEY $LOCAL_BASE/components/approvals/ApprovalStats.tsx root@$DROPLET_IP:$REMOTE_DIR/components/approvals/
scp -i $SSH_KEY $LOCAL_BASE/components/approvals/ApprovalFilters.tsx root@$DROPLET_IP:$REMOTE_DIR/components/approvals/
scp -i $SSH_KEY $LOCAL_BASE/components/approvals/ApprovalNotifications.tsx root@$DROPLET_IP:$REMOTE_DIR/components/approvals/
scp -i $SSH_KEY $LOCAL_BASE/components/approvals/index.ts root@$DROPLET_IP:$REMOTE_DIR/components/approvals/

# Copy enhanced dashboard
echo "📊 Copying enhanced dashboard..."
scp -i $SSH_KEY $LOCAL_BASE/components/dashboard/EnhancedAgentDashboard.tsx root@$DROPLET_IP:$REMOTE_DIR/components/dashboard/

# Copy UI components index
echo "🎯 Copying UI components..."
scp -i $SSH_KEY $LOCAL_BASE/components/ui/index.ts root@$DROPLET_IP:$REMOTE_DIR/components/ui/

# Copy API routes
echo "🌐 Copying API routes..."
scp -i $SSH_KEY $LOCAL_BASE/app/api/approvals/pending/route.ts root@$DROPLET_IP:$REMOTE_DIR/app/api/approvals/pending/
scp -i $SSH_KEY $LOCAL_BASE/app/api/approvals/approve/route.ts root@$DROPLET_IP:$REMOTE_DIR/app/api/approvals/approve/
scp -i $SSH_KEY $LOCAL_BASE/app/api/approvals/reject/route.ts root@$DROPLET_IP:$REMOTE_DIR/app/api/approvals/reject/

# Check if we need to create/update the hooks and services directories
echo "📂 Checking existing hooks..."
ssh -i $SSH_KEY root@$DROPLET_IP "ls -la $REMOTE_DIR/lib/hooks/"

# Install dependencies if needed
echo "📦 Checking dependencies..."
ssh -i $SSH_KEY root@$DROPLET_IP "cd $REMOTE_DIR && if [ -f package.json ]; then npm list @types/react 2>/dev/null || npm install --save @types/react @types/node; fi"

# Create a simple integration file to connect approval system to existing dashboard
echo "🔗 Creating integration file..."
cat << 'INTEGRATION' | ssh -i $SSH_KEY root@$DROPLET_IP "cat > $REMOTE_DIR/app/page.tsx"
'use client'

import { EnhancedAgentDashboard } from '@/components/dashboard/EnhancedAgentDashboard'

export default function Home() {
  return (
    <main className="min-h-screen">
      <EnhancedAgentDashboard />
    </main>
  )
}
INTEGRATION

echo "✅ Approval System Deployment Complete!"
echo ""
echo "Next steps:"
echo "1. SSH into droplet: ssh -i ~/.ssh/digitalocean root@$DROPLET_IP"
echo "2. Navigate to frontend: cd $REMOTE_DIR"
echo "3. Install dependencies: npm install"
echo "4. Build the app: npm run build"
echo "5. Start the app: npm run start"
echo ""
echo "Or if using Docker:"
echo "1. Build image: docker build -t vividwalls-frontend ."
echo "2. Run container: docker run -d -p 3000:3000 vividwalls-frontend"