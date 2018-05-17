#!/bin/bash
set -o xtrace
cat << EOF > /etc/kolla/config/swift/proxy-server.conf
[filter:authtoken]
delay_auth_decision = True
EOF
