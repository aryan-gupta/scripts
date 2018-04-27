
$BACKUP_SERVER = '\\D-Z97-W10'
$BACKUP_SHARE  = 'Backups'

$SOURCE = 'C:\Users\Aryan'

$date = Get-Date -Format FileDate

$backup_root = $BACKUP_SERVER + '\' + $BACKUP_SHARE
New-PSDrive -Name 'B' -PSProvider Filesystem -Root $backup_root -Persist | Out-Null

$destination = "B:\$ENV:ComputerName"
$log = "B:\logs\$date.log"

if (-not (Test-Path $log)) {
	New-Item -Path $log -ItemType File -Force | Out-Null
	Add-Content -Path $log -Value "Backup started $(Get-Date)"
}

if (-not (Test-Path $destination)) {
	New-Item -Path $destination -ItemType Directory -Force | Out-Null
	Add-Content -Path $log -Value "No folder for backup found, created new backup folder"
}

# Add-Type -AssemblyName System.Windows.Forms
# $balloon = New-Object System.Windows.Forms.NotifyIcon 
# $balloon.BalloonTipIcon  = [System.Windows.Forms.ToolTipIcon]::Info
# $balloon.BalloonTipTitle = "Attention  $Env:USERNAME"
# $balloon.BalloonTipText  = 'What do you think of this balloon tip?'
# $balloon.Visible  = $true 
# $balloon.ShowBalloonTip(5000);

# [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
# $objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 
# #$objNotifyIcon.Icon = "C:\Windows\Folder.ico"
# $objNotifyIcon.BalloonTipIcon = "Warning" 
# $objNotifyIcon.BalloonTipText = "Writing a notification." 
# $objNotifyIcon.BalloonTipTitle = "Test Notification"
# $objNotifyIcon.Visible = $True 
# $objNotifyIcon.ShowBalloonTip(5000)

Add-Type -AssemblyName System.Windows.Forms

$PopUp = New-Object System.Windows.Forms.NotifyIcon
$Path = Get-Process -Id $PID | Select-Object -ExpandProperty Path
$PopUp.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($Path)
$PopUp.BalloonTipIcon = 'Info'

$PopUp.BalloonTipText = 'Backup has started, network may be slow'
$PopUp.BalloonTipTitle = 'Backup in progress'
$PopUp.Visible = $true
$PopUp.ShowBalloonTip(500)

robocopy "$SOURCE" "$destination" /MIR /W:0 /R:2 /XJ /XD "*Downloads*" /XD "*AppData*" /LOG+:"$log" /UNICODE /NS /NC /NP

$PopUp.BalloonTipText = 'Backup has finished'
$PopUp.BalloonTipTitle = 'Backup finished'
$PopUp.Visible = $true
$PopUp.ShowBalloonTip(500)

Remove-PSDrive -Name B