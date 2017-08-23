
Write-Host "Add Adware support for Windows Defender"

$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine"
$name = "MpEnablePus"
$type = "DWORD"
$val  = "1"

New-Item -Path $path -Force | Out-Null
New-ItemProperty -Path $path -Name $name -Value $val -PropertyType $type -Force | Out-Null