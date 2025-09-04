#!/usr/bin/env bash
sudo apt update
sudo apt upgrade -y
#Install software-commons-common incase it is not already installed
sudo apt install -y software-properties-common
#Add Ansible PPA
sudo add-apt-repository --yes --update ppa:ansible/ansible
#Install Ansible
sudo apt install -y ansible
#Verify installation
ansible --version
