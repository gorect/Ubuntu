#!/usr/bin/env bash

# create code here to wget the latest version of the go tarball at https://go.dev/dl/$GOVERSION

wget $GOVERSION
rm -rf /usr/local/go && tar -C /usr/local -xzf $GOVERSION
export PATH=$PATH:/usr/local/go/bin
source $HOME/.profile
go version
rm $GOVERSION #rm go1.22.1.linux-amd64.tar.gz
