#!/bin/bash
#
#This script used for pull iso config modify from gitlab and make iso.
#finally, upload iso to ftp server ftp://100.2.30.4/images/
#Usage: bash iso.sh 
#

set -o xtrace
set -e

CURRENT_DIR=$(readlink -f "$(dirname $0)")
##get father dir##
FARTHER_DIR=${CURRENT_DIR}/..
MAKEISO_DIR=${FARTHER_DIR}/mkiso
echo ${MAKEISO_DIR}
TAG="4.0.2"

ISO_DIR=${CURRENT_DIR}/iso
TARGET_FILE="YiheOS.iso"
FTP_URL=ftp://ftp.openstack-ci.com/images
echo ${ISO_DIR}

TARGET_DIR="/root/jenkins/target_registry"
KOLLA_ANSIBLE_DIR="/root/jenkins/"

date=`date +"%Y%m%d"`

#rm -f ${MAKEISO_DIR}/extras/centos-source-ocata-inspur.tar.gz
cp -L ${TARGET_DIR}/latest ${MAKEISO_DIR}/extras/docker-registry.tar.gz

#pull kolla-ansible and update to iso
#cd ${KOLLA_ANSIBLE_DIR}
#git pull
#set kolla-ansible version
OLD_V=`grep "kolla-ansible" ${MAKEISO_DIR}/images/ks.cfg|awk -F'/' '{print $6}'`

#rm -rf ${KOLLA_ANSIBLE_DIR}/dist/
#python setup.py  sdist 2>&1 >/dev/null
#pkg kolla-ansible source can't packege use /root/jenkins/kolla-ansible-4.0.3.dev36.tar.gz

#NEW_V=`ls /root/jenkins/kolla-ansible/dist`
NEW_V=kolla-ansible-4.0.3.dev36.tar.gz
#cp -f ${KOLLA_ANSIBLE_DIR}/kolla-ansible-4.0.3.dev36.tar.gz  ${MAKEISO_DIR}/extras/
#copy the lastest kolla-ansible pkg
cp -f ${KOLLA_ANSIBLE_DIR}/source/kolla-ansible-4.0.3.dev36/dist/kolla-ansible-4.0.3.dev36.tar.gz  ${MAKEISO_DIR}/extras/

if [ ! "${OLD_V%% *}" = $NEW_V ];then
sed -i  "s/$OLD_V/$NEW_V /g" ${ISO_DIR}/extras/init.sh
sed -i  "s/$OLD_V/$NEW_V /g" ${ISO_DIR}/extras/TRANS.TBL
sed -i  "s/$OLD_V/$NEW_V /g" ${ISO_DIR}/images/ks.cfg
fi

##pull and make iso##
cd ${ISO_DIR}
#git pull
mkdir -p ${MAKEISO_DIR}/extras  ${MAKEISO_DIR}/images  ${MAKEISO_DIR}/isolinux ${MAKEISO_DIR}/EFI
chmod -R a+x .
cp -rf EFI/* ${MAKEISO_DIR}/EFI
cp -rf extras/* ${MAKEISO_DIR}/extras
cp -rf images/* ${MAKEISO_DIR}/images
cp -rf isolinux/* ${MAKEISO_DIR}/isolinux
cp -rf mkiso.sh  ${MAKEISO_DIR}
cd ${MAKEISO_DIR}
bash mkiso.sh
mv $TARGET_FILE  YiheOS-${TAG}-${date}.iso


#upload iso to ftp##
ftp -vpn <<!
open dl.yihecloud.com
user ftp ftp
cd iaasos/
bin
put YiheOS-${TAG}-${date}.iso
close
bye
!

