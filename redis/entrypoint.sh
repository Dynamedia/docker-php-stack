#!/bin/sh

REDIS_MAXMEMORY=${REDIS_MAXMEMORY:-64M}
REDIS_MAXMEMORY_POLICY=${REDIS_MAXMEMORY_POLICY:-allkeys-lfu}

# Modify the redis config

sed -i "s#REDIS_MAXMEMORY_PLACEHOLDER#maxmemory $REDIS_MAXMEMORY#g" /usr/local/etc/redis/redis.conf
sed -i "s#REDIS_MAXMEMORY_POLICY_PLACEHOLDER#maxmemory-policy $REDIS_MAXMEMORY_POLICY#g" /usr/local/etc/redis/redis.conf

# Unset some of the more sensitive environment variables we inherited by using a single .env file

unset MYSQL_ROOT_PASSWORD
unset MYSQL_DATABASE
unset MYSQL_USER
unset MYSQL_PASSWORD

exec "$@"
