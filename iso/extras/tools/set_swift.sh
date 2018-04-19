#!/bin/bash
set -o xtrace
set -e
#*************settings need to be set first******************
#set swift node list
#cat << EOF >> /etc/ansible/hosts
#[swift]
#control01
#control02
#EOF

SWIFT_NODE_ONE_HOSTNAME=control01
DISK_LIST="sdc"
STORAGE_NETWORK_IP_LIST="192.168.96.3 192.168.96.5"
#*************settings need to be set first******************

#clear disk reinit
ansible swift -m script -a "/root/tools/clear_swift.sh ${DISK_LIST}"
rm -rf /etc/kolla/config/swift 

#init disk ,genarte rings and copy settings
ansible swift -m script -a "/root/tools/swift_add_label.sh ${DISK_LIST}"
ansible swift -m script -a "/root/tools/swift_rings.sh ${STORAGE_NETWORK_IP_LIST}"
mkdir -p /etc/kolla/config
scp -r ${SWIFT_NODE_ONE_HOSTNAME}:/etc/kolla/config/swift /etc/kolla/config/
