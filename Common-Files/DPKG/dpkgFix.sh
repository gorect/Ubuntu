#!/usr/bin/env bash
#Use this in the event that a .deb package failed to install properly. The new rerun the dpkg -i command. 
sudo apt -f install
