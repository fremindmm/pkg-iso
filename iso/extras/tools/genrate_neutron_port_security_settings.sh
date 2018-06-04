#!/bin/bash
set -o xtrace
mkdir -p /etc/kolla/config/neutron/
cat << EOF > /etc/kolla/config/neutron/ml2_conf.ini
[ml2]
extension_drivers = qos, port_security
EOF
