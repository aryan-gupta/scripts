def read_data(connection, nbytes = None):
	""" Reads data on connection until we read nbytes nbyteser of bytes
		If nbytes is None then read as many bytes, for a max of 4096 bytes
	"""
	if nbytes == None:
		return connection.recv(4096)
	else:
		num_read = 0
		data = b''
		while num_read < nbytes:
			tmp = connection.recv(min(nbytes - num_read, 2048))
			if tmp == b'': raise RuntimeError("Socket connection broken")
			data += tmp
			num_read += len(tmp)
		return data

def read_message(connection):
	header = read_data(connection, 4)
	msg_len = int.from_bytes(header, byteorder="big")
	message = read_data(connection, msg_len)
	return message

def send_message(connection, message):
	msg_len = len(message)
	header = msg_len.to_bytes(4, byteorder="big")
	connection.sendall(header)
	connection.sendall(message)