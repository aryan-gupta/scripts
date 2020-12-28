#!/bin/bash

sudo echo "Exiting Game Mode"
sudo ./win10_disattach.sh &&
sudo ddccontrol -r 0x60 -w 15 dev:/dev/i2c-6
