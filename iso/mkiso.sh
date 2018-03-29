#!/bin/bash

set -o xtrace
set -e

tarPath=`pwd`
tarFile="YiheOS.iso"
#tarISO=`readlink -f tarFile`
rm -f YiheOS*.iso
date=`date +"%Y%m%d"`
mkisofs -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e images/efiboot.img -no-emul-boot -R -J -V 'YiheOS'  -o YiheOS.iso . 2>&1 >/dev/null

