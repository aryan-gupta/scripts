
$featuresOff = @(
	"MediaPlayback"
	"WorkFolders-Client"
	"Microsoft-Windows-HyperV-Guest-Package"
	"Xps-Foundation-Xps-Viewer"
	"Printing-XPSServices-Features"
	"SMB1Protocol"
	"FaxServicesClientPackage"
)

foreach ($feature in $featuresOff) {
	Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName $feature | Out-Null
	(Get-WindowsOptionalFeature -Online -FeatureName $feature | Select-Object -Property FeatureName,State | Format-Table -HideTableHeaders | Out-String).Trim()
}

$featuresOn = @(
	"NetFx3"
	"NetFx4"
	"Microsoft-Windows-Subsystem-Linux"
	
)

foreach ($feature in $featuresOn) {
	Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName $feature
}