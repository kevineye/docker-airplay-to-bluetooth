#!/bin/sh

hciconfig hci0 up

rm -f /run/dbus/pid
dbus-daemon --system --fork

/usr/lib/bluetooth/bluetoothd --plugin=a2dp -n &

pulseaudio --log-level=1 --log-target=stderr --disallow-exit=true --exit-idle-time=-1 &

if [ "$*" == "pair" ]; then
  hciconfig hci0 sspmode 0
  hciconfig hci0 piscan
  sleep 2
  bluetoothctl
elif [ -z "$*" ]; then
  wait
else
  exec sh -c "$*"
fi
