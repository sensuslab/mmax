#!/bin/bash

# ============================================================================
# KORTIX/SUNA AUTOMATED SETUP & DEPLOYMENT SCRIPT
# This script:
# 1. Installs all prerequisites
# 2. Clones the Kortix/Suna repository
# 3. Sets up the environment
# 4. Deploys the application
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
║                                                              ║
║     🚀 KORTIX/SUNA AUTO-SETUP & DEPLOYMENT 🚀               ║
║                                                              ║
║  This script will:                                          ║
║  1. Install all prerequisites                               ║
║  2. Clone Kortix/Suna repository                            ║
║  3. Configure environment                                   ║
║  4. Deploy the application                                  ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

EOF

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root for security reasons"
   exit 1
fi

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    print_status "Detected Linux OS"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    print_warning "Detected macOS - This script is designed for Linux servers"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    print_error "Unsupported operating system: $OSTYPE"
    exit 1
fi

# ============================================================================
# Step 1: Install System Dependencies
# ============================================================================
print_step "STEP 1: Installing System Dependencies"

if [[ "$OS" == "linux" ]]; then
    sudo apt-get update -qq
    sudo apt-get install -y curl wget git build-essential apt-transport-https ca-certificates gnupg lsb-release software-properties-common bc
    print_status "System dependencies installed"
else
    # Check for Homebrew on macOS
    if ! command -v brew &> /dev/null; then
        print_warning "Homebrew not found. Please install Homebrew first:"
        echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    print_status "Homebrew detected"
fi

# ============================================================================
# Step 2: Install Docker & Docker Compose
# ============================================================================
print_step "STEP 2: Installing Docker & Docker Compose"

if ! command -v docker &> /dev/null; then
    if [[ "$OS" == "linux" ]]; then
        # Add Docker's official GPG key
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

        # Add Docker repository
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        # Install Docker
        sudo apt-get update -qq
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

        # Add user to docker group
        sudo usermod -aG docker $USER
        print_status "Docker installed and user added to docker group"
        print_warning "You may need to log out and back in for docker group changes to take effect"
    else
        print_warning "Please install Docker Desktop for macOS from: https://www.docker.com/products/docker-desktop"
        exit 1
    fi
else
    print_status "Docker already installed: $(docker --version)"
fi

# Install Docker Compose (standalone) if not available as plugin
if ! docker compose version &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o ~/docker-compose
    chmod +x ~/docker-compose
    sudo mv ~/docker-compose /usr/local/bin/docker-compose
    print_status "Docker Compose installed"
else
    print_status "Docker Compose already available"
fi

# ============================================================================
# Step 3: Install Python 3.11+
# ============================================================================
print_step "STEP 3: Installing Python 3.11+"

if command -v python3.11 &> /dev/null; then
    print_status "Python 3.11 already installed"
elif command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
    if [[ $(echo "$PYTHON_VERSION >= 3.11" | bc -l 2>/dev/null || python3 -c "import sys; sys.exit(0 if sys.version_info >= (3, 11) else 1)") ]]; then
        print_status "Python $PYTHON_VERSION already installed (meets requirement)"
    else
        if [[ "$OS" == "linux" ]]; then
            sudo apt-get install -y python3.11 python3.11-venv python3.11-dev python3.11-pip
            print_status "Python 3.11 installed"
        else
            print_warning "Please install Python 3.11+ via Homebrew or python.org"
        fi
    fi
else
    if [[ "$OS" == "linux" ]]; then
        sudo apt-get install -y python3.11 python3.11-venv python3.11-dev python3.11-pip
        print_status "Python 3.11 installed"
    else
        print_warning "Please install Python 3.11+ via Homebrew or python.org"
    fi
fi

# ============================================================================
# Step 4: Install Node.js 20+
# ============================================================================
print_step "STEP 4: Installing Node.js 20+"

