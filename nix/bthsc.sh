#!/bin/bash

loc=$(dirname $(type -p $0)) # https://stackoverflow.com/questions/59895/get-the-source-directory-of-a-bash-script-from-within-the-script-itself
filename="$loc/mac_addr.txt"
mac=$(cat $filename | head -n 2 | tail -n 1)
name=$(head -1 $filename)

until $(echo "connect $mac\nexit" | bluetoothctl | grep "$name" -q);
do
    :
done
