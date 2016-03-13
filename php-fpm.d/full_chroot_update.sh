#!/bin/bash
## CHROOT SIMPLE QUICK UPDATE
## running from chroot folder

\cp -Lrf {/usr/lib64/,/lib64/}{libnss*,libsoftokn*,libfreebl*} lib64/
\cp -rf /etc/pki/{CA,ca-trust,tls,nssdb}  etc/pki/
