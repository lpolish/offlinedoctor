# Contributing to Offline Doctor

Thank you for your interest in contributing to **Offline Doctor**! We welcome contributions of all kinds: code improvements, bug reports, documentation enhancements, and ideas.

## Getting Started

1. Fork the repository and clone your fork:
   ```bash
   git clone https://github.com/yourusername/offlinedoctor.git
   cd offlinedoctor
   ```
2. Install dependencies:
   - Frontend:
     ```bash
     npm install
     ```
   - Backend:
     ```bash
     cd backend
     python3 -m venv venv
     source venv/bin/activate
     pip install -r requirements.txt
     deactivate
     cd ..
     ```
3. Run the app locally:
   ```bash
   npm start
   ```

## How to Contribute

### Reporting Issues

- Search existing issues to avoid duplicates.
- Create a new issue with a descriptive title and clear steps to reproduce.
- Include relevant logs or screenshots.

### Pull Requests

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
2. Commit changes with a clear, descriptive message.
3. Push your branch and open a pull request against `main`.
4. Ensure CI passes and all tests (if any) are passing.
5. Describe your changes and link to any related issues.

### Coding Style

- Use modern ES6+ JavaScript features.
- Follow 2-space indentation.
- Write semantic HTML and maintain accessibility.
- Keep Python code readable and idiomatic (PEP8).

### Branching & Git

- Base all branches off `main`.
- Use descriptive branch names: `feature/...`, `fix/...`, `docs/...`, etc.
- Rebase regularly to keep branches up to date.

### Testing

- Add tests for new functionality when possible.
- Manually verify critical workflows.

## Documentation

Improvements to documentation are welcome! Update `README.md`, `DEVELOPMENT.md`, or add new guides.

## Code of Conduct

Please note that this project is released with a [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you agree to abide by its terms.

---

Thank you for helping make Offline Doctor better!
