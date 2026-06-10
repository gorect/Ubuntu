#!/usr/bin/env bash

MODULE="prereqs"

check_prereqs() {
    local pkg

    for pkg in \
        curl \
        git \
        wget \
        vim \
        htop \
        net-tools \
        cifs-utils \
        gedit \
        iputils-ping
    do
        dpkg -s "$pkg" >/dev/null 2>&1 || return 1
    done

    return 0
}
