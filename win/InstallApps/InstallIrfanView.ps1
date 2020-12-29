
$downloadLink = "http://www.irfanview.com/main_download_engl.htm"
$prgm = "~\Downloads\IV_installer.exe"

$link = ((Invoke-WebRequest -URI $downloadLink).links | Where-Object {$_.innerHTML -like "*TUCOWS*"} | Where-Object {$_.innerHTML -notlike "*plugin*"}).href

$link = ((Invoke-WebRequest -URI $link).Links | Where-Object {$_.href -like "*thankyou*"}).href

$link = ((Invoke-WebRequest -URI ("http://www.tucows.com/" + $link)).Links | Where-Object {$_.href -like "*.exe"}).href

Invoke-WebRequest -URI $link -OutFile $prgm

Start-Process -Wait -FilePath "$prgm" -ArgumentList "/silent /group=1 /assoc=1"

<#
	Q: I am an administrator. How can I silently install/uninstall IrfanView?
	A: Usually, you can download the ZIP version of IrfanView and Plugins and deploy the files.
	Self install versions have special start options for silent install (examples, version 4.20):
	1) IrfanView:
		iview420_setup.exe /silent /folder="c:\test folder\irfanview"
		iview420_setup.exe /silent /folder="c:\test folder\irfanview" /desktop=1 /thumbs=1 /group=1 /allusers=0 /assoc=1 /ini="%APPDATA%\irfanview"
		iview420_setup.exe /silent /folder="c:\test folder\irfanview" /ini="c:\temp"

		Options:
		folder:     destination folder; if not indicated: old IrfanView folder is used, if not found, the "Program Files" folder is used
		desktop:  create desktop shortcut; 0 = no, 1 = yes (default: 0)
		thumbs:   create desktop shortcut for thumbnails; 0 = no, 1 = yes (default: 0)
		group:     create group in Start Menu; 0 = no, 1 = yes (default: 0)
		allusers:  desktop/group links are for all users; 0 = current user, 1 = all users
		assoc:     if used, set file associations; 0 = none, 1 = images only, 2 = select all (default: 0)
		assocallusers:  if used, set associations for all users (Windows XP only)
		ini:      if used, set custom INI file folder (system environment variables are allowed)
	2) PlugIns:
		irfanview_plugins_420_setup.exe /silent
		irfanview_plugins_441_setup.exe /silent /folder="c:\program files (x86)\irfanview"
		irfanview_plugins_x64_441_setup.exe /silent /folder="c:\program files\irfanview"
	3) Uninstall:
		iv_uninstall.exe /silent
#>