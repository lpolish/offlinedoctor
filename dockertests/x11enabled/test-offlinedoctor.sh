#!/bin/bash

# Test script for Offline Doctor application in fresh Ubuntu environment
# Run this script inside the Docker container as the testuser

echo "=== Offline Doctor Application Test Script ==="
echo "Testing application setup in fresh Ubuntu 24.04 environment"
echo ""

# Check if we're in the right directory
if [ ! -f "/opt/offlinedoctor/package.json" ]; then
    echo "Navigating to Offline Doctor directory..."
    cd /opt/offlinedoctor
fi

echo "Current directory: $(pwd)"
echo "Current user: $(whoami)"
echo ""

# Test X11 forwarding first
echo "1. Testing X11 forwarding..."
if command -v xeyes >/dev/null 2>&1; then
    echo "✓ X11 applications are available"
    echo "  You can test X11 with: xeyes &"
else
    echo "✗ X11 applications not found"
fi
echo ""

# Check Node.js and npm
echo "2. Checking Node.js environment..."
if command -v node >/dev/null 2>&1; then
    echo "✓ Node.js version: $(node --version)"
else
    echo "✗ Node.js not found"
fi

if command -v npm >/dev/null 2>&1; then
    echo "✓ npm version: $(npm --version)"
else
    echo "✗ npm not found"
fi
echo ""

# Check Python
echo "3. Checking Python environment..."
if command -v python3 >/dev/null 2>&1; then
    echo "✓ Python version: $(python3 --version)"
else
    echo "✗ Python3 not found"
fi

if command -v pip3 >/dev/null 2>&1; then
    echo "✓ pip3 version: $(pip3 --version)"
else
    echo "✗ pip3 not found"
fi
echo ""

# Install npm dependencies
echo "4. Installing npm dependencies..."
if [ -f "package.json" ]; then
    npm install
    if [ $? -eq 0 ]; then
        echo "✓ npm dependencies installed successfully"
    else
        echo "✗ Failed to install npm dependencies"
    fi
else
    echo "✗ package.json not found"
fi
echo ""

# Install Python dependencies
echo "5. Installing Python dependencies..."
if [ -f "backend/requirements.txt" ]; then
    pip3 install -r backend/requirements.txt
    if [ $? -eq 0 ]; then
        echo "✓ Python dependencies installed successfully"
    else
        echo "✗ Failed to install Python dependencies"
    fi
else
    echo "✗ backend/requirements.txt not found"
fi
echo ""

# Check if Ollama is available (it won't be, but we should note it)
echo "6. Checking for Ollama..."
if command -v ollama >/dev/null 2>&1; then
    echo "✓ Ollama is available"
    ollama --version
else
    echo "ℹ Ollama not installed (expected in test environment)"
    echo "  For full functionality, install Ollama: https://ollama.ai/"
fi
echo ""

# Test Electron availability
echo "7. Testing Electron..."
if [ -d "node_modules/.bin" ] && [ -f "node_modules/.bin/electron" ]; then
    echo "✓ Electron is available"
    echo "  Version: $(./node_modules/.bin/electron --version)"
else
    echo "ℹ Electron not found - try running 'npm install' first"
fi
echo ""

echo "=== Test Summary ==="
echo "✓ = Working correctly"
echo "✗ = Issue found"
echo "ℹ = Information/Expected behavior"
echo ""
echo "To run the application (after installing Ollama):"
echo "  npm start"
echo ""
echo "To test X11 forwarding:"
echo "  xeyes &"
echo ""
echo "For a complete setup, refer to the project's README.md"
