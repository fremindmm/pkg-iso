#!/bin/bash
set -o xtrace

function clean(){
docker rm -f cobbler
#docker rmi cobbler:1.0

}
function run(){
docker run -d --net=host --name cobbler -v /repo:/repo cobbler:1.0
sleep 120
docker cp /root/.ssh/id_rsa.pub cobbler:/var/www/cobbler/pub/
docker exec cobbler cobbler import --name=CentOS-7 --path=/repo/ --kickstart=/var/lib/cobbler/kickstarts/centos-7.ks
#set all netcard is eth*
docker exec cobbler cobbler profile edit --name=CentOS-7-x86_64 --kopts='net.ifnames=0 biosdevname=0'
}
##for dev test cobbler image
clean
run

