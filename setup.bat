@echo off
setlocal EnableDelayedExpansion

REM Offline Doctor Setup Script for Windows
REM FULLY AUTOMATED - No manual intervention required
REM Handles all Windows environments including containers

REM Set timezone to UTC to avoid interactive prompts
set TZ=UTC

echo.
echo 🏥 Offline Doctor - Fully Automated Setup
echo ===========================================
echo.

REM Check if we're in the right directory
if not exist "package.json" (
    echo ❌ Error: Please run this script from the project root directory
    echo    ^(where package.json is located^)
    pause
    exit /b 1
)

REM Function to check if running in container
set "IN_CONTAINER=0"
if exist "/.dockerenv" set "IN_CONTAINER=1"
if exist "/proc/1/cgroup" (
    findstr /C:"docker" /proc/1/cgroup >nul 2>&1
    if !errorlevel! equ 0 set "IN_CONTAINER=1"
)

if "!IN_CONTAINER!"=="1" (
    echo 📦 Running in container environment
)

echo 🔍 Checking system requirements...

REM Create temp directory for downloads
set "TEMP_DIR=%TEMP%\offline_doctor_setup"
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"
mkdir "%TEMP_DIR%"

REM Function to download files
:download_file
set "url=%~1"
set "output=%~2"
echo Downloading %url%...
powershell -Command "try { Invoke-WebRequest -Uri '%url%' -OutFile '%output%' -UseBasicParsing } catch { exit 1 }"
if %errorlevel% neq 0 (
    echo ❌ Failed to download %url%
    exit /b 1
)
goto :eof

REM Install Node.js if not present
echo 📦 Checking Node.js installation...
node --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('node --version') do echo ✅ Node.js found: %%i
) else (
    echo Installing Node.js...
    set "NODE_URL=https://nodejs.org/dist/v18.17.1/node-v18.17.1-x64.msi"
    set "NODE_INSTALLER=%TEMP_DIR%\node_installer.msi"
    
    call :download_file "!NODE_URL!" "!NODE_INSTALLER!"
    
    echo Installing Node.js silently...
    msiexec /i "!NODE_INSTALLER!" /qn /norestart
    if !errorlevel! neq 0 (
        echo ❌ Node.js installation failed
        pause
        exit /b 1
    )
    
    REM Update PATH for current session
    for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH 2^>nul') do set "SYSTEM_PATH=%%B"
    set "PATH=%SYSTEM_PATH%;%ProgramFiles%\nodejs"
    
    REM Wait a moment for installation to complete
    timeout /t 5 /nobreak >nul
    
    REM Verify installation
    node --version >nul 2>&1
    if !errorlevel! neq 0 (
        echo ❌ Node.js installation verification failed
        echo Please restart your command prompt and try again
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
    echo ❌ npm not found even after Node.js installation
    echo This is unusual. Please check your Node.js installation
    pause
    exit /b 1
)

REM Install Python if not present
echo 🐍 Checking Python installation...
python --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('python --version') do echo ✅ Python found: %%i
) else (
    echo Installing Python...
    set "PYTHON_URL=https://www.python.org/ftp/python/3.11.6/python-3.11.6-amd64.exe"
    set "PYTHON_INSTALLER=%TEMP_DIR%\python_installer.exe"
    
    call :download_file "!PYTHON_URL!" "!PYTHON_INSTALLER!"
    
    echo Installing Python silently...
    "!PYTHON_INSTALLER!" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
    if !errorlevel! neq 0 (
        echo ❌ Python installation failed
        pause
        exit /b 1
    )
    
    REM Update PATH for current session
    for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH 2^>nul') do set "SYSTEM_PATH=%%B"
    set "PATH=%SYSTEM_PATH%;%LocalAppData%\Programs\Python\Python311;%LocalAppData%\Programs\Python\Python311\Scripts"
    
    REM Wait for installation to complete
    timeout /t 10 /nobreak >nul
    
    REM Verify installation
    python --version >nul 2>&1
    if !errorlevel! neq 0 (
        echo ❌ Python installation verification failed
        echo Please restart your command prompt and try again
        pause
        exit /b 1
    )
    
    for /f "tokens=*" %%i in ('python --version') do echo ✅ Python installed: %%i
)

REM Install Ollama if not present
echo 🤖 Checking Ollama installation...
ollama --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('ollama --version 2^>nul') do echo ✅ Ollama found: %%i
) else (
    echo Installing Ollama...
    set "OLLAMA_URL=https://github.com/ollama/ollama/releases/latest/download/OllamaSetup.exe"
    set "OLLAMA_INSTALLER=%TEMP_DIR%\ollama_installer.exe"
    
    call :download_file "!OLLAMA_URL!" "!OLLAMA_INSTALLER!"
    
    echo Installing Ollama silently...
    "!OLLAMA_INSTALLER!" /S
    if !errorlevel! neq 0 (
        echo ❌ Ollama installation failed
        pause
        exit /b 1
    )
    
    REM Wait for installation to complete
    timeout /t 10 /nobreak >nul
    
    REM Update PATH for current session
    for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH 2^>nul') do set "SYSTEM_PATH=%%B"
    set "PATH=%SYSTEM_PATH%;%LocalAppData%\Programs\Ollama"
    
    REM Verify installation
    ollama --version >nul 2>&1
    if !errorlevel! neq 0 (
        echo ❌ Ollama installation verification failed
        echo Please restart your command prompt and try again
        pause
        exit /b 1
    )
    
    for /f "tokens=*" %%i in ('ollama --version 2^>nul') do echo ✅ Ollama installed: %%i
)

