
import os
import sys
import socket

import protocol as pc

def main():
	with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
		sock.connect(("home.theguptaempire.net", 29630))

		reply = pc.read_message(sock)
		print(reply)

if __name__ == '__main__':
	main()