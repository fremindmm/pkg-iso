#!/bin/bash
set -o xtrace

PXE_CARD_NAME=$1
INIT_CARD=$2

#admin
VLANID=$3
IP_SEGMENT=$4
ADMIN_GATEWAY=$5

#admin ip end is pxe end+0  192.168.93.2 => 192.168.94.2

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
function add_vlan_interface_route(){
    sed -i s/dhcp/none/g /etc/sysconfig/network-scripts/ifcfg-$1
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-$1.$2
DEVICE=$1.$2
BOOTPROTO=none
ONBOOT=yes
IPADDR=$3
PREFIX=24
NETWORK=$4
VLAN=yes
GATEWAY=$5
EOF
}

#pxe ip end segment  add 0 for new admin network ip
pxe_ip_end=`ip a|grep ${PXE_CARD_NAME}|grep inet|awk -F' ' '{print $2}'|awk -F'/' '{print $1}'|awk -F'.' '{print $4}'`
des_ip_end=`expr ${pxe_ip_end} + 0`

#for admin net add route 
if [ -n "${ADMIN_GATEWAY}" ];then
    add_vlan_interface_route ${INIT_CARD} ${VLANID} ${IP_SEGMENT}.${des_ip_end} ${IP_SEGMENT}.0 ${ADMIN_GATEWAY}
else
    add_vlan_interface ${INIT_CARD} ${VLANID} ${IP_SEGMENT}.${des_ip_end} ${IP_SEGMENT}.0
fi

#systemctl restart network &
