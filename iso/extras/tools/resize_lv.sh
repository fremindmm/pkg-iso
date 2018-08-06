#!/bin/bash
set -e
set -o xtrace
LV_PATH_KEY_STRING=$1

function lvextend_and_xfs_growfs(){
    local LV_PATH_KEY_STRING=$1
    df -h |grep ${LV_PATH_KEY_STRING}
    LV_PATH=`lvdisplay |grep "LV Path"|awk -F' ' '{print $3}'|grep ${LV_PATH_KEY_STRING}`
    lvextend -l +100%FREE ${LV_PATH}
    #lvextend -L +1G ${LV_PATH}
    xfs_growfs ${LV_PATH}
    df -h |grep ${LV_PATH_KEY_STRING}
}

function usage {
   cat <<EOF
Usage: $0 args
args:
   LV PATH KEY STRING
EOF
}

if [ -n "${LV_PATH_KEY_STRING}" ];then
lvextend_and_xfs_growfs ${LV_PATH_KEY_STRING}
else
usage
fi
