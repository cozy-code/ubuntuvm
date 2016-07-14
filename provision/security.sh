#!/bin/sh

set -x
#load config file
. ~/provision/config_value

#diable password login
TIMESTAMP=`date -u +%s`
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.$TIMESTAMP.back
EDIT="s/^PermitRootLogin .*$/PermitRootLogin no/"
EDIT="$EDIT;s/Port [0-9 ]*$/Port $SSH_PORT/"
EDIT="$EDIT;s/PasswordAuthentication .*$/PasswordAuthentication no/"
cat /etc/ssh/sshd_config | sed "$EDIT"  | sudo tee /etc/ssh/sshd_config

sudo service ssh restart

# fire wall
#sudo apt-get -y install iptables

sudo apt-get -y install ufw
sudo ufw default deny
sudo ufw allow $SSH_PORT
sudo ufw limit 22
sudo ufw --force enable

sudo echo $SSH_PORT| sudo tee /vagrant/ssh_port
