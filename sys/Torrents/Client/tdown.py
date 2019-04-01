#!/bin/env python

import paramiko
import os
import requests
from bs4 import BeautifulSoup

def get_server():
	return "higgs.gempi.re", "stick"

def get_connection():
	connection = paramiko.SSHClient()
	connection.load_system_host_keys()

	# Excersize caution when using this command.
	# connection.set_missing_host_key_policy(paramiko.client.AutoAddPolicy)

	host, user = get_server()
	connection.connect(hostname = host, username = user)

	# Excersize caution when using this command.
	# connection.save_host_keys(os.path.expanduser("~/.ssh/known_hosts"))

	return connection

def parse_webpage_for_magnet(url):
	raw_html = requests.get(url)
	soup = BeautifulSoup(raw_html, 'html.parser')
	pass

def get_magnet(url):
	if url.startswith("magnet"):
		return url
	elif url.startswith("http"):
		return None #parse_webpage_for_magnet(url)
	else:
		raise ValueError("Invalid url scheme. Must be magnet or webpage")

if __name__ == '__main__':
	svr = get_connection()
	command = "tdownstart " + get_magnet(sys.argv[1])
	stdin, stdout, stderr = svr.exec_command(command)

	print(stdout.readlines())
