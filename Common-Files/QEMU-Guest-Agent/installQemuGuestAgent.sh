#!/usr/bin/env bash
set -e  # Exit if any command fails

# Install QEMU Guest Agent
echo "Installing QEMU Guest Agent..."
sudo apt update -qq
sudo apt install -y qemu-guest-agent

# Enable and start the service
echo "Enabling and starting QEMU Guest Agent..."
sudo systemctl enable --now qemu-guest-agent
echo "QEMU Guest Agent installed and running successfully!"
