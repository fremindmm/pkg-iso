#!/bin/bash
set -o xtrace
set -e
DISK_LIST=$*
index=0
for d in ${DISK_LIST}; do
   parted /dev/${d} -s -- mklabel gpt mkpart KOLLA_SWIFT_DATA 1 -1
   sudo mkfs.xfs -f -L d${index} /dev/${d}1
   #(( index++ ))
   index=`expr $index + 1`
done
