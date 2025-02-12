#!/bin/bash
# Sends the configuration files required by the webserver (does NOT send all the files that 
# may need to be served by the webserver)

function heading() {
    echo "-------"
    printf "\033[1;32m %s \033[0m \n" "$1"
    echo "-------"
}

set -e

droplet_name=$1

if [ -z "$droplet_name" ]; then
    echo "Usage: send-webserver-config.sh <droplet_name>"
    exit 1
fi

heading "Sending webserver config to droplet"

scp {caddy-compose.yaml,Caddyfile} $droplet_name:~/

# Delete and Re-populate the `sites-enabled` directory 
rsync -avL --delete ./sites-enabled/ $droplet_name:~/sites-enabled/


