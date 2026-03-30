#!/bin/bash
set -euxo pipefail

sleep 30

apt-get update -y

echo "===== INSTALL DOCKER ====="
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

docker run -d -p 8000:8000 annettestr/ikea-api:latest

echo "===== INSTALL AND CONFIGURE NGINX ====="
apt-get install -y nginx

cat <<EOT > /etc/nginx/sites-available/default
server {
    listen 80;
    server_name annastr.com;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOT

nginx -t
systemctl restart nginx
systemctl enable nginx

echo "===== INSTALL SSL ====="
apt-get install -y certbot python3-certbot-nginx

echo "===== DONE ====="