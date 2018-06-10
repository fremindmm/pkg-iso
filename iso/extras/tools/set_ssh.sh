#!/bin/bash
set -o xtrace
if [ ! -d ~/.ssh/sockets ];then
    mkdir ~/.ssh/sockets
fi
cat << EOF > ~/.ssh/config
Host *
  Compression yes
  ServerAliveInterval 60
  ServerAliveCountMax 5
  ControlMaster auto
  ControlPath ~/.ssh/sockets/%r@%h-%p
  ControlPersist 4h
EOF
