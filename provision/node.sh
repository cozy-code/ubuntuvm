#!/bin/sh

set -x

# -k: ignore SSL error
if !(which nodebrew >/dev/null); then
    # install
    curl -sSL git.io/nodebrew | perl - setup
    if !(grep -q "export PATH=$HOME/\.nodebrew/current/bin:" $HOME/.bash_profile); then
        echo "export PATH=$HOME/.nodebrew/current/bin:\$PATH" >> $HOME/.bash_profile
        . $HOME/.bash_profile
    fi
else
    echo 'nodebrew installed'
fi

# # use stable version
#nodebrew install-binary stable
#nodebrew use stable

# # use LTS version
#nodebrew install-binary v4.x
#nodebrew use v4.x

# # use 5.x version
nodebrew install-binary v5.x
nodebrew use v5.x

npm update -g
npm update -g npm

sudo apt-get -y install git net-tools sudo bzip2

npm install -g bower
npm install -g grunt-cli
npm install -g gulp gulp-cli
npm install -g yo
npm install -g generator-angular-fullstack
npm install -g npm-check-updates

#mongodb
# Adding the MongoDB Repository
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get -y update
#install
sudo apt-get install -y --allow-unauthenticated mongodb-org
#config
MONGO_CONF=$(cat << 'EOS'
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target
EOS
)
echo "$MONGO_CONF" | sudo tee /etc/systemd/system/mongodb.service

#start
sudo service mongodb start
sudo systemctl enable mongodb
