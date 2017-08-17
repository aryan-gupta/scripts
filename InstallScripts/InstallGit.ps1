
$prgm = "~\Downloads\Git_Installer.exe"

$allEXEs = (Invoke-WebRequest -URI "https://git-scm.com/download/win" -UseBasicParsing).links | Where-Object {$_.href -like "*.exe"} | Where-Object {$_.outerHTML -like "*setup*"}

if((Get-WmiObject -Class Win32_ComputerSystem).SystemType -like '*x64*') {
	$link = ($allEXEs | Where-Object {$_.outerHTML -like "*64*"}).href
} else {
	$link = ($allEXEs | Where-Object {$_.outerHTML -like "*32*"}).href
}

Invoke-WebRequest -URI $link -OutFile $prgm

Start-Process -Wait -FilePath "$prgm" -ArgumentList "/NORESTART /SILENT"

#$env:Path += ";$env:programfiles\Git\bin"