$Global:Admin = $false
$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent() 
$Principal = new-object System.Security.Principal.WindowsPrincipal($CurrentUser)
if ($Principal.IsInRole("Administrators")) { $Global:Admin = $true }

function prompt {
	$CommandNumber = (Get-History -Count 1 ).ID + 1
	Write-VcsStatus
	if (Get-GitDirectory -ne "") { Write-Host "`n" -NoNewLine }
	$Path = [String]$ExecutionContext.SessionState.Path.CurrentLocation
	$Path = $Path.Replace('C:\WORKING', '@')
	$Path = $Path.Replace("$ENV:UserProfile", '~')
	$Prompt = [String]$CommandNumber + ' ' + $Path
	if ($Global:Admin) {
		Write-Host $Prompt -ForegroundColor Yellow -NoNewLine	
	} else { 
		Write-Host $Prompt -NoNewLine
	}
	"$('>>>' * ($nestedPromptLevel + 1)) "
}

Import-Module posh-git

# Set alias so edit opens npp
New-Alias npp "C:\Program Files\Notepad++\notepad++.exe"

# Change working directory to C:\WORKING\
New-Alias op Open-Project

New-Alias nf New-Folder

New-Alias make mingw32-make.exe

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