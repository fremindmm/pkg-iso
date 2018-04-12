#!/bin/bash
set -o xtrace
set -e
for dev in sdb sdc sdd
     do
     echo $dev
     dd if=/dev/zero of=/dev/$dev bs=1M count=10240
     done
