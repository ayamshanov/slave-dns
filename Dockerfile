FROM alpine:latest

MAINTAINER Alexander Yamshanov (https://github.com/ayamshanov)

# Note: you must change RNDC KEY and MASTER DNS.
ENV RNDC_KEY ZXhhbXBsZS1zZWNyZXQtbWFzdGVyLWtleQ==
ENV MASTER_DNS 192.0.2.1

RUN apk update && apk --no-cache add bind \
  && cp /etc/bind/named.conf.authoritative /etc/bind/named.conf \
  && sed -i 's/options {/options {\n\
        allow-new-zones yes;/;' /etc/bind/named.conf \
  && echo 'key "rndc-key-master" {'   >> /etc/bind/named.conf \
  && echo '      algorithm hmac-md5;' >> /etc/bind/named.conf \
  && echo '      secret "'$RNDC_KEY'";' >> /etc/bind/named.conf \
  && echo '};'                        >> /etc/bind/named.conf \
  && echo                             >> /etc/bind/named.conf \
  && echo 'controls {'                >> /etc/bind/named.conf \
  && echo '      inet * port 953 allow { '$MASTER_DNS'; 127.0.0.1; } keys { "rndc-key-master"; };' >> /etc/bind/named.conf \
  && echo '};'                        >> /etc/bind/named.conf

EXPOSE 53/tcp 53/udp
EXPOSE 953

ENTRYPOINT ["/usr/sbin/named", "-u", "named", "-f", "-g"]
