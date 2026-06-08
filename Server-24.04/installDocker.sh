#!/usr/bin/env bash

Err() {
	printf 'Err: %s\n' "$2" 1>&2
	(( $1 > 0 )) && exit $1
}

DockerInstall() {
    #Add Docker's official GPG key:
    sudo apt-get update -y
    sudo apt-get install ca-certificates curl gnupg -y
    sudo install -m 0755 -d /etc/apt/keyrings -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    #Add the repository to Apt sources:
    echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y

    #Install the latest version
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    #Use docker without Sudo
    USER=$(whoami)
    sudo usermod -aG docker $USER
    sudo systemctl enable --now docker
    read -p 'For '"$USER"' to run docker commands without 'sudo' please log out and log back in again.'
}

#Checking for Docker installation
if ! type -P docker &> /dev/null; then
	Err 0 "Dependency 'docker' not found."
    read -p 'Would you like to install docker? [Y/N/Q] ? '
	case ${REPLY,,} in
		y|yes)
			DockerInstall ;;
		n|no)
			read -p 'Docker will not be installed. Quitting'
            sleep 3
            exit 0 ;;
		q|quit)
			exit 0 ;;
		'')
			Err 0 'Empty response -- try again.' ;;
		*)
			Err 0 'Invalid response -- try again.' ;;
	esac
fi
