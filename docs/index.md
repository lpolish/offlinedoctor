---
layout: default
title: Offline Doctor - AI Medical Assistant
---

# Offline Doctor - AI Medical Assistant

![Offline Doctor](/offlinedoctor/assets/images/offlinedoctor.png)

A cross-platform desktop application that provides AI-powered medical assistance without requiring an internet connection. Built with Electron and powered by Ollama for complete privacy and offline functionality.

## 🚨 Important Medical Disclaimer

**This application is for informational purposes only and is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.**

## ✨ Key Features

- **🔒 Complete Privacy**: All data stays on your device
- **📱 Cross-Platform**: Works on Windows, macOS, and Linux
- **🤖 AI-Powered**: Uses advanced language models via Ollama
- **💬 Interactive Chat**: Natural conversation with medical AI
- **🔍 Symptom Checker**: Quick symptom analysis and guidance
- **💊 Medication Tracker**: Track medications and check interactions
- **📊 Medical History**: Local storage of consultation history
- **⚙️ Configurable**: Adjust AI model settings and preferences

[Get Started](./getting-started.html){: .button} [Download](./download.html){: .button} [Documentation](./docs.html){: .button}

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend        │    │   AI Engine     │
│   (Electron)    │◄──►│   (Python Flask) │◄──►│   (Ollama)      │
│                 │    │                  │    │                 │
│ • HTML/CSS/JS   │    │ • REST API       │    │ • Llama2 Model  │
│ • Chat UI       │    │ • Medical Logic  │    │ • Local Inference│
│ • Settings      │    │ • Data Storage   │    │ • No Internet   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 🛠️ Technology Stack

- **Frontend**: Electron, HTML5, CSS3, JavaScript (ES6+)
- **Backend**: Python Flask, RESTful API
- **AI Engine**: Ollama with Llama2 model
- **Storage**: Local file system for complete privacy

## 💡 Why Offline Doctor?

1. **Privacy First**: Your medical data never leaves your device
2. **Always Available**: No internet required after initial setup
3. **User-Friendly**: Intuitive interface for all users
4. **Customizable**: Adjust AI settings to your needs
5. **Open Source**: Transparent and community-driven development

[View on GitHub](https://github.com/lpolish/offlinedoctor){: .button}
