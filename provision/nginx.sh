#!/bin/sh

set -x
#load config file
. ~/provision/config_value

#install
sudo apt-get -y update
sudo apt-get -y install nginx
echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections -v
echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections -v

#MYSQL
sudo apt-get -y install mysql-server

#PHP
sudo apt-get install -y php-fpm php-mysql php php-cgi php-cli php-gd php-apcu php-pear php-xmlrpc php-mbstring php-mcrypt

#PHP_INI_FILE=`php -i | grep "Loaded Configuration File" | awk -F'=> ' '{print $2}'`
PHP_INI_FILE=/etc/php/7.0/fpm/php.ini
TIMESTAMP=`date -u +%s`
sudo cp $PHP_INI_FILE $PHP_INI_FILE.$TIMESTAMP.back
cat $PHP_INI_FILE | sed -e "s/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" | sudo tee $PHP_INI_FILE
sudo systemctl restart php7.0-fpm


#firewall
sudo ufw allow 'Nginx Full'

#Virtual host setting
TEMPLATEFILE=~/provision/etc/nginx/sites-available/virtualhost.template
sudo chmod -R 755 /var/www

HOSTNAME=test.vertual.com
cat $TEMPLATEFILE | sed -e "s/{{HOSTNAME}}/$HOSTNAME/" | sudo tee /etc/nginx/sites-available/$HOSTNAME
sudo ln -s /etc/nginx/sites-available/$HOSTNAME /etc/nginx/sites-enabled/$HOSTNAME
sudo mkdir /var/www/sites/$HOSTNAME/html
sudo chown -R $WORKING_USER:$WORKING_USER /var/www/sites/$HOSTNAME/html

# echo '<?php phpinfo(); ?>' > /var/www/sites/$HOSTNAME/html/index.php


sudo systemctl reload nginx
