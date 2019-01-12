function Get-GitStatus {
	git status
}

function New-GitCommit {
	Param(
		[Parameter(Mandatory=$true, Position=0)] [String] $Message,
	)
	
	git commit -m "$Message"
}

