#!/bin/bash

# Kortix/Suna Server Deployment Setup Script
# This script installs all prerequisites for deploying Kortix/Suna on a remote server

set -e  # Exit on error

echo "🚀 Starting Kortix/Suna Server Setup..."
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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
    print_status "Detected macOS"
else
    print_error "Unsupported operating system: $OSTYPE"
    exit 1
fi

echo ""
echo "📦 Step 1: Installing System Dependencies"
echo "========================================="

# Install essential packages (Linux)
if [[ "$OS" == "linux" ]]; then
    sudo apt-get update -qq
    sudo apt-get install -y curl wget git build-essential apt-transport-https ca-certificates gnupg lsb-release software-properties-common
    print_status "Installed system dependencies"
else
    # Check for Homebrew on macOS
    if ! command -v brew &> /dev/null; then
        print_warning "Homebrew not found. Please install Homebrew first:"
        echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    print_status "Homebrew detected"
fi

echo ""
echo "🔧 Step 2: Installing Docker & Docker Compose"
echo "=============================================="

# Install Docker
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
        # macOS - Docker Desktop
        print_warning "Please install Docker Desktop for macOS from: https://www.docker.com/products/docker-desktop"
        exit 1
    fi
else
    print_status "Docker already installed"
fi

# Install Docker Compose (standalone)
if ! command -v docker compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o ~/docker-compose
    chmod +x ~/docker-compose
    sudo mv ~/docker-compose /usr/local/bin/docker-compose
    print_status "Docker Compose installed"
else
    print_status "Docker Compose already installed"
fi

echo ""
echo "🐍 Step 3: Installing Python 3.11+"
echo "==================================="

# Install Python 3.11
if command -v python3.11 &> /dev/null; then
    print_status "Python 3.11 already installed"
elif command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
    if [[ $(echo "$PYTHON_VERSION >= 3.11" | bc -l 2>/dev/null || python3 -c "import sys; sys.exit(0 if sys.version_info >= (3, 11) else 1)") ]]; then
        print_status "Python $PYTHON_VERSION already installed (meets requirement)"
    else
        if [[ "$OS" == "linux" ]]; then
            sudo apt-get install -y python3.11 python3.11-venv python3.11-dev
            print_status "Python 3.11 installed"
        else
            print_warning "Please install Python 3.11+ via Homebrew or python.org"
        fi
    fi
else
    if [[ "$OS" == "linux" ]]; then
        sudo apt-get install -y python3.11 python3.11-venv python3.11-dev
        print_status "Python 3.11 installed"
    else
        print_warning "Please install Python 3.11+ via Homebrew or python.org"
    fi
fi

# Install pip for Python 3.11
if [[ "$OS" == "linux" ]]; then
    sudo apt-get install -y python3.11-pip
    print_status "Python pip installed"
fi

echo ""
echo "🅽 Step 4: Installing Node.js 20+"
echo "================================="

# Install Node.js via NodeSource
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

# Verify npm
if ! command -v npm &> /dev/null; then
    print_warning "npm not found. Installing..."
    sudo apt-get install -y npm
fi

echo ""
echo "⚡ Step 5: Installing uv (Python Package Manager)"
echo "================================================="

# Install uv
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

echo ""
echo "🛠️  Step 6: Installing mise (Tool Version Manager)"
echo "=================================================="

# Install mise
if ! command -v mise &> /dev/null; then
    curl -LsSf https://github.com/jdx/mise/releases/latest/download/mise-linux-x64.tar.gz | tar -xzO > ~/mise
    chmod +x ~/mise
    sudo mv ~/mise /usr/local/bin/mise
    print_status "mise installed"
else
    print_status "mise already installed"
fi

echo ""
echo "🔐 Step 7: Verifying Installations"
echo "=================================="

# Verify all installations
echo ""
print_status "Docker: $(docker --version)"
print_status "Docker Compose: $(docker compose version)"
print_status "Python: $(python3 --version)"
print_status "Node.js: $(node --version)"
print_status "npm: $(npm --version)"
print_status "uv: $(uv --version)"
print_status "mise: $(mise --version)"

echo ""
echo "✅ Setup Complete!"
echo "=================="
echo ""
echo "Next Steps:"
echo "1. Copy your .env file to the project root directory"
echo "2. Run: python setup.py"
echo "3. Choose deployment method (Docker recommended)"
echo "4. Run: python start.py"
echo ""
echo "Your server is ready for Kortix/Suna deployment! 🎉"
