#!/bin/bash

#Update repo
apt-get update
apt-get upgrade

#Generate mysql password
MYSQL_ROOT_PASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w8 | head -n1)

#Set the password so you don't have to enter it during installation
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"

#Tools
apt-get install htop vim -y

#Main install
apt-get install mysql-server mysql-client apache2 php5 php5-cli libapache2-mod-php5 php5-mysql php5-memcached php5-curl php5-gd php-pear php5-imagick php5-mcrypt php5-mhash php5-sqlite php5-xmlrpc php5-xsl php5-json php5-dev libpcre3-dev make sed -y

sed -i "2i\memory_limit = 128M" /etc/php5/apache2/php.ini
sed -i "4i\upload_max_filesize = 64M" /etc/php5/apache2/php.ini
sed -i "5i\post_max_size = 64M" /etc/php5/apache2/php.ini

service apache2 restart

#Create info file
echo "<?php phpinfo();" > /var/www/html/info.php

echo "---- Installation completed ----"
echo "Your PHP Version is:"
php -v
echo "---"
echo "Your MySQL root password is:"
echo $MYSQL_ROOT_PASSWORD