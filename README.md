A big thank you to this page:
https://wiki.archlinux.org/index.php/Bluetooth_headset#Headset_via_Bluez5.2FPulseAudio

Also inspired by https://hub.docker.com/r/kvaps/bluez-a2dp/

## Todo

* Improve documentation
* Test sharing host's bluetooth stack (/dev/hci) instead of controlling host's bluetooth hardware exclusively (/dev/usb)
* Improve pairing
* Pair multiple devices (works) and automatically switch audio to connected device
