#!/bin/bash

# ============================================================================
# KORTIX/SUNA CONFIGURATION & DEPLOYMENT SCRIPT
# This script:
# 1. Applies your environment configuration
# 2. Builds and deploys the application
# 3. Verifies the deployment
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

print_step() {
    echo ""
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}=========================================${NC}"
}

# Banner
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║          🚀 KORTIX/SUNA DEPLOYMENT STARTED 🚀               ║
╚══════════════════════════════════════════════════════════════╝

EOF

# Check if we're in the right directory
if [ ! -d "suna" ]; then
    print_error "Kortix/Suna repository not found!"
    print_info "Please run this script from the parent directory of 'suna'"
    print_info "Or make sure you've run server-setup-auto.sh first"
    exit 1
fi

cd suna

# ============================================================================
# Step 1: Check for Configuration
# ============================================================================
print_step "STEP 1: Checking Configuration"

if [ ! -f "backend/.env" ]; then
    if [ -f "../config.env" ]; then
        print_info "Found config.env in parent directory"
        cp ../config.env backend/.env
        print_status "Configuration copied to backend/.env"
    elif [ -f "config.env" ]; then
        print_info "Found config.env in current directory"
        cp config.env backend/.env
        print_status "Configuration copied to backend/.env"
    else
        print_error "No configuration file found!"
        print_info ""
        print_info "Please create one of the following:"
        print_info "  1. config.env (in current directory)"
        print_info "  2. ../config.env (in parent directory)"
        print_info ""
        print_info "You can use .env.production as a template:"
        print_info "  cp .env.production config.env"
        print_info "  nano config.env  # Edit with your values"
        print_info ""
        read -p "Create config.env from .env.production now? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cp .env.production config.env
            print_warning "Please edit config.env with your configuration!"
            print_warning "Run: nano config.env"
            print_warning "Then re-run this script"
            exit 1
        else
            exit 1
        fi
    fi
else
    print_status "Configuration file found at backend/.env"
fi

# ============================================================================
# Step 2: Build Docker Images
# ============================================================================
print_step "STEP 2: Building Docker Images"

print_info "This may take 10-15 minutes on first build..."
docker compose -f docker-compose.production.yaml build --no-cache

print_status "Docker images built successfully"

# ============================================================================
# Step 3: Start Services
# ============================================================================
print_step "STEP 3: Starting Services"

docker compose -f docker-compose.production.yaml up -d

print_status "Services started"

# ============================================================================
# Step 4: Wait for Services to be Ready
# ============================================================================
print_step "STEP 4: Waiting for Services to be Ready"

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
# Step 5: Display Status
# ============================================================================
print_step "STEP 5: Deployment Status"

echo ""
docker compose -f docker-compose.production.yaml ps

echo ""
print_info "Service Endpoints:"
echo "  • Frontend:    http://$(hostname -I | awk '{print $1}'):3000"
echo "  • Backend API: http://$(hostname -I | awk '{print $1}'):8000"

print_info "Local Endpoints:"
echo "  • Frontend:    http://localhost:3000"
echo "  • Backend API: http://localhost:8000"

echo ""
print_info "Resource Usage:"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" 2>/dev/null || true

# ============================================================================
# Step 6: Display Next Steps
# ============================================================================
cat << "EOF"

╔══════════════════════════════════════════════════════════════╗
║                  🎉 DEPLOYMENT SUCCESSFUL! 🎉                ║
╚══════════════════════════════════════════════════════════════╝

Your Kortix/Suna instance is now running!

🔗 ACCESS YOUR APPLICATION:
   Local:  http://localhost:3000
   Network: http://YOUR_SERVER_IP:3000

🔧 COMMON COMMANDS:

   View all logs:
   $ docker compose -f docker-compose.production.yaml logs -f

   View specific service:
   $ docker compose -f docker-compose.production.yaml logs -f backend
   $ docker compose -f docker-compose.production.yaml logs -f frontend
   $ docker compose -f docker-compose.production.yaml logs -f worker

   Restart services:
   $ docker compose -f docker-compose.production.yaml restart

   Stop services:
   $ docker compose -f docker-compose.production.yaml down

   Update application:
   $ git pull && docker compose -f docker-compose.production.yaml up -d --build

🎨 CUSTOMIZE YOUR DEPLOYMENT:

   Edit home page configuration:
   $ nano frontend/src/lib/home.tsx

   Or use the web UI:
   Visit http://localhost:3000 and sign up/login
   Go to Agents → Configure

📚 DOCUMENTATION:

   • Customization Guide: CUSTOMIZATION_GUIDE.md
   • Server Guide:       SERVER_DEPLOYMENT_GUIDE.md

🆘 NEED HELP?

   • GitHub Issues: https://github.com/kortix-ai/suna/issues
   • Discord:       https://discord.gg/Py6pCBUUPw

╔══════════════════════════════════════════════════════════════╗
║   🎊 Congratulations! Your AI workforce is ready! 🎊         ║
╚══════════════════════════════════════════════════════════════╝

EOF

print_status "Deployment complete!"
