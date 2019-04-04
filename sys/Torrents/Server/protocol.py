HEAD_LEN = 4

def read_data(connection, nbytes):
	""" Reads data on connection until we read nbytes nbyteser of bytes
		Will block until we read nbytes
	"""
	num_read = 0
	data = b''
	while num_read < nbytes:
		tmp = connection.recv(min(nbytes - num_read, 2048))
		data += tmp
		num_read += len(tmp)
	return data

def read_message(connection):
	header = read_data(connection, HEAD_LEN)
	msg_len = int.from_bytes(header, byteorder="big")
	message = read_data(connection, msg_len)
	return message

def send_message(connection, message):
	msg_len = len(message)
	header = msg_len.to_bytes(HEAD_LEN, byteorder="big")
	connection.sendall(header)
	connection.sendall(message)