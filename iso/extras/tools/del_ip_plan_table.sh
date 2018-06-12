#!/bin/bash
HOSTNAME=$1
sed -i /${HOSTNAME}/d /root/tools/etc/pre_deploy/plan_table
