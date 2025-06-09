---
layout: default
title: Documentation - Offline Doctor
---

# Offline Doctor Documentation

## Table of Contents

1. [Architecture](#architecture)
2. [Features](#features)
3. [Configuration](#configuration)
4. [Development](#development)
5. [Security & Privacy](#security--privacy)
6. [API Reference](#api-reference)

## Architecture

Offline Doctor uses a three-tier architecture:

- **Frontend**: Electron-based desktop application
- **Backend**: Python Flask server for AI processing
- **AI Engine**: Ollama for local model inference

### Component Interaction

```
Frontend (Electron) ←→ Backend (Flask) ←→ Ollama (AI)
```

## Features

### AI Medical Consultation

- Natural language medical queries
- Symptom analysis and guidance
- Medical information and explanations
- Healthcare recommendations

### Symptom Checker

- Comprehensive symptom selection
- AI-powered analysis
- Risk assessment
- Professional care recommendations

### Medication Management

- Medication tracking
- Drug interaction checks
- Reminder system
- Medical history logging

### Privacy Features

- Local-only data storage
- No internet requirement
- Data encryption options
- History anonymization

## Configuration

### AI Model Settings

```javascript
{
  "model": "llama2",
  "temperature": 0.3,
  "max_tokens": 500,
  "top_p": 0.9
}
```

### Privacy Settings

- **Save History**: Toggle history storage
- **Anonymize Data**: Remove identifiers
- **Auto-clear**: Schedule data clearing
- **Export Data**: Local backup options

## Development

### Setup Development Environment

```bash
# Clone repository
git clone https://github.com/lpolish/offlinedoctor.git
cd offlinedoctor

# Install dependencies
npm install

# Set up Python backend
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Building

```bash
# Development build
npm run dev

# Production build
npm run build

# Platform-specific builds
npm run build-win    # Windows
npm run build-mac    # macOS
npm run build-linux  # Linux
```

## Security & Privacy

### Data Storage

- All data stored locally
- Optional encryption
- No cloud connectivity
- Regular data cleanup

### Communication

- Local-only API calls
- Secure IPC channels
- Sanitized inputs
- Error handling

## API Reference

### Backend API Endpoints

#### Medical Consultation
```
POST /consultation
{
  "message": "string",
  "history": "array (optional)"
}
```

#### Symptom Analysis
```
POST /analyze-symptoms
{
  "symptoms": "array"
}
```

#### Medication Check
```
POST /medication-interaction
{
  "medications": "array"
}
```

### Frontend API

#### Electron IPC Channels
- `medical-query`
- `get-models`
- `system-check`

[Back to Home](./){: .button} [Getting Started](./getting-started.html){: .button}
