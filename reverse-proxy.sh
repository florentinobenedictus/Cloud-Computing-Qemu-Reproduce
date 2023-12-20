#!/bin/bash

#mesin1
apt update
apt install nginx &
wait

cat <<EOL > /etc/nginx/sites-available/reverse-proxy
server {
    listen 14997;
    server_name localhost;

    location / {
        proxy_pass http://10.107.25.5:9999;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 14998;
    server_name localhost;

    location / {
        proxy_pass http://10.107.25.6:9999;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 14999;
    server_name localhost;

    location / {
        proxy_pass http://10.107.25.5:10000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 15000;
    server_name localhost;

    location / {
        proxy_pass http://10.107.25.6:10000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOL

ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/

service nginx reload
service nginx restart
