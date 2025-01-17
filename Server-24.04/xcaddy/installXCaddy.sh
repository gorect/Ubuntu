#!/usr/bin/env bash

# Create variable to show the current directory of the script. 
SCRIPT_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Define paths to the two config files
ExampleCaddyfile="${SCRIPT_DIR}/Caddyfile"
CaddyService="${SCRIPT_DIR}/caddy.service"

#Main
echo "sudo apt install -y curl debian-keyring debian-archive-keyring apt-transport-https"
sudo apt install -y curl debian-keyring debian-archive-keyring apt-transport-https
echo "curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-xcaddy-archive-keyring.gpg"
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-xcaddy-archive-keyring.gpg
echo "curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-xcaddy.list"
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-xcaddy.list
echo "sudo apt update"
sudo apt update
echo "sudo apt install xcaddy"
sudo apt install xcaddy

echo "xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/hslatman/caddy-crowdsec-bouncer/crowdsec"
xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/hslatman/caddy-crowdsec-bouncer/crowdsec
sudo mv caddy /usr/bin
caddy version

#create the caddy group
sudo groupadd --system caddy
#create the caddy user and add it to the group
sudo useradd --system \
    --gid caddy \
    --create-home \
    --home-dir /var/lib/caddy \
    --shell /usr/sbin/nologin \
    --comment "Caddy web server" \
    caddy

#create the caddy directory and mv the example Caddyfile there.
mkdir -p /etc/caddy
#check for example files.
if [[ -f "ExampleCaddyfile" -f "CaddyService"]]; then
cp $ExampleCaddyfile /etc/caddy/.
chown caddy:caddy /etc/caddy/Caddyfile

#copy the caddy.service file to the systemd directory. 
cp $CaddyService /etc/systemd/system/.

#reload the systemd service and check the status.
sudo systemctl daemon-reload
sudo systemctl enable --now caddy
sudo systemctl status caddy

else 
  echo "One or more of these files is missing"
  exit 1
fi
