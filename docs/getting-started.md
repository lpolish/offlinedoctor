---
layout: default
title: Getting Started - Offline Doctor
---

# Getting Started with Offline Doctor

## Prerequisites

Before installing Offline Doctor, ensure you have:

- **Node.js** 16 or higher ([Download](https://nodejs.org/))
- **Python** 3.7 or higher ([Download](https://python.org/))
- **Git** (for cloning the repository)

## Installation

### Quick Setup (Recommended)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/lpolish/offlinedoctor.git
   cd offlinedoctor
   ```

2. **Run the setup script:**
   
   **Linux/macOS:**
   ```bash
   ./setup.sh
   ```
   
   **Windows:**
   ```bash
   setup.bat
   ```

3. **Start the application:**
   ```bash
   npm start
   ```

### Manual Setup

1. **Clone and install dependencies:**
   ```bash
   git clone https://github.com/lpolish/offlinedoctor.git
   cd offlinedoctor
   npm install
   ```

2. **Set up Python backend:**
   ```bash
   cd backend
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   deactivate
   cd ..
   ```

3. **Install Ollama:**
   
   Linux/macOS:
   ```bash
   curl -fsSL https://ollama.ai/install.sh | sh
   ```
   
   Windows: Download from [Ollama's website](https://ollama.ai/download)

4. **Pull the medical AI model:**
   ```bash
   ollama pull llama2
   ```

## First Steps

1. **Launch the Application**
   - Start Offline Doctor using `npm start` or the desktop shortcut
   - Wait for the AI model to initialize

2. **Configure Settings**
   - Open the Settings tab
   - Choose your preferred AI model
   - Adjust privacy settings

3. **Start a Consultation**
   - Click the Consultation tab
   - Type your medical question or describe symptoms
   - Wait for the AI's response

4. **Use the Symptom Checker**
   - Navigate to the Symptom Checker tab
   - Select relevant symptoms
   - Click "Analyze Symptoms" for AI assessment

## Troubleshooting

### Common Issues

**Ollama not starting:**
```bash
# Check if Ollama is running
ps aux | grep ollama

# Manually start Ollama
ollama serve
```

**Python virtual environment issues:**
```bash
# Recreate virtual environment
rm -rf backend/venv
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

For more detailed troubleshooting, check our [Documentation](./docs.html).

## Next Steps

- Read through our [Documentation](./docs.html) for detailed features
- Join our [Community](https://github.com/lpolish/offlinedoctor/discussions)
- Report issues on [GitHub](https://github.com/lpolish/offlinedoctor/issues)

[Back to Home](./){: .button} [View Documentation](./docs.html){: .button}
