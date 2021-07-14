FROM alpine:latest
LABEL maintainer="Didstopia"
LABEL description="tftpd on Alpine Linux"

# RUN mkdir -p /var/log && touch /var/log/syslog

RUN apk --no-cache add tftp-hpa bash syslog-ng
RUN mkdir /data && \
    addgroup -S tftpd && \
    adduser -s /bin/false -S -D -H -h /data -G tftpd tftpd

COPY overlay/ /
COPY remap /var/lib/tftpboot/pxelinux.cfg/remap
# COPY syslog-ng.conf /etc/syslog-ng/syslog-ng.conf

VOLUME /data

EXPOSE 69/udp

ENV PUID 100
ENV PGID 101
ENV TFTPD_DEBUG false

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/in.tftpd"]
