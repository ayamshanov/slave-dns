FROM alpine:latest

MAINTAINER Alexander Yamshanov (https://github.com/ayamshanov)

# Note: you must change RNDC_KEY and MASTER_DNS
# You can use `docker run -e "MASTER_DNS=..." -e "RNDC_KEY=..."`
ENV MASTER_DNS 192.0.2.1
ENV RNDC_KEY ZXhhbXBsZS1zZWNyZXQtbWFzdGVyLWtleQ==

RUN apk update && apk --no-cache add bind \
  && cp /etc/bind/named.conf.authoritative /etc/bind/named.conf \
  && sed -i 's/listen-on { 127.0.0.1; };/listen-on { any; };/;' /etc/bind/named.conf \
  && sed -i 's/options {/options {\n\
        allow-new-zones yes;/;' /etc/bind/named.conf \
  && echo 'key "rndc-key-master" {'   >> /etc/bind/named.conf \
  && echo '      algorithm hmac-md5;' >> /etc/bind/named.conf \
  && echo '      secret "$RNDC_KEY";' >> /etc/bind/named.conf \
  && echo '};'                        >> /etc/bind/named.conf \
  && echo                             >> /etc/bind/named.conf \
  && echo 'controls {'                >> /etc/bind/named.conf \
  && echo '      inet * port 953 allow { $MASTER_DNS; } keys { "rndc-key-master"; };' >> /etc/bind/named.conf \
  && echo '};'                        >> /etc/bind/named.conf

EXPOSE 53/udp 53/tcp
EXPOSE 953

ADD start.sh /start.sh
ENTRYPOINT ["/bin/sh", "/start.sh"]
