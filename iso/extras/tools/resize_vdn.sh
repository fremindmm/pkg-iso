#!/bin/bash
DIR="/data"
DISK=$1
FORMART="ext4"
mkdir -p ${DIR}
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
UUID=`blkid|grep ${DISK}1|awk -F' ' '{print $2}'`
cat << EOF >> /etc/fstab
$UUID  ${DIR}  ${FORMART}  defaults  1  2
EOF
mount -a
df -h

