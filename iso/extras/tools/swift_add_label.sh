index=0
DISK_LIST=(sde sdf sdg)
for d in ${DISK_LIST[@]}; do
   parted /dev/${d} -s -- mklabel gpt mkpart KOLLA_SWIFT_DATA 1 -1
   sudo mkfs.xfs -f -L d${index} /dev/${d}1
   (( index++ ))
done
