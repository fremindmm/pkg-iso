#!/bin/bash
set -o xtrace

function build(){
docker build /root/src/make-iso/pkg-iso/iso -t registry.cn-hangzhou.aliyuncs.com/jeckxie/cobbler:1.0
docker push registry.cn-hangzhou.aliyuncs.com/jeckxie/cobbler:1.0 
}

function clean(){
docker rm -f cobbler
#docker rmi cobbler:1.0

}
function run(){
docker run -d --net=host --name cobbler -v /repo:/repo cobbler:1.0
sleep 60
docker cp /root/.ssh/id_rsa.pub cobbler:/var/www/cobbler/pub/
docker exec cobbler cobbler import --name=CentOS-7 --path=/repo/ --kickstart=/var/lib/cobbler/kickstarts/centos-7.ks
#set all netcard is eth*
docker exec cobbler cobbler profile edit --name=CentOS-7-x86_64 --kopts='net.ifnames=0 biosdevname=0'
}
#docker rmi registry.cn-hangzhou.aliyuncs.com/jeckxie/cobbler:1.0
#docker load < /root/src/make-iso/pkg-iso/iso/extras/cobbler.tar
function tag(){
docker pull registry.cn-hangzhou.aliyuncs.com/jeckxie/cobbler:1.0
docker tag registry.cn-hangzhou.aliyuncs.com/jeckxie/cobbler:1.0 cobbler:1.0
}
#docker run -d --net=host --name cobbler -v /repo:/repo cobbler:1.0
#script
#sed -i 's/CentOS-Ocata-x86_64/YiheOS/g' repo/EFI/BOOT/grub.cfg
#sed -i 's/CentOS-Ocata-x86_64/YiheOS/g' repo/isolinux/isolinux.cfg
#docker exec -u root cobbler cp /etc/cobbler/pxe/pxedefault.template /etc/cobbler/pxe/pxedefault.template_start
#docker cp /root/src/deploy_script/ci/pxedefault.template cobbler:/etc/cobbler/pxe/pxedefault.template_stop
#docker exec -u root cobbler sed -i 's/default=0/default=1/g' /etc/cobbler/pxe/efidefault.template

#docker tag registry.cn-hangzhou.aliyuncs.com/jeckxie/cobbler:1.0 cobbler:1.0
function save_to_pkg(){
docker tag registry.cn-hangzhou.aliyuncs.com/jeckxie/cobbler:1.0 cobbler:1.0
docker save -o /root/src/make-iso/pkg-iso/iso/extras/cobbler.tar cobbler:1.0
}
##for dev test cobbler image
#clean
#run
##for package
build
save_to_pkg

