#!/bin/bash
#### Install nginx configuration
#### IT WILL REMOVE ALL CONFIGURATION FILES THAT HAVE BEEN PREVIOUSLY INSTALLED.

GITHUB_REPO_API_URL="https://api.github.com/repos/magenx/Magento-nginx-config/contents/magento2"

echo "---> CREATING NGINX CONFIGURATION FILES NOW"
echo
read -e -p "---> Enter your domain name (without www.): " -i "myshop.com" MAGE_DOMAIN
read -e -p "---> Enter your web user: " -i "www-data" MAGE_OWNER
read -e -p "---> Enter your web root path: " -i "/home/${MAGE_OWNER}/public_html" MAGE_WEB_ROOT_PATH

curl -o /etc/nginx/fastcgi_params https://raw.githubusercontent.com/magenx/Magento-nginx-config/master/magento2/fastcgi_params
curl -o /etc/nginx/nginx.conf https://raw.githubusercontent.com/magenx/Magento-nginx-config/master/magento2/nginx.conf

mkdir -p /etc/nginx/sites-enabled
mkdir -p /etc/nginx/sites-available && cd $_
curl -s ${GITHUB_REPO_API_URL}/sites-available 2>&1 | awk -F'"' '/download_url/ {print $4 ; system("curl -sO "$4)}' >/dev/null

sed -i "s/example.com/${MAGE_DOMAIN}/g" /etc/nginx/sites-available/magento2.conf
sed -i "s,/var/www/html,${MAGE_WEB_ROOT_PATH},g" /etc/nginx/conf_m2/maps.conf
sed -i "s,user  nginx,user  ${MAGE_OWNER},g" /etc/nginx/nginx.conf

ln -s /etc/nginx/sites-available/magento2.conf /etc/nginx/sites-enabled/magento2.conf
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

mkdir -p /etc/nginx/conf_m2 && cd /etc/nginx/conf_m2/
curl -s ${GITHUB_REPO_API_URL}/conf_m2 2>&1 | awk -F'"' '/download_url/ {print $4 ; system("curl -sO "$4)}' >/dev/null
