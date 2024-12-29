#!/bin/bash

# URL for the specific Go version
GO_SPECIFIC_URL="https://go.dev/dl/go1.23.4.linux-amd64.tar.gz"

# Function to download the latest Go version
download_latest_go() {
  # Fetch the latest version URL from the Go downloads page
  LATEST_GO_URL=$(curl -s https://go.dev/dl/ | grep -oP 'https://go.dev/dl/go[0-9.]+.linux-amd64.tar.gz' | head -n 1)

  # If the latest version is found, download it; otherwise, download the specific version
  if [[ -n "$LATEST_GO_URL" ]]; then
    echo "Downloading latest Go version from $LATEST_GO_URL"
    curl -O "$LATEST_GO_URL"
  else
    echo "Downloading specific Go version from $GO_SPECIFIC_URL"
    curl -O "$GO_SPECIFIC_URL"
  fi
}

# Function to install Go
install_go() {
  # Extract the tar file name from the URL
  TAR_FILE=$(basename "$LATEST_GO_URL")
  if [[ ! -f "$TAR_FILE" ]]; then
    TAR_FILE=$(basename "$GO_SPECIFIC_URL")
  fi

  # Install Go
  echo "Installing Go..."
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "$TAR_FILE"

  # Remove the tar file
  echo "Removing the tar file..."
  rm -f "$TAR_FILE"
}

# Main script execution
download_latest_go
install_go

echo "Go installation completed."
