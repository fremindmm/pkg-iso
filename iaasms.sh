#!/bin/bash
set -o xtrace
#set -e 

docker rm -f nginx
docker rm -f iaasms
docker rm -f redis
version="rc2"
db_host="192.168.72.4"
db_user="root"
db_pswd="RJohgYEIZRny1FmU0D3SnQkAEMW7DxpN6oB3MzvZ"
db_name="iaasms_test"
OPS_IP="192.168.72.25"

# prepare file
mkdir -p /data/html/{conf.d,www}
#for i in iaasms.tar.gz ui-iaasms.tar.gz;do
#  if [ ! -e $i ];then
#    echo "下载文件：$i"
#    curl -O https://dl.yihecloud.com/release/$version/iaasms/$i
#  fi
#done
iaasms_image=$(docker load < iaasms.tar.gz|sed  "s/Loaded image://g"|grep iaasms)
echo "==> load: $iaasms_image"
docker pull redis:3.2
docker pull nginx:stable
tar zvxf ui-iaasms.tar.gz -C /data/html/www 

# run nginx
if [ ! -f /data/html/conf.d/iaasms.conf ];then
  cat <<EOF >/data/html/conf.d/iaasms.conf
server {
    listen 80;
    listen 81; # slave 81
    server_name cloudos.service.ob.local;
    client_max_body_size 0m;
    
    gzip on;
    gzip_min_length 1k;
    gzip_buffers 4 16k;
    gzip_comp_level 2;
    gzip_types text/plain application/x-javascript text/css application/xml text/javascript application/javascript application/json;
    gzip_vary off;
    gzip_disable "MSIE [1-6]\.";
    
    # ui static
    root /data/html/www;
    location / {
        rewrite ^/\$ /ui/iaas permanent;
    }

    location ~ ^/ui/([^\/]+) {
        try_files \$uri \$uri/ /ui/\$1/index.html =404;
    }

    location /iaasms {
        proxy_pass   http://${OPS_IP}:1213;
        proxy_set_header        Host \$http_host;
        proxy_set_header        X-Real-IP \$remote_addr;
        proxy_set_header        X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Port \$server_port;
        proxy_set_header        X-Forwarded-Proto \$scheme;
    }
}
EOF
fi

docker run -dti --restart=always --net=host --name nginx \
  -v /data/html/conf.d:/etc/nginx/conf.d \
  -v /data/html/www:/data/html/www \
  nginx:stable 

# run redis
docker run -dti --restart=always --net=host --name redis \
  -v /etc/localtime:/etc/localtime \
  -v /data/redis:/var/lib/redis \
  redis:3.2 redis-server --appendonly yes

#  -v /etc/localtime:/etc/localtime \
# run iaasms
docker run -dti --restart=always --net=host --name iaasms \
  -e DB_HOST="$db_host" \
  -e DB_USER=$db_user \
  -e DB_PSWD=$db_pswd \
  -e DB_NAME="$db_name" \
  -e DB_PORT="3306" \
  -e IAASMS_HOST=localhost \
  -e IAASMS_PORT="1213" \
  -e CACHE_TYPE="redis" \
  -e REDIS_HOSTS="['127.0.0.1:6379']" \
  -e REDIS_PSWD="none" \
  -e DEFAULT_IAAS="false" \
  -e IAAS_TYPE="OpenStack" \
  -e IAAS_HOST="127.0.0.1" \
  -e ADMIN_PW="admin" \
  -e CEPH_ENABLED="false" \
  $iaasms_image
