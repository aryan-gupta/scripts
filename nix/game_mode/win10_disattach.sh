#!/bin/bash

virsh detach-device win10-gaming-vm win10_mouse.xml
virsh detach-device win10-gaming-vm win10_keyboard.xml
virsh detach-device win10-gaming-vm win10_gamepad.xml
virsh detach-device win10-gaming-vm win10_microphone.xml
