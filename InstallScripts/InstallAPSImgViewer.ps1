
$prgm = "~\Downloads\APSImgViewer.exe"
$link = "https://download.apowersoft.com/down.php?softid=photoviewer"

Invoke-WebRequest -URI $link -OutFile "$prgm"

Start-Process -Wait -FilePath "$prgm" -ArgumentList "/SILENT /NORESTART"