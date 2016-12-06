FROM alpine:edge
MAINTAINER Kevin Eye <kevineye@gmail.com>

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
 && apk -U add \
        bluez \
        pulseaudio \
        pulseaudio-bluez \
        pulseaudio-utils \
        pulseaudio-alsa \
 && echo 'load-module module-switch-on-connect' >> /etc/pulse/default.pa

ADD app /app

ENTRYPOINT [ "/app/init.sh" ]
CMD [ ]
