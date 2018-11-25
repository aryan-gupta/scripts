#!/bin/env python

import mysql.connector
from socket import gethostname
from subprocess import call
from uriparse import uri_parse

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

def backup_files(loc):
	print(loc)

if __name__ == '__main__':
	# valid from here: https://dev.mysql.com/doc/refman/8.0/en/connecting-using-uri-or-key-value-pairs.html
	db = get_database("mysql://local@higgs.gempi.re/backup")
	loc = get_backup_locations(db, gethostname())
	backup_files(loc)
