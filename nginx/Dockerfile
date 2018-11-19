FROM nginx:stable-alpine

LABEL maintainer="Rob Ballantyne <rob@dynamedia.uk>"

RUN apk --update add \
    bash

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./sites-available /etc/nginx/sites-available
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

CMD ["nginx"]