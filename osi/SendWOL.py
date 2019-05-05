#!/bin/env python

import struct
import socket
import os
import sys
import mysql.connector

SQLSVR = "local@higgs.gempi.re"
DATABASE = "dhcp"
DOMAIN = '.gempi.re'

def send_wol_packet(ip, mac, port = 9):
	if len(mac) == 12: # match straight mac addresses
		pass
	elif len(mac) == 12 + 5: # match mac addr seperated by ' ', ':', or other seperator
		sep = mac[2]
		mac = mac.replace(sep, '')
	else:
		raise ValueError("[E] Unsupported MAC address format: " + mac)

	# The anatomy of a magic packet is 6 bytes of 0xFF then the mac address 16 times
	packet = ("FF" * 6) + (mac * 16)

	# Convert hex string to Binary packet
	packet = bytes.fromhex(packet)

	sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
	sock.sendto(packet, (ip, port))
	sock.close()

def load_config(host):
	try:
		db = mysql.connector.connect(
			user = SQLSVR.split("@")[0],
			host = SQLSVR.split("@")[1],
			database = DATABASE
		)
	except mysql.connector.errors.ProgrammingError:
		print("[E] Error on connecting to database")

	cur = db.cursor()
	cur.execute(f"SELECT mac FROM static WHERE host = '{host}'")
	result = cur.fetchall()

	if not result:
		print(f"[E] host `{host}' does not exist")
		raise SystemExit()

	return result[0][0]


def main():
	if len(sys.argv) < 2:
		print("[E] Usage: <host>")
	host = sys.argv[1]
	mac = load_config(host)
	ip  = socket.gethostbyname(host + DOMAIN)
	send_wol_packet(ip, mac)
	print("Sent to " + ip + " with mac: " + mac)

if __name__ == "__main__":
	main()
