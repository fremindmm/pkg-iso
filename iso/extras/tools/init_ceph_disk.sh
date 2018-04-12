#!/bin/bash
set -o xtrace
parted /dev/$1 -s -- mklabel gpt mkpart KOLLA_CEPH_OSD_BOOTSTRAP 1 -1
fdisk -l /dev/$1
