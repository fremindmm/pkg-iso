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
TAG="4.0.4"

ISO_DIR=${CURRENT_DIR}/iso
TARGET_FILE="CentOS-Ocata-x86_64.iso"
FTP_URL=ftp://ftp.openstack-ci.com/images
echo ${ISO_DIR}

TARGET_DIR="/root/jenkins/target_registry"
KOLLA_ANSIBLE_DIR="/root/jenkins/kolla-ansible"

date=`date +"%Y%m%d"`

#rm -f ${MAKEISO_DIR}/extras/centos-source-ocata-inspur.tar.gz
cp -L ${TARGET_DIR}/latest ${MAKEISO_DIR}/extras/docker-registry.tar.gz

#pull kolla-ansible and update to iso
cd ${KOLLA_ANSIBLE_DIR}
git pull
rm -rf ${KOLLA_ANSIBLE_DIR}/dist/
python setup.py  sdist
cp -f ${KOLLA_ANSIBLE_DIR}/dist/*  ${MAKEISO_DIR}/extras/kolla-ansible-4.0.4.dev17.tar.gz

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
mv $TARGET_FILE  CentOS-Ocata-x86_64-${TAG}-${date}.iso


##upload iso to ftp##
#ftp -vpn <<!
#open 100.2.30.3
#user administrator 123456a?
#cd openstack_ocata_iso/cicd_iso
#bin
#put CentOS-Ocata-x86_64-${TAG}-${date}-jilin.iso
#close
#bye
#!

