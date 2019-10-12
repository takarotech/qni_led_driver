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
HW_VERSION=$(grep -oP '"hw_version": *\K[^,]' ~/qni_conf.json)
ARGS=$(grep -oP 'args = "\K.*[^";]' ./qni_v0.cfg)
sudo $QNI_LED_DRIVER_BIN qni_v$HW_VERSION.cfg $ARGS
