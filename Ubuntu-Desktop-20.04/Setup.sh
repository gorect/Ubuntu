#!/bin/bash
sudo apt update -y && sudo apt dist-upgrade -y

#install basic tools
sudo apt install vim -y
sudo apt install git -y
sudo apt install wget -y
sudo apt install make -y
sudo apt install gcc -y
sudo apt install gnome-tweak-tool -y
sudo apt install gparted -y
sudo apt install transmission -y

#copy over wallpapers
cp -r Wallpapers/ ~/Pictures/

# remove firefox
sudp apt remove firefox -y

#Install chrome
sudo apt install gdebi-core wget
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo gdebi google-chrome-stable_current_amd64.deb -y
google-chrome

#install bpytop
sudo apt install python3-pip -y
pip3 install bpytop -y
export PATH=$PATH:/home/cameron.local/bin
echo $PATH

#install etcher
echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
sudo apt update -y 
sudo apt install balena-etcher-electron -y

#set up grub for 'loud splash'
# /etc/default/grub
# change timeout from 0 to 5
# delete quite splash

# set up Programs dir
cd
mkdir Programs

#Change login screen from purple to image
sudo apt install libglib2.0-dev-bin
sudo apt install git make gcc libgtk-3-dev libpolkit-gobject-1-dev
git clone https://github.com/thiggy01/gdm-background.git
cd gdm-background
make
sudo make install
gdm-background
