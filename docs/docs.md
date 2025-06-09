---
layout: default
title: Documentation - Offline Doctor
---

# Offline Doctor Documentation

## Table of Contents

1. [Effective Communication](#effective-communication)
2. [Best Practices](#best-practices)
3. [Example Interactions](#example-interactions)
4. [Architecture](#architecture)
5. [Features](#features)
6. [Configuration](#configuration)
7. [Security & Privacy](#security--privacy)

## Effective Communication

Offline Doctor uses a local LLM (Llama2) through Ollama, optimized for medical conversations while maintaining privacy. Here's how to communicate effectively:

### Structuring Your Questions

1. **Be Specific and Concise**
   - ✅ "What are the symptoms of strep throat?"
   - ❌ "I'm not feeling well, there's something in my throat, and I wonder what it could be..."

2. **Include Relevant Context**
   - ✅ "I have a fever of 101°F, sore throat, and headache. Are these flu symptoms?"
   - ❌ "Am I getting sick?"

3. **One Issue at a Time**
   - ✅ "What are common treatments for tension headaches?"
   - ❌ "What about headaches and stomach pain and also my knee hurts?"

### Key Information to Include

- **Symptoms**: Be specific about what you're experiencing
- **Duration**: How long have you had the symptoms
- **Severity**: Rate pain/discomfort on a scale of 1-10
- **Context**: Relevant medical history or triggers

## Best Practices

### DO:
- Start with the most prominent symptom
- Use medical terms if you know them
- Provide numerical values (temperature, blood pressure, etc.)
- Mention any relevant allergies or conditions
- Follow up with clarifying questions

### DON'T:
- Include personal identifiers
- Write long, narrative descriptions
- Mix multiple unrelated conditions
- Expect diagnostic certainty
- Use for emergency situations

### Privacy Tips
- Use general terms instead of specific personal details
- Focus on symptoms rather than personal history
- Clear chat history after each session

## Example Interactions

### Effective Examples

1. **Headache Inquiry**

   ```text
   Input: "I have a throbbing headache in the front of my head, pain level 7/10, started 6 hours ago. No fever or nausea. What could help?"
   ```

2. **Medication Question**

   ```text
   Input: "What's the recommended dosage for over-the-counter ibuprofen for an adult with mild joint pain?"
   ```

3. **Symptom Check**

   ```text
   Input: "Dry cough for 3 days, no fever, slight fatigue. What are common causes and when should I seek medical attention?"
   ```

### Follow-up Questions

When the AI responds, ask focused follow-up questions:

```text
"What warning signs should I watch for?"
"How long should I wait before seeking medical attention?"
"Are there any home remedies I could try first?"
```

### Emergency Guidance

⚠️ **Important**: For any of these symptoms, seek immediate medical attention instead of using Offline Doctor:

- Severe chest pain
- Difficulty breathing
- Severe bleeding
- Loss of consciousness
- Sudden severe headache
- Stroke symptoms (FAST: Face drooping, Arm weakness, Speech difficulty, Time to call emergency)

## Architecture
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
