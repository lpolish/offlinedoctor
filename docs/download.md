---
layout: default
title: Download - Offline Doctor
---

# Download Offline Doctor

Choose your platform below to download the latest version of Offline Doctor.

## Latest Release: v1.0.0

### Windows
- [Offline Doctor Setup.exe](https://github.com/lpolish/offlinedoctor/releases/latest/download/Offline.Doctor.Setup.exe) (64-bit installer)
- [Offline Doctor Portable.zip](https://github.com/lpolish/offlinedoctor/releases/latest/download/Offline.Doctor.Portable.zip) (Portable version)

### macOS
- [Offline Doctor.dmg](https://github.com/lpolish/offlinedoctor/releases/latest/download/Offline.Doctor.dmg) (Universal - Intel & Apple Silicon)

### Linux
- [Offline Doctor.AppImage](https://github.com/lpolish/offlinedoctor/releases/latest/download/Offline.Doctor.AppImage) (AppImage)
- [offlinedoctor_1.0.0_amd64.deb](https://github.com/lpolish/offlinedoctor/releases/latest/download/offlinedoctor_1.0.0_amd64.deb) (Debian/Ubuntu)

## System Requirements

### Windows
- Windows 10 or later (64-bit)
- 4GB RAM minimum
- 2GB free disk space
- Intel or AMD processor

### macOS
- macOS 10.15 (Catalina) or later
- Apple Silicon or Intel processor
- 4GB RAM minimum
- 2GB free disk space

### Linux
- Modern Linux distribution (Ubuntu 20.04+, Fedora 34+, etc.)
- X11 or Wayland display server
- 4GB RAM minimum
- 2GB free disk space

## Installation Instructions

### Windows
1. Download the installer
2. Run the .exe file
3. Follow the installation wizard
4. Launch from Start Menu

### macOS
1. Download the .dmg file
2. Open the disk image
3. Drag to Applications folder
4. Launch from Applications

### Linux
#### AppImage
1. Download the .AppImage file
2. Make it executable: `chmod +x Offline.Doctor.AppImage`
3. Double-click to run or use terminal

#### Debian/Ubuntu
1. Download the .deb file
2. Install using:
   ```bash
   sudo dpkg -i offlinedoctor_1.0.0_amd64.deb
   sudo apt-get install -f
   ```

## Verifying Downloads

All releases are signed and can be verified using GPG:

```bash
gpg --verify Offline.Doctor.AppImage.sig Offline.Doctor.AppImage
```

Download the [public key](https://github.com/lpolish.gpg) for verification.

## Source Code

Get the source code from our GitHub repository:

```bash
git clone https://github.com/lpolish/offlinedoctor.git
```

## Building from Source

You can build Offline Doctor from source for your platform:

1. Clone the repository:
   ```bash
   git clone https://github.com/lpolish/offlinedoctor.git
   cd offlinedoctor
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Build for your platform:
   ```bash
   # Build for current platform
   npm run build

   # Or build for specific platform
   npm run build-win    # Windows (.exe, .msi)
   npm run build-mac    # macOS (.dmg, .pkg)
   npm run build-linux  # Linux (.AppImage, .deb, .tar.gz)
   ```

The installers will be available in the `dist` directory.

## Continuous Integration

All releases are automatically built using GitHub Actions:
- Windows: `.exe` and `.msi` installers
- macOS: Universal `.dmg` and `.pkg` installers (Intel & Apple Silicon)
- Linux: `.AppImage`, `.deb`, and `.tar.gz` packages

Every release is:
- Built on official runners for each platform
- Automatically tested
- Code-signed (for Windows and macOS)
- Available as a draft release for final verification

[View on GitHub](https://github.com/lpolish/offlinedoctor){: .button} [Getting Started](./getting-started.html){: .button}
