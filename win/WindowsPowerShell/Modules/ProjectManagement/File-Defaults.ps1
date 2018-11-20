
# Main Header for c++ files
$FileHeader = 
@'
/**    
***    Copyright (c) 2017 The Gupta Empire - All Rights Reserved
***    Unauthorized copying of this file, via any medium is strictly prohibited
***    Proprietary and confidential
***    
***    Written by Aryan Gupta <me@theguptaempire.net>
***    
***=============================================================================
***    @author          Aryan Gupta
***    @project         
***    @title           main
***    @date            (YYYY-MM-DD)
***    @version         
***    @brief           Contains program entry point and misc. functions
***=============================================================================
**/
'@

# Text for main.cpp file
$MainText = 
@'
#include "info.h"

#include <iostream>

#include "main.h"

int main(int argc, char* argv[]) {
	PRINT_LEGAL_TERR;
	
	return 0;
}
'@

# Text for main.h file
$MainHText = 
@'

#pragma once

int main(int argc, char* argv[]);
'@

$GitKeepText = 
@'
This is a placeholder file used to add an empty folder to a git repository
This file is safe to ignore and will not interfere with the code
'@

$GitIgnoreText = 
@'
# Compiled Object files
*.slo
*.lo
*.o
*.obj

# Precompiled Headers
*.gch
*.pch

# Compiled Dynamic libraries
*.so
*.dylib
*.dll

# Fortran module files
*.mod

# Compiled Static libraries
*.lai
*.la
*.a
*.lib

# Executables
*.exe
*.out
*.app

'@

# text for info.h file
$InfoHText = 
@'

#pragma once

// =================  PROGRAM  INFO  =================
#define R_PVERSION	       /* Version Number */ "1.0.0"
 
#define R_PROJNAME		     /* Project Name */ "Template"
#define R_PRGMNAME		     /* Program Name */ "Template"
#define R_DESCRIPTION	      /* Description */ "This is a Template"

#define R_AUTHOR		     	   /* Author */ "Aryan Gupta"
#define R_COMPANY		          /* Company */ "The Gupta Empire"
#define R_COPYRIGHT				/* Copyright */ "Copyright (c) The Gupta Empire - All Rights Reserved"
#define R_ORGFILENAME  /* Original File Name */ "main.exe" 
#define R_FVERSION		     /* File Version */ "1.0.0"
#define R_COMMENTS		         /* Comments */ "The Gupta Empire - http://theguptaempire.net"
#define R_LEGALTRDMKS	  /* Legal Tademarks */ "..."
#define R_PRIVATEBUILD	    /* Private Build */ "\0" 
#define R_SPECIALBUILD	    /* Special Build */ "\0"

#define R_MAINICON				/* Main Icon */ "./res/icon.ico" 

#define PRINT_LEGAL_TERR std::cout << '\n' << R_PROJNAME << " v" << R_PVERSION << " by " << R_AUTHOR << '\n' << R_COPYRIGHT << '\n' << R_COMMENTS << "\n\n\n" // Legal and Informational

// =================  MACROS  =================
// DEBUGGING
#define LOGL(msg) if(DEBUG) {std::cout << msg << std::endl;}
#define LOG(msg) if(DEBUG) {std::cout << msg;}

// CLEAR TERMINAL 
#if defined(__linux__) || defined(linux) || defined(__linux)
	#define CLEAR_TERMINAL if(DEBUG){system("clear");}
#elif defined(_WIN32)
	#define CLEAR_TERMINAL if(DEBUG){system("cls");}
#endif
'@

$MakeFileText = 
@'
#    
#    Copyright (c) 2017 The Gupta Empire - All Rights Reserved
#    Unauthorized copying of this file, via any medium is strictly prohibited
#    Proprietary and confidential
#    
#    Written by Aryan Gupta <me@theguptaempire.net>
#    
#===============================================================================
#    @author          Aryan Gupta
#    @project         
#    @title           Makefile      
#    @brief           This is the Makefile for this project
#===============================================================================
.DEFAULT_GOAL := install
#==========================  CONST MACROS  ====================================
CC = g++
RES = windres
BIN = bin

