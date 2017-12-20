#!/bin/bash
#### Install nginx configuration
#### IT WILL REMOVE ALL CONFIGURATION FILES THAT HAVE BEEN PREVIOUSLY INSTALLED.

NGINX_EXTRA_CONF="assets.conf error_page.conf extra_protect.conf maintenance.conf php_backend.conf maps.conf phpmyadmin.conf setup.conf pagespeed.conf status.conf"
NGINX_EXTRA_CONF_URL="https://raw.githubusercontent.com/magenx/nginx-config/master/magento2/conf_m2/"

echo "---> CREATING NGINX CONFIGURATION FILES NOW"
echo
read -e -p "---> Enter your domain name (without www.): " -i "myshop.com" MY_DOMAIN
read -e -p "---> Enter your web root path: " -i "/var/www/html/magento" MY_SHOP_PATH
read -e -p "---> Enter your web user usually www-data (nginx for Centos): " -i "www-data" MY_WEB_USER

wget -qO /etc/nginx/fastcgi_params https://raw.githubusercontent.com/magenx/nginx-config/master/magento2/fastcgi_params
wget -qO /etc/nginx/nginx.conf https://raw.githubusercontent.com/magenx/nginx-config/master/magento2/nginx.conf

sed -i "s/www/sites-enabled/g" /etc/nginx/nginx.conf

mkdir -p /etc/nginx/sites-enabled
mkdir -p /etc/nginx/sites-available && cd $_
wget -q https://raw.githubusercontent.com/magenx/nginx-config/master/magento2/sites-available/default.conf
wget -q https://raw.githubusercontent.com/magenx/nginx-config/master/magento2/sites-available/magento2.conf

sed -i "s/example.com/${MY_DOMAIN}/g" /etc/nginx/sites-available/magento2.conf
sed -i "s,/var/www/html,${MY_SHOP_PATH},g" /etc/nginx/sites-available/magento2.conf
sed -i "s,user  nginx,user  ${MY_WEB_USER},g" /etc/nginx/nginx.conf

ln -s /etc/nginx/sites-available/magento2.conf /etc/nginx/sites-enabled/magento2.conf
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

mkdir -p /etc/nginx/conf_m2 && cd /etc/nginx/conf_m2/
for CONFIG in ${NGINX_EXTRA_CONF}
do
wget -q ${NGINX_EXTRA_CONF_URL}${CONFIG}
done
