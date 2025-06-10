#!/bin/bash

# Script to start the Ubuntu 24.04 test environment with X11 forwarding
# for testing Offline Doctor application

echo "Setting up X11 forwarding for Docker container..."

# Create xauth file for Docker
XAUTH_FILE="/tmp/.docker.xauth"

# Remove existing xauth file
rm -f $XAUTH_FILE

# Create new xauth file
touch $XAUTH_FILE
chmod 666 $XAUTH_FILE

# Add current display to xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH_FILE nmerge -

echo "X11 setup complete. Starting Docker container..."

# Start the container
docker-compose up -d

echo "Container started! You can now:"
echo "1. Test X11 forwarding: docker exec -it offlinedoctor-test-env su - testuser -c 'xeyes'"
echo "2. Enter the container: docker exec -it offlinedoctor-test-env bash"
echo "3. Switch to test user: su - testuser"
echo "4. Navigate to project: cd /opt/offlinedoctor"
echo "5. Test the application setup"
echo ""
echo "To stop the container: docker-compose down"
