#!/bin/bash
# LOAD BALANCER : UPDATE UPSTREAMS
# Check running units
# filter instances by tag and state
TAG="web-node*"
STATE="running"
FILTER=""Name=tag-value,Values=${TAG}" "Name=instance-state-name,Values=${STATE}""
BACKEND=$(aws ec2 describe-instances --filter ${FILTER} | awk '/PRIVATEIPADDRESS/{print $4}')
echo ${BACKEND} > /tmp/backend_new.conf
[ -f "/tmp/backend.conf" ] || touch /tmp/backend.conf
DIFF=$(diff /tmp/backend.conf /tmp/backend_new.conf)
if [ "${DIFF}" != "" ]
then
        mv -f /tmp/backend_new.conf /tmp/backend.conf
        # Remove old upstreams
        sed -i '/{/,/keepalive/ {/{/n;/keepalive/!d}' /etc/nginx/backend.conf
        # Inject new upstreams
        for IP in $(cat /tmp/backend.conf)
        do
                sed -i "/upstream backend/ a\
                        server ${IP};" /etc/nginx/backend.conf
        done
        # Load new upstreams
        service nginx restart
        echo "IP loaded into backend - ${BACKEND}" | mail -s "Load Balancer reloaded" admin@magento.com
fi
