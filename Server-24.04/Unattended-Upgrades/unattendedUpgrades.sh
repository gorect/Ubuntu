#!/usr/bin/env bash 

# Create variable to show the current directory of the script. 
SCRIPT_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Define paths to the two config files
CONFIG_20="${SCRIPT_DIR}/20auto-upgrades"
CONFIG_50="${SCRIPT_DIR}/50unattended-upgrades"

# Use the config files
if [[ -f "$CONFIG_20" && -f "$CONFIG_50" ]]; then
    echo "Both config files exist."
    sudo apt update && sudo apt upgrade -y
    sudo apt install unattended-upgrades
    #sudo systemctl status unattended-upgrades 
    #add check for enabled and running. 
    sudo dpkg-reconfigure -plow unattended-upgrades
    echo "Copying $CONFIG_20 and $CONFIG_50"
    cp $CONFIG_20 /etc/apt/apt.conf.d/.
    cp $CONFIG_50 /etc/apt/apt.conf.d/.
    
else
    echo "One or both config files are missing!"
    exit 1
fi


cat /etc/apt/apt.conf.d/20auto-upgrades
#add check for 1, 1 file contents 
cat /etc/apt/apt.conf.d/50unattended-upgrades 
#add check to pull in corrected version of 50unattended-upgrades 
sudo systemctl restart unattended-upgrades
