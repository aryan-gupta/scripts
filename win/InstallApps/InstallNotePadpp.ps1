
$prgm = "~\Downloads\NPP_Installer.exe"
$mainLink = "https://notepad-plus-plus.org/"
$allEXEs = (Invoke-WebRequest -URI "https://notepad-plus-plus.org/download" -UseBasicParsing).Links | Where-Object {$_.href -like "*.exe"}

if((Get-WmiObject -Class Win32_ComputerSystem).SystemType -like '*x64*') {
	$link = ($allEXEs | Where-Object {$_.href -like "*x64*"}).href
} else {
	$link = ($allEXEs | Where-Object {$_.href -notlike "*x64*"}).href
}

Invoke-WebRequest -URI ($mainLink + $link) -OutFile $prgm

Start-Process -Wait -FilePath "$prgm" -ArgumentList "/S"