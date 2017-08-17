
$features = @(
	"MediaPlayback"
	"WorkFolders-Client"
	"Microsoft-Windows-HyperV-Guest-Package"
	"Xps-Foundation-Xps-Viewer"
	"Printing-XPSServices-Features"
	"SMB1Protocol"
	"FaxServicesClientPackage"
)

foreach ($feature in $features) {
	Disable-WindowsOptionalFeature -Online -FeatureName -NoRestart $feature | Out-Null
	(Get-WindowsOptionalFeature -online -FeatureName NETfx3 | Select-Object -Property FeatureName,State | Format-Table -HideTableHeaders | Out-String).Trim()
}
