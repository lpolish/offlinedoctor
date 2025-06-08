#!/usr/bin/env python3
"""
Offline Doctor Backend Server
Interfaces with Ollama for medical AI consultations
"""

import json
import subprocess
import sys
import time
from flask import Flask, request, jsonify
from flask_cors import CORS
import requests
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)

# Ollama configuration
OLLAMA_HOST = "http://localhost:11434"
DEFAULT_MODEL = "llama3.1:8b"

class MedicalAI:
    def __init__(self):
        self.model = DEFAULT_MODEL
        self.medical_context = """
You are a medical AI assistant designed to provide helpful medical information and guidance. 
Your role is to:
1. Analyze symptoms and provide general medical guidance
2. Suggest when to seek professional medical care
3. Provide information about common conditions
4. Offer health and wellness advice

Important disclaimers:
- You are not a replacement for professional medical diagnosis or treatment
- Always recommend consulting healthcare professionals for serious concerns
- Do not provide specific medication dosages or prescriptions
- Emphasize the importance of professional medical care when appropriate

Please provide helpful, accurate, and responsible medical guidance.
"""
    
    def check_ollama_status(self):
        """Check if Ollama service is running"""
        try:
            response = requests.get(f"{OLLAMA_HOST}/api/tags", timeout=5)
            return response.status_code == 200
        except Exception as e:
            logger.error(f"Ollama status check failed: {e}")
            return False
    
    def get_available_models(self):
        """Get list of available models from Ollama"""
        try:
            response = requests.get(f"{OLLAMA_HOST}/api/tags", timeout=10)
            if response.status_code == 200:
                data = response.json()
                return [model['name'] for model in data.get('models', [])]
            return []
        except Exception as e:
            logger.error(f"Failed to get models: {e}")
            return []
    
    def ensure_model_available(self, model_name=None):
        """Ensure the specified model is available, pull if necessary"""
        if model_name is None:
            model_name = self.model
            
        try:
            # Check if model is already available
            available_models = self.get_available_models()
            if model_name in available_models:
                return True
            
            # Pull the model if not available
            logger.info(f"Pulling model {model_name}...")
            pull_data = {"name": model_name}
            response = requests.post(
                f"{OLLAMA_HOST}/api/pull",
                json=pull_data,
                timeout=300  # 5 minutes timeout for model pulling
            )
            
            if response.status_code == 200:
                logger.info(f"Model {model_name} pulled successfully")
                return True
            else:
                logger.error(f"Failed to pull model {model_name}: {response.text}")
                return False
                
        except Exception as e:
            logger.error(f"Error ensuring model availability: {e}")
            return False
    
    def generate_medical_response(self, user_message, conversation_history=None):
        """Generate medical response using Ollama"""
        try:
            # Ensure model is available
            if not self.ensure_model_available():
                return "I'm sorry, but the medical AI model is not currently available. Please check your Ollama installation."
            
            # Prepare the prompt with medical context
            full_prompt = f"{self.medical_context}\n\nPatient: {user_message}\n\nMedical Assistant:"
            
            # Prepare request data
            request_data = {
                "model": self.model,
                "prompt": full_prompt,
                "stream": False,
                "options": {
                    "temperature": 0.3,  # Lower temperature for more consistent medical advice
                    "top_p": 0.9,
                    "max_tokens": 500
                }
            }
            
            # Make request to Ollama
            response = requests.post(
                f"{OLLAMA_HOST}/api/generate",
                json=request_data,
                timeout=60
            )
            
            if response.status_code == 200:
                result = response.json()
                return result.get('response', 'I apologize, but I could not generate a response.')
            else:
                logger.error(f"Ollama API error: {response.status_code} - {response.text}")
                return "I'm experiencing technical difficulties. Please try again later."
                
        except requests.exceptions.Timeout:
            return "The request timed out. Please try again with a shorter message."
        except Exception as e:
            logger.error(f"Error generating response: {e}")
            return "I'm sorry, but I encountered an error while processing your request."

# Initialize medical AI
medical_ai = MedicalAI()

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    ollama_status = medical_ai.check_ollama_status()
    return jsonify({
        'status': 'healthy' if ollama_status else 'degraded',
        'ollama_available': ollama_status,
        'timestamp': time.time()
    })

@app.route('/models', methods=['GET'])
def get_models():
    """Get available models"""
    models = medical_ai.get_available_models()
    return jsonify({
        'models': models,
        'current_model': medical_ai.model
    })

