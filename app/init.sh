#!/bin/sh

hciconfig hci0 up

if [ -z "$BT_DEVICE" ]; then

  # list pairable devices
  hcitool scan
  echo "Re-run with '-e BT_DEVICE=<device id>' to pair with a device."

else

  # start up with a specific device

  rm -f /var/run/dbus.pid
  dbus-daemon --system --fork

  /usr/lib/bluetooth/bluetoothd --plugin=a2dp -n &

  rm -f /tmp/pulse-*
  pulseaudio --log-level=1 --log-target=stderr --disallow-exit=true --exit-idle-time=-1 &

  hciconfig hci0 sspmode 0
  hciconfig hci0 piscan
  sleep 2
  /app/bluetooth-connect.exp

  sleep 5

  paplay /tmp/test/test.wav

fi
