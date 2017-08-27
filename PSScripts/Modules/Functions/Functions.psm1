function Open-Project {
	# Open a current working Project
	Param(
		[Parameter(Mandatory=$false, Position=0)] [String] $Project # The name of the Project to create
	)

	$ProjectRoot = "C:\WORKING"

	if ($Project -eq $null) { # If no project is given, go to project root directory
		Set-Location $ProjectRoot
		return
	}

	$FullProjectPath = $ProjectRoot + '\' + $Project

	if (Test-Path $FullProjectPath) {
		Set-Location $FullProjectPath
		return
	} else {
		throw [System.Management.Automation.ItemNotFoundException] ("Open-Project : Cannot find project `'$Project`' at location `'$FullProjectPath`' because it does not exit.")
	}
}

function New-Folder {
	# Create a new folder in working directory
	Param(
		[Parameter(Mandatory=$true, Position=0)] [String] $Name # The name of the Folder to create
	)

	New-Item -ItemType Directory -Name $Name
}

function Restart-Powershell {
	# Restart Powershell 
	Powershell.exe "Clear-Host"
}

Export-ModuleMember *-*