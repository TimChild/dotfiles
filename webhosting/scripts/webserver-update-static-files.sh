#!/bin/bash
# This script is intended to be run on a webserver droplet to copy static files from 
# ~/sites/<site>/static to /srv/www/<site>/static


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

heading "Updating static files"

# Check sites directory exists
if [ ! -d ~/sites ]; then
    echo "sites directory not found"
    exit 1
fi

for site in ~/sites/*; do
    if [ ! -d "$site/static" ]; then
        warning "No static directory found for $(basename $site)"
    else
        echo "Copying static files for $(basename $site)"
        sudo rsync -aL --delete "$site/static/" "/srv/www/$(basename $site)/"
    fi
done

heading "Static files updated"
