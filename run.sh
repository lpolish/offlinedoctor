#!/bin/bash

# Function to detect package manager and return package names
get_package_names() {
    if command -v apt-get >/dev/null 2>&1; then
        # Ubuntu/Debian packages
        echo "libglib2.0-0 libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libgtk-3-0 libgbm1 libasound2 libxss1 libx11-xcb1 libxtst6 libxcomposite1 libxdamage1 libxrandr2 libxfixes3"
    elif command -v dnf >/dev/null 2>&1; then
        # Fedora/RHEL packages
        echo "glib2 nss atk at-spi2-atk cups-libs gtk3 alsa-lib libX11-xcb libXtst libxshmfence libXcomposite libXdamage libXrandr"
    elif command -v pacman >/dev/null 2>&1; then
        # Arch Linux packages
        echo "glib2 nss atk at-spi2-atk cups gtk3 alsa-lib libxss libxtst libxcomposite libxdamage libxrandr"
    elif command -v zypper >/dev/null 2>&1; then
        # openSUSE packages
        echo "glib2 mozilla-nss atk at-spi2-atk cups gtk3 alsa-lib libXss1 libXtst6 libXcomposite1 libXdamage1 libXrandr2"
    else
        return 1
    fi
}

# Function to check if we're running under Wayland
is_wayland() {
    [ "$XDG_SESSION_TYPE" = "wayland" ] || [ ! -z "$WAYLAND_DISPLAY" ]
}

# Function to check if we can access the display
check_display_access() {
    if is_wayland; then
        test -S "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"
    else
        xhost >/dev/null 2>&1
    fi
}

# Function to install required dependencies
install_dependencies() {
    local packages=$(get_package_names)
    if [ $? -ne 0 ]; then
        echo "❌ Unsupported package manager"
        return 1
    fi

    # Check if we need sudo
    if [ "$(id -u)" != "0" ]; then
        if sudo -n true 2>/dev/null; then
            SUDO="sudo"
        else
            echo "❌ Installing dependencies requires root privileges"
            echo "Please run with sudo or as root to install dependencies"
            return 1
        fi
    fi

    echo "📦 Installing required dependencies..."
    if command -v apt-get >/dev/null 2>&1; then
        $SUDO apt-get update -qq
        $SUDO apt-get install -y --no-install-recommends $packages
    elif command -v dnf >/dev/null 2>&1; then
        $SUDO dnf install -y $packages
    elif command -v pacman >/dev/null 2>&1; then
        $SUDO pacman -Sy --needed --noconfirm $packages
    elif command -v zypper >/dev/null 2>&1; then
        $SUDO zypper --non-interactive install $packages
    else
        echo "❌ Unable to install dependencies automatically"
        echo "Please install the following packages manually:"
        echo "$packages"
        return 1
    fi
}

# Function to run npm as user with proper environment
run_as_user() {
    local user="$1"
    local home=$(getent passwd "$user" | cut -d: -f6)
    local uid=$(id -u "$user")
    
    # Set up environment variables
    export HOME="$home"
    export XDG_RUNTIME_DIR="/run/user/$uid"
    [ -d "$XDG_RUNTIME_DIR" ] || export XDG_RUNTIME_DIR="/tmp/runtime-$user"
    
    if is_wayland; then
        export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"
    else
        export DISPLAY="${DISPLAY:-:0}"
    fi
    
    # Try different methods to run as user
    if command -v runuser >/dev/null 2>&1; then
        exec runuser -u "$user" -- npm start
    elif command -v su >/dev/null 2>&1; then
        exec su -c "HOME='$HOME' XDG_RUNTIME_DIR='$XDG_RUNTIME_DIR' npm start" "$user"
    elif command -v setpriv >/dev/null 2>&1; then
        exec setpriv --reuid="$uid" --regid="$uid" --init-groups npm start
    else
        echo "❌ Unable to drop root privileges safely"
        echo "Please run the application as a regular user:"
        echo "sudo -u $user -E ./run.sh"
        exit 1
    fi
}

# Check for required libraries and install if missing
if ! ldconfig -p 2>/dev/null | grep -q "libglib-2.0\|libnss3\|libgtk-3\|libxss"; then
    echo "🔍 Missing required libraries"
    install_dependencies || exit 1
fi

# Start Ollama service if not running
if ! pgrep -f "ollama serve" > /dev/null; then
    echo "Starting Ollama service..."
    if [ "$(id -u)" = "0" ] && [ ! -z "$SUDO_USER" ]; then
        sudo -u "$SUDO_USER" nohup ollama serve > /dev/null 2>&1 &
    else
        nohup ollama serve > /dev/null 2>&1 &
    fi
    sleep 2
fi

# Handle running as root
if [ "$(id -u)" = "0" ]; then
    if [ ! -z "$SUDO_USER" ]; then
        # Run as the original user
        run_as_user "$SUDO_USER"
        exit $?
    fi
fi

# Set display variables if not set
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
    if is_wayland; then
        export WAYLAND_DISPLAY="wayland-0"
    else
        export DISPLAY=":0"
    fi
fi

# Verify display access
if ! check_display_access; then
    echo "⚠️  Warning: No access to display. The application may not work correctly."
fi

# Start the application
npm start
