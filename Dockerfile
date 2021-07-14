# FROM alpine:latest
FROM project42/syslog-alpine:latest

LABEL maintainer="Didstopia"
LABEL description="tftpd on Alpine Linux"

RUN apk --no-cache add tftp-hpa bash
RUN mkdir /data && \
    addgroup -S tftpd && \
    adduser -s /bin/false -S -D -H -h /data -G tftpd tftpd

COPY remap /var/lib/tftpboot/pxelinux.cfg/remap
COPY container-files /

VOLUME /data

EXPOSE 69/udp

ENV PUID 100
ENV PGID 101
ENV TZ Europe/Helsinki

ENV TFTPD_DEBUG false

ENTRYPOINT ["/init"]
