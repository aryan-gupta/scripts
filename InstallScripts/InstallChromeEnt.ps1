
$prgm = "~\Downloads\ChromeEnt_installer.msi"

$downloadLinkx64 = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
$downloadLinkx86 = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise.msi"

if((Get-WmiObject -Class Win32_ComputerSystem).SystemType -like '*x64*') {
	Invoke-WebRequest -URI "$downloadLinkx64" -OutFile $prgm
} else {
	Invoke-WebRequest -URI "$downloadLinkx86" -OutFile $prgm
}

Start-Process -FilePath "msiexec" -ArgumentList "/i /sb /norestart $prgm"