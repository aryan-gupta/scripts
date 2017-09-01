# https://stackoverflow.com/questions/24914589/how-to-create-permanent-powershell-aliases

# Set alias so edit opens npp
New-Alias npp "C:\Program Files\Notepad++\notepad++.exe"

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
Clear-Host