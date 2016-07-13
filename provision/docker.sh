#!/bin/sh

set -x

#load config file
. ~/provision/config_value
# install docker https://docs.docker.com/engine/installation/linux/ubuntulinux/
sudo apt-get -y update
sudo apt-get -y install apt-transport-https ca-certificates

sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get -y update
sudo apt-get -y purge lxc-docker

sudo apt-get -y install linux-image-extra-$(uname -r)
sudo apt-get -y install docker-engine

#start
sudo service docker start
#Docker to start on boot
sudo systemctl enable docker

#enable non-root user access docker
sudo groupadd docker
sudo usermod -aG docker $WORKING_USER

