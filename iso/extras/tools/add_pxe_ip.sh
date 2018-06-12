#!/bin/bash
set -o xtrace
PXE_IP=$1
sed  -i /pxe/a\\${PXE_IP} /root/tools/ansible/inventory/default 
cat /root/tools/ansible/inventory/default
