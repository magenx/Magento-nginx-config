for ssl configuration in nginx.conf you **must**: <br/>
1 - open    `cd /etc/ssl/certs` <br/>
2 - generate dhparam file    `openssl dhparam -out dhparams.pem 2048` <br/>
3 - enable    `ssl_dhparam /etc/ssl/certs/dhparams.pem` <br/>


https://weakdh.org/sysadmin.html
