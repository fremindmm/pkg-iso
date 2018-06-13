#!/bin/bash
PXE_IP=$1
sed -i /${PXE_IP}/d /root/tools/ansible/inventory/default 
cat /root/tools/ansible/inventory/default
