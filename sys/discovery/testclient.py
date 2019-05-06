
import socket

DMSG = b"TGED DISCOVERY 1.0\r\nRQ:DS\r\n\r\n"
DIS_IP = '255.255.255.255'
PORT = 4745

def main():
	with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
		sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
		sock.settimeout(10)
		sock.sendto(DMSG, (DIS_IP, PORT))

		data, _ = sock.recvfrom(1024)
		print(data)

if __name__ == "__main__":
	main()