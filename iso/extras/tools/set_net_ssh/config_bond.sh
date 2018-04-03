#!/usr/bin/env bash
# Network config direction.
CONFIG_DIR=/etc/sysconfig/network-scripts/
#mkdir -p $CONFIG_DIR
# The num of bond.
BOND_NUM=`cat /tmp/network.info |grep -v ^#|wc -l`

# Get the ipaddr_suffix depends on serial_number.
# VmWare Vsphere virtual machine use the next config.
SERIAL_NUMBER=`dmidecode -s system-serial-number | tr -d " " | tr -d '-' | cut -b 7-38`
# Physical Machine use the next config.
#SERIAL_NUMBER=`dmidecode -s system-serial-number`

IPADDR_SUFFIX=`cat /tmp/sn_ip.file |grep $SERIAL_NUMBER | awk -F'.' '{print $4}'`
echo $SERIAL_NUMBER
echo $IPADDR_SUFFIX
# Create the config files for every bond.
for i in `seq  $BOND_NUM`;
do
  INTERFACE01=`cat /tmp/network.info |grep -v ^#|sed -n "${i}p"|awk '{print $1}'`
  INTERFACE02=`cat /tmp/network.info |grep -v ^#|sed -n "${i}p"|awk '{print $2}'`
  BOND_NAME=`cat /tmp/network.info |grep -v ^#|sed -n "${i}p"|awk '{print $3}'`
  IPADDR_PREFIX=`cat /tmp/network.info |grep -v ^#|sed -n "${i}p"|awk '{print $4}'`
  GATEWAY=`cat /tmp/network.info |grep -v ^#|sed -n "${i}p"|awk '{print $5}'`

cat > $CONFIG_DIR/ifcfg-$INTERFACE01 << EOF
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=none
SLAVE=yes
EOF

DEVICE_NAME='DEVICE='$INTERFACE01
MASTER_NAME='MASTER='$BOND_NAME

sed -i "1s/^/$DEVICE_NAME \n/" $CONFIG_DIR/ifcfg-$INTERFACE01
sed -i "6s/^/$MASTER_NAME \n/" $CONFIG_DIR/ifcfg-$INTERFACE01

cat > $CONFIG_DIR/ifcfg-$INTERFACE02 << EOF
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=none
SLAVE=yes
EOF

DEVICE_NAME='DEVICE='$INTERFACE02

sed -i "1s/^/$DEVICE_NAME \n/" $CONFIG_DIR/ifcfg-$INTERFACE02
sed -i "6s/^/$MASTER_NAME \n/" $CONFIG_DIR/ifcfg-$INTERFACE02

cat > $CONFIG_DIR/ifcfg-$BOND_NAME << EOF
TYPE=Ethernet
NM_CONTROLLED=no
USERCTL=no
ONBOOT=yes
BOOTPROTO=static
IPV6INIT=no
NETMASK=255.255.255.0
BONDING_OPTS='mode=1 miimon=100'
EOF

DEVICE_NAME='DEVICE='$BOND_NAME
DEVICE_IPADDR='IPADDR='$IPADDR_PREFIX.$IPADDR_SUFFIX
DEVICE_GATEWAY='GATEWAY='$GATEWAY
 
sed -i "1s/^/$DEVICE_NAME \n/" $CONFIG_DIR/ifcfg-$BOND_NAME
if [[ $IPADDR_PREFIX ]]; then
   sed -i "6s/^/$DEVICE_IPADDR \n/" $CONFIG_DIR/ifcfg-$BOND_NAME
fi
if [[ $GATEWAY ]]; then
   sed -i "7s/^/$DEVICE_GATEWAY \n/" $CONFIG_DIR/ifcfg-$BOND_NAME
fi

done

#rm -rf /tmp/config_bond.sh
#rm -rf /tmp/network.info
