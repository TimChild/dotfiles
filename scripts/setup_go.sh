#!/bin/bash

# URL for the specific Go version
GO_SPECIFIC_URL="https://go.dev/dl/go1.23.4.linux-amd64.tar.gz"


# Function to install Go
install_go() {
  # Determine the correct tar file name
  TAR_FILE=$(ls go*.linux-amd64.tar.gz | head -n 1)

  # Verify the tar file is a valid gzip file
  echo "Installing Go from $TAR_FILE..."
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "$TAR_FILE"

  # Remove the tar file
  echo "Removing the tar file..."
  rm -f "$TAR_FILE"
}

# Main script execution
if [ ! -f go*.linux-amd64.tar.gz ]; then
  echo "Downloading go"
  curl -LO "$GO_SPECIFIC_URL"
else
  echo "Using existing go tar file"
fi
install_go

# Add Go path export to zshrc if not already present
if ! grep -q "export PATH=\$PATH:/usr/local/go/bin" ~/.zshrc; then
  echo "Adding Go path export to ~/.zshrc..."
  echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.zshrc
fi

echo "Go installation completed."
