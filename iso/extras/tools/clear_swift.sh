#!/bin/bash
set -o xtrace
set -e
DISK_LIST=$*
rm -rf /etc/kolla/config/swift
for dev in ${DISK_LIST};do
     echo $dev
     dd if=/dev/zero of=/dev/$dev bs=1M count=1024
     done
