#!/usr/bin/env bash

#build xcaddy in your current directory.
xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/hslatman/caddy-crowdsec-bouncer/crowdsec

#stop the Caddy service using the following command:
sudo systemctl stop caddy

#rename the folder so you can revert back if you have trouble.
mv /usr/bin/caddy /usr/bin/caddy-old

#move the newly build Caddy application to the /usr/bin folder.
mv caddy /usr/bin/

#start and check the Caddy service.
sudo systemctl start caddy
sudo systemctl status caddy
