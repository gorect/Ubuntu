#! /usr/bin/env bash 
#This is for my MBP which will not successfully reach the login screen when using the default Ubuntu 24.94 desktop installer. 
sudo apt install xserver-xorg xinit
sudo apt install libpangocairo-1.0-0
sudo apt install python3-pip python3-xcffib python3-cairocffi

#without the next two lines, ubuntu will not allow pip installations from externally managed sources. This then creates a virtual environment that aloows pip install qtile ti successfully install. 
python3 -m venv qtile-env
source qtile-env/bin/activate
pip install qtile

#create create directory xsessions for the qtile.desktop file. 
sudo mkdir /usr/share/xsessions
#cp file qtile.desktop to /usr/share/xsessions/.
