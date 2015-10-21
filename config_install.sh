#!/bin/bash
#### Install nginx configuration
#### IT WILL REMOVE ALL CONFIGURATION FILES THAT HAVE BEEN PREVIOUSLY INSTALLED.

NGINX_EXTRA_CONF="error_page.conf extra_protect.conf export.conf hhvm.conf headers.conf maintenance.conf multishop.conf pagespeed.conf spider.conf"
NGINX_EXTRA_CONF_URL="https://raw.githubusercontent.com/magenx/nginx-config/master/magento/conf.d/"

echo "---> CREATING NGINX CONFIGURATION FILES NOW"
echo
read -e -p "---> Enter your domain name (without www.): " -i "myshop.com" MY_DOMAIN
read -e -p "---> Enter your web root path: " -i "/var/www/html" MY_SHOP_PATH

wget -qO /etc/nginx/port.conf https://raw.githubusercontent.com/magenx/nginx-config/master/magento/port.conf
wget -qO /etc/nginx/fastcgi_params https://raw.githubusercontent.com/magenx/nginx-config/master/magento/fastcgi_params
wget -qO /etc/nginx/nginx.conf https://raw.githubusercontent.com/magenx/nginx-config/master/magento/nginx.conf

sed -i "s/www/sites-enabled/g" /etc/nginx/nginx.conf

mkdir -p /etc/nginx/sites-enabled
mkdir -p /etc/nginx/sites-available && cd $_
wget -q https://raw.githubusercontent.com/magenx/nginx-config/master/magento/www/default.conf
wget -q https://raw.githubusercontent.com/magenx/nginx-config/master/magento/www/magento.conf

sed -i "s/example.com/${MY_DOMAIN}/g" /etc/nginx/sites-available/magento.conf
sed -i "s,root /var/www/html,root ${MY_SHOP_PATH},g" /etc/nginx/sites-available/magento.conf

ln -s /etc/nginx/sites-available/magento.conf /etc/nginx/sites-enabled/magento.conf
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

cd /etc/nginx/conf.d/
for CONFIG in ${NGINX_EXTRA_CONF}
do
wget -q ${NGINX_EXTRA_CONF_URL}${CONFIG}
done
