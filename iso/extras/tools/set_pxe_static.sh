#!/bin/bash
set -o xtrace

CARD=$1
CURRENT_DIR=$(readlink -f "$(dirname $0)")
IP=`ip a|grep "$1"|grep inet|awk -F' ' '{print $2}'|awk -F'/' '{print $1}'`
GATEWAY=$2
if [[ -n $GATEWAY ]];then
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-$CARD 
DEVICE=$CARD
BOOTPROTO=static
IPADDR=$IP
PREFIX=24
ONBOOT=yes
GATEWAY=$GATEWAY
EOF
else
   cat << EOF > /etc/sysconfig/network-scripts/ifcfg-$CARD 
DEVICE=$CARD
BOOTPROTO=static
IPADDR=$IP
PREFIX=24
ONBOOT=yes
EOF
fi
#service network restart
