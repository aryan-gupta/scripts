
import socket
import sys

from mpp import send_message, read_message

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

def get_discovery_response(service, timeout=10, ip=None):
	data = '\r\n'.join([HEADER, f"RQ:{service}", '', ''])
	if ip is None: # UDP
		with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
			sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
			sock.settimeout(timeout)
			sock.sendto(data.encode(), (DIS_IP, PORT))

			data, addr = sock.recvfrom(1024)
			reply = parse(data.decode())
			ip = addr[0]
	else: # TDP
		with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
			sock.connect((ip, PORT))
			send_message(sock, data.encode())

			data = read_message(sock)
			reply = parse(data.decode())
	reply['SVR'] = ip
	return reply

def main():
	if len(sys.argv) < 2:
		print("Usage: " + __file__ + " <IP Address>")
		sys.exit(-1)
	print(get_discovery_response('DISCOVERY'))
	print(get_discovery_response('DISCOVERY', ip=sys.argv[1]))
	print(get_discovery_response('SQL'))
	print(get_discovery_response('SQL', ip=sys.argv[1]))
	print(get_discovery_response('lkjlk'))
	print(get_discovery_response('lkjlk', ip=sys.argv[1]))

if __name__ == "__main__":
	main()