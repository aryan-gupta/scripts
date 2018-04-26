Import-Module posh-git

function Global:prompt {
	$location = $PWD.tostring()
	$location = $location.
		replace("C:\Users\Aryan", "@").
		replace("@\Projects", "#")
	Write-VcsStatus
	Write-Host $location -ForegroundColor Blue
	Write-Host "PS>" -NoNewLine
	return " "
}

New-Alias npp "C:\Program Files (x86)\Notepad++\notepad++.exe"
[console]::ForegroundColor = "White"
[console]::BackgroundColor = "Black"
Clear-Host