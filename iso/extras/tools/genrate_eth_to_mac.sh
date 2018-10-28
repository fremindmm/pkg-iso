#!/bin/bash
set -o xtrace
ETH_NUM=`ip a |grep "eth[0-9]:"|wc -l`
mv /usr/lib/udev/rules.d/60-net.rules /usr/lib/udev/rules.d/60-net.rules.bak

for ((i=0; i<"${ETH_NUM}"; i ++))
do
CARD=eth$i
MAC=`ip link show ${CARD}|grep "link\/ethe"|awk -F' ' '{print $2}'`
cat <<EOF>> /usr/lib/udev/rules.d/60-net.rules
ACTION=="add", SUBSYSTEM=="net", DRIVERS=="?*", ATTR{type}=="1", \
       ATTR{address}=="${MAC}", NAME="${CARD}"
EOF
done





