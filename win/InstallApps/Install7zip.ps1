
$mainLink = "http://www.7-zip.org/"
$ext = "exe"
$prgm = "~\Downloads\7zip_installer.$ext"
$installDir = "$env:programfiles\7zip"

$allEXEs = (Invoke-WebRequest -URI "$mainLink" -UseBasicParsing).Links | Where-Object {$_.href -like "*.$ext"}

if((Get-WmiObject -Class Win32_ComputerSystem).SystemType -like '*x64*') {
	$link = ($allEXEs | Where-Object {$_.href -like "*x64*"}).href
} else {
	$link = ($allEXEs | Where-Object {$_.href -notlike "*x64*"}).href
}

Invoke-WebRequest -URI $($mainLink + $link) -OutFile $prgm

Start-Process -Wait -FilePath "$prgm" -ArgumentList "/S /DIR=$installDir"
