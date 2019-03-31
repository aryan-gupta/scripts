#!/bin/bash

hostname="gluon"
domain="gempi.re"
rootpasswd=toor

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc

sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo $hostname > /etc/hostname
(
	echo "127.0.0.1    localhost"
	echo "::1          localhost"
	echo "127.0.1.1    ${hostname}.${domain} ${hostname}"
) >> /etc/hosts

(
	echo $rootpasswd
	echo $rootpasswd
) | passwd

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH
grub-mkconfig -o /boot/grub/grub.cfg