#!/bin/bash

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y -f openjdk-7-jre-headless libsvn1
sudo apt-get install -y -f

# Install mesos package from Mesosphere
# See: http://mesosphere.com/downloads
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)

# Add the repository
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | \
  sudo tee /etc/apt/sources.list.d/mesosphere.list
sudo apt-get -y update

sudo apt-get -y install mesos

sudo mkdir -p /var/local/mesos/logs/{master,agent}
sudo mkdir -p /var/local/mesos/{master,agent}

# The package install will configure a master/agent to start
# at boot on each server and point to a non-existent ZooKeeper
# We need to get rid of that:
if [[ -e "/etc/init/mesos-*" ]]; then
    sudo mv /etc/init/mesos-* /var/local/mesos
fi
