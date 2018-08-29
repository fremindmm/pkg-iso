#!/bin/bash
set -o xtrace
INIT_CARD=$1

function set_interface_up(){
    sed -i s/dhcp/none/g /etc/sysconfig/network-scripts/ifcfg-$1
    sed -i s/ONBOOT=no/ONBOOT=yes/g /etc/sysconfig/network-scripts/ifcfg-$1
}
set_interface_up ${INIT_CARD}
cat /etc/sysconfig/network-scripts/ifcfg-$1
