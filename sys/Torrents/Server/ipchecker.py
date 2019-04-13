#!/bin/env python

import os
import sys
import socket
import datetime

HEAD_LEN = 4

def send_message(connection, message):
	msg_len = len(message)
	header = msg_len.to_bytes(HEAD_LEN, byteorder="big")
	connection.sendall(header)
	connection.sendall(message)

def manage_connection(connection, address):
	ip = str(address[0])
	f = open("/var/log/ipchecker_accepted.log", "a")
	time = str(datetime.datetime.now())
	f.write(time + "\t\t"+ ip + "\n")
	send_message(connection, ip.encode())

def main():
	with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
		sock.bind(('', 29630))
		sock.listen()

		while True:
			connection, address = sock.accept()
			manage_connection(connection, address)


if __name__ == '__main__':
	main()