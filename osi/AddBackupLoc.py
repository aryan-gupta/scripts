#!/bin/env python

import mysql.connector
from socket import gethostname
from os import stat, path
from pwd import getpwuid
from grp import getgrgid
from sys import argv

from uriparse import uri_parse

SQL = 'local@higgs.gempi.re/backup'
BUSVR = 'sftp://higgs.gempi.re'
BULOC = '/run/sdcard/backup'


def backup_table_exists(db, hostname):
	cur = db.cursor()
	cur.execute(f"SHOW TABLES LIKE '{hostname}';")
	result = cur.fetchall()
	return result


def create_backup_table(db, hostname):
	# If uname and gname is empty, access is 512, and dest is exclude then it is an exclude directory

	q = f"""CREATE TABLE {hostname} (
		id INT NOT NULL AUTO_INCREMENT,
		src TEXT NOT NULL,
		dest TEXT NOT NULL,
		uname TINYTEXT,
		gname TINYTEXT,
		access SMALLINT,
		PRIMARY KEY(id)
	);"""
	db.cursor().execute(q)


def add_location(db, hostname, src, dest, uname, gname, access):
	s = "Adding" if access is 512 else "Removing"
	print(f"[I] {s} `{src}' to list of backup locations")
	q = f"""INSERT INTO {hostname} (src, dest, uname, gname, access) VALUES (
		"{src}",
		"{dest}",
		"{uname}",
		"{gname}",
		{access}
	);"""

	db.cursor().execute(q)
	db.commit()


def get_database(uri):
	svr = uri_parse(uri)
	try:
		return mysql.connector.connect(
			user = svr.user,
			host = svr.host,
			database = svr.path[1:] # strip the leading '/'
		)
	except mysql.connector.errors.ProgrammingError:
		print("[E] Error on connecting to database")


def get_file_details(filename):
	s = stat(filename)
	return (
		getpwuid(s.st_uid).pw_name,
		getgrgid(s.st_gid).gr_name,
		int(s.st_mode & 0o777)
	)


def loc_exists(db, hostname, src, dest):
	q = f"""SELECT src, dest FROM {hostname} WHERE src='{src}' AND dest='{dest}'"""
	cursor = db.cursor()
	cursor.execute(q)
	response = cursor.fetchall()

	return response


def add_backup_location(exclude, src, dest, hostname):
	db = get_database(SQL)

	if not backup_table_exists(db, hostname):
		print(f"[W] hostname: {hostname} not found, adding table")
		create_backup_table(db, hostname)

	if not loc_exists(db, hostname, src, dest):
		if exclude:
			user, group, access = '', '', 512
			add_location(db, hostname, src, dest, user, group, access)
		else:
			user, group, access = get_file_details(src)
			add_location(db, hostname, src, dest, user, group, access)
	else:
		print("[E] Location already exits")


def main():
	if len(argv) == 4:
		sub = argv[1] == '-'
		if sub: raise ValueError("[E] Removeing a backup directory cannot have a dest param")
		src  = argv[2]
		dest = argv[3]
	elif len(argv) == 3:
		if argv[1] == '-' or argv[1] == '+':
			sub = argv[1] == '-'
			src  = argv[2]
			dest = None
		elif argv[2] == '-' or argv[2] == '+':
			sub = argv[2] == '-'
			src  = argv[1]
			dest = None
		else:
			sub = False
			src  = argv[1]
			dest = argv[2]
	elif len(argv) == 2:
		if argv[1] == '-' or argv[1] == '+':
			raise ValueError(f"[E] Usage: python {__file__} [+|-] <src> [<dest>]")
		sub = False
		dest = None
		src  = argv[1]
	else:
		raise ValueError(f"[E] Usage: python {__file__} [+|-] <src> [<dest>]")

	hostname = gethostname().lower()
	src = path.abspath(path.normpath(path.expanduser(src.replace('\\', '/'))))

	# @todo make sure that we haven't accidentally added +/- to the start of src

	if sub:
		dest = 'exclude'
	elif dest is None:
		dest = BUSVR + path.join(BULOC, f"{hostname}{src}")
	else:
		base = dest.replace('\\', '/')
		if base[0] == '/':
			dest = BUSVR + base
		else:
			dest = BUSVR + path.join(BULOC, base)

	add_backup_location(sub, src, dest, hostname)


if __name__ == '__main__':
	main()
