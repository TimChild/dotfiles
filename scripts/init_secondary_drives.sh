#!/bin/bash
# Permanently mounts secondary drives
# NOTE: This is only needed to be run once (on initial setup of computer)
#
# UUIDs are the safer way to mount drives as they won't change if new drives are added

# Exit on error
set -e

# Define arrays for UUIDs and mount paths
# Find the UUIDs with `sudo blkid` or `lsblk -f`
# # For multiple ("UUID1" "UUID2")
UUIDs=("546ACF776ACF5500")
MOUNT_PATHS=("/mnt/g")

# Backup fstab
sudo cp /etc/fstab /etc/fstab.bak

# Iterate over UUIDs and mount paths
for i in "${!UUIDs[@]}"; do
  UUID="${UUIDs[$i]}"
  MOUNT_PATH="${MOUNT_PATHS[$i]}"

  # Create mount directory if it doesn't exist
  sudo mkdir -p "$MOUNT_PATH"
  sudo chown -R $USER:$USER "$MOUNT_PATH"

  # Add to fstab (Note: mask is reverse of octal -- 000 means everyone rwx, 027 means group can't write, 137 means others can't write)
  echo "UUID=$UUID $MOUNT_PATH ntfs-3g defaults,nls=utf8,umask=000,dmask=022,fmask=133,uid=1000,gid=1000,windows_names 0 0" | sudo tee -a /etc/fstab
done

# Mount
echo "running 'systemctl daemon-reload'"
sudo systemctl daemon-reload || { echo "Failed on 'systemctl daemon-reload'"; sudo cp /etc/fstab.bak /etc/fstab; echo "Restored fstab backup"; exit 1; }
echo "running 'sudo mount -a'"
sudo mount -a || { echo "Failed on 'sudo mount -a'"; sudo cp /etc/fstab.bak /etc/fstab; echo "Restored fstab backup"; exit 1; }

