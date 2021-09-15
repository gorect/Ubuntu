#!/bin/bash
echo "sudo apt update -y && sudo apt dist-upgrade -y"
sudo apt update -y && sudo apt dist-upgrade -y

#install basic tools
echo"sudo apt install vim -y"
sudo apt install vim -y
echo"sudo apt install git -y"
sudo apt install git -y
echo"sudo apt install wget -y"
sudo apt install wget -y
echo"sudo apt install make -y"
sudo apt install make -y
echo"sudo apt install gcc -y"
sudo apt install gcc -y
echo"sudo apt install gnome-tweak-tool -y"
sudo apt install gnome-tweak-tool -y
echo"sudo apt install gparted -y"
sudo apt install gparted -y
echo"sudo apt install transmission -y"
sudo apt install transmission -y

#copy over wallpapers
echo"cp -r Wallpapers/ ~/Pictures/"
cp -r Wallpapers/ ~/Pictures/

# remove firefox
echo"sudp apt remove firefox -y"
sudp apt remove firefox -y

#Install chrome
echo"sudo apt install gdebi-core wget"
sudo apt install gdebi-core wget
echo"wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
echo"sudo gdebi google-chrome-stable_current_amd64.deb"
sudo gdebi google-chrome-stable_current_amd64.deb
echo"google-chrome"
google-chrome

#install bpytop
echo"sudo apt install python3-pip -y"
sudo apt install python3-pip -y
echo"pip3 install bpytop -y"
pip3 install bpytop -y
echo"export PATH=$PATH:/home/cameron.local/bin"
export PATH=$PATH:/home/cameron.local/bin
echo $PATH

#install etcher
#echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
##sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
#echo"sudo apt update -y"
#sudo apt update -y
#curl -1sLf \
##   'https://dl.cloudsmith.io/public/balena/etcher/setup.deb.sh' \
#   | sudo -E bash
#echo"sudo apt install balena-etcher-electron -y"
#sudo apt install balena-etcher-electron -y

#install VsCodium
sudo apt update -y
sudo apt upgrade -y
sudo apt install apt-transport-https -y
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg
echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list
sudo apt update -y
sudo apt install codium -y

#set up grub for 'loud splash'
# /etc/default/grub
# change timeout from 0 to 5
# delete quite splash

# set up Programs dir
echo"mkdir -p ~/Programs"
mkdir -p ~/Programs

#update/autoremove
sudo apt update -y && sudo apt autoremove -y

#Change login screen from purple to image
echo"sudo apt install libglib2.0-dev-bin"
sudo apt install libglib2.0-dev-bin
echo"sudo apt install git make gcc libgtk-3-dev libpolkit-gobject-1-dev"
sudo apt install git make gcc libgtk-3-dev libpolkit-gobject-1-dev
echo"git clone https://github.com/thiggy01/gdm-background.git"
git clone https://github.com/thiggy01/gdm-background.git
cd gdm-background
echo"make"
make
echo"sudo make install"
sudo make install
gdm-background