@app.route('/models/<model_name>', methods=['POST'])
def set_model(model_name):
    """Set the current model"""
    if medical_ai.ensure_model_available(model_name):
        medical_ai.model = model_name
        return jsonify({'success': True, 'model': model_name})
    else:
        return jsonify({'success': False, 'error': 'Model not available'}), 400

@app.route('/consultation', methods=['POST'])
def medical_consultation():
    """Handle medical consultation requests"""
    try:
        data = request.get_json()
        user_message = data.get('message', '')
        
        if not user_message:
            return jsonify({'error': 'Message is required'}), 400
        
        # Check if Ollama is available
        if not medical_ai.check_ollama_status():
            return jsonify({
                'error': 'Medical AI service is not available. Please ensure Ollama is running.'
            }), 503
        
        # Generate response
        response = medical_ai.generate_medical_response(user_message)
        
        return jsonify({
            'response': response,
            'model': medical_ai.model,
            'timestamp': time.time()
        })
        
    except Exception as e:
        logger.error(f"Error in medical consultation: {e}")
        return jsonify({'error': 'Internal server error'}), 500

@app.route('/analyze-symptoms', methods=['POST'])
def analyze_symptoms():
    """Analyze a list of symptoms"""
    try:
        data = request.get_json()
        symptoms = data.get('symptoms', [])
        
        if not symptoms:
            return jsonify({'error': 'Symptoms list is required'}), 400
        
        symptoms_text = ', '.join(symptoms)
        user_message = f"I have the following symptoms: {symptoms_text}. What could this indicate and what should I do?"
        
        response = medical_ai.generate_medical_response(user_message)
        
        return jsonify({
            'response': response,
            'symptoms': symptoms,
            'timestamp': time.time()
        })
        
    except Exception as e:
        logger.error(f"Error analyzing symptoms: {e}")
        return jsonify({'error': 'Internal server error'}), 500

@app.route('/medication-interaction', methods=['POST'])
def check_medication_interaction():
    """Check for potential medication interactions"""
    try:
        data = request.get_json()
        medications = data.get('medications', [])
        
        if len(medications) < 2:
            return jsonify({'error': 'At least two medications are required'}), 400
        
        medications_text = ', '.join(medications)
        user_message = f"Are there any known interactions between these medications: {medications_text}?"
        
        response = medical_ai.generate_medical_response(user_message)
        
        return jsonify({
            'response': response,
            'medications': medications,
            'timestamp': time.time()
        })
        
    except Exception as e:
        logger.error(f"Error checking medication interactions: {e}")
        return jsonify({'error': 'Internal server error'}), 500

def install_ollama():
    """Install Ollama if not already installed"""
    try:
        # Check if Ollama is already installed
        result = subprocess.run(['ollama', '--version'], capture_output=True, text=True)
        if result.returncode == 0:
            logger.info("Ollama is already installed")
            return True
    except FileNotFoundError:
        pass
    
    logger.info("Installing Ollama...")
    try:
        # Download and install Ollama
        install_script = requests.get('https://ollama.ai/install.sh')
        if install_script.status_code == 200:
            subprocess.run(['bash', '-c', install_script.text], check=True)
            logger.info("Ollama installed successfully")
            return True
        else:
            logger.error("Failed to download Ollama install script")
            return False
    except Exception as e:
        logger.error(f"Failed to install Ollama: {e}")
        return False

def start_ollama_service():
    """Start Ollama service if not running"""
    try:
        # Check if Ollama is running
        if medical_ai.check_ollama_status():
            logger.info("Ollama service is already running")
            return True
        
        # Try to start Ollama
        logger.info("Starting Ollama service...")
        subprocess.Popen(['ollama', 'serve'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        
        # Wait a moment for service to start
        time.sleep(3)
        
        if medical_ai.check_ollama_status():
            logger.info("Ollama service started successfully")
            return True
        else:
            logger.error("Failed to start Ollama service")
            return False
            
    except Exception as e:
        logger.error(f"Error starting Ollama service: {e}")
        return False

if __name__ == '__main__':
    logger.info("Starting Offline Doctor Backend...")
    
    # Ensure Ollama is installed and running
    if not medical_ai.check_ollama_status():
        logger.info("Ollama not available, attempting to start...")
        if not start_ollama_service():
            logger.warning("Could not start Ollama service. Some features may not work.")
    
    # Ensure default model is available
    logger.info(f"Ensuring {DEFAULT_MODEL} model is available...")
    medical_ai.ensure_model_available(DEFAULT_MODEL)
    
    # Start Flask server
    app.run(host='127.0.0.1', port=5000, debug=False)
