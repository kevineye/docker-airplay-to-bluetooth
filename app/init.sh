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

  /usr/lib/bluetooth/bluetoothd --plugin=a2dp -n &

  sed -i 's/device ".*"/device "'$BT_DEVICE'"/' /etc/asound.conf
  /usr/bin/bluealsa &

  hciconfig hci0 sspmode 0
  hciconfig hci0 piscan
  sleep 2
  /app/bluetooth-connect.exp

  sleep 5

  sed -i 's/audio_backend_latency_offset = .*;/audio_backend_latency_offset = '$BT_LATENCY_OFFSET';/g' /etc/shairport-sync.conf
  shairport-sync -a "$AIRPLAY_NAME"

fi
