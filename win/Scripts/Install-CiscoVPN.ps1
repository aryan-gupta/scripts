
$mainLink = "https://vpn.uncc.edu"
$downloadLink = $mainLink + "/+CSCOE+/logon.html"
$prgm = "~\Downloads\CiscoVPN_installer.exe"

$link = ((Invoke-WebRequest -URI $downloadLink).Links | Where-Object {$_.innerText -eq "Windows"}).href

Invoke-WebRequest -URI $($mainLink + $link) -OutFile $prgm

Start-Process -Wait -FilePath "$prgm" -ArgumentList "/i /qb /norestart"