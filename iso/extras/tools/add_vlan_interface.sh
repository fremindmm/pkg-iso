#!/bin/bash
set -o xtrace

PXE_CARD_NAME=enp11s0f0
INIT_CARD=enp11s0f1
VLANID1=1000
IP_SEGMENT1=192.168.93
VLANID2=1001
IP_SEGMENT2=192.168.94
VLANID3=1002
IP_SEGMENT3=192.168.95
VLANID4=1003
IP_SEGMENT4=192.168.96

function add_vlan_interface(){
    sed -i s/dhcp/none/g /etc/sysconfig/network-scripts/ifcfg-$1
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-$1.$2
DEVICE=$1.$2
BOOTPROTO=none
ONBOOT=yes
IPADDR=$3
PREFIX=24
NETWORK=$4
VLAN=yes
EOF
}

#pxe ip end segment  add 100 for new admin network ip
pxe_ip_end=`ip a|grep ${PXE_CARD_NAME}|grep inet|awk -F' ' '{print $2}'|awk -F'/' '{print $1}'|awk -F'.' '{print $4}'`
des_ip_end=`expr ${pxe_ip_end} + 100`

add_vlan_interface ${INIT_CARD} ${VLANID1} ${IP_SEGMENT1}.${des_ip_end} ${IP_SEGMENT1}.0
add_vlan_interface ${INIT_CARD} ${VLANID2} ${IP_SEGMENT2}.${des_ip_end} ${IP_SEGMENT2}.0
add_vlan_interface ${INIT_CARD} ${VLANID3} ${IP_SEGMENT3}.${des_ip_end} ${IP_SEGMENT3}.0
add_vlan_interface ${INIT_CARD} ${VLANID4} ${IP_SEGMENT4}.${des_ip_end} ${IP_SEGMENT4}.0
systemctl restart network
