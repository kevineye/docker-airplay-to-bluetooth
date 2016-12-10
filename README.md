AirPlay music to a Bluetooth speaker.

[![](https://images.microbadger.com/badges/image/kevineye/airplay-to-bluetooth.svg)](https://microbadger.com/images/kevineye/airplay-to-bluetooth "Get your own image badge on microbadger.com")

## Run

```
docker run -d \
    --net host \
    --cap-add NET_ADMIN \
    --device /dev/bus/usb \
    -v "$PWD"/devices:/var/lib/bluetooth \
    -e AIRPLAY_NAME=Docker \
    -e BT_DEVICE=XX:XX:XX:XX:XX:XX \
    -e BT_PIN=0000 \
    kevineye/airplay-to-bluetooth
```

or

```
docker-compose up app                         # list devices
BT_DEVICE=<device id> docker-compose up app   # connect to device and run
```

Make sure the linux host is not already using the bluetooth controller (stop bluetoothd if it is running).

Make sure to put the bluetooth device in pairing mode the first time the container is run (before or after starting).

### Parameters

* `--net host` must be run in host mode for avahi (zeroconf/bonjour) to be happy
* `--cap-add NET_ADMIN` needed to allow container to reconfigure bluetooth things
* `--device /dev/usb` share host usb devices to container for access to USB bluetooth HCI; could also share one specific Bluetooth host device if known (e.g. `/dev/usb/003/003`)
* `-e AIRPLAY_NAME=Docker` set the AirPlay device name. Defaults to Docker
* `-e BT_DEVICE=XX:XX:XX:XX:XX:XX` the Bluetooth device ID to connect to; leave blank to list available device IDs
* `-e BT_PIN=0000` the PIN to use when pairing; usually the default 0000 will work
* `-v <local path>:/var/lib/bluetooth` provide a place to cache paired bluetooth device details; this is not absolutely necessary, but without it future launches of the container will attempt to re-pair with the bluetooth device, which often requires manual intervention on the device

### More Info

This container is based on alpine linux, bluez5 bluetooth, pulseaudio, and [shairport-sync](https://github.com/mikebrady/shairport-sync) for AirPort  playback.

Shairport-sync does not attempt to keep pulseaudio output synchronized as it does with ALSA, but bluez5 has deprecated ALSA support in favor of pulseaudio, so synchronized audio (i.e. among multiple airplay speakers simultaneously) is not really possible with this configuration. In practice, the synchronization is pretty much random, off by up to a second ahead or behind.

## Todo

* Test sharing host's bluetooth stack (/dev/hci) instead of controlling host's bluetooth hardware exclusively (/dev/usb)
* Support pairing with and connecting to multiple bluetooth devices (or any discoverable bluetooth speaker).
* Separate shairplay->pulseaudio and pulseaudio->bluetooth into separate containers
* Work on synchronization, possibly by switching to bluez4 and alsa.