#!/bin/bash
# Initialize a new static site on the webserver (runs locally)
#
# - Create new directories in the ~/sites and /srv/www
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

droplet_name=$1
site_name=$2


if [ -z "$droplet_name" ] || [ -z "$site_name" ]; then
    echo "Usage: webserver-init-new-static-site.sh <droplet_name> <site_name>"
    exit 1
fi

heading "Initializing new static site ($site_name) on ($droplet_name)"

# Check that the site does not already exist on the webserver
if ssh $droplet_name "[ -d /srv/www/$site_name ]"; then
    warning "Site $site_name already exists on the webserver"
    exit 1
fi

echo "Creating directories on the webserver..."
# Create directories on the webserver
ssh $droplet_name "rm -rf ~/sites/$site_name && mkdir -p ~/sites/$site_name/static"
ssh $droplet_name "sudo mkdir -p /srv/www/$site_name"

heading "Static site initialized successfully"
echo "Note that site won't be visible until deploy task is run"
# Deploy task will sync the config (.caddy) as well as static files


