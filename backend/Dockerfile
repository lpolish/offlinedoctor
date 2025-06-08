# Backend Dockerfile for Offline Doctor API
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY server.py ./

# Expose Flask port
EXPOSE 5000

# Set default environment variables
ENV OLLAMA_HOST=http://localhost:11434

# Start the server
CMD ["python3", "server.py"]
