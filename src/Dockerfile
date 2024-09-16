ARG MODSECURITY_TAG

FROM owasp/modsecurity-crs:$MODSECURITY_TAG

USER root
RUN apk update
RUN apk add -U --no-cache php82-fpm

COPY etc/ /etc/
COPY html/ /usr/share/nginx/html/
COPY rules/* /opt/owasp-crs/rules

#RUN cp /etc/nginx/templates/conf.d/modsecurity.conf.template /etc/nginx/conf.d/modsecurity.conf
