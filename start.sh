#!/bin/sh

set -e

sed -i "s/\$MASTER_DNS/$MASTER_DNS/;" /etc/bind/named.conf
sed -i "s/\$RNDC_KEY/$RNDC_KEY/;" /etc/bind/named.conf

exec /usr/sbin/named -u named -f -g
