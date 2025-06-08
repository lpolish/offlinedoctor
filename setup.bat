@echo off
REM Offline Doctor Setup Script for Windows
REM This script sets up the complete environment for the Offline Doctor application

echo 🏥 Setting up Offline Doctor - AI Medical Assistant
echo ==================================================

REM Check if we're in the right directory
if not exist "package.json" (
    echo ❌ Error: Please run this script from the project root directory
    pause
    exit /b 1
)

REM Check Node.js
echo 📦 Checking Node.js installation...
node --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('node --version') do echo ✅ Node.js found: %%i
) else (
    echo ❌ Node.js not found. Please install Node.js 16+ from https://nodejs.org/
    pause
    exit /b 1
)

REM Check npm
npm --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('npm --version') do echo ✅ npm found: %%i
) else (
    echo ❌ npm not found. Please install npm
    pause
    exit /b 1
)

REM Check Python
echo 🐍 Checking Python installation...
python --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('python --version') do echo ✅ Python found: %%i
) else (
    echo ❌ Python not found. Please install Python 3.7+ from https://python.org/
    pause
    exit /b 1
)

REM Install Node.js dependencies
echo 📦 Installing Node.js dependencies...
call npm install

REM Set up Python virtual environment
echo 🐍 Setting up Python backend...
cd backend

REM Create virtual environment
if not exist "venv" (
    echo Creating Python virtual environment...
    python -m venv venv
)

REM Activate virtual environment and install dependencies
echo Installing Python dependencies...
call venv\Scripts\activate.bat
python -m pip install --upgrade pip
pip install -r requirements.txt
call venv\Scripts\deactivate.bat

cd ..

REM Check for Ollama
echo 🤖 Checking Ollama installation...
ollama --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('ollama --version 2^>nul') do echo ✅ Ollama found: %%i
) else (
    echo 🔄 Ollama not found. Please install Ollama manually:
    echo    1. Download from https://ollama.ai/download
    echo    2. Run the installer
    echo    3. Restart this script
    pause
    exit /b 1
)

REM Start Ollama service
echo 🚀 Starting Ollama service...
tasklist /FI "IMAGENAME eq ollama.exe" 2>NUL | find /I /N "ollama.exe" >NUL
if %errorlevel% neq 0 (
    echo Starting Ollama in background...
    start /B ollama serve
    timeout /t 3 /nobreak >nul
)

REM Pull medical model
echo 📥 Setting up medical AI model...
echo This may take a while depending on your internet connection...
ollama pull llama2

REM Create run script
echo @echo off > run.bat
echo REM Start Ollama service if not running >> run.bat
echo tasklist /FI "IMAGENAME eq ollama.exe" 2^>NUL ^| find /I /N "ollama.exe" ^>NUL >> run.bat
echo if %%errorlevel%% neq 0 ( >> run.bat
echo     echo Starting Ollama service... >> run.bat
echo     start /B ollama serve >> run.bat
echo     timeout /t 2 /nobreak ^>nul >> run.bat
echo ^) >> run.bat
echo. >> run.bat
echo REM Start the application >> run.bat
echo npm start >> run.bat

echo.
echo 🎉 Setup completed successfully!
echo.
echo To start the Offline Doctor application:
echo   run.bat
echo.
echo Or use npm:
echo   npm start
echo.
echo To build distributable packages:
echo   npm run build-win      # For Windows installer
echo   npm run build-linux    # For Linux (cross-compile)
echo   npm run build-mac      # For macOS (cross-compile)
echo.
echo 📚 First-time usage tips:
echo   1. The AI model (llama2) has been downloaded
echo   2. All conversations are stored locally
echo   3. No internet connection required after setup
echo   4. Always consult healthcare professionals for serious medical concerns
echo.
pause
