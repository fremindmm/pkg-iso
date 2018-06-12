#!/bin/bash
set -o xtrace
HOSTNAME=$1

echo $HOSTNAME |grep compute
if [ $? -eq 0 ];then
    sed -i '/\[compute\]/a'${HOSTNAME}'' /root/tools/etc/pre_deploy/multinode
fi
echo $HOSTNAME |grep control
if [ $? -eq 0 ];then
    sed  -i '/\[control\]/a'${HOSTNAME}'' /root/tools/etc/pre_deploy/multinode
fi
echo $HOSTNAME |grep storage
if [ $? -eq 0 ];then
    sed  -i '/\[storage\]/a'${HOSTNAME}'' /root/tools/etc/pre_deploy/multinode
fi
cat /root/tools/etc/pre_deploy/multinode |head -30
