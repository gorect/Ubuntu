#!/bin/bash
##Use the following command to set up the stable repository. 
   ##To add the nightly or test repository, add the word nightly or test (or both) after the word stable in the commands below.
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
