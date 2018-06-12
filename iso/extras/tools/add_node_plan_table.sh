#!/bin/bash
set -o xtrace
HOSTNAME=$1
PXE_IP=$2
ADMIN_IP=$3
STORAGE=$4  #example  "swift ceph" or "ceph" or "swift" or ""
SERIAL_NUM=`ansible ${PXE_IP} -m shell -a "dmidecode -s system-serial-number"|tail -1`
echo "${SERIAL_NUM} ${HOSTNAME} ${ADMIN_IP} ${STORAGE}" >>/root/tools/etc/pre_deploy/plan_table
cat /root/tools/etc/pre_deploy/plan_table
