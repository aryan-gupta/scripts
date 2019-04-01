#!/bin/env python

import os
import socket

def read_data(connection):
	return connection.recv(1024)

sock_loc = "/tmp/tdowncom.sock"

if not os.path.isfile(sock_loc):
	pass # the main script is not running. Start main script and then continue

with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock
	try:
		sock.connect(sock_loc)
	except OSError as msg:
		print(msg)
		sys.exit(1)

	message = b'This is the message.  It will be repeated.'
	successful = False
	sock.sendall(message)
	reply = read_data(sock)
	print(reply)