if ! command -v node &> /dev/null || [[ $(node --version | cut -d'v' -f2 | cut -d'.' -f1) -lt 20 ]]; then
    if [[ "$OS" == "linux" ]]; then
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt-get install -y nodejs
        print_status "Node.js 20 installed"
    else
        print_warning "Please install Node.js 20+ via Homebrew: brew install node"
    fi
else
    print_status "Node.js $(node --version) already installed"
fi

# ============================================================================
# Step 5: Install uv (Python Package Manager)
# ============================================================================
print_step "STEP 5: Installing uv (Python Package Manager)"

if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source ~/.bashrc 2>/dev/null || source ~/.zshrc 2>/dev/null || source ~/.profile

    # Ensure uv is in PATH for current session
    export PATH="$HOME/.cargo/bin:$PATH"

    # Add to PATH permanently
    if [[ -f ~/.bashrc ]]; then
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    fi
    if [[ -f ~/.zshrc ]]; then
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
    fi

    print_status "uv installed"
else
    print_status "uv already installed"
fi

# ============================================================================
# Step 6: Install mise (Tool Version Manager)
# ============================================================================
print_step "STEP 6: Installing mise (Tool Version Manager)"

if ! command -v mise &> /dev/null; then
    curl -LsSf https://github.com/jdx/mise/releases/latest/download/mise-linux-x64.tar.gz | tar -xzO > ~/mise
    chmod +x ~/mise
    sudo mv ~/mise /usr/local/bin/mise
    print_status "mise installed"
else
    print_status "mise already installed"
fi

# ============================================================================
# Step 7: Clone Kortix/Suna Repository
# ============================================================================
print_step "STEP 7: Cloning Kortix/Suna Repository"

# Check if already cloned
if [ -d "suna" ] || [ -d "mmax" ]; then
    print_warning "Repository directory already exists"
    read -p "Remove and re-clone? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf suna mmax
    else
        print_info "Using existing directory"
    fi
fi

# Clone repository
if [ ! -d "suna" ]; then
    print_info "Cloning https://github.com/kortix-ai/suna.git..."
    git clone https://github.com/kortix-ai/suna.git
    print_status "Repository cloned successfully"
else
    print_status "Repository already exists"
fi

# ============================================================================
# Step 8: Verify Installations
# ============================================================================
print_step "STEP 8: Verifying Installations"

echo ""
print_status "Docker: $(docker --version)"
print_status "Docker Compose: $(docker compose version)"
print_status "Python: $(python3 --version)"
print_status "Node.js: $(node --version)"
print_status "npm: $(npm --version)"
print_status "uv: $(uv --version)"
print_status "mise: $(mise --version)"
print_status "Git: $(git --version)"
print_status "Repository: $(pwd)/suna"

# ============================================================================
# Step 9: Display Next Steps
# ============================================================================
cat << "EOF"

╔══════════════════════════════════════════════════════════════╗
║                  ✅ SETUP COMPLETE! ✅                       ║
╚══════════════════════════════════════════════════════════════╝

All prerequisites installed and repository cloned!

📍 YOUR REPOSITORY LOCATION:
   /home/user/suna  (or current directory/suna)

🔧 NEXT STEPS:

   1. Configure your environment:
      cd suna
      nano config.env      # Add your configuration

   2. Run the deployment:
      chmod +x deploy-with-config.sh
      ./deploy-with-config.sh

   3. Access your application:
      Frontend: http://your-server-ip:3000
      Backend:  http://your-server-ip:8000

📋 WHAT YOU NEED TO DO:

   Create a config.env file with your environment variables.
   You can copy from .env.production and update as needed.

📚 DOCUMENTATION:
   • See DEPLOYMENT_README.md in the repository
   • See CUSTOMIZATION_GUIDE.md for UI customization

╔══════════════════════════════════════════════════════════════╗
║  Ready for deployment! Run the config and deploy scripts 🎉  ║
╚══════════════════════════════════════════════════════════════╝

EOF
