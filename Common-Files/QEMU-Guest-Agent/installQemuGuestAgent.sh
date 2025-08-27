#!/usr/bin/env bash
sudo apt install qemu-guest-agent -y
sudo systemctl enable qemu-guest-agent
sudosystemctll start qemu-guest-agent
