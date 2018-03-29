#!/bin/bash
set -x
sed -i '$d' /etc/rc.d/rc.local
systemctl start docker; sleep 3
docker load < /root/cobbler.tar
docker run -d --net=host --name cobbler -v /repo:/repo cobbler:1.0
sleep 60
docker cp /root/.ssh/id_rsa.pub cobbler:/var/www/cobbler/pub/
docker exec cobbler cobbler import --name=CentOS-7 --path=/repo/ --kickstart=/var/lib/cobbler/kickstarts/centos-7.ks
#docker exec cobbler cobbler profile edit --name CentOS-7-x86_64 --kopts 'ipaddr=10.99.0.3:255.255.255.0:10.99.0.1:control02'
#docker exec cobbler cobbler profile add --name CentOS-7.a-x86_64 --distro CentOS-7-x86_64 --kickstart /var/lib/cobbler/kickstarts/centos-7.a.ks --enable-menu=false
mkdir /registry
tar -zxf /root/docker-registry.tar.gz -C /registry
docker load < /root/registry.tar
docker run -d -p 4000:5000 --restart=always --name registry -v /registry/:/var/lib/registry registry
tar -zxf /root/kolla-ansible-4.0.4.dev19.tar.gz -C /opt
pip install --no-index --find-links=http://127.0.0.1:81/pypi pbr
pip install --no-index --find-links=http://127.0.0.1:81/pypi ansible
pip install --no-index --find-links=http://127.0.0.1:81/pypi zabbix-api
pip install --no-index --find-links=http://127.0.0.1:81/pypi shade
pip install --no-index --find-links=http://127.0.0.1:81/pypi pywinrm
pip install --no-index --find-links=http://127.0.0.1:81/pypi elasticsearch
pip install --no-index --find-links=http://127.0.0.1:81/pypi -r /opt/kolla-ansible*/requirements.txt
cp -r /opt/kolla-ansible*/etc/kolla /etc
sed -i -e "s/eth0/$(ip -o link | cut -d: -f2 | sed -n 's/ //;2p')/" -e "s/eth1/$(ip -o link | cut -d: -f2 | sed -n 's/ //;3p')/" -e "s/10.10.10.254/$(cat /etc/hosts | cut -d' ' -f1 | tail -n1)/" -e "s/172.16.0.10/$(cat /etc/hosts | cut -d' ' -f1 | tail -n1)/" /etc/kolla/globals.yml
/opt/kolla-ansible*/tools/generate_passwords.py 
rm -rf /root/* /tmp/*
mv /opt/kolla-ansible* /root
