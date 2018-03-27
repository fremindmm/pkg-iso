#!/bin/bash

set -o xtrace
set -e

tarPath=`pwd`
tarFile="CentOS-Ocata-x86_64.iso"
#tarISO=`readlink -f tarFile`
rm -f CentOS-Ocata-x86_64*.iso
date=`date +"%Y%m%d"`
mkisofs -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e images/efiboot.img -no-emul-boot -R -J -V 'CentOS-Ocata-x86_64'  -o CentOS-Ocata-x86_64.iso .

