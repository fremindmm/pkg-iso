#!/bin/bash
PXE_CARD=$1
MANAGE_CARD=$2
MANAGE_GATEWAY=$3

sed -i s/GATEWAY/#GATEWAY/g /etc/sysconfig/network-scripts/ifcfg-${PXE_CARD}
echo GATEWAY=${MANAGE_GATEWAY} >> /etc/sysconfig/network-scripts/ifcfg-${MANAGE_CARD}


