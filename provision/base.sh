#!/bin/sh

set -x
#load config file
source ~/provision/config_value

# Base 64 Encoded certification file
sudo cp ~/provision/cert/*.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates


sudo apt-get -y update
sudo apt-get -y upgrade

#sudo apt-get -y install iptables

#diable password login
TIMESTAMP=`date -u +%s`
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.$TIMESTAMP.back
EDIT="s/^PermitRootLogin .*$/PermitRootLogin no/"
EDIT="$EDIT;s/Port [0-9 ]*$/Port $SSH_PORT/"
EDIT="$EDIT;s/PasswordAuthentication .*$/PasswordAuthentication no/"
sed "$EDIT" /etc/ssh/sshd_config | sudo tee /etc/ssh/sshd_config

sudo service ssh restart
