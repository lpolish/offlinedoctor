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

[View on GitHub](https://github.com/lpolish/offlinedoctor){: .button} [Getting Started](./getting-started.html){: .button}
