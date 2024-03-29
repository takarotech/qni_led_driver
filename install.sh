#!/bin/bash

#-> Make sure we don't run as root
if (( EUID == 0 )); then
	echo 'Please run without sudo!' 1>&2
	exit 1
fi

#-> Go to the directory of this script
cd "$(dirname "${BASH_SOURCE[0]}")"
QNI_LED_DRIVER_DIR=$(pwd)

#-> Clone led driver and screen capture repos
git clone https://github.com/arduino12/rpi-rgb-led-matrix.git
git clone https://github.com/adafruit/rpi-fb-matrix.git

#-> Compile led driver
cd $QNI_LED_DRIVER_DIR/rpi-rgb-led-matrix
make -C examples-api-use -j4
make -C bindings/python build-python -j4 PYTHON=$(which python3)
sudo make -C bindings/python install-python PYTHON=$(which python3)
sudo apt install -y libgraphicsmagick++-dev libwebp-dev
make -C utils led-image-viewer

#-> Compile screen capture
cd $QNI_LED_DRIVER_DIR/rpi-fb-matrix
sudo apt install -y build-essential libconfig++-dev
rm -rf rpi-rgb-led-matrix
ln -sfn $QNI_LED_DRIVER_DIR/rpi-rgb-led-matrix .
sed -i -e 's/adafruit-hat/regular/g' Makefile
make

#-> Set qni_led_server to run on specific cpu core
sudo sed -i '1s/^/isolcpus=3 /' /boot/cmdline.txt

#-> Remove unnecessary processes
sudo apt purge -y bluez bluez-firmware pi-bluetooth triggerhappy pigpio

#-> Limit resolution because 57=1680x1050 is too high for this driver,
#   can set to 47=1440x900, 35=1280x1024 4=640x480
sudo raspi-config nonint do_resolution 2 47

#-> Add to autostart
echo @$QNI_LED_DRIVER_DIR/run_qni_led_driver.sh >> $HOME/.config/lxsession/LXDE-pi/autostart
