#!/usr/bin/env bash
# Config tmp ansible inventory. 
set -o xtrace
set -e
CARD=$1
PLAN_TABLE=/root/tools/etc/pre_deploy/plan_table
mkdir -p /etc/ansible
echo "[pxe]" > /etc/ansible/hosts

docker exec -i cobbler cat /var/lib/dhcpd/dhcpd.leases |grep '^lease'| cut -d' ' -f2| sort -u|xargs -I {} echo {} >> /etc/ansible/hosts

# Add fingreprint on deploy node.
#ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa << EOF
# 
#EOF
#for host in `cat /etc/ansible/hosts | grep -v ^[[]`;do ssh-keyscan -t ecdsa  $host >> /root/.ssh/known_hosts ; done

# Config /etc/hosts for all node
cat << EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
EOF

cat /etc/ansible/hosts | grep -v ^[[]
cat ${PLAN_TABLE} |awk '{print $3"    "$2}' > ./add_hosts
cat ./add_hosts >> /etc/hosts
DEPLOY_IP=`ip a|grep "$CARD"|grep inet|awk -F' ' '{print $2}'|awk -F'/' '{print $1}'`
echo $DEPLOY_IP `hostname` >> /etc/hosts
# Config ansible default inventory.
echo "[node]" >> /etc/ansible/hosts
cat ${PLAN_TABLE} |awk '{print $2}' >> /etc/ansible/hosts

# Create id_rsa.pub on deploy node.
#ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa << EOF
# 
#EOF
# Add fingerprint on deploy node
#for host in `cat /tmp/sn_ip.file |awk '{print $2}'`;do ssh-keyscan -t ecdsa  $host >> /root/.ssh/known_hosts ; done
#for host in `cat /tmp/sn_ip.file |awk '{print $3}'`;do ssh-keyscan -t ecdsa  $host >> /root/.ssh/known_hosts ; done