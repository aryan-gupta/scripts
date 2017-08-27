
# Remove Temp Directories created by Driver updates
Remove-Item -Path "$env:systemdrive\Intel" -Recurse -Force
Remove-Item -Path "$env:systemdrive\AMD" -Recurse -Force 
Remove-Item -Path "$env:systemdrive\PerfLogs" -Recurse -Force

# Setup Working Driectoy for programming and testing