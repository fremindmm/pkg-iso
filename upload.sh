#!/bin/bash
FILE=*.pdf
#FILE=/root/src/make-iso/mkiso/*.iso
#upload iso to ftp##
ftp -vpn <<!
open dl.yihecloud.com
user ftp ftp
cd iaasos/
bin
put $FILE
close
bye
!
