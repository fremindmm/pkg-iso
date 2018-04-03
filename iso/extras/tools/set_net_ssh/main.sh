#!/usr/bin/env bash
# Config tmp ansible inventory. 
set -o xtrace
set -e
mkdir -p /etc/ansible
echo "[pxe]" > /etc/ansible/hosts
docker start cobbler 
function pxe_set(){
   if [ "$1" = "start" ];then
       docker exec -u root cobbler sed -i 's/default=0/default=1/g' /etc/cobbler/pxe/efidefault.template
       docker exec -u root cobbler mv /etc/cobbler/pxe/pxedefault.template_start /etc/cobbler/pxe/pxedefault.template
       docker restart cobbler
   else
       docker exec -u root cobbler sed -i 's/default=1/default=0/g' /etc/cobbler/pxe/efidefault.template
       docker exec -u root cobbler mv /etc/cobbler/pxe/pxedefault.template_stop /etc/cobbler/pxe/pxedefault.template
       docker restart cobbler
   fi
}
pxe_set start
docker exec -it cobbler cat /var/lib/dhcpd/dhcpd.leases |grep '^lease'| cut -d' ' -f2| sort -u|xargs -I {} echo {} >> /etc/ansible/hosts
pxe_set stop 
cat /etc/ansible/hosts | grep -v ^[[]
# Add fingreprint on deploy node.
#ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa << EOF
# 
#EOF
for host in `cat /etc/ansible/hosts | grep -v ^[[]`;do ssh-keyscan -t ecdsa  $host >> /root/.ssh/known_hosts ; done

# Config add_hosts
cat sn_ip.file |awk '{print $3"    "$2}' > ./add_hosts
cat ./add_hosts >> /etc/hosts

# Config ansible default inventory.
echo "[node]" >> /etc/ansible/hosts
cat ./sn_ip.file |awk '{print $2}' >> /etc/ansible/hosts

# Create id_rsa.pub on deploy node.
#ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa << EOF
# 
#EOF
# Add fingerprint on deploy node
#for host in `cat /tmp/sn_ip.file |awk '{print $2}'`;do ssh-keyscan -t ecdsa  $host >> /root/.ssh/known_hosts ; done
#for host in `cat /tmp/sn_ip.file |awk '{print $3}'`;do ssh-keyscan -t ecdsa  $host >> /root/.ssh/known_hosts ; done
