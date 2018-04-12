#!/bin/bash
set -o xtrace
set -e
for dev in sde sdf sdg
     do
     echo $dev
     dd if=/dev/zero of=/dev/$dev bs=1M count=1024
     done
