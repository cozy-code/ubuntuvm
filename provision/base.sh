#!/bin/sh

set -x
#load config file
. ~/provision/config_value

#hosts
if !( grep `hostname` /etc/hosts > /dev/null ); then
    echo "127.0.0.1 `hostname`" | sudo tee -a /etc/hosts
fi

# Base 64 Encoded certification file
sudo cp ~/provision/cert/*.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates


sudo apt-get -y update
sudo apt-get -y upgrade


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
