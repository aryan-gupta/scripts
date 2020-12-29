
$prgm = "~\Downloads\VLC_Installer.exe"
$protocol = "http:"
$mainLink = "https://videolan.org/vlc/download-windows.html"

if((Get-WmiObject -Class Win32_ComputerSystem).SystemType -like '*x64*') {
	$link = ((Invoke-WebRequest -URI "https://videolan.org/vlc/download-windows.html" -UseBasicParsing).Links | Where-Object {$_.href -like "*.exe"} | Where-Object {$_.href -like "*64*"}).href
} else {
	$link = ((Invoke-WebRequest -URI "https://videolan.org/vlc/download-windows.html" -UseBasicParsing).Links | Where-Object {$_.href -like "*.exe"} | Where-Object {$_.href -like "*32*"}).href
}

Invoke-WebRequest -URI $($protocol + $link) -OutFile $prgm

Start-Process -Wait -FilePath "$prgm" -ArgumentList "/L=1033 /S"