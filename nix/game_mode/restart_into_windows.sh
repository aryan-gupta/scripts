#!/bin/bash
num="$(efibootmgr | grep "Windows" | sed 's/* Windows Boot Manager//' | sed 's/Boot//')"
echo $num
efibootmgr -n $num && systemctl reboot
