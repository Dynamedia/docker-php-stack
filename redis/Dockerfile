FROM redis:5-alpine

LABEL maintainer="Rob Ballantyne <rob@dynamedia.uk>"

RUN apk --update add \
    busybox \
    bash

COPY ./redis.conf /usr/local/etc/redis/redis.conf

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]