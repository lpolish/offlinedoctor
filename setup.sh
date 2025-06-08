#!/bin/bash

# Offline Doctor Setup Script for Linux/macOS
# This script sets up the complete environment for the Offline Doctor application

set -e

echo "🏥 Setting up Offline Doctor - AI Medical Assistant"
echo "=================================================="

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
    sleep 3
fi

# Pull medical model
echo "📥 Setting up medical AI model..."
echo "This may take a while depending on your internet connection..."
if ollama list | grep -q "llama3.1:8b"; then
    echo "✅ Llama 3.1 model already available"
else
    echo "Downloading Llama 3.1 model..."
    ollama pull llama3.1:8b
fi

# Create desktop entry (Linux only)
if [ "$(uname)" = "Linux" ]; then
    echo "🖥️  Creating desktop entry..."
    cat > ~/.local/share/applications/offline-doctor.desktop << EOF
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
    chmod +x ~/.local/share/applications/offline-doctor.desktop
    echo "✅ Desktop entry created"
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
echo "  1. The AI model (llama2) has been downloaded"
echo "  2. All conversations are stored locally"
echo "  3. No internet connection required after setup"
echo "  4. Always consult healthcare professionals for serious medical concerns"
echo ""
