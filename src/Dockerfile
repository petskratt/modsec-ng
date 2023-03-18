FROM owasp/modsecurity-crs:nginx-alpine

RUN apk add -U php8-fpm

COPY etc/nginx/ /etc/nginx/
COPY etc/modsecurity.d/ /etc/modsecurity.d/
COPY html/ /usr/share/nginx/html/
COPY docker-entrypoint.d/ /docker-entrypoint.d/

RUN cp /etc/nginx/templates/conf.d/modsecurity.conf.template /etc/nginx/conf.d/modsecurity.conf