#!/bin/bash

# ============================================================================
# KORTIX/SUNA DEPLOYMENT SCRIPT
# This script deploys Kortix/Suna to your server with Upstash Redis
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[ℹ]${NC} $1"
}

# Banner
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║         🚀 KORTIX/SUNA DEPLOYMENT SCRIPT 🚀                 ║
║                                                              ║
║  Deploying with Upstash Redis + Cloud Supabase              ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

EOF

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

print_info "Starting deployment process..."
echo ""

# ============================================================================
# Step 1: Check Prerequisites
# ============================================================================
print_info "Step 1: Checking prerequisites..."

# Check Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker not found. Please run server-setup.sh first"
    exit 1
fi
print_status "Docker is installed"

# Check Docker Compose
if ! command -v docker compose &> /dev/null; then
    print_error "Docker Compose not found. Please run server-setup.sh first"
    exit 1
fi
print_status "Docker Compose is installed"

# Check if .env file exists
if [ ! -f "backend/.env" ]; then
    if [ -f ".env.production" ]; then
        print_info "Copying .env.production to backend/.env..."
        cp .env.production backend/.env
        print_status "Environment file configured"
    else
        print_error ".env file not found. Please create backend/.env"
        exit 1
    fi
else
    print_status "Environment file exists"
fi

# ============================================================================
# Step 2: Build and Start Services
# ============================================================================
print_info "Step 2: Building and starting services..."
echo ""

# Pull latest images
print_info "Pulling latest images..."
docker compose -f docker-compose.production.yaml pull || true

# Build services
print_info "Building services (this may take a few minutes)..."
docker compose -f docker-compose.production.yaml build --no-cache

# Start services
print_info "Starting services..."
docker compose -f docker-compose.production.yaml up -d

# ============================================================================
# Step 3: Wait for Services to be Ready
# ============================================================================
print_info "Step 3: Waiting for services to be ready..."

# Wait for backend
print_info "Waiting for backend API..."
for i in {1..30}; do
    if curl -s http://localhost:8000/health > /dev/null 2>&1; then
        print_status "Backend API is ready"
        break
    fi
    if [ $i -eq 30 ]; then
        print_error "Backend API failed to start"
        print_info "Check logs with: docker compose -f docker-compose.production.yaml logs backend"
        exit 1
    fi
    echo -n "."
    sleep 2
done

# Wait for frontend
print_info "Waiting for frontend..."
for i in {1..30}; do
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        print_status "Frontend is ready"
        break
    fi
    if [ $i -eq 30 ]; then
        print_warning "Frontend may still be starting up"
        break
    fi
    echo -n "."
    sleep 2
done

# Wait for worker
print_info "Waiting for worker..."
sleep 5

# ============================================================================
# Step 4: Display Status
# ============================================================================
echo ""
print_info "Step 4: Deployment Status"
echo ""

# Show service status
docker compose -f docker-compose.production.yaml ps

echo ""
print_info "Service Endpoints:"
echo "  • Frontend:    http://localhost:3000"
echo "  • Backend API: http://localhost:8000"
echo ""

# Show resource usage
print_info "Resource Usage:"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

echo ""
# ============================================================================
# Step 5: Display Next Steps
# ============================================================================
cat << "EOF"

╔══════════════════════════════════════════════════════════════╗
║                    🎉 DEPLOYMENT SUCCESSFUL! 🎉              ║
╚══════════════════════════════════════════════════════════════╝

Your Kortix/Suna instance is now running!

📍 ACCESS YOUR APPLICATION:
   • Web UI:    http://localhost:3000
   • API:       http://localhost:8000

🔧 COMMON COMMANDS:

   View logs:
   $ docker compose -f docker-compose.production.yaml logs -f

   Restart services:
   $ docker compose -f docker-compose.production.yaml restart

   Stop services:
   $ docker compose -f docker-compose.production.yaml down

   Update application:
   $ git pull && docker compose -f docker-compose.production.yaml up -d --build

🎨 CUSTOMIZE YOUR DEPLOYMENT:

   Edit home page:
   $ nano frontend/src/lib/home.tsx

   Configure agents:
   Visit http://localhost:3000 and create your first agent!

📚 DOCUMENTATION:

   • Customization Guide: CUSTOMIZATION_GUIDE.md
   • Server Guide:       SERVER_DEPLOYMENT_GUIDE.md

🆘 NEED HELP?

   • GitHub: https://github.com/kortix-ai/suna/issues
   • Discord: https://discord.gg/Py6pCBUUPw

╔══════════════════════════════════════════════════════════════╗
║  Happy deploying! Your AI workforce is ready to launch! 🚀  ║
╚══════════════════════════════════════════════════════════════╝

EOF

# Show a summary
echo ""
print_info "Quick Summary:"
echo "  Services Running: $(docker compose -f docker-compose.production.yaml ps -q | wc -l)"
echo "  Docker Images: $(docker images -q | wc -l) built"
echo ""
print_status "Deployment complete!"
