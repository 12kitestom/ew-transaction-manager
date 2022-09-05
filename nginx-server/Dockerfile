FROM nginx:1.21-alpine

LABEL maintainer="tom.harris@12kites.com"

COPY ./files /usr/share/nginx/html

COPY ./add-url-var.sh /docker-entrypoint.d

ENV API_URL 'https://api.dev.ew-ops.net/api/v1/transaction'

RUN chmod u+x /docker-entrypoint.d/add-url-var.sh
