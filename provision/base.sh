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

# /etc/fstab
# original = "LABEL=cloudimg-rootfs    /    ext4   defaults    0 0"
echo "LABEL=cloudimg-rootfs   /    ext4   defaults,noatime,nodiratime,relatime    0 1" | sudo tee /etc/fstab

sudo apt-get -y update
sudo apt-get -y upgrade


# bash_profile
if !(grep -q "~/\.bashrc" $HOME/.bash_profile); then
    echo "test -r ~/.bashrc && . ~/.bashrc" >> $HOME/.bash_profile
    . $HOME/.bash_profile
fi

#add password enable working user
if !( grep "^$LOGINUSER:" /etc/passwd > /dev/null ) && [ -e ~/provision/public_key/$LOGINUSER.pub ]; then
    sudo useradd -m $LOGINUSER
    echo "$LOGINUSER:$LOGINUSER_PASS" | sudo chpasswd
    sudo usermod -aG sudo $LOGINUSER
    sudo mkdir /home/$LOGINUSER/.ssh
    sudo chown $LOGINUSER:$LOGINUSER /home/$LOGINUSER/.ssh
    sudo chmod 700 /home/$LOGINUSER/.ssh
    cat ~/provision/public_key/$LOGINUSER.pub | sudo tee -a /home/$LOGINUSER/.ssh/authorized_keys
    sudo chown $LOGINUSER:$LOGINUSER /home/$LOGINUSER/.ssh/authorized_keys
    sudo chmod 600 /home/$LOGINUSER/.ssh/authorized_keys
fi
