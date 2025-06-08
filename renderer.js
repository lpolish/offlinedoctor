class OfflineDoctor {
    constructor() {
        this.currentSection = 'consultation';
        this.chatMessages = [];
        this.medications = [];
        this.medicalHistory = [];
        this.init();
    }

    async init() {
        this.setupEventListeners();
        await this.checkSystemStatus();
        this.loadSettings();
        this.loadMedicalHistory();
    }

    setupEventListeners() {
        // Navigation
        document.querySelectorAll('.nav-item').forEach(item => {
            item.addEventListener('click', (e) => {
                const section = e.currentTarget.dataset.section;
                this.switchSection(section);
            });
        });

        // Chat functionality
        const messageInput = document.getElementById('messageInput');
        const sendButton = document.getElementById('sendButton');

        sendButton.addEventListener('click', () => this.sendMessage());
        messageInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                this.sendMessage();
            }
        });

        // Symptom checker
        document.getElementById('analyzeSymptoms')?.addEventListener('click', () => {
            this.analyzeSymptoms();
        });

        // Medications
        document.getElementById('addMedication')?.addEventListener('click', () => {
            this.addMedication();
        });

        // Settings
        document.getElementById('temperatureSlider')?.addEventListener('input', (e) => {
            document.getElementById('temperatureValue').textContent = e.target.value;
        });
    }

    switchSection(sectionName) {
        // Update navigation
        document.querySelectorAll('.nav-item').forEach(item => {
            item.classList.remove('active');
        });
        document.querySelector(`[data-section="${sectionName}"]`).classList.add('active');

        // Update content
        document.querySelectorAll('.content-section').forEach(section => {
            section.classList.remove('active');
        });
        document.getElementById(sectionName).classList.add('active');

        this.currentSection = sectionName;
    }

    async checkSystemStatus() {
        try {
            const isOnline = await window.electronAPI.checkOllamaStatus();
            const statusDot = document.getElementById('statusDot');
            const statusText = document.getElementById('statusText');

            if (isOnline) {
                statusDot.className = 'status-dot online';
                statusText.textContent = 'AI Ready';
            } else {
                statusDot.className = 'status-dot offline';
                statusText.textContent = 'AI Offline';
            }

            // Load system info
            const systemInfo = await window.electronAPI.getSystemInfo();
            this.displaySystemInfo(systemInfo);
        } catch (error) {
            console.error('Error checking system status:', error);
        }
    }

    displaySystemInfo(info) {
        const systemInfoDiv = document.getElementById('systemInfo');
        if (systemInfoDiv) {
            systemInfoDiv.innerHTML = `
                <div class="info-item">
                    <strong>Platform:</strong> ${info.platform}
                </div>
                <div class="info-item">
                    <strong>Architecture:</strong> ${info.arch}
                </div>
                <div class="info-item">
                    <strong>Node.js:</strong> ${info.nodeVersion}
                </div>
                <div class="info-item">
                    <strong>Electron:</strong> ${info.electronVersion}
                </div>
            `;
        }
    }

    async sendMessage() {
        const messageInput = document.getElementById('messageInput');
        const message = messageInput.value.trim();

        if (!message) return;

        // Add user message to chat
        this.addMessageToChat(message, 'user');
        messageInput.value = '';

        // Show loading
        this.showLoading(true);

        try {
            // Simulate API call to Python backend
            const response = await this.queryMedicalAI(message);
            this.addMessageToChat(response, 'bot');
            
            // Save to history
            this.saveMedicalHistory({
                type: 'consultation',
                date: new Date().toISOString(),
                userMessage: message,
                aiResponse: response
            });
        } catch (error) {
            console.error('Error sending message:', error);
            this.addMessageToChat('I apologize, but I\'m having trouble processing your request. Please check if the AI service is running and try again.', 'bot');
        } finally {
            this.showLoading(false);
        }
    }

    addMessageToChat(message, sender) {
        const chatMessages = document.getElementById('chatMessages');
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${sender}-message`;

        const avatar = sender === 'user' ? '<i class="fas fa-user"></i>' : '<i class="fas fa-robot"></i>';
        
        messageDiv.innerHTML = `
            <div class="message-avatar">
                ${avatar}
            </div>
            <div class="message-content">
                <p>${message}</p>
            </div>
        `;

        chatMessages.appendChild(messageDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    async queryMedicalAI(message) {
        try {
            const response = await fetch('http://127.0.0.1:5000/consultation', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ message: message })
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json();
            return data.response || 'I apologize, but I could not generate a response.';
        } catch (error) {
            console.error('Error querying medical AI:', error);
            
            // Fallback responses when backend is unavailable
            const fallbackResponses = [
                "I'm currently unable to connect to the medical AI service. Please ensure the backend server is running and try again.",
                "The medical AI service appears to be offline. Please check that Ollama is installed and running, then restart the application.",
                "I'm experiencing connectivity issues with the AI service. This could be due to the backend server not running or Ollama not being available."
            ];
            
            return fallbackResponses[Math.floor(Math.random() * fallbackResponses.length)];
        }
    }

    analyzeSymptoms() {
        const selectedSymptoms = [];
        document.querySelectorAll('.symptom-item input[type="checkbox"]:checked').forEach(checkbox => {
            selectedSymptoms.push(checkbox.value);
        });

        if (selectedSymptoms.length === 0) {
            alert('Please select at least one symptom to analyze.');
            return;
        }

        // Send symptoms to backend for analysis
        this.analyzeSymptomsList(selectedSymptoms);
    }

    async analyzeSymptomsList(symptoms) {
        this.showLoading(true);
        
        try {
            const response = await fetch('http://127.0.0.1:5000/analyze-symptoms', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ symptoms: symptoms })
            });

            if (response.ok) {
                const data = await response.json();
                
                // Switch to consultation tab and display results
                this.switchSection('consultation');
                this.addMessageToChat(`I have the following symptoms: ${symptoms.join(', ')}. What could this indicate?`, 'user');
                this.addMessageToChat(data.response, 'bot');
                
                // Save to history
                this.saveMedicalHistory({
                    type: 'symptom',
                    date: new Date().toISOString(),
                    userMessage: `Symptoms: ${symptoms.join(', ')}`,
                    aiResponse: data.response
                });
            } else {
                throw new Error('Backend unavailable');
            }
        } catch (error) {
            console.error('Error analyzing symptoms:', error);
            
            // Fallback to regular chat
            const symptomsText = `I have the following symptoms: ${symptoms.join(', ')}. What could this indicate?`;
            this.switchSection('consultation');
            document.getElementById('messageInput').value = symptomsText;
            this.sendMessage();
        } finally {
            this.showLoading(false);
        }
    }

    addMedication() {
        const medicationInput = document.getElementById('medicationInput');
        const medication = medicationInput.value.trim();

        if (!medication) return;

        this.medications.push({
            name: medication,
            dateAdded: new Date().toISOString()
        });

        this.renderMedications();
        medicationInput.value = '';
        this.saveMedications();
    }

    renderMedications() {
        const medicationList = document.getElementById('medicationList');
        if (!medicationList) return;

        medicationList.innerHTML = this.medications.map((med, index) => `
            <div class="medication-item">
                <div>
                    <strong>${med.name}</strong>
                    <small>Added: ${new Date(med.dateAdded).toLocaleDateString()}</small>
                </div>
                <button onclick="app.removeMedication(${index})" style="background: #f56565; color: white; border: none; padding: 0.5rem; border-radius: 4px; cursor: pointer;">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        `).join('');
    }

    removeMedication(index) {
        this.medications.splice(index, 1);
        this.renderMedications();
        this.saveMedications();
    }

    saveMedicalHistory(entry) {
        this.medicalHistory.unshift(entry);
        this.renderMedicalHistory();
        localStorage.setItem('medicalHistory', JSON.stringify(this.medicalHistory));
    }

    loadMedicalHistory() {
        const saved = localStorage.getItem('medicalHistory');
        if (saved) {
            this.medicalHistory = JSON.parse(saved);
            this.renderMedicalHistory();
        }
    }

    renderMedicalHistory() {
        const historyList = document.getElementById('historyList');
        if (!historyList) return;

        historyList.innerHTML = this.medicalHistory.map(entry => `
            <div class="history-item">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                    <strong>${entry.type.charAt(0).toUpperCase() + entry.type.slice(1)}</strong>
                    <small>${new Date(entry.date).toLocaleDateString()}</small>
                </div>
                <p><strong>Question:</strong> ${entry.userMessage}</p>
                <p><strong>Response:</strong> ${entry.aiResponse}</p>
            </div>
        `).join('');
    }

    saveMedications() {
        localStorage.setItem('medications', JSON.stringify(this.medications));
    }

    loadSettings() {
        // Load saved medications
        const savedMedications = localStorage.getItem('medications');
        if (savedMedications) {
            this.medications = JSON.parse(savedMedications);
            this.renderMedications();
        }

        // Load other settings
        const saveHistory = localStorage.getItem('saveHistory');
        if (saveHistory !== null) {
            document.getElementById('saveHistory').checked = JSON.parse(saveHistory);
        }

        const anonymizeData = localStorage.getItem('anonymizeData');
        if (anonymizeData !== null) {
            document.getElementById('anonymizeData').checked = JSON.parse(anonymizeData);
        }
    }

    showLoading(show) {
        const overlay = document.getElementById('loadingOverlay');
        if (show) {
            overlay.classList.add('show');
        } else {
            overlay.classList.remove('show');
        }
    }
}

// Initialize the application
let app;
document.addEventListener('DOMContentLoaded', () => {
    app = new OfflineDoctor();
});

// Make app globally available for button callbacks
window.app = app;
