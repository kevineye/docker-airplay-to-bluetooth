FROM alpine:edge
MAINTAINER Kevin Eye <kevineye@gmail.com>

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
 && apk -U add \
        bluez \
        pulseaudio \
        pulseaudio-bluez \
        pulseaudio-utils \
        pulseaudio-alsa \
        expect \
 && echo 'load-module module-switch-on-connect' >> /etc/pulse/default.pa

ENV HOME /root

ENV BT_DEVICE ""
ENV BT_PIN "0000"

CMD [ "/app/init.sh" ]

ADD app /app
