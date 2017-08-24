function Create-GitHubRepo {

	Param(
		[parameter(Mandatory=$true, Position=0)] [String] $RepoName,
		[String] $Description,
		[Switch] $Private
	)
	
	$PostParamsHash = @{
		name=$RepoName;
		description=$Description;
		private=$(If ($Private) {"true"} Else {"false"}) 
	}
	
	$PostParams = $PostParamsHash | ConvertTo-Json
	
	# https://stackoverflow.com/questions/27951561/use-invoke-webrequest-with-a-username-and-password-for-basic-authentication-on-t
	$user = 'aryan-gupta'
	$pass = '***REMOVED***'
	$pair = "$($user):$($pass)"
	$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
	$basicAuthValue = "Basic $encodedCreds"
	$Headers = @{
		Authorization = $basicAuthValue
	}

	Invoke-WebRequest -ContentType "application/json" -URI "https://api.github.com/user/repos" -Method POST -Body $PostParams -Headers $Headers
	
}

function Setup-GitSCM {
	Param(
		[parameter(Mandatory=$true, Position=0)] [String] $RepoName
	)

	# Sample: https://github.com/aryan-gupta/WINSetup.git
	$GitLink = ('https://github.com/aryan-gupta/' + $RepoName + '.git')
	git init
	git remote add origin $GitLink
}

function Create-InitialCommit {
	git add *
	git commit -m "Initial Commit"
}

function Create-Folders {
	$RootDir = (Resolve-Path ".\").Path
	New-Item -Type "Directory" -Path $RootDir -Name 'src' -Force # cpp and h files
	New-Item -Type "Directory" -Path $RootDir -Name 'bin' -Force # final EXE and dlls
	New-Item -Type "Directory" -Path $RootDir -Name 'build' -Force # obj directory
	# New-Item -Type "Directory" -Path $RootDir -Name 'ext' -Force
	New-Item -Type "Directory" -Path $RootDir -Name 'test' -Force # tests
	New-Item -Type "Directory" -Path $RootDir -Name 'doc' -Force # documentation
}

function Create-Files {
	
	Param(
		[parameter(Mandatory=$true,Position=0)] [String] $ProjName
	)
	
	$RootDir = (Resolve-Path '.\').Path
	
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
	
	# Main CPP
	$MainText = 
@'
#include "info.h"

#include <iostream>

#include "main.h"

int main(int argc, char* argv[]) {
`tPRINT_LEGAL_TERR;
`t
`treturn 0;
}
'@
	New-Item -Force -Type "File" -Path ($RootDir + '\src') -Name 'main.cpp' -Value ($FileHeader + '`n' + $MainText)
	
	# Main Header
	$MainHText = 
@'
#pragma once

int main(int argc, char* argv[]);
'@
	New-Item -Force -Type "File" -Path ($RootDir + '\src') -Name 'main.cpp' -Value ($FileHeader + '`n' + $MainHText)
	
	# Readme
	$ReadMe = 
@"
<p align="center">
  <img src="res/icon.png" alt="Drawing" width="200"/>
</p>
`n`n`n
# $ProjName #`n`n`n`n
## Prerequisites ##`n`n`n`n
## Installation ##
Please use `<make> ./bin/make.exe` to compile the program when debugging. <br>
You can also use `<make> install` to compile the final (optimized) program.
`n`n`n
## Usage ##
See Installation. If you used `<make> ./bin/make.exe` to compile, the program is
in the `bin` directory. you can also use `<make> install`.
`n`n`n
## Built with ##
#### SDL 2.0 ####
* https://www.libsdl.org/  
* https://www.libsdl.org/download-2.0.php
`n`n`n
## Contributing ##
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D
`n`n`n
## Authors ##
* **Aryan Gupta**
`n`n`n
## License ##
Copyright (c) 2017 The Gupta Empire - All Rights Reserved
See LICENSE.md File for more info. 
"@
	New-Item -Force -Type file -Path $RootDir -Name 'README.md' -Value $ReadMe
	# Licence
	
	# .gitignore
	
	# Resource script
	
	# makefile
	
	# info Header
	
	# .gitkeep
	
}


# Main ====

Param(
	[parameter(Mandatory=$true, Position=0)] [String] $ProjName,
	[String] $Description,
	[Switch] $Private
)

if ($Private) {
	Create-GitHubRepo -RepoName $ProjName -Description $Description -Private
} elseif {
	Create-GitHubRepo -RepoName $ProjName -Description $Description
}

Setup-GitSCM $ProjName
Create-Folders
Create-Files
Create-InitialCommit

