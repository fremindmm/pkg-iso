#!/bin/bash
set -o xtrace
PLAN_TABLE=/root/tools/etc/pre_deploy/plan_table
# Config ansible default inventory.
echo "[ceph]" >> /etc/ansible/hosts
cat ${PLAN_TABLE}|grep ceph|awk -F' ' '{print $2}' >> /etc/ansible/hosts
