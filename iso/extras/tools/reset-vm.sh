#!/bin/bash
set -o xtrace
VM_NAME=$1
source /etc/kolla/admin-openrc.sh

if [ -n "${VM_NAME}" ];then
nova list |grep ${VM_NAME} |awk -F'|' '{print $2}'|xargs nova reset-state --active
nova reboot --hard ${VM_NAME}
else 
nova list |grep -E "powering-off"|awk -F'|' '{print $2}' > /tmp/vmlist
nova list |grep -E "powering-off"|awk -F'|' '{print $2}' |xargs nova reset-state --active
cat /tmp/vmlist|xargs nova reboot --hard
fi
