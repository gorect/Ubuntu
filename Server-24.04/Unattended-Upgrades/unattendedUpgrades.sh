#!/usr/bin/env bash 

sudo apt update
sudo apt-get install unattended 
systemctl status unattended-upgrades 
#add check for enabled and running. 
sudo dpkg-reconfigure -plow unattended-upgrades
cat /etc/apt/apt.conf.d/20auto-upgrades
#add check for 1, 1 file contents 
cat /etc/apt/apt.conf.d/50unattended-upgrades 
#add check to pull in corrected version of 50unattended-upgrades 
