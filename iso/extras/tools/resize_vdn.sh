#!/bin/bash
DIR="/data"
DISK="vdb"
FORMART="ext4"
function part_disk_and_init_formart(){
    local DISK=$1
    local DIR=$2
    local FORMART=$3 
    echo "n
    p
    1
    
    
    w
    " | fdisk /dev/${DISK} && partprobe
    mkfs -t ${FORMART} /dev/${DISK}1
}
part_disk_and_init_formart ${DISK} ${DIR} ${FORMART}
mount /dev/${DISK}1 ${DIR}/
df -h
umount /data
df -h
cat << EOF > /etc/fstab
/dev/${DISK}1  ${DIR}  ${FORMART}  defaults  1  2
EOF
mount -a
df -h

