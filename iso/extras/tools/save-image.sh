#!/bin/bash
DEST=openshift-image.tar
docker images|grep -v REPOSITORY |awk -F' ' '{print $1":"$2}'|grep -v none >images.txt
sed -i ':a;N;s/\n/ /g;ta' ./images.txt
IMAGES=`cat ./images.txt`
echo "docker save $IMAGES -o ./${DEST}"
