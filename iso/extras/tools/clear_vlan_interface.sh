#!/bin/bash
set -o xtrace
SUB_PORT=$1
cd /etc/sysconfig/network-scripts
if [ -n "${SUB_PORT}" ];then
    ls -la |grep "ifcfg-${SUB_PORT}"|awk -F' ' '{print $9}'|xargs -i cp {} /tmp
    ls -la |grep "ifcfg-${SUB_PORT}"|awk -F' ' '{print $9}'|xargs rm -f
    ip link delete ${SUB_PORT}
else
    ls -la |grep "ifcfg-enp11s0f[1-9]\."|awk -F' ' '{print $9}'|xargs -i cp {} /tmp
    ip a |grep ": enp11s0f[1-9]\."|awk -F':' '{print $2}'|awk -F'@' '{print $1}'|xargs -I {} ip link delete {}
    ls -la |grep "ifcfg-enp11s0f[1-9]\."|awk -F' ' '{print $9}'|xargs rm -f
    ls -la |grep "ifcfg-eth[1-9]\."|awk -F' ' '{print $9}'|xargs -i cp {} /tmp
    ip a |grep ": eth[1-9]\."|awk -F':' '{print $2}'|awk -F'@' '{print $1}'|xargs -I {} ip link delete {}
    ls -la |grep "ifcfg-eth[1-9]\."|awk -F' ' '{print $9}'|xargs rm -f
fi
service network restart
