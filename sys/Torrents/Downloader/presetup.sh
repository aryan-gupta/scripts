#!/bin/bash

ping example.com -c 1
timedatectl set-ntp true

pacman -S git

pdisk="/dev/sda"
boot="${pdisk}1"
swap="${pdisk}2"
root="${pdisk}3"
archmnt="/mnt"

(
	echo g # new gpt partition table
	echo n # new partition
	echo   # partition number for gpt (default: 1)
	echo   # start sector (default)
	echo +512M # last sector (550M boot partition)
	echo t # change partition type
	echo 1 # efi partition
	echo n # new partiton
	echo   # partition number for gpt (default: 2)
	echo   # first sector
	echo +1G # last sector
	echo t # change part type
	echo   # select part number (defult: last partition we edit: 2)
	echo 19 # linux swap part number
	echo n # new root partition
	echo   # partition number (default: 2)
	echo   # first sector
	echo   # last sector
	echo w # write new table to disk
) | fdisk $pdisk

mkfs.fat -F32 $boot
mkfs.ext4 $root
mkswap $swap
swapon $swap

mount $root $archmnt
mkdir "${archmnt}/boot"
mount $boot "${archmnt}/boot"

pacstrap $archmnt base grub efibootmgr

genfstab -U $archmnt >> "${archmnt}/etc/fstab"

mkdir "${archmnt}/scripts"
# copy scripts to scripts

arch-chroot $archmnt /bin/bash /scripts/setup.sh