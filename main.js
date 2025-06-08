const { app, BrowserWindow, ipcMain, dialog } = require('electron');
const path = require('path');
const { spawn } = require('child_process');
const http = require('http');
const os = require('os');

let mainWindow;
let pythonProcess;

function checkBackendHealth() {
    const options = {
        hostname: '127.0.0.1',
        port: 5000,
        path: '/health',
        method: 'GET',
        timeout: 5000
    };

    const req = http.request(options, (res) => {
        console.log('Backend health check passed - server is running');
    });

    req.on('error', (err) => {
        console.error('Backend health check failed:', err.message);
    });

    req.on('timeout', () => {
        console.error('Backend health check timed out');
    });

    req.end();
}

// Check if Ollama is installed and running
async function checkOllamaStatus() {
    return new Promise((resolve) => {
        const ollama = spawn('ollama', ['list'], { shell: true });
        
        ollama.on('close', (code) => {
            resolve(code === 0);
        });
        
        ollama.on('error', () => {
            resolve(false);
        });
    });
}

// Start the Python backend server
function startPythonBackend() {
    const backendDir = path.join(__dirname, 'backend');
    const venvPath = path.join(backendDir, 'venv');
    
    let command, args;
    
    if (process.platform === 'win32') {
        // Windows
        const pythonExe = path.join(venvPath, 'Scripts', 'python.exe');
        command = pythonExe;
        args = [path.join(backendDir, 'server.py')];
    } else {
        // Linux/macOS - use bash to activate venv and run python
        command = 'bash';
        args = ['-c', `cd "${backendDir}" && source venv/bin/activate && python server.py`];
    }
    
    console.log(`Starting Python backend with command: ${command} ${args.join(' ')}`);
    
    pythonProcess = spawn(command, args, {
        stdio: 'pipe',
        cwd: backendDir
    });

    pythonProcess.stdout.on('data', (data) => {
        console.log(`Python backend: ${data}`);
    });

    pythonProcess.stderr.on('data', (data) => {
        console.error(`Python backend error: ${data}`);
        // Check if it's just a port already in use error
        if (data.toString().includes('Address already in use')) {
            console.log('Backend already running on port 5000, continuing...');
        }
    });

    pythonProcess.on('close', (code) => {
        console.log(`Python backend exited with code ${code}`);
        if (code === 1 && !pythonProcess.killed) {
            // Likely port already in use, check if backend is accessible
            checkBackendHealth();
        }
    });

    pythonProcess.on('error', (err) => {
        console.error(`Failed to start Python backend: ${err}`);
        dialog.showErrorBox(
            'Backend Error',
            'Failed to start the Python backend. Please ensure Python dependencies are installed.'
        );
    });
}

function createWindow() {
    mainWindow = new BrowserWindow({
        width: 1200,
        height: 800,
        webPreferences: {
            nodeIntegration: false,
            contextIsolation: true,
            preload: path.join(__dirname, 'preload.js')
        },
        icon: path.join(__dirname, 'assets', 'icon.png'),
        title: 'Offline Doctor - AI Medical Assistant'
    });

    mainWindow.loadFile('index.html');

    // Open DevTools in development
    if (process.env.NODE_ENV === 'development') {
        mainWindow.webContents.openDevTools();
    }
}

app.whenReady().then(async () => {
    createWindow();
    
    // Check Ollama status
    const ollamaAvailable = await checkOllamaStatus();
    if (!ollamaAvailable) {
        dialog.showErrorBox(
            'Ollama Not Found',
            'Ollama is not installed or not running. Please install Ollama to use the AI features.'
        );
    }

    // Start Python backend
    startPythonBackend();

    app.on('activate', () => {
        if (BrowserWindow.getAllWindows().length === 0) {
            createWindow();
        }
    });
});

app.on('window-all-closed', () => {
    if (pythonProcess) {
        pythonProcess.kill();
    }
    if (process.platform !== 'darwin') {
        app.quit();
    }
});

app.on('before-quit', () => {
    if (pythonProcess) {
        pythonProcess.kill();
    }
});

// IPC handlers
ipcMain.handle('check-ollama-status', async () => {
    return await checkOllamaStatus();
});

ipcMain.handle('get-system-info', () => {
    return {
        platform: process.platform,
        arch: process.arch,
        nodeVersion: process.version,
        electronVersion: process.versions.electron
    };
});
