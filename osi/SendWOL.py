#!/bin/env python

import struct
import socket
import sys
import os
import subprocess
import mysql.connector
from datetime import datetime

from tgedclient import get_discovery_response
from uriparse import uri_parse

CONFIG_FILE = '~/.config/sendwol.config'
CACHE_FILE = '~/.cache/sendwol.cache'

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


def check_sql_svr(host):
	with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
		return sock.connect_ex((host, 3306)) == 0


def read_dict(filename):
	config = {}
	with open(filename, 'r') as file:
		for line in file:
			key, value = line.split('::', 2)
			config[key.strip()] = value.strip()
	return config


def write_dict(filename, config):
	with open(filename, "w") as file:
		for key in config.keys():
			file.write(f'{key}::{config[key]}\n')


def needs_update(date):
	next_update = datetime.strptime(date, '%Y-%m-%d %H:%M:%S')
	now = datetime.now()
	return next_update > now


def load_config(filename):
	""" Loads a config file, creating one if none exists, updating it if its outdated

		Format:
		DATE::<Date> # last time the config file was updated
		SQL::<Server[user@server.domain.com/database]> The SQL database to use to get config
		SEARCH::The DNS postfix to use
		...
	"""
	db = 'dhcp'
	config = {}

	if not os.path.exists(filename): # If no file exists, create one
		config['DATE'] = str(datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
		reply = get_discovery_response('SQL')
		config['SQL'] = f"{reply['USER']}@{reply['HOST']}/{db}"
		reply = get_discovery_response('DNS_SEARCH')
		config['SEARCH'] = reply['RP']

		write_dict(filename, config)
	else:
		config = read_dict(filename)
		if needs_update(config['DATE']):
			config['DATE'] = str(datetime.now() + datetime.timedelta(days=30))
			write_dict(filename, config)
	return config


def get_mac_from_sql(host, server):
	svr = uri_parse(server)
	db = None
	try:
		db = mysql.connector.connect(
			user=svr.user,
			host=svr.host,
			database=svr.path[1:] # strip the leading '/'
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


def get_mac(host, server, cachefile):
	cache = {}
	if not os.path.exists(cachefile):
		cache[host] = get_mac_from_sql(host, server)
		write_dict(cachefile, cache)
	else:
		cache = read_dict(cachefile)
		if not host in cache.keys():
			cache[host] = get_mac_from_sql(host, server)
			write_dict(cachefile, cache)
	return cache[host]


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
		return

	config = load_config(os.path.expanduser(CONFIG_FILE))

	host = check_hostname(sys.argv[1]).lower()
	fqdn = host + '.' + config['SEARCH']

	awake = ping(fqdn, 2)

	if not awake:
		mac = get_mac(host, config['SQL'], os.path.expanduser(CACHE_FILE))
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
