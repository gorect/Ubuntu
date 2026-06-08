#!/usr/bin/env bash

MODULE="prereqs"

check_prereqs() {
    command -v curl >/dev/null 2>&1 &&
    command -v git >/dev/null 2>&1
}

apply_prereqs() {
    log "Installing prerequisites"

    apt-get update -y

    apt-get install -y \
        curl \
        git \
        wget \
        vim \
        htop \
        net-tools \
	cifs-utils \
	gedit \
	iputils-ping
}
