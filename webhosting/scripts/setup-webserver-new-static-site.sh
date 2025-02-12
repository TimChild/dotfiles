#!/bin/bash
# Initialize a new static site on the webserver (runs locally)
#
# - Check that it doesn't already exist
# - Check that caddy config exists
# - Create new directories in the ~/sites and /srv/www
# - Send caddy config to the `~/sites-enabled` directory
# - does NOT restart caddy since this does not imply sending the new static site files yet


function heading() {
    echo "-------"
    printf "\033[1;32m %s \033[0m \n" "$1"
    echo "-------"
}

function warning() {
    echo "-------"
    printf "\033[1;33m %s \033[0m \n" "$1"
    echo "-------"
}

set -e

site_name=$1
caddy_config_path=$2

if [ -z "$site_name" ] || [ -z "$caddy_config_path" ]; then
    echo "Usage: webserver-init-new-static-site.sh <site_name> <caddy_config_path>"
    exit 1
fi

heading "Initializing new static site ($site_name)"

# Check that the caddy config exists locally
if [ -f $caddy_config_path ]; then
    warning "Caddy config not found at $caddy_config_path"
    exit 1
fi

# Check that the site does not already exist on the webserver
if [ ssh $droplet_name "[ -d /srv/www/$site_name ]" ]; then
    warning "Site $site_name already exists on the webserver"
    exit 1
fi

echo "Creating directories on the webserver..."
# Create directories on the webserver
ssh $droplet_name "mkdir -p ~/sites/$site_name/static"
ssh $droplet_name "mkdir -p /srv/www/$site_name"

echo "Copying caddy config to the webserver..."
# Send caddy config to the webserver
caddy_config_name=$(basename $caddy_config_path)
scp $caddy_config_path $droplet_name:~/sites-enabled/$caddy_config_name

heading "Static site initialized successfully"
echo "Note that static files are not sent in this script"


