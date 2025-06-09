---
layout: default
title: Getting Started - Offline Doctor
---

# Getting Started with Offline Doctor

Welcome to Offline Doctor! This guide will help you set up and start using our AI-powered medical assistant. Offline Doctor provides private, secure medical guidance without requiring an internet connection.

## 🔍 System Requirements

### Hardware Requirements

* **CPU**: 2 cores minimum, 4+ cores recommended
* **RAM**: 4GB minimum, 8GB+ recommended
* **Storage**: 2GB free space minimum
* **Graphics**: Basic GPU (integrated graphics sufficient)

### Software Prerequisites

* **Operating System**
  * Windows 10/11 (64-bit)
  * macOS 10.15 or later
  * Linux (Ubuntu 20.04+, Fedora 34+, or similar)

* **Required Software**
  * Node.js 16 or higher ([Download](https://nodejs.org/))
  * Python 3.7 or higher ([Download](https://python.org/))
  * Git ([Download](https://git-scm.com/))

## 🚀 Installation

### Quick Setup (Recommended)

1. **Clone the Repository**
   ```bash
   git clone https://github.com/lpolish/offlinedoctor.git
   cd offlinedoctor
   ```

2. **Run Automated Setup**
   
   Choose your platform:

   **Linux/macOS:**
   ```bash
   ./setup.sh
   ```
   
   **Windows:**
   ```bash
   setup.bat
   ```

   This script will:
   * Install all dependencies
   * Set up the Python environment
   * Configure Ollama
   * Install required AI models
   * Create desktop shortcuts

3. **Start Offline Doctor**
   ```bash
   npm start
   ```

### Manual Installation

If you prefer more control over the installation process:

1. **Install Dependencies**
   ```bash
   git clone https://github.com/lpolish/offlinedoctor.git
   cd offlinedoctor
   npm install
   ```

2. **Configure Python Backend**
   ```bash
   cd backend
   python3 -m venv venv
   
   # Activate virtual environment
   # On Linux/macOS:
   source venv/bin/activate
   # On Windows:
   # venv\Scripts\activate
   
   pip install -r requirements.txt
   deactivate
   cd ..
   ```

3. **Install Ollama**
   
   **Linux/macOS:**
   ```bash
   curl -fsSL https://ollama.ai/install.sh | sh
   ```
   
   **Windows:**
   * Download from [Ollama's website](https://ollama.ai/download)
   * Run the installer
   * Follow the setup wizard

4. **Download AI Models**
   ```bash
   ollama pull llama2
   ```

## 🎯 Initial Configuration

### First Launch

1. **Start the Application**
   * Run `npm start` or use desktop shortcut
   * Wait for initialization (1-2 minutes)
   * Confirm all services are running

2. **Essential Settings**
   * Open Settings tab
   * Select preferred AI model
   * Configure privacy options
   * Set up data storage preferences

### Privacy Settings

1. **Data Storage**
   * Choose storage location
   * Set retention period
   * Configure backup options

2. **Anonymization**
   * Enable/disable history
   * Set data anonymization level
   * Configure export options

## 💡 Basic Usage

### Medical Consultation

1. **Start a Consultation**
   * Click "Consultation" tab
   * Type your medical question
   * Provide relevant details
   * Review AI response

2. **Best Practices**
   * Be specific about symptoms
   * Include duration and severity
   * Mention relevant history
   * Ask follow-up questions

### Symptom Checker

1. **Check Symptoms**
   * Open Symptom Checker
   * Select all relevant symptoms
   * Add duration and severity
   * Get AI assessment

2. **Track History**
   * Save important consultations
   * Monitor symptom progression
   * Export records if needed

## 🔧 Troubleshooting

### Common Issues

1. **Application Won't Start**
   * Check Node.js installation
   * Verify Python environment
   * Confirm Ollama is running
   * Check system requirements

2. **AI Model Issues**
   ```bash
   # Verify Ollama service
   ps aux | grep ollama
   
   # Restart Ollama
   ollama serve
   
   # Reinstall model if needed
   ollama pull llama2
   ```

3. **Backend Problems**
   ```bash
   # Reset Python environment
   cd backend
   rm -rf venv
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

### Getting Help

* Check [Documentation](./docs.html)
* Visit [FAQ](./faq.html)
* Join [Discord](https://discord.gg/offlinedoctor)
* Report [Issues](https://github.com/lpolish/offlinedoctor/issues)

## 📚 Next Steps

1. **Explore Features**
   * Read our [Documentation](./docs.html)
   * Try the [Tutorials](./tutorials.html)
   * Check [Example Uses](./docs.html#example-interactions)

2. **Join Community**
   * Join [Discussions](https://github.com/lpolish/offlinedoctor/discussions)
   * Follow Development
   * Share Feedback

3. **Advanced Usage**
   * Custom AI Models
   * API Integration
   * Development Guide

[Back to Home](./){: .button} [Read Docs](./docs.html){: .button} [Join Community](./community.html){: .button}
