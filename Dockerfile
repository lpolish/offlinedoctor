# Dockerfile for Offline Doctor Electron app
FROM node:20-slim as build

# Set working directory
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json* ./
RUN npm install --only=production

# Copy application files
COPY . ./

# Build Electron app (if needed)
RUN npm run build-linux || echo "Build skipped for cross-platform image"

# -------- Runtime Stage --------
FROM --platform=linux/amd64 node:20-slim

WORKDIR /app

# Copy built app and backend
COPY --from=build /app/dist ./dist
COPY --from=build /app/backend ./backend
COPY --from=build /app/package.json ./package.json

# Expose ports
EXPOSE 3000 5000

# Default command to run both backend and frontend
CMD ["sh", "-c", "cd backend && python3 server.py & npm start"]
