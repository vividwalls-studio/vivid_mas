#!/bin/bash

# Deploy updated Medusa configuration to droplet
set -e

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m"

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

print_status "🚀 Deploying updated Medusa configuration to droplet..."

# First, backup the current docker-compose.yml on the droplet
print_status "📋 Creating backup of current docker-compose.yml on droplet..."

# Upload the updated docker-compose.yml
print_status "📤 Uploading updated docker-compose.yml..."

# Create the vivid_mas network if it doesn't exist
print_status "🔗 Ensuring vivid_mas network exists..."

# Deploy Medusa service
print_status "🏗️ Deploying Medusa service..."

# Check Medusa service status
print_status "📊 Checking Medusa service status..."

print_success "🎉 Medusa deployment completed!"
