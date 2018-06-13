#!/bin/bash
mkdir -p /etc/ansible/
cat << EOF > /etc/ansible/ansible.cfg
[defaults]
host_key_checking=False
pipelining=True
forks=100
EOF
