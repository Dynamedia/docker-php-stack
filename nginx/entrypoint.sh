#!/bin/sh

USER_NAME=${USER_NAME:-www-data}
USER_GROUP=${USER_GROUP:-www-data}
USER_UID=${USER_UID:-1001}
USER_GID=${USER_GID:-1001}
NGINX_WORKER_PROCESSES="${NGINX_WORKER_PROCESSES:-1}"
PHP_UPSTREAM_CONTAINER="${PHP_UPSTREAM_CONTAINER:-php-fpm}"
PHP_UPSTREAM_PORT="${PHP_UPSTREAM_PORT:-9000}"

# Delete the already existing user / group if existing

if id -u $USER_NAME > /dev/null 2>&1  ; then
    deluser $USER_NAME
fi

if getent passwd $USER_UID > /dev/null 2>&1  ; then
    CLASH_USER="$(getent passwd $USER_UID | cut -d: -f1)"
    deluser $CLASH_USER
fi

if getent group $USER_GID > /dev/null 2>&1  ; then
    CLASH_GROUP="$(getent group $USER_GID | cut -d: -f1)"
    # Try to delete the clashing group. If it has users we will just have to use that group (It's ok, the GID is what we wanted)
    if ! delgroup $CLASH_GROUP > /dev/null 2>&1  ; then
      USER_GROUP=$CLASH_GROUP
    else
      addgroup -g $USER_GID $USER_GROUP
    fi
else
  addgroup -g $USER_GID $USER_GROUP
fi

# Create our user & group with the specified details

adduser -D -u $USER_UID -s /bin/bash -G $USER_GROUP $USER_NAME


# Modify the main config

sed -i "s#NGINX_USER_PLACEHOLDER#user $USER_NAME\;#g" /etc/nginx/nginx.conf
sed -i "s#NGINX_WORKER_PROCESSES_PLACEHOLDER#worker_processes $NGINX_WORKER_PROCESSES\;#g" /etc/nginx/nginx.conf

# Delete the default configuration

if [ -e /etc/nginx/conf.d/default.conf ] ; then
 rm /etc/nginx/conf.d/default.conf
fi

# Add php-upstream

echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf

# Unset some of the more sensitive environment variables we inherited by using a single .env file

unset MYSQL_ROOT_PASSWORD
unset MYSQL_DATABASE
unset MYSQL_USER
unset MYSQL_PASSWORD

exec "$@"
