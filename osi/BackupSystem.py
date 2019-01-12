#!/bin/env python

import mysql.connector
from socket import gethostname
from subprocess import call
from uriparse import uri_parse
import os
import subprocess

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
	for lst in result: # convert response into a list of touples
		ret_val.append((lst[0], lst[1]))
	return ret_val

def mount_backup_loc(svr, loc):
	uri = uri_parse(svr) # parse server uri
	mountpt = os.path.join(loc, uri.host.split('.')[0])
	os.makedirs(mountpt, exist_ok=True)
	cmd = f"mount.cifs -v -o user={uri.user},vers=3.0 //{uri.host}{uri.path} {mountpt}"
	process = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)
	output, error = process.communicate()
	if error:
		print(error + ": ")
		print(output)
	return mountpt

def umount_backup_loc(mountpt):
	cmd = f"umount {mountpt}"
	process = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)
	output, error = process.communicate()
	if error:
		print(error + ": ")
		print(output)

def backup_files(loc):
	cmd = f"rsync -avuzb"
	pass
	

def check_sudo():
	if os.getuid() is not 0:
		raise PermissionError("[E] This scripts must be run with admin credentials")

if __name__ == '__main__':
	check_sudo()
	# valid from here: https://dev.mysql.com/doc/refman/8.0/en/connecting-using-uri-or-key-value-pairs.html
	db = get_database("mysql://local@higgs.gempi.re/backup")
	loc = get_backup_locations(db, gethostname())
	mountpt = mount_backup_loc("stick@higgs.gempi.re/storage", "/media")
	backup_files(loc)
	umount_backup_loc(mountpt)
