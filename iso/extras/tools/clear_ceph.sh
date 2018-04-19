#!/bin/bash
set -o xtrace
set -e
DISK_LIST=$*
for dev in ${DISK_LIST}
     do
     echo $dev
     dd if=/dev/zero of=/dev/$dev bs=1M count=10240
     done
