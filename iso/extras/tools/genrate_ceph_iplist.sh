#!/bin/bash
set -o xtrace
PLAN_TABLE=/root/tools/etc/pre_deploy/plan_table
# Config ansible default inventory.
IS_VMWARE=`dmidecode -s system-serial-number|grep VMware`
echo "[ceph]" >> /etc/ansible/hosts
if [ -n "${IS_VMWARE}" ];then
cat ${PLAN_TABLE}|grep ceph|awk -F' ' '{print $16}' >> /etc/ansible/hosts
else
cat ${PLAN_TABLE}|grep ceph|awk -F' ' '{print $2}' >> /etc/ansible/hosts
fi
