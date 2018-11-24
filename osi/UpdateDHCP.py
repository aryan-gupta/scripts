#!/bin/env python

import mysql.connector

host = "local@higgs.gempi.re"
database = "dhcp"
file = "/var/dhcpd/static.conf"


db = mysql.connector.connect(
	user = host.split("@")[0],
	host = host.split("@")[1],
	database = database
)

mycursor = db.cursor()
mycursor.execute("SELECT * FROM static")
myresult = mycursor.fetchall()

f = open(file, "w")

for x in myresult:
	f.write(f"host {x[0]} {{\n")
	f.write(f"    hardware ethernet {x[1]};\n")
	f.write(f"    fixed-address {x[2]};\n")
	f.write(f"}}\n")