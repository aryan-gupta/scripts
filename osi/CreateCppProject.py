#!/bin/env python

def create_project(fpath):
	if os.path.exists(fpath):
		raise ValueError(f"[E] Could not create directory {fpath}. It may already exist or we dont have the permissions.")
	os.mkdir(fpath)
	os.chdir(fpath)

	DIRS = ["src", "dep", "bin", "res"]

	for dir in DIRS:
		os.mkdir(fpath)
	
	# ===== SOURCE ======
	os.chdir(DIRS[0])
	mcpp = open("main.cpp", mode='w+')
	# mcpp.write()
	



if __name__ == '__main__':
	if len(sys.arg) < 2:
		raise ValueError(f"[E] Not enough arguments: Usage {__file__} <Project_Name>")

	user = getpwuid(s.st_uid).pw_name
	projectSpace = f"/home/{user}/Projects/"
	projectName = sys.arg[1]

	create_project(projectSpace + projectName)