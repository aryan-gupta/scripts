
$BACKUP_SERVER = '192.168.0.5'
$BACKUP_SHARE  = 'Backups'

$SKIP_DIR = @(
	'Downloads'
	'AppData\Local'
	'AppData\LocalLow'
)

$SOURCE = 'C:\Users\Aryan'
$CREDLOC = 'C:\Users\Aryan\Documents\PowershellCredentials\graviton.ps1'
$DRIVE_LTR = 'B'

$destination = "${DRIVE_LTR}:\$ENV:ComputerName"
$log = "${DRIVE_LTR}:\logs\$(Get-Date -Format FileDate).log"

#echo $destination
#echo $log

. $CREDLOC

Add-Type -AssemblyName System.Windows.Forms

$PopUp = New-Object System.Windows.Forms.NotifyIcon
$Path = Get-Process -Id $PID | Select-Object -ExpandProperty Path
$PopUp.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($Path)

$backup_root = '\\' + $BACKUP_SERVER + '\' + $BACKUP_SHARE
$password = $graviton.Password | ConvertTo-SecureString -asPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($graviton.Username, $password)

#echo $backup_root
 
New-PSDrive -Name $DRIVE_LTR -PSProvider Filesystem -Root $backup_root -Persist -Credential $credential -ErrorAction SilentlyContinue | Out-Null

if (-not (Test-Path -Path 'B:\')) {
	$PopUp.BalloonTipIcon = 'Error'

	$PopUp.BalloonTipTitle = 'Backup Error'
	$PopUp.BalloonTipText = 'Backup could not mount the directory'
	$PopUp.Visible = $true
	$PopUp.ShowBalloonTip(5000)
	
	Exit
}

if (-not (Test-Path $log)) {
	New-Item -Path $log -ItemType File -Force | Out-Null
	Add-Content -Path $log -Value "Backup started $(Get-Date)"
} else {
	$PopUp.BalloonTipIcon = 'Info'

	$PopUp.BalloonTipTitle = 'Backup already done'
	$PopUp.BalloonTipText = 'Backup has already been done today'
	$PopUp.Visible = $true
	$PopUp.ShowBalloonTip(500)
	
	Exit
}

if (-not (Test-Path $destination)) {
	New-Item -Path $destination -ItemType Directory -Force | Out-Null
	Add-Content -Path $log -Value "No folder for backup found, created new backup folder"
}

$PopUp.BalloonTipIcon = 'Info'

$PopUp.BalloonTipText = 'Backup has started, network may be slow'
$PopUp.BalloonTipTitle = 'Backup in progress'
$PopUp.Visible = $true
$PopUp.ShowBalloonTip(500)

$exclude_arg = '/XD '
foreach ($dirs in $SKIP_DIR) {
	$exclude_arg += ('"' + $SOURCE + '\' + $dirs + '" ')
}

# echo $exclude_arg
# Exit

Start-Process robocopy -Wait -NoNewWindow -ArgumentList "$SOURCE", "$destination", '/MIR /W:0 /R:2', $exclude_arg, '/XJ', "/LOG+:`"$log`"", '/UNICODE /NS /NC /NP'

$PopUp.BalloonTipText = 'Backup has finished'
$PopUp.BalloonTipTitle = 'Backup finished'
$PopUp.Visible = $true
$PopUp.ShowBalloonTip(500)

Remove-PSDrive -Name B