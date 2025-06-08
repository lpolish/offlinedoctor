<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Offline Doctor - AI Medical Assistant

This is a cross-platform desktop application built with Electron that provides an offline AI-powered medical assistant using Ollama.

## Architecture Overview

- **Frontend**: Electron application with HTML/CSS/JavaScript
- **Backend**: Python Flask server that interfaces with Ollama
- **AI Model**: Llama2 or other compatible models via Ollama
- **Data Storage**: Local storage for privacy and offline functionality

## Key Technologies

- **Electron**: Cross-platform desktop application framework
- **Ollama**: Local AI model hosting and inference
- **Python Flask**: Backend API server
- **HTML/CSS/JavaScript**: Frontend user interface

## Development Guidelines

### Medical AI Context
- Always include appropriate medical disclaimers
- Emphasize that this tool is for guidance only, not diagnosis
- Encourage users to consult healthcare professionals for serious concerns
- Maintain patient privacy and data security

### Code Style
- Use modern JavaScript ES6+ features
- Follow consistent indentation (2 spaces)
- Use semantic HTML and accessible design
- Implement responsive design principles

### Security & Privacy
- All data should be stored locally
- No external API calls for medical data
- Implement data anonymization options
- Ensure secure communication between frontend and backend

### Cross-Platform Considerations
- Test on Windows, macOS, and Linux
- Use platform-appropriate file paths
- Handle different Python executables (python vs python3)
- Provide platform-specific installation instructions

### AI Integration
- Use appropriate temperature settings for medical advice (lower values)
- Implement proper error handling for AI model failures
- Provide fallback responses when AI is unavailable
- Include conversation history context when relevant

### File Structure
- `main.js`: Main Electron process
- `preload.js`: Secure context bridge
- `renderer.js`: Frontend application logic
- `backend/server.py`: Python Flask API server
- `assets/`: Application icons and resources
- `style.css`: Application styling

## Building and Distribution

The application can be packaged for:
- Windows (NSIS installer)
- macOS (DMG)
- Linux (AppImage, DEB)

Use electron-builder for cross-platform packaging.
