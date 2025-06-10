#!/bin/bash

# Offline Doctor Build Script
# Uses Docker to build distributable packages for all platforms

set -e

echo "🏥 Building Offline Doctor - AI Medical Assistant"
echo "=================================================="

# Check for Docker
if ! command -v docker >/dev/null 2>&1; then
    echo "❌ Docker not found. Please install Docker first:"
    echo "Linux: https://docs.docker.com/engine/install/"
    echo "macOS: https://docs.docker.com/desktop/mac/install/"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    exit 1
fi

# Function to cleanup on exit
cleanup() {
    echo "🧹 Cleaning up..."
    docker rm -f offline-doctor-builder 2>/dev/null || true
    docker rmi -f offline-doctor-builder-image 2>/dev/null || true
}
trap cleanup EXIT

echo "🐳 Setting up Docker build environment..."

# Create Docker builder image
cat > Dockerfile.builder << 'EOF'
FROM electronuserland/builder:wine

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Set up work directory
WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Set up Python environment
RUN cd backend && \
    python3 -m venv venv && \
    . venv/bin/activate && \
    pip install -r requirements.txt && \
    deactivate

# Set environment variables
ENV USE_SYSTEM_WINE=true
ENV ELECTRON_CACHE="/root/.cache/electron"
ENV ELECTRON_BUILDER_CACHE="/root/.cache/electron-builder"

EOF

echo "🏗️ Building Docker image..."
docker build -t offline-doctor-builder-image -f Dockerfile.builder .

echo "📦 Building application packages..."
docker run --rm -it \
    -v ${PWD}:/app \
    -v ${PWD}/dist:/app/dist \
    --name offline-doctor-builder \
    offline-doctor-builder-image \
    /bin/bash -c "npm run build-linux && npm run build-win && npm run build-mac"

echo ""
echo "✅ Build completed! Packages are in the 'dist' directory:"
echo "----------------------------------------------------"
ls -lh dist/
echo ""
echo "📦 Available packages:"
echo "  • Windows: dist/Offline Doctor Setup.exe"
echo "  • Linux:   dist/Offline Doctor.AppImage"
echo "  • macOS:   dist/Offline Doctor.dmg"
echo ""
echo "Note: macOS builds on non-macOS hosts are not code-signed"
echo "and require additional steps for distribution."
echo ""
