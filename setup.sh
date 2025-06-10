#!/bin/bash

# Offline Doctor Setup Script for Linux/macOS
# FULLY AUTOMATED - No manual intervention required
# Handles containers, various Linux distributions, and macOS

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Function to check if we're running in a container
in_container() {
    [ -f /.dockerenv ] || grep -q 'docker\|lxc' /proc/1/cgroup 2>/dev/null || [ -n "${KUBERNETES_SERVICE_HOST}" ]
}

# Function to detect the OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt-get; then
            echo "debian"
        elif command_exists dnf; then
            echo "fedora"
        elif command_exists pacman; then
            echo "arch"
        elif command_exists zypper; then
            echo "opensuse"
        elif command_exists apk; then
            echo "alpine"
        elif command_exists yum; then
            echo "rhel"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Function to get architecture
get_arch() {
    case "$(uname -m)" in
        x86_64)
            echo "x64"
            ;;
        aarch64|arm64)
            echo "arm64"
            ;;
        *)
            echo "x64"
            ;;
    esac
}

# Function to check if we can run as root or with sudo
can_elevate() {
    if [ "$(id -u)" = "0" ]; then
        return 0
    elif command_exists sudo && sudo -n true 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to run command with appropriate privileges
run_elevated() {
    if [ "$(id -u)" = "0" ]; then
        "$@"
    else
        sudo "$@"
    fi
}

# Function to configure non-interactive environment
setup_noninteractive() {
    # Set timezone to UTC to avoid tzdata prompts
    export TZ=UTC
    export DEBIAN_FRONTEND=noninteractive
    
    # Configure tzdata non-interactively if in container or can elevate
    if in_container || can_elevate; then
        if command_exists timedatectl; then
            run_elevated timedatectl set-timezone UTC 2>/dev/null || true
        elif [ -f /etc/timezone ]; then
            echo "UTC" | run_elevated tee /etc/timezone > /dev/null 2>&1 || true
            run_elevated dpkg-reconfigure -f noninteractive tzdata 2>/dev/null || true
        fi
    fi
}

# Function to install Node.js
install_nodejs() {
    print_status "Installing Node.js..."
    
    local os=$(detect_os)
    local arch=$(get_arch)
    
    if command_exists node; then
        print_success "Node.js already installed: $(node --version)"
        return 0
    fi
    
    case "$os" in
        "debian")
            if in_container || can_elevate; then
                # Set up non-interactive environment for package installation
                export DEBIAN_FRONTEND=noninteractive
                run_elevated apt-get update -qq
                curl -fsSL https://deb.nodesource.com/setup_18.x | run_elevated bash -
                run_elevated apt-get install -y nodejs
            else
                install_nodejs_binary
            fi
            ;;
        "fedora"|"rhel")
            if in_container || can_elevate; then
                run_elevated dnf install -y nodejs npm
            else
                install_nodejs_binary
            fi
            ;;
        "arch")
            if in_container || can_elevate; then
                run_elevated pacman -Sy --noconfirm nodejs npm
            else
                install_nodejs_binary
            fi
            ;;
        "opensuse")
            if in_container || can_elevate; then
                run_elevated zypper install -y nodejs18 npm18
            else
                install_nodejs_binary
            fi
            ;;
        "alpine")
            if in_container || can_elevate; then
                run_elevated apk add --no-cache nodejs npm
            else
                install_nodejs_binary
            fi
            ;;
        "macos")
            if command_exists brew; then
                brew install node@18
            else
                install_nodejs_binary
            fi
            ;;
        *)
            install_nodejs_binary
            ;;
    esac
    
    # Verify installation
    if command_exists node; then
        print_success "Node.js installed: $(node --version)"
    else
        print_error "Failed to install Node.js"
        exit 1
    fi
}

