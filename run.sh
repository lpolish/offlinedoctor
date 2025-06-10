#!/bin/bash

# Offline Doctor Run Script
# Automatically starts all required services

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check dependencies
if ! command_exists node; then
    echo "❌ Node.js not found. Please run setup.sh first."
    exit 1
fi

if ! command_exists python3; then
    echo "❌ Python not found. Please run setup.sh first."
    exit 1
fi

if ! command_exists ollama; then
    echo "❌ Ollama not found. Please run setup.sh first."
    exit 1
fi

# Start Ollama service if not running
if ! pgrep -f "ollama serve" > /dev/null; then
    echo "🚀 Starting Ollama service..."
    nohup ollama serve > /dev/null 2>&1 &
    sleep 2
fi

# Set up environment for GUI
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
    if command_exists xvfb-run; then
        echo "🖥️  Starting virtual display..."
        exec xvfb-run -a npm start
    else
        echo "⚠️  No display detected and xvfb not available"
        echo "Running in headless mode..."
    fi
fi

# Start the application
echo "🏥 Starting Offline Doctor..."
npm start
