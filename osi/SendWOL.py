#!/bin/env python

import struct
import socket
import sys
import os
import subprocess
import mysql.connector
from datetime import datetime

CONFIG_FILE = 'sendwol.config'

def get_packet(mac):
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
	return bytes.fromhex(packet)


def send_wol_packet(ip, mac, port = 9):
	packet = get_packet(mac)
	with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
		sock.sendto(packet, (ip, port))


def broadcast_wol_packet(brcst, mac, port = 9):
	packet = get_packet(mac)
	with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
		sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
		sock.connect((brcst, port))
		sock.send(packet)


def create_config(filename):
	pass


def update_config(filename, config):
	pass


def load_config(filename):
	""" Loads a config file

		Format:
		DATE::<Date> # last time the config file was updated
		SQL::<Server[user@server.domain.com/database]> The SQL database to use to get config
		DNS::The DNS postfix to use
		<host>::<mac>
		...
	"""
	if not os.path.exists(filename):
		return create_config(filename)

	config = {}
	file = open(filename, 'r')
	for line in file:
		key, value = line.split('::', 2)
		config[key.upper()] = value

	next_update = datetime.strptime("%b %d, %Y %H:%M", config['DATE']) + datetime.timedelta(days=30)
	now = datetime.now()
	if next_update < now:
		update_config(filename, config)

	return config


def get_mac(file, host):
	SQLSVR = "local@higgs.gempi.re"
	DATABASE = "dhcp"
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


def get_dns_search(file):
	return '.gempi.re'


def ping(host, wait):
	reply = subprocess.run(['ping', '-c', '1', f"-w{wait}", host], stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT).returncode
	return reply == 0


def check_hostname(hostname):
	""" A hostname can only contain alphanumerical chars and '-'. Also the first char cannot be '-'"""
	if hostname.isalnum():
		return hostname

	if hostname[0] == '-':
		raise ValueError('Inalid hostname')

	stripped = hostname.replace('-', '')
	if stripped.isalnum():
		return hostname

	raise ValueError('Inalid hostname')


def send_and_wait(fqdn, ip, mac, max_wait = 15):
	brcst = ip[0 : ip.rfind('.')] + '.255'

	awake = False
	wait = 1
	while not awake:
		wait += 1

		if wait > max_wait:
			return awake

		broadcast_wol_packet(brcst, mac)
		send_wol_packet(ip, mac)

		print(f"Sent WOL (waiting: {wait}sec)")
		awake = ping(fqdn, wait)
	return awake


def main():
	if len(sys.argv) < 2:
		print("[E] Usage: <host>")

	config = load_config(CONFIG_FILE)

	host = check_hostname(sys.argv[1])
	fqdn = host + get_dns_search(config)

	awake = ping(fqdn, 2)

	if not awake:
		mac = get_mac(config, host) # reads mac from file, if not, tries to get it from server
		ip  = socket.gethostbyname(fqdn)
		print(f"Sending WOL to {fqdn} ({ip} -- {mac})")
		send_wol_packet(ip, mac)

		awake = send_and_wait(fqdn, ip, mac)

	if awake:
		print(f"{fqdn} is awake")
	else:
		print(f"Failed to wake {fqdn}")


if __name__ == "__main__":
	main()
