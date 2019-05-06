#!/bin/env python

import socket
from threading import Thread, Event
import signal
import sys

PROTOCOL = 'TGED'
VERSION = '1.0'
PORT = 4745

def parse(msg):
	retval = {}
	lines = msg.upper().split('\r\n')
	lines = lines[1:] # the first one is the header

	for line in lines:
		if line.find(':') == -1: continue

		key, value = line.split(':', 2)
		retval[key] = value

	return retval


def get_reply(msg, addr):
	msg = parse(msg)
	response = 'REPLY'
	reply = None
	request = msg['RQ']
	if request == 'CONTROL':
		reply = '\r\n'.join(['IP:192.168.0.3', f"PORT:{PORT}", '', ''])
	elif request == 'DNS_SEARCH':
		reply = '\r\n'.join(['RP:gempi.re', '', ''])
	elif request == 'DNS':
		reply = '\r\n'.join(['IP:192.168.0.3', 'PORT:53', '', ''])
	elif request == 'LG_SMB':
		reply = '\r\n'.join(['IP:192.168.0.5', 'PORT:445', '', ''])
	elif request == 'SM_SMB':
		reply = '\r\n'.join(['IP:192.168.0.5', 'PORT:445', '', ''])
	elif request == 'SQL':
		reply = '\r\n'.join(['IP:192.168.0.3', 'PORT:3306', '', ''])
	else:
		reply = '\r\n'.join(['RP:INVALID', '', ''])
		response = 'INVALID'

	header = f'{PROTOCOL} {response} {VERSION}\r\n'
	return header + reply


def udp_server_work(kill):
	with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
		sock.settimeout(2)
		sock.bind(('0.0.0.0', PORT))

		while not kill.is_set():
			message, address = None, None
			try:
				message, address = sock.recvfrom(1024)
			except socket.timeout:
				continue

			message = message.decode()

			protocol = message.split()[0]
			if protocol != PROTOCOL:
				continue

			reply = get_reply(message, address)
			sock.sendto(reply.encode(), address)

def tcp_server_work(kill):
	pass

def main():
	kill = Event()

	udp_thread = Thread(target=udp_server_work, args=(kill, ))
	udp_thread.start()

	tcp_thread = Thread(target=tcp_server_work, args=(kill, ))
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