import os
import sys
import socket

import protocol as pc

sock_loc = "/tmp/tdowncom.sock"

def manage_connection(connection, address):
	message = pc.read_message(connection).decode()

	if message == '?':
		pc.send_message(connection, 'A'.encode())
		return

	pc.send_message(connection, 'D'.encode())

	# Create connection with other server and start

def check_exclusivity(location):
	""" If the path exists and we cant communicate with the main daemon
		Then daemon crashed so we take over
	"""
	if os.path.exists(location):
		with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
			if not pc.check_server(sock):
				os.remove(location)
				return True
			else:
				return False
	else:
		return True

def main():
	if not check_exclusivity(sock_loc):
		print("Daemon already running")
		sys.exit(0)

	with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
		sock.bind(sock_loc)
		sock.listen()

		while True:
			connection, address = sock.accept()
			manage_connection(connection, address)

if __name__ == '__main__':
	main()