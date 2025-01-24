#!/bin/bash
# https://www.rapidseedbox.com/blog/plex-on-docker

function heading() {
    echo "-------"
    printf "\033[1;32m %s \033[0m \n" "$1"
    echo "-------"
}

heading "Setting up Plex Media Server"
# Get plex_claim from user input
echo "Please enter your Plex claim code:"
read -r PLEX_CLAIM

if [ -z "$PLEX_CLAIM" ]; then
    echo "Please provied a PLEX_CLAIM"
    exit 1
fi

if [ -z "$PLEX_DATA_PATH" ]; then
    echo "Please set the PLEX_DATA_PATH environment variable"
    exit 1
fi

heading "Creating plex directory at ~/plex"
mkdir ~/plex
cd ~/plex || exit


heading "Creating link to data at $PLEX_DATA_PATH"
ln -s "$PLEX_DATA_PATH" remote_data

heading "Creating local directories"
mkdir plex_config
mkdir transcode

heading "Creating compose file"
cat <<EOF > docker-compose.yml
services:
  plex:
    image: lscr.io/linuxserver/plex:latest
    container_name: plex
    environment:
      #- PUID=1000
      #- PGID=1000
      #- PUID=0
      #- PGID=0
      - TZ=America/Vancouver
      - VERSION=docker
      - PLEX_CLAIM=${PLEX_CLAIM}
    volumes:
      # Note: /config requires file locking to work properly, so network shares are risky (can grow to be >10s of GB)
      - /webadmin/plex/plex_config:/config
      - "/webadmin/plex/remote_data/Tv Programs:/tv"
      - /webadmin/plex/remote_data/Films:/movies
      - /webadmin/plex/remote_data:/all
      # Explicitly set where to store temporary files during transcoding
      - /webadmin/plex/transcode:/transcode
      # Explicitly set cache location (2024-11-30 -- don't remember why, maybe to be able to clean it up easily?)
      - "/webadmin/plex/plex_PhotoTranscoder_cache:/config/Library/Application Support/Plex Media Server/Cache/PhotoTranscoder/"
    #restart: unless-stopped
    restart: always
      # network_mode: host
    ports:
      - 32400:32400
EOF

heading "Starting Plex Media Server"
docker compose up -d

