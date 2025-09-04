#!/usr/bin/env bash
# test code before creating actual files.
sudo cp $newNetplan /etc/netplan/.
echo "If you are accessing this host remotly, you will need to end your current ssh session and login with the new IP address."
sudo netplan apply
