#!/bin/bash

NGINX_VIRTUAL_FILE=/etc/nginx/conf.d/virtual.conf
NGINX_PASSWORD_FILE=/etc/nginx/service.pwd

if [ -f ${NGINX_VIRTUAL_FILE} ]; then
    exit 0
fi


mkdir -p /etc/nginx/conf.d

if [ "x${AUTH_TYPE}" = "xldap" ]; then
  cat > ${NGINX_VIRTUAL_FILE} <<EOL
    ldap_server ldap_srv {
        url ${LDAP_URI};
        group_attribute memberUid;
        group_attribute_is_dn on;
        require ${LDAP_REQUIRE};
    }
EOL

  AUTH_CONFIG="auth_ldap \"Protected Service\";
    auth_ldap_servers ldap_srv;
"
else
  # Default to username:password
  # Build the password file
  htpasswd -b -c ${NGINX_PASSWORD_FILE} ${PROXY_AUTH_USERNAME} ${PROXY_AUTH_PASSWORD}

  AUTH_CONFIG="auth_basic \"Protected Service\";
    auth_basic_user_file ${NGINX_PASSWORD_FILE};
"
fi


# Build nginx virtual host file for the service to protect
cat >> ${NGINX_VIRTUAL_FILE} <<EOL
upstream service {

    server ${SERVICE_ADDRESS}:${SERVICE_PORT};
}

server {

    listen 80 default_server;
    server_name ${PROXY_SERVER_NAME};

    ${AUTH_CONFIG}

    location / {

        proxy_pass http://service;
        include /etc/nginx/proxy_params;
    }
}
EOL

exit 0
