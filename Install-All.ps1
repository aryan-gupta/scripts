
# Copy PS Profile to the correct location
# Copy-Item -Path ".\PSScripts\Microsoft.PowerShell_profile.ps1" -Destination "$profile"

# & ".\PSScripts\Add-RegistryDrive.ps1"
# & ".\PSScripts\Optimize-AppPackages.ps1"
# & ".\PSScripts\Optimize-OptionalFeatures.ps1"
# & ".\PSScripts\Optimize-ScheduledTask.ps1"
# & ".\PSScripts\Optimize-Services.ps1"
# & ".\PSScripts\Optimize-Taskbar.ps1"
# & ".\PSScripts\Restore-CommonDirectories.ps1"

# foreach ($file in $(Get-ChildItem .\RegOpti\*.reg)) {
	# regedit /s $file.name
# }

cmd.exe /C ".\GodMode\GodMode.bat"