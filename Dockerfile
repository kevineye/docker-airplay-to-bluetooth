FROM binhex/arch-base
MAINTAINER Kevin Eye <kevineye@gmail.com>

RUN pacman --noconfirm -Sy --needed \
        base-devel \
        git \
        bluez \
        bluez-libs \
        bluez-utils \
        bluez-firmware \
        alsa-utils \
        expect \
        shairport-sync

RUN cd /tmp \
 && curl -LO https://aur.archlinux.org/cgit/aur.git/snapshot/bluez-alsa-git.tar.gz \
 && tar xzvf bluez-alsa-git.tar.gz \
 && cd bluez-alsa-git/ \
 && echo 'nobody ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/nobody \
 && chown -R nobody .

RUN cd /tmp/bluez-alsa-git \
 && su nobody -c 'makepkg --noconfirm --needed -si' \
 && rm /etc/sudoers.d/nobody \
 && mkdir /var/run/dbus

ENV BT_HOST_NAME Docker
ENV BT_DEVICE ""
ENV BT_PIN 0000
ENV AIRPLAY_NAME Docker

ADD asound.conf /etc/asound.conf
ADD app /app

CMD /app/init.sh
