#!/bin/bash
# Sets up the droplet to act as a web server
# Sets up Caddy to run as the web server (will restart automatically on system reboot)
# Caddy will serve static files in `/srv/www` as well as reverse proxy to any services running in other docker containers


function heading() {
    echo "-------"
    printf "\033[1;32m %s \033[0m \n" "$1"
    echo "-------"
}

set -e

heading "Setting up droplet as a webserver..."

# Check caddy-compose.yaml exists
if [ ! -f caddy-compose.yaml ]; then
    echo "caddy-compose.yaml not found"
    exit 1
fi

# Check Caddyfile exists
if [ ! -f Caddyfile ]; then
    echo "Caddyfile not found"
    exit 1
fi

# Check sites-enabled directory exists
if [ ! -d sites-enabled ]; then
    echo "sites-enabled directory not found"
    exit 1
fi

# Allow http and https traffic
sudo ufw allow http
sudo ufw allow https

# Create a www directory within `/srv`
sudo mkdir -p /srv/www

# Start Caddy using docker-compose
ln -s caddy-compose.yaml compose.yaml
docker compose up -d

# Create scripts directory (separately send the webserver-update-static-files.sh script)
mkdir -p ~/scripts

heading "Webserver setup complete (Caddy is running)"

