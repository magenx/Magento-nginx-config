HHVM configuration enabled.<br/>
CentOS 7 <br/>
https://yum.gleez.com/7/x86_64/repoview/hhvm.html <br/>

/etc/hhvm/server.ini 
```
pid = /var/run/hhvm/pid

hhvm.source_root = /var/www/html/
hhvm.server.ip = 127.0.0.1
hhvm.server.port = 9001
hhvm.server.type = fastcgi
hhvm.server.default_document = index.php
hhvm.log.use_log_file = true
hhvm.log.file = /var/log/hhvm/error.log
hhvm.repo.central.path = /var/run/hhvm/hhvm.hhbc
```

for ssl configuration in nginx.conf you **must**: <br/>
1 - open    `cd /etc/ssl/certs` <br/>
2 - generate dhparam file    `openssl dhparam -out dhparams.pem 2048` <br/>
3 - enable in nginx.conf  `ssl_dhparam /etc/ssl/certs/dhparams.pem;` <br/>


https://weakdh.org/sysadmin.html
