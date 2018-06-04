#!/bin/bash
set -o xtrace

SWAP_SIZE=8192
function auto_swap_size(){
    phy_mem=`free -m |grep "Mem"|awk -F' ' '{print $2}'`
    if [ $phy_mem -ge 4095 -a $phy_mem -lt 16384 ];then
        SWAP_SIZE=8192
    elif [ $phy_mem -ge 16384 -a $phy_mem -lt 65536 ];then
        SWAP_SIZE=16384
    elif [ $phy_mem -ge 65536 ];then
        SWAP_SIZE=32768
    else
        SWAP_SIZE=8192
    fi
}



function setup_swap(){
    if [ ! -f /swapfile ]; then
        sudo swapoff -a
        sudo dd if=/dev/zero of=/swapfile bs=1M count=$1
        sudo chmod 0600 /swapfile
        sudo mkswap /swapfile
        sudo /sbin/swapon /swapfile
        sudo echo "/swapfile          swap                 swap    defaults 0 0">>/etc/fstab
    fi
}
setup_swap $SWAP_SIZE
