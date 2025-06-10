# Offline Doctor - AI Medical Assistant 🏥

A cross-platform desktop application that provides AI-powered medical assistance without requiring an internet connection. Built with Electron and powered by Ollama for complete privacy and offline functionality.

![Offline Doctor](offlinedoctor.png)

## ✨ Features

- **🔒 Complete Privacy**: All data stays on your device
- **📱 Cross-Platform**: Works on Windows, macOS, and Linux
- **🤖 AI-Powered**: Uses advanced language models via Ollama
- **💬 Interactive Chat**: Natural conversation with medical AI
- **🔍 Symptom Checker**: Quick symptom analysis and guidance
- **💊 Medication Tracker**: Track medications and check interactions
- **📊 Medical History**: Local storage of consultation history
- **⚙️ Configurable**: Adjust AI model settings and preferences

## 🚨 Important Medical Disclaimer

**This application is for informational purposes only and is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.**

## 🛠️ Prerequisites

**None! Our fully automated setup handles everything for you.**

The setup script will automatically install and configure:
- **Node.js** (if not present)
- **Python** (if not present) 
- **Ollama** (if not present)
- All required dependencies and AI models

## 🚀 Quick Start - FULLY AUTOMATED

1. **Clone the repository:**
   ```bash
   git clone https://github.com/lpolish/offlinedoctor.git
   cd offlinedoctor
   ```

2. **Run the fully automated setup script:**
   ```bash
   # Linux/macOS - FULLY AUTOMATED
   ./setup.sh
   
   # Windows - FULLY AUTOMATED  
   setup.bat
   ```

   **🎯 The setup script is COMPLETELY AUTOMATED and will:**
   - ✅ Detect your operating system and architecture
   - ✅ Install Node.js automatically (from official sources)
   - ✅ Install Python automatically (from official sources)
   - ✅ Install Ollama automatically (from official sources)
   - ✅ Set up all Node.js dependencies
   - ✅ Create and configure Python virtual environment
   - ✅ Download and configure the AI medical model
   - ✅ Create run scripts and desktop shortcuts
   - ✅ Handle container environments seamlessly
   - ✅ Support all major Linux distributions, macOS, and Windows
   - ✅ No manual intervention required!

3. **Start the application:**
   ```bash
   # Use the generated run script (recommended)
   ./run.sh          # Linux/macOS
   run.bat           # Windows
   
   # Or use npm directly
   npm start
   ```

4. **Validate your setup (optional):**
   ```bash
   ./test-setup.sh   # Linux/macOS - Comprehensive validation
   ```

> **🎉 Success!** The setup is designed to be 100% automated with zero manual intervention required. If you encounter any issues, the setup script provides detailed error messages and recovery suggestions.

## 🔧 Supported Environments

Our automated setup works seamlessly on:

### Operating Systems
- **Linux**: Ubuntu, Debian, Fedora, CentOS, Arch, openSUSE, Alpine
- **macOS**: 10.14+ (Intel and Apple Silicon)
- **Windows**: Windows 10/11 (x64)

### Environments
- **Native installations**
- **Docker containers** (detects automatically)
- **Virtual machines**
- **Cloud instances**
- **CI/CD environments**

### Package Managers Supported
- **Linux**: apt, dnf, pacman, zypper, apk, yum
- **macOS**: Homebrew (optional)
- **Windows**: PowerShell with direct downloads

### Fallback Installation Methods
- **Binary downloads** when package managers aren't available
- **Source compilation** as last resort
- **User-space installations** when sudo isn't available

## 📦 Building Distributables

Create installer packages for different platforms:

```bash
# Build for current platform
npm run build

# Platform-specific builds
npm run build-win    # Windows (.exe, .msi)
npm run build-mac    # macOS (.dmg, .pkg)
npm run build-linux  # Linux (.AppImage, .deb, .tar.gz)
```

### Automatic Builds with GitHub Actions

The project uses GitHub Actions to automatically build installers for all platforms:

1. **On every push** to `main` branch: Builds and tests the application
2. **On pull requests**: Builds and tests the changes
3. **On version tags** (`v*`): Creates a draft release with installers for all platforms

To create a new release:

1. Update version in `package.json`
2. Create and push a new tag:
   ```bash
   git tag v1.0.0  # Use appropriate version
   git push origin v1.0.0
   ```
