#!/bin/bash

sudo echo "Starting"
sudo modprobe i2c-dev
sudo virsh start win10-gaming-vm

if [ $? -ne 0 ]; then
	sleep 30
fi

sudo ./win10_attach.sh &&
sudo ddccontrol -r 0x60 -w 18 dev:/dev/i2c-6