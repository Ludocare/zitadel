#!/bin/sh

# Fix permissions for mounted volumes
sudo chown -R nextjs:nodejs /var/www/frontend/.next 2>/dev/null || true
sudo chown -R nextjs:nodejs /var/www/frontend/node_modules 2>/dev/null || true

# Create necessary directories if they don't exist
mkdir -p /var/www/frontend/.next
mkdir -p /var/www/frontend/node_modules

# Execute the passed command
exec "$@"