#!/bin/bash
#
#
#
#gen rule file
set -o xtrace
OLD_CARD_NAME=$1
NEW_CARD_NAME=$2
ON_BOOT=$3
MAC_ADDR=`ifconfig "${OLD_CARD_NAME}" |grep ether |awk -F' ' '{print $2}'`

cat >> /etc/udev/rules.d/70-persistent-ipoib.rules <<EOF
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="${MAC_ADDR}", ATTR{type}=="1", KERNEL=="eth*", NAME="${NEW_CARD_NAME}"
EOF

cat /etc/default/grub |grep "biosdevname"
if [ ! $? -eq 0 ];then
    sed -i 's/quiet/quiet net.ifnames=0 biosdevname=0/g' /etc/default/grub
fi

grub2-mkconfig -o /boot/grub2/grub.cfg
rm -f /etc/sysconfig/network-scripts/ifcfg-${OLD_CARD_NAME}
touch /etc/sysconfig/network-scripts/ifcfg-${NEW_CARD_NAME}
cat > /etc/sysconfig/network-scripts/ifcfg-${NEW_CARD_NAME} <<EOF
BOOTPROTO=dhcp
DEVICE=${NEW_CARD_NAME}
ONBOOT=${ON_BOOT}
EOF

#reboot
