#!/bin/env python

import struct
import socket
import os
import sys

def send_wol_packet(ip, mac, port = 9):
    if len(mac) == 12: # match straight mac addresses
        pass
    elif len(mac) == 12 + 5: # match mac addr seperated by ' ', ':', or other seperator
        sep = mac[2]
        mac = mac.replace(sep, '')
    else:
        raise ValueError("[E] Unsupported MAC address format: " + mac);
    
    # The anatomy of a magic packet is 6 bytes of 0xFF then the mac address 16 times
    packet = ("FF" * 6) + (mac * 16)
    
    # Convert hex string to Binary packet
    packet = bytes.fromhex(packet)
    
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
    sock.sendto(packet, (ip, port))
    sock.close()
    
def load_config(host, filename):
    filename = filename + "/known_mac.txt"
    cfile = open(filename, "r")
    
    for line in cfile:
        parts = line.split()
        if parts[0] == host:
            return parts[1]
        
    
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("[E] Not enough arguments.")
        print("[I] Usage: " + __file__ + " <host>")
    host = sys.argv[1]
    mac = load_config(host, os.path.dirname(os.path.abspath(__file__)))
    ip  = socket.gethostbyname(host)
    send_wol_packet(ip, mac)
