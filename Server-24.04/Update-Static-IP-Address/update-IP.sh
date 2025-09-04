#!/usr/bin/env bash

# Script to get Network Interface, Update IP, Gateway, and Nameserver, update /etc/netplan/50-cloud-init.yml

# --- Define Variables ---
IP_ADDRESS=""
GATEWAY=""
NAMESERVERS=""
INTERFACE_NAME=""
NETPLAN_FILE="/etc/netplan/50-cloud-init.yaml"

# --- Function to Extract Interface Name ---
get_interface_name() {
  INTERFACE_NAME=$(grep -oP '(?<=ethernets:\n\s+)\w+' "$NETPLAN_FILE" | head -n 1)

  if [ -z "$INTERFACE_NAME" ]; then
    echo "Warning: Could not automatically determine interface name.  Using default 'eth0'."
    INTERFACE_NAME="eth0"  # Default fallback
  else
    echo "Detected interface name: $INTERFACE_NAME"
  fi
}

# --- Get User Input ---
get_interface_name
read -r -p "IPv4 Address (e.g., 192.168.1.10/24): " IP_ADDRESS
read -r -p "Gateway (e.g., 192.168.1.1): " GATEWAY
read -r -p "Nameserver(s) (comma-separated, e.g., 8.8.8.8,8.8.4.4): " NAMESERVERS

# --- Generate YAML and Write to File (with sudo) ---
cat <<EOF | sudo tee "$NETPLAN_FILE" > /dev/null
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFACE_NAME:
      dhcp4: false
      addresses: [$IP_ADDRESS]
      routes:
        - to: default
          via: $GATEWAY
      nameservers:
        addresses: [$NAMESERVERS]
EOF

# --- Apply Netplan ---
sudo netplan apply

echo "Netplan configuration updated and applied."

exit 0
