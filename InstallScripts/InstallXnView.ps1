

$prgm = "~\Downloads\XNView_installer.exe"
$link = "http://download.xnview.com/XnView-win-small.exe"

Invoke-WebRequest -URI $link -OutFile "$prgm"

Start-Process -Wait -FilePath "$prgm" -ArgumentList "/SILENT /NORESTART"