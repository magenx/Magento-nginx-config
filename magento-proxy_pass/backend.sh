#!/bin/bash
# LOAD BALANCER : UPDATE UPSTREAMS
# Check running units
# filter instances by tag and state
TAG="web-node*"
STATE="running"
FILTER=""Name=tag-value,Values=${TAG}" "Name=instance-state-name,Values=${STATE}""
BACKEND=$(aws ec2 describe-instances --filter ${FILTER} | awk '/PRIVATEIPADDRESS/{print $4}')
${BACKEND} > /tmp/backend_new.conf
[ -f "/tmp/backend.conf" ] || touch /tmp/backend.conf
DIF=$(diff /tmp/backend.conf /tmp/backend_new.conf)
if [ -n ${DIF} ]; then
        echo "no changes"
else
        mv -f /tmp/backend_new.conf /tmp/backend.conf
        # Remove old upstreams
        sed -i '/{/,/}/ {/{/n;/}/!d}' /etc/nginx/backend.conf
        # Inject new upstreams
        for IP in $(cat /tmp/backend.conf)
        do
                sed -i "/upstream backend/ a\
                        server ${IP};" /etc/nginx/backend.conf
        done
        # Load new upstreams
        service nginx reload
fi
