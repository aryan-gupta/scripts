#!/bin/bash

BOOT=$(sudo efibootmgr | grep "Arch Linux" | sed 's/* Arch Linux//' | sed 's/Boot//')

sudo efibootmgr
printf "\n\n ARE YOU SURE YOU WANT TO REMOVE ENTRY $BOOT ?"
read -p "[y/N]" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

efibootmgr -Bb $BOOT
# efibootmgr --disk /dev/sdb --part 1 --create --label "Arch Linux" --loader /vmlinuz-linux --unicode 'rd.luks.name=dc47124d-a3e0-41ee-bab1-2be753628c35=graviton_crypt0 root=/dev/mapper/graviton_vg0-root rw initrd=\initramfs-linux.img intel_iommu=on iommu=pt' --verbose
efibootmgr --disk /dev/sdb --part 1 --create --label "Arch Linux" --loader /vmlinuz-linux --unicode 'rd.luks.name=dc47124d-a3e0-41ee-bab1-2be753628c35=graviton_crypt0 root=/dev/mapper/graviton_vg0-root rw initrd=\initramfs-linux.img loglevel=3' --verbose
