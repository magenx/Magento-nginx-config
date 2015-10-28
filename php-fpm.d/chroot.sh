#!/bin/bash
## create files for chroot

mkdir -p {etc/pki,usr/share,tmp,dev,lib64}
cp /etc/nsswitch.conf  etc/
cp /etc/resolv.conf  etc/
cp -rf /etc/pki/{CA,ca-trust,tls,nssdb} etc/pki/
cp /lib64/{libsoftokn3.*,libnss*,libfreebl*} lib64/
cp -rf /usr/share/zoneinfo  usr/share/
mknod -m 644 dev/urandom c 1 9
