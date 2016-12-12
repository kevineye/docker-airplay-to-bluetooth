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
* `-e BT_LATENCY_OFFSET=-2000` number of frames (i.e. 1/44100 of a second) to offset audio
* `-v <local path>:/var/lib/bluetooth` provide a place to cache paired bluetooth device details; this is not absolutely necessary, but without it future launches of the container will attempt to re-pair with the bluetooth device, which often requires manual intervention on the device

### More Info

This container is based on alpine linux, bluez5 bluetooth, [shairport-sync](https://github.com/mikebrady/shairport-sync), alsa and [bluez-alsa](https://github.com/Arkq/bluez-alsa).

Audio synchronization among playing devices is pretty good. bluez-alsa does not reliably connect and crashes a lot.

## Todo

* Test sharing host's bluetooth stack (/dev/hci) instead of controlling host's bluetooth hardware exclusively (/dev/usb)
* Support pairing with and connecting to multiple bluetooth devices (or any discoverable bluetooth speaker).
