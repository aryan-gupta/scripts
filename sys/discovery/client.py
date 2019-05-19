
import socket

HEADER = "TGED DISCOVERY 1.0"
DIS_IP = '255.255.255.255'
PORT = 4745

def parse(raw):
	pairs = raw.split('\r\n')[1:-2] # Strip the Header and the trailing empty values
	ret = {}
	for pair in pairs:
		key, value = pair.split(':', 2)
		ret[key] = value
	return ret

def get_discovery_response(service):
	with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
		data = '\r\n'.join([HEADER, f"RQ:{service}", '', ''])

		sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
		sock.settimeout(10)
		sock.sendto(data.encode(), (DIS_IP, PORT))

		data, addr = sock.recvfrom(1024)
		reply = parse(data.decode())
		reply['SVR'] = str(addr[0])

		return reply

def main():
	print(get_discovery_response('DISCOVERY'))
	print(get_discovery_response('SQL'))
	print(get_discovery_response('lkjlk'))

if __name__ == "__main__":
	main()