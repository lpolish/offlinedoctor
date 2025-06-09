---
layout: default
title: Contributing to Offline Doctor
---

# Contributing to Offline Doctor

Thank you for your interest in contributing to Offline Doctor! This guide will help you get started with contributing to the project.

## Repository

The project is hosted on GitHub at [github.com/lpolish/offlinedoctor](https://github.com/lpolish/offlinedoctor).

## Project Structure

- **Frontend**: Electron application using HTML/CSS/JavaScript
- **Backend**: Python Flask server interfacing with Ollama
- **Documentation**: Jekyll-based documentation (this site)

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/offlinedoctor.git
   ```
3. Install dependencies:
   ```bash
   # Frontend dependencies
   npm install
   
   # Backend dependencies
   cd backend
   pip install -r requirements.txt
   ```

## Development Setup

1. Make sure you have Ollama installed and running
2. Start the backend server:
   ```bash
   cd backend
   python server.py
   ```
3. Start the Electron app:
   ```bash
   npm start
   ```

## Making Changes

1. Create a new branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```
2. Make your changes
3. Test your changes thoroughly
4. Commit with a descriptive message:
   ```bash
   git commit -m "feat: add new feature"
   ```
5. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
6. Create a Pull Request

## Code Style

- Follow the existing code style
- Use meaningful variable and function names
- Include comments for complex logic
- Write tests for new features
- Keep commits atomic and well-described

## Need Help?

- Check out the [Documentation](/docs)
- Create an [Issue](https://github.com/lpolish/offlinedoctor/issues)
- Join our [Community](/community)

## License

By contributing to Offline Doctor, you agree that your contributions will be licensed under the MIT License.
