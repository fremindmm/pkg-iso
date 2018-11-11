#!/bin/bash
set -o xtrace
source /etc/kolla/admin-openrc.sh
LIST="nova cinder glance neutron swift placement"
for i in $LIST
do
    openstack role add --project service --user $i admin
done
