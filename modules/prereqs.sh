#!/usr/bin/env bash

#set user check for VM
# Is this a virtual machine?
#if so, sudo apt install qemu-guest-agent

sudo apt update && sudo apt upgrade -y
sudo apt install vim wget curl net-tools cifs-utils gedit iputils-ping
