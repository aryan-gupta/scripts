#!/bin/env python

import mysql.connector
from socket import gethostname
from os import stat, path
from pwd import getpwuid
from grp import getgrgid
from sys import argv

from uriparse import uri_parse

SQL = 'local@higgs.gempi.re/backup'


def backup_table_exists(db, hostname):
	cur = db.cursor()
	cur.execute(f"SHOW TABLES LIKE '{hostname}';")
	result = cur.fetchall()
	return result


def create_backup_table(db, hostname):
	q = f"""CREATE TABLE {hostname} (
		id INT NOT NULL AUTO_INCREMENT,
		type CHAR NOT NULL,
		src TEXT NOT NULL,
		dest TEXT,
		PRIMARY KEY(id)
	);"""
	db.cursor().execute(q)


def add_location(db, hostname, src, dest):
	s, dest, butype = ("Removing", 'NULL', '-') if dest is None else ("Adding", dest, '+')

	print(f"[I] {s} `{src}' to list of backup locations")

	q = f"""INSERT INTO {hostname} (type, src, dest) VALUES (
		"{butype}"
		"{src}",
		"{dest}"
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

# Backups work like this: The SQL server has a db like this
# id (INT)    type (CHAR)       src (TEXT)         dest(TEXT)
# 0             +/-            /home/test/sada        /root/home/test/big/sada
#
# The id is autoincremented, the type is whether the path is an include or exclude
# The src and dest are self explanatory. for excludes, dest is `excluded'
# The dest path always references its path to /root. The /root/ directory stores
# the default backup of the rootfs. If any file must be backed up, it can be stores in
# another folder not in /root/. The backup server appends the dest to the backup
# location path, the client name, and the date. So the final path to the backup
# location for the above directory on the server would be
# /run/sdcard/backups/boson/20190531-2150/root/home/test/big/sada
# {backup_location}/{hostname}/{YYYYMMDD-HHMM}/{backup_type}/{path}

def loc_exists(db, hostname, src, dest):
	q = f"""SELECT src, dest FROM {hostname} WHERE src='{src}' AND dest='{dest}'"""
	cursor = db.cursor()
	cursor.execute(q)
	response = cursor.fetchall()

	return response


def add_backup_location(hostname, src, dest):
	db = get_database(SQL)

	if not backup_table_exists(db, hostname):
		print(f"[W] hostname: {hostname} not found, adding table")
		create_backup_table(db, hostname)

	if not loc_exists(db, hostname, src, dest):
		add_location(db, hostname, src, dest)
	else:
		print("[E] Location already exits")


def main():
	if len(argv) == 4:
		exclude = argv[1] == '-'
		if exclude: raise ValueError("[E] Excluding a backup directory cannot have a dest param")
		src  = argv[2]
		dest = argv[3]
	elif len(argv) == 3:
		if argv[1] == '-' or argv[1] == '+':
			exclude = argv[1] == '-'
			src  = argv[2]
			dest = None
		elif argv[2] == '-' or argv[2] == '+':
			exclude = argv[2] == '-'
			src  = argv[1]
			dest = None
		else:
			exclude = False
			src  = argv[1]
			dest = argv[2]
	elif len(argv) == 2:
		if argv[1] == '-' or argv[1] == '+':
			raise ValueError(f"[E] Usage: python {__file__} [+|-] <src> [<dest>]")
		exclude = False
		dest = None
		src  = argv[1]
	else:
		raise ValueError(f"[E] Usage: python {__file__} [+|-] <src> [<dest>]")

	hostname = gethostname().lower()
	src = path.abspath(path.normpath(path.expanduser(src.replace('\\', '/'))))

	# @todo make sure that we haven't accidentally added +/- to the start of src

	if exclude:
		dest = None
	elif dest is None: # including needs a dest param
		dest = '/root' + src # src is an abs path so it will have the '/'
	else:
		dest = dest.replace('\\', '/')
		if dest[0] != '/':
			raise ValueError(f'[E] dest parameter must be referenced by a root (i.e. start with a `/\' or `\\\')')

	add_backup_location(hostname, src, dest)


if __name__ == '__main__':
	main()
