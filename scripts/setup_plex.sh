#!/bin/bash
# https://www.rapidseedbox.com/blog/plex-on-docker

function heading() {
    echo "-------"
    printf "\033[1;32m %s \033[0m \n" "$1"
    echo "-------"
}

heading "Setting up Plex Media Server"
echo "Checking for PLEX_CLAIM environment variable"
if [ -z "$PLEX_CLAIM" ]; then
    echo "Please set the PLEX_CLAIM environment variable"
    exit 1
fi
echo "Checking user:host path set"
if [ -z "$USER" ] || [ -z "$HOST" ]; then
    echo "Please set the USER and HOST environment variables"
    exit 1
fi


heading "Creating plex directory"
mkdir plex
cd plex || exit


heading "Mounting remote data"
echo "Creating script to mount remote data"
cat <<EOF > mount_remote_data.sh
#!/bin/bash
sshfs -o allow_other,default_permissions,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 "$PLEX_DATA_SERVER":"$PLEX_DATA_SERVER_PATH" remote_data/
EOF
chmod +x mount_remote_data.sh
echo "Running script to mount remote data"
./mount_remote_data.sh

echo "Adding script to crontab"
# Add script preserving any existing crontab entries
(crontab -l 2>/dev/null; echo "@reboot /root/plex/mount_remote_data.sh") | crontab -

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
docker-compose up -d

