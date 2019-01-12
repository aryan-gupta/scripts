#!/bin/env bash

file='~/.private.crypt'
name='private'
bdev="/dev/mapper/$name"
dest='~/Private'

if [! -f "$file" ]
then
	sudo cryptsetup open $file $name
	sudo mount $bdev $dest
fi