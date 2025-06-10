# X11 Enabled Docker Testing Environment

This directory contains a Docker Compose configuration for testing the Offline Doctor application in a fresh Ubuntu 24.04 environment with X11 forwarding enabled.

## Purpose

This testing environment allows you to:
- Test the Offline Doctor application as if you were a new user
- Verify X11 GUI functionality works correctly
- Ensure cross-platform compatibility
- Test installation procedures in a clean environment

## Prerequisites

- Docker and Docker Compose installed
- X11 server running (on Linux, this is typically automatic)
- Display environment variable set (`echo $DISPLAY` should show something like `:0`)

## Quick Start

1. **Start the test environment:**
   ```bash
   ./start-test-env.sh
   ```

2. **Enter the container:**
   ```bash
   docker exec -it offlinedoctor-test-env bash
   ```

3. **Switch to test user:**
   ```bash
   su - testuser
   # Password: testpass
   ```

4. **Test X11 forwarding:**
   ```bash
   xeyes &
   ```

5. **Run the application test script:**
   ```bash
   cd /opt/offlinedoctor
   ./dockertests/x11enabled/test-offlinedoctor.sh
   ```

## Container Details

### Base Image
- **OS**: Ubuntu 24.04 LTS
- **Architecture**: x86_64

### Pre-installed Software
- curl, git, wget
- nano, vim
- Python 3 with pip
- Node.js with npm
- X11 applications (including xeyes for testing)
- Build tools and development dependencies

### User Setup
- **Username**: testuser
- **Password**: testpass
- **Privileges**: sudo access

### Volume Mounts
- **Project**: `/opt/offlinedoctor` (read/write access to your project)
- **Home**: `./test-home` (persistent home directory for testuser)
- **X11**: `/tmp/.X11-unix` (X11 socket for GUI applications)

## Testing Scenarios

### 1. X11 Forwarding Test
```bash
# Inside container as testuser
xeyes &
# Should open the xeyes application on your host display
```

### 2. Application Dependencies Test
```bash
# Inside container as testuser
cd /opt/offlinedoctor
./dockertests/x11enabled/test-offlinedoctor.sh
```

### 3. Full Application Test (requires Ollama)
```bash
# Inside container as testuser
cd /opt/offlinedoctor
npm install
# Install Ollama (if testing full functionality)
npm start
```

## Troubleshooting

### X11 Issues
If X11 forwarding doesn't work:

1. **Check DISPLAY variable:**
   ```bash
   echo $DISPLAY
   ```

2. **Verify X11 permissions:**
   ```bash
   xhost +local:docker
   ```

3. **Restart with fresh X11 setup:**
   ```bash
   docker-compose down
   ./start-test-env.sh
   ```

### Container Access Issues
If you can't access the container:

1. **Check container status:**
   ```bash
   docker-compose ps
   ```

2. **View container logs:**
   ```bash
   docker-compose logs ubuntu-x11-test
   ```

3. **Restart container:**
   ```bash
   docker-compose down
   docker-compose up -d
   ```

## Cleanup

To stop and remove the test environment:
```bash
docker-compose down
```

To also remove volumes (will delete persistent home directory):
```bash
docker-compose down -v
```

## Notes

- The container runs with `network_mode: host` for X11 compatibility
- Security options are relaxed for testing purposes
- The project directory is mounted read/write for live testing
- Changes made to the project inside the container will persist on the host
