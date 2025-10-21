#!/bin/sh

# Fix permissions for mounted volumes
chown -R nextjs:nodejs /workspace/apps/login/.next 2>/dev/null || true
chown -R nextjs:nodejs /workspace/apps/login/node_modules 2>/dev/null || true

# Create necessary directories if they don't exist
mkdir -p /workspace/apps/login/.next
mkdir -p /workspace/apps/login/node_modules

# Execute the passed command
exec "$@"