REM Clean up temp directory
rmdir /s /q "%TEMP_DIR%" 2>nul

REM Install Node.js dependencies
echo 📦 Installing Node.js dependencies...
call npm install
if %errorlevel% neq 0 (
    echo ❌ Failed to install Node.js dependencies
    pause
    exit /b 1
)
echo ✅ Node.js dependencies installed

REM Set up Python virtual environment
echo 🐍 Setting up Python backend...
cd backend

REM Create virtual environment
if not exist "venv" (
    echo Creating Python virtual environment...
    python -m venv venv
    if !errorlevel! neq 0 (
        echo ❌ Failed to create Python virtual environment
        pause
        exit /b 1
    )
)

REM Install Python dependencies
echo Installing Python dependencies...
call venv\Scripts\activate.bat
python -m pip install --upgrade pip
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo ❌ Failed to install Python dependencies
    call venv\Scripts\deactivate.bat
    cd ..
    pause
    exit /b 1
)
call venv\Scripts\deactivate.bat
cd ..
echo ✅ Python backend setup complete

REM Start Ollama service
echo 🚀 Starting Ollama service...
tasklist /FI "IMAGENAME eq ollama.exe" 2>NUL | find /I /N "ollama.exe" >NUL
if %errorlevel% neq 0 (
    echo Starting Ollama in background...
    start /B ollama serve
    timeout /t 5 /nobreak >nul
    echo ✅ Ollama service started
) else (
    echo ✅ Ollama service already running
)

REM Download AI model
echo 📥 Downloading medical AI model ^(this may take a while^)...
ollama pull tinyllama
if %errorlevel% neq 0 (
    echo ⚠️  Failed to download AI model. You can try again later with: ollama pull tinyllama
) else (
    echo ✅ AI model downloaded successfully
)

REM Create run script
echo 🔧 Creating run script...
echo @echo off > run.bat
echo REM Offline Doctor Run Script >> run.bat
echo REM Automatically starts all required services >> run.bat
echo. >> run.bat
echo REM Check dependencies >> run.bat
echo node --version ^>nul 2^>^&1 >> run.bat
echo if %%errorlevel%% neq 0 ( >> run.bat
echo     echo ❌ Node.js not found. Please run setup.bat first. >> run.bat
echo     pause >> run.bat
echo     exit /b 1 >> run.bat
echo ^) >> run.bat
echo. >> run.bat
echo python --version ^>nul 2^>^&1 >> run.bat
echo if %%errorlevel%% neq 0 ( >> run.bat
echo     echo ❌ Python not found. Please run setup.bat first. >> run.bat
echo     pause >> run.bat
echo     exit /b 1 >> run.bat
echo ^) >> run.bat
echo. >> run.bat
echo ollama --version ^>nul 2^>^&1 >> run.bat
echo if %%errorlevel%% neq 0 ( >> run.bat
echo     echo ❌ Ollama not found. Please run setup.bat first. >> run.bat
echo     pause >> run.bat
echo     exit /b 1 >> run.bat
echo ^) >> run.bat
echo. >> run.bat
echo REM Start Ollama service if not running >> run.bat
echo tasklist /FI "IMAGENAME eq ollama.exe" 2^>NUL ^| find /I /N "ollama.exe" ^>NUL >> run.bat
echo if %%errorlevel%% neq 0 ( >> run.bat
echo     echo 🚀 Starting Ollama service... >> run.bat
echo     start /B ollama serve >> run.bat
echo     timeout /t 3 /nobreak ^>nul >> run.bat
echo ^) >> run.bat
echo. >> run.bat
echo REM Start the application >> run.bat
echo echo 🏥 Starting Offline Doctor... >> run.bat
echo npm start >> run.bat

echo ✅ Run script created

echo.
echo ✅ 🎉 Setup completed successfully!
echo.
echo To start the Offline Doctor application:
echo   run.bat
echo.
echo Or use npm:
echo   npm start
echo.
echo To build distributable packages:
echo   npm run build-win      # For Windows installer
echo   npm run build-linux    # For Linux ^(cross-compile^)
echo   npm run build-mac      # For macOS ^(cross-compile^)
echo.
echo 📚 First-time usage tips:
echo   1. The AI model ^(tinyllama^) has been downloaded
echo   2. All conversations are stored locally
echo   3. No internet connection required after setup
echo   4. Always consult healthcare professionals for serious medical concerns
echo.
pause
