#!/bin/bash
set -o xtrace
sed -i '/Openstack custom configragtion/, +100d' /root/tools/etc/kolla/globals.yml
cat /root/tools/etc/pre_deploy/global.yml |grep -A 100  "Openstack custom configragtion" >> /root/tools/etc/kolla/globals.yml
