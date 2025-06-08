const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('electronAPI', {
    checkOllamaStatus: () => ipcRenderer.invoke('check-ollama-status'),
    getSystemInfo: () => ipcRenderer.invoke('get-system-info')
});

contextBridge.exposeInMainWorld('api', {
    send: (channel, data) => {
        const validChannels = ['medical-query', 'get-models', 'system-check'];
        if (validChannels.includes(channel)) {
            ipcRenderer.send(channel, data);
        }
    },
    receive: (channel, func) => {
        const validChannels = ['medical-response', 'models-list', 'system-status'];
        if (validChannels.includes(channel)) {
            ipcRenderer.on(channel, (event, ...args) => func(...args));
        }
    }
});
