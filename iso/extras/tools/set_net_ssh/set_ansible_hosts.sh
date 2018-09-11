#!/usr/bin/env bash
# Config tmp ansible inventory. 
set -o xtrace
set -e
CARD=$1
PLAN_TABLE=/root/tools/etc/pre_deploy/plan_table

if [ ! -f /etc/ansible/pxe_list ];then
mkdir -p /etc/ansible
echo "[pxe]" > /etc/ansible/hosts

docker exec -i cobbler cat /var/lib/dhcpd/dhcpd.leases |grep '^lease'| cut -d' ' -f2| sort -u|xargs -I {} echo {} >> /etc/ansible/hosts
else
cat /etc/ansible/pxe_list >>/etc/ansible/hosts
fi
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

IS_VMWARE=`dmidecode -s system-serial-number|grep VMware`
cat /etc/ansible/hosts | grep -v ^[[]
if [ -n "${IS_VMWARE}" ];then
cat ${PLAN_TABLE} |awk '{print $17"    "$16}' > ./add_hosts
else
cat ${PLAN_TABLE} |awk '{print $3"    "$2}' > ./add_hosts
fi
cat ./add_hosts >> /etc/hosts
DEPLOY_IP=`ip a|grep "$CARD"|grep inet|awk -F' ' '{print $2}'|awk -F'/' '{print $1}'`
echo $DEPLOY_IP `hostname` >> /etc/hosts
# Config ansible default inventory.
echo "[node]" >> /etc/ansible/hosts
if [ -n "${IS_VMWARE}" ];then
cat ${PLAN_TABLE} |awk '{print $16}' >> /etc/ansible/hosts
else
cat ${PLAN_TABLE} |awk '{print $2}' >> /etc/ansible/hosts
fi
# Create id_rsa.pub on deploy node.
#ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa << EOF
# 
#EOF
# Add fingerprint on deploy node
#for host in `cat /tmp/sn_ip.file |awk '{print $2}'`;do ssh-keyscan -t ecdsa  $host >> /root/.ssh/known_hosts ; done
#for host in `cat /tmp/sn_ip.file |awk '{print $3}'`;do ssh-keyscan -t ecdsa  $host >> /root/.ssh/known_hosts ; done
