#!/bin/bash

#-> Make sure we don't run as root
if (( EUID == 0 )); then
   echo 'Please run without sudo!' 1>&2
   exit 1
fi

#-> Go to the directory of this script
cd "$(dirname "${BASH_SOURCE[0]}")"

#-> Run qni_led_driver with arguments
#sudo rpi-fb-matrix/rpi-fb-matrix qni_v0.cfg --led-pixel-mapper=Snake:2 --led-pwm-bits=8 --led-brightness=90 --led-pwm-lsb-nanoseconds 400 "$@"
#sudo rpi-fb-matrix/rpi-fb-matrix qni_v1.cfg --led-gpio-mapping=free-i2c --led-multiplexing=4 --led-pixel-mapper=Snake:3 --led-pwm-bits=8 --led-brightness=90 --led-slowdown-gpio=2 --led-pwm-lsb-nanoseconds 500 "$@"
sudo rpi-fb-matrix/rpi-fb-matrix qni_v2.cfg --led-gpio-mapping=free-i2c --led-multiplexing=4 --led-pixel-mapper=Snake:2 --led-pwm-bits=8 --led-brightness=90 --led-slowdown-gpio=3 --led-pwm-lsb-nanoseconds 500 "$@"
