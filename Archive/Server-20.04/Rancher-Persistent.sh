#!/usr/bin/env bash
##Rancher uses etcd as datastore. When using the Docker Install, the embedded etcd is being used. 
  ##The persistent data is at the following path in the container: /var/lib/rancher. 
  ##You can bind mount a host volume to this location to preserve data on the host it is running on.
docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  -v /opt/rancher:/var/lib/rancher \
  rancher/rancher:latest
