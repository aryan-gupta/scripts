#!/bin/env python

import mysql.connector
from socket import gethostname
from os import stat, path
from pwd import getpwuid
from grp import getgrgid
from sys import argv

host = "local@higgs.gempi.re"
database = "backup"
bhost = "higgs"
broot = "/run/sdcard/"
bloc = bhost + ':' + broot

def create_table_if_null(db, hostname):
	cur = db.cursor()
	cur.execute(f"SHOW TABLES LIKE '{hostname}';")
	result = cur.fetchall()

	if not result:
		print(f"[W] hostname: {hostname} not found, adding table")

		q = f"""CREATE TABLE {hostname} (
			id INT NOT NULL AUTO_INCREMENT,
			src TEXT NOT NULL,
			dest TEXT NOT NULL,
			uname TINYTEXT,
			gname TINYTEXT,
			access SMALLINT,
			PRIMARY KEY(id)
		);"""

		cur.execute(q)

def add_location(db, hostname, src, dest, uname, gname, access):
	# print(f"[I] Adding `{src}' to list of backup locations")
	q = f"""INSERT INTO {hostname} (src, dest, uname, gname, access) VALUES (
		"{src}",
		"{dest}",
		"{uname}",
		"{gname}",
		{access}
	);"""

	print(q)
	return

	cursor = db.cursor()
	cursor.execute(q)
	db.commit()

def get_database():
	try:
		return mysql.connector.connect(
			user = host.split("@")[0],
			host = host.split("@")[1],
			database = database
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

def add(src, dest):
	hostname = gethostname()

	db = get_database()
	create_table_if_null(db, hostname) # Create our table is there is none
	user, group, access = get_file_details(src)
	add_location(db, hostname, src, dest, user, group, access)

if __name__ == '__main__':
	if (len(argv) <= 1): # need at least source
		raise ValueError(f"[E] Usage: python {__file__} <src> [<dest>]")
	
	src = path.abspath(argv[1].replace('\\', '/'))
	if (len(argv) == 2): # if no dest then create the destination using source
		dest = f"{bloc}{gethostname()}{src}"
	else: # make sure dest is up to spec (higgs:/run/sdcard/<src>)
		dest = argv[2].replace('\\', '/')
		if dest.startswith(bloc):
			pass
		else:
			dest = bhost + ':' + path.join(broot, dest)

	# print(src, dest)
	add(src, dest)
