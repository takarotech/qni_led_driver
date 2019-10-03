#!/bin/bash

#-> Make sure we don't run as root
if (( EUID == 0 )); then
   echo 'Please run without sudo!' 1>&2
   exit 1
fi

#-> Go to the directory of this script
cd "$(dirname "${BASH_SOURCE[0]}")"

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
