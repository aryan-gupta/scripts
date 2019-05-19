#!/bin/env python

import socket
from threading import Thread, Event
import signal
import sys
import json

SERVICES_FILE = sys.argv[1] if len(sys.argv) >= 2 else 'services.json'
HEADER = '{protocol} {{response}} {version}\r\n'

def parse(msg):
	retval = {}
	lines = msg.upper().split('\r\n')
	lines = lines[1:] # the first one is the header

	for line in lines:
		if line.find(':') == -1: continue

		key, value = line.split(':', 1)
		retval[key] = value

	return retval


def dict_str(as_dict):
	as_list = [ f'{key}:{as_dict[key]}' for key in as_dict.keys() ]
	as_list.extend(['', ''])
	return '\r\n'.join(as_list)


def get_reply(header, config, msg, addr):
	msg = parse(msg)
	request = msg['RQ'] if 'RQ' in msg.keys() and msg['RQ'] in config.keys() else 'INVALID'
	response = 'INVALID' if request == 'INVALID' else 'REPLY'
	reply = dict_str(config[request])
	return header.format(response=response) + reply


def udp_server_work(port, protocol, kill, config, version):
	with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
		sock.settimeout(2)
		sock.bind(('0.0.0.0', port))

		while not kill.is_set():
			try:
				message, address = sock.recvfrom(4096)
			except socket.timeout:
				continue

			message = message.decode()

			if message.split()[0] != protocol: continue # discard packet if not our protocol

			header = HEADER.format(protocol=protocol, version=version)
			reply = get_reply(header, config, message, address)
			sock.sendto(reply.encode(), address)


def tcp_server_work(port, protocol, kill, config, version):
	pass


def load_config(filename):
	with open(filename, 'r') as file:
		return json.load(file)


def main():
	config = load_config(SERVICES_FILE)
	protocol = config['DISCOVERY']['PROTOCOL']
	port = config['DISCOVERY']['PORT']
	version = config['DISCOVERY']['VERSION']

	kill = Event()

	udp_thread = Thread(target=udp_server_work, args=(port, protocol, kill, config, version))
	udp_thread.start()

	tcp_thread = Thread(target=tcp_server_work, args=(port, protocol, kill, config, version))
	tcp_thread.start()

	def sig_handler(sig, frame):
		nonlocal kill, tcp_thread, udp_thread
		kill.set()
		tcp_thread.join()
		udp_thread.join()
		sys.exit(0)
	signal.signal(signal.SIGINT, sig_handler)
	signal.pause()


if __name__ == "__main__":
	main()