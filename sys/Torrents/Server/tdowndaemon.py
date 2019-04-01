import os
import sys
import socket
import signal
import stat

sock_loc = "/tmp/tdowncom.sock"

def signal_handler(sig, frame):
	sock.close()
	os.remove(sock_loc)

def read_data(connection):
	return connection.recv(1024)

def send_success(connection):
	connection.sendall(b"Done")

signal.signal(signal.SIGINT, signal_handler)
if os.path.exists(sock_loc):
	os.remove(sock_loc)

with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock
	sock.bind(sock_loc)
	sock.listen()

	while True:
		connection, address = sock.accept()
		print("New connection")
		data1 = read_data(connection)
		print("recv")
		send_success(connection)