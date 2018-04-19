#!/bin/bash
set -o xtrace
DIR=/tmp/serial
DES_DIR=/root/tools/etc/pre_deploy
ADMIN_IP_SEGMENT=$1
PXE_IP_SEGMENT=$2
iplist=`ls ${DIR}`
echo ""> ${DES_DIR}/plan_table
for ip in ${iplist};do
    serial=`cat ${DIR}/${ip}|awk -F'\"' '{print $6}'`
    if [ ! -s ${DES_DIR}/plan_table ];then
        ADMIN_IP=`echo $ip|sed "s/$PXE_IP_SEGMENT/$ADMIN_IP_SEGMENT/g"`
        echo ${serial} ${ADMIN_IP}> ${DES_DIR}/plan_table
    else
        ADMIN_IP=`echo $ip|sed "s/$PXE_IP_SEGMENT/$ADMIN_IP_SEGMENT/g"`
        echo ${serial} ${ADMIN_IP}>> ${DES_DIR}/plan_table
    fi
done
