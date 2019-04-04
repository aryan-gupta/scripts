#!/bin/env python

import os
import sys
import socket

import protocol as pc

sock_loc = "/tmp/tdowncom.sock"

def main():
	if not os.path.isfile(sock_loc):
		pass # the main script is not running. Start main script and then continue

	with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
		try:
			sock.connect(sock_loc)
		except OSError as msg:
			print(msg)
			sys.exit(1)

		message = b'This is the message. It will be repeated.'
		pc.send_message(sock, message)
		reply = pc.read_message(sock)
		print(reply)

if __name__ == '__main__':
	main()