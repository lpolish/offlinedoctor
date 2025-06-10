@echo off
setlocal EnableDelayedExpansion

REM Check if running in a container
set IN_CONTAINER=0
if exist /.dockerenv set IN_CONTAINER=1
if not "!IN_CONTAINER!"=="1" for /f %%i in ('findstr "docker" \proc\1\cgroup 2^>nul') do set IN_CONTAINER=1

echo 🏥 Setting up Offline Doctor - AI Medical Assistant
echo ==================================================

if "!IN_CONTAINER!"=="1" (
    echo 📦 Running in container environment - using local development mode
    set SKIP_DOCKER=1
)

REM Check if we're in the right directory
if not exist "package.json" (
    echo ❌ Error: Please run this script from the project root directory
    pause
    exit /b 1
)

REM Check for Node.js
echo 📦 Checking Node.js installation...
node --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('node --version') do echo ✅ Node.js found: %%i
) else (
    echo Node.js not found. Installing...
    echo Downloading Node.js installer...
    powershell -Command "& {Invoke-WebRequest -Uri 'https://nodejs.org/dist/v18.17.1/node-v18.17.1-x64.msi' -OutFile 'node_installer.msi'}"
    echo Installing Node.js...
    msiexec /i node_installer.msi /qn
    del node_installer.msi
    echo ✅ Node.js installed
    
    REM Add Node.js to PATH for current session
    set "PATH=%PATH%;%ProgramFiles%\nodejs"
    
    REM Verify installation
    node --version >nul 2>&1
    if %errorlevel% neq 0 (
        echo ❌ Node.js installation failed.
        pause
        exit /b 1
    )
    for /f "tokens=*" %%i in ('node --version') do echo ✅ Node.js installed: %%i
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
    echo Python not found. Installing...
    echo Downloading Python installer...
    powershell -Command "& {Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe' -OutFile 'python_installer.exe'}"
    echo Installing Python...
    python_installer.exe /quiet InstallAllUsers=1 PrependPath=1
    del python_installer.exe
    
    REM Add Python to PATH for current session
    set "PATH=%PATH%;%LocalAppData%\Programs\Python\Python310;%LocalAppData%\Programs\Python\Python310\Scripts"
    
    REM Verify installation
    python --version >nul 2>&1
    if %errorlevel% neq 0 (
        echo ❌ Python installation failed.
        pause
        exit /b 1
    )
    for /f "tokens=*" %%i in ('python --version') do echo ✅ Python installed: %%i
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
    echo 🔄 Installing Ollama...
    powershell -Command "& {Invoke-WebRequest -Uri 'https://ollama.ai/download/ollama-windows.exe' -OutFile 'ollama-installer.exe'}"
    ollama-installer.exe /S
    del ollama-installer.exe
    
    REM Verify installation
    ollama --version >nul 2>&1
    if %errorlevel% neq 0 (
        echo ❌ Ollama installation failed.
        pause
        exit /b 1
    )
    for /f "tokens=*" %%i in ('ollama --version 2^>nul') do echo ✅ Ollama installed: %%i
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

REM Check for Docker if not in container
if not "!IN_CONTAINER!"=="1" (
    echo 🐳 Checking Docker installation...
    docker --version >nul 2>&1
    if !errorlevel! equ 0 (
        for /f "tokens=*" %%i in ('docker --version') do echo ✅ Docker found: %%i
    ) else (
        echo Docker not found. Please install Docker Desktop from https://www.docker.com/products/docker-desktop
        echo After installing Docker Desktop, run this script again.
        pause
        exit /b 1
    )
)
