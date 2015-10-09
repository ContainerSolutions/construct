#!/bin/bash

if [[ -z $(which wget) ]]; then
   sudo apt-get install -y wget
fi
wget -qO- https://get.docker.com/ | sh

if [[ $? != 0 ]]; then
    echo "ERROR - failed to install Docker"
    exit 1
fi

# Check this can download and run containers
RES=$(docker run hello-world | grep "Hello from Docker.")
if [[ -z ${RES} ]]; then
    echo "ERROR - look like docker installed, but containers cannot be run"
    exit 1
fi

# Enable docker to be run by the `vagrant` user:
sudo usermod -a -G docker vagrant

VERSION=$(docker --version)
echo "SUCCESS -- ${VERSION} is up and running"

