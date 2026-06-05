#!/usr/bin/env bash

# create code here to wget the latest version of the go tarball at https://go.dev/dl/$GOVERSION
# Set the URL for the Go downloads page
URL="https://go.dev/dl/"
echo "Fetching available Go versions from $URL..."

# Fetch the latest .tar.gz file link specifically for Linux amd64
LATEST_FILE=$(wget -qO- "$URL" | \
grep -oP 'href="/dl/go1[0-9]+\.[0-9]+\.[0-9]+\.linux-amd64\.tar\.gz"' | \
head -n 1 | \
sed -E 's/^href="//;s/"$//')

if [[ -n "$LATEST_FILE" ]]; then
  # Build the full download URL
  DOWNLOAD_URL="https://go.dev$LATEST_FILE"
  echo "Latest Go version found: $DOWNLOAD_URL"

  # Download the file
  echo "Downloading..."
  wget -q "$DOWNLOAD_URL" -P ./
  if [[ $? -eq 0 ]]; then
    echo "File downloaded successfully to the current directory."
  else
    echo "Failed to download the file."
    exit 1
  fi
else
  echo "No matching Go versions found."
  exit 1
fi


#everything below here is just installing the already downloaded tarball. 
wget $GOVERSION
rm -rf /usr/local/go && tar -C /usr/local -xzf $GOVERSION
export PATH=$PATH:/usr/local/go/bin
source $HOME/.profile
go version
rm $GOVERSION #rm go1.22.1.linux-amd64.tar.gz
