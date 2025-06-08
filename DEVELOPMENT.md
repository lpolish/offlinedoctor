# Development Configuration

## Environment Variables

You can create a `.env` file in the project root to configure development settings:

```bash
# Backend Configuration
BACKEND_HOST=127.0.0.1
BACKEND_PORT=5000

# Ollama Configuration  
OLLAMA_HOST=http://localhost:11434
DEFAULT_MODEL=llama2

# Development Settings
NODE_ENV=development
ELECTRON_IS_DEV=1
```

## Development Commands

```bash
# Start in development mode
npm run dev

# Run backend separately
cd backend && source venv/bin/activate && python server.py

# Build for testing
npm run pack

# Run tests (when implemented)
npm test
```

## Debugging

### Frontend Debugging
- Press F12 to open DevTools in the Electron app
- Check Console tab for JavaScript errors
- Use Network tab to monitor backend API calls

### Backend Debugging
- Backend logs appear in the terminal when running
- Add `debug=True` to Flask app for detailed error messages
- Use Python debugger: `import pdb; pdb.set_trace()`

### Ollama Debugging
```bash
# Check Ollama status
ollama list

# Test Ollama directly
curl http://localhost:11434/api/generate -d '{
  "model": "llama2",
  "prompt": "What is fever?",
  "stream": false
}'
```
