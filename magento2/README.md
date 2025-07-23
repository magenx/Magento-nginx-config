TESTING<br/>

to enable configuration you have to run these commands:  
```cd /etc/nginx/sites-enabled/```  
```ln -s /etc/nginx/sites-available/default.conf ./default.conf```  
```ln -s /etc/nginx/sites-available/magento2.conf ./magento2.conf```  
```nginx -t```  
if no errors detected, then  
```service nginx restart```

for local ssl configuration in nginx.conf you must:  
1 - open ```cd /etc/ssl/certs```  
2 - generate dhparam file ```openssl dhparam -out dhparams.pem 4096```  
3 - enable in nginx.conf ```ssl_dhparam /etc/ssl/certs/dhparams.pem;```  


```conf_m2/cors.conf``` => custom CORS headers  
```conf_m2/error_page.conf``` => configure custom error pages  
```conf_m2/extra_protect.conf``` => protecting everything  
```conf_m2/maintenance.conf``` => global maintenance  
```conf_m2/maps.conf``` => global nginx maps  
```conf_m2/media.conf``` => settings for any media assets  
```conf_m2/pagespeed.conf``` => settings for pagespeed plugin  
```conf_m2/php_backend.conf``` => global settings for php execution  
```conf_m2/phpmyadmin.conf``` => settings for phpMyAdmin  
```conf_m2/sitemap.conf``` => settings for any SEO  
```conf_m2/static.conf``` => settings for any static assets  
```conf_m2/status.conf``` => nginx/php-fpm status locations  
```conf_m2/varnish_proxy.conf``` => varnish cache proxy  


```sites-available/default.conf``` => catch non-existent server name  
```sites-available/magento2.conf``` => magento virtual host/server configuration file  


```fastcgi_params``` => global fastcgi parameters  
```nginx.conf``` => main nginx configuration file  