3. GitHub Actions will automatically:
   - Build installers for Windows, macOS, and Linux
   - Create a draft release with all installers
   - Generate release notes

# Platform-specific builds
```bash
npm run build-win     # Windows NSIS installer
npm run build-mac     # macOS DMG
npm run build-linux   # Linux AppImage and DEB
```

## 🏗️ Architecture

```txt
┌─────────────────┐    ┌──────────────────┐    ┌───────────────────┐
│   Frontend      │    │   Backend        │    │   AI Engine       │
│   (Electron)    │◄──►│   (Python Flask) │◄──►│   (Ollama)        │
│                 │    │                  │    │                   │
│ • HTML/CSS/JS   │    │ • REST API       │    │ • Llama2 Model    │
│ • Chat UI       │    │ • Medical Logic  │    │ • Local Inference │
│ • Settings      │    │ • Data Storage   │    │ • No Internet     │
└─────────────────┘    └──────────────────┘    └───────────────────┘
```

### Components

- **Frontend (Electron)**: Cross-platform desktop UI with medical consultation interface
- **Backend (Python Flask)**: API server handling medical queries and business logic
- **AI Engine (Ollama)**: Local language model serving medical AI responses
- **Data Storage**: Local SQLite/JSON for medical history and user preferences

## 🔧 Configuration

### AI Model Settings

The application supports multiple AI models:

- **llama2** (Recommended): Best balance of performance and accuracy
- **mistral**: Faster responses, good for basic queries
- **codellama**: Specialized for technical medical information

Configure in the Settings tab or modify `backend/server.py`:

```python
DEFAULT_MODEL = "llama2"  # Change to your preferred model
```

### Privacy Settings

- **Save History**: Toggle consultation history storage
- **Anonymize Data**: Remove personal identifiers from stored data
- **Auto-clear**: Automatically clear history after specified time

## 🗂️ Project Structure

```
offline-doctor/
├── main.js              # Main Electron process
├── preload.js           # Security context bridge
├── renderer.js          # Frontend application logic
├── index.html           # Main UI layout
├── style.css            # Application styles
├── package.json         # Node.js dependencies and scripts
├── setup.sh            # Linux/macOS setup script
├── setup.bat           # Windows setup script
├── assets/             # Icons and images
├── backend/            # Python Flask server
│   ├── server.py       # Main API server
│   ├── requirements.txt # Python dependencies
│   └── venv/           # Python virtual environment
└── .github/
    └── copilot-instructions.md
```

## 🔒 Security & Privacy

- **No External Connections**: All processing happens locally
- **Data Encryption**: Sensitive data encrypted at rest
- **Memory Safety**: Secure cleanup of medical data in memory
- **Access Control**: No unauthorized access to medical history
- **HIPAA Considerations**: Designed with healthcare privacy in mind

## 🧪 Development

### Running in Development Mode

```bash
npm run dev
```

### Backend Development

```bash
cd backend
source venv/bin/activate
python server.py
```

### Adding New Features

1. **Frontend Features**: Modify `renderer.js` and update UI in `index.html`
2. **Backend API**: Add endpoints in `backend/server.py`
3. **AI Prompts**: Update medical context in `MedicalAI` class

## 🐛 Troubleshooting

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

**Model download failures:**
```bash
# Check available models
ollama list

# Re-download model
ollama pull llama2
```

### Log Files

- **Electron logs**: Check console in DevTools (F12)
- **Backend logs**: Terminal output when running `python server.py`
- **Ollama logs**: Check `~/.ollama/logs/` directory

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and test thoroughly
4. Submit a pull request with detailed description

### Medical Content Guidelines

- Always include appropriate disclaimers
- Cite medical sources when possible
- Avoid providing specific dosage recommendations
- Emphasize the importance of professional medical care

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Ollama](https://ollama.ai/) for local AI model hosting
- [Electron](https://electronjs.org/) for cross-platform desktop framework
- [Flask](https://flask.palletsprojects.com/) for Python web framework
- Medical AI community for guidance on responsible AI healthcare applications

## 📞 Support

For support and questions:

- **Issues**: [GitHub Issues](https://github.com/lpolish/offlinedoctor/issues)
- **Discussions**: [GitHub Discussions](https://github.com/lpolish/offlinedoctor/discussions)
- **Email**: hello@luispulido.com

---

**Remember**: This tool is designed to supplement, not replace, professional medical advice. Always consult healthcare professionals for serious medical concerns.
