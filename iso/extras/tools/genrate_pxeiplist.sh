#!/bin/bash
set -o xtrace
DEPLOY_IP=$1
PXEFILE=/root/tools/ansible/inventory/default
echo "[pxe]" > ${PXEFILE}
docker exec -i cobbler cat /var/lib/dhcpd/dhcpd.leases |grep '^lease'| cut -d' ' -f2| sort -u>>${PXEFILE}
echo "[deploy]" >> ${PXEFILE}
echo $DEPLOY_IP >> ${PXEFILE}
