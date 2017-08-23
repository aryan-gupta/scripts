function Create-GitHubRepo {

	Param(
		[parameter(Mandatory=$true, Position=0)] [String] $RepoName,
		[String] $Description,
		[Switch] $Private
	)
	
	$postParamsHash = @{
		name=$RepoName;
		description=$Description;
		private=$(If ($Private) {"true"} Else {"false"}) 
	}
	
	$postParams = $postParamsHash | ConvertTo-Json
	
	# https://stackoverflow.com/questions/27951561/use-invoke-webrequest-with-a-username-and-password-for-basic-authentication-on-t
	$user = 'aryan-gupta'
	$pass = '***REMOVED***'
	$pair = "$($user):$($pass)"
	$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
	$basicAuthValue = "Basic $encodedCreds"
	$Headers = @{
		Authorization = $basicAuthValue
	}

	Invoke-WebRequest -ContentType "application/json" -URI "https://api.github.com/user/repos" -Method POST -Body $postParams -Headers $Headers
	
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
	$FileHeader = 
@'
/* 
 * Copyright (c) 2017 The Gupta Empire - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Written by Aryan Gupta <me@theguptaempire.net>
 * 
 * =============================================================================
 * @author 			Aryan Gupta
 * @project 		
 * @title 			
 * @date			(YYYY-MM-DD)
 * @version			1.0.0
 * @description 	
 * =============================================================================
 */		
'@

	$RootDir = (Resolve-Path '.\').Path
	
	# Main CPP
	$MainText = 
@'
#include "info.h"
int main(int argc, char* argv[]) {
`t
}
'@
	New-Item -Force -Type "File" -Path ($RootDir + '\src') -Name 'main.cpp' -Value ($FileHeader + '`n' + $MainText)
	
	# Main Header
}