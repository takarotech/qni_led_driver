#!/bin/bash

#-> Make sure we don't run as root
if (( EUID == 0 )); then
	echo 'Please run without sudo!' 1>&2
	exit 1
fi

#-> Make sure the driver is not running yet
QNI_LED_DRIVER_BIN=./rpi-fb-matrix/rpi-fb-matrix
if pgrep -f $QNI_LED_DRIVER_BIN > /dev/null; then
	echo 'Please kill previous led driver!' 1>&2
	exit 2
fi

#-> Go to the directory of this script
cd "$(dirname "${BASH_SOURCE[0]}")"

#-> Run qni_led_driver with arguments
sudo $QNI_LED_DRIVER_BIN qni_v0.cfg --led-pixel-mapper=Snake:2 --led-pwm-bits=8 --led-brightness=90 --led-pwm-lsb-nanoseconds 400 "$@"
#sudo $QNI_LED_DRIVER_BIN qni_v1.cfg --led-gpio-mapping=free-i2c --led-multiplexing=4 --led-pixel-mapper=Snake:3 --led-pwm-bits=8 --led-brightness=90 --led-slowdown-gpio=2 --led-pwm-lsb-nanoseconds 500 "$@"
#sudo $QNI_LED_DRIVER_BIN qni_v2.cfg --led-gpio-mapping=free-i2c --led-multiplexing=4 --led-pixel-mapper=Snake:2 --led-pwm-bits=8 --led-brightness=90 --led-slowdown-gpio=3 --led-pwm-lsb-nanoseconds 500 "$@"
