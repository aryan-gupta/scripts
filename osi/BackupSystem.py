#!/bin/env python

import mysql.connector
from socket import gethostname
from uriparse import uri_parse
import os
import subprocess
from datetime import datetime
import warnings
warnings.filterwarnings(action='ignore',module='.*paramiko.*')
import paramiko

SQL = "mysql://local@higgs.gempi.re/backup"
BU_SVR = 'ssh://stick@higgs.gempi.re'
BU_ROOT = '/run/sdcard/backups'
BU_FFMT = '%Y%m%d-%H%M'

def get_ssh_connection(svr):
	client = paramiko.SSHClient()
	client.load_system_host_keys()
	ssh_config = paramiko.SSHConfig()

	user_config_file = os.path.expanduser("~/.ssh/config")
	if os.path.exists(user_config_file):
		with open(user_config_file) as file:
			ssh_config.parse(file)

	server = uri_parse(svr)
	if server.scheme != 'ssh': raise ValueError('[E] Not a link to a ssh server')

	config = ssh_config.lookup(server)

	client.set_missing_host_key_policy(paramiko.client.AutoAddPolicy)

	client.connect(
		hostname=config['hostname'] if 'user' in config.keys() else 'higgs.gempi.re',
		username=config['user'] if 'user' in config.keys() else 'stick',
		port=config['port'] if 'port' in config.keys() else 22,
	)

	return client

def get_database(svr):
	uri = uri_parse(svr)
	if not uri.scheme == "mysql":
		raise ValueError("[E] Wrong connection scheme")

	try:
		return mysql.connector.connect(
			user = uri.user,
			host = uri.host,
			database = uri.path[1:]
		)
	except mysql.connector.errors.ProgrammingError:
		print("[E] Error on connecting to database")
		raise SystemExit()

def get_backup_locations(db, hostname):
	q = f"SELECT src, dest FROM {hostname};"
	cur = db.cursor()
	cur.execute(q)
	result = cur.fetchall()
	ret_val = []
	for lst in result: # convert response into a list of tuples
		ret_val.append((lst[0], lst[1]))
	return ret_val

def run_copy(client, src, dest):
	cmd = f"cp -al {src} {dest}"
	stdin, stdout, stderr = client.exec_command(cmd)
	print(stdout.read())
	print(stderr.read())
	return stdin, stdout, stderr

def create_folder(client, src, dest):
	if os.path.isdir(src):
		dir_name = dest
	else:
		dir_name = os.path.dirname(dest)
	cmd = f"mkdir -p {dir_name}"
	client.exec_command(cmd)

def run_rsync(src, dest, excludes):
	if os.path.isdir(src): src = src + '/'

	cmd = ['rsync', '-vaiS', '--delay-updates', '--delete', 'src', 'dest', f'--log-file=/var/test.txt']
	for exc in excludes:
		cmd.append(f'--exclude={exc}')
	cmd[4] = src
	cmd[5] = dest

	subprocess.run(cmd, capture_output=True)

def get_last_backup(client, root):
	cmd = f"ls {root}"
	_, stdout, _ = client.exec_command(cmd)
	folders = stdout.read().decode().strip().split()
	if len(folders) >= 1 and folders[0] != '':
		last = folders[len(folders) - 1]
		return datetime.strptime(last, BU_FFMT)
	else:
		return None

def backup_files(locs): # locs are a 3-tuple of src, dest, and excludes
	root = os.path.join(BU_ROOT, gethostname())
	client = get_ssh_connection(BU_SVR)
	last_bu = get_last_backup(client, root)
	date = datetime.strftime(datetime.now(), BU_FFMT)

	if last_bu is None:
		for loc in locs:
			dest = os.path.join(root, date, loc[1][1:])
			create_folder(client, loc[0], dest)
			run_rsync(loc[0], dest, [])
	else:
		last = os.path.join(root, datetime.strftime(last_bu, BU_FFMT))
		new = os.path.join(root, date)
		run_copy(client, last, new)
		for loc in locs:
			run_rsync(loc[0], os.path.join(root, date, loc[1][1:]), [])

def main():
	db = get_database(SQL)
	loc = get_backup_locations(db, gethostname())
	backup_files(loc)

if __name__ == '__main__':
	main()

## Create links
# cp -al dest/initial dest/first

## Sync
# rsync -vaiS --delay-updates --delete src/ dest/first