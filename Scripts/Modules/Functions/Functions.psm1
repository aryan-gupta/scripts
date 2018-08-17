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