#============================  SDL LIBS  ======================================
L_SDLC = -IC:/Compiler/SDL/include/SDL2  
L_SDLL = $(GRAPHICS) -LC:/Compiler/SDL/lib -lmingw32 -lSDL2main -lSDL2 -lSDL2_mixer -lSDL2_ttf -lSDL2_image

#==============================  MACROS  ======================================
CFLAGS = $(DEBUG) -Wall -std=c++11 -c
LFLAGS = $(DEBUG) -Wall
OBJS = $(BIN)/res.o $(BIN)/main.o

#============================ RECEPIES ========================================

$(BIN)/main.o: main.cpp main.h
	$(CC) main.cpp -o $@ $(CFLAGS) $(L_SDLC)

$(BIN)/%.o: %.cpp
	$(CC) $^ -o $@ $(CFLAGS) $(L_SDLC)

$(BIN)/res.o: res.rc info.h
	$(RES) res.rc  $@
	
# Link
$(BINDIR)\main.exe: DEBUG = -g -DDEBUG
$(BINDIR)\main.exe: $(OBJS)
	$(CC) $^ -o $(BIN)/main.exe $(LFLAGS) $(L_SDLL)

#============================= PHONY RECEPIES =================================
.PHONY: all
all: clean $(OBJS)
	$(CC) $(OBJS) $(LFLAGS) $(L_SDLL) -o $(BIN)/final.exe

.PHONY: install
install: DEBUG = -O2 -s -DNDEBUG
install: GRAPHICS = -w -Wl,-subsystem,windows
install: all Runner.cpp $(BIN)/res.o
	$(CC) Runner.cpp $(BIN)/res.o -static -o Play.exe
	Play.exe
	
.PHONY: clean
clean:
	del $(BIN)\*.o
	del $(BIN)\*.exe
'@


$ReadMeText = 
@'
<p align="center">
  <img src="res/icon.png" alt="Drawing" width="200"/>
</p>



#  #




## Prerequisites ##
Make sure you have the SDL libs installed. Please modify the Makefile in the root
folder to reflect the directory you have SDL installed. 



## Installation ##
Please use `<make> ./bin/make.exe` to compile the program when debugging. <br>
You can also use `<make> install` to compile the final (optimized) program.



## Usage ##
See Installation. If you used `<make> ./bin/make.exe` to compile, the program is
in the `bin` directory. If you used `<make> install`, then the game should automatically
run.



## Built with ##
#### SDL 2.0 ####
* https://www.libsdl.org/  
* https://www.libsdl.org/download-2.0.php



## Contributing ##
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D



## Authors ##
* **Aryan Gupta**



## License ##
Copyright (c) 2017 The Gupta Empire - All Rights Reserved
See LICENSE.md File for more info. 

'@

$ResourceFile = 
@'
/**    
***    Copyright (c) 2017 The Gupta Empire - All Rights Reserved
***    Unauthorized copying of this file, via any medium is strictly prohibited
***    Proprietary and confidential
***    
***    Written by Aryan Gupta <me@theguptaempire.net>
***    
***=============================================================================
***    Please see other files for detailed information. This file is a stagnant
***    file and will not change. Values contained in this file will be replaced
***    during compile time with the proper values.   
***=============================================================================
**/
 
#include "info.h"

MAIN ICON R_MAINICON

1 VERSIONINFO
FILEVERSION     1,0,0,0
PRODUCTVERSION  1,0,0,0
BEGIN
	BLOCK "StringFileInfo"
	BEGIN
		BLOCK "080904E4"
		BEGIN
			VALUE "ProductName", 		R_PROJNAME
			VALUE "InternalName",		R_PRGMNAME
			VALUE "ProductVersion",		R_PVERSION
			VALUE "CompanyName",		R_COMPANY
			VALUE "FileDescription",	R_DESCRIPTION
			VALUE "LegalCopyright",		R_COPYRIGHT
			VALUE "OriginalFilename",	R_ORGFILENAME
			VALUE "FileVersion",		R_FVERSION
			VALUE "Comments",			R_COMMENTS
			VALUE "LegalTrademarks",	R_LEGALTRDMKS
			VALUE "PrivateBuild",		R_PRIVATEBUILD
			VALUE "SpecialBuild",		R_SPECIALBUILD
		END
	END

	BLOCK "VarFileInfo"
	BEGIN
		VALUE "Translation", 0x809, 1252
	END
END

'@