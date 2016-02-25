#!/bin/bash

NGINX_VIRTUAL_FILE=/etc/nginx/conf.d/virtual.conf
NGINX_PASSWORD_FILE=/etc/nginx/service.pwd

if [ -f ${NGINX_VIRTUAL_FILE} ]; then
    exit 0
fi

# Build the password file
htpasswd -b -c ${NGINX_PASSWORD_FILE} ${PROXY_AUTH_USERNAME} ${PROXY_AUTH_PASSWORD}

# Build nginx virtual host file for the service to protect
cat > ${NGINX_VIRTUAL_FILE} <<EOL
upstream service {

    server ${SERVICE_ADDRESS}:${SERVICE_PORT};
}

server {

    listen ${SERVICE_PORT} default_server;
    server_name ${PROXY_SERVER_NAME};

    auth_basic "Protected Service";
    auth_basic_user_file ${NGINX_PASSWORD_FILE};

    location / {

        proxy_pass http://service;
        include /etc/nginx/proxy_params;
    }
}
EOL

exit 0
