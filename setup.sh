#!/bin/bash

# Offline Doctor Setup Script for Linux/macOS
# This script sets up the complete environment for the Offline Doctor application

set -e

# Function to check if we have root access
check_root_access() {
    # First check if we're already root
    if [ "$(id -u)" = "0" ]; then
        echo "✅ Running as root"
        return 0
    fi
    
    # If not root, check if we can use sudo
    if sudo -n true 2>/dev/null; then
        echo "✅ Sudo access available"
        return 0
    else
        echo "❌ This script needs root privileges for some operations"
        echo "Please run as root or make sure you have sudo access"
        echo "You can try: sudo ./setup.sh"
        return 1
    fi
}

# Function to detect package manager
detect_package_manager() {
    if command -v apt-get >/dev/null; then
        echo "apt"
    elif command -v dnf >/dev/null; then
        echo "dnf"
    elif command -v yum >/dev/null; then
        echo "yum"
    elif command -v pacman >/dev/null; then
        echo "pacman"
    elif command -v zypper >/dev/null; then
        echo "zypper"
    elif command -v brew >/dev/null; then
        echo "brew"
    else
        echo "unknown"
    fi
}

echo "🏥 Setting up Offline Doctor - AI Medical Assistant"
echo "=================================================="

# Check root access at the start
check_root_access || exit 1

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check Node.js
echo "📦 Checking Node.js installation..."
if command_exists node; then
    node_version=$(node --version)
    echo "✅ Node.js found: $node_version"
else
    echo "❌ Node.js not found. Please install Node.js 16+ from https://nodejs.org/"
    exit 1
fi

# Check npm
if command_exists npm; then
    npm_version=$(npm --version)
    echo "✅ npm found: $npm_version"
else
    echo "❌ npm not found. Please install npm"
    exit 1
fi

# Check Python
echo "🐍 Checking Python installation..."
if command_exists python3; then
    python_version=$(python3 --version)
    echo "✅ Python3 found: $python_version"
elif command_exists python; then
    python_version=$(python --version)
    echo "✅ Python found: $python_version"
else
    echo "❌ Python not found. Please install Python 3.7+ from https://python.org/"
    exit 1
fi

# Install Node.js dependencies
echo "📦 Installing Node.js dependencies..."
npm install

# Set up Python virtual environment
echo "🐍 Setting up Python backend..."
cd backend

# Create virtual environment
if [ ! -d "venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment and install dependencies
echo "Installing Python dependencies..."
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
deactivate

cd ..

# Check for Ollama
echo "🤖 Checking Ollama installation..."
if command_exists ollama; then
    ollama_version=$(ollama --version 2>/dev/null || echo "unknown")
    echo "✅ Ollama found: $ollama_version"
else
    echo "🔄 Ollama not found. Installing Ollama..."
    if command_exists curl; then
        curl -fsSL https://ollama.ai/install.sh | sh
        echo "✅ Ollama installed successfully"
    else
        echo "❌ curl not found. Please install Ollama manually from https://ollama.ai/"
        echo "   Run: curl -fsSL https://ollama.ai/install.sh | sh"
    fi
fi

# Start Ollama service (if not running)
echo "🚀 Starting Ollama service..."
if ! pgrep -f "ollama serve" > /dev/null; then
    echo "Starting Ollama in background..."
    nohup ollama serve > /dev/null 2>&1 &
    sleep 5
fi

# Pull medical model
echo "🤖 Pulling medical AI model..."
ollama pull llama2 || {
    echo "❌ Failed to pull the medical model. Please check your internet connection and try again."
    echo "You can manually pull the model later with: ollama pull llama2"
    exit 1
}

echo ""
echo "✅ Setup completed successfully!"
echo "To start the application, run: npm start"
echo "=================================================="
echo "📥 Setting up medical AI model..."
echo "This may take a while depending on your internet connection..."
if ollama list | grep -q "tinyllama"; then
    echo "✅ tinyllama model already available"
else
    echo "Downloading tinyllama model..."
    ollama pull tinyllama
fi

# Create desktop entry (Linux only)
if [ "$(uname)" = "Linux" ]; then
    echo "🖥️  Creating desktop entry..."
    
    # Determine the appropriate applications directory
    if [ "$(id -u)" = "0" ]; then
        # For root user, use system-wide applications directory
        APPS_DIR="/usr/share/applications"
    else
        # For regular user, use local applications directory
        APPS_DIR="${HOME}/.local/share/applications"
        # Create the directory if it doesn't exist
        mkdir -p "${APPS_DIR}"
    fi
    
    cat > "${APPS_DIR}/offline-doctor.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Offline Doctor
Comment=AI-powered offline medical assistant
Exec=$(pwd)/run.sh
Icon=$(pwd)/assets/icon.png
Terminal=false
StartupWMClass=Offline Doctor
Categories=Science;Education;MedicalSoftware;
EOF
    chmod +x "${APPS_DIR}/offline-doctor.desktop"
    echo "✅ Desktop entry created in ${APPS_DIR}"
fi

# Create run script
cat > run.sh << 'EOF'
#!/bin/bash
# Start Ollama service if not running
if ! pgrep -f "ollama serve" > /dev/null; then
    echo "Starting Ollama service..."
    nohup ollama serve > /dev/null 2>&1 &
    sleep 2
fi

# Start the application
npm start
EOF

chmod +x run.sh

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "To start the Offline Doctor application:"
echo "  ./run.sh"
echo ""
echo "Or use npm:"
echo "  npm start"
echo ""
echo "To build distributable packages:"
echo "  npm run build-linux    # For Linux AppImage/deb"
echo "  npm run build-win      # For Windows (cross-compile)"
echo "  npm run build-mac      # For macOS (cross-compile)"
echo ""
echo "📚 First-time usage tips:"
echo "  1. The AI model (tinyllama) has been downloaded"
echo "  2. All conversations are stored locally"
echo "  3. No internet connection required after setup"
echo "  4. Always consult healthcare professionals for serious medical concerns"
echo ""
