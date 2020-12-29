#!/bin/bash

#Defining Variables

DNS_SERVER="localhost"
DNS_ZONE="gempi.re."
HOST="$1.gempi.re."
IP="192.168.0.$2"
TTL="86400"
RECORD=" $HOST $TTL A $IP"


echo "
server $DNS_SERVER
zone $DNS_ZONE
debug
update add $RECORD
show
send" | nsupdate -k /etc/rndc.key


DNS_SERVER="localhost"
DNS_ZONE="0.168.192.in-addr.arpa."
HOST="$1.gempi.re."
IP="$2.0.168.192.in-addr.arpa."
TTL="86400"
RECORD=" $IP $TTL PTR $HOST"


echo "
server $DNS_SERVER
zone $DNS_ZONE
debug
update add $RECORD
show
send" | nsupdate -k /etc/rndc.key
