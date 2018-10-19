#!/bin/bash
PWD=$(dirname $0)
PKG=$2
set -o xtrace
set -e

function offline_pkg_make {
if [ -f ${PWD}/offlinePackage.tar.gz ];then
sudo mv ${PWD}/offlinePackage.tar.gz /tmp/
fi
#sudo apt-get update
#sudo apt-get install dpkg-dev -y
#sudo mv -f /var/cache/apt/archives/* /tmp/
sudo mkdir -p /var/cache/apt/archives
sudo apt-get -d install ${PKG}

sudo mkdir -p ${PWD}/offlinePackage
sudo cp -r /var/cache/apt/archives  ${PWD}/offlinePackage
sudo chmod 777 -R ${PWD}/offlinePackage/
sudo dpkg-scanpackages ${PWD}/offlinePackage/ /dev/null |gzip >${PWD}/offlinePackage/Packages.gz
sudo cp ${PWD}/offlinePackage/Packages.gz ${PWD}/offlinePackage/archives/Packages.gz
sudo tar cvzf offlinePackage.tar.gz ${PWD}/offlinePackage/
}

function install_offline_pkg {
sudo tar -xvf ${PWD}/offlinePackage.tar.gz -C /tmp/
sudo mkdir -p /tmp/offlinePackage/offlinePackage/
sudo cp -rf /tmp/offlinePackage/archives/ /tmp/offlinePackage/offlinePackage/
sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
sudo cp /etc/apt/sources.list.bak /tmp/
sudo touch /etc/apt/sources.list
sudo chmod 0666 /etc/apt/sources.list
sudo cat << EOF > /etc/apt/sources.list 
deb file:///tmp/offlinePackage archives/
EOF
sudo chmod 0644 /etc/apt/sources.list
sudo apt-get update
}
function recover_list {
sudo cp /tmp/sources.list.bak /etc/apt/sources.list
sudo apt-get update
}

function usage {
cat <<EOF
Usage: $0 COMMAND [options]
Options:
   pkg_name
Commands:
   make
   install
Note:
   The software compression package is placed in the same directory as the script.
EOF
}

case "$1" in 
(make)
    offline_pkg_make
    ;;
(install)
    install_offline_pkg
    sudo apt-get install $2
    recover_list
    ;;
(*)    usage
       exit 0
       ;;
esac
