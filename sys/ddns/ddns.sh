#!/bin/sh

/usr/bin/curl 'https://USER:PASS@domains.google.com/nic/update?hostname=HOST' --silent > /tmp/ddns_ip.txt