
Write-Host "Disabling Services"
$disableServices = @( 
	## Currently Testing ##
	"Windows Error Reporting Service"
	"Windows Image Acquisition"
	"TCP/IP NetBIOS Helper"
	"Secondary Logon"
	"Program Compatibility Assistant Service"

	## Telemetry ##
	"Connected User Experiences and Telemetry"
	"dmwappushsvc"
	"Diagnostic Tracking Service"
	
	## Unused Services ##
	"Bluetooth Support Service" # Bluetooth
	"Downloaded Maps Manager"
	"Data Usage"
	
	## Black Viper ##
	"Auto Time Zone Updater"
	"Microsoft App-V Client"
	"Remote Registry"
	"Routing and Remote Access"
	"Shared PC Account Manager"
	"Smart Card"
	"User Experience Virtualization Service"
	"Application Layer Gateway Service"
	"BranchCache"
	"Client for NFS"
	"Geolocation Services"
	"HV Host Service"
	"Hyper-V Data Exchange Service"
	"Hyper-V Guest Service Interface"
	"Hyper-V Guest Shutdown Service"
	"Hyper-V Heartbeat Service"
	"Hyper-V PowerShell Direct Service"
	"Hyper-V Remote Desktop Virtualization Service"
	"Hyper-V Time Synchronization Service"
	"Hyper-V Volume Shadow Copy Requestor"
	"Infrared monitor service"
	"Internet Connection Sharing (ICS)"
	"Microsoft iSCSI Initiator Service"
	"Microsoft Windows SMS Router Service"
	"Offline Files"
	"Payments and NFC/SE Manager"
	"Phone Service"
	"Remote Procedure Call (RPC) Locator"
	"Retail Demo Service"
	"Smart Card Device Enumeration Service"
	"Smart Card Removal Policy"
	"SNMP Trap"
	"Windows Camera Frame Server"
	"Windows Mobile Hotspot Service"
	"Windows Remote Management (WS-Management)"
	"WWAN AutoConfig"
	"Xbox Live Auth Manager"
	"Xbox Live Game Save"
	"XboxNetApiSvc"
	
	#"IP Helper"
	#"Print Spooler"
	#"Security Center"
	#"Touch Keyboard and Handwriting Panel Service"
	#"Windows Defender Service"
	#"Windows Search"
)

foreach($service in $disableServices) {
	try {
		Get-Service -DisplayName $service -ErrorAction Stop | Set-Service -StartupType Disabled
	
		Get-Service -DisplayName $service -ErrorAction Stop | Select-Object -property name,starttype
	} catch {
		Write-Host "$service not found"
	}
}