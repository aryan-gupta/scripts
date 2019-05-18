#!/bin/sh

PWD=$(pwd)

CRED_FILE="cred.txt"
CRED_FINAL_LOC="/etc/ddns"

SYSTEMD_SERVICE_FILE="ddns.service"
SYSTEMD_LIB_LOC="/usr/lib/systemd/system"

SCRIPT_FILE="ddns.py"
SCRIPT_LOC="/bin"
SCRIPT_NAME="ddnsupdater"

# Install Cred file
if [[ ! -f "$PWD/$CRED_FILE" ]]; then
	echo "Could not find cred file: $PWD/$CRED_FILE"
	exit -1
fi

if [[ ! -d "$CRED_FINAL_LOC" ]]; then
	mkdir -p "$CRED_FINAL_LOC"
fi

ln -s "$PWD/$CRED_FILE" "$CRED_FINAL_LOC/$CRED_FILE"



# Install systemd service file
if [[ ! -f "$PWD/$SYSTEMD_SERVICE_FILE" ]]; then
	echo "Could not find cred file: $PWD/$SYSTEMD_SERVICE_FILE"
	exit -1
fi

if [[ ! -d "$SYSTEMD_LIB_LOC" ]]; then
	mkdir -p "$SYSTEMD_LIB_LOC"
fi

ln -s "$PWD/$SYSTEMD_SERVICE_FILE" "$SYSTEMD_LIB_LOC"



# Install script file
if [[ ! -f "$PWD/$SCRIPT_FILE" ]]; then
	echo "Could not find cred file: $PWD/$SCRIPT_FILE"
	exit -1
fi

if [[ ! -d "$SCRIPT_LOC" ]]; then
	mkdir -p "$SCRIPT_LOC"
fi

ln -s "$PWD/$SCRIPT_FILE" "$SCRIPT_LOC/$SCRIPT_NAME"



# Start service
systemctl enable --now "$SYSTEMD_SERVICE_FILE"