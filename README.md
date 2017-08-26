[![Docker Automated build](https://img.shields.io/docker/automated/ayamshanov/slave-dns.svg)]()
[![Docker Build Status](https://img.shields.io/docker/build/ayamshanov/slave-dns.svg)]()

# Docker container with slave DNS (dynamic zones)

> Alpine Linux  
> BIND

## Usage

To use this container, you will need to provide IP-address of master DNS and rndc key.

```
docker run -d \
  -e "MASTER_DNS=198.51.100.1" \
  -e "RNDC_KEY=YW5vdGhlci1zZWNyZXQtbWFzdGVyLWtleQ==" \
  -v slave-dns:/var/bind \
  -p 53:53/udp -p 53:53/tcp \
  -p 953:953 \
  ayamshanov/slave-dns
```

## Environment variables

You must configure slave DNS daemon use following environment variables:

> **MASTER_DNS**  
> **RNDC_KEY**  
