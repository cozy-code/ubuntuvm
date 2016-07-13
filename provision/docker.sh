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

#Enable UFW forwarding
TIMESTAMP=`date -u +%s`
sudo cp /etc/default/ufw /etc/default/ufw.$TIMESTAMP.back

EDIT="s/^DEFAULT_FORWARD_POLICY=.*$/DEFAULT_FORWARD_POLICY=\"ACCEPT\"/"
cat /etc/default/ufw  | sed "$EDIT"  | sudo tee /etc/default/ufw
sudo ufw reload
sudo ufw allow 2375/tcp

#Configure a DNS server for use by Docker

if !( grep "^ *DOCKER_OPTS=" /etc/default/docker > /dev/null ); then
    echo "DOCKER_OPTS=\"--dns 8.8.8.8 --dns 8.8.4.4\"" | sudo tee -a /etc/default/docker
    sudo service docker restart
fi
