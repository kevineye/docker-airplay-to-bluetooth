#!/bin/sh

hciconfig hci0 reset
hciconfig hci0 up

if [ -z "$BT_DEVICE" ]; then

  # list pairable devices
  hcitool scan
  echo "Re-run with '-e BT_DEVICE=<device id>' to pair with a device."
  
else

  # start up with a specific device

  rm -f /run/dbus/pid
  dbus-daemon --system --fork

  avahi-daemon &

  sed -i 's/device ".*"/device "'$BT_DEVICE'"/' /etc/asound.conf
  /usr/lib/bluetooth/bluetoothd --plugin=a2dp -n &
  /usr/bin/bluealsa &
  sleep 5
  
  hciconfig hci0 name $BT_HOST_NAME
  hciconfig hci0 sspmode 0
  hciconfig hci0 piscan
  /app/bluetooth-connect.exp

  sleep 5
  
  shairport-sync -v -a "$AIRPLAY_NAME"

fi