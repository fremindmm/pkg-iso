#!/bin/bash
function part_disk_and_extendvg(){
    local DISK=$1
    echo "n
    p
    1
    
    
    w
    " | fdisk /dev/${DISK} && partprobe
    mkfs -t ext3 /dev/${DISK}1
    partx /dev/${DISK}1
    pvdisplay 
    pvcreate /dev/${DISK}1
    vgextend centos /dev/${DISK}1
}

function usage {
   cat <<EOF
Usage: $0 args
args:
   disk
EOF
}
DISK=$1
if [ -n "${DISK}" ];then
    part_disk_and_extendvg ${DISK}
else
    usage
fi
