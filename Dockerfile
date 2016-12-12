FROM alpine:edge
MAINTAINER Kevin Eye <kevineye@gmail.com>

RUN apk -U add \
        expect \
        build-base \
        curl \
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
        autoconf \
        automake \
        libtool \
        alsa-lib-dev \
        alsa-utils \
        bluez-dev \
        bluez-libs \
        bluez \
        ortp-dev\
        glib-dev \
        libsndfile-dev \
        linux-headers \
 && cd /tmp \
 && curl -L -O http://www.kernel.org/pub/linux/bluetooth/sbc-1.3.tar.xz \
 && unxz sbc-1.3.tar.xz \
 && tar xvf sbc-1.3.tar \
 && cd sbc-1.3 \
 && ./configure --prefix=/usr \
 && make \
 && make install \
 && cd /tmp \
 && curl -L -O https://github.com/Arkq/bluez-alsa/archive/master.zip \
 && unzip master.zip \
 && cd bluez-alsa-master \
 && autoreconf --install \
 && mkdir build
RUN cd /tmp/bluez-alsa-master/build \
 && ../configure --disable-hcitop \
 && make \
 && make install \
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
 && make \
 && make install \
 && cd /
RUN apk --purge del \
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
        bluez-dev \
        ortp-dev\
        glib-dev \
        libsndfile-dev \
        linux-headers \
 && apk add \
        libdaemon \
        popt \
        soxr \
        libconfig \
        avahi \
        alsa-lib \
        ortp \
        glib \
        libsndfile \
 && rm -rf /var/cache/apk* /lib/apk/db/* /etc/ssl /tmp/*

ENV HOME /root

ENV BT_DEVICE ""
ENV BT_PIN "0000"
ENV BT_LATENCY_OFFSET "-2000"

ENV AIRPLAY_NAME "Docker"

CMD [ "/app/init.sh" ]

ADD asound.conf /etc/asound.conf
ADD shairport-sync.conf /etc/shairport-sync.conf
ADD app /app
