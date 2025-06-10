@echo off
setlocal enabledelayedexpansion

echo 🏥 Building Offline Doctor - AI Medical Assistant
echo ==================================================

REM Check for Docker
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker not found. Please install Docker first:
    echo Windows: https://docs.docker.com/desktop/windows/install/
    exit /b 1
)

REM Check if we're in the right directory
if not exist "package.json" (
    echo ❌ Error: Please run this script from the project root directory
    exit /b 1
)

echo 🐳 Setting up Docker build environment...

REM Create Docker builder image
(
echo FROM electronuserland/builder:wine
echo.
echo # Install system dependencies
echo RUN apt-get update ^&^& apt-get install -y \
echo     python3 \
echo     python3-pip \
echo     python3-venv \
echo     ^&^& rm -rf /var/lib/apt/lists/*
echo.
echo # Set up work directory
echo WORKDIR /app
echo.
echo # Copy package files first for better caching
echo COPY package*.json ./
echo.
echo # Install Node.js dependencies
echo RUN npm install
echo.
echo # Copy the rest of the application
echo COPY . .
echo.
echo # Set up Python environment
echo RUN cd backend ^&^& \
echo     python3 -m venv venv ^&^& \
echo     . venv/bin/activate ^&^& \
echo     pip install -r requirements.txt ^&^& \
echo     deactivate
echo.
echo # Set environment variables
echo ENV USE_SYSTEM_WINE=true
echo ENV ELECTRON_CACHE="/root/.cache/electron"
echo ENV ELECTRON_BUILDER_CACHE="/root/.cache/electron-builder"
) > Dockerfile.builder

echo 🏗️ Building Docker image...
docker build -t offline-doctor-builder-image -f Dockerfile.builder .

echo 📦 Building application packages...
docker run --rm -it ^
    -v "%CD%":/app ^
    -v "%CD%\dist":/app/dist ^
    --name offline-doctor-builder ^
    offline-doctor-builder-image ^
    /bin/bash -c "npm run build-linux && npm run build-win && npm run build-mac"

REM Cleanup
echo 🧹 Cleaning up...
docker rm -f offline-doctor-builder >nul 2>&1
docker rmi -f offline-doctor-builder-image >nul 2>&1

echo.
echo ✅ Build completed! Packages are in the 'dist' directory:
echo ----------------------------------------------------
dir /b dist
echo.
echo 📦 Available packages:
echo   • Windows: dist\Offline Doctor Setup.exe
echo   • Linux:   dist\Offline Doctor.AppImage
echo   • macOS:   dist\Offline Doctor.dmg
echo.
echo Note: macOS builds on non-macOS hosts are not code-signed
echo and require additional steps for distribution.
echo.
