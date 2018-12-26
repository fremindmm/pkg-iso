#!/bin/bash
echo "Creating a fstab backup..."
ansible ceph -m shell -a "sudo cp /etc/fstab /etc/fstab_backup"

echo "Removing ceph references from fstab..."
ansible ceph -m shell -a "sudo sed -i '/\/var\/lib\/ceph\/osd\//d' /etc/fstab"

echo "rm meph mon osd rgw dir"
ansible node -m shell -a "rm -rf /etc/kolla/ceph-mon"
ansible node -m shell -a "rm -rf /etc/kolla/ceph-osd"
ansible node -m shell -a "rm -rf /etc/kolla/ceph-rgw"

echo "rm docker volume ceph_mon_config coph_mon  only for control node other node error can be ignore"
ansible node -m shell -a "docker volume rm ceph_mon_config"
ansible node -m shell -a "docker volume rm ceph_mon"
