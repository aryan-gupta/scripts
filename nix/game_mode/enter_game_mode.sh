#!/bin/bash

sudo echo "Starting"
sudo modprobe i2c-dev
sudo virsh start win10-gaming-vm
sleep 30
sudo /var/lib/libvirt/images/win10_attach.sh &&
sudo ddccontrol -r 0x60 -w 18 dev:/dev/i2c-6