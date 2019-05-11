
import socket

SSDP_BROADCAST_PORT = 1900
SSDP_BROADCAST_ADDR = '239.255.255.250'
SSDP_BROADCAST_MSG = '\r\n'.join([
	'M-SEARCH * HTTP/1.1',
	f'HOST: {SSDP_BROADCAST_ADDR}:{SSDP_BROADCAST_PORT}',
	'MAN: "ssdp:discover"',
	'MX: 10',
	'ST: ssdp:all',
	'',
	''
])
UPNP_DEFAULT_SERVICE_TYPE = "urn:schemas-upnp-org:service:AVTransport:1"

def get_upnp_replies(timeout = 3): # SSDP
	replies = []
	with socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP) as s:
		s.settimeout(timeout)
		s.setsockopt(socket.IPPROTO_IP, socket.IP_MULTICAST_TTL, 4)
		s.bind(('', SSDP_BROADCAST_PORT + 10))

		s.sendto(SSDP_BROADCAST_MSG.encode('UTF-8'), (SSDP_BROADCAST_ADDR, SSDP_BROADCAST_PORT))

		while True:
			data = None
			try:
				data, _ = s.recvfrom(4096)
			except socket.timeout:
				break

			replies.append(data.decode('UTF-8'))

	devices = []
	for reply in replies:
		device = {}
		lines = reply.split('\r\n')

		if lines[0] != 'HTTP/1.1 200 OK':
			continue
		lines = lines[1:-2]

		for line in lines:
			key, value = line.split(':', 1)
			device[key.strip().upper()] = value.strip()
		devices.append(device)

	return devices


def filter_devices(devices, service):
	return [ device for device in devices if service in device['ST'] ]


def main():
	devs = get_upnp_replies()
	devs = filter_devices(devs, "urn:schemas-upnp-org:service:AVTransport:1")
	print(devs)

if __name__ == '__main__':
	main()