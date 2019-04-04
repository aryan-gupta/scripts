import os
import sys
import socket

import protocol as pc

sock_loc = "/tmp/tdowncom.sock"

def main():
	if os.path.exists(sock_loc):
		os.remove(sock_loc)

	with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
		sock.bind(sock_loc)
		sock.listen()

		while True:
			connection, address = sock.accept()
			message = pc.read_message(connection)
			print(message)
			pc.send_message(connection, b'Done')

if __name__ == '__main__':
	main()