#!/bin/sh

set -x
#load config file
. ~/provision/config_value

#install
sudo apt-get -y update
sudo apt-get -y install nginx

#firewall
sudo ufw allow 'Nginx Full'
