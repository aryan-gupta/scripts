#!/bin/sh

PWD=$(pwd)

CRED_FILE="cred.txt"
CRED_FINAL_LOC="/etc/ddnsupdater"

SYSTEMD_SERVICE_FILE="ddns.service"
SYSTEMD_LIB_LOC="/usr/lib/systemd/system"

SCRIPT_FILE="ddns.py"
SCRIPT_LOC="/bin"
SCRIPT_NAME="ddnsupdater"

error() {
	printf '\E[31m'; echo "$@"; printf '\E[0m'
}

# Check root
if [[ $EUID -ne 0 ]]; then
	error "This script should be run using sudo or as the root user"
	exit 1
fi

# Check all the source files exist
if [[ ! -f "$PWD/$CRED_FILE" ]]; then
	error "[E] Could not find cred file: $PWD/$CRED_FILE"
	exit -1
fi

if [[ ! -f "$PWD/$SYSTEMD_SERVICE_FILE" ]]; then
	error "[E] Could not find service file: $PWD/$SYSTEMD_SERVICE_FILE"
	exit -1
fi

if [[ ! -f "$PWD/$SCRIPT_FILE" ]]; then
	error "[E] Could not find script file: $PWD/$SCRIPT_FILE"
	exit -1
fi

# Make cred directory
if [[ ! -d "$CRED_FINAL_LOC" ]]; then
	mkdir -p "$CRED_FINAL_LOC"
fi

# Install Cred file
ln -s "$PWD/$CRED_FILE" "$CRED_FINAL_LOC/$CRED_FILE"

# Install systemd service file
cp "$PWD/$SYSTEMD_SERVICE_FILE" "$SYSTEMD_LIB_LOC"

# Install script file
ln -s "$PWD/$SCRIPT_FILE" "$SCRIPT_LOC/$SCRIPT_NAME"

# Start service
systemctl enable --now "$SYSTEMD_SERVICE_FILE"