#!/bin/bash
#### Install nginx configuration
#### IT WILL REMOVE ALL CONFIGURATION FILES THAT HAVE BEEN PREVIOUSLY INSTALLED.

NGINX_EXTRA_CONF="error_page.conf extra_protect.conf export.conf php_backend.conf maintenance.conf maps.conf phpmyadmin.conf"
NGINX_EXTRA_CONF_URL="https://raw.githubusercontent.com/magenx/nginx-config/master/magento1/conf_m1/"

echo "---> CREATING NGINX CONFIGURATION FILES NOW"
echo
read -e -p "---> Enter your domain name (without www.): " -i "myshop.com" MY_DOMAIN
read -e -p "---> Enter your web root path: " -i "/var/www/html" MY_SHOP_PATH

wget -qO /etc/nginx/fastcgi_params https://raw.githubusercontent.com/magenx/nginx-config/master/magento1/fastcgi_params
wget -qO /etc/nginx/nginx.conf https://raw.githubusercontent.com/magenx/nginx-config/master/magento1/nginx.conf

sed -i "s/www/sites-enabled/g" /etc/nginx/nginx.conf

mkdir -p /etc/nginx/sites-enabled
mkdir -p /etc/nginx/sites-available && cd $_
wget -q https://raw.githubusercontent.com/magenx/nginx-config/master/magento1/sites-available/default.conf
wget -q https://raw.githubusercontent.com/magenx/nginx-config/master/magento1/sites-available/magento1.conf

sed -i "s/example.com/${MY_DOMAIN}/g" /etc/nginx/sites-available/magento1.conf
sed -i "s,root /var/www/html,root ${MY_SHOP_PATH},g" /etc/nginx/sites-available/magento1.conf

ln -s /etc/nginx/sites-available/magento1.conf /etc/nginx/sites-enabled/magento1.conf
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

mkdir -p /etc/nginx/conf_m1 && cd /etc/nginx/conf_m1/
for CONFIG in ${NGINX_EXTRA_CONF}
do
wget -q ${NGINX_EXTRA_CONF_URL}${CONFIG}
done
