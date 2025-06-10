#!/bin/bash

# Offline Doctor Setup Test Script
# Tests the setup process in various scenarios

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo ""
echo "🧪 Offline Doctor Setup Validation Test"
echo "========================================"
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    print_error "Please run this script from the project root directory"
    exit 1
fi

print_status "Running comprehensive setup validation..."

# Test 1: Check all required dependencies
print_status "Test 1: Checking dependencies..."

if command_exists node; then
    print_success "Node.js found: $(node --version)"
else
    print_error "Node.js not found"
    exit 1
fi

if command_exists npm; then
    print_success "npm found: $(npm --version)"
else
    print_error "npm not found"
    exit 1
fi

if command_exists python3; then
    print_success "Python found: $(python3 --version)"
else
    print_error "Python not found"
    exit 1
fi

if command_exists ollama; then
    print_success "Ollama found: $(ollama --version 2>/dev/null || echo 'installed')"
else
    print_error "Ollama not found"
    exit 1
fi

# Test 2: Check Node.js dependencies
print_status "Test 2: Checking Node.js dependencies..."
if [ -d "node_modules" ]; then
    print_success "Node.js dependencies installed"
else
    print_error "Node.js dependencies not installed"
    exit 1
fi

# Test 3: Check Python backend setup
print_status "Test 3: Checking Python backend..."
if [ -d "backend/venv" ]; then
    print_success "Python virtual environment created"
else
    print_error "Python virtual environment not found"
    exit 1
fi

# Test 4: Check if Ollama service can start
print_status "Test 4: Checking Ollama service..."
if pgrep -f "ollama serve" > /dev/null; then
    print_success "Ollama service is running"
else
    print_warning "Starting Ollama service for test..."
    nohup ollama serve > /dev/null 2>&1 &
    sleep 3
    if pgrep -f "ollama serve" > /dev/null; then
        print_success "Ollama service started successfully"
    else
        print_error "Failed to start Ollama service"
        exit 1
    fi
fi

# Test 5: Check if AI model is available
print_status "Test 5: Checking AI model..."
if ollama list | grep -q "tinyllama"; then
    print_success "AI model (tinyllama) is available"
else
    print_warning "AI model not found, but this is optional for basic functionality"
fi

# Test 6: Check run script
print_status "Test 6: Checking run script..."
if [ -f "run.sh" ] && [ -x "run.sh" ]; then
    print_success "Run script exists and is executable"
else
    print_error "Run script not found or not executable"
    exit 1
fi

echo ""
print_success "🎉 All tests completed successfully!"
echo ""
echo "The Offline Doctor setup appears to be working correctly."
echo "You can now start the application with:"
echo "  ./run.sh"
echo "or"
echo "  npm start"
echo ""
