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

# Change working directory to C:\WORKING\
New-Alias op Open-Project

New-Alias nf New-Folder

# Set console colors 
$host.UI.RawUI.ForegroundColor = "white"
$host.UI.RawUI.BackgroundColor = "black"
$host.PrivateData.VerboseForegroundColor = "white"
$host.PrivateData.VerboseBackgroundColor = "black"
$host.PrivateData.WarningForegroundColor = "yellow"
$host.PrivateData.WarningBackgroundColor = "black"
$host.PrivateData.ErrorForegroundColor = "red"
$host.PrivateData.ErrorBackgroundColor = "black"
# Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White
New-Alias npp "C:\Program Files (x86)\Notepad++\notepad++.exe"
# [console]::ForegroundColor = "White"
# [console]::BackgroundColor = "Black"
Clear-Host