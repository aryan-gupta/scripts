#!/bin/env python

import os
import sys
import socket

import protocol as pc

sock_loc = "/tmp/tdowncom.sock"

def is_magnet(link):
	return link.startswith("magnet:?")

def start_daemon():
	pass # code this

def main():
	if len(sys.argv) < 2:
		print("Usage: ", sys.argv[0], " <magnet_link>")
		sys.exit(-1)

	link = sys.argv[1]
	if not is_magnet(link):
		raise RuntimeError("Argument is not a magnet link")

	if not os.path.isfile(sock_loc):
		start_daemon()

	with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
		try:
			sock.connect(sock_loc)
		except OSError as msg:
			print(msg)
			sys.exit(1)

		reply = pc.get_reply(sock, link)
		if reply == "D":
			print("Torrent successfully recived")

if __name__ == '__main__':
	main()