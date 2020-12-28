#!/bin/bash

virsh attach-device win10-gaming-vm win10_mouse.xml
virsh attach-device win10-gaming-vm win10_keyboard.xml
virsh attach-device win10-gaming-vm win10_gamepad.xml
virsh attach-device win10-gaming-vm win10_microphone.xml
