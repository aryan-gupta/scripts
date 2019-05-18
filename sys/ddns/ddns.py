
import requests
import sys
from time import sleep
from threading import Event
from asyncio import Future
import signal


CRED_FILE = sys.argv[1] if len(sys.argv) >= 2 else 'cred.txt'
WAIT_TIME = 5.0
IP_CHECK_URL = 'https://domains.google.com/checkip'
IP_UPDATE_URL = 'https://domains.google.com/nic/update?hostname={host}'
IP_FILE = '/tmp/ddns_ip.txt'


def get_ip():
	reply = requests.get(IP_CHECK_URL)
	return reply.text.strip()


def update_ip(user, passwd, host):
	url = IP_UPDATE_URL.format(host=host)
	auth = requests.auth.HTTPBasicAuth(user, passwd)
	headers = {'User-agent': f'Python{sys.version.split()[0]}'}
	reply = requests.get(url, auth=auth, headers=headers)
	return reply.text.strip()


def send_error_ctrl(error):
	pass


def send_ip_ctrl(ip):
	pass


def write_ip(ip, filename):
	with open(filename, 'w') as file:
		file.write(ip)


def handle_reply(info, ip):
	if 'nochg' == info:
		pass
	elif 'good' == info:
		send_ip_ctrl(ip)
	elif 'nohost' == info:
		send_error_ctrl(info)
	elif 'badauth' == info:
		send_error_ctrl(info)
	elif 'notfqdn' == info:
		send_error_ctrl(info)
	elif 'abuse' == info:
		send_error_ctrl(info)
	elif 'badagent' == info:
		send_error_ctrl(info)
	elif '911' == info:
		send_error_ctrl(info)


def main():
	ip = None
	kill = Event()

	def sig_handler(sig, frame):
		nonlocal kill
		kill.set()
		sys.exit(0)
	signal.signal(signal.SIGINT, sig_handler)

	cred = {}
	with open(CRED_FILE, 'r') as file:
		for line in file.readlines():
			key, value = line.split('::', 1)
			cred[key.strip()] = value.strip()

	while not kill.wait(5.0):
		if get_ip() != ip:
			reply = update_ip(cred['USER'], cred['PASS'], cred['HOST']).split(' ')
			info, ip = reply[0].strip(), reply[1].strip()
			handle_reply(info, ip)
			write_ip(ip, IP_FILE)



if __name__ == '__main__':
	main()