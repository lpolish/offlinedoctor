#!/bin/bash
# Test script to verify Offline Doctor setup

echo "🧪 Testing Offline Doctor Setup"
echo "==============================="

# Test Node.js dependencies
echo "📦 Testing Node.js setup..."
if npm list electron >/dev/null 2>&1; then
    echo "✅ Electron installed"
else
    echo "❌ Electron not found"
fi

# Test Python backend
echo "🐍 Testing Python backend..."
cd backend
if [ -d "venv" ]; then
    echo "✅ Python virtual environment found"
    source venv/bin/activate
    
    if python -c "import flask, flask_cors, requests" 2>/dev/null; then
        echo "✅ Python dependencies installed"
    else
        echo "❌ Python dependencies missing"
    fi
    
    deactivate
else
    echo "❌ Python virtual environment not found"
fi

cd ..

# Test Ollama (optional)
echo "🤖 Testing Ollama..."
if command -v ollama >/dev/null 2>&1; then
    echo "✅ Ollama installed"
    
    if ollama list >/dev/null 2>&1; then
        echo "✅ Ollama service accessible"
        
        if ollama list | grep -q "llama2"; then
            echo "✅ Llama2 model found"
        else
            echo "⚠️  Llama2 model not found (will be downloaded on first use)"
        fi
    else
        echo "⚠️  Ollama service not running (will start automatically)"
    fi
else
    echo "⚠️  Ollama not installed (install with setup script)"
fi

echo ""
echo "🚀 Ready to start! Run:"
echo "   npm start"
echo ""
echo "Or use the setup script if issues found:"
echo "   ./setup.sh"
