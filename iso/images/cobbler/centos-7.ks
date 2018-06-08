#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Install OS instead of upgrade
install
# Keyboard layouts
keyboard 'us'
# Root password
rootpw --iscrypted $6$p2kJBD5OWSvXGhe7$TqvszSa2BkAQIZpG4yoYwdUXXMmh3mRbn9QGvGbr2pajDei.HYtVbPVu7ulDVre44bdgiw8sayUmflOEDwHz81
# System timezone
timezone Asia/Shanghai
# System language
lang en_US
# Firewall configuration
firewall --disabled
# System authorization information
auth  --useshadow  --passalgo=sha512
# Use CDROM installation media
url --url=$tree
# Use text mode install
text
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# Reboot after installation
reboot --eject

%include /tmp/part-include

%packages
@^minimal
@core
net-tools
vim-enhanced
docker-engine
python-docker-py
gcc
python-devel
python-pip
libffi-devel
openssl-devel
python-openstackclient
python-neutronclient
python2-heatclient
python2-ironicclient
wget
hdparm
sdparm
qemu-img
ntpdate
ntp
dstat
git
sshpass
sysstat
nethogs
iperf
iperf3
tcpdump
ipmitool
MySQL-python
mariadb                                                                                                                                                                  
telnet
python2-shaker
screen
tmux
python-tooz                                                                                                                                                              
python2-PyMySQL
%end
%pre
#!/bin/sh
u=`blkid | grep Ocata | cut -d: -f1`
for i in `ls /sys/block/ | grep -P "(vd|sd|hd)"`; do
    [[ $u =~ $i ]] && continue
    devices="$devices $i"
done
set $devices
if [[ $# -eq 1 ]]; then
    device=$1
fi
exec < /dev/tty3 > /dev/tty3 2>&1
chvt 3
while [[ -z $device ]]; do
    clear
    echo "Detect multiple disks:$devices"
    read -p "Which disk do you want to install system: " device
    for i in $devices; do
        if [[ $device = $i ]]; then
            break 2
        fi
    done
done
devicesize=`cat "/sys/block/$device/size"`
if [[ $devicesize -lt 419430400 ]]; then
    clear
    echo "Selected disk $device is less then 200G, install failed. "
    echo ""
    read -p "Click keyboard to reboot: "
    reboot
fi
chvt 1
btrfs=`grep btrfs /proc/cmdline`
cat > /tmp/part-include << EOF
ignoredisk --only-use=$device
bootloader --location=mbr --driveorder=$device
zerombr
clearpart --all --drives=$device
part /boot
part /boot/efi
EOF
if [[ -z $btrfs ]]; then
echo "part pv.01 --grow" >> /tmp/part-include
echo "volgroup centos pv.01" >> /tmp/part-include
echo "logvol / --vgname=centos --size=90000 --name=root" >> /tmp/part-include
echo "logvol none --vgname=centos --size=90000 --thinpool --name=docker --metadatasize=512 --chunksize=512" >> /tmp/part-include
echo "logvol /var --fstype="xfs" --percent=100 --vgname=centos --name=nova-compu
te" >> /tmp/part-include
else
echo "part btrfs.99 --size=90000 --fstype=btrfs" >> /tmp/part-include
echo "btrfs none --label=c7 btrfs.99" >> /tmp/part-include
echo "btrfs / --subvol --name=root LABEL=c7" >> /tmp/part-include
fi
%end
%post
mkdir -p /etc/systemd/system/docker.service.d
tee /etc/systemd/system/docker.service.d/kolla.conf <<-'EOF'
[Service]
MountFlags=shared
EOF
btrfs=`grep btrfs /proc/cmdline`
mkdir /etc/docker
if [[ -z $btrfs ]]; then
tee /etc/docker/daemon.json <<-'EOF'
{
  "insecure-registries": ["0.0.0.0/0"],
  "storage-driver": "devicemapper",
  "storage-opts": [
    "dm.thinpooldev=/dev/mapper/centos-docker",
    "dm.use_deferred_removal=true",
    "dm.use_deferred_deletion=true"
  ],
  "log-opts": {
    "max-size": "20m",
    "max-file": "5"
  }
}
EOF
tee /etc/lvm/profile/docker-thinpool.profile <<-'EOF'
activation {
    thin_pool_autoextend_threshold=80
    thin_pool_autoextend_percent=20
}
EOF
lvchange --metadataprofile docker-thinpool centos/docker                                                                                                                
echo "ExecStartPre=/usr/sbin/lvchange -ay /dev/centos/docker" >> /etc/systemd/system/docker.service.d/kolla.conf
else
tee /etc/docker/daemon.json <<-'EOF'
{
  "insecure-registries": ["0.0.0.0/0"],
  "log-opts": {
    "max-size": "20m",
    "max-file": "5"
  }                                                                                                                                                                      
}
EOF
fi
systemctl disable postfix
systemctl disable NetworkManager
systemctl disable chronyd                                                                                                                                                
systemctl enable docker
echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
echo -e "* soft nofile 65535\n* hard nofile 65535" >> /etc/security/limits.conf
echo "nameserver 114.114.114.114" >> /etc/resolv.conf
echo "UseDNS no" >> /etc/ssh/sshd_config
mkdir /root/.ssh
curl -o /root/.ssh/authorized_keys http://$http_server/cblr/pub/id_rsa.pub > /dev/null 2>&1
[[ -n $name ]] && curl http://$http_server/cblr/svc/op/nopxe/system/$name
rm -f /tmp/*
%end
