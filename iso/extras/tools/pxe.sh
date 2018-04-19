#!/bin/bash
set -o xtrace
function pxe_set(){
   if [ "$1" = "start" ];then
       docker exec -u root cobbler sed -i 's/default=0/default=1/g' /etc/cobbler/pxe/efidefault.template
       docker exec -u root cobbler cp /etc/cobbler/pxe/pxedefault.template_start /etc/cobbler/pxe/pxedefault.template
       docker restart cobbler
   else
       docker exec -u root cobbler sed -i 's/default=1/default=0/g' /etc/cobbler/pxe/efidefault.template
       docker exec -u root cobbler cp /etc/cobbler/pxe/pxedefault.template_stop /etc/cobbler/pxe/pxedefault.template
       docker restart cobbler
   fi
}
#pxe [start, stop]
pxe_set $1
