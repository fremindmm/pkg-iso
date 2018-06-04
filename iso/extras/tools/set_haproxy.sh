#!/bin/bash
set -o xtrace
cat <<EOF |tee /tmp/haproxy.sh
IS_SERVER_SET=\`grep "server 6h" /etc/kolla/haproxy/haproxy.cfg\`
if [ -z "\${IS_SERVER_SET}" ];then
    sed -i -e '/glance_api/a\  timeout server 6h' /etc/kolla/haproxy/haproxy.cfg && docker stop haproxy && docker start haproxy
fi
IS_CLIENT_SET=\`grep "client 6h" /etc/kolla/haproxy/haproxy.cfg\`
if [ -z "\${IS_CLIENT_SET}" ];then
    sed -i -e '/glance_api/a\  timeout client 6h' /etc/kolla/haproxy/haproxy.cfg && docker stop haproxy && docker start haproxy
fi
EOF
chmod 750 /tmp/haproxy.sh

function set_haproxy(){
    if [ -f "/root/multinode" ];then
        ansible all -i /root/multinode -m script -a "/tmp/haproxy.sh"
    else
        bash /tmp/haproxy.sh
    fi
}

set_haproxy
