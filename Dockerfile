FROM alpine:edge
MAINTAINER Kevin Eye <kevineye@gmail.com>

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
 && apk -U add \
        bluez \
        pulseaudio \
        pulseaudio-bluez \
        pulseaudio-utils \
        pulseaudio-dev \
        expect \
        build-base \
        curl \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
        autoconf \
        automake \
        libtool \
 && echo 'load-module module-switch-on-connect' >> /etc/pulse/default.pa \
 && cd /tmp \
 && curl -L -O https://github.com/mikebrady/shairport-sync/archive/2.8.6.tar.gz \
 && tar xzvf 2.8.6.tar.gz\
 && cd shairport-sync-2.8.6 \
 && autoreconf -i -f \
 && ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --localstatedir=/var \
        --with-alsa \
        --with-avahi \
        --with-ssl=openssl \
        --with-soxr \
        --with-pulseaudio \
 && make \
 && make install \
 && cd / \
 && apk --purge del \
        build-base \
        curl \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
        autoconf \
        automake \
        libtool \
        pulseaudio-dev \
 && apk add \
        libdaemon \
        popt \
        soxr \
        libconfig \
        avahi \
        pulseaudio-libs \
 && rm -rf /var/cache/apk* /lib/apk/db/* /etc/ssl /tmp/*

ENV HOME /root

ENV BT_DEVICE ""
ENV BT_PIN "0000"

ENV AIRPLAY_NAME "Docker"

CMD [ "/app/init.sh" ]

ADD app /app
