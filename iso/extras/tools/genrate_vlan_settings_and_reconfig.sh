#!/bin/bash
set -o xtrace
ADD=$1
###set br ,port
VLAN_CARD=`cat /root/tools/etc/pre_deploy/global.yml |grep tm_vlan_card_name|awk -F'"' '{print $2}'`
if [ ! -n $ADD ];then
ansible node -m script -a "/root/tools/enable_vlan.sh ${VLAN_CARD}"
else
ansible pxe -i /root/tools/ansible/inventory/add_list -m script -a "/root/tools/enable_vlan.sh ${VLAN_CARD}"
fi
###settings
IS_EXSIT=`grep -rn ",default:" /etc/kolla/config/neutron/ml2_conf.ini`
if [ ! -n "${IS_EXSIT}" ];then 
mkdir -p /etc/kolla/config/neutron
cat << EOF >> /etc/kolla/config/neutron/ml2_conf.ini
[ovs]
bridge_mappings = physnet1:br-ex,default:br-eth1
[ml2_type_vlan]
network_vlan_ranges = default:84:84 
EOF
fi
###reconfig
kolla-ansible upgrade -i /root/multinode -t neutron
