#!/bin/bash

DOWN_INTERFACE=`ip a |grep eth |grep "state DOWN"|awk -F':' '{print $2}'`

if [ -n "${DOWN_INTERFACE}" ];then
    echo "interface ${DOWN_INTERFACE} is DOWN"
    exit 1
else
    echo "all interface is ok"
fi

