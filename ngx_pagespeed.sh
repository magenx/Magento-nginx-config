#!/bin/bash

#====================#===============#
# CENTOS 7 OPTIMIZED | MAGENX SERVER #
#====================#===============#

NGINX_VERSION=$(curl -s http://nginx.org/en/download.html | grep -oP '(?<=gz">).*?(?=</a>)' | head -1)
NPS_VERSION=$(curl -s https://api.github.com/repos/apache/incubator-pagespeed-ngx/tags 2>&1 | head -3 | grep -oP '(?<="v).*(?=")')
NGINX_PAGESPEEDSO="/usr/lib64/nginx/modules/ngx_pagespeed.so"

yum -y -q install gcc-c++ pcre-devel zlib-devel make unzip libuuid-devel

rm -rf /opt/ngx_pagespeed_module/
mkdir -p /opt/ngx_pagespeed_module && cd $_

wget -O v${NPS_VERSION}.zip https://github.com/apache/incubator-pagespeed-ngx/archive/v${NPS_VERSION}.zip
unzip -o v${NPS_VERSION}.zip
cd incubator-pagespeed-ngx-${NPS_VERSION}/

NPS_RELEASE_NUMBER=${NPS_VERSION/beta/}
NPS_RELEASE_NUMBER=${NPS_VERSION/stable/}
psol_url=https://dl.google.com/dl/page-speed/psol/${NPS_RELEASE_NUMBER}.tar.gz

[ -e scripts/format_binary_url.sh ] && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL)
wget ${psol_url}
tar -xzf $(basename ${psol_url})

cd /opt/ngx_pagespeed_module
wget -O ${NGINX_VERSION}.tar.gz http://nginx.org/download/${NGINX_VERSION}.tar.gz
tar -xzf ${NGINX_VERSION}.tar.gz
cd ${NGINX_VERSION}/
./configure --prefix=/etc/nginx \
	--sbin-path=/usr/sbin/nginx \
	--modules-path=/usr/lib64/nginx/modules \
	--conf-path=/etc/nginx/nginx.conf \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
	--pid-path=/var/run/nginx.pid \
	--lock-path=/var/run/nginx.lock \
	--http-client-body-temp-path=/var/cache/nginx/client_temp \
	--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
	--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
	--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
	--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
	--user=nginx \
	--group=nginx \
	--with-compat \
	--with-file-aio \
	--with-threads \
	--with-http_addition_module \
	--with-http_auth_request_module \
	--with-http_dav_module \
	--with-http_flv_module \
	--with-http_gunzip_module \
	--with-http_gzip_static_module \
	--with-http_mp4_module \
	--with-http_random_index_module \
	--with-http_realip_module \
	--with-http_secure_link_module \
	--with-http_slice_module \
	--with-http_ssl_module \
	--with-http_stub_status_module \
	--with-http_sub_module \
	--with-http_v2_module \
	--with-mail \
	--with-mail_ssl_module \
	--with-stream \
	--with-stream_realip_module \
	--with-stream_ssl_module \
	--with-stream_ssl_preread_module \
	--with-http_perl_module \
	--with-http_geoip_module \
	--add-dynamic-module=/opt/ngx_pagespeed_module/incubator-pagespeed-ngx-${NPS_VERSION} \
	--with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' \
	--with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie'

if [ $? -eq 0 ]; then
if [ -d "/etc/nginx" ]; then  
    cp -rf /etc/nginx /etc/nginx_config_back_nps  
    #yum remove nginx
fi
if [ -L ${NGINX_PAGESPEEDSO} ]; then
     rm ${NGINX_PAGESPEEDSO%.*}*
fi
make
else
  echo "==============================================================="
  echo "Configure error"
  exit 1
fi

if [ $? -eq 0 ]; then
make install
cd /usr/lib64/nginx/modules
mv ngx_pagespeed.so ngx_pagespeed_${NGINX_VERSION}.so 
ln -s ngx_pagespeed_${NGINX_VERSION}.so ngx_pagespeed.so

if [ -d "/etc/nginx_config_back_nps" ]; then  
    rm -rf /etc/nginx
    cp -rf /etc/nginx_config_back_nps /etc/nginx 
fi
if [ ! -L "/etc/nginx/modules" ] ; then
   cd /etc/nginx
   ln -s /usr/lib64/nginx/modules modules
fi
else
  echo "==============================================================="
  echo "Make error"
  exit 1
fi

