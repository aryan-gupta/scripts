#!/bin/bash

sudo echo "Starting"
sudo modprobe i2c-dev
sudo sh -c "echo 1 > /sys/module/kvm/parameters/ignore_msrs"
sudo virsh start win10-gaming-vm

retval=$?
if [ $retval -eq 0 ]; then
	echo "Waiting for windows start"
	sleep 30
fi

sudo ./win10_attach.sh &&
sudo ddccontrol -r 0x60 -w 18 dev:/dev/i2c-6
sudo ddccontrol -r 0x60 -w 14 dev:/dev/i2c-6

retval=$?
if [ $retval -ne 0 ]; then
	sudo ./win10_deattach.sh
fi