# Function to install Node.js from binary
install_nodejs_binary() {
    print_status "Installing Node.js from official binary..."
    
    local arch=$(get_arch)
    local os_type="linux"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        os_type="darwin"
    fi
    
    local node_version="v18.17.1"
    local node_filename="node-${node_version}-${os_type}-${arch}"
    local node_url="https://nodejs.org/dist/${node_version}/${node_filename}.tar.xz"
    
    # Create temp directory
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    # Download and extract
    print_status "Downloading Node.js binary..."
    curl -fsSL "$node_url" -o node.tar.xz
    tar -xf node.tar.xz
    
    # Install to appropriate location
    if can_elevate; then
        run_elevated cp -r "${node_filename}"/* /usr/local/
    else
        mkdir -p "$HOME/.local"
        cp -r "${node_filename}"/* "$HOME/.local/"
        
        # Add to PATH
        if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
            export PATH="$HOME/.local/bin:$PATH"
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
        fi
    fi
    
    # Cleanup
    cd - > /dev/null
    rm -rf "$temp_dir"
}

# Function to install Python
install_python() {
    print_status "Installing Python..."
    
    local os=$(detect_os)
    
    if command_exists python3; then
        print_success "Python already installed: $(python3 --version)"
        return 0
    fi
    
    case "$os" in
        "debian")
            if in_container || can_elevate; then
                # Set up non-interactive environment for package installation
                export DEBIAN_FRONTEND=noninteractive
                run_elevated apt-get update -qq
                run_elevated apt-get install -y python3 python3-pip python3-venv
            else
                install_python_binary
            fi
            ;;
        "fedora"|"rhel")
            if in_container || can_elevate; then
                run_elevated dnf install -y python3 python3-pip python3-virtualenv
            else
                install_python_binary
            fi
            ;;
        "arch")
            if in_container || can_elevate; then
                run_elevated pacman -Sy --noconfirm python python-pip
            else
                install_python_binary
            fi
            ;;
        "opensuse")
            if in_container || can_elevate; then
                run_elevated zypper install -y python3 python3-pip python3-virtualenv
            else
                install_python_binary
            fi
            ;;
        "alpine")
            if in_container || can_elevate; then
                run_elevated apk add --no-cache python3 py3-pip py3-virtualenv
            else
                install_python_binary
            fi
            ;;
        "macos")
            if command_exists brew; then
                brew install python@3.10
            else
                install_python_binary
            fi
            ;;
        *)
            install_python_binary
            ;;
    esac
    
    # Verify installation
    if command_exists python3; then
        print_success "Python installed: $(python3 --version)"
    else
        print_error "Failed to install Python"
        exit 1
    fi
}

# Function to install Python from source (fallback)
install_python_binary() {
    print_warning "Installing Python from source as fallback..."
    
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    # Download Python source
    curl -fsSL https://www.python.org/ftp/python/3.10.11/Python-3.10.11.tgz -o python.tgz
    tar -xf python.tgz
    cd Python-3.10.11
    
    # Configure and compile
    ./configure --prefix="$HOME/.local" --enable-optimizations
    make -j$(nproc 2>/dev/null || echo 1)
    make install
    
    # Add to PATH
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        export PATH="$HOME/.local/bin:$PATH"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
    fi
    
    # Cleanup
    cd - > /dev/null
    rm -rf "$temp_dir"
}

# Function to install Ollama
install_ollama() {
    print_status "Installing Ollama..."
    
    if command_exists ollama; then
        print_success "Ollama already installed: $(ollama --version 2>/dev/null || echo 'installed')"
        return 0
    fi
    
    # Try official installer first
    if command_exists curl; then
        curl -fsSL https://ollama.ai/install.sh | sh
    elif command_exists wget; then
        wget -qO- https://ollama.ai/install.sh | sh
    else
        # Manual installation
        local os_type="linux"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            os_type="darwin"
        fi
        
        local arch=$(get_arch)
        local ollama_url="https://github.com/ollama/ollama/releases/latest/download/ollama-${os_type}-${arch}"
        
        print_status "Downloading Ollama binary..."
        if command_exists curl; then
            curl -fsSL "$ollama_url" -o ollama
        elif command_exists wget; then
            wget -q "$ollama_url" -O ollama
        else
            print_error "Neither curl nor wget available for downloading Ollama"
            exit 1
        fi
        
        chmod +x ollama
        
        if can_elevate; then
            run_elevated mv ollama /usr/local/bin/
        else
            mkdir -p "$HOME/.local/bin"
            mv ollama "$HOME/.local/bin/"
        fi
    fi
    
    # Verify installation
    if command_exists ollama; then
        print_success "Ollama installed successfully"
    else
        print_error "Failed to install Ollama"
        exit 1
    fi
}

# Function to install GUI dependencies (for Electron)
install_gui_deps() {
    print_status "Installing GUI dependencies for Electron..."
    
    local os=$(detect_os)
    
    # Skip if in container without display
    if in_container && [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
        print_warning "Skipping GUI dependencies in headless container"
        return 0
    fi
    
    case "$os" in
        "debian")
            if can_elevate; then
                # Set up non-interactive environment for package installation
                export DEBIAN_FRONTEND=noninteractive
                run_elevated apt-get update -qq
                run_elevated apt-get install -y --no-install-recommends \
                    libglib2.0-0 libnss3 libatk1.0-0 libatk-bridge2.0-0 \
                    libcups2 libdrm2 libgtk-3-0 libgbm1 libasound2 \
                    libxss1 libx11-xcb1 libxtst6 xvfb
            fi
            ;;
        "fedora"|"rhel")
            if can_elevate; then
                run_elevated dnf install -y \
                    glib2 nss atk at-spi2-atk cups-libs gtk3 \
                    alsa-lib libX11-xcb libXtst libxshmfence xorg-x11-server-Xvfb
            fi
            ;;
        "arch")
            if can_elevate; then
                run_elevated pacman -Sy --noconfirm \
                    glib2 nss atk at-spi2-atk cups gtk3 \
                    alsa-lib libxss libxtst xorg-server-xvfb
            fi
            ;;
        "alpine")
            if can_elevate; then
                run_elevated apk add --no-cache \
                    glib nss atk at-spi2-atk cups gtk+3.0 \
                    alsa-lib libxss libxtst6 xvfb
            fi
            ;;
    esac
}

# Main installation function
main() {
    echo ""
    echo "🏥 Offline Doctor - Fully Automated Setup"
    echo "==========================================="
    echo ""
    
    # Check if we're in the right directory
    if [ ! -f "package.json" ]; then
        print_error "Please run this script from the project root directory (where package.json is located)"
        exit 1
    fi
    
    # Set up non-interactive environment early
    setup_noninteractive
    
    print_status "Detected OS: $(detect_os)"
    print_status "Architecture: $(get_arch)"
    
    if in_container; then
        print_status "Running in container environment"
    fi
    
    # Install core dependencies
    install_nodejs
    install_python
    install_ollama
    install_gui_deps
    
    # Install npm dependencies
    print_status "Installing Node.js dependencies..."
    npm install
    print_success "Node.js dependencies installed"
    
    # Set up Python backend
    print_status "Setting up Python backend..."
    cd backend
    
    # Create virtual environment
    if [ ! -d "venv" ]; then
        print_status "Creating Python virtual environment..."
        python3 -m venv venv
    fi
    
    # Install Python dependencies
    print_status "Installing Python dependencies..."
    source venv/bin/activate
    pip install --upgrade pip
    pip install -r requirements.txt
    deactivate
    cd ..
    
    print_success "Python backend setup complete"
    
    # Start Ollama service
    print_status "Starting Ollama service..."
    if ! pgrep -f "ollama serve" > /dev/null; then
        nohup ollama serve > /dev/null 2>&1 &
        sleep 3
        print_success "Ollama service started"
    else
        print_success "Ollama service already running"
    fi
    
    # Download AI model
    print_status "Downloading medical AI model (this may take a while)..."
    if ollama pull tinyllama; then
        print_success "AI model downloaded successfully"
    else
        print_warning "Failed to download AI model. You can try again later with: ollama pull tinyllama"
    fi
    
    # Create run script
    print_status "Creating run script..."
    create_run_script
    
    # Create desktop entry (Linux only)
    if [[ "$(detect_os)" != "macos" ]] && [ -n "$XDG_CURRENT_DESKTOP" ]; then
        create_desktop_entry
    fi
    
    echo ""
    print_success "🎉 Setup completed successfully!"
    echo ""
    echo "To start the Offline Doctor application:"
    echo "  ./run.sh"
    echo ""
    echo "Or use npm:"
    echo "  npm start"
    echo ""
    echo "📚 First-time usage tips:"
    echo "  1. The AI model (tinyllama) has been downloaded"
    echo "  2. All conversations are stored locally"
    echo "  3. No internet connection required after setup"
    echo "  4. Always consult healthcare professionals for serious medical concerns"
    echo ""
}

# Function to create run script
create_run_script() {
    cat > run.sh << 'EOF'
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
EOF

    chmod +x run.sh
    print_success "Run script created"
}

# Function to create desktop entry
create_desktop_entry() {
    local apps_dir="$HOME/.local/share/applications"
    
    # Use system directory if running as root
    if [ "$(id -u)" = "0" ]; then
        apps_dir="/usr/share/applications"
    fi
    
    mkdir -p "$apps_dir"
    
    cat > "$apps_dir/offline-doctor.desktop" << EOF
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
    
    chmod +x "$apps_dir/offline-doctor.desktop"
    print_success "Desktop entry created"
}

# Run main function
main "$@"
