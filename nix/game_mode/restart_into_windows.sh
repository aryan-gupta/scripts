#!/bin/bash
num="$(efibootmgr | grep "Windows Boot Manager" | awk '{print $1}' | sed 's/Boot//' | sed 's/*//')"
echo $num
efibootmgr -n $num && systemctl reboot
