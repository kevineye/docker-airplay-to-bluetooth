FROM alpine:edge
MAINTAINER Kevin Eye <kevineye@gmail.com>

#add #include <sys/stat.h> to tools/hciconfig.c

RUN apk -U add build-base curl libusb-dev dbus-dev glib-dev alsa-lib-dev linux-headers libusb-compat-dev \
 && rm -rf /usr/include/fortify \
 && cd /root \
 && curl -L -O http://www.kernel.org/pub/linux/bluetooth/bluez-4.101.tar.xz \
 && unxz bluez-4.101.tar.xz \
 && tar xvf bluez-4.101.tar \
 && cd bluez-4.101 \
 && ./configure --enable-alsa --enable-usb --enable-tools --enable-test

ADD bluez-4.101-alpine.patch /tmp/bluez-4.101-alpine.patch

RUN cd /root/bluez-4.101 \
 && patch -p1 < /tmp/bluez-4.101-alpine.patch

RUN cd /root/bluez-4.101 \
 && make \
 && make install

RUN apk -U add \
        bluez \
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
 && make install

#  && cd / \
#  && apk --purge del \
#         build-base \
#         curl \
#         alsa-lib-dev \
#         libdaemon-dev \
#         popt-dev \
#         libressl-dev \
#         soxr-dev \
#         avahi-dev \
#         libconfig-dev \
#         autoconf \
#         automake \
#         libtool \
#         pulseaudio-dev \
#  && apk add \
#         libdaemon \
#         popt \
#         soxr \
#         libconfig \
#         avahi \
#         pulseaudio-libs \
#  && rm -rf /var/cache/apk* /lib/apk/db/* /etc/ssl /tmp/*

ENV HOME /root

ENV BT_DEVICE ""
ENV BT_PIN "0000"

ENV AIRPLAY_NAME "Docker"

CMD [ "/app/init.sh" ]

ADD app /app
