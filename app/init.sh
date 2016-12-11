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

  rm -f /var/run/avahi-daemon/pid
  avahi-daemon &

  /usr/sbin/bluetoothd -n &

  hciconfig hci0 sspmode 0
  hciconfig hci0 piscan

  bluez4-simple-agent hci0 "$BT_DEVICE" "$BT_PIN"
  
  aplay -D bluetooth /tmp/test/test.wav

  # shairport-sync -a "$AIRPLAY_NAME" -o alsa -- -d bluetooth

fi
