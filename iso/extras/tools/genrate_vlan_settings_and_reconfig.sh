#!/bin/bash
set -o xtrace
###set br ,port
VLAN_CARD=`cat /root/tools/etc/pre_deploy/global.yml |grep tm_vlan_card_name|awk -F'"' '{print $2}'`
ansible node -m script -a "/root/tools/enable_vlan.sh ${VLAN_CARD}"
###settings
mkdir -p /etc/kolla/config/neutron
cat << EOF >> /etc/kolla/config/neutron/ml2_conf.ini
[ovs]
bridge_mappings = physnet1:br-ex,default:br-eth1
[ml2_type_vlan]
network_vlan_ranges = default:84:84 
EOF
###reconfig
kolla-ansible reconfigure -i /root/multinode -t neutron
