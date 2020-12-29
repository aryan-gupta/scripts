#!/bin/bash

# AKA mntsecure.sh

CRYPT_FILE='~/.Secure.crypt'
CRYPT_NAME='boson-aryan-crypt'
MNT_DIR='~/Secure'
args=("$@") # https://stackoverflow.com/questions/35544760

# If script is not run as root then re run the script as
# root with the proper home variable
if [[ $EUID -ne 0 ]]; then
	sudo "${BASH_SOURCE[0]}" "${args[@]}" --home "$HOME"
	exit 0
fi

echo "${args[@]}" >> /test.txt

# if grep -qs "/dev/mapper/$CRYPT_NAME " "/proc/mounts"; then
# 	umount "/dev/mapper/$CRYPT_NAME"
# fi


# if [ -f "/dev/mapper/$CRYPT_NAME" ]; then
# 	cryptsetup close "$CRYPT_NAME"
# fi


# if we are running as root then double check that the
# home variable is set, if so then get the location of
# the crypt file
if [ "$1" == "--home" ]; then
	CRYPT_FILE=${CRYPT_FILE//"~"/"$2"}
	MNT_DIR=${MNT_DIR//"~"/"$2"}
else
	echo "Script must be run as normal user or \`--home ~\` must be specified"
	exit 1
fi

# Start the timer if this script is running in the background
# else mount the crypt volume and re run the script in the background
if [ "$3" == "--background" ]; then
	# CRYPT_FILE=${CRYPT_FILE//"~"/"$3"} # --background --home ~
	# MNT_DIR=${MNT_DIR//"~"/"$3"}


	while [ -f "/dev/mapper/$CRYPT_NAME" ]
	do
		echo "/dev/mapper/$CRYPT_NAME" >> /test.txt
		umount "/dev/mapper/$CRYPT_NAME" >> /test.txt
		cryptsetup close "$CRYPT_NAME" >> /test.txt
		sleep 1 # 5 min
	done
else
	cryptsetup open "$CRYPT_FILE" "$CRYPT_NAME"
	mount "/dev/mapper/$CRYPT_NAME" "$MNT_DIR"

	echo "Mounted Secure Directory"

	sudo "${BASH_SOURCE[0]}" "${args[@]}" --background &
	echo "Launched Background daemon"
	disown
fi

