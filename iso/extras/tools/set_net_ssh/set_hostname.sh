#!/bin/bash
# Creating id_rsa.pub
#ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa << EOF
#
#EOF
#echo /n

# Set the hostname depends on the serial number 
# VmWare Vsphere virtual machine use the next config.
#SERIAL_NUMBER=`dmidecode -s system-serial-number | tr -d " " | tr -d '-' | cut -b 7-38`
# Physical Machine use the next config.
SERIAL_NUMBER=`dmidecode -s system-serial-number`
HOST_NAME=`cat /tmp/plan_table|grep "$SERIAL_NUMBER"|awk '{print $2}'`

if [[ $HOST_NAME ]] ; then 
   hostnamectl set-hostname $HOST_NAME ; 
else
   echo "##########################"
   echo "HOST NAME  NOT FOUND"
   exit 0
fi
# rm -rf /tmp/sn_ip.file
# rm -rf /tmp/init_config.sh
#cat /tmp/authorized_keys >> /root/.ssh/authorized_keys
